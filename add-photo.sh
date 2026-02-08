#!/bin/bash
# add-photo.sh — Add a photo to the gallery with one command
# Usage:
#   ./add-photo.sh <image-path> [caption] [category]
#   ./add-photo.sh <image-path>              (interactive mode)
#   ./add-photo.sh                           (picks from gallery-inbox/)
#
# Examples:
#   ./add-photo.sh ~/Downloads/IMG_1234.HEIC "Morning chai with mountain view" india
#   ./add-photo.sh ~/Downloads/photo.jpg
#   ./add-photo.sh                           # processes all files in gallery-inbox/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GALLERY_DIR="$SCRIPT_DIR/content/gallery"
INDEX_FILE="$GALLERY_DIR/_index.md"
INBOX_DIR="$SCRIPT_DIR/gallery-inbox"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the next available number
get_next_number() {
  local max=0
  for f in "$GALLERY_DIR"/*.jpg "$GALLERY_DIR"/*.jpeg "$GALLERY_DIR"/*.png "$GALLERY_DIR"/*.webp; do
    [ -f "$f" ] || continue
    num=$(basename "$f" | grep -oE '^[0-9]+' || echo "0")
    if [ "$num" -gt "$max" ] 2>/dev/null; then
      max=$num
    fi
  done
  echo $((max + 1))
}

# Convert caption to slug for filename
slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | sed 's/  */ /g' | sed 's/ /-/g' | cut -c1-50 | sed 's/-$//'
}

# Process a single image
process_image() {
  local input_file="$1"
  local caption="$2"
  local category="$3"

  if [ ! -f "$input_file" ]; then
    echo "Error: File not found: $input_file"
    return 1
  fi

  # Get file extension (lowercase)
  local ext=$(echo "${input_file##*.}" | tr '[:upper:]' '[:lower:]')

  # Interactive prompts if caption/category not provided
  if [ -z "$caption" ]; then
    echo -e "${CYAN}Caption for $(basename "$input_file"):${NC}"
    read -r caption
    if [ -z "$caption" ]; then
      echo "Error: Caption is required"
      return 1
    fi
  fi

  if [ -z "$category" ]; then
    echo -e "${CYAN}Category (e.g., tokyo, sf, india, personal, food, misc):${NC}"
    read -r category
    if [ -z "$category" ]; then
      category="misc"
      echo -e "${YELLOW}Defaulting to 'misc'${NC}"
    fi
  fi

  # Get next number
  local num=$(get_next_number)
  local num_padded=$(printf "%02d" "$num")

  # Generate filename
  local slug=$(slugify "$caption")
  local output_name="${num_padded}-${category}-${slug}.jpg"
  local output_path="$GALLERY_DIR/$output_name"

  # Convert/copy the image
  if [ "$ext" = "heic" ] || [ "$ext" = "heif" ]; then
    echo -e "  Converting HEIC → JPG..."
    sips -s format jpeg -s formatOptions 85 "$input_file" --out "$output_path" >/dev/null 2>&1
    echo -e "  ${GREEN}✓ Converted HEIC → JPG${NC}"
  elif [ "$ext" = "png" ]; then
    echo -e "  Converting PNG → JPG..."
    sips -s format jpeg -s formatOptions 85 "$input_file" --out "$output_path" >/dev/null 2>&1
    echo -e "  ${GREEN}✓ Converted PNG → JPG${NC}"
  elif [ "$ext" = "jpg" ] || [ "$ext" = "jpeg" ]; then
    cp "$input_file" "$output_path"
    echo -e "  ${GREEN}✓ Copied JPG${NC}"
  elif [ "$ext" = "webp" ]; then
    echo -e "  Converting WebP → JPG..."
    sips -s format jpeg -s formatOptions 85 "$input_file" --out "$output_path" >/dev/null 2>&1
    echo -e "  ${GREEN}✓ Converted WebP → JPG${NC}"
  else
    echo "Error: Unsupported format: $ext (supported: heic, heif, jpg, jpeg, png, webp)"
    return 1
  fi

  # Resize if image is too large (max 3000px wide)
  local width=$(sips -g pixelWidth "$output_path" | tail -1 | awk '{print $2}')
  if [ "$width" -gt 3000 ] 2>/dev/null; then
    echo -e "  Resizing from ${width}px wide → 3000px..."
    sips --resampleWidth 3000 "$output_path" >/dev/null 2>&1
    echo -e "  ${GREEN}✓ Resized${NC}"
  fi

  # Append to _index.md (before the closing ---)
  # Remove the trailing --- and add the new entry, then add --- back
  local escaped_caption=$(echo "$caption" | sed 's/"/\\"/g')

  # Use sed to insert before the last ---
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed
    sed -i '' -e '$ s/^---$//' "$INDEX_FILE"
  else
    # Linux sed
    sed -i -e '$ s/^---$//' "$INDEX_FILE"
  fi

  # Append the new entry and closing ---
  cat >> "$INDEX_FILE" << EOF
  - file: $output_name
    caption: "$escaped_caption"
---
EOF

  echo -e "  ${GREEN}✓ Created: content/gallery/$output_name${NC}"
  echo -e "  ${GREEN}✓ Updated _index.md with caption${NC}"
}

# ─────────────────────────────────────────────
# Main logic
# ─────────────────────────────────────────────

echo ""

if [ $# -ge 1 ] && [ -f "$1" ]; then
  # File provided as argument
  process_image "$1" "$2" "$3"
  echo ""
  echo -e "${GREEN}Done! Ready to commit.${NC}"

elif [ $# -eq 0 ]; then
  # No arguments — process gallery-inbox/
  if [ ! -d "$INBOX_DIR" ]; then
    mkdir -p "$INBOX_DIR"
    echo "Created gallery-inbox/ folder."
    echo "AirDrop your photos there, then run this script again."
    exit 0
  fi

  # Find all image files in inbox
  files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find "$INBOX_DIR" -maxdepth 1 -type f \( -iname "*.heic" -o -iname "*.heif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 2>/dev/null)

  if [ ${#files[@]} -eq 0 ]; then
    echo "No images found in gallery-inbox/"
    echo "AirDrop your photos to: $INBOX_DIR"
    exit 0
  fi

  echo -e "${CYAN}Found ${#files[@]} image(s) in gallery-inbox/${NC}"
  echo ""

  for f in "${files[@]}"; do
    echo -e "${YELLOW}Processing: $(basename "$f")${NC}"
    process_image "$f" "" ""
    echo ""
  done

  # Ask to clean up inbox
  echo -e "${CYAN}Delete processed files from gallery-inbox? (y/n):${NC}"
  read -r cleanup
  if [ "$cleanup" = "y" ] || [ "$cleanup" = "Y" ]; then
    for f in "${files[@]}"; do
      rm "$f"
    done
    echo -e "${GREEN}✓ Cleaned up gallery-inbox/${NC}"
  fi

  echo ""
  echo -e "${GREEN}Done! Ready to commit.${NC}"

else
  echo "Usage:"
  echo "  ./add-photo.sh <image-path> [caption] [category]"
  echo "  ./add-photo.sh                (process gallery-inbox/)"
  echo ""
  echo "Examples:"
  echo "  ./add-photo.sh ~/Downloads/IMG_1234.HEIC \"Morning view\" india"
  echo "  ./add-photo.sh ~/Downloads/photo.jpg"
  echo "  ./add-photo.sh"
  exit 1
fi
