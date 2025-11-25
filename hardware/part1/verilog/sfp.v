module sfp (clk, reset, in, out, acc_en, relu_en, valid_in, valid_out);

  parameter col = 8;
  parameter psum_bw = 16;

  input clk;
  input reset;
  input [psum_bw*col-1:0] in;
  output [psum_bw*col-1:0] out;
  input acc_en;      // Accumulation enable
  input relu_en;     // ReLU enable
  input valid_in;    // Input valid signal
  output valid_out;  // Output valid signal

  reg [psum_bw*col-1:0] acc_reg;
  reg [psum_bw*col-1:0] out_reg;
  reg valid_out_reg;
  
  assign out = out_reg;
  assign valid_out = valid_out_reg;

  always @ (posedge clk) begin
    if (reset) begin
      acc_reg <= 0;
      out_reg <= 0;
      valid_out_reg <= 0;
    end else begin
      valid_out_reg <= valid_in;
      
      if (valid_in) begin
        // Accumulation logic - fully unrolled for each column
        if (acc_en) begin
          acc_reg[psum_bw*1-1:psum_bw*0] <= $signed(acc_reg[psum_bw*1-1:psum_bw*0]) + $signed(in[psum_bw*1-1:psum_bw*0]);
          acc_reg[psum_bw*2-1:psum_bw*1] <= $signed(acc_reg[psum_bw*2-1:psum_bw*1]) + $signed(in[psum_bw*2-1:psum_bw*1]);
          acc_reg[psum_bw*3-1:psum_bw*2] <= $signed(acc_reg[psum_bw*3-1:psum_bw*2]) + $signed(in[psum_bw*3-1:psum_bw*2]);
          acc_reg[psum_bw*4-1:psum_bw*3] <= $signed(acc_reg[psum_bw*4-1:psum_bw*3]) + $signed(in[psum_bw*4-1:psum_bw*3]);
          acc_reg[psum_bw*5-1:psum_bw*4] <= $signed(acc_reg[psum_bw*5-1:psum_bw*4]) + $signed(in[psum_bw*5-1:psum_bw*4]);
          acc_reg[psum_bw*6-1:psum_bw*5] <= $signed(acc_reg[psum_bw*6-1:psum_bw*5]) + $signed(in[psum_bw*6-1:psum_bw*5]);
          acc_reg[psum_bw*7-1:psum_bw*6] <= $signed(acc_reg[psum_bw*7-1:psum_bw*6]) + $signed(in[psum_bw*7-1:psum_bw*6]);
          acc_reg[psum_bw*8-1:psum_bw*7] <= $signed(acc_reg[psum_bw*8-1:psum_bw*7]) + $signed(in[psum_bw*8-1:psum_bw*7]);
        end else begin
          acc_reg <= in;
        end

        // ReLU logic - fully unrolled for each column
        if (relu_en) begin
          out_reg[psum_bw*1-1:psum_bw*0] <= ($signed(acc_reg[psum_bw*1-1:psum_bw*0]) < 0) ? 16'h0 : acc_reg[psum_bw*1-1:psum_bw*0];
          out_reg[psum_bw*2-1:psum_bw*1] <= ($signed(acc_reg[psum_bw*2-1:psum_bw*1]) < 0) ? 16'h0 : acc_reg[psum_bw*2-1:psum_bw*1];
          out_reg[psum_bw*3-1:psum_bw*2] <= ($signed(acc_reg[psum_bw*3-1:psum_bw*2]) < 0) ? 16'h0 : acc_reg[psum_bw*3-1:psum_bw*2];
          out_reg[psum_bw*4-1:psum_bw*3] <= ($signed(acc_reg[psum_bw*4-1:psum_bw*3]) < 0) ? 16'h0 : acc_reg[psum_bw*4-1:psum_bw*3];
          out_reg[psum_bw*5-1:psum_bw*4] <= ($signed(acc_reg[psum_bw*5-1:psum_bw*4]) < 0) ? 16'h0 : acc_reg[psum_bw*5-1:psum_bw*4];
          out_reg[psum_bw*6-1:psum_bw*5] <= ($signed(acc_reg[psum_bw*6-1:psum_bw*5]) < 0) ? 16'h0 : acc_reg[psum_bw*6-1:psum_bw*5];
          out_reg[psum_bw*7-1:psum_bw*6] <= ($signed(acc_reg[psum_bw*7-1:psum_bw*6]) < 0) ? 16'h0 : acc_reg[psum_bw*7-1:psum_bw*6];
          out_reg[psum_bw*8-1:psum_bw*7] <= ($signed(acc_reg[psum_bw*8-1:psum_bw*7]) < 0) ? 16'h0 : acc_reg[psum_bw*8-1:psum_bw*7];
        end else begin
          out_reg <= acc_reg;
        end
      end
    end
  end

endmodule

