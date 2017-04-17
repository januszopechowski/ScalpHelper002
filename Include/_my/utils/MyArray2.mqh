//+------------------------------------------------------------------+
//|                                                     MyArray2.mqh |
//|                                                              JPO |
//|  http://forex-strategies-revealed.com/trading-strategy-basicbala |
//+------------------------------------------------------------------+
#property copyright "JPO"
#property link      "http://forex-strategies-revealed.com/trading-strategy-basicbala"
#property version   "1.00"
#property strict
#include  <Arrays\List.mqh>
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MyArray2 : public CList
  {
private:

public:
                     MyArray2();
                    ~MyArray2();
                    void Destroy();
  };
  
  
void MyArray2::Destroy(void){
 
//--- service pointer to work in a loop
   CObject* item;
//--- go through the loop and try to delete dynamic pointers
int n = this.Total();
item = this.GetFirstNode();  
   //while(CheckPointer(m_items)!=POINTER_INVALID)
   for(int i = 0;i<n;++i)
     {
      
    //  if(CheckPointer(item)==POINTER_DYNAMIC)
        {
       //  Print("Dynamyc object to be deleted");
         delete item;
        }
        item = this.GetNextNode();  
     // else Print("Non-dynamic object cannot be deleted");
     }
//---
  
}  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyArray2::MyArray2()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyArray2::~MyArray2()
  {
      Destroy();
  }
//+------------------------------------------------------------------+
