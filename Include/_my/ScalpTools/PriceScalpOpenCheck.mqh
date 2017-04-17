 
 
 
  #include <_my\utils\PriceGetter.mqh>
  #include  <_my\ScalpTools\TradeOpenInfo.mqh>
  #include <_my\utils\MyMath.mqh>

//
// sprawdzam czy cena poszla 
// nie kompletnie i cofnela sie
//
//  #include <_my\ScalpTools\PriceScalpOpenCheck.mqh>
//
//
//
class  PriceScalpOpenCheck
{
   bool _isPriceInitiallyBelowLevelPrice;
   bool _isPriceBelowLevelPrice;
   bool _isPriceBelowLevelPriceBefore;
   
   double _openLevelNearDistancePips;// when price is near that price - open order
   
   
   int _barsMissed;
   double         _pip;// price fraction of a pip   
   TradeOpenInfo* _ti; 
   PriceGetter*   _pg;// price getter
  // double         _tradeLevelPrice;// trade at price
 //  int            _side;// short -1 or long 1 
  // bool           _advancedChecks;
   //double _prevPrice;
   double _currPrice; 
   
//   
//     
   bool PriceOpenShortAdvanced();
   bool PriceOpenLongAdvanced();
   bool PriceOpenShortSimple();
   bool PriceOpenLongSimple();
   
public:
   void Set_isPriceBelowLevelPrice();
   void Set_openLevelNearDistancePips(double b){_openLevelNearDistancePips=b;}



   PriceScalpOpenCheck(
         PriceGetter* pg//, /* double tradeLevelPrice,  int side, */ 
         ,TradeOpenInfo*  ti 
         );
   ~PriceScalpOpenCheck(){delete _ti;}
   bool OpenTrade();
   bool CheckTradePriceOpen();
  // void Set_advancedChecks(bool b){_advancedChecks=b;}
};

void PriceScalpOpenCheck::Set_isPriceBelowLevelPrice( )
{
       double quote = _pg.GetCurrentQuoteForOpen(_ti._tradeSide);
       
       if(this._ti.IsReadyForBeforeOpenCheck())
       {
        this._isPriceBelowLevelPriceBefore = this._isPriceBelowLevelPrice;
        this._isPriceBelowLevelPrice  = quote<_ti._tradeOpenPrice;
       // Print("Set_isPriceBelowLevelPrice : ", " Qoute ",quote," _tradeOpenPrice ",_ti._tradeOpenPrice," _isPriceBelowLevelPriceBefore  ",_isPriceBelowLevelPriceBefore," _isPriceBelowLevelPrice " ,_isPriceBelowLevelPrice );
        //if(_isPriceBelowLevelPrice!=_isPriceBelowLevelPriceBefore)        
        //{
         //Print("Set_isPriceBelowLevelPrice : _isPriceBelowLevelPrice!=_isPriceBelowLevelPriceBefore ",_isPriceBelowLevelPrice," != ", _isPriceBelowLevelPriceBefore);
        //}
       }

}
   bool PriceScalpOpenCheck::CheckTradePriceOpen()
   {
   
      int side = this._ti._tradeSide;
      bool open=false;
      
      if(!_ti.IsReadyForBeforeOpenCheck())
      {
         return false;
      }
     // _missedLevelRetracePrice = _pg.GetNormalized( _missedLevelPrice  +  _pip*((double)missedLevelRetracePips)*((double)_side)) ;
     /*
     if(this._advancedChecks)
     {
         if(side>0)
         {
            open= PriceOpenLongAdvanced();
         }      
         else if(side<0)
         {
            open =PriceOpenShortAdvanced();
         }
     }
     else 
     */
     
     Set_isPriceBelowLevelPrice();
     if(side!=0)
     {
       if((_isPriceBelowLevelPrice?0:1) != (this._isPriceBelowLevelPriceBefore?0:1))
       {
        // Print("CheckTradePriceOpen true due _isPriceBelowLevelPrice _isPriceBelowLevelPriceBefore" );
         open=true;
       }
       else // sprawdz dystans
       {       
          this._currPrice = this._pg.GetCurrentQuoteForOpen(_ti._tradeSide);
          double dist =  MyMath::Abs(this._currPrice - _ti._tradeOpenPrice);          
          open = _openLevelNearDistancePips*this._pip >dist;                                                                                                                         
         if(open )
         {
          //  Print("CheckTradePriceOpen true due _openLevelNearDistancePips this._currPrice: " ,this._currPrice,_ti._tradeOpenPrice," dist ",dist, " near dist ",_openLevelNearDistancePips*this._pip  );
         }
       }     
     }
     return open;      
   }
  
   PriceScalpOpenCheck::PriceScalpOpenCheck(PriceGetter* pg,TradeOpenInfo* ti )
   {   
      _pg               =  pg;
      _pip              = _pg.GetPipPriceFraction();
      _barsMissed=2;
      _ti=  ti;
        
       //Print(" ctor PriceScalpOpenCheck");
       Set_isPriceBelowLevelPrice(); 
       if(_ti.IsReadyForBeforeOpenCheck())
       {       
         this._isPriceBelowLevelPriceBefore = this._isPriceBelowLevelPrice;
         _isPriceInitiallyBelowLevelPrice   = this._isPriceBelowLevelPrice;
         double initialQoute = pg.GetCurrentQuoteForOpen(_ti._tradeSide);

         Print("_isPriceInitiallyBelowLevelPrice: ",_isPriceInitiallyBelowLevelPrice, " initialQoute ",initialQoute," _tradeOpenPrice ",_ti._tradeOpenPrice);
       }
      //this._advancedChecks=false;// not implemented other
      //this._currPrice = this._pg.GetCurrentQuoteForOpen(ti._tradeSide);
      //this._prevPrice = this._currPrice;

   }
   
    
     /*
   bool PriceScalpOpenCheck::PriceOpenShortAdvanced()
   {
 
      double high = this._pg.HighestPrice(this._barsMissed);
      double bidPrice = this._pg.Get_Bid();
      double missedLevelRetracePrice = 
      _pg.GetNormalized( high  -  _pip*_missedLevelRetracePips) ;
      
      
      if( (this._tradeLevelPrice < high) && (high>_missedLevelPrice)&&  (missedLevelRetracePrice > bidPrice) )
      {
         return true;
      }
      else 
      {
      return false;
      }
      
      return false;
   }
   */
   
 /*  
   bool PriceScalpOpenCheck::PriceOpenLongAdvanced()
   {
     return false;
   
      double low = this._pg.LowestPrice(this._barsMissed);
      double askPrice = this._pg.Get_Ask();
      double missedLevelRetracePrice = 
      _pg.GetNormalized( low  +  _pip*_missedLevelRetracePips);
      
      if( 
            (this._tradeLevelPrice < low) && 
      //   (low<_missedLevelPrice)&&  
            (missedLevelRetracePrice < askPrice) 
         )
      {
         return true;
      }
      else 
      {
         return false;
      }
      //double diffMin = 
      //double diff = this._tradeLevel - high;
      //if(diff>0 && diff<diffMin && )
  
   }
 */

/*
   bool PriceScalpOpenCheck::PriceOpenLongSimple()
   {
      double askPrice = this._pg.Get_Ask();
      this._prevPrice = this._currPrice;
      this._currPrice = askPrice;
      
      
      
      if( 
             (this._ti._tradeOpenPrice <= this._currPrice)  
          && 
             (   this._prevPrice < this._ti._tradeOpenPrice  )
          
        )
      {
         return true;
      }
      else 
      {
         return false;
      }
      
      
   }   

 
   
 


   bool PriceScalpOpenCheck::PriceOpenShortSimple()
   {
      double bidPrice = this._pg.Get_Bid();      
      this._prevPrice = this._currPrice;
      this._currPrice = bidPrice;
      
      if( 
            (this._ti._tradeOpenPrice >= _currPrice )
            &&
            ( this._prevPrice > this._ti._tradeOpenPrice )
            
        )
      {
         return true;
      }
      else 
      {
      return false;
      }
   }
   
   */