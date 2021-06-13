-module(drawtest).
-compile(export_all).

setup() ->
	wx:new(),
	F = wxFrame:new(wx:null(), -1, "drawtest", [{size, {600, 600}}]),
	wxFrame:show(F),
	DC = wxClientDC:new(F),
	Pen = wxPen:new({0, 0, 0}),
	wxDC:setPen(DC, Pen),
	Fun = fun(X, Y) ->
		wxDC:drawRectangle(DC, {X * 8, Y * 16, 8, 16})
	end,
	[Fun(X, Y) || Y <- lists:seq(0, 31), X <- lists:seq(0, 63)],
	DC.
