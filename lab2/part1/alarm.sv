// cse140lsp22 - toy story edition
// How does this work? How long does the alarm stay on? 
// (buzz is the alarm itself)
// observe that the alarm would only buzz for 1 min (the interval when tmin=amin and thrs=ahrs)
// can we do something better? like buzzing until Andy switches it off? 
// think of what could be the changes (you don't have to implement it).
module alarm(
  input[6:0]   tmin,
               amin,
               thrs,
               ahrs,						 
  output logic buzz
);

/* fill in the guts
  combinational logic (no clock, use =, not <=) 
  buzz = 1 iff tmin=amin and thrs=ahrs
*/

always_comb begin
	buzz = tmin==amin && thrs==ahrs;	
	end
endmodule
