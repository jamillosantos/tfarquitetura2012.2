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
$dic = array(
    //Non-Jump R-Type0  op rg
    array('ins' => "08", 'opc' => 0, 'asc' => 'jr'),
    array('ins' => "10", 'opc' => 0, 'asc' => 'mfhi'),
    array('ins' => "12", 'opc' => 0, 'asc' => 'mflo'),
    array('ins' => "11", 'opc' => 0, 'asc' => 'mthi'),
    array('ins' => "13", 'opc' => 0, 'asc' => 'mtlo'),
    
    //Non-Jump R-Type1  op rg rg
    array('ins' => "1A", 'opc' => 1, 'asc' => 'div'),
    array('ins' => "1B", 'opc' => 1, 'asc' => 'divu'),
    array('ins' => "09", 'opc' => 1, 'asc' => 'jalr'),
    array('ins' => "18", 'opc' => 1, 'asc' => 'mult'),
    array('ins' => "19", 'opc' => 1, 'asc' => 'multu'),
    array('ins' => "20", 'opc' => 1, 'asc' => 'cvt.s.w'),
    array('ins' => "24", 'opc' => 1, 'asc' => 'cvt.w.s'),
    array('ins' => "06", 'opc' => 1, 'asc' => 'mov.s'),
    
    //Non-Jump R-Type2  op rg rg rg
    array('ins' => "20", 'opc' => 2, 'asc' => 'add'),
    array('ins' => "21", 'opc' => 2, 'asc' => 'addu'),
    array('ins' => "24", 'opc' => 2, 'asc' => 'and'),
    array('ins' => "27", 'opc' => 2, 'asc' => 'nor'),
    array('ins' => "25", 'opc' => 2, 'asc' => 'or'),
    array('ins' => "00", 'opc' => 2, 'asc' => 'sll'),
    array('ins' => "04", 'opc' => 2, 'asc' => 'sllv'),
    array('ins' => "2A", 'opc' => 2, 'asc' => 'slt'),
    array('ins' => "2B", 'opc' => 2, 'asc' => 'sltu'),
    array('ins' => "03", 'opc' => 2, 'asc' => 'sra'),
    array('ins' => "07", 'opc' => 2, 'asc' => 'srav'),
    array('ins' => "02", 'opc' => 2, 'asc' => 'srl'),
    array('ins' => "06", 'opc' => 2, 'asc' => 'srlv'),
    array('ins' => "22", 'opc' => 2, 'asc' => 'sub'),
    array('ins' => "23", 'opc' => 2, 'asc' => 'subu'),
    array('ins' => "26", 'opc' => 2, 'asc' => 'xor'),
    array('ins' => "00", 'opc' => 2, 'asc' => 'add.s'),
    array('ins' => "03", 'opc' => 2, 'asc' => 'div.s'),
    array('ins' => "02", 'opc' => 2, 'asc' => 'mul.s'),
    array('ins' => "01", 'opc' => 2, 'asc' => 'sub.s'),
    
    //I-Type3 op rg imm
    array('ins' => "20", 'opc' => 3, 'asc' => 'lb'),
    array('ins' => "24", 'opc' => 3, 'asc' => 'lbu'),
    array('ins' => "21", 'opc' => 3, 'asc' => 'lh'),
    array('ins' => "25", 'opc' => 3, 'asc' => 'lhu'),
    array('ins' => "0F", 'opc' => 3, 'asc' => 'lui'),
    array('ins' => "23", 'opc' => 3, 'asc' => 'lw'),
    array('ins' => "31", 'opc' => 3, 'asc' => 'lwcl'),
    array('ins' => "29", 'opc' => 3, 'asc' => 'sh'),
    array('ins' => "2B", 'opc' => 3, 'asc' => 'sw'),
    array('ins' => "39", 'opc' => 3, 'asc' => 'swcl'),
   
    //I-Type4 op rg rg imm
    array('ins' => "08", 'opc' => 4, 'asc' => 'addi'),
    array('ins' => "09", 'opc' => 4, 'asc' => 'addiu'),
    array('ins' => "0C", 'opc' => 4, 'asc' => 'andi'),
    array('ins' => "0D", 'opc' => 4, 'asc' => 'ori'),
    array('ins' => "09", 'opc' => 4, 'asc' => 'slti'),
    array('ins' => "0B", 'opc' => 4, 'asc' => 'sltiu'),
    array('ins' => "0E", 'opc' => 4, 'asc' => 'xori'),
    
    //I-Type5 op rg label
    array('ins' => "01", 'opc' => 5, 'asc' => 'bgez'),
    array('ins' => "07", 'opc' => 5, 'asc' => 'bgtz'),
    array('ins' => "06", 'opc' => 5, 'asc' => 'blez'),
    array('ins' => "01", 'opc' => 5, 'asc' => 'bltz'),
    array('ins' => "02", 'opc' => 5, 'asc' => 'j'),
    array('ins' => "03", 'opc' => 5, 'asc' => 'jal'),
    
    //I-Type6 op rg rg label
    array('ins' => "04", 'opc' => 6, 'asc' => 'beq'),
    array('ins' => "05", 'opc' => 6, 'asc' => 'bne'),
    
    //J-Type7 op label
    array('ins' => "02", 'opc' => 7, 'asc' => 'j'),
    array('ins' => "03", 'opc' => 7, 'asc' => 'jal'),
    
    //Type8 op
    array('ins' => "0D", 'opc' => 8, 'asc' => 'break'),
    array('ins' => "0C", 'opc' => 8, 'asc' => 'syscall')
);

foreach($dic as $d){
    fwrite( $fp, pack("H*", $d["ins"]).pack("C", $d["opc"]).str_pad($d["asc"], 12, "\0")  );   
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
