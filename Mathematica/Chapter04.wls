#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


xLaTeX=(MaTeX[
	#1,Magnification->#2,
	"Preamble"->{"\\usepackage{siunitx}","\\usepackage{physics}","\\usepackage{upgreek}"}])&;


xLabelFont={FontColor->Black,FontFamily->"Latin Modern",FontSize->5}


xFigConfig={
	Frame->True,GridLines->Automatic,ImageSize->Automatic->300,
	FrameStyle->BlackFrame,PlotStyle->ColorData[10],BaseStyle->xLabelFont};
xFigTicks=(FrameTicks->{
	Table[{x,xLaTeX[ToString[PaddedForm[x,{#2[[1]],#2[[2]]}]],0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}],
	Table[{x,xLaTeX[ToString[PaddedForm[x,{#4[[1]],#4[[2]]}]],0.5]},{x,#3[[1]],#3[[2]],#3[[3]]}]})&;
xFigLabel=(FrameLabel->{xLaTeX[#1,0.8],xLaTeX[#2,0.8]})&;


dsBase=DSolve[{Dx c''[x]-c[x]/tau==0,c[0]==nB0(eVBE-1),c[xB]==-nB0},c,x]
dsEmitter=DSolve[{Dx c''[x]-c[x]/tau==0,c[0]==pE0 (eVBE-1),c[xE]==0},c,x]
dsCollector=DSolve[{Dx c''[x]-c[x]/tau==0,c[0]==-pC0,c[xC]==0},c,x]


cB=(Piecewise[{{nB0+FullSimplify[First[c/.dsBase][#]],0<=#<=xB},{Undefined,True}}])&
cE=(Piecewise[{{pE0+FullSimplify[First[c/.dsEmitter][#]],0<=#<=xE},{Undefined,True}}])&
cC=(Piecewise[{{pC0+FullSimplify[First[c/.dsCollector][#]],0<=#<=xC},{Undefined,True}}])&


val={Dx->1,tau->1,eVBE->5,pE0->0.2,nB0->0.4,pC0->0.6,dpEB->2,dpCB->4,xE->8,xB->4,xC->16}


Plot[
	Evaluate[{cE[x1]/.{x1->(xE-x)},cB[x2]/.{x2->-(xE+dpEB)+(x)},cC[x3]/.{x3->-(xE+dpEB+xB+dpCB)+(x)}}/.val],
	{x,0,Plus[xE,xB,xC,dpEB,dpCB]/.val},
	PlotRange->All,Evaluate@xFigConfig]


Evaluate[{cE[x1]/.{x1->(xE-x)},cB[x2]/.{x2->(xE+dpEB+x)},cC[x3]/.{x3->(xE+dpEB+xB+dpCB)+(xC-x)}}/.val]


dnB=Function[{x},(nB0((Exp[e VBE/kT]-1)Sinh[(xB-x)/(LB)])-nB0 Sinh[x/LB])/Sinh[xB/LB]]
dpE=Function[{x},(pE0((Exp[e VBE/kT]-1)Sinh[(xE-x)/(LE)]))/Sinh[xE/LE]]


JnB=Function[{x},FullSimplify[-e DB D[dnB[t],t]]/.{t->x}]
JpE=Function[{x},FullSimplify[-e DE D[dpE[t],t]]/.{t->x}]


FullSimplify[JnB[x]]
FullSimplify[JpE[x]]


FullSimplify[JnB[0]]
FullSimplify[JnB[xB]]
FullSimplify[JpE[0]]


Series[1/(1+x^2/2),{x,0,3}]


SameQ[Cosh[(-x+xE)/LE] Csch[xE/LE],1/Tanh[xE/LE]]


SameQ[3,5-2]


(**)
