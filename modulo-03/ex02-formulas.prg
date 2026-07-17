function main()

    local a, b, c

    ? "+++++++ Área do círculo ++++++"
    Input "Raio: " To a
    ? "Área: " + Str( PI() * a ^ 2, 10, 2 )

    ? "++++ Hipotenusa ++++"
    Input "Cateto A: " To a
    Input "Cateto B: " To b
    ? "Hipotenusa: " + Str( Sqrt( a ^ 2 + b ^ 2 ), 10, 2 )

    ? "+++++ IMC +++++"
    Input "Peso (kg): "  To a
    Input "Altura (m): " To b
    ? "IMC: " + Str( a / b ^ 2, 10, 2 )

return nil