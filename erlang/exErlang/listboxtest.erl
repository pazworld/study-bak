-module(listboxtest).

-export([start/0]).
-include_lib("wx/include/wx.hrl").

start() ->
    wx:new(),
    F = wxFrame:new(wx:null(), -1, "ListBox test"),
    B = wxListBox:new(F, -1, [{size, {10, 10}}]),
    wxFrame:show(F),
    wxListBox:set(B, items()),
    wxListBox:setSelection(B, 999),
    wxListBox:setFirstItem(B, 999 - 5),
    ok.

items() ->
    [integer_to_list(X) || X <- lists:seq(0, 1000)].
