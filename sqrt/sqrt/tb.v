module tb;  //testbench module is always empty. No input or output ports.

reg Clock, reset;
wire done;
parameter N = 16;   //width of the input.
reg [N-1:0] num_in;
reg [N:0] i;
wire [N/2-1:0] sq_root;
integer error,actual_result;  //this indicates the number of errors encountered during simulation.
parameter Clock_period = 10;    //Change clock period here. 

//Apply the inputs to the design and check if the results are correct. 
//The number of inputs for which the results were wrongly calculated are counted by 'error'. 
initial
begin
    Clock = 1;
    error = 0;
    i=1;
    //First we apply reset input for one clock period.
    reset = 1;
    #Clock_period;
    reset = 0;
    //Test the design for all the combination of inputs.
    //Since we have (2^16)-1 inputs, we test all of them one by one. 
    while(i<=2**N-1) begin
        apply_input(i);
        i = i+1;    
    end
    #Clock_period;
    reset = 1;   //all inputs are tested. Apply reset
    num_in = 0;     //reset the 'num_in'
    $stop;  //Stop the simulation, as we have finished testing the design.
end

task apply_input;
    input [N:0] i;
begin
    num_in = i[N-1:0];  
    wait(~done);    //wait for the 'done' to finish its previous high state
    wait(done); //wait until 'done' output goes High.
    wait(~Clock);   //we sample the output at the falling edge of the clock.
    actual_result = $rtoi($floor($pow(i,0.5))); //Calculate the actual result.
    //if actual result and calculated result are different increment 'error' by 1.
    if(actual_result != sq_root) 
        error = error + 1; 
end
endtask

//generate a 50Mhz clock for testing the design.
always #(Clock_period/2) Clock <= ~Clock;

//Instantiate the matrix multiplier
square_root #(.N(N)) find_sq_root 
        (.Clock(Clock), 
        .reset(reset), 
        .num_in(num_in), 
        .done(done),
        .sq_root(sq_root)
        );

endmodule   //End of testbench.




module square_root
    #(parameter N = 32)
    (   input Clock,  //Clock
        input reset,  //Asynchronous active high reset.      
        input [N-1:0] num_in,   //this is the number for which we want to find square root.
        output reg done,     //This signal goes high when output is ready
        output reg [N/2-1:0] sq_root  //square root of 'num_in'
    );

    reg [N-1:0] a;   //original input.
    reg [N/2+1:0] left,right;     //input to adder/sub.r-remainder.
    reg signed [N/2+1:0] r;
    reg [N/2-1:0] q;    //result.
    integer i;   //index of the loop. 

    always @(posedge Clock or posedge reset) 
    begin
        if (reset == 1) begin   //reset the variables.
            done <= 0;
            sq_root <= 0;
            i = 0;
            a = 0;
            left = 0;
            right = 0;
            r = 0;
            q = 0;
        end    
        else begin
            //Before we start the first clock cycle get the 'input' to the variable 'a'.
            if(i == 0) begin  
                a = num_in;
                done <= 0;    //reset 'done' signal.
                i = i+1;   //increment the loop index.
            end
            else if(i < N/2) begin //keep incrementing the loop index.
                i = i+1;  
            end
          
            right = {q,r[N/2+1],1'b1};
            left = {r[N/2-1:0], a[N-1:N-2]};
            a = {a[N-3:0], 2'b0};  //shifting left by 2 bit.
            if ( r[N/2+1] == 1)    //add or subtract as per this bit.
                r = left + right;
            else
                r = left - right;
            q = {q[N/2-2:0], ~r[N/2+1]};
            if(i == N/2) begin    //This means the max value of loop index has reached. 
                done <= 1;    //make 'done' high because output is ready.
                i = 0; //reset loop index for beginning the next cycle.
                sq_root <= q;   //assign 'q' to the output port.
                //reset other signals for using in the next cycle.
                left = 0;
                right = 0;
                r = 0;
                q = 0;
            end
        end    
    end

endmodule










