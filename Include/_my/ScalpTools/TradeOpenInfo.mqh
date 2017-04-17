//+------------------------------------------------------------------+
//|                                                TradeOpenInfo.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <_my\utils\UtilsDateTime.mqh>
//#include <_my\ScalpTools\TradeOpenInfo.mqh>
#include <_my\utils\PriceGetter.mqh>
// do not add string or dynamic array content
class TradeOpenInfo
{
//
// dont add string or other dynamic array
//
public :
int      _tradeSide;
double   _tradeOpenPrice;
double   _tradeTPPips;
double   _tradeSLPips;
bool     _useSecondOrder;
double   _tradeTP2Pips;

bool      _tradeWasOpened;
bool      _tradeWasMissed;
bool      _tradePriceWasSet;
//int       _tradeType;// 0 retrace limit order, 1 stop order
datetime  _lastDT;// last date

//void  SetTradeLastDate(datetime lastDate){_lastDate=lastDate;}


TradeOpenInfo
(
      int      tradeSide,
      double   tradeOpenPrice,      
      double   tradeSLPips,
      double   tradeTPPips,
      bool     useSecondOrder,
      double   tradeTP2Pips,
     // int tradeType,
      double   daysTillEnd
)
{
   this._tradeWasOpened=false;
   this._tradeWasMissed = false;
   this._tradePriceWasSet = tradeOpenPrice>0.0?true:false;
   
   this._tradeSide = tradeSide;
   this._tradeOpenPrice = tradeOpenPrice;
   this._tradeTPPips=tradeTPPips;
   this._tradeSLPips=tradeSLPips;
   //this._tradeType = tradeType;
   this._lastDT =  UtilsDateTime::AddDaysToDateTime( UtilsDateTime::GetCurrentDateTime(),daysTillEnd);
   this._useSecondOrder    = useSecondOrder;
   this._tradeTP2Pips      = tradeTP2Pips;
   
}


void InitSideForLimitOrder(PriceGetter* price)
  {    
   double bid = price.Get_Bid();
   double ask = price.Get_Ask();
// TradeOpenInfo a;
   int side=0;
   double level= this._tradeOpenPrice;
   if(bid>level && ask>level)
     {
         side=-1;
     }
   else if(bid<level && ask<level)
     {
         side=1;
     }     
     this._tradeSide = side;    
  }
  
  

/*
void SetPriceLevel(double level,int side)
{

   this._tradeWasOpened=false;
   this._tradeWasMissed = false;
   this._tradePriceWasSet = true;
   
   this._tradeSide = tradeSide;
   this._openTradePrice = openTradePrice;
   this._tradeTPPips=tradeTPPips;
   this._tradeSLPips=tradeSLPips;
   this._tradeType = tradeType;
}
*/

bool TakeBid(){ return (this._tradeSide=1 ? false:true);}

bool IsReadyForBeforeOpenCheck()
{
   datetime dt = UtilsDateTime::GetCurrentDateTime();
   bool result=
   (!this._tradeWasMissed) && 
   (this._tradeSide!=0) && 
   this._tradePriceWasSet && 
   (!this._tradeWasOpened) 
     &&
    (_lastDT>dt )
    ;
    
     /*
    if((!result)&&  (this._tradeWasOpened))
    {
     Print(
      " IsReadyForBeforeOpenCheck false trade opened:  _tradeWasMissed ",_tradeWasMissed,
      " _tradeSide ",_tradeSide,
      " _tradePriceWasSet ",_tradePriceWasSet,
      " _tradeWasOpened ",_tradeWasOpened,
      "_lastDT",_lastDT,
      " current dt",dt
      );      
    }
    if((!result)&&  (!this._tradeWasOpened) && _tradeSide!=0 &&_tradePriceWasSet)
    {
      Print(
      " IsReadyForBeforeOpenCheck false :  _tradeWasMissed ",_tradeWasMissed,
      " _tradeSide ",_tradeSide,
      " _tradePriceWasSet ",_tradePriceWasSet,
      " _tradeWasOpened ",_tradeWasOpened,
      "_lastDT",_lastDT,
      " current dt",dt
      );      
    }
   */
    return result;
   
}
/*
bool IsReadyForAfterOpenCheck()
{
   return 
   (!this._tradeWasMissed) && 
   (this._tradeSide!=0) && 
   this._tradePriceWasSet && 
   this._tradeWasOpened;
   
}
*/


void Set_tradeWasOpened(bool b)
{
   this._tradeWasOpened = b;
   Print("call Set_tradeWasOpened with" +(string)b );
}



void Set_tradeWasMissed(bool b)
{
   this._tradeWasMissed=b;   
   Print("call Set_tradeWasMissed with" +(string)b );
}



};
//+------------------------------------------------------------------+
