/*
 * principal.prg  -  Testa a biblioteca matematica.prg.
 * Compilar: hbmk2 principal.prg
 * (SET PROCEDURE TO ja inclui a matematica.prg na compilacao.)
 */

SET PROCEDURE TO matematica.prg

PROCEDURE Main()
   ? "FatorialN(5) =", FatorialN( 5 )                 // 120
   ? "EhPrimo(7)   =", IIf( EhPrimo( 7 ), "SIM", "NAO" )
   ? "EhPrimo(8)   =", IIf( EhPrimo( 8 ), "SIM", "NAO" )
   ? "MDC(12, 18)  =", MDC( 12, 18 )                  // 6
   ? "MMC(4, 6)    =", MMC( 4, 6 )                    // 12
   RETURN
