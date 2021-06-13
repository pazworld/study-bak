-module(painttest).
-export([start/0]).
-include_lib("wx/include/wx.hrl").

start() ->
    wx:new(),
    F = wxFrame:new(wx:null(), ?wxID_ANY, "paint test"),
    DC = wxClientDC:new(F),
    wxFrame:connect(F, paint, [{callback, fun(_, _) -> on_paint(DC) end}]),
    wxFrame:show(F),
    ok.

on_paint(DC) ->
    io:format("paint ~n"),
    wxDC:drawRectangle(DC, {100, 100, 100, 100}),
    ok.
