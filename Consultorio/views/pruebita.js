//piedra 1, papel 2 o tijera 3

let jugador = 0
let pc = 2
jugador = prompt("Elige: 1 para piedra, 2 para papel, 3 para tijera")

let aleatorio = Math.floor(Math.random() * 3) + 1

if (jugador == 1){
    alert ("Elegiste piedra")
    alert ("PC elige " + aleatorio)
    if (aleatorio == 1){
        alert ("Empate")
    }
        else if (aleatorio == 2){
            alert ("Perdiste")
        }
            else if (aleatorio == 3){
                alert ("Ganaste")
            }
}
    else if (jugador == 2){
        alert ("Elegiste papel")
        alert ("PC elige " + aleatorio)
        if (aleatorio == 1){
            alert ("Ganaste")
        }
            else if (aleatorio == 2){
                alert ("Empate")
            }
                else if (aleatorio == 3){
                    alert ("Perdiste")
                }
    }
    else if (jugador == 3){
        alert ("Elegiste tijera")
        alert ("PC elige " + aleatorio)
        if (aleatorio == 1){
            alert ("Perdiste")
        }
            else if (aleatorio == 2){
                alert ("Ganaste")
            }
                else if (aleatorio == 3){
                    alert ("Empate")
                }
    }
    else{
        alert ("Elige un número incorrecto")
    }