//+------------------------------------------------------------------+
//|                                                 IndicatorGetter.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+
//#property copyright "Copyright 2015, JPO"
//#property link      "januszopechowski@yahoo.com"
//#property version   "1.00"
//#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
// #include <_my\utils\IndicatorGetter.mqh>
//
//
class IndicatorGetter
{
protected:
   string   _symbol;
   ENUM_TIMEFRAMES _period;
public: //  fields
               string   GetSymbol()                {return this._symbol;}
               ENUM_TIMEFRAMES    
                        GetPeriod()                {return this._period;}
                        
public:           // functionality                
                     double GetMA(ENUM_MA_METHOD maType,ENUM_APPLIED_PRICE priceType ,int nBarsAvg,int shift)      {return iMA(_symbol,_period,nBarsAvg,0,maType ,priceType,shift);}                            
                    // double GetMA_EMA_CloseShift(int shift,int nBarsAvg){ return GetMA(MODE_EMA,PRICE_CLOSE ,nBarsAvg,shift);}                            

                     double GetMA_EMA_Close(int nBarsAvg,int shift){ return GetMA(MODE_EMA,PRICE_CLOSE ,nBarsAvg,shift);}                            
                     double GetMA_EMA_High(int nBarsAvg,int shift){ return GetMA(MODE_EMA,PRICE_HIGH ,nBarsAvg,shift);}                            
                     double GetMA_EMA_Low(int nBarsAvg,int shift){ return GetMA(MODE_EMA,PRICE_LOW ,nBarsAvg,shift);}                            


                     double GetMA_EMA_Close1(int nBarsAvg){ return GetMA_EMA_Close(nBarsAvg,1);} 
                     
                     double GetMA_OnArray(double &maBuf[],int N_avg,ENUM_MA_METHOD maType,int shift){
                        return iMAOnArray(maBuf,0,N_avg,0, maType,shift);
                      };
                     double GetMA_SMA_Close(int nBarsAvg,int shift){ return GetMA(MODE_SMA,PRICE_CLOSE ,nBarsAvg,shift);}                            

                     
                                                
                     // implied volatility
                     double GetIV(int shift,ENUM_MA_METHOD maType ,int nBarsAvg)     {return GetMA(maType,PRICE_HIGH,nBarsAvg,shift)-GetMA(maType,PRICE_LOW,nBarsAvg,shift);}                     
                     double GetIV_LWMA(int shift,int nBarsAvg) {return GetIV(shift,MODE_LWMA,nBarsAvg);}
                     double GetIV_SMA(int shift ,int nBarsAvg) {return GetIV(shift,MODE_SMA,nBarsAvg);}
                     double GetIV_EMA(int shift,int nBarsAvg)  {return GetIV(shift,MODE_EMA,nBarsAvg);}
                     double GetiAC(int shift)      {return iAC(_symbol,_period,shift);}
                                     
                     double GetATR(int shift ,int nBarsAvg){return  iATR( _symbol,_period,nBarsAvg,shift); }
                     
                     double GetRSI(int shift ,int nBarsAvg,ENUM_APPLIED_PRICE priceType ){return  iRSI( _symbol,_period,nBarsAvg,priceType ,shift); }                     
                     double GetRSIOnClose(int shift ,int nBarsAvg){   return GetRSI(shift ,nBarsAvg,PRICE_CLOSE); }
                     double GetRSIOnClose1(int nBarsAvg){   return GetRSI(1,nBarsAvg,PRICE_CLOSE); }
                     double GetRSIOnClose0(int nBarsAvg){   return GetRSI(0,nBarsAvg,PRICE_CLOSE); }
                     
                     //double GetMoneyFlowIndex(int shift ,int nBarsAvg,ENUM_APPLIED_PRICE priceType ){
                     //return iMfi iRSI( _symbol,_period,nBarsAvg,priceType ,shift); }                     
                     
                     double GetMoneyFlowIndex(int shift ,int nBarsAvg)
                     {   
                        return iMFI( 
   this._symbol,     // symbol 
   this._period,     // timeframe 
   nBarsAvg,         // averaging period 
   shift             // shift 
                                );
                     }
                     

                     double GetStochastic(int shift ,int Kp,int Dp,int Slowing,ENUM_MA_METHOD maType,int priceField,int mode )
                     { return  iStochastic(_symbol,_period,Kp,Dp,Slowing,maType,priceField,mode,shift); }
                     
                     double GetStochasticMainEMAClose(int shift ,int Kp,int Dp,int Slowing)  { return  GetStochastic(shift ,Kp,Dp,Slowing,MODE_EMA ,1,MODE_MAIN);}
                     double GetStochasticSignalEMAClose(int shift ,int Kp,int Dp,int Slowing){ return  GetStochastic(shift ,Kp,Dp,Slowing,MODE_EMA ,1,MODE_SIGNAL);}                     
                     
                     // mode :"MODE_MAIN,MODE_SIGNAL 0/1 
                     // price field : HIGH-LOW/ CLOSE  /  0/1                      
                     double GetStochasticMainEMAClose1(int Kp,int Dp,int Slowing)  { return  GetStochastic(1,Kp,Dp,Slowing,MODE_EMA ,1,MODE_MAIN);}
                     double GetStochasticSignalEMAClose1(int Kp,int Dp,int Slowing){ return  GetStochastic(1,Kp,Dp,Slowing,MODE_EMA ,1,MODE_SIGNAL);}
                     double GetStochasticMainSMAClose1(int Kp,int Dp,int Slowing)  { return  GetStochastic(1,Kp,Dp,Slowing,MODE_SMA ,1,MODE_MAIN);}
                     double GetStochasticSignalSMAClose1(int Kp,int Dp,int Slowing){ return  GetStochastic(1,Kp,Dp,Slowing,MODE_SMA ,1,MODE_SIGNAL);}
//                     double GetStochasticMainSMAClose0(int Kp,int Dp,int Slowing)  { return  GetStochastic(0,Kp,Dp,Slowing,MODE_SMA ,0,MODE_MAIN);}
//                     double GetStochasticSignalSMAClose0(int Kp,int Dp,int Slowing){ return  GetStochastic(0,Kp,Dp,Slowing,MODE_SMA ,0,MODE_SIGNAL);}                     
                     
                     double GetMACD(   
 
   int fast_ema_period,  // Fast EMA period 
   int slow_ema_period,  // Slow EMA period 
   int signal_period,    // Signal line period 
   int applied_price,    // applied price 
   int mode,             // line index 
   int shift             // shift 
   ){ return iMACD(this._symbol,this._period,fast_ema_period,slow_ema_period,signal_period,applied_price,mode,shift);}
 
   double GetMACDMainClose(int fast_ema_period,int slow_ema_period,int signal_period,int shift) 
    { return GetMACD(fast_ema_period,slow_ema_period,signal_period,PRICE_CLOSE,MODE_MAIN,shift);}
   
   double GetMACDSignalClose(int fast_ema_period,int slow_ema_period,int signal_period,int shift) 
    { return GetMACD(fast_ema_period,slow_ema_period,signal_period,PRICE_CLOSE,MODE_SIGNAL,shift);}


   double GetMACDSignalClose(int shift) { return GetMACDSignalClose(12,26,9,shift) ;}
   double GetMACDMainClose(int shift) { return GetMACDMainClose(12,26,9,shift) ;}


   double GetAdx( 
   int          avgperiod,        // averaging period 
   int          applied_price, // applied price 
   int          mode,          // line index 
   int          shift          // shift 
   ){ 
   return iADX( this._symbol,this._period,
   avgperiod,        // averaging period 
   applied_price, // applied price 
   mode,          // line index  0 main, 1 plus ,2 minus
   shift          // shift 
   );}


  double GetAdxMainClose(int avgperiod,int  shift){ return GetAdx(avgperiod,PRICE_CLOSE, 0,shift);}
  double GetAdxPlusClose(int avgperiod,int  shift){ return GetAdx(avgperiod,PRICE_CLOSE, 1,shift);}
  double GetAdxMinusClose(int avgperiod,int  shift){ return GetAdx(avgperiod,PRICE_CLOSE, 2,shift);}




double  GetBands( 
   int          avgperiod,           // averaging period 
   double       deviation,        // standard deviations 
   int          bands_shift,      // bands shift 
   int          applied_price,    // applied price 
   int          mode,             // line index  0 main,1 upper 2 lower
   int          shift             // shift 
   )
   {return iBands(this._symbol,this._period,avgperiod,deviation,bands_shift,applied_price,mode,shift);}

  double  GetBandsOnClose1( int avgperiod,double deviation,int mode)
  {return GetBands(avgperiod,deviation,1,PRICE_CLOSE,mode,1);}
  double  GetBandsMainOnClose1( int avgperiod,double deviation){return GetBandsOnClose1(avgperiod,deviation,0);}
  double  GetBandsUpperOnClose1( int avgperiod,double deviation){return GetBandsOnClose1(avgperiod,deviation,1);}
  double  GetBandsLowerOnClose1( int avgperiod,double deviation){return GetBandsOnClose1(avgperiod,deviation,2);}


//  double  GetBandsLowerOnClose1( int avgperiod,double deviation){return GetBandsOnClose1(avgperiod,deviation,2);}

/*
mode 
int HAHIGH      0
int HALOW       1
int HAOPEN      2
int HACLOSE     3

*/ 
double  GetHeikenAshi( 
   int          mode,             // line index  0 main,1 upper 2 lower
   int          shift             // shift 
   );

 

double  GetHeiken_Ashi_Smoothed
( 
   int   mode,             // line index  0 main,1 upper 2 lower
   int   shift,             // shift 
   int mamethod,
   int maNavg,
   int mamethod2,
   int maNavg2
);

double  GetHeiken_Ashi_Smoothed
( 
   int   mode,             // line index  0 main,1 upper 2 lower
   int   shift             // shift 
);


double GetTDI_With_Alerts
( 
   int   mode,             
   int   shift,             // shift 
 string NoteGeneral,//=" --- General Options --- ";
 bool Show_TrendVisuals,//=true;
 bool Show_SignalArrows,//=true;
 int SHIFT_Sideway,//=0;
 int SHIFT_Up_Down,//=0;
//----
 string NoteIndic,//=" --- Indicator Options --- ";
 int RSI_Period,//=13;         //8-25
 int RSI_Price,//=0;           //0-6
 int Volatility_Band,//=34;    //20-40
 int RSI_Price_Line,//=2;
 int RSI_Price_Type,//=0;      //0-3
 int Trade_Signal_Line,//=7;
 bool SHOW_Trade_Signal_Line2,//=true;
 int Trade_Signal_Line2,//=18;
 int Trade_Signal_Type,//=0;   //0-3
//----
 string NoteAlerts,//=" --- Alert Options --- ";
 bool BuySellAlerts,//=true;
 bool CautionAlerts,//=true;
 bool MsgAlerts,//= true;
 bool SoundAlerts,//= true;
 string SoundAlertFile,//="alert.wav";
 bool eMailAlerts//= false;


);
double GetTDI_With_Alerts
( 
   int   mode,             
   int   shift             // shift 
);

/*
#property indicator_buffers 7
#property indicator_color1 Black
#property indicator_color2 MediumBlue
#property indicator_color3 Yellow
#property indicator_width3 2
#property indicator_color4 MediumBlue
#property indicator_color5 Green
#property indicator_width5 2
#property indicator_color6 Red
#property indicator_color7 Aqua
#property indicator_style7 2

*/
double GetTDI_With_Alerts_Red(int shift){return GetTDI_With_Alerts(5,shift);}
double GetTDI_With_Alerts_Green(int shift){return GetTDI_With_Alerts(4,shift);}
double GetTDI_With_Alerts_Yellow(int shift){return GetTDI_With_Alerts(2,shift);}

//
   
//   SetIndexBuffer(0,FastWoodieCCI);   
//   SetIndexBuffer(1,SlowWoodieCCI);   
//   SetIndexBuffer(2,HistoWoodieCCI); fast-slow
double GetWoodiesCCI(int mode,int shift);
double GetWoodiesCCI( int mode, int shift,int       A_period,int       B_period,int       num_bars);
double GetWoodiesCCIFast(int shift){return GetWoodiesCCI(0,shift);}
double GetWoodiesCCISlow(int shift){return GetWoodiesCCI(1,shift);}
double GetWoodiesCCIHist(int shift){return GetWoodiesCCI(2,shift);}


    IndicatorGetter(string symbol);
    IndicatorGetter(string symbol,ENUM_TIMEFRAMES period );
    ~IndicatorGetter();
};
double IndicatorGetter::GetTDI_With_Alerts
( 
   int   mode,             // line index  0 main,1 upper 2 lower
   int   shift             // shift 
)
{
 string NoteGeneral=" --- General Options --- ";
 bool Show_TrendVisuals=true;
 bool Show_SignalArrows=true;
 int SHIFT_Sideway=0;
 int SHIFT_Up_Down=0;
//----
 string NoteIndic=" --- Indicator Options --- ";
 int RSI_Period=13;         //8-25
 int RSI_Price=0;           //0-6
 int Volatility_Band=34;    //20-40
 int RSI_Price_Line=2;
 int RSI_Price_Type=0;      //0-3
 int Trade_Signal_Line=7;
 bool SHOW_Trade_Signal_Line2=true;
 int Trade_Signal_Line2=18;
 int Trade_Signal_Type=0;   //0-3
//----
 string NoteAlerts=" --- Alert Options --- ";
 bool BuySellAlerts=false;// =true;
 bool CautionAlerts=false;////=true;
 bool MsgAlerts=false;//= true;
 bool SoundAlerts=false;//= true;
 string SoundAlertFile="alert.wav";
 bool eMailAlerts=false;//= false;


return GetTDI_With_Alerts( mode,shift,
 NoteGeneral,
 Show_TrendVisuals,
 Show_SignalArrows,
 SHIFT_Sideway,
 SHIFT_Up_Down,
//----
 NoteIndic,
RSI_Period,         //8-25
RSI_Price,           //0-6
Volatility_Band,    //20-40
RSI_Price_Line,
RSI_Price_Type,      //0-3
Trade_Signal_Line,
SHOW_Trade_Signal_Line2,
Trade_Signal_Line2,
Trade_Signal_Type,   //0-3
//----
NoteAlerts,
BuySellAlerts,
CautionAlerts,
MsgAlerts,
SoundAlerts,
SoundAlertFile,
eMailAlerts
);
}

double IndicatorGetter::GetTDI_With_Alerts
(
   int   mode,             // line index  0 main,1 upper 2 lower
   int   shift,             // shift 
 string NoteGeneral,//=" --- General Options --- ";
 bool Show_TrendVisuals,//=true;
 bool Show_SignalArrows,//=true;
 int SHIFT_Sideway,//=0;
 int SHIFT_Up_Down,//=0;
//----
 string NoteIndic,//=" --- Indicator Options --- ";
 int RSI_Period,//=13;         //8-25
 int RSI_Price,//=0;           //0-6
 int Volatility_Band,//=34;    //20-40
 int RSI_Price_Line,//=2;
 int RSI_Price_Type,//=0;      //0-3
 int Trade_Signal_Line,//=7;
 bool SHOW_Trade_Signal_Line2,//=true;
 int Trade_Signal_Line2,//=18;
 int Trade_Signal_Type,//=0;   //0-3
//----
 string NoteAlerts,//=" --- Alert Options --- ";
 bool BuySellAlerts,//=true;
 bool CautionAlerts,//=true;
 bool MsgAlerts,//= true;
 bool SoundAlerts,//= true;
 string SoundAlertFile,//="alert.wav";
 bool eMailAlerts//= false;
)
{

double result = iCustom(this._symbol,this._period,"_my\\systems\\TDI-With_Alerts", 
  NoteGeneral,
 Show_TrendVisuals,
 Show_SignalArrows,
 SHIFT_Sideway,
 SHIFT_Up_Down,
//----
 NoteIndic,
RSI_Period,         //8-25
RSI_Price,           //0-6
Volatility_Band,    //20-40
RSI_Price_Line,
RSI_Price_Type,      //0-3
Trade_Signal_Line,
SHOW_Trade_Signal_Line2,
Trade_Signal_Line2,
Trade_Signal_Type,   //0-3
//----
NoteAlerts,
BuySellAlerts,
CautionAlerts,
MsgAlerts,
SoundAlerts,
SoundAlertFile,
eMailAlerts
  , mode, shift);
//double pHACLOSE = iCustom(this._symbol,this._period,"Heiken Ashi", color1,color2,color3,color4, HACLOSE, 1);
return result;


};


double  IndicatorGetter::GetHeikenAshi( 
   int          mode,             // line index  0 main,1 upper 2 lower
   int          shift             // shift 
   )
   {
/*
*/
color color1 = Red;
color color2 = White;
color color3 = Red;
color color4 = White;
/*
int HAHIGH      0
int HALOW       1
int HAOPEN      2
int HACLOSE     3
*/

double result = iCustom(this._symbol,this._period,"Heiken Ashi", color1,color2,color3,color4, mode, shift);
//double pHACLOSE = iCustom(this._symbol,this._period,"Heiken Ashi", color1,color2,color3,color4, HACLOSE, 1);
return result;

}


double  IndicatorGetter::GetHeiken_Ashi_Smoothed
( 
   int   mode,             // line index  0 main,1 upper 2 lower
   int   shift             // shift 
)
{
return 
GetHeiken_Ashi_Smoothed
( 
   mode,             // line index  0 main,1 upper 2 lower
   shift,             // shift 
   2,
   6,
   3,
   2
);
}

double  IndicatorGetter::GetHeiken_Ashi_Smoothed
( 
   int   mode,             // line index  0 main,1 upper 2 lower
   int   shift,             // shift 
   int mamethod,
   int maNavg,
   int mamethod2,
   int maNavg2
)
   {
   
 /*
int HAHIGH      0
int HALOW       1
int HAOPEN      2
int HACLOSE     3
*/

double result = iCustom(this._symbol,this._period,"Heiken_Ashi_Smoothed", 
   mamethod,
   maNavg,
   mamethod2,
   maNavg2
  , mode, shift);
//double pHACLOSE = iCustom(this._symbol,this._period,"Heiken Ashi", color1,color2,color3,color4, HACLOSE, 1);
return result;

}


double IndicatorGetter::GetWoodiesCCI
(
 int mode,
 int shift
)
{

int       A_period=14;
int       B_period=6;
int       num_bars=550;

   return GetWoodiesCCI(mode,shift,A_period,B_period,num_bars);
}


double IndicatorGetter::GetWoodiesCCI
(
 int mode,
 int shift,
int       A_period,
int       B_period,
int       num_bars
)
{
double result = iCustom(this._symbol,this._period,"_my\\systems\\WoodiesCCI", 
A_period,
B_period,
num_bars,
 mode, shift);
return result;

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
IndicatorGetter::IndicatorGetter(string symbol)
  {   
   _symbol = symbol;
   _period = PERIOD_CURRENT; 
  
  }
IndicatorGetter::IndicatorGetter(string symbol,ENUM_TIMEFRAMES period     )
  {   
   _symbol = symbol;
   _period = period;  
  }
  
  
  
  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
IndicatorGetter::~IndicatorGetter()
  {
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                  MACD Sample.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
  





 
//+------------------------------------------------------------------+

 