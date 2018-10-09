/*========DESCRI��O Martingale 1.0====== 

  
=======================*/

/*=======================================================ANOTA��ES========================================================
Atualiza��o: TAKE: SPRED+1PIP

*So funciona no USDJPY se excluir o *Point.


--Estou quase deixando esse EA de lado. porque nao consigo reduzir o lote e consistir os ganhos!

*ATT em MA rapida e MA lenta (que estao com nome trocado).
========================================================================================================================*/
string Robo = "Martingale 2.0";
extern int Slippage = 0;
extern int MagicNumber = 121212;

extern int TAKE = 1;

extern double Lots = 0.01;
extern int lotdecimal = 2; 
extern double LotExponent = 2; 
double Spread=MarketInfo(Symbol(),MODE_SPREAD);


int ticket,NumOfTrades;
datetime tempo;
double iLots;

int OnInit(){return(INIT_SUCCEEDED);}
  
void OnTick()
  {     
      Comment(Spread);
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FECHAR TODAS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
   
      
         static int closedOrders=0;
         if(OrdersHistoryTotal()!=closedOrders)
         {
            closedOrders=OrdersHistoryTotal();
            int hstTotal = OrdersHistoryTotal(); 
        
            if(OrderSelect(hstTotal-1,SELECT_BY_POS,MODE_HISTORY))
            {
               tempo = OrderCloseTime();
               if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber  )
               {
                  if(OrderOpenPrice()>OrderClosePrice())
                  {
                     bool STOPTUDO = true;
                  }
               }
               
               if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber  )
               {
                  if(OrderOpenPrice()<OrderClosePrice())
                  {
                     bool STOPTUDOb = true;
                  }
               }      
           }
        } 
            
            int v, totalv=OrdersTotal();
            for(int i=OrdersTotal()-1; i>=0; i--)   
            {
               if(OrderSelect(v,SELECT_BY_POS)==true)
               {
                 int Tck = OrderTicket();
                 if( STOPTUDO==true || STOPTUDOb==true)  ticket = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrPink);
                
                } 
           
            }//FIM CONTADOR  
               
            
      //========================POINT===============================
               double MyPoint=Point;                                      
               if(Digits==3 || Digits==5) MyPoint=Point*10;               
      //============================================================
      double MA = iMA(Symbol(),NULL,5,0,MODE_SMA,PRICE_CLOSE,0);
      
      double MAlenta = iMA(Symbol(),NULL,4,0,MODE_EMA,PRICE_CLOSE,0);
      double MArapida = iMA(Symbol(),NULL,13,0,MODE_EMA,PRICE_CLOSE,0); 
      
      
    //fui dormir. ser� q ficaria legal um switch?

   NumOfTrades = CountTrades();
   //iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), lotdecimal); 
     iLots = Lots+(NumOfTrades*0.01); //anda de 2 em 2. 0.01 - 0.03 - 0.05...
   
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ABERTURA ORDEM++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
   if(Time[0]>=tempo)
   {
      if(OrdersTotal()==0) 
      {
         if(MArapida<MAlenta) ticket = OrderSend(Symbol(),OP_SELL,iLots,Bid,0,0,(Bid-1*MyPoint)-Spread*Point,NULL,MagicNumber,0,Red);
         if(MArapida>MAlenta) ticket = OrderSend(Symbol(),OP_BUY,iLots,Ask,0,0,(Ask+1*MyPoint)+Spread*Point,NULL,MagicNumber,0,Blue);
      }    
    }
            
   for (int trade=OrdersTotal()-1; trade>=0; trade--) 
   {
      if (OrderSelect(trade,SELECT_BY_POS, MODE_TRADES)) 
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         {
            
            if(OrderType()==OP_SELL)
            {
               if(Bid-3*MyPoint>OrderOpenPrice()) ticket = OrderSend(Symbol(),OP_SELL,iLots,Bid,0,0,(Bid-NumOfTrades*MyPoint)-Spread*Point,NULL,MagicNumber,0,Red);
               break; //(Bid-5*MyPoint)-Spread*Point
            }
            if(OrderType()==OP_BUY)
            {
               if(Ask+3*MyPoint<OrderOpenPrice()) ticket = OrderSend(Symbol(),OP_BUY,iLots,Ask,0,0,(Ask+NumOfTrades*MyPoint)+Spread*Point,NULL,MagicNumber,0,Blue);
               break;
           }      
         } 
      }     
   }

  
  //Ask+NumOfTrades*4*MyPoint
  
  
  
  
  
  
  
  
  }//FIM ONTICK
  
//Contar quantas ordens existe em aberto
  
   int CountTrades() {
   int count = 0;
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) 
   {
      int a = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
   }
   return (count);
}

  //a- MathPow(3, NumOfTrades)*MyPoint  
         
        /* for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
         if (OrderSelect(trade, SELECT_BY_POS, MODE_TRADES)) {
            
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber) {
               if (OrderType() == OP_SELL)
               {
               double a = OrderOpenPrice();
                  if(Bid-10*MyPoint>OrderOpenPrice()) ticket = OrderSend(Symbol(),OP_SELL,iLots,Bid,0,0,,NULL,MagicNumber,0,Red);
                  
                  break;
               }
               }
               }
               }
          //a- MathPow(3, NumOfTrades)*MyPoint     
               */