#!/usr/bin/env wolframscript
(* ::Package:: *)

xn=1;
a=1;
Vbi=1/(2a) xn^2;
phi0[x_]:=Piecewise[{
	{Vbi-1/(2a) (xn-x)^2,0<x<xn},
	{Vbi,x>=xn}
}];
phim[x_]:=1/(16Pi a) 1/x;
Plot[{phi0[x],phim[x],phi0[x]+phim[x]},{x,0,5},Frame->True,GridLines->Automatic,PlotRange->{0,3}]
Plot[{phi0[x]+phim[x]},{x,0,5},Frame->True,GridLines->Automatic,PlotRange->{0,3}]


Solve[q/(16 Pi es x^2)==(q Nd)/es (xn),x]
Solve[q/(16 Pi es x^2)==(q Nd)/es (xn-x),x]


(*-*)
