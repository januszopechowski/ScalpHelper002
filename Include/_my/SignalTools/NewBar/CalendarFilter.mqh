//+------------------------------------------------------------------+
//|                                               CalendarFilter.mqh |
//|                                                              JPO |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
  
  #include<_my\SignalTools\TrendSignal.mqh>
  #include <_my\utils\FFCal.mqh>
  #include <_my\utils\MyMath.mqh>
  #include <_my\utils\UtilsDateTime.mqh>
  #include<_my\OrderManagement\OrderSendSimple.mqh>
  
  ///#include<_my\SignalTools\CalendarFilter.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CalendarFilter : public TrendSignal
  {
protected:

string _symbol;
ENUM_TIMEFRAMES _period;


FFCal *_ffcal;
TrendSignal * _reva;

bool _useEvents;

int  _beforeEventNoTradeWindowInMinutes;
//int  _afterEventNoTradeWindowInMinutes;               
int _closeOpenedTradesBeforeEventInMinutes;
OrderSendSimple* _os;


datetime  _lastCalendarUse;
int _lastCalendarUseSide;
int _lastCalendarUseMinutes;
/*

 bool IsCalendarUseMinutesZeroWithRefreshCurrent(int currentMinutes)
 {
   bool result = true;
   int mins;
   
   for(int i = 0;i<2;++i) 
   {
      _lastCalendarUseMinutes[i]=mins=_lastCalendarUseMinutes[i+1];
   }
  _lastCalendarUseMinutes[3] = currentMinutes;
  
  
  
  
  return result;   
 }

 */

int Get_lastCalendarUseInMinutes()
{  
    // round w dol
   double min=MyMath::Abs(UtilsDateTime::MinutesSince(_lastCalendarUse));
   if(min<1.0)
   {
      min=0;
   }
   return  (int)min;
 }
 
 
 
 
 
 
 
 
public:
                     CalendarFilter(
                        string symbol,
                        ENUM_TIMEFRAMES period,
                        bool useEvents,   
                        FFCalNewsClassShow newsShowClass,
                        int beforeEventNoTradeWindowInMinutes,
                        int afterEventNoTradeWindowInMinutes,
                        int closeOpenedTradesBeforeEventInMinutes,
                        OrderSendSimple* os,       
                        
                        TrendSignal * reva
                     );

                    ~CalendarFilter();


      virtual int GetTrendSide()
      {      
      
      
      if ( this._beforeEventNoTradeWindowInMinutes<this.GetMinimumCheckInterveInMinutes()) 
      {
       Alert(_symbol," ",_period,", CalendarFilter: Set Time Before  news 3 mins or more");
      }
      
          int side= this._reva.GetTrendSide();      
          int calendarUseSide=1;  
          //_lastCalendarUseSide
          if(!_useEvents)
            return side;
            
          if(side!=0)
          {
            if(this.Get_lastCalendarUseInMinutes()<this.GetMinimumCheckInterveInMinutes())// calendar file checked every 3 minutes
            // leftover  filter requires 2 or more minutes
            {
              calendarUseSide= this._lastCalendarUseSide;
            }
            else
            {            
               this._ffcal.start2();
               int mins=   this._ffcal.GetFirstMinutes();
               int mins2 = this._ffcal.GetSecondMinutes();
               int mins3 = this._ffcal.GetThirdMinutes();
               
               if(mins2!=0)
               {
                  mins    =(int) MyMath::Min( mins,mins2);
               }
               if(mins3!=0)
               {
                  mins    = (int)MyMath::Min( mins,mins3);
               }           
               
               // if all 3 are zeros 
               // check if there is info about no events
               // and if message  about event is empty:
               // let it trade - since there are zeros due no events
               bool noevent1 = this._ffcal.IsFirstEventNoMessage();
               bool noevent2 = this._ffcal.IsSecondEventNoMessage();
               bool noevent3 = this._ffcal.IsThirdEventNoMessage();
               bool noEvent = noevent1&&noevent2&&noevent3;
               
               
               
               //sometimes there is one event small event left
               // with 0 minutes - green one
               // green one
               // so here is exception 
               bool noEventProbablyLeftOver = 
               (mins==0)&&(_lastCalendarUseMinutes ==0);
               
               //((!noevent1)&&noevent2&&noevent3)&&
               //(!this._ffcal.IsFirstEventImpactHigh())
               //;
               
               
               
               if(noEvent&&mins==0)
               {  
              
                  Print("Allow trading-no events "); 
                  // do nothing - allow trading             
                  calendarUseSide=1;  
                  
               }
               else if(noEventProbablyLeftOver)
               {
                  Print("Allow trading- PROBABLY no events  - 0 minutes from one to another check"); 
                  // do nothing - allow trading             
                  calendarUseSide=1;  
                  
               }
               else
               {                  
              // Print(" mins ",mins," this.Get_lastCalendarUseInMinutes() ",this.Get_lastCalendarUseInMinutes());
               
               
                  if( mins<=_beforeEventNoTradeWindowInMinutes)
                  {               
                     calendarUseSide=0;                                
                     Print("No trading last event minutes: ",mins," (if negative - in the past)" );               
                     
                     if( (mins>0) && (this._closeOpenedTradesBeforeEventInMinutes !=0)  && (this._closeOpenedTradesBeforeEventInMinutes>=mins))
                     {
                        _os.CloseAll();
                        _os.DeleteAllPendings();
                     }               
                  }
               }
               _lastCalendarUseSide = calendarUseSide;
               _lastCalendarUse = UtilsDateTime::GetTime();
               _lastCalendarUseMinutes = mins;

            }
          }
          // jesli kalendarz pozwala - zwroc strone z filtrowanej klasy
          // jak nie - mow nie.
          return  calendarUseSide==0?0: side;

      } 
                     
      virtual int ClosePosition(){return _reva.ClosePosition();}//                
      virtual double GetRisk(){return _reva.GetRisk();}                     
      virtual double GetQuoteForOpen(){return this._reva.GetQuoteForOpen(); }                    
                     




void Set_Show_SymbolNews(

bool	   Show_USD_News                ,// = false;
bool	   Show_EUR_News                ,// = false;
bool	   Show_GBP_News                ,// = false;
bool	   Show_NZD_News                ,// = false;
bool	   Show_JPY_News                ,// = false;
bool	   Show_AUD_News                ,// = false;
bool	   Show_CAD_News                ,// = false;
bool	   Show_CHF_News                ,// = false;
bool	   Show_CNY_News                ,// = false;
bool	   Ignore_Current_SymbolNews    // = false;
)
{

this._ffcal.Show_USD_News=Show_USD_News;
this._ffcal.Show_EUR_News=Show_EUR_News;
this._ffcal.Show_GBP_News=Show_GBP_News;
this._ffcal.Show_NZD_News=Show_NZD_News;
this._ffcal.Show_JPY_News=Show_JPY_News;
this._ffcal.Show_AUD_News=Show_AUD_News;
this._ffcal.Show_CAD_News=Show_CAD_News;
this._ffcal.Show_CHF_News=Show_CHF_News;
this._ffcal.Show_CNY_News=Show_CNY_News;
this._ffcal.Ignore_Current_Symbol=Ignore_Current_SymbolNews;

}
void Set_Show_CNY_News(

bool	   Show_CNY_News                

)
{


this._ffcal.Show_CNY_News=Show_CNY_News;


}

void RefreshCalendar()
{
  this._ffcal.start2();
}


int GetMinimumCheckInterveInMinutes(){return 3;}
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CalendarFilter::CalendarFilter(
                        string symbol,
                        ENUM_TIMEFRAMES period,
                        bool useEvents,   
                        FFCalNewsClassShow newsShowClass,
                        int beforeEventNoTradeWindowInMinutes,
                        int afterEventNoTradeWindowInMinutes,
                        int closeOpenedTradesBeforeEventInMinutes,
                        OrderSendSimple* os,
                        TrendSignal * reva
                        
)
{

   _symbol=symbol;
   _period=period;

   

   _useEvents=useEvents;   
   _beforeEventNoTradeWindowInMinutes= beforeEventNoTradeWindowInMinutes;
   _closeOpenedTradesBeforeEventInMinutes = closeOpenedTradesBeforeEventInMinutes;
   _os=os;
   
    //  _afterEventNoTradeWindowInMinutes = afterEventNoTradeWindowInMinutes;
    // to bedzie pokazywac wydarzenia ktore juz sie wydarzyly przez _afterEventNoTradeWindowInMinutes
   _ffcal = new FFCal(symbol,period,afterEventNoTradeWindowInMinutes,newsShowClass);// sprawdzaj ..   
   _reva=reva;  
   _lastCalendarUse=0;
   _lastCalendarUseSide=0;
   _lastCalendarUseMinutes=-1;// not 0 since 0 is when it stalls on friday when no events are present
   //IsCalendarUseMinutesZeroWithRefreshCurrent(-1);
 
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CalendarFilter::~CalendarFilter()
  {
  delete _ffcal;
  }
  
  
//+------------------------------------------------------------------+
