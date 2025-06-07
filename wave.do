-- wave.do - Script de visualização para o testbench do Trabalho 3

add wave -divider "CLOCKS"
add wave -hex /tb_top/clk_1mhz

add wave -divider "ENTRADAS GERAIS"
add wave -hex /tb_top/reset
add wave -hex /tb_top/serial_in
add wave -hex /tb_top/write_in
add wave -hex /tb_top/ack_in
add wave -hex /tb_top/dequeue

add wave -divider "SAÍDAS DO SISTEMA"
add wave -hex /tb_top/data_out
add wave -hex /tb_top/len_out
add wave -hex /tb_top/status
add wave -hex /tb_top/ready

add wave -divider "INTERNOS (Top)"
add wave -hex /tb_top/uut/clk_100khz
add wave -hex /tb_top/uut/clk_10khz
add wave -hex /tb_top/uut/des_data_out
add wave -hex /tb_top/uut/fifo_enqueue