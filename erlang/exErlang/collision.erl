-module(collision).
-export([start/0]).
-include_lib("wx/include/wx.hrl").

start() ->
    wx:new(),
    F = wxFrame:new(wx:null(), -1, "collision test"),
    wxFrame:show(F),
    DC = wxClientDC:new(F),
    wxDC:setBackground(DC, wxBrush:new(?wxBLACK)),
    wxDC:clear(DC),
    wxDC:setUserScale(DC, 16, 16),
    draw_block(DC, 8, 4),
    draw_block(DC, 16, 4),
    X1 = lists:seq(0, 24),
    X2 = lists:reverse(X1),
    lists:map(fun(X) ->
        collision_light(DC, is_collision(DC, X, 2)),
        draw_runner(DC, X, 2),
        timer:sleep(100),
        draw_runner(DC, X, 2)
    end, X1 ++ X2 ++ X1 ++ X2),
    ok.

draw_block(DC, X, Y) ->
    wxDC:blit(DC, {X, Y}, {4, 4}, block_dc(), {0, 0}).

draw_runner(DC, X, Y) ->
    wxDC:blit(DC, {X, Y}, {8, 9}, runner_dc(), {0, 0}, [{rop, ?wxXOR}]).

block_dc() ->
    ImgBin = [
        2#11110000,
        2#11110000,
        2#11110000,
        2#11110000
    ],
    make_image_dc(ImgBin, 4).

runner_dc() ->
    ImgBin = [
        2#00011000,
        2#00011000,
        2#01110000,
        2#10011000,
        2#00100100,
        2#00100000,
        2#11010000,
        2#00010000,
        2#00010000
    ],
    make_image_dc(ImgBin, 9).

make_image_dc(ImgBin, Height) ->
    ImgBinStr =
        lists:flatten([tl(integer_to_list(X + 16#100, 2)) || X <- ImgBin]),
    ImgRGB = list_to_binary(lists:map(
        fun(X) -> X2 = (X - 48) * 255, [X2, X2, X2] end, ImgBinStr)),
    Img = wxImage:new(8, Height),
    wxImage:setData(Img, ImgRGB),
    Bmp = wxBitmap:new(Img),
    DC = wxMemoryDC:new(),
    wxMemoryDC:selectObject(DC, Bmp),
    DC.

is_collision(DC, X, Y) ->
    {Bmp, BDC} = store_bitmap(DC, X, Y),
    and_bitmap(BDC),
    have_white_pixel(Bmp).

store_bitmap(DC, X, Y) ->
    Bmp = wxBitmap:new(8, 9),
    BDC = wxMemoryDC:new(),
    wxMemoryDC:selectObject(BDC, Bmp),
    wxDC:blit(BDC, {0, 0}, {8, 9}, DC, {X, Y}),
    {Bmp, BDC}.

and_bitmap(BDC) ->
    wxDC:blit(BDC, {0, 0}, {8, 9}, runner_dc(), {0, 0}, [{rop, ?wxAND}]).

have_white_pixel(Bmp) ->
    Img = wxBitmap:convertToImage(Bmp),
    RGB = binary:bin_to_list(wxImage:getData(Img)),
    lists:any(fun(X) -> X =/= 0 end, RGB).

collision_light(DC, On) ->
    Color = case On of
        true -> ?wxRED;
        _    -> ?wxBLACK
    end,
    wxDC:setPen(DC, wxPen:new(?wxBLACK, [{style, ?wxTRANSPARENT}])),
    wxDC:setBrush(DC, wxBrush:new(Color)),
    wxDC:drawRectangle(DC, {0, 0, 1, 1}),
    ok.
