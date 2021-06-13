%% A micro-blog, wxErlang sample from O'reilly Erlang Programming.

-module(microblog).
-compile(export_all).

-include_lib("wx/include/wx.hrl").

-define(ABOUT, ?wxID_ABOUT).
-define(EXIT, ?wxID_EXIT).

start() ->
    wx:new(),
    Frame = wxFrame:new(wx:null(), ?wxID_ANY, "MicroBlog"),
    setup(Frame),
    wxFrame:show(Frame),
    loop(Frame),
    wx:destroy(),
    ok.

setup(Frame) ->

    MenuBar = wxMenuBar:new(),
    File = wxMenu:new(),

    wxMenu:append(File, ?EXIT, "Quit"),

    wxMenuBar:append(MenuBar, File, "&File"),

    wxFrame:setMenuBar(Frame, MenuBar),

    wxFrame:connect(Frame, command_menu_selected),
    wxFrame:connect(Frame, close_window, [{skip, true}]).

loop(Frame) ->
    receive
        %#wx{id = ?ABOUT, event = #wxCommand{}} ->
        #wx{obj = Frame, event = #wxClose{type = close_window}} ->
            io:format("close_window~n"),
            wxWindow:destroy(Frame);
            %wxWindow:close(Frame, []);
        #wx{id = ?EXIT, event = #wxCommand{type = command_menu_selected}} ->
            io:format("Quit Menu~n"),
            wxWindow:destroy(Frame);
        Event ->
            io:format("Event ->~n~w~n", [Event]),
            loop(Frame)
        end.
