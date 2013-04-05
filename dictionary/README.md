
MIPS - Tipos de instruções:
---------------------------
Os tipos de instruções do MIPS são compostas por 32bits e classificadas pelo seu formato:
  - R-Type:

        opcode(6b) | rs(5b) | rd(5b) | rt(5b) | sa(5b) | function(6b)

    Instruções R-Type possuem opcode `0x00` e são identificadas pelo 6 últimos bits do campo `function`.
    
  - I-Type:
  
        opcode(6b) | rs(5b) | rt(5b) | immediate(16b)

    Instruções I-Type são indentificadas pelo 6 primeiros bits do opcode.

  - J-Type:
  
        opcode(6b) | label(26b)

    Instruções J-Type são indentificadas pelo 6 primeiros bits do opcode.
    
  - Coprocessor Instructions:
  
        opcode(6b) | format(5b) | ft(5b) | fs(5b) | fd(5b) | functions(6b)

    Coprocessor Instructions possuem opcode `0x11` e são identificadas pelo 6 últimos bits do campo `function`.

    

Definição de busca e uso do dicionário
--------------------------------------

A construção do dicionario de dá pelo array:

    array('opcode' => "", 'function' => "", 'type' => 0, 'asc' => '')
    
  * `opcode` - Hexadecimal do opcode da instrução. 
  * `function` - Hexadecimal do campo function da instrução.
  * `asc` - Texto do nome da função
  * `type` - Tipo que definine a estrutura de escrita da instrução:
      
    **R-Type**
    - `type => 0` - op
    - `type => 1` - op rs
    - `type => 2` - op rd
    - `type => 3` - op rs, rt
    - `type => 4` - op rd, rs
    - `type => 5` - op rd, rs, rt
    - `type => 6` - op rd, rt, rs
    - `type => 7` - op rd, rt, sa

    **I-Type**
    - `type => 8`  - op rs, label
    - `type => 9`  - op rs, rt, label
    - `type => 10` - op rt, rs, immediate
    - `type => 11` - op rt, immediate(rs)
    
    **J-Type**
    - `type => 12` - op label

    **Coprocessor-Type**
    - `type => 13` - op rs, fd
    - `type => 14` - op fd, fs
    - `type => 15` - op fd, fs, ft
    

  ###Busca no dicionário:
  
    A busca no dicionário deve ser feita a partir instrução.
    
    Verfica-se os 6 primeiros bits que identificam o opcode; caso o opcode seja `0x00`, o tipo será **R-Type**
    e a instrução será identificada pelos 6 últimos bits do campo function. caso o opcode seja `0x11`, o tipo
    será **Coprocessor-Type** e a função também será indentificada pelo campo function.
    Se o opcode não for `0x00` e nem `0x11` a instrunção será **I-Type** ou **J-Type**.
    
    **Indentificando as instruções:**
    * Ler 6 primeiros Bits:
      * Se 6 primeiros Bits igual a `0x00`:
      
          - Ler 6 últimos Bits.
          - Buscar a instrução pelo campo function no dicionário e opcode = `0x00`.
         
      * Se não Se 6 primeiros Bits igual a `0x11`:
      
          - Ler 6 últimos Bits.
          - Buscar a instrução pelo campo function no dicionário e opcode = `0x11`.
         
      * Se não:
      
          - Ler 6 primeiros Bits.
          - Buscar a instrução pelo opcode no dicionário.
         
    * Indentificar o tipo da escrita da instrução pelo campo type.
    * Escrever a função como o campo type especifíca.
    
Referências
-----------
1. https://github.com/jamillosantos/tfarquitetura2012.2/blob/master/dictionary/MIPS_reference.pdf
2. http://en.wikipedia.org/wiki/MIPS_architecture#cite_note-22
3. http://www.d.umn.edu/~gshute/spimsal/new/instruction-types.xhtml

