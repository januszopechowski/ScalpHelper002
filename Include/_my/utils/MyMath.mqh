//+------------------------------------------------------------------+
//|                                                       MyMath.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
/*
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property version   "1.00"
#property strict
*/

// #include <_my\utils\MyMath.mqh>
struct Line2D
{
// kolejnosc pol tutaj wazna - spojrz na initializer
double x1;
double y1;
double x2;
double y2;

};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MyMath
  {
private:

public:
                     MyMath();
                    ~MyMath();
                    static double Pow(double aa,double exponent){return MathPow(aa,exponent);}
                    static double Sqrt(double aa){return MathSqrt(aa);}
                    static double Abs(double aa){return MathAbs(aa);}
                    static int Abs(int aa){return MathAbs(aa);}
                    static double Max(double aa,double exponent){return MathMax(aa,exponent);}
                    static double Min(double aa,double exponent){return MathMin(aa,exponent);}

                    static double Atan(double aa){return MathArctan(aa);}
                    // equidistant in x points
                    // y distance differs
                    static double Angle(double line1_y1,double line1_y2,double line2_y1,double line2_y2,double deltax);


                    
  };
  
  
  
  
                    double MyMath::Angle(double line1_y1,double line1_y2,double line2_y1,double line2_y2,double deltax)
                    {  /* 
                      Line2D line1
                            ,line2;
                         
                            // x comparable to y
                            // fake numbers
                            line1.x1=0;
                            line1.x2=1;
                            line2.x1=0;
                            line2.x2=1;
                           
                            
                      line1.y1 = line1_y1;
                      line1.y2 = line1_y2;
                      line2.y1 = line2_y1;
                      line2.y2 = line2_y2;
                      
                    
     double slope1 = (line1.y1 - line1.y2)  / (line1.x1 - line1.x2);
     double slope2 = (line2.y1 - line2.y2)  / (line2.x1 - line2.x2);
     
     double div =(1 - (slope1 * slope2));
     double atanV  = 0;
     if(div!=0)
     {
     
     
     atanV  = MyMath::Atan((slope1 - slope2) / div);
    }
    */     
    
     double slope1 = (line1_y1 - line1_y2)/deltax;
     double slope2 = (line2_y1 - line2_y2)/deltax;
     double atanV =  MyMath::Atan(slope1) -  MyMath::Atan(slope2);
     double angle  = atanV/ 3.1415*180.0;
  //  Print( " Atan Angle degrees",angle);
    return angle;
}                    
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyMath::MyMath()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyMath::~MyMath()
  {
  }
//+------------------------------------------------------------------+
