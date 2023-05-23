implement main
    open core, stdio

domains
    naselenie = integer.
    gosudarstvo = string.
    stolica = string.
    gender = string.

class facts
    gos : (integer Id_gos, string Gosudarstvo, string Chast_sveta, integer Naselenie, integer Ploschad).
    stol : (integer Id_stol, string Stolica, integer Naselenie, integer Ploschad).
    pred : (integer Id_stol, integer Id_gos).
    gender_gos : (gosudarstvo Q, stolica W, gender E, naselenie R).

clauses
    gos(276, "German", "Europe", 84, 357588).
    gos(250, "France", "Europe", 68, 551695).
    gos(156, "China", "Asia", 1500, 9597000).
    gos(392, "Japan", "Asia", 126, 377973).
    gos(124, "Canada", "America", 39, 9985000).
    gos(076, "Argentina", "America", 215, 2780000).

    stol(0, "Berlin", 4, 892).
    stol(1, "Tokio", 14, 2194).
    stol(2, "Ottawa", 1, 2790).
    stol(3, "Paris", 3, 105).
    stol(4, "Beijing", 22, 16411).
    stol(5, "Buenos Aires", 3, 203).

    pred(0, 276).
    pred(1, 392).
    pred(2, 124).
    pred(3, 250).
    pred(4, 156).
    pred(5, 076).

    gender_gos("German", "Berlin", "Male", 41100721).
    gender_gos("German", "Berlin", "Female", 42708704).
    gender_gos("France", "Paris", "Male", 32165751).
    gender_gos("France", "Paris", "Female", 33920457).
    gender_gos("China", "Beijing", "Male", 722000006).
    gender_gos("China", "Beijing", "Female", 689000069).
    gender_gos("Japan", "Tokyo", "Male", 61473601).
    gender_gos("Japan", "Tokyo", "Female", 64745856).
    gender_gos("Argentina", "Buenos Aire", "Male", 22790322).
    gender_gos("Argentina", "Buenos Aire", "Female", 23798672).
    gender_gos("Canada", "Ottawa", "Male", 19288225).
    gender_gos("Canada", "Ottawa", "Female", 19528177).

class predicates
    printGos : (). /*Вывод всех государств с их id, названием, столицей, населением и площадью.*/
    printStol : (). /*Вывод всех столиц с их id, названием, населением и площадью.*/
    printPred : (). /*Вывод всех id государств и  id их столиц.*/
    zchsv : (string). /*Вывод всех государств по заданной части света.*/
    zidst : (integer). /*Вывод части света по id столицы их государства.*/
    sootn : (). /*Рассчёт соотношения площадей столицы к принадлежащему государству.*/
    printGender_gos : (). /*Вывод государств с количеством мужского и женского населения*/
    increaseNaselenie : (string, integer). /*Увеличение числа населения опрёделенного государства.*/
    decreaseNaselenie : (string, integer). /*Уменьшение числа населения определённого государства.*/

clauses
    printGender_gos() :-
        gender_gos(Q, W, E, R),
        write("Gos: ", Q, " |Stolica: ", W, " |Gender: ", E, " |Naselenie: ", R),
        nl,
        fail.
    printGender_gos() :-
        write("That's all.\n").

clauses
    printGos() :-
        gos(A, B, C, D, I),
        write("ID: ", A, " |Stolica: ", B, " |Chast sveta: ", C, " |Naselenie: ", D, " |Ploschad: ", I),
        nl,
        fail.
    printGos() :-
        write("That's all.\n").

clauses
    printStol() :-
        stol(A, B, C, D),
        write("ID: ", A, " |Stolica: ", B, " |Naselenie: ", C, " |Ploschad: ", D),
        nl,
        fail.
    printStol() :-
        write("That's all.\n").

clauses
    printPred() :-
        pred(A, B),
        write("ID stolica: ", A, " |ID gos: ", B),
        nl,
        fail.
    printPred() :-
        write("That's all.\n").

clauses
    zchsv(C) :-
        gos(A, _, C, _, _),
        stol(X, Y, _, _),
        pred(X, A),
        write("Capitals that are located in a given part of the world:\n"),
        write(C, ":\t", Y),
        nl,
        fail.
    zchsv(_).

clauses
    zidst(X) :-
        gos(A, _, C, _, _),
        stol(X, _, _, _),
        pred(X, A),
        write("Part of the world by this id of the capital:\n"),
        write(X, ":\t", C),
        nl,
        fail.
    zidst(_).

clauses
    increaseNaselenie(B, Num) :-
        retract(gos(A, B, C, D, I)),
        asserta(gos(A, B, C, D + Num, I)),
        fail.
    increaseNaselenie(_, _).

clauses
    decreaseNaselenie(B, Num) :-
        retract(gos(A, B, C, D, I)),
        asserta(gos(A, B, C, D - Num, I)),
        fail.
    decreaseNaselenie(_, _).

clauses
    sootn() :-
        gos(A, _, C, _, P0),
        stol(X, Y, _, P1),
        pred(X, A),
        write("The ratio of the area of the capital to the area of the state:\n"),
        S = P1 / P0,
        write(C, ":\t", Y, " = ", S, "\n"),
        nl,
        fail.
    sootn() :-
        write("That's all.\n").

clauses
    run() :-
        write(" Basic information about countries:\n"),
        printGos(),
        write(" \n"),
        write("Basic information about the capitals: \n"),
        printStol(),
        write(" \n"),
        write("Basic information about the IDs of countries and their capitals: \n"),
        printPred(),
        write(" \n"),
        write("Basic information about the gender population of countries: \n"),
        printGender_gos(),
        write(" \n"),
        write("Write a part of the world:\n"),
        C = stdio::readLine(),
        zchsv(C),
        write("Press enter to continue. \n"),
        _ = stdio::readLine(),
        write(" \n"),
        write("Write the id of the capital:\n"),
        X = stdio::read(),
        zidst(X),
        _ = stdio::readLine(),
        write(" \n"),
        write("Basic information about the ratio of countries and their capitals:\n"),
        sootn(),
        write(" \n"),
        write(
            "If the population of a certain country has increased, first specify the country in one line, and then in another line specify how much the population has increased. (If not, specify any country and the number 0)\n"),
        B = stdio::readLine(),
        N = stdio::read(),
        increaseNaselenie(B, N),
        _ = stdio::readLine(),
        printGos(),
        write(" \n"),
        write(
            "If the population of a certain country has decreased, first indicate the country in one line, and then in another line indicate how much the population has increased. (If not, specify any country and the number 0).\n"),
        G = stdio::readLine(),
        J = stdio::read(),
        decreaseNaselenie(G, J),
        _ = stdio::readLine(),
        printGos().

end implement main

goal
    console::runUtf8(main::run).
