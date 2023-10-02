#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter04B_01.fig.wls";
nbPDFName="build/"<>StringReplace[nbFileName,"wls"->"pdf"];
nbPDFNameList=(StringReplace[nbPDFName,".fig"->#<>".fig"]&)/@Alphabet[];
Export[nbPDFName,""]


xLaTeX=(MaTeX[
	#1,Magnification->#2,
	"Preamble"->{"\\usepackage{siunitx}","\\usepackage{physics}","\\usepackage{upgreek}","\\usepackage{color}"}])&;


xLabelFont={FontColor->Black,FontFamily->"Latin Modern",FontSize->5}


xFigConfig={
	Frame->True,GridLines->Automatic,ImageSize->Automatic->300,
	FrameStyle->BlackFrame,PlotStyle->ColorData[10],BaseStyle->xLabelFont};
xFigTicks=(FrameTicks->{
	Table[{x,xLaTeX[ToString[PaddedForm[x,{#2[[1]],#2[[2]]}]],0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}],
	Table[{x,xLaTeX[ToString[PaddedForm[x,{#4[[1]],#4[[2]]}]],0.5]},{x,#3[[1]],#3[[2]],#3[[3]]}]})&;
xFigLabel=(FrameLabel->{xLaTeX[#1,0.8],xLaTeX[#2,0.8]})&;


xFig3DConfig={
	ViewPoint->{-100,-80,65},PlotPoints -> 50,MaxRecursion -> 5,
	ExclusionsStyle->{None,{Red,Thin}},ColorFunction->ColorData["DarkRainbow"],
	BaseStyle->xLabelFont};
xFig3DTicks=(Ticks->{
	Table[{x,xLaTeX[ToString[PaddedForm[x,{#2[[1]],#2[[2]]}]],0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}],
	Table[{x,xLaTeX[ToString[PaddedForm[x,{#4[[1]],#4[[2]]}]],0.5]},{x,#3[[1]],#3[[2]],#3[[3]]}],
	Table[{x,xLaTeX[ToString[PaddedForm[x,{#6[[1]],#6[[2]]}]],0.5]},{x,#5[[1]],#5[[2]],#5[[3]]}]})&;
xFig3DLabel=(AxesLabel->{xLaTeX[#1,0.8],xLaTeX[#2,0.8],xLaTeX[#3,0.8]})&;


xTicks=(Table[{x,xLaTeX[ToString[PaddedForm[x,{#2[[1]],#2[[2]]}]],0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksDif=(Table[{x,xLaTeX[#2[x],0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog=(Table[{10^x,xLaTeX["10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog1=(Table[{10^x,xLaTeX["1\\times 10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog2=(Table[{2 10^x,xLaTeX["2\\times 10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xTicksLog5=(Table[{5 10^x,xLaTeX["5\\times 10^{"<>ToString[x]<>"}",0.5]},{x,#1[[1]],#1[[2]],#1[[3]]}])&;


xGrids=(Table[x,{x,#1[[1]],#1[[2]],#1[[3]]}])&;
xGridsLog=(Flatten[Table[Table[{If[#2[[1]]<=(n 10^x)<=#2[[2]],(n 10^x),{}]},{n,1,9,1}],{x,#1[[1]],#1[[2]],#1[[3]]}]])&;


xDx=1;
xtau=1;
xeVBE=5;
xeVBC=2;
xpE0=0.2;
xnB0=0.4;
xpC0=0.6;
xdpEB=2;
xdpCB=4;
xxE=4;
xxB=3;
xxC=10;
xxTotal=Plus[xE,xB,xC,dpEB,dpCB]


xx1=(xE-x)
xx2=-(xE+dpEB)+(x)
xx3=-(xE+dpEB+xB+dpCB)+(x)


listVal={Dx->xDx,tau->xtau,eVBE->xeVBE,eVBC->xeVBC,pE0->xpE0,nB0->xnB0,pC0->xpC0,dpEB->xdpEB,dpCB->xdpCB,xE->xxE,xB->xxB,xC->xxC,xTotal->xxTotal}
listTransform={x1->xx1,x2->xx2,x3->xx3}
listAll=Join[listVal,listTransform]


deq=(Dx c''[xi]-c[xi]/tau==0)


deqSolve=(Piecewise[{{#[[1]]+((c/.DSolve[{deq,#[[4]],#[[5]]},c,xi][[1]])[#[[3]]]),0<=#[[3]]<=#[[2]]-0},{Undefined,True}}])&


listFA={
	{pE0,xE,x1,c[0]==pE0(eVBE-1),c[xE]==0},
	{nB0,xB,x2,c[0]==nB0(eVBE-1),c[xB]==-nB0},
	{pC0,xC,x3,c[0]==-pC0,c[xC]==0}}
listRA={
	{pE0,xE,x1,c[0]==-pE0,c[xE]==0},
	{nB0,xB,x2,c[0]==-nB0,c[xB]==nB0(eVBC-1)},
	{pC0,xC,x3,c[0]==pC0(eVBC-1),c[xC]==0}}
listSA={
	{pE0,xE,x1,c[0]==pE0(eVBE-1),c[xE]==0},
	{nB0,xB,x2,c[0]==nB0(eVBE-1),c[xB]==nB0(eVBC-1)},
	{pC0,xC,x3,c[0]==pC0(eVBC-1),c[xC]==0}}
listCF={
	{pE0,xE,x1,c[0]==0,c[xE]==-pE0},
	{nB0,xB,x2,c[0]==-nB0,c[xB]==-nB0},
	{pC0,xC,x3,c[0]==-pC0,c[xC]==0}}
listInfo={{"\:6b63","\:53cd"},{"\:53cd","\:6b63"},{"\:6b63","\:6b63"},{"\:53cd","\:53cd"}}


list[[0]]//.listAll


fig1=ReleaseHold[Hold[Plot[Evaluate[(deqSolve/@list)//.listAll],
	{x,0,xTotal//.listVal},
	Prolog->{
		FaceForm[Opacity[0.06, Blue]],Rectangle[{0,-0.1}//.listAll,{xE,2.1}//.listAll],
		FaceForm[Opacity[1.00, Gray]],Rectangle[{xE,-0.1}//.listAll,{xE+dpEB,2.1}//.listAll],
		FaceForm[Opacity[0.04, Red ]],Rectangle[{xE+dpEB,-0.1}//.listAll,{xE+dpEB+xB,2.1}//.listAll],
		FaceForm[Opacity[1.00, Gray]],Rectangle[{xE+dpEB+xB,-0.1}//.listAll,{xE+dpEB+xB+dpCB,2.1}//.listAll],
		FaceForm[Opacity[0.02, Blue]],Rectangle[{xE+dpEB+xB+dpCB,-0.1}//.listAll,{xE+dpEB+xB+dpCB+xC,2.1}//.listAll]
	},
	Epilog->{
		Point[{x,(deqSolve/@list)[[1]]//.listAll}//.{x->0}//.listAll],
		Point[{x,(deqSolve/@list)[[1]]//.listAll}//.{x->xE}//.listAll],
		Point[{x,(deqSolve/@list)[[2]]//.listAll}//.{x->xE+dpEB}//.listAll],
		Point[{x,(deqSolve/@list)[[2]]//.listAll}//.{x->xE+dpEB+xB}//.listAll],
		Point[{x,(deqSolve/@list)[[3]]//.listAll}//.{x->xE+dpEB+xB+dpCB}//.listAll],
		Point[{x,(deqSolve/@list)[[3]]//.listAll}//.{x->xE+dpEB+xB+dpCB+xC}//.listAll],
		Text[Style["\:53d1\:5c04\:6781",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xE/2,1.8}//.listAll],
		Text[Style["\:57fa\:6781",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xB/2+xE+dpEB,1.8}//.listAll],
		Text[Style["\:96c6\:7535\:6781",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xC/2+xE+dpEB+xB+dpCB,1.8}//.listAll],
		Text[Style["\:53d1\:5c04\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB/2,1.2}//.listAll],
		Text[Style["BE\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB/2,1.0}//.listAll],
		Text[Style["\:96c6\:7535\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB+xB+dpCB/2,1.2}//.listAll],
		Text[Style["BC\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB+xB+dpCB/2,1.0}//.listAll],
		Text[Style[info[[1]]<>"\:504f",FontFamily->"Noto Serif CJK SC",FontSize->9,White],{0+xE+dpEB/2,0.5}//.listAll],
		Text[Style[info[[2]]<>"\:504f",FontFamily->"Noto Serif CJK SC",FontSize->9,White],{0+xE+dpEB+xB+dpCB/2,0.5}//.listAll],
		Text[Style["E",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xE/2,1.6}//.listAll],
		Text[Style["B",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xB/2+xE+dpEB,1.6}//.listAll],
		Text[Style["C",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xC/2+xE+dpEB+xB+dpCB,1.6}//.listAll],
		Text[xLaTeX["n^{++}",0.8],{0+xE/2,1.3}//.listAll],
		Text[xLaTeX["p^{+}",0.8],{0.1+xB/2+xE+dpEB,1.3}//.listAll],
		Text[xLaTeX["n",0.8],{0+xC/2+xE+dpEB+xB+dpCB,1.3}//.listAll],
		Text[xLaTeX["p_E(x')",0.8],{0+xE/2,0}//.listAll],
		Text[xLaTeX["n_B(x)",0.8],{0+xB/2+xE+dpEB,0}//.listAll],
		Text[xLaTeX["p_C(x'')",0.8],{0+xC/2+xE+dpEB+xB+dpCB,0}//.listAll],
		Text[xLaTeX["p_{E0}",0.8],{0+3xE/4,pE0+0.1}//.listAll],
		Text[xLaTeX["n_{B0}",0.8],{0+xB/3+xE+dpEB,nB0+0.1}//.listAll],
		Text[xLaTeX["p_{C0}",0.8],{0+xC/10+xE+dpEB+xB+dpCB,pC0+0.1}//.listAll],
		White,
		Polygon[{{0.7+xE+dpEB/2,1.7+0.1},{0.7+xE+dpEB/2,1.7-0.1},{-0.4+xE+dpEB/2,1.7}}//.listAll],
		Polygon[{{-0.7+xE+dpEB+xB+dpCB/2,1.7+0.1},{-0.7+xE+dpEB+xB+dpCB/2,1.7-0.1},{0.4+xE+dpEB+xB+dpCB/2,1.7}}//.listAll],
		Line[{{-0.4+xE+dpEB/2,1.7+0.1},{-0.4+xE+dpEB/2,1.7-0.1}}//.listAll],
		Line[{{0.4+xE+dpEB+xB+dpCB/2,1.7+0.1},{0.4+xE+dpEB+xB+dpCB/2,1.7-0.1}}//.listAll],
		Black,Dashed,Thickness[0.002],
		Line[{{0,pE0}//.listAll,{xE,pE0}//.listAll}],
		Line[{{xE+dpEB,nB0}//.listAll,{xE+dpEB+xB,nB0}//.listAll}],
		Line[{{xE+dpEB+xB+dpCB,pC0}//.listAll,{xE+dpEB+xB+dpCB+xC,pC0}//.listAll}]
	},
	PlotStyle->{Blue,Red,Blue},
	GridLines->{xGrids[{0,xTotal,1}//.listAll],xGrids[{0,2,0.1}//.listAll]},
	FrameTicks->{
	{
		{0//.listAll, xLaTeX["x'=x_E",0.5]},
		{xE//.listAll,xLaTeX["0",0.5]},
		{xE+dpEB//.listAll, xLaTeX["0",0.5]},
		{xE+dpEB+xB//.listAll,xLaTeX["x=x_B",0.5]},
		{xE+dpEB+xB+dpCB//.listAll, xLaTeX["0",0.5]},
		{xE+dpEB+xB+dpCB+xC//.listAll,xLaTeX["x''=x_C",0.5]}
	},
	{}},
	PlotRange->{-0.1,2.1},
	Evaluate@xFigConfig]]/.(({list->#[[1]],info->#[[2]]}&)/@{{listFA,listInfo[[1]]},{listRA,listInfo[[2]]},{listSA,listInfo[[3]]},{listCF,listInfo[[4]]}})]


fig2=ReleaseHold[Hold[Plot[Evaluate[(deqSolve/@list)//.listAll],
	{x,0,xTotal//.listVal},
	Prolog->{
		FaceForm[Opacity[0.06, Blue]],Rectangle[{0,-0.1}//.listAll,{xE,2.1}//.listAll],
		FaceForm[Opacity[1.00, Gray]],Rectangle[{xE,-0.1}//.listAll,{xE+dpEB,2.1}//.listAll],
		FaceForm[Opacity[0.04, Red ]],Rectangle[{xE+dpEB,-0.1}//.listAll,{xE+dpEB+xB,2.1}//.listAll],
		FaceForm[Opacity[1.00, Gray]],Rectangle[{xE+dpEB+xB,-0.1}//.listAll,{xE+dpEB+xB+dpCB,2.1}//.listAll],
		FaceForm[Opacity[0.02, Blue]],Rectangle[{xE+dpEB+xB+dpCB,-0.1}//.listAll,{xE+dpEB+xB+dpCB+xC,2.1}//.listAll]
	},
	Epilog->{
		Point[{x,(deqSolve/@list)[[1]]//.listAll}//.{x->0}//.listAll],
		Point[{x,(deqSolve/@list)[[1]]//.listAll}//.{x->xE}//.listAll],
		Point[{x,(deqSolve/@list)[[2]]//.listAll}//.{x->xE+dpEB}//.listAll],
		Point[{x,(deqSolve/@list)[[2]]//.listAll}//.{x->xE+dpEB+xB}//.listAll],
		Point[{x,(deqSolve/@list)[[3]]//.listAll}//.{x->xE+dpEB+xB+dpCB}//.listAll],
		Point[{x,(deqSolve/@list)[[3]]//.listAll}//.{x->xE+dpEB+xB+dpCB+xC}//.listAll],
		Text[Style["\:53d1\:5c04\:6781",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xE/2,1.8}//.listAll],
		Text[Style["\:57fa\:6781",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xB/2+xE+dpEB,1.8}//.listAll],
		Text[Style["\:96c6\:7535\:6781",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xC/2+xE+dpEB+xB+dpCB,1.8}//.listAll],
		Text[Style["\:53d1\:5c04\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB/2,1.2}//.listAll],
		Text[Style["BE\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB/2,1.0}//.listAll],
		Text[Style["\:96c6\:7535\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB+xB+dpCB/2,1.2}//.listAll],
		Text[Style["BC\:7ed3",FontFamily->"Noto Serif CJK SC",FontSize->8,White],{0+xE+dpEB+xB+dpCB/2,1.0}//.listAll],
		Text[Style[info[[1]]<>"\:504f",FontFamily->"Noto Serif CJK SC",FontSize->9,White],{0+xE+dpEB/2,0.5}//.listAll],
		Text[Style[info[[2]]<>"\:504f",FontFamily->"Noto Serif CJK SC",FontSize->9,White],{0+xE+dpEB+xB+dpCB/2,0.5}//.listAll],
		Text[Style["E",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xE/2,1.6}//.listAll],
		Text[Style["B",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xB/2+xE+dpEB,1.6}//.listAll],
		Text[Style["C",FontFamily->"Noto Serif CJK SC",FontSize->9],{0+xC/2+xE+dpEB+xB+dpCB,1.6}//.listAll],
		Text[xLaTeX["n^{++}",0.8],{0+xE/2,1.3}//.listAll],
		Text[xLaTeX["p^{+}",0.8],{0.1+xB/2+xE+dpEB,1.3}//.listAll],
		Text[xLaTeX["n",0.8],{0+xC/2+xE+dpEB+xB+dpCB,1.3}//.listAll],
		Text[xLaTeX["p_E(x')",0.8],{0+xE/2,0}//.listAll],
		Text[xLaTeX["n_B(x)",0.8],{0+xB/2+xE+dpEB,0}//.listAll],
		Text[xLaTeX["p_C(x'')",0.8],{0+xC/2+xE+dpEB+xB+dpCB,0}//.listAll],
		Text[xLaTeX["p_{E0}",0.8],{0+3xE/4,pE0+0.1}//.listAll],
		Text[xLaTeX["n_{B0}",0.8],{0+xB/3+xE+dpEB,nB0+0.1}//.listAll],
		Text[xLaTeX["p_{C0}",0.8],{0+xC/10+xE+dpEB+xB+dpCB,pC0+0.1}//.listAll],
		White,
		Polygon[{{0.7+xE+dpEB/2,1.7+0.1},{0.7+xE+dpEB/2,1.7-0.1},{-0.4+xE+dpEB/2,1.7}}//.listAll],
		Polygon[{{-0.7+xE+dpEB+xB+dpCB/2,1.7+0.1},{-0.7+xE+dpEB+xB+dpCB/2,1.7-0.1},{0.4+xE+dpEB+xB+dpCB/2,1.7}}//.listAll],
		Line[{{-0.4+xE+dpEB/2,1.7+0.1},{-0.4+xE+dpEB/2,1.7-0.1}}//.listAll],
		Line[{{0.4+xE+dpEB+xB+dpCB/2,1.7+0.1},{0.4+xE+dpEB+xB+dpCB/2,1.7-0.1}}//.listAll],
		Dashed,Thickness[0.002],
		Blue,Line[{{x,(deqSolve/@list)[[1]]//.listAll}//.{x->0},{x,(deqSolve/@list)[[1]]//.listAll}//.{x->xE}}//.listAll],
		Red ,Line[{{x,(deqSolve/@list)[[2]]//.listAll}//.{x->xE+dpEB},{x,(deqSolve/@list)[[2]]//.listAll}//.{x->xE+dpEB+xB}}//.listAll],
		Black,Dashed,Thickness[0.002],
		Line[{{0,pE0}//.listAll,{xE,pE0}//.listAll}],
		Line[{{xE+dpEB,nB0}//.listAll,{xE+dpEB+xB,nB0}//.listAll}],
		Line[{{xE+dpEB+xB+dpCB,pC0}//.listAll,{xE+dpEB+xB+dpCB+xC,pC0}//.listAll}]
	},
	PlotStyle->{Blue,Red,Blue},
	GridLines->{xGrids[{0,xTotal,1}//.listAll],xGrids[{0,2,0.1}//.listAll]},
	FrameTicks->{
	{
		{0//.listAll, xLaTeX["x'=x_E",0.5]},
		{xE//.listAll,xLaTeX["0",0.5]},
		{xE+dpEB//.listAll, xLaTeX["0",0.5]},
		{xE+dpEB+xB//.listAll,xLaTeX["x=x_B",0.5]},
		{xE+dpEB+xB+dpCB//.listAll, xLaTeX["0",0.5]},
		{xE+dpEB+xB+dpCB+xC//.listAll,xLaTeX["x''=x_C",0.5]}
	},
	{}},
	ImageSize->Automatic->400,
	PlotRange->{-0.1,2.1},
	Evaluate@xFigConfig]]/.(({list->#[[1]],info->#[[2]]}&)/@{{listFA,listInfo[[1]]}})]


fig=Join[fig2,fig1]


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]


(*-*)
