-- // Load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- // Local Cache
local string_sub = string.sub
local string_lower = string.lower
local string_gmatch = string.gmatch
local string_match = string.match

local table_unpack = table.unpack
local table_insert = table.insert

-- // Vortex Library
local _version: string = "v1.4"
local vortex = loadstring(game:HttpGet("https://github.com/zkyoi/Vortex/releases/download/" .. _version .. "/main.luau", true))()

-- // Services
local Players = game:GetService("Players")

-- // Variables
local localPlayer: Player = Players.LocalPlayer

local prefix: string = "-"
local commands = {}

-- // Helper Functions
local function createCommand(commandName: string, description: string, arguments: { string }, callback: ( arguments: { string } ) -> ()): ()
    commands[string_lower(commandName)] = {
        name = commandName,
        description = description,
        arguments = arguments,
        callback = callback
    }
end

-- // Commands
createCommand("test", "This is a test command!", { "argument1", "argument2" }, function(arguments: { string }): ()
    print(table_unpack(arguments))
end)

createCommand("rejoin", "Rejoins the current server", {}, function(arguments: { string }): ()
    vortex.rejoin()
end)

createCommand("goto", "Teleports to a player", { "player" }, function(arguments: { string }): ()
    local player = vortex.findPlayer(arguments[1])
    if not player then return end
    vortex.teleportTo(player)
end)

createCommand("vgoto", "Teleports vehicle to player", { "player" }, function(arguments: { string }): ()
    local player = vortex.findPlayer(arguments[1])
    if not player then return end
    vortex.teleportVehicle(player)
end)

createCommand("view", "Views a player", { "player" }, function(arguments: { string }): ()
    local player = vortex.findPlayer(arguments[1])
    if not player then return end
    vortex.view(player)
end)

createCommand("unview", "Unviews a player", {}, function(arguments: { string }): ()
    vortex.unview()
end)

-- // Command Functions
local function executeCommand(commandName: string, arguments: { string }?): ()
    if not commandName then return end
    arguments = arguments or {}

    local command = commands[string_lower(commandName)]
    if not command then return end
    task.spawn(command.callback, arguments)
end

local function parseCommand(message: string): ()
    if not message or message == "" then return end
    local full: { string } = {}

    for match: string in string_gmatch(message, "%S+") do
        table_insert(full, match)
    end

    if #full <= 0 then return end

    if string_sub(full[1], 1, 1) == prefix then
        local command: string = string_sub(full[1], 2, #full[1])
        local arguments: { string } = { table_unpack(full, 2, #full) }

        executeCommand(command, arguments)
    end
end

-- // Connections
localPlayer.Chatted:Connect(parseCommand)
