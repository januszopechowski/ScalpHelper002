//+------------------------------------------------------------------+
//|                                 EngulfingCandleSignalATRFilt.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, JPO"
#property link      "januszopechowski@yahoo.com"
#property version   "1.00"
#property strict
#include<_my\SignalTools\TrendSignal.mqh>

//
//#include<_my\SignalTools\NewBar\DummyFilterNeverOpen.mqh>


//
//+------------------------------------------------------------------+
//|          passes all from underlying TrendSignal                                                        |
//+------------------------------------------------------------------+
 class DummyFilterNeverOpen : public TrendSignal
  {
private:
//
TrendSignal * _reva;
  
 public:
//
DummyFilterNeverOpen(  
TrendSignal * reva
)  
{
      _reva = reva;
}
      

 
~DummyFilterNeverOpen()
  {
   
  }

     

      virtual int GetTrendSide()
      {      
          return 0; // always no
      } 
                     
      virtual int ClosePosition()
      {      
            return _reva==NULL ? 0 : _reva.ClosePosition();                     
      }//
                
      virtual double GetRisk()
      {
         return   _reva==NULL ? 0 : _reva.GetRisk();
      }
 

    };
