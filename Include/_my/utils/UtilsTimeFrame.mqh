//+------------------------------------------------------------------+
//|                                                    TimeFrame.mqh |
//|                                               Copyright 2015, JO |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, JO"
#property link      "http://www.mql4.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

//#include <_my\utils\UtilsTimeFrame.mqh>

class UtilsTimeFrame
{
    public:
     // define index and swith it to timeframe index 0..8, -1 current period
     static ENUM_TIMEFRAMES IndexToFrame(int index);
     static int FrameToIndex(ENUM_TIMEFRAMES index);
     static ENUM_TIMEFRAMES  LongerFrame(ENUM_TIMEFRAMES index);
     
     static ENUM_TIMEFRAMES  ShorterFrame(ENUM_TIMEFRAMES index);
     
     static int TicksBetweenDates(int ndays,ENUM_TIMEFRAMES  period);

};

int  UtilsTimeFrame::TicksBetweenDates(int ndays, ENUM_TIMEFRAMES  period)
{
   int nminutesPerPeriod = (int)period;   
   return  (int)(((double)ndays)/((double)nminutesPerPeriod));
}

static ENUM_TIMEFRAMES UtilsTimeFrame::LongerFrame(ENUM_TIMEFRAMES tf)
{
ENUM_TIMEFRAMES result;
switch(tf)
  {
   case PERIOD_M1:
      result = PERIOD_M5;
      break;
   case PERIOD_M5:
      result = PERIOD_M15;
   break;
   case PERIOD_M15:
      result = PERIOD_M30;
      break;
   case PERIOD_M30:
      result = PERIOD_H1;
      break;
   case PERIOD_H1:
      result = PERIOD_H4;
      break;            
   case PERIOD_H4:
      result = PERIOD_D1;
      break;                  
   case PERIOD_D1:
      result = PERIOD_W1;
      break;                  
   case PERIOD_W1:
      result = PERIOD_MN1;
      break;                  
/*      
   case PERIOD_MN1:
      result = PERIOD_MN1;
      break;                        
*/      
   default:
      result =PERIOD_MN1;
      break;
  }
  
 return result; 
}


static ENUM_TIMEFRAMES UtilsTimeFrame::ShorterFrame(ENUM_TIMEFRAMES tf)
{
ENUM_TIMEFRAMES result;
switch(tf)
  {
   case PERIOD_M1:
      result = PERIOD_M1;
      break;
   case PERIOD_M15:
      result = PERIOD_M5;
   break;
   case PERIOD_M30:
      result = PERIOD_M15;
      break;
   case PERIOD_H1:
      result = PERIOD_M30;
      break;
   case PERIOD_H4:
      result = PERIOD_H1;
      break;            
   case PERIOD_D1:
      result = PERIOD_H4;
      break;                  
   case PERIOD_W1:
      result = PERIOD_D1;
      break;                  
   case PERIOD_MN1:
      result = PERIOD_W1;
      break;                  
/*      
   case PERIOD_MN1:
      result = PERIOD_MN1;
      break;                        
*/      
   default:
      result =PERIOD_MN1;
      break;
  }
  
 return result; 
}



static int UtilsTimeFrame::FrameToIndex(ENUM_TIMEFRAMES tf)
{
int result;

switch(tf)
  {
   case PERIOD_M1:
      result = 0;
      break;
   case PERIOD_M5:
      result = 1;
   break;
   case PERIOD_M15:
      result = 2;
      break;
   case PERIOD_M30:
      result = 3;
      break;
   case PERIOD_H1:
      result = 4;
      break;            
   case PERIOD_H4:
      result = 5;
      break;                  
   case PERIOD_D1:
      result = 6;
      break;                  
   case PERIOD_W1:
      result = 7;
      break;                  
   case PERIOD_MN1:
      result = 8;
      break;                        
   default:
      result =-1;
      break;
  }
 return result;

}


// non mt4, my own interp
ENUM_TIMEFRAMES UtilsTimeFrame::IndexToFrame(int index)
{
ENUM_TIMEFRAMES result;

switch(index)
  {
   case 0:
      result = PERIOD_M1;
      break;
   case 1:
      result = PERIOD_M5;
   break;
   case 2:
      result = PERIOD_M15;
      break;
   case 3:
      result = PERIOD_M30;
      break;
   case 4:
      result = PERIOD_H1;
      break;            
   case 5:
      result = PERIOD_H4;
      break;                  
   case 6:
      result = PERIOD_D1;
      break;                  
   case 7:
      result = PERIOD_W1;
      break;                  
   case 8:
      result = PERIOD_MN1;
      break;                        
   default:
      result =PERIOD_CURRENT;
      break;
  }
 return result;
 
 
/*
-1
Current timeframe
PERIOD_M1 0

PERIOD_M5 1

PERIOD_M15 2
PERIOD_M30 3


PERIOD_H1 4 

PERIOD_H4 5

PERIOD_D1 6

PERIOD_W1 7
*/

}// M
