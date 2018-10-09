/*========DESCRI��O BB Money 1.0====== 
  
=======================*/


/*=======================================================ANOTA��ES========================================================
  Ta com erro no magic2. m�s decidi manter porque ta dando lucro.
========================================================================================================================*/
input int Slippage = 0;
input int MagicNumber1 = 8001;
input int MagicNumber2 = 8002;
input int MagicNumber3 = 8003;

input int Lots1 = 1.0;
input int Lots2 = 2.0;
input int Lots3 = 3.0;

input int TAKE1 = 20; 

input int STOP2 = 10; 
input int STOP3 = 10; 

int ticket;


void OnTick()
  {
      //========================POINT===============================
               double MyPoint=Point;                                      
               if(Digits==3 || Digits==5) MyPoint=Point*10;               
      //============================================================
      
     double BBupper = iBands(Symbol(),NULL,22,3,0,PRICE_CLOSE,MODE_UPPER,0);
     double BBlower = iBands(Symbol(),NULL,22,3,0,PRICE_CLOSE,MODE_LOWER,0);
     
      
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ABERTURA ORDEM++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++       
   
   if(OrdersTotal()==0)
   {
      if(Ask > BBupper || Bid > BBupper)
      {
         ticket = OrderSend(Symbol(),OP_SELL,Lots1,Bid,Slippage,0,Bid-TAKE1*MyPoint,NULL,MagicNumber1,0,Red);
      }
      
      if(Bid < BBlower || Ask < BBlower)
      {
         ticket = OrderSend(Symbol(),OP_BUY,Lots1,Ask,Slippage,0,Ask+TAKE1*MyPoint,NULL,MagicNumber1,0,Blue);
      }      
  
  }//FIM ORDERSTOTAL
  
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CONFIGURA��O DE ORDEM MAGIC 1++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
      if(OrdersTotal()==1)
      {
      int cnt, total=OrdersTotal();
      for(cnt=0;cnt<total;cnt++)
      {
         if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol()&&OrderMagicNumber()==MagicNumber1)
         {
           
                     
            if(OrderType()==OP_BUY)
            {  //DEFINI��O DE STOP
               if(Ask+STOP2*MyPoint < OrderOpenPrice()) ticket = OrderSend(Symbol(),OP_BUY,Lots2,Ask,Slippage,0,0,NULL,MagicNumber2,0,Blue);
            }//FIM OP_BUY
            
            
            if(OrderType()==OP_SELL)
            {  //DEFINI��O DE STOP
               if(Bid-STOP2*MyPoint>OrderOpenPrice()) ticket = OrderSend(Symbol(),OP_SELL,Lots2,Bid,Slippage,0,0,NULL,MagicNumber2,0,Red);
            }//FIM OP_SELL      
            
            
         }//FIM ORDERMAGIC
      }//FIM CONTADOR      
      }      
               
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CONFIGURA��O DE ORDEM MAGIC 2++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   
            int cntt, totalt=OrdersTotal();
            for(cntt=0;cntt<totalt;cntt++)
            {
               if(OrderSelect(cntt,SELECT_BY_POS,MODE_TRADES))
               if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber2)
               {
                  if(OrderType()==OP_SELL)
                  {  //DEFINI��O DE TAKE
                     if(Bid+TAKE1*MyPoint<OrderOpenPrice()) bool TAKESHELL2=true;
                     
                     //DEFINI��O DE STOP E ORDERSEND MAGIC3
                     if(Bid-STOP2*MyPoint>OrderOpenPrice())
                     {
                      bool STOPSHELL2 = true;
                      ticket = OrderSend(Symbol(),OP_BUY,Lots3,Ask,Slippage,0,Ask+15*MyPoint,NULL,MagicNumber3,0,Blue);
                      }
                     
                  }
                  
                  if(OrderType()==OP_BUY)
                  {  //DEFINI��O DE TAKE
                     if(Ask-TAKE1*MyPoint>OrderOpenPrice()) bool TAKEBUY2=true; 
                     
                     if(Ask+STOP2*MyPoint<OrderOpenPrice())
                     {
                         bool STOPBUY2 = true;
                         ticket = OrderSend(Symbol(),OP_SELL,Lots3,Bid,Slippage,0,Bid-15*MyPoint,NULL,MagicNumber3,0,Red);
                         }
                     
                  }
               
               }//FIM MAGIC2
             }//FIM CONTADOR
  
  
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CONFIGURA��O MAGIC3++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
            int f, totalf=OrdersTotal();
            for(f=0;f<totalf;f++)
            {
               if(OrderSelect(f,SELECT_BY_POS,MODE_TRADES))
               if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber2)
               {
                  if(OrderType()==OP_SELL)
                  {

                     //if(STOPSHELL2=true) ticket = OrderSend(Symbol(),OP_BUY,Lots3,Ask,Slippage,0,Ask+TAKE1*MyPoint,NULL,MagicNumber3,0,Blue);
                    }}} 
                    
        
  

  
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++FECHAMENTO DE TODAS AS ORDENS++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
            int v, totalv=OrdersTotal();
            for(v=0;v<totalv;v++)
            {
               if(OrderSelect(v,SELECT_BY_POS,MODE_TRADES))
               {
                 if(STOPSHELL2==true || STOPBUY2==true || TAKESHELL2==true || TAKEBUY2==true ) ticket = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrPink);
                } 
           
            }//FIM CONTADOR  
  
  
  
  
  
  
  
  }//FIM ONTICK
