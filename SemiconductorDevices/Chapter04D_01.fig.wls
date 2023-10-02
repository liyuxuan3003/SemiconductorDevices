#!/usr/bin/env wolframscript
(* ::Package:: *)

ClearAll["Global`*"]


SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter04D_01.fig.wls";
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


xe=1.602176565 10^(-19)
xkB=1.3806488 10^(-23)
xT=300
xbF=100
xbR=10
xa=b/(1+b)
xaF=xa//.{b->bF}
xaR=xa//.{b->bR}
xIES=1
xICS=(aF/aR)IES


xIFD=IES(Exp[e VBE/(kB T)]-1)
xIRD=ICS(Exp[e VBC/(kB T)]-1)


xICp=aF IFD-IRD
xIEp=aR IRD-IFD
xIBp=-ICp-IEp


xIC=+ICp
xIE=-IEp
xIB=+IBp


valList={e->xe,kB->xkB,T->xT,bF->xbF,bR->xbR,aF->xaF,aR->xaR,
	IES->xIES,ICS->xICS,
	IFD->xIFD,IRD->xIRD,
	ICp->xICp,IEp->xIEp,IBp->xIBp,
	IC->xIC,IE->xIE,IB->xIB}


xVBC1=VBE-VCE
xVBE1=VBE
volatgeList1={VBC->xVBC1,VBE->xVBE1}


xVBC2=-VCB
xVBE2=+VBE
volatgeList2={VBC->xVBC2,VBE->xVBE2}


fig1=Plot3D[IC//.valList//.volatgeList1,{VCE,-0.5,0.5},{VBE,-0.5,0.5},
	PlotRange->{-10,10},
	ColorFunction->ColorData["StarryNightColors"],
	PlotPoints->100,Mesh->60,MeshStyle->Gray,
	Exclusions->{VBE==VCE,VBE==0},
	Evaluate@xFig3DTicks[{-0.5,0.5,0.25},{3,2},{-0.5,0.5,0.25},{3,2},{-10,10,5},{2,0}],
	Evaluate@xFig3DLabel["V_{CE}~(\\si{V})","V_{BE}~(\\si{V})","I_{C}/I_{s}"],
	Evaluate@xFig3DConfig]


fig2=Plot3D[IC//.valList//.volatgeList2,{VCB,-0.5,0.5},{VBE,-0.5,0.5},
	PlotRange->{-10,10},
	ColorFunction->ColorData["StarryNightColors"],
	PlotPoints->100,
	Mesh->60,
	MeshStyle->Gray,
	Exclusions->{VCB==0,VBE==0},
	Evaluate@xFig3DTicks[{-0.5,0.5,0.25},{3,2},{-0.5,0.5,0.25},{3,2},{-10,10,5},{2,0}],
	Evaluate@xFig3DLabel["-V_{BC}~(\\si{V})","+V_{BE}~(\\si{V})","I_{C}/I_{s}"],
	Evaluate@xFig3DConfig]


fig3Func=IC//.valList//.volatgeList2
fig3=Plot[Evaluate@Join[Table[fig3Func,{VBE,0.00,0.04,0.01}]],
	{VCB,-0.2,0.5},PlotRange->{-2.5,5.5},
	Epilog->{
		Black,Dashed,Thickness[0.002],Line[{{0,-2.5},{0,5.5}}],
		Text[xLaTeX["+V_{BE}=0.00\\si{V}",0.6],{0.42,0.83}],
		Text[xLaTeX["+V_{BE}=0.01\\si{V}",0.6],{0.42,1.35}],
		Text[xLaTeX["+V_{BE}=0.02\\si{V}",0.6],{0.42,2.00}],
		Text[xLaTeX["+V_{BE}=0.03\\si{V}",0.6],{0.42,3.00}],
		Text[xLaTeX["+V_{BE}=0.04\\si{V}",0.6],{0.42,4.52}],
		Text[xLaTeX["-V_{BC}=0",0.8],{0.07,5.1}],
		Text[Style["\:9971\:548c\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{-0.11,4.02}],
		Text[Style["\:653e\:5927\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{+0.15,4.02}],
		Point[Table[{0,fig3Func//.{VBE->x,VCB->0}},{x,0.00,0.04,0.01}]]
	},
	PlotStyle->ColorData[10],
	GridLines->{xGrids[{-0.2,0.5,0.02}],xGrids[{-2.4,5.4,0.2}]},
	Evaluate@xFigTicks[{-0.2,0.5,0.1},{2,1},{-2,5,1},{2,1}],
	Evaluate@xFigLabel["-V_{BC}~(\\si{V})","I_{C}/I_{S}"],
	Evaluate@xFigConfig]


fig4Func=IC//.valList//.volatgeList1
fig4=Plot[Evaluate@Join[Table[fig4Func,{VBE,0.00,0.04,0.01}],{fig4Func//.{VBE->VCE}}],
	{VCE,-0.2,0.5},PlotRange->{-1.5,5.5},
	Epilog->{
		Text[xLaTeX["V_{BE}=0.00\\si{V}",0.6],{0.42,0.83}],
		Text[xLaTeX["V_{BE}=0.01\\si{V}",0.6],{0.42,1.35}],
		Text[xLaTeX["V_{BE}=0.02\\si{V}",0.6],{0.42,2.00}],
		Text[xLaTeX["V_{BE}=0.03\\si{V}",0.6],{0.42,3.00}],
		Text[xLaTeX["V_{BE}=0.04\\si{V}",0.6],{0.42,4.52}],
		Text[Style["\:9971\:548c\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{-0.11,4.02}],
		Text[Style["\:653e\:5927\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{+0.15,4.02}],
		Text[xLaTeX["V_{BE}=V_{CE}",0.8],{0.13,5.1}],
		Point[Table[{x,fig4Func//.{VCE->VBE,VBE->x}},{x,0.00,0.04,0.01}]]
	},
	PlotStyle->Join[ColorData[10]/@{1,2,3,4,5},{Directive[Black,Thickness[0.002],Dashed]}],
	GridLines->{xGrids[{-0.2,0.5,0.02}],xGrids[{-1.4,5.4,0.2}]},
	Evaluate@xFigTicks[{-0.2,0.5,0.1},{2,1},{-1,5,1},{2,1}],
	Evaluate@xFigLabel["V_{CE}~(\\si{V})","I_{C}/I_{S}"],
	Evaluate@xFigConfig]


fig5Func=IC//.valList//.volatgeList2
fig5=Plot[Evaluate@Join[Table[fig5Func,{VCB,{0.0,0.5}}]],
	{VBE,-0.2,0.5},PlotRange->{-1.5,5.5},
	GridLines->{xGrids[{-0.2,1,0.02}],xGrids[{-1.4,5.4,0.2}]},
	Epilog->{
		Black,Dashed,Thickness[0.002],Line[{{0,-2.5},{0,5.5}}],
		Text[xLaTeX["-V_{BC}=0.0\\si{V}",0.6],{-0.1,-1.20}],
		Text[xLaTeX["-V_{BC}=0.5\\si{V}",0.6],{-0.1,+0.40}],
		Text[xLaTeX["-V_{BE}=0",0.8],{-0.07,5.1}],
		Text[Style["\:622a\:6b62\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{-0.11,4.02}],
		Text[Style["\:653e\:5927\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{+0.15,4.02}]
	},
	PlotStyle->ColorData[10],
	Evaluate@xFigTicks[{-0.2,1,0.1},{2,1},{-1,5,1},{2,1}],
	Evaluate@xFigLabel["+V_{BE}~(\\si{V})","I_{C}/I_{S}"],
	Evaluate@xFigConfig]


fig6Func=IC//.valList//.volatgeList1
fig6=Plot[Evaluate@Join[Table[fig6Func,{VCE,2,2,0.1}]],
	{VBE,-0.2,0.5},PlotRange->{-1.5,5.5},
	PlotStyle->Black,
	Epilog->{
		Black,Dashed,Thickness[0.002],Line[{{0,-2.5},{0,5.5}}],
		Text[xLaTeX["V_{CE}\\gg V_{BE,\\max}",0.6],{-0.12,0.50}],
		Text[xLaTeX["V_{BE}=0",0.8],{-0.06,5.1}],
		Text[Style["\:622a\:6b62\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{-0.11,4.02}],
		Text[Style["\:653e\:5927\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{+0.15,4.02}]
	},
	GridLines->{xGrids[{-0.2,1,0.02}],xGrids[{-1.4,5.4,0.2}]},
	Evaluate@xFigTicks[{-0.2,1,0.1},{2,1},{-1,5,1},{2,1}],
	Evaluate@xFigLabel["V_{BE}~(\\si{V})","I_{C}/I_{S}"],
	Evaluate@xFigConfig]


fig7=Plot3D[(IC/IB)//.valList//.volatgeList2,{VCB,-0.5,0.5},{VBE,-0.5,0.5},
	PlotRange->{-15,105},
	ColorFunction->Function[{x,y,z},ColorData["GreenPinkTones"][(z/200)+0.5]],
	ColorFunctionScaling->None,
	MeshStyle->Gray,
	BoxRatios->{1,1,0.7},
	Ticks->{xTicks[{-0.5,0.5,0.25},{3,2}],xTicks[{-0.5,0.5,0.25},{3,2}],Table[{x,xLaTeX[ToString[x],0.5]},{x,{-10,0,25,50,75,100}}]},
	Evaluate@xFig3DLabel["-V_{BC}","+V_{BE}","\\dfrac{I_{C}}{I_{B}}"],
	Evaluate@xFig3DTicks[{-0.5,0.5,0.25},{3,2},{-0.5,0.5,0.25},{3,2},{-10,100,10},{3,0}],
	Evaluate@xFig3DConfig]


fig8Func={IB,IC}//.valList//.volatgeList2
fig8=Plot[Evaluate@Join[Table[fig8Func,{VCB,{0.5}}]],
	{VBE,-0.2,0.5},PlotRange->{-1.5,5.5},
	GridLines->{xGrids[{-0.2,1,0.02}],xGrids[{-1.4,5.4,0.2}]},
	Epilog->{
		Black,Dashed,Thickness[0.002],Line[{{0,-2.5},{0,5.5}}],
		Text[xLaTeX["-V_{BC}=0.5\\si{V}",0.6],{-0.1,+0.40}],
		Text[Style["\:622a\:6b62\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{-0.11,4.02}],
		Text[Style["\:6b63\:5411\:653e\:5927\:533a",FontFamily->"Noto Serif CJK SC",FontSize->9],{+0.35,4.02}]
	},
	PlotLegends->Placed[LineLegend[
		{
			xLaTeX["I_B",0.8],
			xLaTeX["I_C",0.8]
		},LegendFunction->"Panel",LegendLayout -> {"ReversedRow",1}],{Right,Bottom}],
	PlotStyle->{Red,Blue,Black},
	Evaluate@xFigTicks[{-0.2,1,0.1},{2,1},{-1,5,1},{2,1}],
	Evaluate@xFigLabel["+V_{BE}~(\\si{V})","I/I_{S}"],
	Evaluate@xFigConfig]


fig={fig1,fig2,fig3,fig4,fig5,fig6,fig7,fig8}


figWithName=Transpose[{fig,nbPDFNameList[[1;;Length[fig]]]}];
ReleaseHold[(Hold[Export[#[[2]],#[[1]],ImageResolution->2000]]&)/@figWithName]


(*-*)
