//+------------------------------------------------------------------+
//|                                       OrderSendSimple.mqh |
//|                                               Copyright 2015, JO |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+

  
 #include<_my\utils\PriceGetter.mqh>
 #include<_my\OrderManagement\OrdersNumberCalculator.mqh>
 #include <_my\utils\UtilsTrading.mqh>
 #include <_my\utils\MyMath.mqh>
 //OrderManagement
//
//
//#include<_my\OrderManagement\OrderSendSimple.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
// 

   enum ENUM_RISK_TYPE 
   {
      cash_amt=0,
      account_percent=1
   };




//modifier
class OrderSendSimple //: public BaseTradingPortfolio
  {
bool printit;   
protected:
   // side - 0,1 off , on
   int      _magicNumber;
   bool _checkIfOrdersNumberIsExceeded;
 
   
   int _maxSlippage;
   double _maxSpreadInPips;
            
   
   string   _symbol;
   string   _comment;
   double   _risk;
   ENUM_RISK_TYPE _riskType;
   PriceGetter* _prices;
   OrdersNumberCalculator *_oc;
   //int _side;// -1 short, 1 long
   
   double _orderExpirationInSeconds;
 
 
   bool _closeTradeWhenInLoss;
   
public:

   void Set_printit(bool b){this.printit=b;}
   int Get_magicNumber(){return _magicNumber;}
   PriceGetter* Get_prices(){return _prices;}

   OrdersNumberCalculator* GetOrderCalc(){return this._oc;}

  //void Set_orderExpirationInSeconds(double b){this._orderExpirationInSeconds=b; }
  //void Set_orderExpirationInMinutes(double b){this._orderExpirationInSeconds=b*60; }
  void Set_orderExpirationInBars(double b){
  
      this._orderExpirationInSeconds= NormalizeDouble(b*60* ((int)this._prices.GetPeriod()),0); 
  
      if(this._orderExpirationInSeconds<3600)
      {
         Print( "Expitation less than hour. Setting expiration time slightly above 1 h");
         this._orderExpirationInSeconds=3614;
      }
  }
   void Set_checkIfOrdersNumberIsExceeded(bool b){_checkIfOrdersNumberIsExceeded=b;}
   void Set_closeTradeWhenInLoss(bool b){this._closeTradeWhenInLoss=b; }
   
   void Set_orderComment(string b){this._comment=b; }
   string Get_orderComment(){return this._comment; }
      
     void Set_maxSlippage(int b){this._maxSlippage=b; }
     void Set_maxSpreadInPips(double b){this._maxSpreadInPips=b; }
      void Set_riskType(ENUM_RISK_TYPE b){this._riskType=b; }



                     OrderSendSimple(string symbol,ENUM_TIMEFRAMES period,int magicNumber,double risk);                     
                    ~OrderSendSimple();
                    // set tp equal to 2nd bollinger band when one trade is left
                    void CheckForClose(double targetQuote); 
                    
                    //otwiera pare orderow dla zadanych parametrow tp i sl
                    virtual void OpenOrdersForInputParams(int side,double sl,double tp,bool testmode,int maxOpenOrders);
                    virtual void OpenStopOrdersForInputParams(int side,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote);
                    virtual void OpenLimitOrdersForInputParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote);


                    virtual int OpenOrdersForInputIncrementParams(int side,double sl,double tp,bool testmode,int maxOpenOrders);
                    virtual void OpenStopOrdersForInputIncrementParams(int side,double sl,double tp,bool testmode,int maxOpenOrders);
                    virtual int OpenLimitOrdersForInputIncrementParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders);

                    virtual void OpenStopOrdersForInputIncrementParams(int side,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote);
                    virtual int OpenLimitOrdersForInputIncrementParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote);




                    bool CloseAll();         
                    bool CloseAllIfInProfit();// close if in  profit           
                    bool DeleteAllPendings();
                    virtual int OpenOrdersByType( int tradeOperation,int side,double sl,double tp,double price,double lots );
                    virtual void OpenStopOrders( int side,double sl,double tp,double price,double lots );                    
                    virtual int OpenLimitOrders( int side,double sl,double tp,double price,double lots );                    
                    
                    virtual int OpenOrders( int side, double sl, double tp, double price, double lots  );
                    //virtual void OpenOrdersF( int side, double sl, double tp, double price, double lots  );
/*
                    int OrderOpenF(string     OO_symbol,
               int        OO_cmd,
               double     OO_volume,
               double     OO_price,
               int        OO_slippage,
               double     OO_stoploss,
               double     OO_takeprofit,
               string     OO_comment,
               int        OO_magic,
               datetime   OO_expiration,
               color      OO_arrow_color);       
*/
                    
//
//
//check for open - moze uzywac algosow roznych - wirtualna albo strategia
//
// calc 
// calcsize - moze uzywac roznych ,obecnie 2 procent wartosci portfela, do przeladowania
// calc entrypoint
// calc stoploss
// calc  
protected:      
       // 0.0001 for eurusd or 0.01 for usdjpy
       //
       // open order
       virtual datetime GetExpiration(){
            if(_orderExpirationInSeconds <= 0.0)
            {
               return 0;
            }
            else
            {
               datetime expDate = (datetime)(this._prices.Get_Time()+ this._orderExpirationInSeconds);  
               return expDate;
               
           }
       } // forever
       // size according to risk
       virtual double GetLotSize(double slpips,int side);             
       
       
      virtual double GetRiskInCash();
      
static int OrderOpenF(string     OO_symbol,
               int        OO_cmd,
               double     OO_volume,
               double     OO_price,
               int        OO_slippage,
               double     OO_stoploss,
               double     OO_takeprofit,
               string     OO_comment,
               int        OO_magic,
               datetime   OO_expiration,
               color      OO_arrow_color);       
       
  };
  
  double OrderSendSimple::GetRiskInCash()
  {
   
      double cashAtRisk=0;//this._risk>1.0 ? this._risk : NormalizeDouble((AccountFreeMargin()*this._risk),2);
       if(this._riskType== ENUM_RISK_TYPE::cash_amt)
       {     
            cashAtRisk= this._risk;
        }    
       else if(this._riskType== ENUM_RISK_TYPE::account_percent)
       {
            cashAtRisk=NormalizeDouble(this._risk*0.01  * AccountFreeMargin(),2);            
       }     
     //  Print("cashAtRisk ",cashAtRisk);
        return cashAtRisk;
   }  
  
double OrderSendSimple::GetLotSize(double slpips,int side)
{
      double cashAtRisk= this.GetRiskInCash();//this._risk>1.0 ? this._risk : NormalizeDouble((AccountFreeMargin()*this._risk),2);
      double div = slpips*this._prices.GetPipPLNValue()  ;
      
      
      double nlots =  div==0.0? this._prices.Get_MinLotSize() : (cashAtRisk/div);      
      
      double nlots2=UtilsTrading::FixUpLotSize(nlots,_symbol);
      
      return (nlots2);
}
 
void OrderSendSimple::OpenOrdersForInputParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders)
{
      int side=0;
      
      if(side1>0)
      {
         side=1; 
      }
      else if(side1<0)
      {
         side=-1;
      }
      else
      {
         Print("  Exit:  OpenOrdersForInputParams : side ",side1);
         return;
      }

      //
      //
      double pips  =this._prices.GetPipPriceFraction();
      //double point  =this._prices.Get_Point();
      double open  = this._prices.GetCurrentQuoteForOpen(side);
      double slpips = MathAbs(open -sl)/pips;
 
      double nlots = NormalizeDouble(MathAbs(GetLotSize(slpips,side)),2);
      double nlotsMin= NormalizeDouble(MathAbs(this._prices.Get_MinLotSize()),2);
      //      
      
      
      if (nlots<nlotsMin) {
         Print ("OrderSendSimple::OpenOrdersForInputParams :   Lot Size is too small ,quitting lot size/lot size min : ",nlots ," / ", nlotsMin);
         return;
      
      }
      
      
      
      
      int digits= this._prices.GetDigits();
      double maxSpread = NormalizeDouble(this._maxSpreadInPips*pips,digits);
      double spread = NormalizeDouble(this._prices.GetSpreadInPriceFraction(),digits);      
      if(spread/maxSpread>1.05 )
      {
      Print ("OrderSendSimple::OpenOrdersForInputParams :   Spread is too big ,quitting spread/spread max : ",spread ," / ", maxSpread);
         return;
      }
      
      
      
      //
      //
      
      if (testmode) {return;}
      
      
      
      //
      //
      //if(this._oc.IsAnyOrderPresent())
      if(_checkIfOrdersNumberIsExceeded)
      if(this._oc.CalculateCurrentOrders()>maxOpenOrders)
               { 
                  Print(" OrderSendSimple::OpenOrdersForInputParams : orders open, cant open when any open order exists"); 
                  return;
               }
      //
      // methods set side
      OpenOrders(side,sl,tp ,open,nlots);
      //
      //if(this._oc.IsAnyOrderPresent())               
      { 
     //    this._side=side;return; 
      }
      //
}//M


void OrderSendSimple::OpenStopOrdersForInputParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote)
{
      int side=0;
      
      if(side1>0)
      {
         side=1; 
      }
      else if(side1<0)
      {
         side=-1;
      }
      else
      {
         Print("  Exit:  OpenOrdersForInputParams : side ",side1);
         return;
      }

      //
      //
      double pips  =this._prices.GetPipPriceFraction();
      //double point  =this._prices.Get_Point();
      double open  =openQuote;
      double slpips = MathAbs(open -sl)/pips;
 
      double nlots = NormalizeDouble(MathAbs(GetLotSize(slpips,side)),2);
      double nlotsMin= NormalizeDouble(MathAbs(this._prices.Get_MinLotSize()),2);
      //      
      
      
      if (nlots<nlotsMin) {
         Print ("OrderSendSimple::OpenOrdersForInputParams :   Lot Size is too small ,quitting lot size/lot size min : ",nlots ," / ", nlotsMin);
         return;
      
      }
      
      
      
      
      int digits= this._prices.GetDigits();
      double maxSpread = NormalizeDouble(this._maxSpreadInPips*pips,digits);
      double spread = NormalizeDouble(this._prices.GetSpreadInPriceFraction(),digits);      
      if(spread/maxSpread>1.05 )
      {
      Print ("OrderSendSimple::OpenOrdersForInputParams :   Spread is too big ,quitting spread/spread max : ",spread ," / ", maxSpread);
         return;
      }
      
      
      
      //
      //
      
      if (testmode) {return;}
      
      
      
      //
      //
      //if(this._oc.IsAnyOrderPresent())
            if(_checkIfOrdersNumberIsExceeded)
            {
      int currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
      if(currentOrdersNum >maxOpenOrders)
               { 
                  Print(" OrderSendSimple::OpenOrdersForInputParams : orders open, cant open when any open order exists"); 
                  return;
               }
            }
      //
      // methods set side
      OpenStopOrders(side,sl,tp ,open,nlots);
      //
     // currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
     // if(currentOrdersNum >0)               
      { 
    //     this._side=side;return; 
      }
      //
}//M

void OrderSendSimple::OpenLimitOrdersForInputParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote)
{
      int side=0;
      
      if(side1>0)
      {
         side=1; 
      }
      else if(side1<0)
      {
         side=-1;
      }
      else
      {
         Print("  Exit:  OpenLimitOrdersForInputParams : side ",side1);
         return;
      }

      //
      //
      double pips  =this._prices.GetPipPriceFraction();
      //double point  =this._prices.Get_Point();
      double open  = openQuote;
      double slpips = MathAbs(open-sl)/pips;
 
      double nlots = NormalizeDouble(MathAbs(GetLotSize(slpips,side)),2);
      double nlotsMin= NormalizeDouble(MathAbs(this._prices.Get_MinLotSize()),2);
      //      
      
      
      if (nlots<nlotsMin) {
         Print ("OrderSendSimple::OpenOrdersForInputParams :   Lot Size is too small ,quitting lot size/lot size min : ",nlots ," / ", nlotsMin);
         return;
      
      }
      
      
      
      
      int digits= this._prices.GetDigits();
      double maxSpread = NormalizeDouble(this._maxSpreadInPips*pips,digits);
      double spread = NormalizeDouble(this._prices.GetSpreadInPriceFraction(),digits);      
      if(spread/maxSpread>1.05 )
      {
      Print ("OrderSendSimple::OpenOrdersForInputParams :   Spread is too big ,quitting spread/spread max : ",spread ," / ", maxSpread);
         return;
      }
      
      
      
      //
      //
      
      if (testmode) {return;}
      
      
      
      //
      //
      //if(this._oc.IsAnyOrderPresent())
            if(_checkIfOrdersNumberIsExceeded)
            {
      int currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
      if(currentOrdersNum >maxOpenOrders)
               { 
                  Print(" OrderSendSimple::OpenOrdersForInputParams : orders open, cant open when any open order exists"); 
                  return;
               }
            }
      //
      // methods set side
      OpenLimitOrders(side,sl,tp ,open,nlots);
      //
   //   currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
 //     if(currentOrdersNum >0)               
      { 
   //      this._side=side;return; 
      }
      //
}//M


int OrderSendSimple::OpenOrdersByType( int tradeOperation,int side,double sl2,double tp2,double price2,double lots )
{


double sl = this._prices.GetNormalized(sl2);
double tp = this._prices.GetNormalized(tp2);
double price = this._prices.GetNormalized(price2);
double minSL = this._prices.GetNormalized(this._prices.Get_StopLevelDistance());
double diffSLPrice = MyMath::Abs(price-sl);

if(diffSLPrice<minSL)
{
   Print("SL too small  diff:",diffSLPrice," min diff",minSL);
   return 0;
}

 int ticket;
            lots  = NormalizeDouble(MyMath::Abs(lots),2);
               int maxNcloseTry = 50;
               int closeTry;

               closeTry = 1;
               while
               ( 
                  (closeTry++<=maxNcloseTry) && 
                  (
                  
            (ticket=OrderSend(this._symbol,tradeOperation ,lots ,price,this._maxSlippage,sl,tp,_comment,this._magicNumber,GetExpiration(),Blue))
                  == (-1)
                  )
               )
               {
                  Print("OrderSend error " ,GetLastError(), ",try: ", closeTry);
                  Print(
                     this._symbol + 
                      " tradeop "+  ((string)tradeOperation)  
                     +" lots "   + ((string)lots)
                     +" price "  + ((string)price) 
                     +" slip "   + ((string)_maxSlippage)
                     +" sl: "    + ((string)sl)
                     +" tp: "    +((string)tp)
                     );
                     Print(
                     " comment " +((string)_comment)
                     +"mnum "     +((string)this._magicNumber)
                     +" expiration "         +(TimeToString(GetExpiration(),TIME_DATE|TIME_MINUTES))
                     );
                     Print(
                     " Blue "
                     +" bid " + (string)this._prices.Get_Bid()
                     +" ask " + (string)this._prices.Get_Ask()

                     );
                  
               }
               if(closeTry>maxNcloseTry){    Print("OrderSend error : Order Not send " );
                                             return -1;
                                        }

return ticket;
}



int OrderSendSimple::OpenOrders( int side,double sl,double tp,double price,double lots )
{
  //Print(" sending market order : side ",side, ",sl ",sl,", tp ",tp," , price open",price," lots ",lots);

         int tradeOperation=0;// buy
         if(side<0)
            {
               tradeOperation = 1;// sell
            }

return OpenOrdersByType( tradeOperation,side,sl,tp,price,lots );
} 
  
void OrderSendSimple::OpenStopOrders( int side,double sl,double tp,double price,double lots )
{
 Print(" sending stop order : side ",side, ",sl ",sl,", tp ",tp," , price open",price," lots ",lots);

         int tradeOperation=4;// buy stop
         if(side<0)
            {
               tradeOperation = 5;// sell stop
            }

OpenOrdersByType( tradeOperation,side,sl,tp,price,lots );
            
}


       
int OrderSendSimple::OpenLimitOrders( int side,double sl,double tp,double price,double lots )
{ 
 
//OP_BUYLIMIT
 //2 
//Buy limit pending order 
//OP_SELLLIMIT 
//3 
//Sell limit pending order
 
Print(" sending limit : side ",side, ",sl ",sl,", tp ",tp," , price open",price," lots ",lots);
         int tradeOperation=2;// buy limit
         if(side<0)
            {
               tradeOperation = 3;// sell limit
            }

return OpenOrdersByType( tradeOperation,side,sl,tp,price,lots );
            
}
                   
 
 
  
bool OrderSendSimple::CloseAllIfInProfit()
  {
  //int MAGICMA = this._magicNumber;
  
  bool result = true;
  int closeTry,maxNcloseTry=50;
  double tradePrice; 
   int side;
   
   
   
   
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
     
      
      {
         if(OrderMagicNumber()!=this._magicNumber || OrderSymbol()!=this._symbol) continue;
                  
         // odwrotnie do otwierania
         if(OrderType()==OP_BUY)
         {
            side=1;
         }
         else if(OrderType()==OP_SELL)
         {
            side=-1;
         } 
         else 
         { 
            Print("Pendingsh sholuldnt be here");
            continue;// pendings? ..
         }  
         
              tradePrice = this._prices.GetCurrentQuoteForClose(side);
              double openPrice = OrderOpenPrice();
              if(!this._closeTradeWhenInLoss)
              {
                 if( !( (side==1 && openPrice<=tradePrice) || (side==-1 && openPrice>=tradePrice ) ) )
                 {
                     Print(
                      "Cant close because in loss :",
                      OrderProfit(), " ticket ", 
                      OrderTicket(),
                      " open price " ,OrderOpenPrice(), 
                      " trade price ",tradePrice,
                      " sl ", OrderStopLoss(),
                      " tp ",OrderTakeProfit(),
                      " all side ",   (string)this._oc.Get_TradesSideBuySellOrZeroOrTwo(false)     
                      +" bid " + (string)this._prices.Get_Bid()
                      +" ask " + (string)this._prices.Get_Ask()

                       );
                     continue;
                 }
              }
              
              
              
               closeTry=0;
               while( (closeTry++<=maxNcloseTry) && !OrderClose(OrderTicket(),OrderLots(),tradePrice,3,White))
               {
                  Print("OrderClose error ",GetLastError());
               }
               if(closeTry>maxNcloseTry)
               {
                    Print("OrderClose error : cant close");
                     Print(
                      "Cant close because error :",
                      OrderProfit(), " ticket ", 
                      OrderTicket(),
                      " open price " ,OrderOpenPrice(), 
                      " trade price ",tradePrice,
                      " sl ", OrderStopLoss(),
                      " tp ",OrderTakeProfit(),
                      " all side ",  (string) this._oc.Get_TradesSideBuySellOrZeroOrTwo(false)     
                        ," bid ",  (string)this._prices.Get_Bid()
                       ," ask " , (string)this._prices.Get_Ask()

                       );

                    result = false;                    
               }
               else
               {
                  i=-1;// aby i++ i bylo zero
               }
              
               
            
           
        }// for js symbols
        
     }// for i orders total

    //  if(result)
   //   {  
   //         _side=0;// strona pusta
    //  }
   return (result);  
  } 
 

   

bool OrderSendSimple::CloseAll()
  {
  //int MAGICMA = this._magicNumber;
  
  bool result = true;
  int closeTry,maxNcloseTry=51;
  double tradePrice; 
   int side;
   
   
   
   
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
     
      
      {
         if(OrderMagicNumber()!=this._magicNumber || OrderSymbol()!=this._symbol) continue;
                  
         // odwrotnie do otwierania
         if(OrderType()==OP_BUY)
         {
            side=1;
         }
         else if(OrderType()==OP_SELL)
         {
            side=-1;
         } 
         else 
         { 
            Print("Pendingsh sholuldnt be here");
            continue;// pendings? ..
         }  
         
              tradePrice = this._prices.GetCurrentQuoteForClose(side);
              
               closeTry=0;
               while( (closeTry++<=maxNcloseTry) && !OrderClose(OrderTicket(),OrderLots(),tradePrice,_maxSlippage,White))
               {
                  Print("OrderClose error ",GetLastError());
               }
               if(closeTry>maxNcloseTry)
               {
                    
                    Print("OrderClose error : cant close");
                    result = false;                    
               }
               else
               {
                  i=-1;// aby i++ i bylo zero
               }
              
               
            
           
        }// for js symbols
        
     }// for i orders total

   //   if(result)
      {  
   //         _side=0;// strona pusta
      }
   return (result);  
  } 
 

bool OrderSendSimple::DeleteAllPendings()
  {
  //int MAGICMA = this._magicNumber;
  
  bool result = true;
  int closeTry,maxNcloseTry=6;
   
   for(int i=0;i<OrdersTotal();i++)
     {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
         //        
         //for (int js =jsStart;js<jsEnd;++js)
         {
                  if(OrderMagicNumber()!=this._magicNumber || OrderSymbol()!=this._symbol) continue;
                  //
                  // odwrotnie do otwierania
                  if(OrderType()==OP_BUY || OrderType()==OP_SELL)
                  {                     
                     continue;
                  }
                  
               closeTry=0;
               while( (closeTry++<=maxNcloseTry) && !OrderDelete(OrderTicket()))
               {
                 // if(printit)
                  {
                  Print("DeleteAllPendings  error " +((string)GetLastError()) + " try number : "+ IntegerToString(closeTry));
                  Print(
                     this._symbol + 
                     " OrderTicket "  +  ((string)OrderTicket())
                     + " OrderType "  +  ((string)OrderType())                     
                     +" White ");                  
                  }
               }
               if(closeTry>maxNcloseTry){result = false;}                                          
         }// for js symbols
        
     }// for i orders total
   //this._side=0;
   return (result);  
  } 

  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderSendSimple::OrderSendSimple(string symbol,ENUM_TIMEFRAMES period,int magicNumber,double risk)
  {  
   this.printit=false;
   this._orderExpirationInSeconds=0; // wazne!
   this._maxSlippage=1;
   this._maxSpreadInPips=1;
   this._riskType = 0;
   this._prices= new PriceGetter(symbol,period);
   this._oc= new OrdersNumberCalculator(symbol,magicNumber);
   this._magicNumber  = magicNumber;
   this._symbol = symbol;  
   this._comment = "OrderSendSimple";
   this._risk = risk;   
   this._closeTradeWhenInLoss=false;// dont close trade in a loss   
   this._checkIfOrdersNumberIsExceeded=true;
  }
  
  
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderSendSimple::~OrderSendSimple(){
  //if(_prices!=NULL)
  {
   delete _prices;
   }
  if(_oc!=NULL)
  {
   delete _oc;   
   }
  

  
 }//C
  
//+------------------------------------------------------------------+
//+---------------------------------------------------------------------------------------------------------------------+
//| The function opens or sets an order                                                                                 |
//| symbol      - symbol, at which a deal is performed.                                                                 |
//| cmd         - a deal Can have any value of trade operations.                                                        |
//| volume      - amount of lots.                                                                                       |
//| price       - Open price.                                                                                           |
//| slippage    - maximum price deviation for market buy or sell orders.         |
//| stoploss    - position close price when an unprofitability level is reached (0 if there is no unprofitability level)|
//| takeprofit  - position close price when a profitability level is reached (0 if there is no profitability level).    |
//| comment     - order comment. The last part of comment can be changed by the trade server.                           |
//| magic       - order magic number. Can be used as an identifier determined by user.                                  |
//| expiration  - pending order expiration time.                                                                        |
//| arrow_color - Opening arrow's color on the chart. If the parameter is missing or its value equals CLR_NONE          |
//|               then the opening arrow is not displayed on the chart.                                                 |
//+---------------------------------------------------------------------------------------------------------------------+
int OrderSendSimple::OrderOpenF(string     OO_symbol,
               int        OO_cmd,
               double     OO_volume,
               double     OO_price,
               int        OO_slippage,
               double     OO_stoploss,
               double     OO_takeprofit,
               string     OO_comment,
               int        OO_magic,
               datetime   OO_expiration,
               color      OO_arrow_color)
  {
   int      result      = -1;    //result of opening an order
   int      Error       = 0;     //error when opening an order
   int      attempt     = 0;     //amount of performed attempts
   int      attemptMax  = 3;     //maximum amount of attempts
   bool     exit_loop   = false; //exit the loop
   string   lang=TerminalInfoString(TERMINAL_LANGUAGE);  //trading terminal language, for defining the language of the messages
   double   stopllvl=NormalizeDouble(MarketInfo(OO_symbol,MODE_STOPLEVEL)*MarketInfo(OO_symbol,MODE_POINT),Digits);  //minimum stop loss/ take profit level, in points
                                                                                                                     //the module provides a safe order opening. 
//--- checking stop orders for buying
   if(OO_cmd==OP_BUY || OO_cmd==OP_BUYLIMIT || OO_cmd==OP_BUYSTOP)
     {
      double tp = (OO_takeprofit - OO_price)/MarketInfo(OO_symbol, MODE_POINT);
      double sl = (OO_price - OO_stoploss)/MarketInfo(OO_symbol, MODE_POINT);
      if(tp>0 && tp<=stopllvl)
        {
         OO_takeprofit=OO_price+stopllvl+2*MarketInfo(OO_symbol,MODE_POINT);
        }
      if(sl>0 && sl<=stopllvl)
        {
         OO_stoploss=OO_price -(stopllvl+2*MarketInfo(OO_symbol,MODE_POINT));
        }
     }
//--- checking stop orders for selling
   if(OO_cmd==OP_SELL || OO_cmd==OP_SELLLIMIT || OO_cmd==OP_SELLSTOP)
     {
      double tp = (OO_price - OO_takeprofit)/MarketInfo(OO_symbol, MODE_POINT);
      double sl = (OO_stoploss - OO_price)/MarketInfo(OO_symbol, MODE_POINT);
      if(tp>0 && tp<=stopllvl)
        {
         OO_takeprofit=OO_price -(stopllvl+2*MarketInfo(OO_symbol,MODE_POINT));
        }
      if(sl>0 && sl<=stopllvl)
        {
         OO_stoploss=OO_price+stopllvl+2*MarketInfo(OO_symbol,MODE_POINT);
        }
     }
//--- while loop
   while(!exit_loop)
     {
      result=OrderSend(OO_symbol,OO_cmd,OO_volume,OO_price,OO_slippage,OO_stoploss,OO_takeprofit,OO_comment,OO_magic,OO_expiration,OO_arrow_color); //attempt to open an order using the specified parameters
      //--- if there is an error when opening an order
      if(result<0)
        {
         Error = GetLastError();                                     //assign a code to an error
         switch(Error)                                               //error enumeration
           {                                                         //order closing error enumeration and an attempt to fix them
            case  2:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;                                 //define one more attempt
                  Sleep(3000);                                       //3 seconds of delay
                  RefreshRates();
                  break;                                             //exit switch
                 }
               if(attempt==attemptMax)
                 {
                  attempt=0;                                         //reset the amount of attempts to zero 
                  exit_loop = true;                                  //exit while
                  break;                                             //exit switch
                 }
            case  3:
               RefreshRates();
               exit_loop = true;                                     //exit while
               break;                                                //exit switch   
            case  4:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;                                 //define one more attempt
                  Sleep(3000);                                       //3 seconds of delay
                  RefreshRates();
                  break;                                             //exit switch
                 }
               if(attempt==attemptMax)
                 {
                  attempt = 0;                                       //reset the amount of attempts to zero 
                  exit_loop = true;                                  //exit while
                  break;                                             //exit switch
                 }
            case  5:
               exit_loop = true;                                     //exit while
               break;                                                //exit switch   
            case  6:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;                                 //define one more attempt
                  Sleep(5000);                                       //3 seconds of delay
                  break;                                             //exit switch
                 }
               if(attempt==attemptMax)
                 {
                  attempt = 0;                                       //reset the amount of attempts to zero 
                  exit_loop = true;                                  //exit while
                  break;                                             //exit switch
                 }
            case  8:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;                                 //define one more attempt
                  Sleep(7000);                                       //3 seconds of delay
                  break;                                             //exit switch
                 }
               if(attempt==attemptMax)
                 {
                  attempt = 0;                                       //reset the amount of attempts to zero 
                  exit_loop = true;                                  //exit while
                  break;                                             //exit switch
                 }
            case 64:
               exit_loop = true;                                     //exit while
               break;                                                //exit switch
            case 65:
               exit_loop = true;                                     //exit while
               break;                                                //exit switch
            case 128:
               Sleep(3000);
               RefreshRates();
               continue;                                             //exit switch
            case 129:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;                                 //define one more attempt
                  Sleep(3000);                                       //3 seconds of delay
                  RefreshRates();
                  break;                                             //exit switch
                 }
               if(attempt==attemptMax)
                 {
                  attempt = 0;                                       //reset the amount of attempts to zero 
                  exit_loop = true;                                  //exit while
                  break;                                             //exit switch
                 }
            case 130:
               exit_loop=true;                                       //exit while
               break;
            case 131:
               exit_loop = true;                                     //exit while
               break;                                                //exit switch
            case 132:
               Sleep(10000);                                         //sleep for 10 seconds
               RefreshRates();                                       //update data
                                                                     //exit_loop = true;                                   //exit while
               break;                                                //exit switch
            case 133:
               exit_loop=true;                                       //exit while
               break;                                                //exit switch
            case 134:
               exit_loop=true;                                       //exit while
               break;                                                //exit switch
            case 135:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;                                 //define one more attempt
                  RefreshRates();
                  break;                                             //exit switch
                 }
               if(attempt==attemptMax)
                 {
                  attempt = 0;                                       //reset the amount of attempts to zero 
                  exit_loop = true;                                  //exit while
                  break;                                             //exit switch
                 }
            case 136:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;                                 //define one more attempt
                  RefreshRates();
                  break;                                             //exit switch
                 }
               if(attempt==attemptMax)
                 {
                  attempt = 0;                                       //reset the amount of attempts to zero 
                  exit_loop = true;                                  //exit while
                  break;                                             //exit switch
                 }
            case 137:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;
                  Sleep(2000);
                  RefreshRates();
                  break;
                 }
               if(attempt==attemptMax)
                 {
                  attempt=0;
                  exit_loop=true;
                  break;
                 }
            case 138:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;
                  Sleep(1000);
                  RefreshRates();
                  break;
                 }
               if(attempt==attemptMax)
                 {
                  attempt=0;
                  exit_loop=true;
                  break;
                 }
            case 139:
               exit_loop=true;
               break;
            case 141:
               Sleep(5000);
               exit_loop=true;
               break;
            case 145:
               exit_loop=true;
               break;
            case 146:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;
                  Sleep(2000);
                  RefreshRates();
                  break;
                 }
               if(attempt==attemptMax)
                 {
                  attempt=0;
                  exit_loop=true;
                  break;
                 }
            case 147:
               if(attempt<attemptMax)
                 {
                  attempt=attempt+1;
                  OO_expiration=0;
                  break;
                 }
               if(attempt==attemptMax)
                 {
                  attempt=0;
                  exit_loop=true;
                  break;
                 }
            case 148:
               exit_loop=true;
               break;
            default:
               Print("Error: ",Error);
               exit_loop=true; //exit while 
               break;          //other options 
           }
        }
      //--- if no errors detected
      else
        {
         if(lang == "Russian") {Print ("The order is successfully opened. ", result);}
         if(lang == "English") {Print("The order is successfully opened.", result);}
         Error = 0;                                //reset the error code to zero
         break;                                    //exit while
                                                   //errorCount =0;                          //reset the amount of attempts to zero
        }
     }
   return(result);
  }
//+------------------------------------------------------------------+

int OrderSendSimple::OpenOrdersForInputIncrementParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders)
{
        sl=MyMath::Abs(sl);
        tp=MyMath::Abs(tp);

      int side=0;
      
      if(side1>0)
      {
         side=1; 
      }
      else if(side1<0)
      {
         side=-1;
      }
      else
      {
         Print("  Exit:  OpenOrdersForInputParams : side ",side1);
         return -1;
      }
      //
      //
      double pips  =this._prices.GetPipPriceFraction();
      //double point  =this._prices.Get_Point();
      double open  = this._prices.GetCurrentQuoteForOpen(side);
      double slprice = open +  (side>0?(-sl) :(sl));
      double tpprice = (tp==0)?0 :  (open +  (side>0?(tp) :(-tp))) ;
      
      
      double slpips = MathAbs(sl)/pips;
 
      double nlots = NormalizeDouble(MathAbs(GetLotSize(slpips,side)),2);
      double nlotsMin= NormalizeDouble(MathAbs(this._prices.Get_MinLotSize()),2);
      //      
      
      
      if (nlots<nlotsMin) {
         Print ("OrderSendSimple::OpenOrdersForInputParams :   Lot Size is too small ,quitting lot size/lot size min : ",nlots ," / ", nlotsMin);
         return -1;      
      }
      
      
      int digits= this._prices.GetDigits();
      double maxSpread = NormalizeDouble(this._maxSpreadInPips*pips,digits);
      double spread = NormalizeDouble(this._prices.GetSpreadInPriceFraction(),digits);      
      if(spread/maxSpread>1.05 )
      {
         if(printit)
         Print ("OrderSendSimple::OpenOrdersForInputParams :   Spread is too big ,quitting spread/spread max : ",spread ," / ", maxSpread);
         return -1;
      }
      //
      //      
      if (testmode) {return -1;}
      
      
      
      //
      //
      //if(this._oc.IsAnyOrderPresent())
            if(_checkIfOrdersNumberIsExceeded)
            {
            
               if(this._oc.CalculateCurrentOrders()>maxOpenOrders)
               {
                  Print(" OrderSendSimple::OpenOrdersForInputParams : orders open, cant open when any open order exists"); 
                  return -1;               
               }               
            }
    // methods set side
     return OpenOrders(side,slprice,tpprice ,open,nlots);
    //
    //  if(this._oc.IsAnyOrderPresent())               
    //  { 
    //    this._side=side;return; 
    //  }
    //
}//M

void OrderSendSimple::OpenStopOrdersForInputIncrementParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders)
{
double openQuote = this._prices.GetCurrentQuoteForOpen(side1);
OpenStopOrdersForInputIncrementParams(side1,sl,tp,testmode,maxOpenOrders,openQuote);

}

void OrderSendSimple::OpenStopOrdersForInputIncrementParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote)
{

        sl=MyMath::Abs(sl);
        tp=MyMath::Abs(tp);
      int side=0;
      
      if(side1>0)
      {
         side=1; 
      }
      else if(side1<0)
      {
         side=-1;
      }
      else
      {
         Print("  Exit:  OpenOrdersForInputParams : side ",side1);
         return;
      }

      //
      //
      double pips  =this._prices.GetPipPriceFraction();
      //double point  =this._prices.Get_Point();
      double open  =openQuote;
      double slpips = MathAbs(sl)/pips;
      
      double slprice = open +  (side>0?(-MathAbs(sl)) :(MathAbs(sl))) ;
      double tpprice = this._prices.GetNormalized(tp)==this._prices.GetNormalized(0)?0 :  (open +  (side>0?(tp) :(-tp))) ;

       
 
      double nlots = NormalizeDouble(MathAbs(GetLotSize(slpips,side)),2);
      double nlotsMin= NormalizeDouble(MathAbs(this._prices.Get_MinLotSize()),2);
      //      
      
      
      if (nlots<nlotsMin) {
         Print ("OrderSendSimple::OpenOrdersForInputParams :   Lot Size is too small ,quitting lot size/lot size min : ",nlots ," / ", nlotsMin);
         return;
      
      }
      
      
      
      
      int digits= this._prices.GetDigits();
      double maxSpread = NormalizeDouble(this._maxSpreadInPips*pips,digits);
      double spread = NormalizeDouble(this._prices.GetSpreadInPriceFraction(),digits);      
      if(spread/maxSpread>1.05 )
      {
      Print ("OrderSendSimple::OpenOrdersForInputParams :   Spread is too big ,quitting spread/spread max : ",spread ," / ", maxSpread);
         return;
      }
      
      
      
      //
      //
      
      if (testmode) {return;}
      
      
      
      //
      //
      //if(this._oc.IsAnyOrderPresent())
      if(_checkIfOrdersNumberIsExceeded)
      {
      int currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
      if(currentOrdersNum >=maxOpenOrders)
               { 
                  Print(" OrderSendSimple::OpenOrdersForInputParams : orders open, cant open when any open order exists"); 
                  return;
               }
      }
      //
      // methods set side
      OpenStopOrders(side,slprice,tpprice ,open,nlots);
      //
    //  currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
    //  if(currentOrdersNum >0)               
      { 
     //    this._side=side;return; 
      }
      //
}//M


int  OrderSendSimple::OpenLimitOrdersForInputIncrementParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders)
{
double openQuote = this._prices.GetCurrentQuoteForOpen(side1);
return OpenLimitOrdersForInputIncrementParams(side1,sl,tp,testmode,maxOpenOrders,openQuote);

}


int OrderSendSimple::OpenLimitOrdersForInputIncrementParams(int side1,double sl,double tp,bool testmode,int maxOpenOrders,double openQuote)
{
        sl=MyMath::Abs(sl);
        tp=MyMath::Abs(tp);

      int side=0;
      int ticket=-1;
      
      if(side1>0)
      {
         side=1; 
      }
      else if(side1<0)
      {
         side=-1;
      }
      else
      {
         Print("  Exit:  OpenLimitOrdersForInputParams : side ",side1);
         return ticket;
      }

      //
      //
      double pips  =this._prices.GetPipPriceFraction();
      //double point  =this._prices.Get_Point();
      double open  = openQuote;
  
 
      double slpips = MathAbs(sl)/pips;


      double slprice = open +  ((side>0?(-sl) :(sl))) ;
      double tpprice = (tp==0)?0 :  (open +  (side>0?(tp) :(-tp))) ;
 
 
 
      double nlots = NormalizeDouble(MathAbs(GetLotSize(slpips,side)),2);
      double nlotsMin= NormalizeDouble(MathAbs(this._prices.Get_MinLotSize()),2);
      //      
      
      
      if (nlots<nlotsMin) {
         Print ("OrderSendSimple::OpenOrdersForInputParams :   Lot Size is too small ,quitting lot size/lot size min : ",nlots ," / ", nlotsMin);
         return ticket;
      
      }
      
      
      
      
      int digits= this._prices.GetDigits();
      double maxSpread = NormalizeDouble(this._maxSpreadInPips*pips,digits);
      double spread = NormalizeDouble(this._prices.GetSpreadInPriceFraction(),digits);      
      if(spread/maxSpread>1.05 )
      {
      Print ("OrderSendSimple::OpenOrdersForInputParams :   Spread is too big ,quitting spread/spread max : ",spread ," / ", maxSpread);
         return ticket;
      }
      
      
      
      //
      //
      
      if (testmode) {return ticket;}
      
      
      
      //
      //
      //if(this._oc.IsAnyOrderPresent())
      //int currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
      //if(currentOrdersNum >maxOpenOrders)
               { 
        //          Print(" OrderSendSimple::OpenOrdersForInputParams : orders open, cant open when any open order exists"); 
         //         return ticket;
               }
      //
      // methods set side
      return OpenLimitOrders(side,slprice,tpprice ,open,nlots);
      //
    //  currentOrdersNum = this._oc.CalculateCurrentOrders() + this._oc.CalculateCurrentOrdersPending();
    //  if(currentOrdersNum >0)               
    //  { 
    //     this._side=side;return; 
     // }
      //
}//M
