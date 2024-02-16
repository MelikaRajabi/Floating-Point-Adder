`timescale 1ns/1ns

module fp_adder__tb_example();

   integer i, j, result_err, bit_err;

   reg [31:0] a, b, c, data[0:40000];

   initial begin

      bit_err = 0;
      result_err = 0;

      $readmemh("fp.hex_example.txt", data);

      if(data[0] === 'bx) begin
         $display("ERROR: fp.hex file is not read in properly");
         $display("Make sure this file is located in working directory");
         $stop;
      end

      for(i=0; i<28; i=i+1) begin

         a = data[i*3+0];
         b = data[i*3+1];
         c = data[i*3+2];

         #10;

         if(uut.s !== c) begin
            result_err = result_err + 1;
            $write("\tError: %8x + %8x, expected: %8x, but got: %8x\n", a, b, c, uut.s);
         end

         for(j=0; j<32; j=j+1)
            if(c[j] !== uut.s[j])
               bit_err = bit_err + 1;

      end

      if(result_err) begin
         $write("\n\n\tTotal Errors in the Results: %4d\n", result_err);
         $write("\tTotal Bit Mismatches in the Results: %d\n", bit_err);
      end
      else
         $write("\n\n\tWaw!! NO ERROR Found. Great Job.\n\n");

   end

   fp_adder uut( .a(a), .b(b), .s());                 // a + b

endmodule