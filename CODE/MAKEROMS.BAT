@echo off

echo>>oo.lrn ff800000
echo.>>oo.lrn
echo>>oo.lrn 2
echo.>>oo.lrn
echo>>oo.lrn oo.out
echo.>>oo.lrn
echo.>>oo.lrn
echo.>>oo.lrn
echo.>>oo.lrn
echo>>oo.lrn a

srec < oo.lrn
copy /b bbf8.0+bbfa.0+bbfc.0+bbfe.0 7m.0 /v
copy /b bbf8.1+bbfa.1+bbfc.1+bbfe.1 7m.1 /v
dataio 7m.0
dataio 7m.1

del >nul bb.lrn
