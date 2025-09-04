---
title: "More Than Just Buy Now"
date: 2025-09-05T00:54:04+05:30
draft: false
categories: ["Research"]
---

## Payment is a black-box

Hey there!  

Have you ever clicked "Pay Now" on an online shopping cart and wondered at how seamless it all felt? I mean, in theory, sending money online should be as simple as transferring cash from your wallet to someone else's. 

{{< figure src="/images/dump/naive-view.png" alt="direct-payment">}}

Just right amount, right person, done. But if we remove the layers, then you'll see it's anything but straightforward. Online payments are a perfect product of tech, trust, and observers. Let's unfold this world. Grab a coffee, this might change how you think during that next Amazon sale : )  

## The madness: Scale, Context, and the Need for Observers 

Imagine this you're on a massive e-commerce site during a flash sale, one of those where a million users are adding items to their carts. Now, sending a payment here isn't just about wiring the right amount to the merchant's bank. Here it's a high-stakes operation. The merchant has to handle that insane scale without buckling under the pressure. Imagine a million transactions hitting at once, the system needs to be built for it, like a stadium designed for a sold-out concert. 

{{< figure src="/images/dump/more-layer.png" alt="more-layer">}}

But scale is just the start. The real magic (or headache) is context. Without knowing what the payment is for, that money is just floating into a black box. Is it for those sneakers in size 10, or that gadget you just ordered last minute? This is where payment gateways comes in to the picture, like referees. They're not just middlemen, they're observers of the entire network (card networks, wallet transactions, banks). They monitor every step, providing real-time updates on the payment's state pending, processing, confirmed, or failed, now this helps merchant take the decision on your order.  

## Think of a card payment: 
It's essentially a network where merchant's bank communicates with the your bank to move funds. When you swipe (or tap "confirm"), you're authorising the deduction from your account. Gateways track this journey, sending hooks or notifications that tell the merchant, "Hey, this is legit, go ahead and ship the product." Without these insights, merchants would be flying blind, risking fraud, delays, or unhappy customers. These gateways aren't passive; they enable actions like inventory updates or automated refunds if things go south. In short, they're the glue holding the ecosystem together.  

## UPI: P2P Meets Real-World Needs  
Now, let's switch gears to something closer to home for many of us in India: UPI (Unified Payments Interface). At its core, UPI is beautifully straightforward, it's designed for peer-to-peer (P2P) transfers. A merchant could just share their UPI ID, and you pay directly for your order. No fuss. But here's the catch- How does the merchant know if that incoming payment is for this specific order with the exact amount? Without verification, it's like shouting into a void. 

{{< figure src="/images/dump/complex-upi.png" alt="complex-upi">}}

Enter payment gateways again, acting as participants in the NPCI (National Payments Corporation of India) network. They don't just facilitate, they observe and query. For instance, a gateway might generate a unique UPI URI (like a tailored link) with parameters tied to your order, amount, order ID, you name it. When you pay via that intent, the gateway checks the NPCI network: "Has this been processed correctly? Is the metadata a match?"  

If everything checks out, boom the merchant gets notified. Maybe it's a webhook triggering an inventory update, or an automated email confirming the payment. This lets them proceed with delivery without second-guessing. It's efficient, but it highlights a key truth: Even in "direct" systems like UPI, you need these observers to bridge the gap between initiation and confirmation. They're the ones ensuring the payment isn't lost in translation, handling refunds if needed, and keeping the whole show running smoothly.  

## The Broader Landscape: Orchestrators, Scale, and the Observer's Role  
Zoom out, and you'll see online payments aren't just one-to-one affairs. They're ecosystems buzzing with participants- banks, gateways, networks. In high-traffic scenarios, like a Black Friday sale with billions of users, merchants might partner with multiple gateways to distribute the load. No single provider can handle it all, so you bring in more players with robust capabilities to collect payments on your behalf.  

{{< figure src="/images/dump/orchestrator-image.png" alt="orchestrator" height="400">}}

This is where things get even more layered, the "orchestrator." Think of it as a smart router that evaluates options and picks the best path for your payment, factoring in speed, fees, success rates, and user preferences. It's like a GPS for your money, ensuring it takes the smoothest route from your bank to the merchant's.  

At the heart of it all? Observers. In a true P2P setup without them, there's no neutral party to monitor states, communicate updates, or step in for disputes. They make the system resilient, turning potential black boxes into transparent flows.  

## Decentralised Networks and Blockchain: A Game-Changer on the Horizon?  
Here's where it gets exciting. With Web3 and blockchain entering the game, we're on the path of a revolution. In a blockchain world, transactions are public and queryable by anyone, no black boxes here. Suddenly, the barrier to entry drops: Anyone could become a payment gateway without needing special access to networks like NPCI. Validation becomes democratized, potentially slashing costs and inviting more participants.  

But complexity doesn't end here; it evolves. During massive sales or with billions of daily users, you'd still need scalable providers to handle traffic. Orchestrators could be more helpful here, routing payments across decentralized networks(or chains). The luxury is ? More choice, less reliance on single partners, and built-in transparency that reduces fraud.  

{{< figure src="/images/dump/decentralised-tech.png" alt="web3">}}

Of course, we're not there yet. Today's infrastructure, gateways, hooks, and all- still powers the internet economy. But as blockchain matures, it could empower merchants and users alike, making payments feel truly peer-to-peer while handling real-world scale.  

## Wrapping It Up:  
So, next time you hit that payment button, remember: It's not just money moving- it's a sync of observers, states, and safeguards ensuring everything aligns while staying compliant with all the law of land. From e-commerce behemoths, online payments thrive on this hidden infrastructure. And with decentralised tech, we might see a more inclusive, efficient future.

Thank you for reading! I wrote this blog in small chunks over several days, used gemini Flash to generate the illustrations. hope my goal to keep things as simple as possible and avoid any technical jargon was successful. 