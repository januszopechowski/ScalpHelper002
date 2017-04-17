//+------------------------------------------------------------------+
//|                                                     NewPrint.mqh |
//|                                                              JPO |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#import "kernel32.dll"
    void OutputDebugStringW(string sMsg);
    void OutputDebugStringA(uchar& szAnsiStr[]);
#import

//------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NewPrint
  {
  
  //const string z="";
  
  // true - print to windows
  // false - print  to print      
  static  int Get_PrintSrc(){ return (int)GlobalVariableGet("NewPrint_PrintSrc");} 
  static  void Set_PrintSrc(int v){ GlobalVariableSet("NewPrint_PrintSrc",(double)v);} 


  static  int Get_PrintItFlag(){ return (int)GlobalVariableGet("NewPrint_PrintItFlag");} 
  static  void Set_PrintItFlag(int v){ GlobalVariableSet("NewPrint_PrintItFlag",(double)v);}   
   
public:  
  static void InitToMTLog(){Set_PrintSrc(1);}
  static void InitToWindows(){Set_PrintSrc(1);}
  
  static void ShowPrintOut(){Set_PrintSrc(1);}
  static void DoNotShowPrintOut(){Set_PrintSrc(0);}
  
  
             //        NewPrint();
               //     ~NewPrint();                    



   static  void PrintIt(string s)                   
   {   
      if(Get_PrintItFlag()==0)
      {
         return;
      }   
    //
    //uchar szAnsiStr[];
    //StringToCharArray(s,szAnsiStr);
    //OutputDebugStringA(szAnsiStr); 
    //OutputDebugStringW("Unicode strings for unicode functions");   
    //
    if(Get_PrintSrc()==1)
    {
       OutputDebugStringW(s);    
    }
    else
    {
      Print(s);
    }
    
   }
    
   void PrintIt(string s,string s1){PrintIt(s+s1);}
   void PrintIt(string s,string s1,string s2){PrintIt(s+s1+s2);}
   void PrintIt(string s,string s1,string s2,string s3){PrintIt(s+s1+s2+s3);}
   //void PrintItSpaced(string s,string s1,string s2,string s3){PrintIt(s+" "+s1+" "+s2+" "+s3);}
   void PrintItSpaced(string s,string s1="",string s2="",string s3="",string s4="",string s5="",string s6=""){PrintIt(s+" "+s1+" "+s2+" "+s3+" "+s4+" "+s5+" "+s6);}
                    
  };
  
  
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//NewPrint::NewPrint()  {  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//NewPrint::~NewPrint()  {  }
//+------------------------------------------------------------------+
