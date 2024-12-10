module Custom6to3MUX(
    input [15:0] WDataPort1,
    input [15:0] WDataPort2,
    input [3:0] WPortName1,
    input [3:0] WPortName2,
    input InSignal1,
    input InSignal2,
    input ControlSignal,

    output [15:0] DataOut,
    output [3:0] PortOut,
    output SignalOut

);


assign DataOut = ControlSignal ? WDataPort2 : WDataPort1;
assign PortOut = ControlSignal ? WPortName2 : WPortName1;
assign SignalOut = ControlSignal ? InSignal2 : InSignal1;


endmodule