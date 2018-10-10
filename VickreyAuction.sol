pragma solidity ^0.4.22;
import "./Auction.sol";

contract VickreyAuction is Auction {

    uint public minimumPrice;
    uint public biddingDeadline;
    uint public revealDeadline;
    uint public bidDepositAmount;

    //TODO: place your code here
    mapping(address => bytes32) commitments;

    uint private startTime;
    bool private AuctionEnded;
    uint public highestBid;
    address internal currentWinnerAddress;
    uint public secondHB;
    uint public numberOfBids;

    // constructor
    function VickreyAuction(address _sellerAddress,
                            address _timerAddress,
                            uint _minimumPrice,
                            uint _biddingPeriod,
                            uint _revealPeriod,
                            uint _bidDepositAmount)
             Auction (_sellerAddress, _timerAddress) {

        minimumPrice = _minimumPrice;
        bidDepositAmount = _bidDepositAmount;
        biddingDeadline = time() + _biddingPeriod;
        revealDeadline = time() + _biddingPeriod + _revealPeriod;

        //TODO: place your code here
        startTime = time();
        AuctionEnded = false;
        highestBid = 0;
        secondHB = 0;
        numberOfBids = 0;
    }

    // Record the player's bid commitment
    // Make sure at least bidDepositAmount is provided (for new bids)
    // Bidders can update their previous bid for free if desired.
    // Only allow commitments before biddingDeadline
    function commitBid(bytes32 bidCommitment) public payable {
        // TODO: place your code here
        require(!AuctionEnded);
        require(time() < biddingDeadline);

        if(commitments[msg.sender] == bytes32(0) && msg.value >= bidDepositAmount)
        {
            commitments[msg.sender] = bidCommitment;
            msg.sender.transfer(msg.value - bidDepositAmount);
            numberOfBids++;
        }
        else if(commitments[msg.sender] != bytes32(0))
        {
            commitments[msg.sender] = bidCommitment;
            msg.sender.transfer(msg.value);
        }
        else
        {
            msg.sender.transfer(msg.value);
            revert();
        }
    }

    // Check that the bid (msg.value) matches the commitment
    // If the bid is below the minimum price, it is ignored but the deposit is returned.
    // If the bid is below the current highest known bid, the bid value and deposit are returned.
    // If the bid is the new highest known bid, the deposit is returned and the previous high bidder's bid is returned.
    function revealBid(bytes32 nonce) public payable returns(bool isHighestBidder) {
        // TODO: place your code here
        bytes32 tempCom = makeCommitment(msg.value, nonce);
        require(commitments[msg.sender] == tempCom);
        require(time() >= biddingDeadline);
        require(time() < revealDeadline);
        if(msg.value >= minimumPrice)
        {
          if(msg.value < highestBid && msg.value > secondHB)
            secondHB = msg.value;
          if(msg.value >= highestBid)
          {
              msg.sender.transfer(bidDepositAmount);
              currentWinnerAddress.transfer(highestBid);
              currentWinnerAddress = msg.sender;
              secondHB = highestBid;
              highestBid = msg.value;
              return true;
          }
          else
              msg.sender.transfer(msg.value + bidDepositAmount);
        }
        else
            msg.sender.transfer(bidDepositAmount);
        return false;
    }

    function makeCommitment(uint bidValue, bytes32 nonce) public pure returns(bytes32) {
        return keccak256(bidValue, nonce);
    }

    function getWinner() public returns (address winner){
        if((time() >= revealDeadline))
          winnerAddress = currentWinnerAddress;
        return winnerAddress;
    }

    // finalize() must be extended here to provide a refund to the winner
    function finalize() public {
        //TODO: place your code here
        require(time() >= revealDeadline);
        AuctionEnded = false;
        if(numberOfBids == 1)
          currentWinnerAddress.transfer(highestBid - minimumPrice);
        else if (numberOfBids > 1)
          currentWinnerAddress.transfer(highestBid - secondHB);
        // call the general finalize() logic
        super.finalize();
    }
}
