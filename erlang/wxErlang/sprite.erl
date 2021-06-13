-module(sprite).
-compile(export_all).
-include_lib("wx/include/wx.hrl").

start() ->
    wx:new(),
    ImgBin = [
        2#11111110, % #######_
        2#00000001, % _______#
        2#00111001, % __###__#
        2#01000101, % _#___#_#
        2#01000101, % _#___#_#
        2#01111101, % _#####_#
        2#01000001, % _#_____#
        2#01000001, % _#_____#
        2#01000001, % _#_____#
        2#01000001, % _#_____#
        2#00100101, % __#__#_#
        2#00011001, % ___##__#
        2#00000001, % _______#
        2#11111110, % #######_
        2#00000000
    ],
    ImgBinStr =
        lists:flatten([tl(integer_to_list(X + 16#100, 2)) || X <- ImgBin]),
    ImgRGB = list_to_binary(lists:map(
        fun(X) -> X2 = (X - 48) * 255, [X2, X2, X2] end, ImgBinStr)),
    Img = wxImage:new(8, 16),
    wxImage:setData(Img, ImgRGB),
    Bmp = wxBitmap:new(Img),
    MDC = wxMemoryDC:new(),
    wxMemoryDC:selectObject(MDC, Bmp),
    F = wxFrame:new(wx:null(), -1, "sprite test", [{size, {600, 600}}]),
    wxFrame:show(F),
    DC = wxClientDC:new(F),
    [wxDC:blit(DC, {X * 8, Y * 16}, {8, 16}, MDC, {0, 0})
        || Y <- lists:seq(0, 31), X <- lists:seq(0, 63)].
