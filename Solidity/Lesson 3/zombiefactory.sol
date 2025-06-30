pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ZombieFactory is Ownable{

    //  Events - way for contract to communicate that something happened on the blockchain to front-end
    event NewZombie(uint zombieId, string name, uint dna);

    //  State variables are permanently stored in contract storage
    uint dnaDigits = 16; 
    uint dnaModulus = 10 ** dnaDigits;

    //  traditional 32 bit time unit
    uint cooldownTime = 1 days;

    //  Structs allow for more complicated data types that have multiple properties
    struct Zombie {
        string name;
        uint dna;
        uint32 level;           //  cluster identical data types together to mimimize storage space, thus gas fees.
        uint32 readyTime;
    }

    Zombie[] public zombies;

    //  mappings - another way of storing organized data in Solidity
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;


    //  instructions - 'memory' states variable should be stored in memory, as required for all reference types.
    //  i.e. arrays, structs, mappings, strings
    //  Convention - start function parameter variable names with _
    //  Convention - private functions start with _

    //  internal - similar to private but accessible to contracts that inherit
    //  external - similar to public, except that these functions can only be called outside the contract
    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime))) - 1;

        //  msg.sender global variable
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        //  fire an event to let app know function was called
        emit NewZombie(id, _name, _dna);
    }

    //  view function - only viewing data but not modifying
    //  pure function - not even accessing any data
    function _generateRandomDna(string memory _str) private view returns (uint) {
        // keccak256 - equivalent of SHA3; expects param of type 'bytes'
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        // require statement - verify conditions that must be met
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
