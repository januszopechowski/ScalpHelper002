
// check  price relation now and after
 
  #include <_my\utils\PriceGetter.mqh>

//
//  #include <_my\ScalpTools\checkers\PriceMoveCheck.mqh>
//
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PriceMoveCheck
  {
  
protected:
   // check info
   PriceGetter* _pg;
   double _pipsToSkip;    // spip unneccessary constant move pips
   double _pip;
   
   // bunch of variables that are importand for skipping ticks
   double _price1Prev;
   double _price1;
   double _price1Diff;
   int _skippedTicks;       
   
public:
                     PriceMoveCheck(PriceGetter* pg,double pipsToSkip);
                    ~PriceMoveCheck();                    
                    bool PriceHasMovedByRequiredDistance();
  };
  
  bool PriceMoveCheck::PriceHasMovedByRequiredDistance(void)
  {
   
  
   //_price1Prev = _price1;
   _price1=_pg.Get_Bid();
   _price1Diff =_pg.GetNormalized(MyMath::Abs(_price1-_price1Prev ));
   bool ok = _price1Diff>_pip*_pipsToSkip;
   if(ok)
   {
      _price1Prev = _price1;
      _skippedTicks=0;
      return true;
   }
   else
   
   {
     // Print("Heartbea ScalpHelper002 _skippedTicks",_skippedTicks, " _price1Diff ",_price1Diff," _price1 ",_price1," _price1Prev ",_price1Prev);
      _skippedTicks++;
      return false;
   }
}
  
void PriceMoveCheck::PriceMoveCheck(PriceGetter* pg,double pipsToSkip)
{

   _pg = pg;
   _pipsToSkip=pipsToSkip;

_price1=_pg.Get_Bid();
_price1Prev=_price1;
_price1Diff=0;
_skippedTicks = 0;       
_pip = _pg.GetPipPriceFraction();


}
//--------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PriceMoveCheck::~PriceMoveCheck()
  {
  }
//+------------------------------------------------------------------+
