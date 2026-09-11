-- // Local Cache
local string_format = string.format

-- // Variables
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer: Player = Players.LocalPlayer

-- // Game Variables
local gameName: string = "GEF"
local gameId: number = 5216419122

local pickupsFolder: (Folder | Instance)? = Workspace:WaitForChild("Pickups", 5)
if not pickupsFolder then return function() end end

return function (createCommand, vortex)
    createCommand("game", "Prints the game you are currently in", {}, function(): ()
        print(string_format("Game Name: %s", gameName))
    end)

    createCommand("give", "Gives you an item", { "item" }, function(arguments): ()
        local itemName: string = arguments[1]
        if not itemName then return end
        local item: (MeshPart | Instance)? = pickupsFolder:FindFirstChild(itemName)
        if not item then return end
        local proximityPrompt: ProximityPrompt? = item:FindFirstChildOfClass("ProximityPrompt")
        if not proximityPrompt then return end
        local lastPosition: CFrame? = vortex.getCFrame(localPlayer)
        vortex.teleportTo(item)
        task.wait(0.5)
        fireproximityprompt(proximityPrompt)
        task.wait(0.5)

        if lastPosition then
            vortex.teleportTo(lastPosition)
        end
    end)
end
