// CSE140L  
// see Structural Diagram in Lab2 Part 3 assignment writeup
// fill in missing connections and parameters
module lab2_part3_top_level(
  input Reset,
        Timeset, 	  // manual buttons
        Alarmset,	  //	(five total)
		Minadv,
		Hrsadv,
        Dayadv,
        Monthadv,
        Dateadv,
		Alarmon,
		Pulse,		  // assume 1/sec.
// 6 decimal digit display (7 segment)
  output[6:0] S1disp, S0disp, 	   // 2-digit seconds display
               M1disp, M0disp, 
               H1disp, H0disp,     // hours display
               D0disp,             // day of week display
               Month1disp, Month0disp,     // 2-digit month display
               Date1disp, Date0disp,     // date display
  output logic Buzz);	           // alarm sounds

//...
  logic[6:0] TSec, TMin, THrs,     // clock/time 
             AMin, AHrs;		   // alarm setting
  logic[6:0] Min, Hrs,Day,Date,Month;
  logic Szero, Mzero, Hzero,Dzero,Datezero,Monthzero, 	   // "carry out" from sec -> min, min -> hrs, hrs -> days
        TMen, THen,TDen,TDateen,TMonthen, AMen, AHen; 
  logic Buzz1;	                   // intermediate Buzz signal



ct_mod_N #(.N('d60)) Sct(
    .clk(Pulse), .rst(Reset), .en(~Timeset), .ct_out(TSec), .z(Szero)
    );
	 	 
	
	
// minutes counter -- runs at either 1/sec or 1/60sec
	muxMin mMin(.Timeset(Timeset), .Szero(Szero), .Minadv(Minadv), .TMen(TMen));
  ct_mod_N #(.N('d60)) Mct(
    .clk(Pulse), .rst(Reset), .en(TMen), .ct_out(TMin), .z(Mzero)
    );

	
// hours counter -- runs at either 1/sec or 1/60min
	muxHrs mHrs(.Timeset(Timeset), .Szero(Szero), .Mzero(Mzero), .Hrsadv(Hrsadv), .THen(THen));
  ct_mod_N #(.N('d24)) Hct(
	.clk(Pulse), .rst(Reset), .en(THen), .ct_out(THrs), .z(Hzero)
    );

	 
	 
// Day counter -- runs at either 1/sec or 1/24Hrs
	muxDay mDay(.Timeset(Timeset), .Szero(Szero), .Mzero(Mzero), .Hzero(Hzero), .Dayadv(Dayadv), .TDen(TDen));
  ct_mod_N #(.N('d7)) Dct(
	.clk(Pulse), .rst(Reset), .en(TDen), .ct_out(Day), .z(Dzero)
    ); 
	

	//Month counter
always_comb begin
	if(Timeset == 'd0 && Szero == 'd1 && Mzero == 'd1 && Hzero == 'd1 && Datezero == 'd1) TMonthen = 'd1;
	else if(Timeset == 'd1 && Monthadv == 'd1) TMonthen = 'd1;
	else TMonthen = 'd0;
end

	ct_mod_N #(.N('d12)) Monthct(
	.clk(Pulse), .rst(Reset), .en(TMonthen), .ct_out(Month), .z(Monthzero)
    ); 

	
// Date counter
always_comb begin
	if(Timeset == 'd0 && Szero == 'd1 && Mzero == 'd1 && Hzero == 'd1) TDateen = 'd1;
	else if(Timeset == 'd1 && Dateadv == 'd1) TDateen = 'd1;
	else TDateen = 'd0;
end
  ct_mod_D Datect(
	.clk(Pulse), .rst(Reset), .TMo0(Month), .en(TDateen), .ct_out(Date), .z(Datezero)
    ); 
	

// alarm set registers -- either hold or advance 1/sec
	 always_comb begin
		if(Alarmset == 'd1 && Minadv == 'd1) 
			AMen = 'd1;
		else AMen = 'd0;
	 end
	 
  ct_mod_N #(.N('d60)) Mreg(
    .clk(Pulse), .rst(Reset), .en(AMen), .ct_out(AMin), .z()
    ); 
	 
	 
	 always_comb begin
		if(Alarmset == 'd1 && Hrsadv == 'd1) 
			AHen = 'd1;
		else AHen = 'd0;
	 end
  ct_mod_N #(.N('d24)) Hreg(
    .clk(Pulse), .rst(Reset), .en(AHen), .ct_out(AHrs), .z()
    ); 
	 
	 


// display drivers (2 digits each, 6 digits total)
	 always_comb begin
		if(Alarmset == 'd1 && Timeset == 'd0) begin
			Min = AMin;
			Hrs = AHrs;
		end else begin
			Min = TMin;
			Hrs = THrs;
		end
	 end
  lcd_int Sdisp(
    .bin_in (TSec)  ,
	.Segment1  (S1disp),
	.Segment0  (S0disp)
	);


  lcd_int Mdisp(
    .bin_in (Min) ,
	.Segment1  (M1disp),
	.Segment0  (M0disp)
	);


  lcd_int Hdisp(
    .bin_in (Hrs),
	.Segment1  (H1disp),
	.Segment0  (H0disp)
	);

	
  lcd_int Ddisp(
    .bin_in (Day),
	.Segment1  (),
	.Segment0  (D0disp)
	);

  lcd_int Datedisp(
    .bin_in (Date + 'd1),
	.Segment1  (Date1disp),
	.Segment0  (Date0disp)
	);
	
	
  lcd_int Mothdisp(
    .bin_in (Month + 'd1),
	.Segment1  (Month1disp),
	.Segment0  (Month0disp)
	);
	

// buzz off :)	  make the connections
  alarm a1(
    .tmin(TMin), .amin(AMin), .thrs(THrs), .ahrs(AHrs), .buzz(Buzz1)
	);

	

always_comb begin
	if(Alarmon == 'd1 && Buzz1 == 'd1) begin
		case(Day)
		'd0:  	 Buzz = 1'b0;
		'd6:  	 Buzz = 1'b0;
		default:  Buzz = 1'b1;
		endcase
	end
	else Buzz = 'd0;
end	
endmodule
