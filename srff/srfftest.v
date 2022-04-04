
`include "srff.v"
module srfftb();

reg s,r,clk=0;
wire q,qbar;
always #15 clk=~clk;

srff OUT (.s(s),.r(r),.clk(clk),.q(q),.qbar(qbar));
initial begin

s=0;
r=0;
#10
s=0;
r=1;
#10
s=1;
r=1;
#10;
$display("s=%b r=%b clk=%b q=%b qbar=%b",s,r,clk,q,qbar); 

end 


endmodule 

