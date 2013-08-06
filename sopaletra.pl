%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                       Proyecto II: Prolog - sopaletra                     %%
%%                            Alberto Cols, 09-10177                         %%
%%                          Matteo Ferrando, 09-10285                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% generadorSopa
%   Funcion "main" que se encarga de la ejecucion del programa.
generadorSopa :-
  write('Holis guardis!'), nl,
  obtenerTam(Tam),
  obtenerAlfabeto(Alfabeto),
  write('Donde guardaste tu lista de palabras favoritas en TODO el mundo? '),
  cargarListaPalabra(Aceptadas, Alfabeto, Tam),
  write('Donde esta la listica de palabras que mas odias en todo el UNIVERSO? '),
  cargarListaPalabra(Rechazadas, Alfabeto, 0),
  sopaLetra(Alfabeto, Tam, Aceptadas, Rechazadas, Sopa),
  mostrarSopa(Sopa, Tam),
  %% Para mostrar la sopa una sola vez.
  %% Al parecer funciona solo en ciertas implementaciones de prolog
  %% Descomentar para probar (Ver linea 108)
  %% assert(Sopa),
  quieresMas,
  5write('Gracias, mi aficionado a las sopa de letras favorito!'),nl,
  !.
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 Funciones para obtener por entrada estandar               %%
%%                          los parametros necesarios                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% obtenerTam(-Tam)
%   Obtiene por entrada estandar el tamano de la matriz.
obtenerTam(Tam) :-
  write('De que tamano quieres que sean las sopitas, guardia grandote? '),
  read(Tam).
 
% obtenerAlfabeto(-Alfabeto)
%   Obtiene por entrada estandar el alfabeto valido.
obtenerAlfabeto(Alfabeto) :-
  write('Cual es el alfabeto que tu conoces, oh gran guardia? '),
  read(Alfabeto).
 
% cargarListaPalabra(-Palabras, +Alfabeto, +Tam)
%   Abre un archivo, obtiene su informacion y luego determina si las palabras
%   que se encontraban en el son validas.
cargarListaPalabra(Palabras, Alfabeto, Tam) :-
  read(Archivo),
  see(Archivo),
  read(Palabras),
  seen,
  palabrasValidas(Palabras, Alfabeto, Tam).
 
% quieresMas
%   Verifica si el usuario quiere obtener mas sopas de letras.
quieresMas :-
  write('Quieres mas? '),
  read(Mas),
  Mas \= mas.
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                Funciones para validar las palabras recibidas              %%
%%                         por los archivos de entrada                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% palabrasValidas(?ListaPalabras, +Alfabeto)
%   Determina si las de palabras de la lista pasada son validas.
palabrasValidas([], _, _) :-
  nl, write('Todas las palabras son validas.'), nl.
% Si el Tam es 0 es que se trata de las palabras rechazadas.
palabrasValidas([Palabra|Resto], Alfabeto, 0) :-
  atom_chars(Palabra, Lista),
  palValida(Lista, Alfabeto),
  palabrasValidas(Resto, Alfabeto, 0).
% Si es distinto de 0 significa que se verificaran las palabas aceptadas
palabrasValidas([Palabra|Resto], Alfabeto, Tam) :-
  Tam > 0,
  atom_chars(Palabra, Lista),
  length(Lista, TamLista),
  TamLista =< Tam,
  palValida(Lista, Alfabeto),
  palabrasValidas(Resto, Alfabeto, Tam).
 
% palValida(?Palabra, +Alfabeto)
%   Determina si una palabra es valida
%   Todos sus caracteres pertenecen al abecedario.
palValida([], _).
palValida([Letra|Resto], Alfabeto) :-
  member(Letra, Alfabeto),
  palValida(Resto, Alfabeto).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Funciones para generar todas las posibles                %%
%%                      matrices con el alfabeto indicado                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% sopaLetra(+Alfabeto, +Tam, +Aceptadas, +Rechazadas, -Sopa)
%   Genera una matriz que cumpla con la condicion de aparicion de TODAS
%   las palabras aceptadas y de NINGUNA de las palabras rechazadas.
sopaLetra(Alfabeto, Tam, Aceptadas, Rechazadas, Sopa) :-
  getMatrix(Tam, Tam, Alfabeto, Sopa),
  getListas(Sopa, Tam, Sopitas),
  estanTodas(Aceptadas, Sopitas),
  sinRechazadas(Rechazadas, Sopitas).
  %% Para mostrar la sopa una sola vez.
  %% Al parecer funciona solo en ciertas implementaciones de prolog
  %% Descomentar para probar (Ver linea 22)
  %not(Sopa).                              
 
% getListas(+Sopa, +Tam, -Sopitas)
%   Obtiene una lista con todas las posibles palabras de la sopa de letras.
%   En la que luego se verificara si estan todas las palabras aceptadas y no
%   hay ninguna rechazada
getListas(Sopa, Tam, Sopitas) :-
  Horizontales = Sopa,
  getVerticales(Sopa, Verticales),
  getDiagPrinc(Sopa, Tam, DiagPrinc),
  getDiagSecun(Sopa, Tam, DiagSecun),
  append(Horizontales, Verticales, HorVer),
  append(HorVer, DiagPrinc, HorVerDP),
  append(HorVerDP, DiagSecun, Normales),
  reverseall(Normales, Raras),
  append(Normales, Raras, Sopitas).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% reverseall(+Normal, ?Raras)
%   Devuelve en Raras una lista con todas las palabras de Normal pero inversas.
reverseall([],[]).
reverseall([X|Xs], [Y|Ys]) :-
  reverse(X, Y),
  reverseall(Xs, Ys).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Funciones para obtener todas las palabras de la sopa de letra indicada  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% getVertical(+Sopa, -Columna, +Filas)
%   Obtiene una columna de la sopa de letras.
getVertical([], [], []).
getVertical([[S|Opitas]|Resto], [S|Columna], [Opitas|Filas]) :-
  getVertical(Resto, Columna, Filas).
 
% getVerticales(+Sopa, -Verticales)
%   Obtiene la lista con todas las columnas de la sopa de letras.
getVerticales([[]|_], []).
getVerticales(Sopa, [Vertical|Resto]) :-
  getVertical(Sopa, Vertical, Opa),
  getVerticales(Opa, Resto).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% nVacias(?Num, -Vacias)
%   Crea una lista con un caracter "vacio" o no valido para la sopa de letras.
%   ($ en nuestro caso), utilizado para poder desfasar la matriz y obtener las 
%   diagonales.
nVacias(0,[]).
nVacias(N, [$|Vacias]) :-
  N > 0,
  NResto is N - 1,
  nVacias(NResto, Vacias).
 
% quitarVacias(+Sucias, ?Diagonales)
%   Quita los caracteres "vacios" de las palabras obtenidas en Sucias que son
%   las palabras que corresponden a las diagonales de la matriz.
quitarVacias([], []).
quitarVacias([Verti|Cales], [Diago|Nales]) :-
  delete(Verti, $, Diago),
  quitarVacias(Cales, Nales).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% getDiagPrinc(+Sopa, +Tam, -DiagPrinc)
%   Funcion que obtiene todas las palabras de la sopa de letras en direccion 
%   NorOeste -> SurEste
getDiagPrinc(Sopa, Tam, DiagPrinc) :-
  N is Tam - 1,
  getDesfasadasPrinc(Sopa, N, 0, Defasadas),
  getVerticales(Defasadas, Verticales),
  quitarVacias(Verticales, DiagPrinc).
 
% getDesfasadasPrinc(+Sopa, ?Izq, ?Der, -Desfasadas)
%   Desfasa las filas de la sopa de letras para poder obtener las palabras
%   diagonales NorOeste -> SurEste
getDesfasadasPrinc([], -1, _, []).
getDesfasadasPrinc([Sopi|Tas], Izq, Der, [SopiDes|Fasadas]) :-
  Izq >= 0,
  IzqN is Izq - 1,
  DerN is Der + 1,
  nVacias(Izq, LIzq),
  nVacias(Der, LDer),
  append(LIzq, Sopi, IzqSopita),
  append(IzqSopita, LDer, SopiDes),
  getDesfasadasPrinc(Tas, IzqN, DerN, Fasadas).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% getDiagSecun(+Sopa, +Tam, -DiagSecun)
%   Funcion que obtiene todas las palabras de la sopa de letras en direccion 
%   NorEste -> SurOeste
getDiagSecun(Sopa, Tam, DiagSecun) :-
  N is Tam - 1,
  getDesfasadasSecun(Sopa, 0, N, Defasadas),
  getVerticales(Defasadas, Verticales),
  quitarVacias(Verticales, DiagSecun).
 
% getDesfasadasSecun(+Sopa, ?Izq, ?Der, -Desfasadas)
%   Desfasa las filas de la sopa de letras para poder obtener las palabras
%   diagonales NorEste -> SurOeste
getDesfasadasSecun([], _, -1, []).
getDesfasadasSecun([Sopi|Tas], Izq, Der, [SopiDes|Fasadas]) :-
  Der >= 0,
  IzqN is Izq + 1,
  DerN is Der - 1,
  nVacias(Izq, LIzq),
  nVacias(Der, LDer),
  append(LIzq, Sopi, IzqSopita),
  append(IzqSopita, LDer, SopiDes),
  getDesfasadasSecun(Tas, IzqN, DerN, Fasadas).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% estanTodas(+Aceptadas, +Sopa)
%   Verifica que todas las palabras aceptadas aparezcan (al menos una vez) en 
%   la lista de todas las palabras de la sopa de letras. Si llega al caso base 
%   es porque todas las palabras se encontraban.
estanTodas([],_).
estanTodas([Aceptada|Resto], Sopa) :-
  estaPalabra(Aceptada, Sopa),
  estanTodas(Resto, Sopa).
   
% sinRechazadas(+Rechazadas, +Sopa)
%   Verifica que ninguna de las palabras rechazadas aparezcan (ni una vez) en 
%   la lista de todas las palabras de la sopa de letras. Si llega al caso base 
%   es porque ninguna de las palabras se encontraba.
sinRechazadas([],_).
sinRechazadas([Rechazada|Resto], Sopa) :-
  not(estaPalabra(Rechazada, Sopa)),
  sinRechazadas(Resto, Sopa).
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
% getFila(?Tam, +Alfabeto, -Fila)
%   Genera sistematicamente todas las posibles filas que se pueden crear con 
%   el alfabeto.
getFila(0, _, []).
getFila(Tam, Alfabeto, [X|Resto]) :-
  Tam > 0,
  TamResto is Tam - 1,
  member(X, Alfabeto),
  getFila(TamResto, Alfabeto, Resto).
 
% getMatrix(?Quedan, +Tam, +Alfabeto, -Matrix)
%   Obtiene sistematicamente todas las matrices matrices que se pueden generar 
%   con el Alfabeto
getMatrix(0, _, _, []).
getMatrix(Quedan, Tam, Alfabeto, [Fila|Resto]) :-
  Quedan > 0,
  TamResto is Quedan -1,
  getFila(Tam, Alfabeto, Fila),
  getMatrix(TamResto, Tam, Alfabeto, Resto).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% estaPalabra(+Palabra, +Sopa)
%   Verifica que Palabra se encuentre al menos una vez en la lista de palabras
%   de Sopa. Esto es, que Palabra sea substring de alguna de las palabras.
estaPalabra(Palabra, [Sopita|_]) :-
  atom_chars(Palabra, Caracteres),
  substring(Caracteres, Sopita).
estaPalabra(Palabra, [_|Resto]) :-
  estaPalabra(Palabra, Resto).
 
% equalString(+Palabra1, +Palabra2)
%   Verifica que palabras pasadas sean iguales.
equalstring([], _).
equalstring([Char|Sub], [Char|Str]) :-
  equalstring(Sub, Str).
 
% substring(+SubPalabra, +Palabra)
%   Verifica que SubPalabra sea substring de Palabra.
substring([], _).
substring([Sub|Subs], [Sub|Strs]) :-
  equalstring(Subs, Strs).
substring(Subs, [_|Strs]) :-
  substring(Subs, Strs).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  Funciones para imprimir las matrices                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% printFila(+Fila)
%   Imprime una fila de la matriz.
printFila([]) :-
  write('|').
printFila([X|Xs]) :-
  write(X),
  tab(1),
  printFila(Xs).
 
% printLinea(+Tam)
%   Imprime una linea de '-'
printLinea(0):-
  nl.
printLinea(Tam) :-
  Tam > 0,
  write('-'),
  TamResto is Tam - 1,
  printLinea(TamResto).
 
% mostrarSopa(+Sopa, +Tam)
%   Imprime una Sopa por pantalla con los '-' de division.
mostrarSopa(Sopa, Tam) :-
  Guion is Tam * 2 + 3,
  printLinea(Guion),
  mostrarMatrix(Sopa),
  printLinea(Guion).
 
% mostrarSopa(+Sopa)
%   Imprime la sopa pasada.
mostrarMatrix([]).
mostrarMatrix([F|Resto]) :-
  write('| '),
  printFila(F), nl,
  mostrarMatrix(Resto).
