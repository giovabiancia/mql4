//+------------------------------------------------------------------+
//|                                                    PauseTest.mq4 |
//|                                      Copyright � 2006, komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2006, komposter"
#property link      "mailto:komposterius@mail.ru"

#include <PauseBeforeTrade.mq4>
#include <TradeContext.mq4>

int ticket = 0;
int start()
{
	// ���� ��� �������, �������� ���� ���������
	if ( ticket <= 0 )
	{
		// ��� ������������ ��������� ������ � �������� ��� (���� ��������� ������, �������)
		if ( TradeIsBusy() < 0 ) { return(-1); }
		// ����������� ����� ����� ��������� ����������
		if ( _PauseBeforeTrade() < 0 )
		{
			// ���� ��������� ������, ����������� �������� ����� � �������
			TradeIsNotBusy();
			return(-1);
		}
		// ��������� �������� ����������
		RefreshRates();

		// � �������� ������� �������
		ticket = OrderSend( Symbol(), OP_BUY, 0.1, Ask, 5, 0.0, 0.0, "PauseTest", 123, 0, Lime );
		if ( ticket < 0 ) { Alert( "������ OrderSend � ", GetLastError() ); }
		// ����������� �������� �����
		TradeIsNotBusy();
	}
	// ���� ���� �������, �������� ���� ���������
	else
	{
		// ��� ������������ ��������� ������ � �������� ��� (���� ��������� ������, �������)
		if ( TradeIsBusy() < 0 ) { return(-1); }
		// ����������� ����� ����� ��������� ����������
		if ( _PauseBeforeTrade() < 0 )
		{
			// ���� ��������� ������, ����������� �������� ����� � �������
			TradeIsNotBusy();
			return(-1);
		}
		// ��������� �������� ����������
		RefreshRates();

		// � �������� ������� �������
		if ( !OrderClose( ticket, 0.1, Bid, 5, Lime ) )
		{ Alert( "������ OrderClose � ", GetLastError() ); }
		else
		{ ticket = 0; }

		// ����������� �������� �����
		TradeIsNotBusy();
	}
return(0);
}

