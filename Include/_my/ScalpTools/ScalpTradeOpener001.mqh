

#include <_my\utils\PriceGetter.mqh>
#include <_my\ScalpTools\PriceScalpMissCheck.mqh>
#include  <_my\OrderManagement\OrderSendSimple.mqh> 
#include <_my\ScalpTools\PriceScalpOpenCheck.mqh>
#include <_my\ScalpTools\PriceScalpMissCheck.mqh>
#include <_my\SignalTools\TrendSignal.mqh>
// #include <_my\ScalpTools\ScalpTradeOpener001.mqh>
//+------------------------------------------------------------------+
//| klasa otwiera                                                                  |
//+------------------------------------------------------------------+
class ScalpTradeOpener001
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
   TrendSignal* _filterSignal;
   int _maxTradesPerSymbolOpened;


public:
   void Set_maxTradesPerSymbolOpened(int b){_maxTradesPerSymbolOpened=b;}
   
   
                     ScalpTradeOpener001(
                     TradeOpenInfo *ti,
                     PriceScalpOpenCheck * och,
                     PriceScalpMissCheck * mch,
                     OrderSendSimple *os,
                     TrendSignal* filterSignal);

                    ~ScalpTradeOpener001();
  // void              InitTradeOpenInfo(         double   openTradePrice,      double   tradeTPPips,      double   tradeSLPips   );   
   
   bool              CheckTrading();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool ScalpTradeOpener001::CheckTrading()
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
                    
                    
            //if(trade1>0)
            {
               this._trade.Set_tradeWasOpened(true);
            }

         //Print( " ask " + ((string) _price.Get_Ask()) + " bid " + ((string) _price.Get_Bid())  );
         
         int allowbyFilterSide=_filterSignal.GetTrendSide();
         int trade1;
         int trade2;
         if(allowbyFilterSide!=0)
          {    
              trade1=_os.OpenOrdersForInputIncrementParams(
                                                               this._trade._tradeSide,
                                                               this._trade._tradeSLPips*this._pip,
                                                               this._trade._tradeTPPips*_pip,
                                                               false,_maxTradesPerSymbolOpened);          
              
             // Print("_useSecondOrder ",this._trade._useSecondOrder);
              if(this._trade._useSecondOrder)
              {
              trade2=_os.OpenOrdersForInputIncrementParams(
                                                                  this._trade._tradeSide,
                                                                  this._trade._tradeSLPips*this._pip,
                                                                  this._trade._tradeTP2Pips*_pip,
                                                                  false,_maxTradesPerSymbolOpened);
              }
          
          }
        }

     }
     
     
     
     return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
void ScalpTradeOpener001::InitTradeOpenInfo(            
      double   openTradePrice,
      double   tradeTPPips,
      double   tradeSLPips
      )
  {  
  
   double bid = this._price.Get_Bid();
   double ask = this._price.Get_Ask();
   int side=0;   
   if(bid>level && ask>level)
     {
         side=1;
     }
   else if(bid<level && ask<level)
     {
         side=-1;
     }     
    this._trade = new TradeOpenInfo(side,openTradePrice,tradeTPPips,tradeSLPips);
  }
*/  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScalpTradeOpener001::ScalpTradeOpener001(
TradeOpenInfo *ti, 
PriceScalpOpenCheck * och,
PriceScalpMissCheck * mch,
OrderSendSimple *os ,
TrendSignal* filterSignal
)
  {

   PriceGetter*price=os.Get_prices();
   _price=price;
   _pip=_price.GetPipPriceFraction();
   this._trade = ti;
   this._missCheck =mch;
   this._openCheck = och;
   this._filterSignal=filterSignal;
   


   _os=os;
   _maxTradesPerSymbolOpened=1;
   
   
       
   
   //SetPullbackLevel(pricelevel);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScalpTradeOpener001::~ScalpTradeOpener001()
  {
   // delete _missCheck;
   // delete _openCheck;
  }
//+------------------------------------------------------------------+
/*
void ScalpTradeOpener001::Alloc1(int n)
{
    //  this._n=n;
     // ArrayResize(_trades,n);
    
}

*/
//+------------------------------------------------------------------+
