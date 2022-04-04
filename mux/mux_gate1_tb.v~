module mux_gate1_tb();
reg S0,I0,I1;
wire Y;
mux_gate1 DUT(.I0(I0),.I1(I1),.S0(S0),.Y(Y));
initial begin
I0=1'b0; I0=1'b0;S0=1'b0;
#2 I0=1'b1;
#2 S0=1'b1;
#2 I1=1'b1;
#2 $stop();
end

initial begin $monitor("time=%b,I0=%b,I1=%b, S0=%b,Y=%b",$time,I0,I1,S0,Y);
end
endmodule


module mux_gate1(S0,I0,I1,Y);
input S0,I0,I1;
output Y;
assign Y=S0 ? I1:I0;
endmodule
