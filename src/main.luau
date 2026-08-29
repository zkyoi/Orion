-- // Load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- // Local Cache
local string_sub = string.sub
local string_lower = string.lower
local string_gmatch = string.gmatch

local table_unpack = table.unpack
local table_insert = table.insert

local print = print

local typeof = typeof
local loadstring = loadstring

-- // Vortex Library
local _version: string = "v1.4"
local vortexSuccess, vortex = pcall(function()
    return loadstring(game:HttpGet("https://github.com/zkyoi/Vortex/releases/download/" .. _version .. "/main.luau", true))()
end)

if not vortexSuccess then
    return
end

-- // Services
local Players = game:GetService("Players")

-- // Variables
local localPlayer: Player = Players.LocalPlayer
local currentGameId: number = game.GameId

local baseUrl: string = "https://raw.githubusercontent.com/zkyoi/Orion/refs/heads/main/src/"
local gamesUrl: string = baseUrl .. "games/"
local configUrl: string = gamesUrl .. "config.luau"

local configSuccess, config = pcall(function()
    return loadstring(game:HttpGet(configUrl))()
end)

local prefix: string = "-"
local commands = {}

-- // Helper Functions
local function createCommand(commandName: string, description: string, arguments: { string }, callback: ( arguments: { string }? ) -> ()): ()
    commands[string_lower(commandName)] = {
        name = commandName,
        description = description,
        arguments = arguments,
        callback = callback
    }
end

-- // Commands
createCommand("test", "This is a test command!", { "argument1", "argument2" }, function(arguments): ()
    print(table_unpack(arguments))
end)

createCommand("rejoin", "Rejoins the current server", {}, function(): ()
    vortex.rejoin()
end)

createCommand("goto", "Teleports to a player", { "player" }, function(arguments): ()
    local player = vortex.findPlayer(arguments[1])
    if not player then return end
    vortex.teleportTo(player)
end)

createCommand("vgoto", "Teleports vehicle to player", { "player" }, function(arguments): ()
    local player = vortex.findPlayer(arguments[1])
    if not player then return end
    vortex.teleportVehicle(player)
end)

createCommand("view", "Views a player", { "player" }, function(arguments): ()
    local player = vortex.findPlayer(arguments[1])
    if not player then return end
    vortex.view(player)
end)

createCommand("unview", "Unviews a player", {}, function(): ()
    vortex.unview()
end)

-- // Fetch Game Commands
if configSuccess and config and typeof(config) == "table" and config[currentGameId] then
    local moduleUrl: string = gamesUrl .. config[currentGameId]

    if moduleUrl then
        local gameSuccess, gameModule = pcall(function()
            return loadstring(game:HttpGet(moduleUrl))()
        end)

        if gameSuccess and typeof(gameModule) == "function" then
            gameModule(createCommand, vortex)
        end
    end
end

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

    if #full == 0 then return end

    if string_sub(full[1], 1, 1) == prefix then
        local command: string = string_sub(full[1], 2, #full[1])
        local arguments: { string } = { table_unpack(full, 2, #full) }

        executeCommand(command, arguments)
    end
end

-- // Connections
localPlayer.Chatted:Connect(parseCommand)
