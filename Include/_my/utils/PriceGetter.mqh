
//
// #include <_my\utils\PriceGetter.mqh>
//
//
class PriceGetter
{
protected:
   string   _symbol;
   ENUM_TIMEFRAMES _period;
public: //  fields
               string   GetSymbol()                {return this._symbol;}
               ENUM_TIMEFRAMES    
                        GetPeriod()                {return this._period;}
string TF2Str()
  {
  int period = (int)this._period;
   switch(period)
     {
      case PERIOD_M1: return("M1");
      case PERIOD_M5: return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1: return("H1");
      case PERIOD_H4: return("H4");
      case PERIOD_D1: return("D1");
      case PERIOD_W1: return("W1");
      case PERIOD_MN1: return("MN");
     }
   return("unknown");
  }                        
                        
                        
public:           // functionality             
               datetime TimeP(int shift)           {return iTime(_symbol, _period, shift);}
               double   CloseP(int shift)          {return iClose(_symbol,_period, shift);}
               double   OpenP(int shift)           {return iOpen(_symbol, _period, shift);}
               double   HighP(int shift)           {return iHigh(_symbol, _period, shift);}
               double   LowP(int shift)            {return iLow(_symbol, _period, shift);}
               long   VolumeP(int shift)          {return iVolume(_symbol,_period, shift);}
               double   GetPrice(ENUM_APPLIED_PRICE price_type,int shift);          
               
               
               
               int   HighestPIndex(int priceType,int nbars,int startBar)        {  return iHighest(_symbol, _period, priceType,nbars,startBar); }               
               int   HighestPIndex(int nbars)                                   {  return HighestPIndex(MODE_HIGH,nbars,0);       }
               int   HighestPIndex(int nbars,int startBar)                      {  return HighestPIndex(MODE_HIGH,nbars,startBar);}
               int   HighestClosePIndex(int nbars)                                   {  return HighestPIndex(MODE_CLOSE,nbars,0);       }
               int   HighestClosePIndex(int nbars,int startBar)                      {  return HighestPIndex(MODE_CLOSE,nbars,startBar);}


               
 /* priceType:
0 Open price
1 Low price
2 High price
3 Close price
4 volume
 */
  

               int   LowestPIndex(int priceType,int nbars,int startBar)         {  return  iLowest(_symbol, _period, priceType,nbars,startBar);  }
               int   LowestPIndex(int nbars)                                    {  return LowestPIndex(MODE_LOW,nbars,0);         }
               int   LowestPIndex(int nbars,int startBar)                       {  return LowestPIndex(MODE_LOW,nbars,startBar);  }
               int   LowestClosePIndex(int nbars)                                    {  return LowestPIndex(MODE_CLOSE,nbars,0);         }
               int   LowestClosePIndex(int nbars,int startBar)                       {  return LowestPIndex(MODE_CLOSE,nbars,startBar);  }

               double HighestPrice(int nbars,int startBar) {return HighP(HighestPIndex(nbars,startBar));} 
               double HighestPrice(int nbars) {return HighestPrice(nbars,0);} 
               double LowestPrice(int nbars,int startBar) {return LowP(LowestPIndex(nbars,startBar));} 
               double LowestPrice(int nbars) {return LowestPrice(nbars,0);} 
               
               double HighestClosePrice(int nbars,int startBar) {return CloseP(HighestClosePIndex(nbars,startBar));} 
               double LowestClosePrice(int nbars,int startBar) {return CloseP(LowestClosePIndex(nbars,startBar));} 


               double Get_MI(int mode){return MarketInfo(_symbol,mode);}
               double Get_Bid(){return Get_MI(MODE_BID);}
               double Get_Ask(){return Get_MI(MODE_ASK);}
               double Get_Point(){return Get_MI(MODE_POINT);}
               double Get_StopLevelInPoints(){return Get_MI(MODE_STOPLEVEL);}
               double Get_StopLevelDistance(){return Get_StopLevelInPoints()*Get_Point();}
               //double Get_StopLevelPips(){return Get_MI(MODE_STOPLEVEL);}
               
               datetime Get_Time(){return (datetime)Get_MI(MODE_TIME);}

               double Get_SpreadInPoints()
               {
                  //return    Get_MI(MODE_SPREAD);
                  return GetSpreadInPriceFraction()/this.Get_Point();   
               }
               double Get_MinLotSize(){return Get_MI(MODE_MINLOT);}



int GetDigits()
{ 
/*
   double Bid1 =MarketInfo(_symbol,MODE_BID);   
   double Point1 =MarketInfo(_symbol,MODE_POINT);
    
   double pip_value = MathPow(10.0, MathFloor(MathLog(Bid1 / 2.0) / MathLog(10.0)) - 3);
   int pip_digits =(int) MathRound(MathLog(pip_value / Point1) / MathLog(10.0));
   return pip_digits;
   */
return(int)Get_MI(MODE_DIGITS);

}


double GetSpreadInPriceFraction()
{ 
   //double point= Get_Point();
   //double spreadInPoints=Get_SpreadInPoints();
   //return (spreadInPoints*point);
    return this.Get_Ask() - this.Get_Bid();
}

double GetPipPriceFraction()
{/*
   double Bid1 =MarketInfo(_symbol,MODE_BID);   
   double Point1 =MarketInfo(_symbol,MODE_POINT);
    
   double pip_value = MathPow(10.0, MathFloor(MathLog(Bid1 / 2.0) / MathLog(10.0)) - 3);
   //int pip_digits =(int) MathRound(MathLog(pip_value / Point1) / MathLog(10.0));
   return pip_value ;
*/
   
   double point = Get_Point();
   int digits=GetDigits();
   
   if((digits==3) || (digits==5))
     {
      point*=10;
     }
     
      
   return point;
   
}

double GetPipPLNValue()
{

   string symbol = this._symbol;

/*
   double pipPriceFraction = GetPipPriceFraction();
   double tickvalue = MarketInfo(symbol,MODE_TICKVALUE);
   double ticksize  = MarketInfo(symbol,MODE_TICKSIZE);   
   double PipValue=(((tickvalue*pipPriceFraction)/ticksize));   
   return NormalizeDouble(PipValue,5);
   */
   
   int digits=GetDigits();
   //double point=MarketInfo(symbol,MODE_POINT);
   double multiplier = ((digits==3) || (digits==5))?10:1;   
   double tickvalue = MarketInfo(symbol,MODE_TICKVALUE)*multiplier ;      
   return NormalizeDouble(tickvalue ,12);
}
   
double GetNormalized(double d) { 
double d1=d;
double d2 = NormalizeDouble(d1,  GetDigits());
return (d2);
}


double GetCurrentQuoteForOpen(int side)
 {
          double open;
         if(side<0) // short
         {
          open= Get_MI(MODE_BID);   
         }
         else // long
         {
          open=Get_MI(MODE_ASK);      
         }
      return open;
 }


 double  GetCurrentQuoteForClose(int side)
 {
         double open;
         if(side>0) // long
         {
          open= Get_MI(MODE_BID);   
         }
         else // long
         {
          open=Get_MI(MODE_ASK);      
         }
      return open;
 }
 
 int PipsToPointFactor()
  {

   int point=1;
   int digits=this.GetDigits();

   if(digits==5 || digits==3) //Check whether it's a 5 digit broker (3 digits for Yen)
   point=10; //1 pip to 10 point if 5 digit
   
   else if(digits==4 || digits==2)
   point=1; //1 pip to 1 point if 4 digit

   return(point);

  }
   // PriceGetter(string symbol);
    PriceGetter(string symbol,ENUM_TIMEFRAMES period );
    ~PriceGetter();
};


 double   PriceGetter::GetPrice(ENUM_APPLIED_PRICE price_type1,int shift)
 {
 double result;
 int pt=(int)price_type1;
 
  
   if( pt==0) //PRICE_CLOSE  0 
   {
      result = CloseP(shift);
   
   }
   else
   {
  
   switch(pt) 
  { 
   
   case 0: //PRICE_CLOSE  0 
   result = CloseP(shift);
   break;
   
   case 1: // PRICE_OPEN 1 
   result = OpenP(shift);
   break;
   
   case 2 ://    PRICE_HIGH 2
   result = HighP(shift);
   break;
   
   case 3 ://PRICE_LOW 3
   result = LowP(shift);
   break;
 case 4://PRICE_MEDIAN 4 Median price, (high + low)/2
   result = (HighP(shift) + LowP(shift))/2.0;
   break;

case 5://PRICE_TYPICAL 5 Typical price, (high + low + close)/3
   result = (HighP(shift) + LowP(shift)+ CloseP(shift))/3.0;
   break;
   case 6 : //PRICE_WEIGHTED 6 Weighted close price, (high + low + close + close)/4
   
   result = (HighP(shift) + LowP(shift)+ CloseP(shift)*2.0)/4.0;
   break; 
   
   
   default: 
      result=0;
      break;
      
      
       
  } 
  
  }
  return result;
  
      
 }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
PriceGetter::PriceGetter(string symbol)
  {   
   _symbol = symbol;
   _period = PERIOD_CURRENT; 
  
  }
  */
PriceGetter::PriceGetter(string symbol,ENUM_TIMEFRAMES period     )
  {   
   _symbol = symbol;
   _period = period;  
  }
  
  
  
  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PriceGetter::~PriceGetter()
  {
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                  MACD Sample.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
  





 
//+------------------------------------------------------------------+

 