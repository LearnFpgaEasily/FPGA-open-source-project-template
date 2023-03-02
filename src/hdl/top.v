module top(
    input clock,
    input resetn,
    output reg LED
);

always @(posedge clock)
begin
if(!resetn)
    LED <= 1'b0;
else 
    LED <= 1'b1;
end

endmodule