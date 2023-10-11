#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter05A_01.fig.wls";
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


xVbi=1.0
xVp0=4.0
xVp=Vbi-Vp0
xVGSth=Vp
xVDSsat=VGS-Vp
listAll={Vbi->xVbi,Vp0->xVp0,Vp->xVp,VGSth->xVGSth,VDSsat->xVDSsat}
listFunc={Vp->xVp,VGSth->xVGSth,VDSsat->xVDSsat}
listVal={Vbi->xVbi,Vp0->xVp0}


xID1=Piecewise[{
	{3(VDS/Vp0)-2((VDS+Vbi-VGS)/Vp0)^(3/2)+2((Vbi-VGS)/Vp0)^(3/2),VGSth<=VGS<=0 && 0<=VDS<=VDSsat},
	{3(VDSsat/Vp0)-2((VDSsat+Vbi-VGS)/Vp0)^(3/2)+2((Vbi-VGS)/Vp0)^(3/2),VGSth<=VGS<=0 && VDS>VDSsat},
	{0,VGS<VGSth}
}]


xIDSS1=Simplify[xID1//.Join[{VGS->0,VDS->VDSsat},listFunc]]


xID1A=Assuming[Vbi-Vp0<=0 && VGS<=0 && Vbi<=VGS+Vp0,Simplify[xID1//.Join[{VDS->VDSsat},listFunc]]]
xID1S=FullSimplify[IDSS1 (1-VGS/Vp)^2//.{IDSS1->xIDSS1}]


fig1=Plot3D[xID1//.listAll,{VDS,0,xVp0},{VGS,-xVp0,0},PlotRange->All,
	Exclusions->({VGS==Vp,VDS==VGS-Vp}//.listAll),
	Evaluate@xFig3DTicks[{0,4,1},{1,0},{-4,0,1},{1,0},{0.0,0.5,0.1},{2,1}],
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","I_{D1}/I_{P1}"],
	Evaluate@xFig3DConfig]


fig2=Plot[Evaluate@Join[{xID1//.listAll//.{VGS->VDS+Vp//.listAll}},
	Table[xID1//.listAll//.{VGS->x},{x,0,-6xVp0/8,-xVp0/8}]],{VDS,0,xVp0},
	PlotRange->{-0.05,0.55},
	PlotStyle->Join[{Directive[Black,Thickness[0.002],Dashed]},ColorData[10]/@{1,2,3,4,5,6,7}],
	Epilog->{
		Text[xLaTeX["V_{GS}=-3.0\\si{V}",0.6],{3.65,-0.02}],
		Text[xLaTeX["V_{GS}=-2.5\\si{V}",0.6],{3.65,0.029}],
		Text[xLaTeX["V_{GS}=-2.0\\si{V}",0.6],{3.65,0.065}],
		Text[xLaTeX["V_{GS}=-1.5\\si{V}",0.6],{3.65,0.130}],
		Text[xLaTeX["V_{GS}=-1.0\\si{V}",0.6],{3.65,0.225}],
		Text[xLaTeX["V_{GS}=-0.5\\si{V}",0.6],{3.65,0.350}],
		Text[xLaTeX["V_{GS}=-0.0\\si{V}",0.6],{3.65,0.518}],
		Point[Table[({VDS,xID1})//.Join[listAll,{VDS->VDSsat}],{VGS,-3,0,0.5}]],
		Text[Style["\:7ebf\:6027\:533a",FontFamily->"Noto Serif CJK SC",FontSize->10],{2.5,0.45}],
		Text[Style["\:9971\:548c\:533a",FontFamily->"Noto Serif CJK SC",FontSize->10],{3.5,0.45}]
	},
	Evaluate@xFigTicks[{0,4,0.5},{2,1},{0.0,0.5,0.1},{2,1}],
	Evaluate@xFigLabel["V_{DS}~(\\si{V})","I_{D1}/I_{P1}"],
	GridLines->{xGrids[{0.0,4.0,0.25}],xGrids[{-0.05,0.55,0.02}]},
	Evaluate@xFigConfig]


fig3=Plot[{
	xID1//.listAll//.{VDS->4},
	Piecewise[{{xIDSS1 (1-VGS/Vp)^2,VGS>=VGSth}}]//.listAll},{VGS,-xVp0,0},
	PlotStyle->{{Black},{Dashed,Red,Thickness[0.003]}},
	PlotLegends->Placed[LineLegend[
	{
		Style["\:7cbe\:786e\:503c",FontFamily->"Noto Serif CJK SC",FontSize->9],
		Style["\:8fd1\:4f3c\:503c",FontFamily->"Noto Serif CJK SC",FontSize->9]
	},LegendFunction->"Panel",LegendLayout -> {"Column",1}],{Left,Top}],
	Evaluate@xFigTicks[{-4,0,0.5},{2,1},{0.0,0.5,0.1},{2,1}],
	Evaluate@xFigLabel["V_{GS}~(\\si{V})","I_{D1}/I_{P1}"],
	GridLines->{xGrids[{-4.0,0.0,0.25}],xGrids[{-0.05,0.55,0.02}]},
	Evaluate@xFigConfig]


xgm=D[xID1//.listFunc,VGS]


xgma=Piecewise[{
	{(3/(2Vp0))(VDS/Sqrt[Vp0(Vbi-VGS)]),VGSth<=VGS<=0&&0<=VDS<=VDSsat},
	{xgm,True}
}]


fig4=Plot3D[xgm//.listVal,{VDS,0,xVp0},{VGS,-xVp0,0},PlotRange->{0,0.4},
	ColorFunction->ColorData["ArmyColors"],
	Exclusions->({VGS==Vp,VDS==VGS-Vp}//.listAll),
	Evaluate@xFig3DTicks[{0,4,1},{1,0},{-4,0,1},{1,0},{0.0,0.5,0.1},{2,1}],
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","g_m/I_{P1}"],
	Evaluate@xFig3DConfig]


fig5=Plot3D[xgma//.listAll,{VDS,0,xVp0},{VGS,-xVp0,0},PlotRange->{0,0.4},
	ColorFunction->ColorData["ArmyColors"],
	Exclusions->({VGS==Vp,VDS==VGS-Vp}//.listAll),
	Evaluate@xFig3DTicks[{0,4,1},{1,0},{-4,0,1},{1,0},{0.0,0.5,0.1},{2,1}],
	Evaluate@xFig3DLabel["V_{DS}~(\\si{V})","V_{GS}~(\\si{V})","g_m/I_{P1}"],
	Evaluate@xFig3DConfig]


fig6=Plot[Evaluate@Table[xgm//.listVal//.{VDS->x},{x,0,6xVp0/8,xVp0/8}],{VGS,-xVp0,0},Evaluate@xFigConfig]


Series[Sqrt[x],{x,0,5}]


fig={fig1,fig2,fig3,fig4,fig5,fig6}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]


(*-*)
