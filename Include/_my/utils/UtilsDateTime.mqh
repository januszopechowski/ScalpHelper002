//+------------------------------------------------------------------+
//|                                                UtilsDateTime.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
 

//#include <_my\utils\UtilsDateTime.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class UtilsDateTime
  { 
public:             
  
   static uint GetCurrentTickCount(){return GetTickCount();}
   static uint AddDaysToTickCount(uint tc,double ndays){return tc+(uint)(1000.0*60.0*60.0*24.0*ndays);}
   static datetime GetCurrentDateTime(){return TimeCurrent();}//GetTickCount();}
   static datetime AddDaysToDateTime(datetime tc,double ndays){return (datetime)(tc+(int)(60.0*1440.0*ndays));}
   static datetime GetTime(){return TimeGMT();}
   static double MinutesSince(datetime dt){ return ((double)(GetTime()-dt))/60.0; }
   
  };
  
 
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//UtilsDateTime::UtilsDateTime()  {  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//UtilsDateTime::~UtilsDateTime()  {  }
//+------------------------------------------------------------------+
