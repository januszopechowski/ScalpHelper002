//+------------------------------------------------------------------+
//|                                               ScalpHelper001.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+



#include <_my\ScalpTools\PriceScalpMissCheck.mqh>
#include  <_my\OrderManagement\OrderSendSimple.mqh> 
#include<_my\OrderManagement\BreakEvenAndTrailingStop.mqh>
#include <_my\ScalpTools\ScalpTradeOpener001.mqh> 
#include <_my\ScalpTools\TradeOpenInfo.mqh>
#include <_my\ScalpTools\PriceScalpMissCheck.mqh>
#include<_my\SignalTools\NewBar\DummyFilterAlwaysOpen.mqh>
#include<_my\SignalTools\NewBar\TimeBasedFilterSkippingTicks.mqh>
#include <_my\SignalTools\NewBar\HighCandlesFilter.mqh>
#include<_my\SignalTools\NewBar\CalendarFilter.mqh>
//
//copied
//


//input bool _yesMakeNewPendingOrdersOrNoWaitForMyOrders=false;// open new trade or wait for order by symbol ,tp and lot

input double  _tradeLevel1=0;
input double  _tradeLevel2=0;
input double  _tradeLevel3=0;
input double  _tradeLevel4=0;


enum TradeSide{long1=1,short1=-1,missing1=0,auto_retrace=2};
input TradeSide  _tradeLevel1Side=TradeSide::missing1;
input TradeSide  _tradeLevel2Side=TradeSide::missing1;
input TradeSide  _tradeLevel3Side=TradeSide::missing1;
input TradeSide  _tradeLevel4Side=TradeSide::missing1;



input string  Part_1                        = "SL TP TP1 and Risk";

input double  _SLPips=12;
input double  _TPPips=10;
//input double  _Lots=0.47;
input  bool    _useSecondOrder = false;
input double  _TP2Pips=10;



input  ENUM_RISK_TYPE riskType = ENUM_RISK_TYPE::account_percent;// account percent or cash amt
input  double  _Risk  = 2;             //risk : percent : 2 , cash 200



input string  Part_2                        = "Missed level and early entry params.";
input double _openLevelNearDistancePips=0.5;

input double _missedLevelNearDistancePips=3;
input double _missedLevelRetraceDistanceFromNearPips=10;
input int    _missedLevelRetraceNBarsCheck=150;

input string  Part_3                        = "Break even and trailing stop";
  
input double  _beTpConstInPips=0.5; 
input double  _beConstInPips=8.0;
input double  _tsConstInPips=0;

input string  Part_4                        = "Trading conditions required";

input double _numberOfSessionsLevelsAreValid = 1.5; // how many days order will be valid:sat,sun included.
input int    MAGICMA  =161213;// maic number - 0 if manual orders 
input double   _maxSpreadInPips=1.2;
input int _maxTradesPerSymbolOpened = 1;

input string  Part_5                        = "Lower CPU Cost by  skipping ticks with no movement:";
input double _skippedTicksPriceMoveInPips =0.0;

input string  Part_6                        = "Fast move filter:";
input int _checkPriceSpeedWindowInMinutes=1;
input double _checkPriceSpeedMaxDistanceInPips=13;

input  string  Part_7                        = "FF calendar events handling:";
input bool _useFFCalendar=true;
input FFCalNewsClassShow _checkEventCategory = FFCalNewsClassShow::HighOnly;
input int _beforeEventNoTradeWindowInMinutes=120; 
input int _afterEventNoTradeWindowInMinutes=180; 
input int _showCNYEvents=true; //check events on CNY importand for AUD
input int _closeOpenedTradesBeforeEventInMinutes=10; 



//string  Part_                        = "Unused:";
// untested - leave true
//  bool  _checkEveryTick = true;
//  uint  _checkTickAndWaitTimePeriodInMiliseconds=1000;


 input  string  Part_8                        = "Daily and hourly trading filters:";

 input bool  _takeSunday= true; 
 input bool  _takeMonday= true;
 input bool  _takeWendesday= true;
 input bool  _takeTuesday= true;
 input bool  _takeThursday= true; 
 input bool  _takeFriday= true;

 input bool  _take00= false; 
 input bool  _take01= true;
 input bool  _take02= true;
 input bool  _take03= true;
 input bool  _take04= true; 
 input bool  _take05= true;
 input bool  _take06= true; 
 input bool  _take07= true;
 input bool  _take08= true;
 input bool  _take09= true;
 input bool  _take10= true; 
 input bool  _take11= true;
 input bool  _take12= true; 
 input bool  _take13= true;
 input bool  _take14= true;
 input bool  _take15= true;
 input bool  _take16= true; 
 input bool  _take17= true;
 input bool  _take18= true; 
 input bool  _take19= true;
 input bool  _take20= true;
 input bool  _take21= true;
 input bool  _take22= true; 
 input bool  _take23 =false;
input bool _forTestingHoldLevelProcessingDuringNoTradeHours=false; 









int _ntrades = 4;//


OrdersNumberCalculator* _oc;
PriceGetter* _pg;
OrderSendSimple *_orderSender;
BreakEvenAndTrailingStop *_be;

const int  nElems=4;
ScalpTradeOpener001* toColl[4];
TradeOpenInfo* tiCol[4];
PriceScalpOpenCheck *ocCol[4];
PriceScalpMissCheck *mcCol[4];

string _symbol;
ENUM_TIMEFRAMES _period;

//int n = 4;
double _tlevel[4]; 
TradeSide    _tlevel_side1[4];

TrendSignal* _signal0m;
TrendSignal* _signal0;
TrendSignal* _signal1;
TrendSignal* _signal2;

 
int _lastHourChecked;
int _lastMinuteChecked;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   
   
 _lastMinuteChecked = Minute();
  
  int i;

//---
      _symbol = Symbol();
      _period = (ENUM_TIMEFRAMES)Period();
      
      if(_period != PERIOD_M1)
      {
         Print(" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
         Print(" One minute (M1) chart is required.");
         Print(" !!!!!!!!!!!Check line below!!!!!!!!!!!!!!!!!!!!!!!!!");
         double z=0;double z2 = 1.0/z;
      }
      
      _orderSender =  new OrderSendSimple (_symbol,_period,MAGICMA,_Risk*(_useSecondOrder?0.5:1.0));
      _orderSender.Set_maxSpreadInPips(_maxSpreadInPips);            
      _orderSender.Set_riskType(riskType);
      _orderSender.Set_orderComment("ScalpHelper002");       
       
      
      
   
       
      _signal0m = new DummyFilterAlwaysOpen(NULL);
      
      
      CalendarFilter* cf0 = new CalendarFilter(
      _symbol,_period,
      _useFFCalendar,
      _checkEventCategory,
      _beforeEventNoTradeWindowInMinutes,
      _afterEventNoTradeWindowInMinutes,
      _closeOpenedTradesBeforeEventInMinutes,
      _orderSender,
      _signal0m);
      cf0.Set_Show_CNY_News(_showCNYEvents);      
      cf0.RefreshCalendar();
      _signal0 =cf0;
 
   _signal1 = new TimeBasedFilterSkippingTicks(_symbol,_period,_signal0,
      
 _takeSunday, 
  _takeMonday,
  _takeWendesday,
  _takeTuesday,
  _takeThursday, 
  _takeFriday,

  _take00, 
  _take01,
  _take02,
  _take03,
  _take04, 
  _take05,
  _take06, 
  _take07,
  _take08,
  _take09,
  _take10, 
  _take11,
  _take12, 
  _take13,
  _take14,
  _take15,
  _take16, 
  _take17,
  _take18, 
  _take19,
  _take20,
  _take21,
  _take22, 
  _take23 
  );      
  _signal2 = new HighCandlesFilter(_symbol,_period,0.0,_checkPriceSpeedMaxDistanceInPips,_checkPriceSpeedWindowInMinutes,_signal1);

    
 
 
       
      _oc   = _orderSender.GetOrderCalc();
      _pg   = _orderSender.Get_prices();
      
      _be   = new BreakEvenAndTrailingStop(_symbol,_period,MAGICMA);
      _be.set_Break_Even_SL_AboveEntry_in_Pips(_beTpConstInPips);
      _be.Set_Trailing_Stop_in_PriceDiff_and_Pips(0,_tsConstInPips);
      _be.Set_Trail_before_break_even(false);
      _be.set_Break_Even_Trigger_in_PriceDiff_and_Pips(0,_beConstInPips);
      
      _tlevel[0]=_tradeLevel1;
      _tlevel[1]=_tradeLevel2;
      _tlevel[2]=_tradeLevel3;
      _tlevel[3]=_tradeLevel4;
       
      _tlevel_side1[0]=_tradeLevel1Side;
      _tlevel_side1[1]=_tradeLevel2Side;
      _tlevel_side1[2]=_tradeLevel3Side;
      _tlevel_side1[3]=_tradeLevel4Side;
      
      
      TradeOpenInfo* t;
      PriceScalpOpenCheck *openCheck;
      PriceScalpMissCheck *missCheck;
      ScalpTradeOpener001* to;
      double price;
      TradeSide tside;
      int sideInt;
      
      
      for(i=0;i<nElems;++i)
      {
      
         to=NULL;
         t=NULL;
         openCheck=NULL;
         missCheck=NULL;
         
         
         price = _tlevel[i];
         tside = _tlevel_side1[i];
         
         sideInt = GetSideInt(tside,price);
         Print("Level ",((string)price) ," side was set " , ((string)sideInt) );
         t = new TradeOpenInfo(sideInt ,price,_SLPips,_TPPips,_useSecondOrder,_TP2Pips,_numberOfSessionsLevelsAreValid);
                 
         
         openCheck  = new PriceScalpOpenCheck(_pg,t);
         openCheck.Set_openLevelNearDistancePips(_openLevelNearDistancePips);
         missCheck = new PriceScalpMissCheck(_pg,_missedLevelNearDistancePips,_missedLevelRetraceDistanceFromNearPips,_missedLevelRetraceNBarsCheck,t);               
         if(!_forTestingHoldLevelProcessingDuringNoTradeHours)// jesli nie test - sprawdz
         {
           missCheck.CheckPriceWasTradedWithSet();
         }
         
         to = new ScalpTradeOpener001(t,openCheck,missCheck,_orderSender,_signal2);
         to.Set_maxTradesPerSymbolOpened(_maxTradesPerSymbolOpened*(_useSecondOrder?2:1));
         
         toColl[i]=to;
         tiCol[i]=t;
         ocCol[i]=openCheck;
         mcCol[i] = missCheck;
      }
      
      
    
    
    
   return(INIT_SUCCEEDED);
  }
//
//  
   int GetSideInt(TradeSide tside,double price)
   {
         int sideInt=0;
         double bidPriceAtStart = _pg.Get_Bid();   
         if(TradeSide::auto_retrace==tside)
         {
            sideInt = price>bidPriceAtStart?-1:(1);            
         }
         else
         {
            sideInt =TradeSide::long1==tside? 1:-1;
         }
         return (int)sideInt;
   }
//
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   delete _orderSender;
   delete _be;
   delete _signal0;
   delete _signal1;
   delete _signal2;
   int i;
      for(i=0;i<nElems;++i)
      {                  
         delete toColl[i];
         delete tiCol[i];
         delete ocCol[i];
         delete mcCol[i];
      }   
      
      if(_signal0m!=NULL)
      {
         delete _signal0m;
      }
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

// ticks to count
//uint _dt=0;
//uint _dt0=0;
/*
bool WaitCheck()
{
             
      //check tick or wait
      if(!_checkEveryTick)
      {      
         _dt0=GetTickCount();
         if((_dt0-_dt)<_checkTickAndWaitTimePeriodInMiliseconds)
         return true;
         _dt=_dt0;
        // Print("Wait...");
      }
     // Print("Go!...");
      return false;
}
*/

double _price1Prev=0;
double _price1=0;
double _price1Diff=0;
int _skippedTicks = 0;
 int _skippedTicksPrev = 0;
void OnTick()
  {
   //
   //--- check for history and trading
     if(IsTradeAllowed()==false)
         return;       
       // filter for hours day of week
 
 
 
 
      if(_useFFCalendar)
      {       
        _signal0.GetTrendSide();// odswiezamy
      }
      
      
 if(_skippedTicksPriceMoveInPips>0.01)
 {
   //_price1Prev = _price1;
   _price1=_pg.Get_Bid();
   _price1Diff =_pg.GetNormalized(MyMath::Abs(_price1-_price1Prev ));
   bool ok = _price1Diff>_pg.GetPipPriceFraction()*_skippedTicksPriceMoveInPips;
   if(ok)
   {
      _price1Prev = _price1;
      _skippedTicksPrev=_skippedTicks;
      _skippedTicks=0;
   }
   else
   
   {
     // Print("Heartbea ScalpHelper002 _skippedTicks",_skippedTicks, " _price1Diff ",_price1Diff," _price1 ",_price1," _price1Prev ",_price1Prev);
      _skippedTicks++;
      return;
   }
   
   
 }
      
     
      int allowtimetrade=1;
      if(_forTestingHoldLevelProcessingDuringNoTradeHours)       // test - turn off processing, EA is off   
      {       
      
         allowtimetrade=_signal1.GetTrendSide();// czas
      
 
       }
      // allow due time
      if( allowtimetrade==1 )
        {  
         
          
 

 
      if(_useFFCalendar)
      {       
      _signal0.GetTrendSide();// odswiezamy
      }
            CheckForFix();       
      }// allow time
      
      

      
      _be.check_trade_levels_to_set_stop();
  }
  
  
    //int UpdateNoSLCurrentOrders();
void  CheckForFix(void)
{

      int i;
       
      for(i=0;i<nElems;++i)
      {                  
          RefreshRates();// importand
          toColl[i].CheckTrading();         // if anything left

      }   



}
    