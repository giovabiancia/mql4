/*========DESCRI��O 3.0====== 

  
=======================*/

/*=======================================================ANOTA��ES========================================================

EA de ganho com GAP Hood INVERSO AUDUSD 15/04/16.

Pensar a possibilidade desse EA perguntar. martingale?true, false ent�o encerra na primeira ordem.
========================================================================================================================*/

static input string Option1 = "--------Options Basic";
extern int Slippage = 3;
extern int MagicNumber = 9090909; //BUY
extern int MagicNumber2 = 808080; //SELL
extern int StopLoss = 10;
extern int TakeProfit =10;
extern int Tralling = 5;
extern double Lots = 0.01;
extern double LotsMult = 0.02;

static input string Option2 = "--------Options Martingale";
extern double LotsMultMartingale = 0.06;
extern int MaxOrders = 100;

static input string Option3 = "--------Other Options";
extern int PipsCandle=10;
extern int DistancePips=5;
extern int MinuteFinish = 6;


static input string CONTACT = "Help? Joaotorresmarques1@Gmail.com";

string Robo = "Robin Hood 1.0";
int ticket,takeBUY,takeSELL;
double iLots,lote;
datetime espera;





int OnInit()
{

 /*Comment(  "\n\n",
            "    Rob� ",Robo,"\n",
            "   ..................................................","\n\n",
            
            "    Moeda           ","        ",Symbol(),"\n",
            "    Spread          ","        ",Spread,"\n",
            "    Lot             ","        ",Lots,"\n",
            "    Lot Martingale  ","        ",LotsMultMartingale,"\n",
            
            "   ..................................................","\n\n",
            
           "    Valor Atual     ","         ",AccountBalance()," USD","\n",
           
           "   ...................................................","\n\n"
           
           "      HELP?      ","Joaotorresmarques1@Gmail.com","\n",
           
           
           );*/
           
return(INIT_SUCCEEDED);}
  
void OnTick()
  {     

//=========================POINT
      double MyPoint=Point;                                      
      if(Digits==3 || Digits==5) MyPoint=Point*10;   
   
//=========================CONTADOR DE ORDENS ABERTAS  
   int count,countsellstop,countbuystop,countsell,countbuy;
   
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) 
   {
      int a = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber2){
      
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
         if (OrderType() == OP_BUYLIMIT) countbuystop++; 
         if (OrderType() == OP_BUY) countbuy++;    
         }
         
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber){
      
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
         if (OrderType() == OP_SELLLIMIT) countsellstop++; 
         if (OrderType() == OP_SELL) countsell++;    
         }
   } 


//=========================LOTES
      if(count<5)   iLots = count*LotsMult;
      if(count>=5 && count<=11)  iLots = count*LotsMultMartingale;
      
     
//++++++++++++++++++++++++++++++++++++++++++++++++++++ENCERRAR TODAS AS ORDENS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

         static int closedOrders=0;
         if(OrdersHistoryTotal()!=closedOrders)
         {
            closedOrders=OrdersHistoryTotal();
            int hstTotal = OrdersHistoryTotal(); 
        
            if(OrderSelect(hstTotal-1,SELECT_BY_POS,MODE_HISTORY))
            {
               if(OrderMagicNumber()==MagicNumber2)
               {  

                  if(OrderType()==OP_BUY)
                  {
                     if(OrderOpenPrice()<OrderClosePrice())  bool STOPTUDOb = true; espera = OrderCloseTime()+MinuteFinish*60;

                  }//FIM OP_BUY
                     
               }//FIM MAGICNUMBER 
               
               if(OrderMagicNumber()==MagicNumber)
               {  
                  if(OrderType()==OP_SELL)
                  { 
                     if(OrderOpenPrice()>OrderClosePrice())   bool STOPTUDO2 = true; espera = OrderCloseTime()+MinuteFinish*60;

                  }//FIM OP_SELL
                  }
           }//FIM ORDERSELECT
        }//FIM ORDERHISTORY 
            
            int v, totalv=OrdersTotal();
            for(int i=OrdersTotal()-1; i>=0; i--)   
            {
               if(OrderSelect(v,SELECT_BY_POS)==true)
               {
                  if(OrderMagicNumber()==MagicNumber2)
                  {  
                     
                     if(OrderType()==OP_BUY)
                     {
                        if(STOPTUDOb==true)  ticket = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrPink);
                     }   
                  
                  }//FIM ORDERMAGIC 
                  
                  
                  if(OrderMagicNumber()==MagicNumber)
                  {  if(OrderType()==OP_SELL )
                     {
                      if(STOPTUDO2==true)  ticket = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrPink);
                     }
                     }
                }//FIM SELECT 
           
            }//FIM CONTADOR  
     
              
                           
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ABERTURA ORDEM++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
 
  if(TimeCurrent()>espera)
  {
    if((countbuy==0 && countbuystop==0) && (countsell==0 && countsellstop==0)  )
    {
         if(Ask-PipsCandle*MyPoint>Open[0])
         {
            ticket = OrderSend(Symbol(), OP_SELLLIMIT,Lots,Close[0]+DistancePips*MyPoint,Slippage,0,0,Robo,MagicNumber,0,Red);
            ticket = OrderSend(Symbol(),OP_BUYLIMIT,Lots,Open[0]-DistancePips*MyPoint,Slippage,0,0,Robo,MagicNumber2,0,Blue);
         } 
      }   
   
    }//FIM BUYSTOP
    
    if((countsell==0 && countsellstop==0) && (countbuy==0 && countbuystop==0))
    {
      if(Bid+PipsCandle*MyPoint<Open[0])
      {
          ticket = OrderSend(Symbol(), OP_SELLLIMIT,Lots,Open[0]+DistancePips*MyPoint,Slippage,0,0,Robo,MagicNumber,0,Red);
          ticket = OrderSend(Symbol(),OP_BUYLIMIT,Lots,Close[0]-DistancePips*MyPoint,Slippage,0,0,Robo,MagicNumber2,0,Blue);
          
      }        
      
    } 

//++++++++++++++++++++++++++++++++++++++++++++++++++ENCERRAR ORDENS PENDENTES++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    for (int trade7=OrdersTotal()-1; trade7>=0; trade7--) 
   {
      if (OrderSelect(trade7,SELECT_BY_POS, MODE_TRADES)) 
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         {    
            if(OrderType()==OP_SELLLIMIT)
            {   
               if(OrderOpenTime()<Time[0]-MinuteFinish*60) ticket = OrderDelete(OrderTicket(),Green);  
            }//FIM OP_BUYSTOP
            
           }
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber2)
            {  
            if(OrderType()==OP_BUYLIMIT)
            {  
               if(OrderOpenTime()<Time[0]-MinuteFinish*60) ticket = OrderDelete(OrderTicket(),Green); 
            }//FIM OP_SELLSTOP
             
         }//FIM MAGIC
      }//FIM ORDERSELECT
    }//FIM CONTADOR
    
  
//=========================CONFIGURA��O DE TAKES   
    switch(countsell) 
   {
      case 0: takeSELL = TakeProfit;   break;
      case 1: takeSELL = TakeProfit*1; break;
      case 2: takeSELL = TakeProfit*1; break;
      case 3: takeSELL = TakeProfit*1; break;
      case 4: takeSELL = TakeProfit*1; break;
      case 5: takeSELL = TakeProfit*1; break;
      case 6: takeSELL = TakeProfit*2; break;
      case 7: takeSELL = TakeProfit*2; break;
      case 8: takeSELL = TakeProfit*2; break;
      case 9: takeSELL = TakeProfit*2; break;
      
      
   }     
   
   if(countsell >= 10) takeSELL = TakeProfit*3; 
   
    switch(countbuy) 
   {
      case 0: takeBUY = TakeProfit;   break;
      case 1: takeBUY = TakeProfit*1; break;
      case 2: takeBUY = TakeProfit*1; break;
      case 3: takeBUY = TakeProfit*1; break;
      case 4: takeBUY = TakeProfit*1; break;
      case 5: takeBUY = TakeProfit*1; break;
      case 6: takeBUY = TakeProfit*2; break;
      case 7: takeBUY = TakeProfit*2; break;
      case 8: takeBUY = TakeProfit*2; break;
      case 9: takeBUY = TakeProfit*2; break;
     
      
      
   } 
   if(countbuy >= 10) takeBUY = TakeProfit*3;
   
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++TRALLING STOP+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
    for (int trade3=OrdersTotal()-1; trade3>=0; trade3--) 
    {
      if (OrderSelect(trade3,SELECT_BY_POS, MODE_TRADES)) 
      {
         if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicNumber || OrderMagicNumber()==MagicNumber2) )
         {  
               if(OrderType()==OP_BUY)
               {
                  double stnewpricebuy = OrderOpenPrice();
                  double SL = OrderStopLoss();
                  
                  if(SL==0 && Ask+takeBUY*MyPoint>stnewpricebuy) ticket = OrderModify(OrderTicket(),OrderOpenPrice(),stnewpricebuy+takeBUY*MyPoint,0,0,clrLightGreen);
                  
                  if(SL>0 && (OrderStopLoss()<(Ask+Tralling*MyPoint)))   ticket = OrderModify(OrderTicket(),OrderOpenPrice(),SL+Tralling*MyPoint,0,0,clrLightGreen);
                  
  
               }//FIM OP_BUY
               
                if(OrderType()==OP_SELL)
                {
                  double stnewpricesell = OrderOpenPrice();
                  double SLsell = OrderStopLoss();
               
                  if(SLsell==0 && Bid-takeSELL*MyPoint<stnewpricesell) ticket = OrderModify(OrderTicket(),OrderOpenPrice(),stnewpricesell-takeSELL*MyPoint,0,0,clrLightGreen);
                  
                  if(SLsell>0 && (OrderStopLoss()>(Bid-Tralling*MyPoint)))   ticket = OrderModify(OrderTicket(),OrderOpenPrice(),SLsell-Tralling*MyPoint,0,0,clrLightGreen);

               
               }//FIM OP_SELL
               
          }//FIM MAGIC
        }//FIM SELECT
    }//FIM CONTADOR  
    
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ENVIO DE ORDEM MARTINGAE++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
   if(count<MaxOrders)
   {       
   for (int trade1=OrdersTotal()-1; trade1>=0; trade1--) 
   {
      if (OrderSelect(trade1,SELECT_BY_POS, MODE_TRADES)) 
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber2)
         {
                       
            if(OrderType()==OP_BUY)
            {
              if(Ask+StopLoss*MyPoint<OrderOpenPrice()) ticket = OrderSend(Symbol(),OP_BUY,iLots,Ask,Slippage,0,0,NULL,MagicNumber2,0,clrGreenYellow);
               break;                                                                           
            }//FIM OP_BUY 
           }
           
           
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         {
             if(OrderType()==OP_SELL)
             {
                if(Bid-StopLoss*MyPoint>OrderOpenPrice()) ticket = OrderSend(Symbol(),OP_SELL,iLots,Bid,Slippage,0,0,NULL,MagicNumber,0,clrGreenYellow);
                break; 
             }//FIM OP_SELL      
         }//FIM MAGICNUMBER 
      }//FIM ORDERSELECT     
   }//FIM CONTADOR  
}
   
  
   

  }//FIM ONTICK
  

