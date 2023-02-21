module muxMin
 (input        Timeset, 
  input        Szero, 
  input			Minadv,	
  output logic TMen);


	always_comb begin
		if(Timeset == 'd0 && Szero == 'd1) TMen = 'd1;
		else if(Timeset == 'd1 && Minadv == 'd1) TMen = 'd1;
		else TMen = 'd0;
	end
	
endmodule
