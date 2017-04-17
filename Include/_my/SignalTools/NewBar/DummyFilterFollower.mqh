//+------------------------------------------------------------------+
//|                                 EngulfingCandleSignalATRFilt.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+
 
#include<_my\SignalTools\TrendSignal.mqh>

// #include<_my\SignalTools\NewBar\DummyFilterFollower.mqh>

// dopuszczenie dla jednego sygnalu - AC
//+------------------------------------------------------------------+
//|          passes all from underlying TrendSignal                                                        |
//+------------------------------------------------------------------+
 class DummyFilterFollower : public TrendSignal
  {
private:
//
TrendSignal * _reva;
  
 public:
//
DummyFilterFollower(  
TrendSignal * reva
)  
{
      _reva = reva;
}
      

 
~DummyFilterFollower()
  {
   
  }

     virtual double GetQuoteForOpen(){return this._reva.GetQuoteForOpen(); }

      virtual int GetTrendSide()
      {      
          return this._reva.GetTrendSide();

      } 
                     
      virtual int ClosePosition()
      {      
            return _reva.ClosePosition();                     
      }//
                
      virtual double GetRisk()
      {
         return _reva.GetRisk();
      }
 

    };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


  
//+------------------------------------------------------------------+
