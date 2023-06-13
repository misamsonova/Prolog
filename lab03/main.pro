implement main
    open core, file, stdio
    domains
        naselenie = integer.
        gosudarstvo = string.
        stolica = string.
        chast_sveta = string.
        gender = symbol.
    class facts - information
        gos : (integer Id_gos, string Gosudarstvo, chast_sveta Chast_sveta, integer Naselenie, integer Ploschad).
        stol : (integer Id_stol, string Stolica, integer Naselenie, integer Ploschad).
        pred : (integer Id_stol, integer Id_gos).
        gender_gos : (gosudarstvo Q, stolica W, gender E, naselenie R).
    class predicates
        printGos : (). % Вывод всех государств с их id, названием, столицей, населением и площадью.
        printStol : (). % Вывод всех столиц с их id, названием, населением и площадью.
        printPred : (). % Вывод всех id государств и  id их столиц.
        zchsv : (chast_sveta, list (string)). % Вывод всех государств по заданной части света.
        zidst : (integer, chast_sveta). % Вывод части света по id столицы их государства.
        sootn : (). % Рассчёт соотношения площадей столицы к принадлежащему государству.
        printGender_gos : (). % Вывод государств с количеством мужского и женского населения
        increaseNaselenie : (string, integer). % Увеличение числа населения определённого государства.
        decreaseNaselenie : (string, integer). % Уменьшение числа населения определённого государства.
        sumNaselenie : (list(string), naselenie). % Вычисление общего населения выбранных государств
        maxNaselenie : (list(string), naselenie). % Вычисление максимального населения выбранных государств
        minNaselenie : (list(string), naselenie). % Вычисление минимального населения выбранных государств
    clauses
        printGender_gos() :-
            gender_gos(Q, W, E, R),
            write("Gos: ", Q, " |Stolica: ", W, " |Gender: ", E, " |Naselenie: ", R),
            nl,
            fail.
        printGender_gos() :-
            write("That's all.\n").

        printGos() :-
            [Gosudstvo || gos(_, Gosudstvo, _, _, _)],
            write(Gosudstvo),
            nl,
            fail.
        printGos() :-
            write("That's all.\n").

        printStol() :-
            [Stolica || stol(_, Stolica, _, _)],
            write(Stolica),
            nl,
            fail.
        printStol() :-
            write("That's all.\n").

        printPred() :-
            pred(IdStol, IdGosudarstvo),
            write("ID столицы: ", IdStol, " ID государства: ", IdGosudarstvo),
            nl,
            fail.
        printPred() :-
            write("That's all.\n").

        zchsv(ChastSveta, Gosudarstva) :-
            [Gosudstvo || gos(_, Gosudstvo, ChastSveta, _, _)],
            append([Gosudstvo], Gosudarstva, NewGosudarstva),
            fail.
        zchsv(_, Gosudarstva) :-
            write("Список государств: "),
            write(Gosudarstva),
            nl.

        zidst(IdStol, ChastSveta) :-
            stol(IdStol, _, _, _),
            pred(IdStol, IdGosudarstvo),
            gos(IdGosudarstvo, _, ChastSveta, _, _),
            write("Часть света по этому id столицы: "),
            write(ChastSveta),
            nl.

        sootn() :-
            [ChastSveta, SrednPlStol, SrednPlGos] || (
                gos(_, _, ChastSveta, _, PlGos),
                findall(PlStol, (
                    pred(IdStol, IdGosudarstvo), gos(IdGosudarstvo, _, _, _, PlGos0), stol(IdStol, _, _, PlStol)
                ), PlStols),
                sumlist(PlStols, SumPlStol),
                length(PlStols, KolStol),
                SrednPlStol is SumPlStol/KolStol,
                SrednPlGos is PlGos/KolStol,
                Sootn is SrednPlStol / SrednPlGos,
                write("Соотношение: "),
                write(Sootn),
                nl
            ),
            fail.
        sootn() :-
            write("That's all.\n").

        increaseNaselenie(Gosudstvo, Num) :-
            retract(gos(IdGosudarstvo, Gosudstvo, ChastSveta, Naselenie, Ploschad)),
            asserta(gos(IdGosudarstvo, Gosudstvo, ChastSveta, Naselenie + Num, Ploschad)),
            nl,
            write("Население государства "),
            write(Gosudstvo),
            write(" увеличено на "),
            write(Num),
            write("."),
            nl.

        decreaseNaselenie(Gosudstvo, Num) :-
            retract(gos(IdGosudarstvo, Gosudstvo, ChastSveta, Naselenie, Ploschad)),
            asserta(gos(IdGosudarstvo, Gosudstvo, ChastSveta, Naselenie - Num, Ploschad)),
            nl,
            write("Население государства "),
            write(Gosudstvo),
            write(" уменьшено на "),
            write(Num),
            write("."),
            nl.

        sumNaselenie(Gosudarstva, SumNaselenie) :-
            [Naselenie || gos(_, Gosudstvo, _, Naselenie, _) , Gosudstvo in Gosudarstva],
            sumlist(Gosudarstvo, SumNaselenie),
            write("Общее население: "),
            write(SumNaselenie),
            nl.

        maxNaselenie(Gosudarstva, MaxNaselenie) :-
            [Naselenie || gos(_, Gosudstvo, _, Naselenie, _) , Gosudstvo in Gosudarstva],
            max_list(Gosudarstvo, MaxNaselenie),
            write("Максимальное население: "),
            write(MaxNaselenie),
            nl.

        minNaselenie(Gosudarstva, MinNaselenie) :-
            [Naselenie || gos(_, Gosudstvo, _, Naselenie, _) , Gosudstvo in Gosudarstva],
            min_list(Gosudarstvo, MinNaselenie),
            write("Минимальное население: "),
            write(MinNaselenie),
            nl.

clauses
    run() :-
increaseNaselenie(Gosudstvo, Amount) :-
            gos(IdGosudstva, Gosudstvo, _, Naselenie, _),
            NewNaselenie is Naselenie + Amount,
            retract(gos(IdGosudstva, Gosudstvo, ChastSveta, Naselenie, Ploschad)),
            assert(gos(IdGosudstva, Gosudstvo, ChastSveta, NewNaselenie, Ploschad)).

        decreaseNaselenie(Gosudstvo, Amount) :-
            gos(IdGosudstva, Gosudstvo, _, Naselenie, _),
            NewNaselenie is Naselenie - Amount,
            retract(gos(IdGosudstva, Gosudstvo, ChastSveta, Naselenie, Ploschad)),
            assert(gos(IdGosudstva, Gosudstvo, ChastSveta, NewNaselenie, Ploschad)).

        sumNaselenie(Gosudstva, Sum) :-
            findall(Naselenie, (member(G, Gosudstva), gos(_, G, _, Naselenie, _)), Naselenies),
            sumlist(Naselenies, Sum).

        maxNaselenie(Gosudstva, Max) :-
            findall(Naselenie, (member(G, Gosudstva), gos(_, G, _, Naselenie, _)), Naselenies),
            max_list(Naselenies, Max).

        minNaselenie(Gosudstva, Min) :-
            findall(Naselenie, (member(G, Gosudstva), gos(_, G, _, Naselenie, _)), Naselenies),
            min_list(Naselenies, Min).


clauses
    run() :-
        console::init(),
        reconsult("..\\information.txt", information),
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
        X = stdio::read(),
        Y = stdio::read(),
        sumNaselenie([X,Y],_),
        write("Total population of selected States:"),
        write(Sum),
        write(" \n"),
        X = stdio::read(),
        Y = stdio::read(),
        maxNaselenie([X,Y],_),
        write("Maximum population of selected States:"),
        write(Max),
       write(" \n"),
        X = stdio::read(),
        Y = stdio::read(),
        minNaselenie([X,Y],_),
        write("Minimum population of selected States:"),
        write(Min),
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
