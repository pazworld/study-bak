-module(scale).
-export([start/0]).
-include_lib("wx/include/wx.hrl").

start() ->
    wx:new(),
    F = wxFrame:new(wx:null(), -1, "scale test", [{size, {600, 600}}]),
    wxFrame:show(F),
    DC = wxClientDC:new(F),
    wxDC:setPen(DC, wxPen:new(?wxBLACK, [{style, ?wxTRANSPARENT}])),
    wxDC:setBrush(DC, wxBrush:new(?wxWHITE)),
    wxDC:setUserScale(DC, 16, 8),
    MDC = wxMemoryDC:new(),
    Bmp = make_bitmap(),
    wxMemoryDC:selectObject(MDC, Bmp),
    wxDC:blit(DC, {2, 2}, {8, 16}, MDC, {0, 0}),
    wxDC:blit(DC, {12, 2}, {8, 16}, MDC, {0, 0}),
    wxDC:blit(DC, {22, 2}, {8, 16}, MDC, {0, 0}),
    wxDC:drawRectangle(DC, {2, 20, 28, 8}),
    DC.

make_bitmap() ->
        ImgBin = [
        2#00000001, % #######_
        2#11111110, % _______#
        2#11000110, % __###__#
        2#10111010, % _#___#_#
        2#10111010, % _#___#_#
        2#10000010, % _#####_#
        2#10111110, % _#_____#
        2#10111110, % _#_____#
        2#10111110, % _#_____#
        2#10111110, % _#_____#
        2#11011010, % __#__#_#
        2#11100110, % ___##__#
        2#11111110, % _______#
        2#11111110, % _______#
        2#00000001, % #######_
        2#11111111  % ________
    ],
    ImgBinStr =
        lists:flatten([tl(integer_to_list(X + 16#100, 2)) || X <- ImgBin]),
    ImgRGB = list_to_binary(lists:map(
        fun(X) -> X2 = (X - 48) * 255, [X2, X2, X2] end, ImgBinStr)),
    Img = wxImage:new(8, 16),
    wxImage:setData(Img, ImgRGB),
    wxBitmap:new(Img).
