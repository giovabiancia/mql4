//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                      Copyright � 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Moving Average v.3.0. #150 only for EURUSD M1. 08.2006-12.2006" 
#property link      "http://automated-trading.narod.ru/"

#define MAGICMA  150
//����������� ������ ��������� ��� �����������
extern double Lots                       = 0.1;    //����������� ��������� 0.1
extern double LotMax                     = 1000;    //��������� ������������� ����
extern double MaximumRisk                = 0.105;  //����������� ��������� 0.02, �������� ��������� ��� 0.2 � 0.5, �������� ��� 0.6, �� ����� ���������
extern double DecreaseFactor             = 3;      //����������� ��������� 3
extern double MovingPeriod               = 13;      //����������� ��������� 12, �������� ������ ����� �� 13 � �������� ��� 1, ���� MaximumRisk=0.6 �� M5
extern double MovingShift                = 15;      //����������� ��������� 6
extern int    MODE_Op_Buy                = 1;      //����� ���������� ����������� �������� (Moving Average)...
extern int    MODE_Cl_Buy                = 1;      //...& 0-MODE_SMA, 1-MODE_EMA, 2-MODE_SMMA, 3-MODE_LWMA...
extern int    MODE_Op_Sell               = 2;      //...& MODE_SMA-������� ���������� �������, MODE_EMA-���������������� ���������� �������, MODE_SMMA-���������� ���������� �������, MODE_LWMA-�������-���������� ���������� �������
extern int    MODE_Cl_Sell               = 0;      //---||---...& ---||---
extern int    PriceConstantMAofOp_Buy    = 0;      //������� ���������-���� ��� ������� �����������...
extern int    PriceConstantMAofCl_Buy    = 0;      //...& 0-PRICE_CLOSE, 1-PRICE_OPEN, 2-PRICE_HIGH, 3-PRICE_LOW, 4-PRICE_MEDIAN, 5-PRICE_TYPICAL, 6-PRICE_WEIGHTED
extern int    PriceConstantMAofOp_Sell   = 0;      //...& PRICE_CLOSE-���� ��������, PRICE_OPEN-���� ��������, PRICE_HIGH-������������ ����, PRICE_LOW-����������� ����, PRICE_MEDIAN-������� ����, (high+low)/2, PRICE_TYPICAL-�������� ����, (high+low+close)/3, PRICE_WEIGHTED-���������� ���� ��������, (high+low+close+close)/4
extern int    PriceConstantMAofCl_Sell   = 4;      //---||---...& ---||---
extern int    Buy                        = 1;      //0-�� ��������� ������� Buy (����� ������������� ����� ��������� �������)
extern int    Sell                       = 1;      //0-�� ��������� ������� Sell (����� ������������� ����� ��������� �������)
extern int    MinAccountBalance          = 1;      //0-������� �� ������������ � ��� 0 ������� ����������. ������ ��� ������� � USD. ��������� ��������������� ������� ��� ����������� ��������� FreeMargin. MinAccountBalance-��� �������� FreeMargin ��� �������� ������� � �������������� �������� �������.
extern int    VolumeLot                  = 100000; //����� ���� ��� ������� ����������� � ��������� EURUSD.
extern int    ConsiderPricelosingOrder   = 1;      //To consider the price of closing of the order-��������� ���� �������� ������ (0-�� ���������, ������ 0-���������)
extern int    ToOpenOrdersWithEqualLots  = 1;      //��������� ������ � ������� ������
//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//---- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//---- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) { Print("Error in history!"); break; }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) continue;
         //----
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1) lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
      if(lot<0.1) lot=0.1;
     }
//---- return lot size
   if(lot>LotMax) lot=LotMax;
   
     if(OrderSelect(SELECT_BY_POS,MODE_TRADES)==true)
   {
   if(ToOpenOrdersWithEqualLots>0 && (OrderLots()>lot || OrderLots()<lot))
   {
   lot=OrderLots();
   }
   }
   return(lot);
}
//+------------------------------------------------------------------+
//| Check for open order conditions                                  |
//+------------------------------------------------------------------+
void CheckForOpen()
  {
   double ma;
   int    res;
   double ocp1;
   double ocp2;
//---- go trading only for first tiks of new bar
   if(Volume[0]>1) return;
//---- get Moving Average 

//open Sell
   ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_Op_Sell,PriceConstantMAofOp_Sell,0);
//---- sell conditions
    int sells=0;
//----
   for(int i=0;i<OrdersTotal();i++)
       {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_SELL) sells++;
        }
        }
//��������� ���� �������� ������
        
        if(sells==0)
        {
        if(OrderSelect(HistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY)==true)
        {
        ocp2=OrderClosePrice();
        }
        }
//---- sell conditions 
 if(((ocp2<=Bid && ConsiderPricelosingOrder>=1)==true && Open[1]>ma && Close[1]<ma && sells<1 && Sell>=1) || (ConsiderPricelosingOrder<=0 && Open[1]>ma && Close[1]<ma && sells<1 && Sell>=1))
 {
 res=OrderSend(Symbol(),OP_SELL,LotsOptimized(),Bid,3,0,0,"",MAGICMA,0,Red);
 return;
 }

//open Buy 
 if(Volume[0]>1) return;
 ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_Op_Buy,PriceConstantMAofOp_Buy,0);
//---- sell conditions
    int buys=0;
//----
   for(int i2=0;i2<OrdersTotal();i2++)
       {
      if(OrderSelect(i2,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
        }
        }
//��������� ���� �������� ������
        if(buys==0)
        {
        if(OrderSelect(HistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY)==true)
        {
        ocp1=OrderClosePrice();
        }
        }
 //---- buy conditions
 if((((ocp1>=Ask || ocp1==0) && ConsiderPricelosingOrder>=1)==true && Open[1]<ma && Close[1]>ma && buys<1 && Buy>=1) || (ConsiderPricelosingOrder<=0 && Open[1]<ma && Close[1]>ma && buys<1 && Buy>=1))
 {
 res=OrderSend(Symbol(),OP_BUY,LotsOptimized(),Ask,3,0,0,"",MAGICMA,0,Blue);
 return;
 }
 
 if(MinAccountBalance>0)
 {
 if(OrderSelect(SELECT_BY_POS,MODE_TRADES)==true)
   {
   if(sells<1 && OrderType()==OP_BUY==true && OrderType()==OP_SELL==false && Bid*VolumeLot/AccountLeverage()*OrderLots()+MinAccountBalance>=AccountFreeMargin())
   {
   OrderSend(Symbol(),OP_SELL,OrderLots(),Bid,3,0,0,"",MAGICMA,0,DarkOrchid);
   Print("Sell ��� ����������� ��������� FreeMargin ������ ",AccountFreeMargin(),", # ",MAGICMA,", Ticket# ",OrderTicket());
   }
   }
   if(OrderSelect(SELECT_BY_POS,MODE_TRADES)==true)
   {
   if(buys<1 && OrderType()==OP_BUY==false && OrderType()==OP_SELL==true && Ask*VolumeLot/AccountLeverage()*OrderLots()+MinAccountBalance>=AccountFreeMargin())
   {
   OrderSend(Symbol(),OP_BUY,OrderLots(),Ask,3,0,0,"",MAGICMA,0,Orange);
   Print("Buy ��� ����������� ��������� FreeMargin ������ ",AccountFreeMargin(),", # ",MAGICMA,", Ticket# ",OrderTicket());
   }
   }
}
//----
  }
//+------------------------------------------------------------------+
//| Check for close order conditions                                 |
//+------------------------------------------------------------------+
void CheckForClose()
  {
//Close Buy
   double ma;
//---- go trading only for first tiks of new bar
   if(Volume[0]>1) return;
//---- get Moving Average 
   ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_Cl_Buy,PriceConstantMAofCl_Buy,0);
//----
   for(int i2=0;i2<OrdersTotal();i2++)
     {
      if(OrderSelect(i2,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
//---- check order type
 if(OrderType()==OP_BUY)
 {
 int Fa1;
 while(Fa1<1)
   {
   if (Open[1]>ma && Close[1]<ma && OrderProfit()>=0) OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
   break;
   }
 }
}
//Close Sell
   if(Volume[0]>1) return;

   ma=iMA(NULL,0,MovingPeriod,MovingShift,MODE_Cl_Sell,PriceConstantMAofCl_Sell,0);
//----
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)        break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
//---- check order type
 if(OrderType()==OP_SELL)
   {
  int Fa2;
  while(Fa2<1)    
    {
     if (Open[1]<ma && Close[1]>ma && OrderProfit()>=0) OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
     break;
}
}
}
//----
}
//+------------------------------------------------------------------+
//| Start function                                                   |
//+------------------------------------------------------------------+
void start()
  {
//---- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false) return;
CheckForOpen();
CheckForClose();
//----
  }
//+------------------------------------------------------------------+