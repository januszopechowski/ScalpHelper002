//+------------------------------------------------------------------+
//|                                          ScalpTradeOpener002.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//#property copyright "Copyright 2016, MetaQuotes Software Corp."
//#property link      "https://www.mql5.com"
//#property version   "1.00"
//#property strict

#include <_my\utils\PriceGetter.mqh>
#include <_my\ScalpTools\PriceScalpMissCheck.mqh>
#include  <_my\OrderManagement\OrderSendSimple.mqh> 
#include <_my\ScalpTools\PriceScalpOpenCheck.mqh>
#include <_my\ScalpTools\PriceScalpMissCheck.mqh>
// #include <_my\ScalpTools\ScalpTradeOpener001.mqh>
//+------------------------------------------------------------------+
//| klasa otwiera                                                                  |
//+------------------------------------------------------------------+
class ScalpTradeOpener002
  {
private:

   string            _symbol;
   PriceGetter      *_price;
   PriceScalpMissCheck *_missCheck;
   PriceScalpOpenCheck *_openCheck;

   int               _magicNumber;
   OrderSendSimple *_os;
   double            _pip;
   TradeOpenInfo    *_trade;
   
public:
                     ScalpTradeOpener002(TradeOpenInfo *ti,PriceScalpOpenCheck * och,PriceScalpMissCheck * mch,OrderSendSimple *os);
                    ~ScalpTradeOpener002();   
   bool              CheckTrading();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
bool ScalpTradeOpener002::CheckTrading()
  {
   bool result=false;
  // Print("call CheckTrading");
   if(this._trade.IsReadyForBeforeOpenCheck())
     {
     //Print("call CheckTrading.IsReadyForBeforeOpenCheck");
        result=true;
        
        if(this._missCheck.CheckTradePriceMiss())
        {
            this._trade.Set_tradeWasMissed(true);
        }
        else if( this._openCheck.CheckTradePriceOpen() )
        {
         //Print( " ask " + ((string) _price.Get_Ask()) + " bid " + ((string) _price.Get_Bid())  );
         int trade1=_os.OpenOrdersForInputIncrementParams(
                                                               this._trade._tradeSide,
                                                               this._trade._tradeSLPips*this._pip,
                                                               this._trade._tradeTPPips*_pip,
                                                               false,4);
            if(trade1>0)
            {
               this._trade.Set_tradeWasOpened(true);
            }
        }

     }
     
     
     
     return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScalpTradeOpener002::ScalpTradeOpener002(TradeOpenInfo *ti, PriceScalpOpenCheck * och,PriceScalpMissCheck * mch,OrderSendSimple *os )
  {

   PriceGetter*price=os.Get_prices();
   _price=price;
   _pip=_price.GetPipPriceFraction();
   this._trade = ti;
   this._missCheck =mch;
   this._openCheck = och;
   _os=os;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScalpTradeOpener002::~ScalpTradeOpener002()
  {
   // delete _missCheck;
   // delete _openCheck;
  }
//+------------------------------------------------------------------+