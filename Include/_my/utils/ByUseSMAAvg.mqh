//+------------------------------------------------------------------+
//|                                                  ByUseSMAAvg.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
/*
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
*/
 #include <_my\utils\MyMath.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
 
 // #include <_my\utils\ByUseSMAAvg.mqh>
 
 
class ByUseSMAAvg
{
int _current;
int _picked;
int _n;
int _i;
double _values[1500];

public:
ByUseSMAAvg(int n) 
{
Init(n);
}
ByUseSMAAvg() 
{
Init(200);
}

protected:

void Init(int n)
{
n =  MyMath::Abs(n);

if(n>1500)
{
_n=1500;
Print("ByUseSMAAvg: max nelem is 1500");
}
_n=n;
_picked=0;
_current=0;
//_values =   double[_n];
}

public:

double GetAvg(double currentValue)
{
double result=0;



   if(this._picked<this._n)
   {
      _values[this._picked]=currentValue;
      ++this._picked;      
      
   }
   else
   {
      if(this._current>=this._n)
      {
         this._current=0;
      }
      this._values[this._current] =currentValue;
      ++this._current;
   }
   

for (_i=0;_i<this._picked;++_i)
{
      result+=_values[_i];
}

result = result/((double)(this._picked));

//Print("ByUseSMAAvg: result",result);

return result;
}

};