 
#include<_my\SignalTools\TrendSignal.mqh>

//
//#include<_my\SignalTools\NewBar\DummyFilterAlwaysOpen.mqh>


//
//+------------------------------------------------------------------+
//|          passes all from underlying TrendSignal                                                        |
//+------------------------------------------------------------------+
 class DummyFilterAlwaysOpen : public TrendSignal
  {
private:
//
TrendSignal * _reva;
 
 int _side; 
 public:
 void Set_Side(int i){_side=i;}
 
//
DummyFilterAlwaysOpen(  
TrendSignal * reva
)  
{
      _reva = reva;
      _side=1;
}
      

 
~DummyFilterAlwaysOpen()
  {
   
  }

     

      virtual int GetTrendSide()
      {      
          return _side; // always no
      } 
                     
      virtual int ClosePosition()
      {      
            return _side;//_reva==NULL ? 0 : _reva.ClosePosition();                     
      }//
                
      virtual double GetRisk()
      {
         return   _reva==NULL ? 0.5 : _reva.GetRisk();
      }
 

    };
