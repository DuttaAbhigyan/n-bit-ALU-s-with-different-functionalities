/*Description: In this code I have implemented various simple 32 bit Integer Arithmetic modules namely Full Adder (ripple 
carry), Subtractor, 16bit multiplicator, Comparator, 1's complement, 2's complement, biteise AND, bitwise OR. All the 
implemented modules are created using gate level modelling wherever possible*/

/* Different modules/componrnts using gate level design for a 32 bit ALU is described below*/

/*Multiplexer module to decide the operation to be performed*/
module multiplexer(outReal,in1,in2,choice);
  output [31:0]outReal;
  wire [31:0]out[0:7];
  input [31:0]in1,in2;
  input [2:0]choice;
  reg [31:0]outReal1;
  wire c_out;
  
  bitwise_and ba(out[0],in1,in2);
  bitwise_or bo(out[1],in1,in2);
  thirtytwo_bit_fa tbf(c_out,out[2],0,in1,in2);
  ones_complement oc(out[3],in1);
  twos_complement tc(out[4],in1);
  subtractor sbt(out[5],c_in,x,y);
  sixteen_bit_multiplicator sbm(out[6],in1,in2);
  thirty_two_bit_comparator ttbc(out[7],in1,in2);
  
  always@(choice)
    begin
      if(choice==0)
        assign outReal1=out[0];
      else if(choice==1)
        assign outReal1=out[1];
      else if(choice==2)
        assign outReal1=out[2];
      else if(choice==3)
        assign outReal1=out[3];
      else if(choice==4)
        assign outReal1=out[4];
      else if(choice==5)
        assign outReal1=out[5];
      else if(choice==6)
        assign outReal1=out[6];
      else if(choice==7)
        assign outReal1=out[7];
    end
  assign outReal=outReal1;
endmodule
  

/*Bitwise AND module*/ 
module bitwise_and(out,x,y);
  output [31:0]out;
  input [31:0]x,y;
  assign out=x & y;
endmodule

/*Bitwise OR module*/ 
module bitwise_or(out,x,y);
  output [31:0]out;
  input [31:0]x,y;
  assign out=x | y;
endmodule

/*1 bit Full Adder*/ 
module one_bit_fa(c_out,sum,c_in,x,y);
  input c_in,x,y;
  output c_out,sum;
  wire s1,s2,s3;
  
  xor(s1,x,y);
  xor(sum,s1,c_in);
  and(s2,s1,c_in);
  and(s3,x,y);
  or(c_out,s3,s2);
endmodule
  
/*4bit Full Adder using ripple from pre-defined 1 Bit Adder*/ 
module four_bit_fa(c_out,sum,c_in,x,y);
  output [3:0]sum;
  output c_out;
  input [3:0]x,y;
  input c_in;
  wire c1,c2,c3;
  
  one_bit_fa one_fa0(c1,sum[0],c_in,x[0],y[0]);
  one_bit_fa one_fa1(c2,sum[1],c1,x[1],y[1]);
  one_bit_fa one_fa2(c3,sum[2],c2,x[2],y[2]);
  one_bit_fa one_fa3(c_out,sum[3],c3,x[3],y[3]);
endmodule


/*16 bit Full Adder using ripple from pre-defined 4 Bit Adder*/ 
module sixteen_bit_fa(c_out,sum,c_in,x,y);
  output [15:0]sum;
  output c_out;
  input [15:0]x,y;
  input c_in;
  wire c1,c2,c3;
  
  four_bit_fa four_fa0(c1,sum[3:0],c_in,x[3:0],y[3:0]);
  four_bit_fa four_fa1(c2,sum[7:4],c1,x[7:4],y[7:4]);
  four_bit_fa four_fa2(c3,sum[11:8],c2,x[11:8],y[11:8]);
  four_bit_fa four_fa3(c_out,sum[15:12],c3,x[15:12],y[15:12]);
endmodule


/*32 bit Full Adder using ripple from pre-defined 16 Bit Adder*/ 
module thirtytwo_bit_fa(c_out,sum,c_in,x,y);
  output [31:0]sum;
  output c_out;
  input [31:0]x,y;
  input c_in;
  wire c1;
  
  sixteen_bit_fa sixteen_fa0(c1,sum[15:0],c_in,x[15:0],y[15:0]);
  sixteen_bit_fa sixteen_fa1(c_out,sum[31:16],c1,x[31:16],y[31:16]);
endmodule


/*32 bit one's complement*/ 
module ones_complement(out,in);
  input [31:0]in;
  output [32:0]out;
  assign out=~in;
endmodule

/*32 bit two's complement*/ 
module twos_complement(out,in);
  input [31:0]in;
  output [32:0]out;
  wire [31:0]sum,y;
  wire c_out;
  ones_complement oc0(y,in);
  thirtytwo_bit_fa thirtytwo_fa0(c_out,sum,0,1,y);
  assign out={c_out,sum};
endmodule

/*32 bit Full Subtractor using ripple from pre-defined 32 Bit Adder*/ 
module subtractor(out,c_in,x,y);
  output [31:0]out;
  input [31:0]x,y;
  input c_in;
  wire c_out,c_dummy;
  wire [31:0]sum1,sum2,sum3,y_c;
  
  
  ones_complement oc0(y_c,y);
  thirtytwo_bit_fa thirtytwo_fa0(c_out,sum1,c_in,x,y_c);
  ones_complement oc1(sum2,sum1);
  thirtytwo_bit_fa thirtytwo_fa1(c_dummy,sum3,c_in,sum1,c_out);
  assign out=c_out?sum3:-sum2;
endmodule

/*4 bit Full Multiplicator using ripple from pre-defined Adders*/ 
module four_bit_multiplicator(out,in1,in2);
  output [31:0]out;
  input [15:0]in1,in2;
  wire [15:0]t1,t2,t3,t4,t5,t6,t7,u2,u3,u4;
  wire c1,c2,c3;
  assign t1=in1 & {4{in2[0]}};
  assign t2=in1 & {4{in2[1]}};
  assign t3=in1 & {4{in2[2]}};
  assign t4=in1 & {4{in2[3]}};
  assign u2=t2<<1;
  assign u3=t3<<2;
  assign u4=t4<<3;
  
  sixteen_bit_fa sbf0(c1,t5,0,t1,u2);
  sixteen_bit_fa sbf1(c2,t6,c1,t5,u3);
  sixteen_bit_fa sbf2(c3,t7,c2,t6,u4);
  assign out={c3,t7};
endmodule

/*4 bit Full Multiplicator using ripple from pre-defined 4 bit Full Multiplicator*/ 
module sixteen_bit_multiplicator(out,in1,in2);
  output [32:0]out;
  input [15:0]in1,in2;
  wire [31:0]t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,u2,u3,u4,u5,u6,u7,u8,u9,u10,u11,u12,u13,u14,u15,u16;
  wire c[0:14];
  wire [31:0]sum[0:14];
  
  four_bit_multiplicator fbm0(t1,in1[3:0],in2[3:0]);
  four_bit_multiplicator fbm1(t2,in1[7:4],in2[3:0]);
  four_bit_multiplicator fbm2(t3,in1[11:8],in2[3:0]);
  four_bit_multiplicator fbm3(t4,in1[15:12],in2[3:0]);
  
  four_bit_multiplicator fbm4(t5,in1[3:0],in2[7:4]);
  four_bit_multiplicator fbm5(t6,in1[7:4],in2[7:4]);
  four_bit_multiplicator fbm6(t7,in1[11:8],in2[7:4]);
  four_bit_multiplicator fbm7(t8,in1[15:12],in2[7:4]);
  
  four_bit_multiplicator fbm8(t9,in1[3:0],in2[11:8]);
  four_bit_multiplicator fbm9(t10,in1[7:4],in2[11:8]);
  four_bit_multiplicator fbm10(t11,in1[11:8],in2[11:8]);
  four_bit_multiplicator fbm11(t12,in1[15:12],in2[11:8]);
  
  four_bit_multiplicator fbm12(t13,in1[3:0],in2[15:12]);
  four_bit_multiplicator fbm13(t14,in1[7:4],in2[15:12]);
  four_bit_multiplicator fbm14(t15,in1[11:8],in2[15:12]);
  four_bit_multiplicator fbm15(t16,in1[15:12],in2[15:12]);
  
  assign u2=t2<<4;
  assign u3=t3<<8;
  assign u4=t4<<12;
  assign u5=t5<<4;
  assign u6=t6<<8;
  assign u7=t7<<12;
  assign u8=t8<<16;
  assign u9=t9<<8;
  assign u10=t10<<12;
  assign u11=t11<<16;
  assign u12=t12<<20;
  assign u13=t13<<12;
  assign u14=t14<<16;
  assign u15=t15<<20;
  assign u16=t16<<24;
  
  thirtytwo_bit_fa ttbf0(c[0],sum[0],0,t1,u2);
  thirtytwo_bit_fa ttbf1(c[1],sum[1],c[0],sum[0],u3);
  thirtytwo_bit_fa ttbf2(c[2],sum[2],c[1],sum[1],u4);
  thirtytwo_bit_fa ttbf3(c[3],sum[3],c[2],sum[2],u5);
  thirtytwo_bit_fa ttbf4(c[4],sum[4],c[3],sum[3],u6);
  thirtytwo_bit_fa ttbf5(c[5],sum[5],c[4],sum[4],u7);
  thirtytwo_bit_fa ttbf6(c[6],sum[6],c[5],sum[5],u8);
  thirtytwo_bit_fa ttbf7(c[7],sum[7],c[6],sum[6],u9);
  thirtytwo_bit_fa ttbf8(c[8],sum[8],c[7],sum[7],u10);
  thirtytwo_bit_fa ttbf9(c[9],sum[9],c[8],sum[8],u11);
  thirtytwo_bit_fa ttbf10(c[10],sum[10],c[9],sum[9],u12);
  thirtytwo_bit_fa ttbf11(c[11],sum[11],c[10],sum[10],u13);
  thirtytwo_bit_fa ttbf12(c[12],sum[12],c[11],sum[11],u14);
  thirtytwo_bit_fa ttbf13(c[13],sum[13],c[12],sum[12],u15);
  thirtytwo_bit_fa ttbf14(c[14],sum[14],c[13],sum[13],u16);
  
  assign out={c[14],sum[14]};
  
endmodule
  
/*2 bit comparator using gate level design*/
module two_bit_comparator(out1,out2,in1,in2,cont);
  input [1:0]in1,in2;
  output out1,out2;
  input cont;
  wire t1,t2,t3,t4,t5,t6,t7,t8;
  
  and(t1,in1[1],~in2[1]);
  and(t2,in1[0],~in2[1],~in2[0]);
  and(t3,in1[1],in1[0],~in2[0]);
  or(t4,t1,t2,t3);
  and(out1,t4,cont);
  and(t5,in2[1],~in1[1]);
  and(t6,in2[0],~in1[1],~in1[0]);
  and(t7,in2[1],in2[0],~in1[0]);
  or(t8,t5,t6,t7);
  and(out2,t8,cont);
endmodule
    
/*8 bit comparator using gate level design*/
module eight_bit_comparator(out1,out2,in1,in2,cont);
  output out1,out2;
  input [7:0]in1,in2;
  input cont;
  wire t1,t2,t3,t4,t5,t6,t7,t8,x1,x2,x3;
  wire s1[0:2];
  wire s2[0:2];
  wire s3;
  
  two_bit_comparator tbc0(t1,t2,in1[7:6],in2[7:6],cont);
  xnor(x1,t1,t2);
  two_bit_comparator tbc1(t3,t4,in1[5:4],in2[5:4],x1);
  xnor(x2,t3,t4);
  two_bit_comparator tbc2(t5,t6,in1[3:2],in2[3:2],x2);
  xnor(x3,t5,t6);
  two_bit_comparator tbc3(t7,t8,in1[1:0],in2[1:0],x3);
  
  one_bit_fa ob0(s3,s1[0],0,t1,t3);
  one_bit_fa ob1(s3,s1[1],0,s1[0],t5);
  one_bit_fa ob2(s3,s1[2],0,s1[1],t7);
  one_bit_fa ob3(s3,s2[0],0,t2,t4);
  one_bit_fa ob4(s3,s2[1],0,s2[0],t6);
  one_bit_fa ob5(s3,s2[2],0,s2[1],t8);
  
  assign out1=s1[2];
  assign out2=s2[2];
endmodule

/*32 bit comparator using gate level design, outputs 4 n1>n2, 2 for n2<n1, 1 for n1=n2*/
module thirty_two_bit_comparator(out4,in1,in2);
  output [3:0]out4;
  wire out1,out2,out3;
  input [31:0]in1,in2;
  wire t1,t2,t3,t4,t5,t6,t7,t8,x1,x2,x3;
  wire s1[0:2];
  wire s2[0:2];
  wire s3;
  
  eight_bit_comparator ebc0(t1,t2,in1[31:24],in2[31:24],1);
  xnor(x1,t1,t2);
  eight_bit_comparator ebc1(t3,t4,in1[23:16],in2[23:16],x1);
  xnor(x2,t3,t4);
  eight_bit_comparator ebc2(t5,t6,in1[15:8],in2[15:8],x2);
  xnor(x3,t5,t6);
  eight_bit_comparator ebc3(t7,t8,in1[7:0],in2[7:0],x3);
  
  one_bit_fa ob0(s3,s1[0],0,t1,t3);
  one_bit_fa ob1(s3,s1[1],0,s1[0],t5);
  one_bit_fa ob2(s3,s1[2],0,s1[1],t7);
  one_bit_fa ob3(s3,s2[0],0,t2,t4);
  one_bit_fa ob4(s3,s2[1],0,s2[0],t6);
  one_bit_fa ob5(s3,s2[2],0,s2[1],t8);
  assign out1=s1[2];
  assign out2=s2[2];
  and(out3,~out2,~out1);
  assign out4={out1,out2,out3};
endmodule
