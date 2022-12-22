// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.5.0 <0.9.0;

contract PropertyOwnership {

    // Designated authority is the only one who can create new properties
    address public Designated_authority;

    constructor(address _Designated_authority) public {
        Designated_authority = _Designated_authority;
    }

    // Structure to store property information
    struct Property {
        uint area;
        string location;
        address owner;
    }

    uint public count;

    mapping(uint => Property) public Properties;

    function getPropertyOwner(uint _id) public view returns (address) {
        return Properties[_id].owner;
    }

    function getPropertiesOwned(address _owner) public view returns (uint[] memory) {

        // Count how many properties are owned by owner
        uint num = 0;
        for(uint i = 0; i <= count; i++) {
            if(Properties[i].owner == _owner) {
                num+=1;
            }
        }

        // Create an array storing indices of properties owned
        uint[] memory prop = new uint[](num);
        uint temp_ind = 0;
        for(uint i = 0; i <= count; i++) {
            if(Properties[i].owner == _owner) {
                prop[temp_ind] = i;
                temp_ind+=1;
            }
        }

        return prop;
    }

    function createNewProperty
    (uint _area, string memory _location, address _owner) public {
        
        // check for designated authority
        require(msg.sender == Designated_authority, "User not authorized to create new property");

        count += 1;
        Properties[count] = Property({
            area: _area,
            location: _location,
            owner: _owner
        });

    }

    function transferPropertyOwnership(uint id, address new_owner) external {

        // check so that only current owner can change ownernship
        require(msg.sender == Properties[id].owner, "message sender not owner of property");

        Properties[id].owner = new_owner;
    }

    function splitPropertyOwnership 
    (uint id, uint[] memory _newAreas, address[] memory _newOwners) public {
        
        // check so that only current owner can change ownernship
        require(msg.sender == Properties[id].owner, "message sender not owner of property");

        // require number of new areas and owners to be same
        require(_newAreas.length == _newOwners.length, "Number of new owners and areas must match");

        // require sum of new areas to be equal to area of original property
        uint newAreasTotal = 0;
        for(uint i = 0; i < _newAreas.length; i++) {
            newAreasTotal += _newAreas[i];
        }
        require(newAreasTotal == Properties[id].area, "Sum of new areas not equal to old area");

        // Add new properties to list
        for(uint i = 0; i < _newAreas.length; i++) {
            count += 1;
            Properties[count] = Property({
                area: _newAreas[i],
                location: Properties[id].location,
                owner: _newOwners[i]
            });
        }

        // Remove original property  
        delete Properties[id];
    }
}