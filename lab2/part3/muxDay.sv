module muxDay 
 (input        Timeset, 
  input        Szero,
  input 			Mzero, 
  input 			Hzero, 
  input 			Dayadv,
  output logic TDen);
  
always_comb begin
	if(Timeset == 'd0 && Szero == 'd1 && Mzero == 'd1 && Hzero == 'd1) TDen = 'd1;
	else if(Timeset == 'd1 && Dayadv == 'd1) TDen = 'd1;
	else TDen = 'd0;
end
endmodule
