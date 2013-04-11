<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title></title>
    </head>
    <body>
<?php
try {
//abreaquivo ou cria
$fp = fopen("dictionary", "w+");

// escreve segundo paramentro no arquivo de $fp
//Refazer 
/*
 *  array("opcode" => "00", function = "", "type" => 0, "asc" => "")
 *  fwrite( $fp, pack("H*", $d["opc"]).pack("H*", $d["function"]).pack("C", $d["type"]).str_pad($d["asc"], 12, "\0")  ); 
 */
$dic = array(
    //R-Type0 - op
    array('opcode' => "00", 'function' => "0C", 'type' => 0, 'asc' => 'syscall'),
    array('opcode' => "00", 'function' => "0D", 'type' => 0, 'asc' => 'break'),

    //R-Type1 - op rs
    array("opcode" => "00", 'function' => "08", 'type' => 1, 'asc' => 'jr'),
    array("opcode" => "00", 'function' => "11", 'type' => 1, 'asc' => 'mthi'),
    array("opcode" => "00", 'function' => "13", 'type' => 1, 'asc' => 'mtlo'),

    //R-Type2 - op rd
    array("opcode" => "00", 'function' => "10", 'type' => 2, 'asc' => 'mfhi'),
    array("opcode" => "00", 'function' => "12", 'type' => 2, 'asc' => 'mflo'),

    //R-Type3 - op rs rt
    array("opcode" => "00", 'function' => "18", 'type' => 3, 'asc' => 'mult'),
    array("opcode" => "00", 'function' => "19", 'type' => 3, 'asc' => 'multu'),
    array("opcode" => "00", 'function' => "1A", 'type' => 3, 'asc' => 'div'),
    array("opcode" => "00", 'function' => "1B", 'type' => 3, 'asc' => 'divu'),

    //R-Type4 - op rd rs
    array("opcode" => "00", 'function' => "09", 'type' => 4, 'asc' => 'jalr'),

    //R-Type5 - op rd rs rt
    array("opcode" => "00", 'function' => "20", 'type' => 5, 'asc' => 'add'),
    array("opcode" => "00", 'function' => "21", 'type' => 5, 'asc' => 'addu'),
    array("opcode" => "00", 'function' => "22", 'type' => 5, 'asc' => 'sub'),
    array("opcode" => "00", 'function' => "23", 'type' => 5, 'asc' => 'subu'),
    array("opcode" => "00", 'function' => "24", 'type' => 5, 'asc' => 'and'),
    array("opcode" => "00", 'function' => "25", 'type' => 5, 'asc' => 'or'),
    array("opcode" => "00", 'function' => "26", 'type' => 5, 'asc' => 'xor'),
    array("opcode" => "00", 'function' => "27", 'type' => 5, 'asc' => 'nor'),
    array("opcode" => "00", 'function' => "2A", 'type' => 5, 'asc' => 'slt'),
    array("opcode" => "00", 'function' => "2B", 'type' => 5, 'asc' => 'sltu'),

    //R-Type6 - op rd rt rs
    array("opcode" => "00", 'function' => "04", 'type' => 6, 'asc' => 'sllv'),
    array("opcode" => "00", 'function' => "06", 'type' => 6, 'asc' => 'srlv'),
    array("opcode" => "00", 'function' => "07", 'type' => 6, 'asc' => 'srav'),

    //R-Type7 - op rd rt sa
    array("opcode" => "00", 'function' => "00", 'type' => 7, 'asc' => 'sll'),
    array("opcode" => "00", 'function' => "02", 'type' => 7, 'asc' => 'srl'),
    array("opcode" => "00", 'function' => "03", 'type' => 7, 'asc' => 'sra'),
    

    //I-Type8 - op rs label
    array('opcode' => "01", 'function' => "00", 'type' => 8, 'asc' => 'bltz'),
    array('opcode' => "01", 'function' => "00", 'type' => 8, 'asc' => 'bgez'),
    array('opcode' => "06", 'function' => "00", 'type' => 8, 'asc' => 'blez'),
    array('opcode' => "07", 'function' => "00", 'type' => 8, 'asc' => 'bgtz'),

    //I-Type9 - op rs rt label
    array('opcode' => "04", 'function' => "00", 'type' => 9, 'asc' => 'beq'),
    array('opcode' => "05", 'function' => "00", 'type' => 9, 'asc' => 'bne'),

    //I-Type10 - op rt rs immediate
    array('opcode' => "08", 'function' => "00", 'type' => 10, 'asc' => 'addi'),
    array('opcode' => "09", 'function' => "00", 'type' => 10, 'asc' => 'addiu'),
    array('opcode' => "0A", 'function' => "00", 'type' => 10, 'asc' => 'slti'),
    array('opcode' => "0B", 'function' => "00", 'type' => 10, 'asc' => 'sltiu'),
    array('opcode' => "0C", 'function' => "00", 'type' => 10, 'asc' => 'andi'),
    array('opcode' => "0D", 'function' => "00", 'type' => 10, 'asc' => 'ori'),
    array('opcode' => "0E", 'function' => "00", 'type' => 10, 'asc' => 'xori'),

    //I-Type11 - op rt immediate(rs)
    array('opcode' => "0F", 'function' => "00", 'type' => 11, 'asc' => 'lui'),
    array('opcode' => "20", 'function' => "00", 'type' => 11, 'asc' => 'lb'),
    array('opcode' => "21", 'function' => "00", 'type' => 11, 'asc' => 'lh'),
    array('opcode' => "23", 'function' => "00", 'type' => 11, 'asc' => 'lw'),
    array('opcode' => "24", 'function' => "00", 'type' => 11, 'asc' => 'lbu'),
    array('opcode' => "25", 'function' => "00", 'type' => 11, 'asc' => 'lhu'),
    array('opcode' => "28", 'function' => "00", 'type' => 11, 'asc' => 'sb'),
    array('opcode' => "29", 'function' => "00", 'type' => 11, 'asc' => 'sh'),
    array('opcode' => "2B", 'function' => "00", 'type' => 11, 'asc' => 'sw'),
    array('opcode' => "31", 'function' => "00", 'type' => 11, 'asc' => 'lwcl'),
    array('opcode' => "39", 'function' => "00", 'type' => 11, 'asc' => 'swcl'),
    
    //J-Type12 op label
    array('opcode' => "02", 'function' => "00", 'type' => 12, 'asc' => 'j'),
    array('opcode' => "03", 'function' => "00", 'type' => 12, 'asc' => 'jal'),
    
    //Coprocessor-Type13 - op rs fd
    array("opcode" => "11", 'function' => "00", "type" => 13, "asc" => "mtc1"),

    //Coprocessor-Type14 - op fd fs 
    array("opcode" => "11", 'function' => "20", "type" => 14, "asc" => "cvt.s.w"),
    array("opcode" => "11", 'function' => "24", "type" => 14, "asc" => "cvt.w.s"),
    array("opcode" => "11", 'function' => "06", "type" => 14, "asc" => "mov.s"),

    //Coprocessor-Type15 - op fd fs ft
    array("opcode" => "11", 'function' => "00", "type" => 15, "asc" => "add.s"),
    array("opcode" => "11", 'function' => "03", "type" => 15, "asc" => "div.s"),
    array("opcode" => "11", 'function' => "02", "type" => 15, "asc" => "mul.s"),
    array("opcode" => "11", 'function' => "01", "type" => 15, "asc" => "sub.s")
);

foreach($dic as $d){
    //fwrite( $fp, pack("H*", $d["i"]).pack("C", $d["opc"]).str_pad($d["asc"], 12, "\0")  );   
    fwrite( $fp, pack("H*", $d["opcode"]).pack("H*", $d["function"]).pack("C", $d["type"]).str_pad($d["asc"], 13, "\0")  );
}

// Fecha o arquivo
fclose($fp);
} catch (Exception $e) {
    echo "Erro: ",  $e->getMessage(), "\n";
}

echo "Dicionario criado!";

?>
    </body>
</html>
