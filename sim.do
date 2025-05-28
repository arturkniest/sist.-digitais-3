# Limpando e inicializando
vlib work
vmap work work

# Compilação dos arquivos VHDL
vcom -2008 deserializador.vhd
vcom -2008 fila.vhd
vcom -2008 top_level.vhd
vcom -2008 testbench_top.vhd

# Carregar o testbench
vsim work.testbench_top

# Adicionar sinais à visualização
add wave -divider "Clocks e Controle"
add wave clk_1MHz rst write ack dequeue

add wave -divider "Deserializador"
add wave -recursive uut/d_inst/*

add wave -divider "Fila"
add wave -recursive uut/f_inst/*

# Rodar simulação
run 2 ms

# Fim
