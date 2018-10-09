

/*=======================================================ANOTAÇÕES========================================================


========================================================================================================================*/

static input string Option1 = "--------Options Basic";
extern int Slippage = 3;
extern int MagicNumber = 9090909; 

extern int MagicNumber2 = 808080;

extern int StopLoss = 10;
extern int TakeProfit = 10;
extern double Lots = 0.01;
extern int MinuteFinish = 50;




string Robo = "Novo EArsima";
int ticket;
double iLots;
datetime espera,newtime;




int ordembuy,ordemsell;

int OnInit(){return(INIT_SUCCEEDED);}

void OnTick()
{        
 
 int count,countbuy,countsell;
   
   for (int trade1=OrdersTotal()-1; trade1>=0; trade1--) 
   {
      if (OrderSelect(trade1,SELECT_BY_POS, MODE_TRADES)) 
      {  
         if(OrderMagicNumber()==MagicNumber)
         {
            if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
            if(OrderType()==OP_BUY) countbuy++;
            if(OrderType()==OP_SELL) countsell++;
         }   
    
     }
   }
       
//=========================CONFIGURAÇÃO DE LOTE    
 switch(count) 
   {
       case 0: iLots = Lots; break;
      case 1: iLots = 0.05; break;
      case 2: iLots = 0.09; break;
      case 3: iLots = 0.10; break;
      case 4: iLots = 0.20; break;
      case 5: iLots = 0.29; break;
      case 6: iLots = 0.50; break;
      case 7: iLots = 1.0; break;
      case 8: iLots = 2.0; break;
      case 9: iLots = 3.0; break;
      case 10: iLots = 3.5; break;
      case 11: iLots = 4.0; break;
      case 12: iLots = 4.5; break;
   }
      
      
   //++++++++++++++++++++++++++++++++++++++++++++++++++++ENCERRAR TODAS AS ORDENS+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 


         static int closedOrders=0;
         if(OrdersHistoryTotal()!=closedOrders)
         {
            closedOrders=OrdersHistoryTotal();
            int hstTotal = OrdersHistoryTotal(); 
        
            if(OrderSelect(hstTotal-1,SELECT_BY_POS,MODE_HISTORY))
            {
               if(OrderMagicNumber()==MagicNumber)
               {  
                  if(OrderType()==OP_BUY)
                  {
                     if(OrderOpenPrice()<OrderClosePrice()) bool STOPTUDOb = true; 
                    
                  }//FIM OP_BUY
                  
                  
               }//FIM MAGICNUMBER 
               
               if(OrderMagicNumber()==MagicNumber2)
               {  
                  
                  if(OrderType()==OP_SELL)
                  { 
                     if(OrderOpenPrice()>OrderClosePrice()) bool STOPTUDO2 = true;
                     
                  }//FIM OP_SELL
                     
               }//FIM MAGICNUMBER 
               
              
                
           }//FIM ORDERSELECT
        }//FIM ORDERHISTORY 
            
          
            for(int i=OrdersTotal()-1; i>=0; i--)   
            {
               if(OrderSelect(i,SELECT_BY_POS)==true)
               {
                  if(OrderMagicNumber()==MagicNumber)
                  {  
                     if(OrderType()==OP_BUY)
                     {
                        if(STOPTUDOb==true)  ticket = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrPink); espera = Time[0] + MinuteFinish*60;
                     }   
                     
                     
                  
                  }//FIM ORDERMAGIC
                  
                  if(OrderMagicNumber()==MagicNumber2)
                  {  
                    
                     if(OrderType()==OP_SELL )
                     {
                     
                      if(STOPTUDO2==true)  ticket = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrPink); espera = Time[0] + MinuteFinish*60;
                      
                     }
                  
                  }//FIM ORDERMAGIC
                  
                 
  
                }//FIM SELECT 
           
            }//FIM CONTADOR  
             
      
//=========================POINT
      double MyPoint=Point;                                      
      if(Digits==3 || Digits==5) MyPoint=Point*10;   
      
//=========================MEDIAS MOVEIS      
      double MA9 = iMA(Symbol(),NULL,9,0,MODE_EMA,PRICE_CLOSE,0);
      double MA14 = iMA(Symbol(),NULL,14,0,MODE_EMA,PRICE_CLOSE,0);
      double RSI = iRSI(Symbol(),NULL,14,PRICE_CLOSE,0);
      
      if(RSI<30 || RSI>70) espera = Time[0] + 30*60;       
       
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ABERTURA ORDEM MAGIC1 E MARTINGALE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                   
 ////BUY : MAGIC            || SELL: MAGIC2
  if(Time[0]>espera)
  {
      if(OrdersTotal()==0)
      { 
        if((MA9>MA14 && Open[0]>MA9 && RSI>50) || (MA9<MA14 && Open[0]<MA9 && RSI<50 ) )
        {
            ordembuy = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,Ask+TakeProfit*MyPoint,Robo,MagicNumber,0,Blue);
            ordemsell = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,Bid-TakeProfit*MyPoint,Robo,MagicNumber2,0,Red);
         }
      }  
  }     


   for (int trade7=OrdersTotal()-1; trade7>=0; trade7--) 
   {
      if (OrderSelect(trade7,SELECT_BY_POS, MODE_TRADES)) 
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         {    
            if(OrderType()==OP_BUY)
            { 
              if(Ask+StopLoss*MyPoint<OrderOpenPrice()) ordembuy = OrderSend(Symbol(),OP_BUY,iLots,Ask,Slippage,0,Ask+TakeProfit*MyPoint,Robo,MagicNumber,0,Blue);
              break;

            }
         }//FIM ORDERMAGIC
         
         
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber2)
         {    
            if(OrderType()==OP_SELL)
            { 
               if(Bid-StopLoss*MyPoint>OrderOpenPrice()) ordemsell = OrderSend(Symbol(),OP_SELL,iLots,Bid,Slippage,0,Bid-TakeProfit*MyPoint,Robo,MagicNumber2,0,Red);
               break;
            }
          }//FIM ORDERMAGIC2      
         
      }
   }

               
  }//FIM ONTICK
 