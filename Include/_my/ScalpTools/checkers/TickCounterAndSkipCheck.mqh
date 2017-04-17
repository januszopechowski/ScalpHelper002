

 
// #include <_my\ScalpTools\checkers\TickCounterAndSkipCheck.mqh>
// poczekaj
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
 class TickCounterAndSkipCheck 
 {
  
protected:

 int _nTicksToSkipWhenCheckingTime;
 int _currentTick;


public:

void Set_nTicksToSkipWhenCheckingTime(int n){_nTicksToSkipWhenCheckingTime=n;}

//   
//
TickCounterAndSkipCheck(    int nTicksToSkipWhenCheckingTime) 
{
 _nTicksToSkipWhenCheckingTime=nTicksToSkipWhenCheckingTime;
 _currentTick=_nTicksToSkipWhenCheckingTime;  

}

      bool SkipTickWithCounterIncrease()
      {      
          
          if(_currentTick<_nTicksToSkipWhenCheckingTime)
          {
            ++_currentTick;
            return true;
          }
          else
          {          
            _currentTick=0;
            return false;            
          }          
          
      } 
      
 

    };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


  
//+------------------------------------------------------------------+
