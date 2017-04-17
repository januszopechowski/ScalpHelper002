 

// #include <_my\utils\UtilsTrading.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


class UtilsTrading
  {

public:



                     UtilsTrading();
                    ~UtilsTrading();
   public:
   
   static int CalculateCurrentAllOrders(int _magicNumber , string _symbol);
   static int CalculateCurrentOpenOrders(int _magicNumber , string _symbol);
   static int CalculateCurrentPendingtOrders(int _magicNumber , string _symbol);
   static int UtilsTrading::DayOfWeek1(){return DayOfWeek();}
   static double MathAbs1(double v){return MathAbs(v);}
   static double FixUpLotSize(double lotcalculation,string symbol);
                    
                    
   static datetime GetNY1970Date(){datetime dt=D'1970.01.01 00:00'; return dt;};
   static datetime LastClosedOrderCloseTimeIfItWasALossOrGetNY1970Date(int _magicNumber , string _symbol);
   static double LastClosedTradeProfit(int magic,datetime dateStart,string symbol);
   static int IsLastClosedTradeInLoss(int magic, string symbol);

   static int  NumberOfLastClosedTradeInLoss(int magic, string symbol,int minNumProfits);
     
     
   static bool UtilsTrading::CloseSelectedOrder(int order_ticket,double nlots,int side,double tradePrice);
  };
  
bool UtilsTrading::CloseSelectedOrder(int order_ticket,double nlots,int side,double tradePrice)
{

               bool result = true;
               //if(nlots==0)
               //{
                  //nlots= OrderLots();
               //}
              //Print(" closing order ", order_ticket," profit ", OrderProfit());
              //double tradePrice = this._price.GetCurrentQuoteForClose(side);
               
               int closeTry=0;
               int maxNcloseTry=50;
               while( (closeTry++<=maxNcloseTry) && !OrderClose(order_ticket,nlots,tradePrice,3,White))
               {
                  Print("OrderClose error .. ",GetLastError());
               }
               if(closeTry>maxNcloseTry)
               {
                    Print("OrderClose error : cant close");
                    result = false;                    
               }
      
              return result;

}
  static double UtilsTrading::LastClosedTradeProfit(int magic,datetime dateStart,string symbol)
  {
   double profit=0;
   int maxi=10000;
for(int i=OrdersHistoryTotal()-1;i>=0;i--)
 {
   if(OrderSelect(i, SELECT_BY_POS,MODE_HISTORY))
   if(OrderSymbol()==symbol && OrderMagicNumber()==magic && dateStart<OrderOpenTime())
    {       
       if(OrderType()==OP_BUY || OrderType()==OP_SELL ) 
       {
         profit=OrderProfit();
         break;
       }
       
    }
    if(i>maxi)
    break;
 }
 return profit;
  }
  
  
 
  static int UtilsTrading::IsLastClosedTradeInLoss(int magic, string symbol)
  {
   
  bool result=false;
  int maxi=10000;
  double profit;
//  int nprofits2= nprofits;
     
   for(int i=OrdersHistoryTotal()-1;i>=0;i--)
    {
      if(OrderSelect(i, SELECT_BY_POS,MODE_HISTORY))
      if(OrderSymbol()==symbol && OrderMagicNumber()==magic  )
       {       
          if(OrderType()==OP_BUY || OrderType()==OP_SELL ) 
          {
            profit=OrderProfit();
            if(profit>0)
            {
               
               return false;
               
               
            }
            else
            {
               return true;
            }
          }      
       }
       if(i>maxi)
         break;
    }
   return result;
  }
  
  
   
   
  double UtilsTrading::FixUpLotSize(double lotcalculation,string symbol)
       {
         double   min_lot     = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
         double   max_lot     = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
         int      lotdigits   = (int) - MathLog(SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP));
         double   lots        = NormalizeDouble(lotcalculation, lotdigits);
         if (lots < min_lot) lots = min_lot;
         if (lots > max_lot) lots = max_lot;      
         
         /*
double lots      = 1.47;
    double lotstep   = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
    int lotdigits    = (int) - MathLog10(lotstep);
    double lotsdiff  = MathMod(lots, lotstep);

    Print ("Lots : ", DoubleToString(lots, 2));
    Print ("Symbol info lotstep : ", lotstep);

    Print ("Math Mod ", lotsdiff);
    Print ("Lots (mathmod) : ", lots - lotsdiff);

    Print ("Math Log - lotdigits : ", lotdigits);
    Print ("Lots (mathlog) : ", DoubleToString(lots, lotdigits));         
         */
         
         
       return lots;
       }

  
  int UtilsTrading::CalculateCurrentAllOrders(int magicNumber , string symbol)
  {
     int ntrades=0;     
     
     for(int i=0;i<OrdersTotal();i++)
     {
         if( OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false )
         {
            break;
         }     
         if(OrderMagicNumber()!=magicNumber || OrderSymbol()!=symbol) 
         {
            continue;
         }         
         // liczysz pendingi           
         ntrades++;                  
     }// for i orders total     
      return (ntrades);
  }

  int UtilsTrading::CalculateCurrentOpenOrders(int magicNumber , string symbol)
  {
     int ntrades=0;     int ot;// typ orderu
     
     for(int i=0;i<OrdersTotal();i++)
     {
         if( OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false )
         {
            break;
         }     
         if(OrderMagicNumber()!=magicNumber || OrderSymbol()!=symbol) 
         {
            continue;
         }         
             
            ot =  OrderType();     
            if(ot!= OP_BUY &&  ot!= OP_SELL ) 
            {
               continue;
            }
         
         // liczysz otwarte
         ntrades++;                  
     }// for i orders total     
      return (ntrades);
  }
  
  
   
   
  datetime UtilsTrading::LastClosedOrderCloseTimeIfItWasALossOrGetNY1970Date(int magicNumber , string symbol)
  {
     
          
     datetime dt=GetNY1970Date();
     


for(int i=OrdersHistoryTotal()-1;i>=0;i--)
 {
   if(!OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS,MODE_HISTORY))
   {
      continue;
   }
   
   if(OrderSymbol()==symbol && OrderMagicNumber()==magicNumber)
    { 
       //for buy order
       // find loss 
       if(
         (OrderType()==OP_BUY && OrderClosePrice()<OrderOpenPrice() ) 
         ||        
         (OrderType()==OP_SELL && OrderClosePrice()>OrderOpenPrice()) 
         )
         {
            dt= OrderCloseTime();
         }
         break;// last closed order and run away
         
    }
 }
     
     
 
      return dt;
  }
  
  
  
  int UtilsTrading::CalculateCurrentPendingtOrders(int magicNumber , string symbol)
  {
     int ntrades=0;     int ot;// typ orderu
     
     for(int i=0;i<OrdersTotal();i++)
     {
         if( OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false )
         {
            break;
         }     
         if(OrderMagicNumber()!=magicNumber || OrderSymbol()!=symbol) 
         {
            continue;
         }         
             
            ot =  OrderType(); 
            // pomijasz otwarte    
            if(ot== OP_BUY ||  ot== OP_SELL ) 
            {
               continue;
            }
         
         // liczysz pendingi
         ntrades++;                  
     }// for i orders total     
      return (ntrades);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UtilsTrading::UtilsTrading()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UtilsTrading::~UtilsTrading()
  {
  }
//+------------------------------------------------------------------+
