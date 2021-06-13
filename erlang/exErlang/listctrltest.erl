% This program is written with
% https://python-minutes.blogspot.com/2017/06/pythongui-listctrl.html
% as a reference.

-module(listctrltest).

-export([start/0]).
-include_lib("wx/include/wx.hrl").

start() ->
    setup_frame(),
    ok.

setup_frame() ->
    wx:new(),
    Frame = wxFrame:new(wx:null(), -1, "ListCtrl test"),
    wxFrame:createStatusBar(Frame),
    setup_listctrl(Frame),
    wxFrame:show(Frame).

setup_listctrl(Frame) ->
    ListCtrl = wxListCtrl:new(Frame, [{style, ?wxLC_REPORT}]),
    add_listctrl_column(ListCtrl),
    add_listctrl_data(ListCtrl),
    add_listctrl_event(Frame, ListCtrl),
    ok.

add_listctrl_column(ListCtrl) ->
    wxListCtrl:insertColumn(ListCtrl, 0, "Name", [{width, 150}]),
    wxListCtrl:insertColumn(ListCtrl, 1, "Age", [{width, 100}]).

add_listctrl_data(ListCtrl) ->
    lists:foreach(fun(X) ->
        wxListCtrl:insertItem(ListCtrl, X, "Yamada " ++ [$0 + X + 1] ++ " rou"),
        wxListCtrl:setItem(ListCtrl, X, 1, integer_to_list((X + 1) * 5))
    end, lists:seq(0, 2)).

add_listctrl_event(Frame, ListCtrl) ->
    wxListCtrl:connect(ListCtrl, command_list_item_selected,
        [{callback, fun(_, Event) -> on_listitem_selected(Frame, ListCtrl, Event) end}]).

on_listitem_selected(Frame, ListCtrl, Event) ->
    Index = wxListEvent:getIndex(Event),
    Str = wxListCtrl:getItemText(ListCtrl, Index) ++ " is selected.",
    wxFrame:setStatusText(Frame, Str).
