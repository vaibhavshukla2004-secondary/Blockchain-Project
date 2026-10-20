# Decentralized Room Booking DApp

## Description

This project is a decentralized hotel room booking application built with a Solidity smart contract and a Web3-enabled browser interface. The contract tracks each room's name, price, availability status, and occupant. A customer pays a fixed booking fee to reserve an available room, then pays the room's full price to mark it as occupied. The manager receives both payments directly.

Room statuses are:

- **Available** — the room can be booked or, if the manager is connected, deleted.
- **Booked** — reserved by a customer who can pay the room price to occupy it.
- **Occupied** — in use by that customer; the customer or manager can release it.

## Functions and access conditions

All actions are transactions on the connected blockchain network and require a connected wallet. The smart contract enforces permissions and payment amounts; hiding or showing a button in the interface is not an access-control mechanism.

### Manager

The manager is the wallet address that deploys the contract.

| Function | Conditions |
| --- | --- |
| Add a room | Only the manager can call `addRoom`. Provide a room name and price in ETH; the interface converts the price to wei. The room is created as **Available**. |
| Delete a room | Only the manager can call `deleteRoom`. The room must exist and be **Available**. Deleted room IDs are not reused. |
| Release a room | The manager can call `releaseRoom` for any existing room that is **Booked** or **Occupied**. The interface currently presents checkout/release to the occupying customer, but the contract also permits the manager to release it. |
| Receive payments | The manager receives the booking fee when a room is booked and the full room price when the customer occupies it. These payments are not refunded by `releaseRoom`. |

### Customers and other non-manager wallets

| Function | Conditions |
| --- | --- |
| View rooms | Connect a wallet to the DApp to view room names, prices, statuses, and occupant addresses. |
| Book a room | Any non-manager wallet can call `bookRoom` for an **Available** room by paying the exact fixed booking fee of **0.000002 ETH**. The room becomes **Booked** by that wallet, and the fee is transferred to the manager. |
| Occupy a room | Only the wallet that booked the room can call `occupyRoom`. The room must be **Booked**, and the transaction must send the exact room price. The room becomes **Occupied**, and the payment is transferred to the manager. |
| Release / checkout | Only the room's occupant or the manager can call `releaseRoom`, and the room must not already be **Available**. This returns the room to **Available** and clears its occupant; it does not refund payments. |

## Deployment configuration and safety

Do not commit deployment-specific ABI data or the contract address in source code or other public GitHub files. Keep them in local or deployment-managed configuration that is excluded from version control. The ABI and contract address are not secrets—the ABI describes the public contract interface, and deployed contract addresses are public on-chain—so never use either as a substitute for protecting private keys, seed phrases, or other credentials.

**Before publishing:** the current `index.html` still contains an ABI and a contract address. Move these values to untracked deployment configuration or remove them from the public source before pushing if you want to keep deployment details out of the GitHub repository. Never put wallet private keys or seed phrases in the repository or frontend.


## Steps to connect MetaMask and interact with the smart contract

1.Write Smart Contract Code in IDE \
2.Compile Smart Contract Code \
3.Connect IDE to MetaMask Account and Deploy the Smart Contract \
4.Get ABI Code and Smart Contract Address from Deployment \
5.Paste ABI Code and Smart Contract Address in frontend Files \
6.Host Frontend Files Locally to Interact with deployed Contract and Meta Mask \
\


## Deployment Network : Sepolia 

It is deployed on a testnet network called Sepolia, uses SepoliaETH. \

## Tests 

1.Valid Test - Manager Adds A room \
2.Invalid Test - Manager Tries to Remove a room that doesn't exist 
