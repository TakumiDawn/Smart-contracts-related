pragma solidity ^0.4.22;
import "gist/Timer.sol";

contract Auction {

    address internal timerAddress;
    address internal sellerAddress;
    address internal winnerAddress;

    // constructor
    function Auction(address _sellerAddress,
                     address _timerAddress) public {

        timerAddress = _timerAddress;
        sellerAddress = _sellerAddress;
        if (sellerAddress == 0)
          sellerAddress = msg.sender;
    }

    // This is provided for testing
    // You should use this instead of block.number directly
    // You should not modify this function.
    function time() public view returns (uint) {
        if (timerAddress != 0)
          return Timer(timerAddress).getTime();

        return block.number;
    }

    // Anybody can call this.
    function finalize() public {
        //TODO: place your code here
        //set the winner
        //require(msg.sender == sellerAddress);
        //sellerAddress.transfer(address(this).balance);
        //selfdestruct;
    }

    // This can ONLY be called by seller
    // Money should only be refunded to the winner.
    function refund() public {
        //TODO: place your code here
        //require(sellerAddress == msg.sender);
        //winnerAddress.transfer(address(this).balance);
    }

    function getWinner() public returns (address winner){
        return winnerAddress;
    }

}
