function Main()

    local nSecreto := hb_RandomInt( 1, 100 )
    local nPalpite := 0
    local nI := 0
    local lAcertou := .F.

    ? "Advinhe o numero entre 1 e 100! Voce tem 7 tentativas."

    for nI := 1 to 7
        input "Tentativa " + Str( nI, 1 ) + ": " to nPalpite
        if nPalpite == nSecreto
            lAcertou := .T.
            exit
        elseif nPalpite < nSecreto
            ? "O numero secreto e maior."
        else
            ? "O numero secreto e menor."
        endif
    next

    if lAcertou
        ? "Parabens! Voce acertou em", nI, "tentativa(s)."
    else
        ? "Suas tentativas acabaram."
    endif

    ? "O numero secreto era:", nSecreto

return nil
