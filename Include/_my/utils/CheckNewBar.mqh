//+------------------------------------------------------------------+
//|                                                 CheckNewBar.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+
 
// #include <_my\utils\CheckNewBar.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CheckNewBar
  {
  
protected:
   string   _symbol; 
 
   ENUM_TIMEFRAMES _period;
 
   
 
   bool        _isNewBar;
   datetime    _LastBarOpenAt;
 

public:

               bool     CheckIfNewBar();

                        
 
   void Set_period(ENUM_TIMEFRAMES b)        {_period = b; }   
   
                        
                        CheckNewBar(string symbol,ENUM_TIMEFRAMES b );
                        ~CheckNewBar();
                        //void Run();
  
  
  
  datetime newBar ;
  bool NewBar()
{
   if(ArraySize(Time)==0)
      return(false);
   if (Time[0] != newBar){// line 89
      newBar = Time[0];
      return true;
   }
   return false;
}   
  
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CheckNewBar::CheckNewBar(string symbol ,ENUM_TIMEFRAMES period)
  {
    
    newBar=Time[0];

    
   _symbol = symbol;
  _period=period;
 
   
    _isNewBar =false;
   _LastBarOpenAt =0;
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CheckNewBar::~CheckNewBar()
  {
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                  MACD Sample.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
   
 

 
 
//+------------------------------------------------------------------+
 
//
//  
//+------------------------------------------------------------------+
//| Check for position direction -1 short  0 flat 1 long             |
//+------------------------------------------------------------------+
//
//
      
bool CheckNewBar::CheckIfNewBar()
{


   if(_LastBarOpenAt == iTime(_symbol,this._period,0)) // This tick is not in new bar
    {
      _isNewBar=false;
    }
  else
    {      
      _LastBarOpenAt = iTime(_symbol,this._period,0);;
      _isNewBar = true;    
    }
  return _isNewBar;

}
