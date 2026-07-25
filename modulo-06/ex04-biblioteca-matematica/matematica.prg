FUNCTION FatorialN( nN )
   LOCAL nFat := 1, nI
   FOR nI := 2 TO nN
      nFat *= nI
   NEXT
RETURN nFat

FUNCTION EhPrimo( nN )
   LOCAL nI
   IF nN < 2
      RETURN .F.
   ENDIF
   FOR nI := 2 TO Int( Sqrt( nN ) )
      IF nN % nI == 0
         RETURN .F.
      ENDIF
   NEXT
RETURN .T.

FUNCTION MDC( nA, nB )
   LOCAL nTmp
   DO WHILE nB != 0
      nTmp := nB
      nB   := nA % nB
      nA   := nTmp
   ENDDO
RETURN nA

FUNCTION MMC( nA, nB )
RETURN ( nA * nB ) / MDC( nA, nB )
