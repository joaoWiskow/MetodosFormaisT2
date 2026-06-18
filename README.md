# MetodosFormaisT2
Destinado a resolução do trabalho 2 da disciplina de métodos formais
Enunciado do Problema:
Estamos interessados em implementar o tipo abstrato de dados Pilha (sem limite de tamanho) 
através da implementação concreta utilizando arrays. Observe que é obrigatório o uso de arrays
em todas as operações de implementação concreta!
Para tal será necessário criar uma classe Pilha em Dafny e representar os atributos, métodos, 
funções e predicados de acordo com as seguintes instruções. Para fins de simplificação, 
considere a declaração de Pilhas contendo números inteiros e não se preocupe em implementar 
uma coleção genérica.
Representação abstrata (via ghost):
• Representar a coleção de elementos da pilha.
• Representar qualquer outra informação pertinente para a correta verificação de correção 
da implementação.
Invariante de classe (via predicate):
• Utilizar um predicado Valid() adequado para a invariante da representação abstrata
associada à coleção do tipo pilha.
Operações:
• Construtor deve instanciar uma pilha vazia.
• Adicionar um novo elemento no topo da pilha.
• Remover um elemento do topo da pilha, caso ela não esteja vazia.
• Ler o valor do topo da pilha, sem removê-lo, caso a pilha não esteja vazia.
• Verificar se a pilha está vazia ou não.
• Consultar o número de elementos armazenados na pilha.
• Inverter a ordem dos elementos da pilha.
• Empilhar uma pilha sobre outra.
Todas as pré-condições, pós-condições, invariantes e variantes devem ser corretamente 
especificadas. Faz parte da avaliação do trabalho o completo entendimento de quais asserções 
devem fazer parte da especificação das operações solicitadas sobre a estrutura de dados.
Por fim, construa um pequeno método “Main” demonstrando o uso das operações 
implementadas e verificando asserções (no estilo de teste unitário) para um número de casos
que garantam uma cobertura razoável.
