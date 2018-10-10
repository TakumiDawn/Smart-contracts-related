pragma solidity ^0.4.21;
// ECE 398 SC - Smart Contracts and Blockchain Security
// http://soc1024.ece.illinois.edu/teaching/ece398sc/spring2018/

contract SolidityChallenges {

    // 1. Simple syntax

    function arithmeticA(uint x) public pure returns(uint) {
        // The following fragment of code is a for-loop that assigns a value
        // to the variable j, depending on the value of the argument x.
        uint j = 5;
        for (uint i = 0; i < x; i++) {
            j += 2;
            j += 3/uint(2);
        }
        return j;
    }

    // Your task is to figure out a simpler way to write the function
    // exprssion that sets the variable y to the same value
    function arithmeticB(uint x) public pure returns(uint) {
        /* TODO replace this line with a simple expression that */
        // return 0;
        /* makes the assert pass */
        uint y = 5 + 3*x;
        return y;

    }

    function testYouMustPass1() public pure returns(string) {
        require(arithmeticA(1) == arithmeticB(1));
        require(arithmeticA(2) == arithmeticB(2));
        require(arithmeticA(6) == arithmeticB(6));
        return "OK";
    }

    // 2. Arithmetic and types

    // This function should return the absolute value of a 16-bit integer.
    // Note that the range of int16 values is from -32768 to 32767.
    // safeAbs_i16(-32768) should raise an exception.
    function safeAbs_i16(int16 x) public pure returns(int16) {
        // TOOD: your code goes here
        if (x == -32768)
          require(false);

        if (x < 0)
          return -1 * x;
        else
          return x;
    }

    function testYouMustPass2() public pure returns(string) {
        require( safeAbs_i16(1) == 1 );
        require( safeAbs_i16(-100) == 100 );
        require( safeAbs_i16(int16(uint16(int16(-10)))) == int16(65546));
        //require( safeDouble_i16(-32768));// should raise an exception!
        //return "OK";
    }

    // 3. Arrays

    /*The following is pseudocode for reversing an array:
      reverse(array arr):
      let output be a new array of the same size, |output| = |arr|
      for each index i in range 0 to arr.length-1 inclusive:
      output[arr.length - i - 1] = arr[i]
      return output

      Note that:
      reverse([1,2,3])
      should return [3,2,1]    */

    function reverse(address[] memory arr) public pure returns(address[] memory) {
        address[] memory output= new address[](arr.length);
        // TODO: your code goes here
        for (uint i = 0; i < arr.length; i++)
        {
            output[arr.length - i - 1] = arr[i];
        }
        return output;
    }

    function testReverse() public pure returns (string) {
        // You're on your own. Write your own test cases here if it helps you.
        address[] memory arr = new address[](3);
        arr[0] = 1; arr[1] = 3; arr[2] = 3;
        address[] memory o1 = reverse(arr);
        // TODO: check that o1 should be [3,2,1]
        for (uint i = 0; i < arr.length; i++)
        {
            require(o1[arr.length - i - 1] == arr[i]);
        }
        return "OK";
    }
}

// The following portions of the challenge involve building a simple voting contract
// Collects votes from anyone, but only one vote per address.
// Each vote requires a deposit of 0.1 ether (which is returned if successful).
// The owner can stop the vote

contract VotingChallenge {

    bool public voteActive = true;

    // 4. Declaring member variables

    // TODO: declare public member variables votesYes and votesNo
    // (both are uint16)
    uint16 public votesYes;
    uint16 public votesNo;

    // 5. mapping datatypes

    // TODO: declare a public member variable "voted" mapping voter addresses
    // to booleans (indicating whether they have already voted or not)
    mapping(address => bool) public voted;
    // 6. Events for debugging

    // TODO: Define two events, VoteYes and VoteNo (with no parameters)
    event VoteYes();
    event VoteNo();
    // 7. Stateful functions

    // TODO: make this function return true if yes is winning
    function isYesWinning() public view returns(bool) {
        if (votesYes > votesNo)
          return true;
        return false;
    }

    // TODO: Each of the voteYes and voteNo functions should do the following:
    // - Throw an exception unless a security deposit of 0.01 ether is
    //       included in msg.value
    // - Throw an exception if the vote is over
    // - if the vote is still active and msg.sender already voted,
    //       then keep their security deposit!
    // - otherwise increment the corresponding member variable, votesYes or votesNo
    // - give the voter back their security deposit
    // - emit a log event VoteYes or VoteNo
    // - return the new number of total votes
    // - anything else? (hint: think about overflows, and make
    //       a sensible design decision)

    function voteYes() public payable returns(uint) {
        // TODO: your code goes here
        require(msg.value >= 0.01 ether);
        require(voteActive == true);
        if(voted[msg.sender] != true)
        {
          voted[msg.sender] = true;
          votesYes++;
          msg.sender.transfer(msg.value);
        }
        emit VoteYes();
        return votesYes;
    }
    function voteNo() public payable returns(uint) {
        // TODO: your code goes here
        require(msg.value >= 0.01 ether);
        require(voteActive == true);
        if(voted[msg.sender] != true)
        {
          voted[msg.sender] = true;
          votesNo++;
          msg.sender.transfer(msg.value);
        }
        emit VoteNo();
        return votesNo;
    }

    // 8. Access control

    // Only the original creator of the contract can end the vote
    // TODO: Define a constructor for this contract.
    // Whoever created the contract is assigned the owner.
    address private owner = msg.sender;

    function closeVote() public {
        // TODO: only the owner should be able to call this function
        require(msg.sender == owner);
        voteActive = false;
        // If is yes, then the owner can keep the security deposits
        if (votesYes >= 10 && votesYes > votesNo)
          owner.transfer(address(this).balance);
    }
}


// 9. External interfaces

// The following is an abstact contract interface for a voting contract.
// Your goal is to attack it by voting many times in a row.

contract VulnerableVote {
    function voteYes() public returns(int);
    function voteNo() public returns(int);
}

contract VoterAttack {
    VulnerableVote victim;

    function voteYesTwoHundredTimes(address addr) public {
        // Vote 200 times in this contract (an instance of VulnerableVote):
        // https://ropsten.etherscan.io/address/0x1655489598b9d4da51fd6ba8adc4764c4c899e4d#code
        // TODO: your code goes here
        //address targetAddr = 0x1655489598b9d4da51fd6ba8adc4764c4c899e4d;
        //VoterAttack public targetAddr;
        victim = VulnerableVote(addr);
        for(uint i = 0; i < 200; i++)
        {
            victim.voteYes();
        }
    }
}
