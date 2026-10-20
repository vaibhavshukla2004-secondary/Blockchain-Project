// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoomBooking {
    address payable public manager;
    uint256 public bookingFee = 0.000002 ether; // Fixed booking fee transferred to manager

    enum RoomStatus { Available, Booked, Occupied }

    struct Room {
        uint256 id;
        string name;
        uint256 price; // in wei
        RoomStatus status;
        address occupant;
    }

    uint256 public roomCount = 0;
    mapping(uint256 => Room) public rooms;

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can perform this action");
        _;
    }

    constructor() {
        manager = payable(msg.sender);
    }

    function addRoom(string memory _name, uint256 _price) external onlyManager {
        roomCount++;
        rooms[roomCount] = Room(roomCount, _name, _price, RoomStatus.Available, address(0));
    }

    // 1. Throw error if room does not exist or is currently booked/occupied
    function deleteRoom(uint256 _roomId) external onlyManager {
        require(rooms[_roomId].id != 0, "Room does not exist");
        require(rooms[_roomId].status == RoomStatus.Available, "Cannot delete room: Room is currently booked or occupied");
        delete rooms[_roomId]; 
    }

    // 2. Charges a fixed booking fee (0.000002 ETH) and transfers it directly to the manager
    function bookRoom(uint256 _roomId) external payable {
        require(rooms[_roomId].status == RoomStatus.Available, "Room not available");
        require(msg.value == bookingFee, "Must pay exact booking fee of 0.000002 ETH");

        rooms[_roomId].status = RoomStatus.Booked;
        rooms[_roomId].occupant = msg.sender;

        // Route booking fee directly to manager
        manager.transfer(msg.value);
    }

    // 3. Status correctly set to Occupied after full payment
    function occupyRoom(uint256 _roomId) external payable {
        require(
            rooms[_roomId].status == RoomStatus.Booked && rooms[_roomId].occupant == msg.sender, 
            "Room is not booked by you"
        );
        require(msg.value == rooms[_roomId].price, "Incorrect payment amount");

        rooms[_roomId].status = RoomStatus.Occupied; // Updated to Occupied

        // Route full payment directly to manager
        manager.transfer(msg.value);
    }

    // 4. Releases room back to Available status (manager retains received ETH)
    function releaseRoom(uint256 _roomId) external {
        require(msg.sender == rooms[_roomId].occupant || msg.sender == manager, "Only occupant or manager can release");
        require(rooms[_roomId].status != RoomStatus.Available, "Room is already available");

        rooms[_roomId].status = RoomStatus.Available;
        rooms[_roomId].occupant = address(0);
    }
}