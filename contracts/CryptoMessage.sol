// SPDX-License-Identifier: None
pragma solidity ^0.5.0 <0.7.0;

contract CryptoMessage{
    /* Cache - This cache is used since updateRequest needs byte value to operate
     and we can only pass bytes not string */
    bytes trueValue = "true";
    bytes falseValue = "false";
    
    function getTrueByte() public view returns(bytes memory){
        return trueValue;
    }
    
    function getFalseByte() public view returns(bytes memory){
        return falseValue;
    }
    
    // ---------------------------Structs-------------------------------------//
    
    struct User{
        string userName;
        address userAddress;
    }
    
    struct Message{
        address messageFrom;
        string message;
    }

    struct Friend{
        address friendAddress;
        bool isBlocked;
    }
 
    struct FriendRequest{
        address requestFrom;
        bytes status;
    }
    
    // ---------------------------Mappings--------------------------------------//

    mapping (address => User) public users;

    // Below the mapping are nested mapping so it functions like 3d array
    uint256 private messageCount = 0;
    mapping (address => mapping(uint256 => Message)) public messages;

    uint256 private friendCount = 0;
    mapping (address => mapping(uint256 => Friend)) public friends;

    uint256 private requestCount = 0;
    mapping (address => mapping(uint256 => FriendRequest)) public friendRequests;
    
    //------------------------------Events---------------------------------------//
    
    //Events to describe what happened
    event userAdded(
        string userName,
        address userAddress
    );
    
    event messageTransfered(
        address messageFrom,
        string message
    );
    
    event friendAdded(
        address friendAddress,
        bool isBlocked
    );
    
    event friendRequestSent(
        address requestFrom,
        bytes status
    );
    
    event friendRequestUpdated(
        address requestFrom,
        bytes status
    );
    
    // -------------------------Function Modifiers-------------------------------//
    // 0. Address validator
    
    /* Adress is passed with message and checks whether empty address or not */
    function validateAddress(address _addressToValidate,string memory _falseMessage) pure private{
        require(_addressToValidate != address(0x0), _falseMessage);
    }
    
    // 1. Check if user or not
    modifier isUser{
        // checks in the array of users list if the user address is listed or not
        // if listed isUser == true else isUser = false and return false message
        validateAddress(users[msg.sender].userAddress, "Current wallet owner is not an user!");
        _;
    }
    
    // 2. Middleware for new user
    modifier newUserMiddleware(string memory _userName) {
        // empty string can't be passed as username
        require(bytes(_userName).length > 0, 'Username can\'t be null!');

        // since eth/gas amount is used to transact the tx, making sure the wallet is up
        validateAddress(msg.sender, "Wallet not detected!");
        _;
    }
    
    // 3. Middleware for sending Message
    modifier newMessageMiddleware(address _toAddress, string memory _message){
        // same logic as isUser for checking if receiver is user or not
        validateAddress(users[_toAddress].userAddress, "Receiver is not an user!");

        // empty string can't be passed as message
        require(bytes(_message).length > 0, 'Message can\'t be null!');

        // since eth/gas amount is used to transact the tx, making sure the wallet is up
        validateAddress(msg.sender, "Wallet not detected!");
        
        // check if _toAddress is friend or not of msg.sender
        bool isFriend = false;
        for(uint256 i = 1; i <= friendCount; i++){
            if(friends[msg.sender][i].friendAddress == _toAddress){
                isFriend = true;
            }
        }
        
        require(isFriend, "User is not a friend!");
        _;
    }
    
    // 4. Middleware for sending friend request
    modifier newFriendRequestMiddleware(address _requestReceiver){
        validateAddress(users[_requestReceiver].userAddress, "Request receiver is not an user!");
        _;
    }
    
    // 5. Middleware for adding friend
    modifier addFriendMiddleware(address _requestFrom){
        validateAddress(_requestFrom, "Address must not be null!");
        _;
    }
    
    // 6. Middleware for updating friend request
    modifier updateFriendRequestMiddleware(uint256 _requestCount, bytes memory _status){
        require(keccak256(_status) == keccak256("true") || keccak256(_status) == keccak256("false"), "Status must be either true or false!");
        _;
    }
    
    //--------------------------Functions----------------------------------------//
    // 1. Create User
    function addUser(string memory _userName) newUserMiddleware(_userName) public{
        users[msg.sender] = User(_userName, msg.sender);
        emit userAdded(
             _userName, msg.sender
        );
    }
    
    // 2. Send Message
    function sendMessage(address _toAddress, string memory _message) isUser newMessageMiddleware(_toAddress, _message) public {
        ++messageCount;
        messages[_toAddress][messageCount] = Message(msg.sender, _message);
        emit messageTransfered(
            _toAddress,
            _message
        );
    }
    
    // 3. Send Friend Request
    function sendFriendRequest(address _requestReceiver) isUser newFriendRequestMiddleware(_requestReceiver) public{
        ++requestCount;
        friendRequests[_requestReceiver][requestCount] = FriendRequest(msg.sender, "null");
        emit friendRequestSent(
            msg.sender,
            "null"
        );
    }
    
    // 4. Add friend
    function addFriend(address _requestFrom) isUser addFriendMiddleware(_requestFrom) private{
        ++friendCount;
        friends[msg.sender][friendCount] = Friend(_requestFrom, false);
        
        ++friendCount;
        friends[_requestFrom][friendCount] = Friend(msg.sender, false);
        emit friendAdded(
            _requestFrom,
            false
        );
    }
    
    // 5. update friend request
    function updateFriendRequestStatus(uint256 _requestCount, bytes memory _status) isUser updateFriendRequestMiddleware(_requestCount, _status) public{
        if(keccak256(_status) == keccak256("true")){
            friendRequests[msg.sender][_requestCount].status = "true";    
            emit friendRequestUpdated(
                friendRequests[msg.sender][_requestCount].requestFrom,
                _status
            );
            addFriend(friendRequests[msg.sender][_requestCount].requestFrom);
        }
        if(keccak256(_status) == keccak256("false")){
            friendRequests[msg.sender][_requestCount].status = "false";    
        }
    }
}