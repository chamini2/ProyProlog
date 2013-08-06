Proyecto II: Prolog
===================

El proyecto se encuentra en perfecto funcionamiento, pudiendo generar todas las
posibles sopas de letras a partir del Tamano, Alfabeto, y listas de la palabras
aceptadas y rechazadas indicadas.

Las sopas de letras las genera mediante el uso de backtracking de forma sistema-
tica, es decir, generara siempre de forma "ordenada" las sopas de letras (toman-
do en cuenta las palabras que deben aparecer). Para esto genera va generando to-
das las filas posibles y todas las posibles combinaciones de las mismas para ge-
nerar la Sopa; posteriormente verifica que la Sopa obtenida cumpla las condicio-
nes de que aparezcan todas las  palabras Aceptadas pero que no aparezcan las Re-
chazadas.

Para obtener todas las posibles palabras de  la sopa de  letra  (a las que luego
se verificara si las palabras ac eptadas pertenecen), se van almacenando una por
una en una lista. Para obtener cada palabra de cada  direccion (horizontal, ver-
tical,  diagonal principal  y diagonal secundaria),  se  realizan los siguientes
"calculos":

* Las palabras horizontales son iguales a las filas de la matriz.

* Las palabras verticales se obtienen mediante recursion:
    + Para obtener una fila:
        - Se obtiene el primer atomo de la fila y se agrega a la columna.
        - Se pasa a la siguiente fila y se hace repite el paso anterior.
        - Al finalizar, el predicado devuelve la columna obtenida y una sopa "nueva" sin esta columna.
    + Para obtenerlas todas:
        - Se llama al predicado anterior y se agrega la columna resultante en una lista.
        - Se llama recursivamente pero esta vez con la sopa "nueva" devuelta en el predicado anterior.
        - Se repite hasta que la sopa "nueva" esta vacia.
* Las palabras en diagonal (en ambas direcciones) también se  obtienen mediante recursion:
    La  mejor forma de explicarlo  es mediante un ejemplo visual para obtener las diagonales NorOeste -> SurEste:

        Supongamos que tenemos la matriz A:
                         a b c
                         d e f
                         g h i
                         
        Queremos obtener una lista D con las diagonales, que quedaría así:
  	        D=[[g], [d, h], [a, e, i], [b, f], [c]]
            
            Siendo Tam el numero de Filas.
            Asumiendo Tam' = Tam - 1 y n = 0.

                1) Desfasamos fila  por fila (agregando espacios "vacíos" que  en
            el programa se interpretan  con un $), agregando Tam' $'s a la iz-
            quierda de la primera fila y n $'s a la derecha de la misma, gráfi-
            camente quedaría así (Recordemos que la matriz está expresada como
            una lista de listas, por lo que al "agregar" los $ lo que se hace es
            concatenarlos del lado indicado de la lista):
                        $ $ $ a b c
                        d e f
                        g h i

                2) Tam'-- , n++
                3) pasamos a la siguiente fila (lista), y agregamos Tam' $'s a la
            izquierda de dicha fila y n $'s a la derecha de la misma, quedaría así:
                        $ $ a b c
                        $ d e f $
                        g h i

                4) Se repite desde el paso 2) hasta que Tam' == 0.
                        $ $ a b c
                        $ d e f $
                        g h i $ $

                5) Aplicamos el predicado para obtener las columnas (palabras ver-
             ticales) sobre la "nueva" sopa, y se obtendría:
		        D'=[[$, $, g], [$, d, h], [a, e, i], [b, f, $, $], [c, $, $]]

                6) Se eliminan los $'s de cada una de las sublistas.

                7) D = D' => se obtuvieron todas las diagonales NorOeste-> SurEste
             de la sopa.

                Para el  caso de  las diagonales NorEste -> SurOeste, se aplica  el
                mismo algoritmos  pero se inicia agregando al lado izquierdo 0 $'s
                y del lado  derecho Tam-1 $'s. Luego  se van agregando a las filas
                de abajo incrementando en 1 el  numero de $'s  de lado izquierdo y
                decrementando  en  1  el  numero de  $'s del lado derecho por cada
                vuelta.
