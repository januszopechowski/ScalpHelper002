//+------------------------------------------------------------------+
//|                                 EngulfingCandleSignalATRFilt.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+

#include<_my\SignalTools\TrendSignal.mqh>
#include <_my\utils\PriceGetter.mqh>
#include<_my\SignalTools\NewBar\TimeBasedFilter.mqh>
//#include <_my\NN\iACPerceptron.mqh>
//#include <_my\utils\UtilsTimeFrame.mqh>
//
//iACPerceptron1
// #include<_my\SignalTools\NewBar\TimeBasedFilterSkippingTicks.mqh>
// dopuszczenie dla jednego sygnalu - AC
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
 class TimeBasedFilterSkippingTicks : public TimeBasedFilter
  {
protected:

 int _nTicksToSkipWhenCheckingTime;
 int _currentTick;
 int _lastTrendSide;

public:

void Set_nTicksToSkipWhenCheckingTime(int n){_nTicksToSkipWhenCheckingTime=n;}

//   
//
TimeBasedFilterSkippingTicks(                        
string symbol,
ENUM_TIMEFRAMES period, // n steps to make avg indicating trend
TrendSignal * reva,
 bool takeSunday, 
 bool takeMonday,
 bool takeWendesday,
 bool takeTuesday,
 bool takeThursday, 
 bool takeFriday,

 bool take00, 
 bool take01,
 bool take02,
 bool take03,
 bool take04, 
 bool take05,
 bool take06, 
 bool take07,
 bool take08,
 bool take09,
 bool take10, 
 bool take11,
 bool take12, 
 bool take13,
 bool take14,
 bool take15,
 bool take16, 
 bool take17,
 bool take18, 
 bool take19,
 bool take20,
 bool take21,
 bool take22, 
 bool take23 
) :
TimeBasedFilter(
 
                        
                          symbol,
                        period,
                        // n steps to make avg indicating trend
reva,
takeSunday, 
 takeMonday,
 takeWendesday,
 takeTuesday,
 takeThursday, 
 takeFriday,

 take00, 
 take01,
 take02,
 take03,
 take04, 
 take05,
 take06, 
 take07,
 take08,
 take09,
 take10, 
 take11,
 take12, 
 take13,
 take14,
 take15,
 take16, 
 take17,
 take18, 
 take19,
 take20,
 take21,
 take22, 
 take23 
)  

{
 _nTicksToSkipWhenCheckingTime=200;
 _currentTick=_nTicksToSkipWhenCheckingTime;  
 _lastTrendSide=0;
}
       

     
   

      virtual int GetTrendSide()
      {      
          
          if(_currentTick<_nTicksToSkipWhenCheckingTime)
          {
            ++_currentTick;
            
          }
          else
          {          
            _currentTick=0;
            _lastTrendSide = TimeBasedFilter::GetTrendSide();
          }          
          return  _lastTrendSide;        
      } 
                     
 

    };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


  
//+------------------------------------------------------------------+
