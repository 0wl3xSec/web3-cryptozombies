pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    //  Events - way for contract to communicate that something happened on the blockchain to front-end
    event NewZombie(uint zombieId, string name, uint dna);

    //  State variables are permanently stored in contract storage
    uint dnaDigits = 16; 
    uint dnaModulus = 10 ** dnaDigits;

    //  Structs allow for more complicated data types that have multiple properties
    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    //  instructions - 'memory' states variable should be stored in memory, as required for all reference types.
    //  i.e. arrays, structs, mappings, strings
    //  Convention - start function parameter variable names with _
    //  Convention - private functions start with _
    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
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
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
