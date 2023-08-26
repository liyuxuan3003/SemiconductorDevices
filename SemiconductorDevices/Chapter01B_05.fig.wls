#!/usr/bin/env wolframscript
(* ::Package:: *)

SetDirectory[NotebookDirectory[]];
Needs["MaTeX`"];


nbFileName="Chapter01B_05.fig.wls";
nbPDFName="build/"<>StringReplace[nbFileName,"wls"->"pdf"];


fig=Plot3D[Sqrt[(Na+Nd)/(Na Nd)],{Na,0,1},{Nd,0,1},
	PlotRange->{0,8},
	PlotPoints->200,
	ViewPoint->{1000,600,500},
	ColorFunction->ColorData["DarkRainbow"],
	BaseStyle->{FontFamily->"Latin Modern Roman",FontSize->8},
	AxesLabel->{MaTeX["N_d"],MaTeX["N_a"],MaTeX["W/(2\\epsilon_s V_{bi}/e)"]}]


Export[nbPDFName,fig,ImageResolution->2000]


(*-*)
