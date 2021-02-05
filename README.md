# PokéFinder

Descubra o verdadeiro potencial dos seus Pokémons.

## Conteúdo

- [Tecnologias Utilizadas](#Tecnologias)
- [Configuração do Ambiente](#Configuração)
- [Conteúdo](#Conteúdo)

## Tecnologias Utilizadas

- Escrito em Swift - 5.0
- Interfaces construidas com ViewCode
- Arquitetura MVVM
- RxSwift & RxCocoa para facilitar o bind entre objetos e views.
- RealmSwfit para persistência de dados locais.
- CocoaPods para gerenciamento de dependências.

## Configuração do Ambiente

Clone o repositório:

```sh
git clone https://github.com/jotape26/PokeFinder.git
cd PokeFinder
```

- Caso não tenha o CocoaPods instalado:

```sh
sudo gem install cocoapods
```

E para instalar as dependências:

```
pod install
```

## Conteúdo

- Proteção por Login e Senha ao app.
- Listagem facil com filtro de Pokémons favoritos.
- Pokémons favoritos são salvos para visualização offline.
- Acesso rápido a detalhes do Pokémon.

To-do:

- Listar os movimentos possiveis do Pokémon.
