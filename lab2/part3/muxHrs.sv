module muxHrs
 (input        Timeset, 
  input        Szero,
  input 			Mzero, 
  input			Hrsadv,
  output logic THen);
 //
always_comb begin
	if(Timeset == 'd0 && Szero == 'd1 && Mzero == 'd1) THen = 'd1;
	else if(Timeset == 'd1 && Hrsadv == 'd1) THen = 'd1;
	else THen = 'd0;
end
endmodule
