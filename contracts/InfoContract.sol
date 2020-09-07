pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <0.7.0;

// Contract for adding person and adding orders and saving file hashes to blockchain
contract InfoContract{

    // These are the information of print orders for each customer
  struct Order {
    uint _orderId;
    string _orderName;
    string _fileName;
    string _fileHash;
    uint _createTime;
    string material;
    string size;
    string color;
    uint price;
  }
    
    // These are the information for each customer
    struct Person {
        string _firstName;
        string _lastName;
        address _userAddress;
        uint[] OrderList; 
        mapping(uint => Order) OrderStructs; 
    }
    
    // This is a library of all customers with an address mapping as a key
    // to a value of Person containing all of the information above.
    mapping(address => Person) public PersonStructs;
    address[] public PersonList;
    
    // This method is used to add a new person into the PersonStructs library
    // 
    // By first needing the user to input their first name, last name and also automatically 
    // catching the address of the user.
    function newPerson(address PersonKey, string memory _firstName,string memory _lastName)
        public
        returns(string memory)
    {
        //  unchecked for duplicates
        PersonStructs[PersonKey]._firstName = _firstName;
        PersonStructs[PersonKey]._lastName = _lastName;
        PersonStructs[PersonKey]._userAddress = PersonKey;
        PersonList.push(PersonKey);
        return PersonStructs[PersonKey]._lastName ;
    }
    
    // This method is used to find a specific person within the library by using the address key.
    function getPerson(address PersonKey)
        public
        returns(string memory firstName, string memory lastName, uint orderCount)
    {
        return(PersonStructs[PersonKey]._firstName,PersonStructs[PersonKey]._lastName, PersonStructs[PersonKey].OrderList.length);
    }

    // This method is used to add an order into the library of the specific person by again using the user's address, order ID and
    // order name as a reference.
    function addOrder(address PersonKey, uint OrderKey, string memory _orderName)
        public
        returns(bool success)
    {
        PersonStructs[PersonKey].OrderList.push(OrderKey);
        PersonStructs[PersonKey].OrderStructs[OrderKey]._orderName = _orderName;
        PersonStructs[PersonKey].OrderStructs[OrderKey]._orderId = OrderKey;
        return true;
    }
    
    // This function is used for extracting the specific order of the person.
    function getPersonOrder(address PersonKey, uint OrderKey)
        external view
        returns(uint OrderId, string memory OrderName)
    {
        return(
            PersonStructs[PersonKey].OrderStructs[OrderKey]._orderId,
            PersonStructs[PersonKey].OrderStructs[OrderKey]._orderName);
    }

    // This function is used for getting the hash of the uploaded file from the blockchain.
    function getHash(address PersonKey, uint OrderKey)
        public 
        returns (string memory)
    {
        return(PersonStructs[PersonKey].OrderStructs[OrderKey]._fileHash);
    }

    // This function is used for importing the hash of the uploaded file into the blockchain.
    function setHash(string memory _importedFileHash, address PersonKey, uint OrderKey)
        public
        returns(string memory)
    {
        string memory userFirstName;
        string memory userLastName;
        uint orderListLength;
        bool containsOrder = false;

        (userFirstName, userLastName, orderListLength) = getPerson(PersonKey);
        for (uint i = 0; i < orderListLength; i++) {
            if (OrderKey == getPersonOrders(PersonKey)[i]) {
                containsOrder = true;
            }
        }
        if (containsOrder) {
            PersonStructs[PersonKey].OrderStructs[OrderKey]._fileHash = _importedFileHash;
            string(abi.encodePacked("File hash: ", _importedFileHash, ", has been added to ", userFirstName, " ", userLastName));
        } else {
            string("Order Doesn't Exist");
        }
    }
    
    // This method is for getting the entire list of orders requested by a specific customer.
    function getPersonOrders(address PersonKey)
        public
        returns(uint[] memory orders)
    {
        return( PersonStructs[PersonKey].OrderList
            );
    }

    
    // function getSize(address PersonKey)
    //     external view
    //     returns(string memory size)
    // {
    //     return( "Large"
    //         );
    // }

    
}


