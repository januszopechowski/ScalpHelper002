//+------------------------------------------------------------------+
//|                                                  OrdersNumberCalculator.mqh |
//|                                              Copyright 2015, JPO |
//|                                       januszopechowski@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, JPO"
#property link      "januszopechowski@yahoo.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// #include<_my\OrderManagement\OrdersNumberCalculator.mqh>



class OrdersNumberCalculator
  {
private:  
      int _sellOrders;//used by CalculateCurrentOrders
      int _buyOrders;  //used by CalculateCurrentOrders
      int _sellOrdersPending;//used by CalculateCurrentOrders
      int _buyOrdersPending;  //used by CalculateCurrentOrders

protected:
      // side - 0,1 off , on
      int      _magicNumber;
      string   _symbol;
public:
                     string   Get_symbol(){return this._symbol;}                     
                     int      Get_magicNumber(){return this._magicNumber;}                     
                     double   Get_buyOrders(){return this._buyOrders;}                     //CalculateCurrentOrders
                     double   Get_sellOrders(){return this._sellOrders;}                       //CalculateCurrentOrders
                     int   Get_BuySellOrders(){return this._sellOrders + this._buyOrders;}                       //CalculateCurrentOrders
                     double   Get_buyOrdersPending(){return this._buyOrdersPending;}                     //CalculateCurrentOrders
                     double   Get_sellOrdersPending(){return this._sellOrdersPending;}                       //CalculateCurrentOrders
                     double   Get_BuySellOrdersPending(){return this._sellOrdersPending + this._buyOrdersPending;}                       //CalculateCurrentOrders

                     int      Get_TradesSideBuySellOrZeroOrTwo(bool notRecalc); // 0 none,1 buy,-1 sell,2mix
                     int      Get_TradesPendingSideBuySellOrZeroOrTwo(bool notRecalc); // 0 none,1 buy,-1 sell,2mix
                     
public:
                     OrdersNumberCalculator(string symbol,int magicNumber);
                    ~OrdersNumberCalculator();
                    int CalculateCurrentOrders();
                    int CalculateCurrentOrdersPending();
                    int CalculateCurrentOrdersOpenAndPending();
                    bool IsAnyOrderPresent();                    
                    int  Get_TradesSideOpenAndPendingBuySellOrZeroOrTwo(bool notRecalc);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrdersNumberCalculator::OrdersNumberCalculator(string symbol,int magicNumber)
  {
  this._symbol = symbol;
  this._magicNumber = magicNumber;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrdersNumberCalculator::~OrdersNumberCalculator()
  {
  }
//+------------------------------------------------------------------+
//
int  OrdersNumberCalculator::Get_TradesSideOpenAndPendingBuySellOrZeroOrTwo(bool notRecalc)
{  
   int os = Get_TradesSideBuySellOrZeroOrTwo(notRecalc);
   if(os==0)
      os =Get_TradesPendingSideBuySellOrZeroOrTwo(notRecalc);
      
   return os;
}



int  OrdersNumberCalculator::Get_TradesSideBuySellOrZeroOrTwo(bool notRecalc)
{  
   if(notRecalc == false)
   {
      CalculateCurrentOrders();// init numbers 
   }
   int result=0;
   if(this.Get_BuySellOrders()>0 && this._sellOrders>0 && this._buyOrders==0) result= -1;
   
   if(this.Get_BuySellOrders()>0 && this._buyOrders>0 && this._sellOrders==0) result= 1;
   
   if(this.Get_BuySellOrders()>0 && this._buyOrders>0 && this._sellOrders>0) result= 2;
   
   return result;      
}
 
int  OrdersNumberCalculator::Get_TradesPendingSideBuySellOrZeroOrTwo(bool notRecalc)
{  
   if(notRecalc == false)
   {
      CalculateCurrentOrdersPending();// init numbers 
   }
   int result=0;
   if(this.Get_buyOrdersPending()>0 && this._sellOrdersPending>0 && this._buyOrdersPending==0) result= -1;
   
   if(this.Get_BuySellOrdersPending()>0 && this._buyOrdersPending>0 && this._sellOrdersPending==0) result= 1;
   
   if(this.Get_BuySellOrdersPending()>0 && this._buyOrdersPending>0 && this._sellOrdersPending>0) result= 2;
   
   return result;      
}
  
  bool OrdersNumberCalculator::IsAnyOrderPresent()
  {
     int ntrades=0;      
     return (CalculateCurrentOrders()!=0);
  }  
  
  int OrdersNumberCalculator::CalculateCurrentOrders()
  {
     int ntrades=0;     
     this._sellOrders=0;
     this._buyOrders=0;
     int ot;
     for(int i=0;i<OrdersTotal();i++)
     {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         {
            break;
         }     
         if(OrderMagicNumber()!=_magicNumber || OrderSymbol()!=_symbol) 
         {
            continue;
         }  
         
             ot =  OrderType();     
            if(ot!= OP_BUY &&  ot!= OP_SELL ) 
            {
               continue;
            }

            if(ot== OP_BUY ) 
            {
               this._buyOrders++;
            }
            
            if(ot== OP_SELL ) 
            {
               this._sellOrders++;
            }
            // liczysz ordersy total ?
            ntrades++;             
                  
     }// for i orders total     
      return (_buyOrders+_sellOrders);
  }
  
int OrdersNumberCalculator::CalculateCurrentOrdersPending()
  {
        int ntrades=0;     
        for(int i=0;i<OrdersTotal();i++)
        {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
            {
               break;
            }     
            if(OrderMagicNumber()!=_magicNumber || OrderSymbol()!=_symbol) 
            {
               continue;
            }         
            if(OrderType()== OP_BUY &&  OrderType()== OP_SELL ) 
            {
               continue;
            }
            // liczysz pendingi
            ntrades++;
        }// for i orders total
      return (ntrades);
  }
    

int OrdersNumberCalculator::CalculateCurrentOrdersOpenAndPending()
  {
        int ntrades=0;     
        for(int i=0;i<OrdersTotal();i++)
        {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
            {
               break;
            }     
            if(OrderMagicNumber()!=_magicNumber || OrderSymbol()!=_symbol) 
            {
               continue;
            }         
//            if(OrderType()== OP_BUY &&  OrderType()== OP_SELL ) 
    //        {
  //             continue;
  //          }
            // liczysz pendingi
            ntrades++;
        }// for i orders total
      return (ntrades);
  }
        