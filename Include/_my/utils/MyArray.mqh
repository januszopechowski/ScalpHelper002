//+------------------------------------------------------------------+
//|                                                      MyArray.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Arrays\ArrayObj.mqh>
#include <Arrays\Array.mqh>


class MyArray: public  CArrayObj
{
public :






bool DestroyWhenDelete;





void Destroy() ;

MyArray()
{
   DestroyWhenDelete = true;
}

~MyArray()
{
   if(DestroyWhenDelete)
   {
      Destroy();
   }
}


};

void MyArray::Destroy() 
  { 
//--- service pointer for working in the loop 
   CObject* item; 
   int n = this.Total();
   for( int i = 0 ;i < n;++i)
   {
      item = this.Next();
      if(CheckPointer(item)!=POINTER_INVALID)
      {
         delete item;
      }
   }
   
   
   
//--- 
  }