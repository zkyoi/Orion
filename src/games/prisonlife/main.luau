-- // Local Cache
local string_format = string.format

-- // Game Variables
local gameName: string = "Prison Life"
local gameId: number = 73885730

return function (createCommand, vortex)
    createCommand("game", "Prints the game you are currently in", {}, function(): ()
        print(string_format("Game Name: %s", gameName))
    end)
end
