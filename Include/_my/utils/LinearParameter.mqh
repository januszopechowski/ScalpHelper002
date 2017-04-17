//+------------------------------------------------------------------+
//|                                              LinearParameter.mqh |
//|                                               Copyright 2015, JO |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
//#property copyright "Copyright 2015, JO"
//#property link      "http://www.mql4.com"
//#property version   "1.00"
//#property strict

// #include <_my\utils\LinearParameter.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//  y = a* x + b
// in terms of fieldnames in class below 
// f(x) = _tangent*x + _const
class LinearParameter
  {
private:
      double _const;
      double _tangent;
public :
      void Set_Tangent(double b)    {  this._tangent = b;}
      void Set_Const(double b)      {  this._const = b;}
      double GetValue(double x)     {  return (double)(x*this._tangent + this._const); }
      double Get_Const()     {  return (double)(this._const); }
      void SetInterpolator(double beginValue,double endValue,int ndays, ENUM_TIMEFRAMES period);
      void SetInterpolator(double beginValue,double endValue,double nbars);
   
public:

      LinearParameter(double tangent, double const1)
      {
         this._const = const1;
         this._tangent = tangent;
      }//


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LinearParameter(){this._const=0;this._tangent=1;}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
~LinearParameter(){}
  
  
  };
  
  
  
  
//+------------------------------------------------------------------+
void LinearParameter::SetInterpolator(double beginValue,double endValue,double nbars)
{
//y=a * x + b
// begin = b
 _const = beginValue;
 // endValue = a*nbars + b 
 _tangent = (endValue - _const)/((double)nbars);
  
}
void LinearParameter::SetInterpolator(double beginValue,double endValue,int ndays, ENUM_TIMEFRAMES period)
{
   ENUM_TIMEFRAMES period1 = (period == PERIOD_CURRENT)? ((ENUM_TIMEFRAMES )Period()): period;

   SetInterpolator(beginValue,endValue,ndays*(
   (double)(1440.0/(double)((int)period1))     ));

}