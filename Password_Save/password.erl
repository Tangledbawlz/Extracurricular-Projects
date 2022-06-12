-module(password).
-export([start/0, handle_password_checker/0, login/2]).

start() ->
% Create a process
% Param 1 - The module name
% Param 2 - The function to run
% Param 3 - List of parameters to pass to that function (none in this case)
% This will return the Server PID (process ID)
spawn(password, handle_password_checker, []).

handle_password_checker() ->
% Wait for a request
receive
% Save the client PID in both cases so we can send back a response
% The command is called password_check (lower case is called an atom)
% The password_check command takes a tuple of one thing ... in this case Password
% The first clause will run if the Password matches the famous 123456 password.
% The syntax for sending a message is PID ! Message
% In our case, we are sending a message back as a tuple of either {ok} or {error}
{Client_PID, password_check, Password} when Password == "password" -> Client_PID ! {ok};
{Client_PID, password_check, _Password} -> Client_PID ! {error}
end,
% Done processing the client ... use recursion to wait for the next client request
handle_password_checker().

login(Server_PID, Password) ->
% Helper function to run password_check on the server
% The self() function returns the client PID to send to the server
Server_PID ! {self(), password_check, Password},

% Wait for a response back from the server
receive
% response for correct password
{ok} -> io:format("Welcome User~n");

% response for incorrect password
{error} -> io:format("Incorrect password, try again!!!~n")
end.
