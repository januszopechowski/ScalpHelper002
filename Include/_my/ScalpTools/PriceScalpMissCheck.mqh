 
 
 
  #include <_my\utils\PriceGetter.mqh>
  #include  <_my\ScalpTools\TradeOpenInfo.mqh>

//
// sprawdzam czy cena poszla 
// nie kompletnie i cofnela sie
//
//  #include <_my\ScalpTools\PriceScalpMissCheck.mqh>
//
//
//
class  PriceScalpMissCheck
{
//
   double            _pip;// price fraction of a pip
   
   int _side;
   double            _missedLevelPips; // diff price missed
   double            _missedLevelRetracePips;
   double            _missedLevelPrice; // diff price missed
   //double          _missedLevelRetracePrice;
   double            _tradeOpenPrice;
      
   int               _barsMissed; // bars to be checked   
   PriceGetter*   _pg;// price getter   
   TradeOpenInfo* _ti;
  // int               _barsTraded; // bars taded to be checked   
//   
   bool PriceMissedShort();
   bool PriceMissedLong();   
   
  
public:

  // void Set_barsMissed(int b){_barsMissed=b;}

   PriceScalpMissCheck(PriceGetter* pg,double missedLevelPips, double missedLevelRetracePips,int barsMissed,TradeOpenInfo* ti);

   bool MissedTrade();
   bool CheckTradePriceMiss();
   bool CheckPriceWasTradedWithSet();

};


   bool PriceScalpMissCheck::CheckTradePriceMiss()
   {

      _missedLevelPrice =  _pg.GetNormalized(_tradeOpenPrice +  _pip*((double)_missedLevelPips)*((double)_side)) ;
     // _missedLevelRetracePrice = _pg.GetNormalized( _missedLevelPrice  +  _pip*((double)missedLevelRetracePips)*((double)_side)) ;
     bool missed= MissedTrade();
     
    if(missed)
    {
      Print( "CheckTradePriceMiss , reports missed trade _missedLevelPrice :",_missedLevelPrice);
    }
    
   
    
     return missed;      
   }
   
   
   
  
   PriceScalpMissCheck::PriceScalpMissCheck(PriceGetter* pg,double missedLevelPips, double missedLevelRetracePips,int barsMissed,TradeOpenInfo* ti)
   {   
      _pg               =  pg;
      _ti               =  ti;
      _pip              = _pg.GetPipPriceFraction();
      _missedLevelPips = missedLevelPips;
      _missedLevelRetracePips = missedLevelRetracePips;      
      _barsMissed       = barsMissed;   
      _tradeOpenPrice = ti._tradeOpenPrice;
      _side=ti._tradeSide;
      //_barsTraded=11;
      
     // if(CheckPriceWasTraded())
      
      
   }
   
    
   
   bool PriceScalpMissCheck::PriceMissedShort()
   {
      double high = this._pg.HighestPrice(this._barsMissed);
      double bidPrice = this._pg.Get_Bid();
      double missedLevelRetracePrice = 
      _pg.GetNormalized( high  -  _pip*_missedLevelRetracePips) ;
      
      
      if( (this._tradeOpenPrice > high) && (high>_missedLevelPrice)&&  (missedLevelRetracePrice > bidPrice) )
      {
      
      
      
      //if()
      {         
         Print( " missed short level"); 
         Print( " _tradeOpenlPrice ",_tradeOpenPrice );
         Print( " missedLevelPips ", _missedLevelPips);
         Print( " missedLevelRetracePips ", _missedLevelRetracePips);
         
         Print( " _missedLevelPrice ",_missedLevelPrice );
         Print( " _missedLevelRetracePrice ",_missedLevelRetracePips );
         Print( " highest  ",high);
         Print( " current bid ",bidPrice);

      }     
      
         return true;
      }
      else 
      {
      return false;
      }
   }

   bool PriceScalpMissCheck::PriceMissedLong()
   {
      double low = this._pg.LowestPrice(this._barsMissed);
      double askPrice = this._pg.Get_Ask();
      double missedLevelRetracePrice = 
      _pg.GetNormalized( low  +  _pip*_missedLevelRetracePips);
      
      if( (this._tradeOpenPrice< low) && (low<_missedLevelPrice)&&  (missedLevelRetracePrice < askPrice) )
      {
      
      
      {         
         Print( " missed long level"); 
         Print( " _tradeOpenlPrice ",_tradeOpenPrice );
         Print( " missedLevelPips ", _missedLevelPips);
         Print( " missedLevelRetracePips ", _missedLevelRetracePips);
         
         Print( " _missedLevelPrice ",_missedLevelPrice );
         Print( " _missedLevelRetracePrice ",_missedLevelRetracePips );
         Print( " lowest  ",low);
         Print( " current ask  ",askPrice);

      }        
      
      
         return true;
      }
      else 
      {
      return false;
      }   
   }


   bool  PriceScalpMissCheck::MissedTrade()
   {
      if(this._side>0)
      {
         return PriceMissedLong();
      }
      
      if(this._side<0)
      {
         return PriceMissedShort();
      }
      return false;
   }
   
 

   bool PriceScalpMissCheck::CheckPriceWasTradedWithSet(void) 
   {
      double high = this._pg.HighestPrice(this._barsMissed);
      double low = this._pg.LowestPrice(this._barsMissed);             
      bool missed=false;    
      if(high> this._tradeOpenPrice && this._tradeOpenPrice>low && high>0 && low>0 && this._tradeOpenPrice > 0)
      {                
            Print( " Level was traded in last ",this._barsMissed," bars: _tradeOpenlPrice ",_tradeOpenPrice ," high ",high," low ", low);
            missed=true;
      }
      
      if(missed)
      {
        _ti.Set_tradeWasOpened(true);
      }
      
     return missed;      
   }