%% A micro-blog, wxErlang sample from O'reilly Erlang Programming.

-module(microblog).
-compile(export_all).

-include_lib("wx/include/wx.hrl").

-define(ABOUT, ?wxID_ABOUT).
-define(EXIT, ?wxID_EXIT).
-define(APPEND, 131).

start() ->
    wx:new(),
    Frame = wxFrame:new(wx:null(), ?wxID_ANY, "MicroBlog"),
    Text = wxTextCtrl:new(Frame, ?wxID_ANY,
        [{value, "MiniBlog"},
            {style, ?wxTE_MULTILINE}]),
    setup(Frame, Text),
    wxFrame:show(Frame),
    loop(Frame, Text),
    wx:destroy(),
    flush_messages(),
    ok.

setup(Frame, Text) ->
    setup_menubar(Frame),

    wxFrame:createStatusBar(Frame),
    wxFrame:setStatusText(Frame, "Welcome to wxErlang"),

    wxFrame:connect(Frame, command_menu_selected),
    wxFrame:connect(Frame, close_window),

    wxTextCtrl:setEditable(Text, false),
    ok.

setup_menubar(Frame) ->
    MenuBar = wxMenuBar:new(),
    File = wxMenu:new(),
    Edit = wxMenu:new(),
    Help = wxMenu:new(),

    wxMenu:append(Help, ?ABOUT, "About MicroBlog"),
    wxMenu:append(File, ?EXIT, "Quit"),
    wxMenu:append(Edit, ?APPEND, "Add en&try\tCtrl-T"),

    wxMenuBar:append(MenuBar, File, "&File"),
    wxMenuBar:append(MenuBar, Edit, "&Edit"),
    wxMenuBar:append(MenuBar, Help, "&Help"),

    wxFrame:setMenuBar(Frame, MenuBar).

loop(Frame, Text) ->
    receive
        #wx{id = ?ABOUT, event = #wxCommand{}} -> show_about(Frame), loop(Frame, Text);
        #wx{id = ?EXIT, event = #wxCommand{}} ->
            io:format("Quit Menu~n"), wxWindow:destroy(Frame);
        #wx{event = #wxClose{}} ->
            io:format("close_window~n"), wxWindow:destroy(Frame);
        #wx{id = ?APPEND, event = #wxCommand{}} ->
            append_input_entry(Frame, Text), loop(Frame, Text);
        Event -> io:format("Event ->~n~w~n", [Event]), loop(Frame, Text)
    end.

show_about(Frame) ->
            Str = "MicroBlog is a minimal wxErlang example.",
            MD = wxMessageDialog:new(Frame, Str,
                [{style, ?wxOK bor ?wxICON_INFORMATION},
                {caption, "About MicroBlog"}]),
                wxDialog:showModal(MD),
                wxDialog:destroy(MD).

append_input_entry(Frame, Text) ->
        Prompt = "Please enter text here.",
        MD = wxTextEntryDialog:new(Frame, Prompt,
            [{caption, "New blog entry."}]),
        case wxTextEntryDialog:showModal(MD) of
            ?wxID_OK ->
                Str = wxTextEntryDialog:getValue(MD),
                wxTextCtrl:appendText(Text, [10] ++ dateNow() ++ " " ++ Str);
            _ -> ok
        end,
        wxDialog:destroy(MD).

dateNow() ->
    {{Yea,Mon,Day},{Hou,Min,Sec}} = erlang:localtime(),
    io_lib:format("~4..0B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B",
        [Yea,Mon,Day,Hou,Min,Sec]).

flush_messages() ->
    receive
        Message -> io:format("flush: ~w~n", [Message]),
        flush_messages()
    after
        100 -> ok
    end.
