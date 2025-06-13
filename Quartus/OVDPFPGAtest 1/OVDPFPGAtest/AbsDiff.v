module AbsDiff(
    input  [31:0] A,
    input  [31:0] B,
    output reg [31:0] Diff
);

wire [31:0] subs = A-B;
wire sgn = subs[31];

    always@(*)
	 	 begin
       if(!sgn)
		   Diff <= A-B;
		 else
         Diff <= B-A;
    end
   // assign Diff = (A > B) ? (A - B) : (B - A);
endmodule 