class PilhaIlimitadaV2 {
  // Abstração
  ghost var Conteudo: seq<int>
  ghost var Repr: set<object>

  // Implementação
  var a: array<int>
  var topo: nat // Indica a quantidade de elementos (e a próxima posição livre)

  // Invariante de classe
  ghost predicate Valid()
    reads this, Repr
    ensures Valid() ==> this in Repr && a in Repr
  {
    this in Repr &&
    a in Repr &&
    a.Length > 0 &&
    0 <= topo <= a.Length &&
    Conteudo == a[..topo]
  }

  // Construtor: Instancia uma pilha vazia com capacidade inicial
  constructor ()
    ensures Valid() && fresh(Repr - {this})
    ensures Conteudo == []
  {
    a := new int[4]; // Capacidade inicial arbitrária > 0
    topo := 0;
    Conteudo := [];
    Repr := {this, a};
  }

  // Consultar se a pilha está vazia
  function EstaVazia(): bool
    requires Valid()
    reads Repr
    ensures EstaVazia() == (|Conteudo| == 0)
  {
    topo == 0
  }

  // Consultar o número de elementos
  function Tamanho(): nat
    requires Valid()
    reads Repr
    ensures Tamanho() == |Conteudo|
  {
    topo
  }

  // Ler o topo sem remover
  function Topo(): int
    requires Valid()
    requires |Conteudo| > 0
    reads Repr
    ensures Topo() == Conteudo[|Conteudo| - 1]
  {
    a[topo - 1]
  }

  // Adicionar elemento (Empilhar) com redimensionamento se necessário
  method Empilha(e: int)
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
    ensures Conteudo == old(Conteudo) + [e]
  {
    if topo == a.Length {
      // Redimensiona o array dobrando o tamanho
      var novoArray := new int[a.Length * 2];
      
      // Copia os elementos antigos usando um loop verificado
      var i := 0;
      while i < topo
        invariant 0 <= i <= topo
        invariant novoArray[..i] == a[..i]
      {
        novoArray[i] := a[i];
        i := i + 1;
      }
      
      a := novoArray;
      Repr := {this, a}; // Atualiza o conjunto de representação
    }

    a[topo] := e;
    topo := topo + 1;
    Conteudo := Conteudo + [e];
  }

  // Remover elemento do topo
  method Desempilha() returns (e: int)
    requires Valid()
    requires |Conteudo| > 0
    modifies Repr
    ensures Valid()
    ensures e == old(Conteudo)[|old(Conteudo)| - 1]
    ensures Conteudo == old(Conteudo)[..|old(Conteudo)| - 1]
  {
    topo := topo - 1;
    e := a[topo];
    Conteudo := a[..topo];
  }

  // Inverter a ordem dos elementos da pilha
  method Inverte()
    requires Valid()
    modifies Repr
    ensures Valid()
    ensures |Conteudo| == |old(Conteudo)|
    ensures forall i :: 0 <= i < |Conteudo| ==> Conteudo[i] == old(Conteudo)[|old(Conteudo)| - 1 - i]
  {
    var i := 0;
    var j := topo - 1;
    while i < j
      invariant 0 <= i && j < topo
      invariant i + j == topo - 1 || i == j + 1
      invariant forall k :: 0 <= k < topo && k != i && k != j ==> a[k] == old(a[k]) // Preservação do resto
      // Inversão parcial das pontas até o índice atual:
      invariant forall k :: 0 <= k < i ==> a[k] == old(a[topo - 1 - k]) && a[topo - 1 - k] == old(a[k])
    {
      var temp := a[i];
      a[i] := a[j];
      a[j] := temp;
      i := i + 1;
      j := j - 1;
    }
    Conteudo := a[..topo];
  }

  // Empilhar outra pilha sobre esta (consome a outra pilha esvaziando-a)
  method EmpilhaPilha(outra: PilhaIlimitada)
    requires Valid() && outra.Valid()
    requires this != outra && Repr !! outra.Repr // Garante que são instâncias separadas na memória
    modifies Repr, outra.Repr
    ensures Valid() && outra.Valid()
    ensures Conteudo == old(Conteudo) + old(outra.Conteudo)
    ensures outra.Conteudo == []
  {
    var elementosParaCopiar := outra.Tamanho();
    var i := 0;
    
    while i < elementosParaCopiar
      invariant Valid() && outra.Valid()
      invariant this != outra && Repr !! outra.Repr
      invariant 0 <= i <= elementosParaCopiar
      invariant outra.Conteudo == old(outra.Conteudo)
      invariant Conteudo == old(Conteudo) + outra.Conteudo[..i]
    {
      var e := outra.a[i];
      this.Empilha(e);
      i := i + 1;
    }
    
    // Esvazia a outra pilha conforme a especificação do comportamento
    outra.topo := 0;
    outra.Conteudo := [];
  }
}

// Métodos de Teste Unitário (Main)
method Main() {
  var pilha := new PilhaIlimitada();
  
  assert pilha.EstaVazia() == true;
  assert pilha.Tamanho() == 0;

  // Testando Empilhar (Garante que ultrapasse o tamanho inicial 4 para testar redimensionamento)
  pilha.Empilha(10);
  pilha.Empilha(20);
  pilha.Empilha(30);
  pilha.Empilha(40);
  pilha.Empilha(50); // Aqui ocorre o redimensionamento interno automático

  assert pilha.Tamanho() == 5;
  assert pilha.Topo() == 50;
  assert pilha.Conteudo == [10, 20, 30, 40, 50];

  // Testando Desempilhar
  var e := pilha.Desempilha();
  assert e == 50;
  assert pilha.Topo() == 40;
  assert pilha.Conteudo == [10, 20, 30, 40];

  // Testando Inversão
  pilha.Inverte();
  assert pilha.Conteudo == [40, 30, 20, 10];
  assert pilha.Topo() == 10;

  // Testando Empilhar outra Pilha
  var outraPilha := new PilhaIlimitada();
  outraPilha.Empilha(100);
  outraPilha.Empilha(200);

  pilha.EmpilhaPilha(outraPilha);
  assert pilha.Conteudo == [40, 30, 20, 10, 100, 200];
  assert outraPilha.Conteudo == []; // A outra pilha foi limpa com sucesso
}