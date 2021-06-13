-module(xortest).
-export([start/0]).
-include_lib("wx/include/wx.hrl").

start() ->
    wx:new(),
    F = wxFrame:new(wx:null(), -1, "xor test"),
    wxFrame:show(F),
    DC = wxClientDC:new(F),
    wxDC:setBackground(DC, wxBrush:new(?wxBLACK)),
    wxDC:clear(DC),
    wxDC:setUserScale(DC, 16, 16),
    DrawFunc = fun(X, Y) ->
        wxDC:blit(DC, {X, Y}, {4, 4}, make_bmpdc(), {0, 0}, [{rop, ?wxXOR}])
    end,
    X1 = lists:seq(0, 24),
    X2 = lists:reverse(X1),
    DrawFunc(8, 4),
    DrawFunc(16, 4),
    lists:map(fun(X) ->
        DrawFunc(X, 2),
        timer:sleep(100),
        DrawFunc(X, 2)
    end, X1 ++ X2).

make_bmpdc() ->
    ImgBin = list_to_binary([255 || _ <- lists:seq(1, 16 * 3 * 4)]),
    Img = wxImage:new(4, 4),
    wxImage:setData(Img, ImgBin),
    Bmp = wxBitmap:new(Img),
    BmpDC = wxMemoryDC:new(),
    wxMemoryDC:selectObject(BmpDC, Bmp),
    BmpDC.
