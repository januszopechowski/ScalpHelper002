 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// abstract signal class
class TrendSignal
  {
  
public:
                     TrendSignal();
                    ~TrendSignal();



                    virtual int GetTrendSide(){ Print("call to TrendSignal::GetTrendSide");  return 0;}
                    virtual int ClosePosition(){return true;}
                    virtual double GetRisk(){return 0;}
                    virtual double GetQuoteForOpen(){return 0;}


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TrendSignal::TrendSignal()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TrendSignal::~TrendSignal()
  {
  }
//+------------------------------------------------------------------+
