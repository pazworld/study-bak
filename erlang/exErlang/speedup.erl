% this code is from https://arifishaq.files.wordpress.com/2018/04/wxerlang-speeding-up.pdf

-module(speedup).
-compile(export_all).

test1() ->
	wx:new(),
	Frame = wxFrame:new(wx:null(), -1, "test1"),
	wxFrame:show(Frame),
	DC = wxWindowDC:new(Frame),
	wxDC:drawText(DC, "wxErlang is cool!", {50, 50}),
	wxDC:drawLine(DC, {50, 70}, {150, 70}),
	Pen = wxPen:new({255, 0, 0}, [{width, 3}, {style, 104}]),
	wxDC:setPen(DC, Pen),
	wxDC:drawLine(DC, {50,80}, {150,80}),
	wxDC:drawRectangle(DC, {50,90,100,20}),
	Brush = wxBrush:new({0,0,255}, [{style, 112}]),
	wxDC:setBrush(DC, Brush),
	wxDC:drawRectangle(DC, {200,50,100,20}),
	wxDC:setClippingRegion(DC, {70, 30, 30, 100}),
	wxDC:setLogicalFunction(DC, 2), %% 2 = wxINVERT
	YellowBrush = wxBrush:new({255,255,0}, [{style,100}]), %% 100 = wxSOLID
	wxDC:setBrush(DC, YellowBrush),
	wxDC:drawRectangle(DC, {0,0,200,200}),
	DC.
