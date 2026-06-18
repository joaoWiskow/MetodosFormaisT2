class PilhaIlimitada{
    //Abstração
    ghost var Conteudo: seq<nat>
    ghost var Repr: set<object>
    //Implementação
    var a: array<nat>
    var cauda: nat

    //Invariante de classe
    ghost predicate Valid()

    constructor ()
    ensures Conteudo == []
    {
    cauda := 0;
    Conteudo := [];
    Repr := {this};
    }

    method Empilha(e:nat)
    modifies Repr
    ensures Valid()
    ensures Conteudo ==  [e] + old(Conteudo) 
    {
    a[cauda] := e;
    cauda := cauda + 1;
    Conteudo := Conteudo + [e];
    }


    method Desempilha(e:nat)
    method Main()

}