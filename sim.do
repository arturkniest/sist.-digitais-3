-- sim.do - Script para simular o projeto do Trabalho 3 no ModelSim

vlib work
vmap work work

vcom -2008 fila.vhd
vcom -2008 deserializador.vhd
vcom -2008 top.vhd
vcom -2008 tb_top.vhd

vsim work.tb_top

do wave.do
run 2 ms
