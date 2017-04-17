

// check  price relation now and after
 
  #include <_my\utils\PriceGetter.mqh>
  #include  <_my\ScalpTools\TradeOpenInfo.mqh>

//
// sprawdzam czy cena poszla 
// nie kompletnie i cofnela sie
//
//  #include <_my\ScalpTools\checkers\LevelRelationToCurrentPriceCheck.mqh>
//
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LevelRelationToCurrentPriceCheck
  {
protected:
   // check info
   bool _isBidAboveLevelBegining;
   bool _isBidAboveLevel;
   double _priceLevel;
   PriceGetter* _pg;
   
public:
                     LevelRelationToCurrentPriceCheck();
                    ~LevelRelationToCurrentPriceCheck();
                    void ComposeMessage(PriceGetter* pg);
                    void SetLevelPriceWithRelationToBid(double d)
                    {                    
                     _priceLevel = d;
                     SetLevelRelationToBid(true);                     
                    
                    }
                    void SetLevelRelationToBid(bool initial)
                    {
                    
                     bool isBidAboveLevel =
                    
                     
                     _isBidAboveLevelBegining
                     
                    }
                    
                    
                    
  };
  
  
void LevelRelationToCurrentPriceCheck::ComposeMessage(PriceGetter* pg)
{

   _pg = pg;


}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LevelRelationToCurrentPriceCheck::LevelRelationToCurrentPriceCheck()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LevelRelationToCurrentPriceCheck::~LevelRelationToCurrentPriceCheck()
  {
  }
//+------------------------------------------------------------------+
