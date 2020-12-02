[Fvol_GARCH,Fvol_EGARCH,Hvol] = Vol('601012.SH','20200430','20200730','20200731',today,'SSE')
disp(['Forecasted 1-year GARCH volatility = ' num2str(Fvol_GARCH*100,4) '%'])
disp(['Forecasted 1-year EGARCH volatility = ' num2str(Fvol_EGARCH*100,4) '%'])
disp(['Historical 1-year volatility = ' num2str(Hvol*100,4) '%'])