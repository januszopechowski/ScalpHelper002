//+------------------------------------------------------------------+
//|                                 EngulfingCandleSignalATRFilt.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+


#include<_my\SignalTools\TrendSignal.mqh>
#include <_my\utils\PriceGetter.mqh>
//#include <_my\NN\iACPerceptron.mqh>
//#include <_my\utils\UtilsTimeFrame.mqh>
//
//iACPerceptron1
// #include<_my\SignalTools\NewBar\TimeBasedFilter.mqh>
// dopuszczenie dla jednego sygnalu - AC
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
 class TimeBasedFilter : public TrendSignal
  {
protected:
//
TrendSignal * _reva;
 PriceGetter* _pg;
 
 

bool _days[7]; //sunday=0,monday=1..
bool _hours[24]; // 0 ..24
public:
//   
//
TimeBasedFilter(
 
                        
                        string symbol,
                        ENUM_TIMEFRAMES period,
                        // n steps to make avg indicating trend
TrendSignal * reva,
 bool takeSunday, 
 bool takeMonday,
 bool takeWendesday,
 bool takeTuesday,
 bool takeThursday, 
 bool takeFriday,

 bool take00, 
 bool take01,
 bool take02,
 bool take03,
 bool take04, 
 bool take05,
 bool take06, 
 bool take07,
 bool take08,
 bool take09,
 bool take10, 
 bool take11,
 bool take12, 
 bool take13,
 bool take14,
 bool take15,
 bool take16, 
 bool take17,
 bool take18, 
 bool take19,
 bool take20,
 bool take21,
 bool take22, 
 bool take23 
            
                       
                                          
                     )  
{

_pg = new PriceGetter(symbol,period);
      _reva = reva;
      
//weekday
//Returns the current zero-based day of the week (0-Sunday,1,2,3,4,5,6) of the last known server time.

//int  DayOfWeek();
//Returned value

//Current zero-based day of the week (0-Sunday,1,2,3,4,5,6).

//Note

//At the testing, the last known server time is modelled.

//Example:



  // do not work on holidays. 
 // if(DayOfWeek()==0 || DayOfWeek()==6) return(0);
 


  _days[0]=takeSunday; 
  _days[1]=takeMonday;
  _days[2]=takeWendesday;
  _days[3]=takeTuesday;
  _days[4]=takeThursday;
  _days[5]=takeFriday;

  _hours[00]=take00;
  _hours[01]=take01;
  _hours[02]=take02;
  _hours[03]=take03;
  _hours[04]=take04; 
  _hours[05]=take05;
  _hours[06]=take06;
  _hours[07]=take07;
  _hours[08]=take08;
  _hours[09]=take09;
  _hours[10]=take10;
  _hours[11]=take11;
  _hours[12]=take12;
  _hours[13]=take13;
  _hours[14]=take14;
  _hours[15]=take15;
  _hours[16]=take16;
  _hours[17]=take17;
  _hours[18]=take18;
  _hours[19]=take19;
  _hours[20]=take20;
  _hours[21]=take21;
  _hours[22]=take22;
  _hours[23]=take23;     
      
      }
      

 
              ~TimeBasedFilter()
  {
  
   if (_pg!=NULL)
   {
      delete _pg;
   }
   

   
  }

     
     virtual double GetQuoteForOpen(){return this._reva.GetQuoteForOpen(); }

 

      virtual int GetTrendSide()
      {      
          int side=0;
          datetime dt = this._pg.TimeP(0);

          MqlDateTime str1;
          TimeToStruct(dt,str1); 

          int day =  str1.day_of_week;
          int hour =  TimeHour(dt);// str1.hour;
          //if(_sup.Supervise())
         // {         
         
         //Print(hour, ",",day);
            if(this._hours[hour]== true &&  this._days[day] == true)
            {                                 
            side= this._reva.GetTrendSide(); 
           }         
          return side;
      } 
                     
      virtual int ClosePosition()
      {      
         // when another alog - do not close position?
          //if(_sup.Supervise())
          //{
            return _reva.ClosePosition();                     
          //}
          //return 0;
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
