/*

//+------------------------------------------------------------------+
//|                                                 HeikenAshiSignal.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, JPO"
#property link      "januszopechowski@yahoo.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include<_my\SignalTools\TrendSignal.mqh>
#include<_my\utils\PriceGetter.mqh>

class HeikenAshiSignal
  {  
protected:

   string   _symbol; 
   PriceGetter* _pg;   
   ENUM_TIMEFRAMES _period;
   
private:
   int         _prevSide;// poprzednia strona portfela
   int         _currentSide;// biezaca strona portfela   
   
public:
   int GetPositionTargetSide(int li_8 );      
                 
   void Set_period(ENUM_TIMEFRAMES b)        {_period = b; }   

                        
                        HeikenAshiSignal(string symbol);
                        ~HeikenAshiSignal();
                        
};  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HeikenAshiSignal::HeikenAshiSignal(string symbol)
  {   
   _symbol = symbol;
   _period = PERIOD_CURRENT;
   _Tenkan = 8;//8*6*6/5;
   _Kijun= 29;//29*6*6/5;
   _Senkou = 34;//34*6*6/5; 
 
  
  }
  
  
  
  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HeikenAshiSignal::~HeikenAshiSignal()
  {
     if(this._pg!=null)
     {
      delete this._pg;
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                  MACD Sample.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
  




 
//
//  
//+------------------------------------------------------------------+
//| Check for position direction -1 short  0 flat 1 long             |
//+------------------------------------------------------------------+
//
//

//
int  HeikenAshiSignal::GetPositionTargetSide(int li_8 ) //int li_8=0;// current bar
{ 

   int    i,pos;
   double haOpen,haHigh,haLow,haClose;
//---
   if(rates_total<=10)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtLowHighBuffer,false);
   ArraySetAsSeries(ExtHighLowBuffer,false);
   ArraySetAsSeries(ExtOpenBuffer,false);
   ArraySetAsSeries(ExtCloseBuffer,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
//--- preliminary calculation
   if(prev_calculated>1)
      pos=prev_calculated-1;
   else
     {
      //--- set first candle
      if(open[0]<close[0])
        {
         ExtLowHighBuffer[0]=low[0];
         ExtHighLowBuffer[0]=high[0];
        }
      else
        {
         ExtLowHighBuffer[0]=high[0];
         ExtHighLowBuffer[0]=low[0];
        }
      ExtOpenBuffer[0]=open[0];
      ExtCloseBuffer[0]=close[0];
      //---
      pos=1;
     }
//--- main loop of calculations
   for(i=pos; i<rates_total; i++)
     {
      haOpen=(ExtOpenBuffer[i-1]+ExtCloseBuffer[i-1])/2;
      haClose=(open[i]+high[i]+low[i]+close[i])/4;
      haHigh=MathMax(high[i],MathMax(haOpen,haClose));
      haLow=MathMin(low[i],MathMin(haOpen,haClose));
      if(haOpen<haClose)
        {
         ExtLowHighBuffer[i]=haLow;
         ExtHighLowBuffer[i]=haHigh;
        }
      else
        {
         ExtLowHighBuffer[i]=haHigh;
         ExtHighLowBuffer[i]=haLow;
        }
      ExtOpenBuffer[i]=haOpen;
      ExtCloseBuffer[i]=haClose;
     }
//--- done
   return(rates_total);
  }
  
  
  */