function [M,Mdct]=vec2featmat(D,cep_ord)
  
b0=[0 0 0 0 1  0  0  0 0];
b1=[0 0 2 1 0 -1 -2 0 0]/10;
b2=conv(b1(3:7),[2 1 0 -1 -2]/10);

Mdct=[cos(pi*(1:cep_ord)'*((1:D)-0.5)/D);ones(1,D)];

M=kron([b0;-b1;b2],Mdct);