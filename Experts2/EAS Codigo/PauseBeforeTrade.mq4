//+------------------------------------------------------------------+
//|                                             PauseBeforeTrade.mq4 |
//|                                      Copyright � 2006, komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
//#property copyright "Copyright � 2006, komposter"
//#property link      "mailto:komposterius@mail.ru"

extern int PauseBeforeTrade = 10; // ����� ����� ��������� ���������� (� ��������)

/////////////////////////////////////////////////////////////////////////////////
// int _PauseBeforeTrade ()
//
// ������� ������������� ���������� ���������� LastTradeTime �������� ���������� �������.
// ���� � ������ ������� ��������� ����� ������, ��� �������� LastTradeTime + PauseBeforeTrade, ������� ���.
// ���� ���������� ���������� LastTradeTime �� ����������, ������� ������ �.
// ���� ���������:
//  1 - �������� ����������
// -1 - ������ �������� ���� �������� ������������� (������� ����� � �������, ������ ��������, ��������� ������ 
// ��� ������ �������, ... )
/////////////////////////////////////////////////////////////////////////////////
int _PauseBeforeTrade ()
{
	// ��� ������������ ��� ������ ����������� ����� - ������ ��������� ������ �������
	if ( IsTesting() ) { return(1); }
	int _GetLastError = 0;
	int _LastTradeTime, RealPauseBeforeTrade;

	//+------------------------------------------------------------------+
	//| ���������, ���������� �� ��. ���������� �, ���� ���, ������ �  |
	//+------------------------------------------------------------------+
	while( true )
	{
		// ���� ������� ��� ���������� �������������, ���������� ������
		if ( IsStopped() ) { Print( "������� ��� ���������� �������������!" ); return(-1); }

		// ���������, ���������� �� ��. ����������
		// ���� ��� ����, ������� �� ����� �����
		if ( GlobalVariableCheck( "LastTradeTime" ) ) break;
		else
		// ���� GlobalVariableCheck ������� FALSE, ������ ���� ���������� ���, ���� ��� �������� �������� ������
		{
			_GetLastError = GetLastError();
			// ���� ��� �� ���� ������, ������� ����������, ��� 0,1 ������� � �������� �������� �������
			if ( _GetLastError != 0 )
			{
				Print( "_PauseBeforeTrade() - GlobalVariableCheck( \"LastTradeTime\" ) - Error #", _GetLastError );
				Sleep(100);
				continue;
			}
		}

		// ���� ������ ���, ������ ���������� ���������� ������ ���, �������� ������� �
		// ���� GlobalVariableSet > 0, ������ ���������� ���������� ������� �������. ������� �� �-���
		if ( GlobalVariableSet( "LastTradeTime", LocalTime() ) > 0 ) return(1);
		else
		// ���� GlobalVariableSet ������� �������� <= 0, ������ ��� �������� ���������� �������� ������
		{
			_GetLastError = GetLastError();
			// ������� ����������, ��� 0,1 ������� � �������� ������� �������
			if ( _GetLastError != 0 )
			{
				Print( "_PauseBeforeTrade() - GlobalVariableSet ( \"LastTradeTime\", ", LocalTime(), " ) - Error #", _GetLastError );
				Sleep(100);
				continue;
			}
		}
	}

 
	//+---------------------------------------------------------------------------------------+
	//| ���� ���������� ������� ����� �� ����� �����, ������ ���������� ���������� ����������.|
	//| ���, ���� LocalTime() ������ > LastTradeTime + PauseBeforeTrade                      |
	//+---------------------------------------------------------------------------------------+
	while( true )
	{
		// ���� ������� ��� ���������� �������������, ���������� ������
		if ( IsStopped() ) { Print( "������� ��� ���������� �������������!" ); return(-1); }

		// �������� �������� ��. ����������
		_LastTradeTime = GlobalVariableGet ( "LastTradeTime" );
		// ���� ��� ���� ��������� ������, ������� ����������, ��� 0,1 ������� � �������� ������� �������
		_GetLastError = GetLastError();
		if ( _GetLastError != 0 )
		{
			Print( "_PauseBeforeTrade() - GlobalVariableGet ( \"LastTradeTime\" ) - Error #", _GetLastError );
			continue;
		}

		// �������, ������� ������ ������ �� ������� ��������� �������� ��������
		RealPauseBeforeTrade = LocalTime() - _LastTradeTime;
		
		// ���� ������ ������, ��� PauseBeforeTrade ������,
		if ( RealPauseBeforeTrade < PauseBeforeTrade )
		{
			// ������� ����������, ��� �������, � ��������� �����
			Comment( "����� ����� ��������� ����������. �������� ", PauseBeforeTrade - RealPauseBeforeTrade, " ���." );
			Sleep(1000);
			continue;
		}
		// ���� ������ ������, ��� PauseBeforeTrade ������, ������������� ���������� �����
		else
		{ break; }
	}

	//+---------------------------------------------------------------------------------------+
	//| ���� ���������� ������� ����� �� ����� �����, ������ ���������� ���������� ����������,|
	//| � ��������� ����� ������, ��� LastTradeTime + PauseBeforeTrade							   |
	//| ������������� ���������� ���������� LastTradeTime �������� ���������� �������         |
	//+---------------------------------------------------------------------------------------+
	while( true )
	{
		// ���� ������� ��� ���������� �������������, ���������� ������
		if ( IsStopped() ) { Print( "������� ��� ���������� �������������!" ); return(-1); }

		// ������������� ���������� ���������� LastTradeTime �������� ���������� �������. ���� ������� - �������
		if ( GlobalVariableSet( "LastTradeTime", LocalTime() ) > 0 ) { Comment( "" ); return(1); }
		else
		// ���� GlobalVariableSet ������� �������� <= 0, ������ �������� ������
		{
			_GetLastError = GetLastError();
			// ������� ����������, ��� 0,1 ������� � �������� ������� �������
			if ( _GetLastError != 0 )
			{
				Print( "_PauseBeforeTrade() - GlobalVariableSet ( \"LastTradeTime\", ", LocalTime(), " ) - Error #", _GetLastError );
				Sleep(100);
				continue;
			}
		}
	}
}

