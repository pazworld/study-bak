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
    flush_messages(),
    ok.

setup(Frame) ->

    MenuBar = wxMenuBar:new(),
    File = wxMenu:new(),
    Help = wxMenu:new(),

    wxMenu:append(Help, ?ABOUT, "About MicroBlog"),
    wxMenu:append(File, ?EXIT, "Quit"),

    wxMenuBar:append(MenuBar, File, "&File"),
    wxMenuBar:append(MenuBar, Help, "&Help"),

    wxFrame:setMenuBar(Frame, MenuBar),

    wxFrame:connect(Frame, command_menu_selected),
    wxFrame:connect(Frame, close_window).

loop(Frame) ->
    receive
        %#wx{id = ?ABOUT, event = #wxCommand{}} ->
        #wx{obj = Frame, event = #wxClose{type = close_window}} ->
            io:format("close_window~n"),
            wxWindow:destroy(Frame);
        #wx{id = ?ABOUT, event = #wxCommand{}} ->
            Str = "MicroBlog is a minimal wxErlang example.",
            MD = wxMessageDialog:new(Frame, Str,
                [{style, ?wxOK bor ?wxICON_INFORMATION},
                {caption, "About MicroBlog"}]),
                wxDialog:showModal(MD),
                wxDialog:destroy(MD),
                loop(Frame);
        #wx{id = ?EXIT, event = #wxCommand{type = command_menu_selected}} ->
            io:format("Quit Menu~n"),
            wxWindow:close(Frame),
            % wxWindow:close/1 simply generates a wxCloseEvent
            % therefore need loop again and destroy window in close event handler
            loop(Frame);
        Event ->
            io:format("Event ->~n~w~n", [Event]),
            loop(Frame)
        end.

flush_messages() ->
    receive
        Message -> io:format("flush: ~w~n", [Message]),
        flush_messages()
    after
        100 -> ok
    end.
