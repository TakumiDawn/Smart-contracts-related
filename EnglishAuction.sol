pragma solidity ^0.4.22;
import "./Auction.sol";

contract EnglishAuction is Auction {

    uint public initialPrice;
    uint public biddingPeriod;
    uint public minimumPriceIncrement;

    //TODO: place your code here
    bool private AuctionWon;
    uint internal currPrice;
    address internal currentWinnerAddress;
    uint private startTime;
    uint internal currTime;

    // constructor
    function EnglishAuction(address _sellerAddress,
                          address _timerAddress,
                          uint _initialPrice,
                          uint _biddingPeriod,
                          uint _minimumPriceIncrement) public
             Auction (_sellerAddress, _timerAddress) {

        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        minimumPriceIncrement = _minimumPriceIncrement;

        //TODO: place your code here
        AuctionWon = false;
        currPrice = initialPrice;
        startTime = time();
        currTime = startTime;
        currentWinnerAddress = 0;
    }

    function bid() public payable{
        //TODO: place your code here
        //require(AuctionWon != true);
        //require( (time()-currTime) < (biddingPeriod));
        require( (time() < (biddingPeriod+currTime)));
        if (AuctionWon)
          require(msg.value >= currPrice + minimumPriceIncrement);
        else
          require(msg.value >= initialPrice);

        //refund
        if (AuctionWon) {
            currentWinnerAddress.transfer(currPrice);
        }
        currentWinnerAddress = msg.sender;
        currPrice = msg.value;
        AuctionWon = true;
        currTime = time();
    }

    //TODO: place your code here
    //Need to override the default implementation
    function getWinner() public returns (address winner){
        if(time() >= (biddingPeriod+currTime) )
        {
            winnerAddress = currentWinnerAddress;
            return winnerAddress;
        }
        else
            return 0;
    }
}
