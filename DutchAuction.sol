pragma solidity ^0.4.22;
import "./Auction.sol";

contract DutchAuction is Auction {

    uint public initialPrice;
    uint public biddingPeriod; //
    uint public offerPriceDecrement;

    //TODO: place your code here
    uint private startTime;
    bool private AuctionWon;
    //mapping(address => uint) pendingReturns;
    //address internal highestBidder;
    //uint public highestBid;
    //uint internal currPrice;
    //address internal currentWinnerAddress;

    // constructor
    function DutchAuction(address _sellerAddress,
                          address _timerAddress,
                          uint _initialPrice,
                          uint _biddingPeriod,
                          uint _offerPriceDecrement) public
             Auction (_sellerAddress, _timerAddress) {

        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        offerPriceDecrement = _offerPriceDecrement;

        //TODO: place your code here
        startTime = time();
        AuctionWon = false;
        //currPrice = 0;
    }


    function bid() public payable{
        //TODO: place your code here
        require(AuctionWon != true);
        require(time() < (startTime+biddingPeriod));
        require(msg.value >= (initialPrice - offerPriceDecrement*time()));//do I do to adjust for not 0 startTime?
        // if(currPrice != 0)
        // {
        //     pendingReturns[winnerAddress] += currPrice;
        // }
        winnerAddress = msg.sender;
        AuctionWon = true;
        //refund the extra
        if (msg.value > initialPrice - offerPriceDecrement*time())
           msg.sender.transfer(msg.value-(initialPrice-offerPriceDecrement*time()));

        //currPrice = msg.value;
    }

}
