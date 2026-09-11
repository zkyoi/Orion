-- // Local Cache
local string_format = string.format
local string_lower = string.lower

-- // Variables
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer: Player = Players.LocalPlayer

-- // Game Variables
local gameName: string = "GEF"
local gameId: number = 5216419122

local pickupsFolder: (Folder | Instance)? = Workspace:WaitForChild("Pickups", 5)
if not pickupsFolder then return function() end end

local locations: { Vector3 | CFrame } = {
    ["insidesecrettower"] = Vector3.new(-679, 54, -308),
}

return function (createCommand, vortex)
    createCommand("game", "Prints the game you are currently in", {}, function(): ()
        print(string_format("Game Name: %s", gameName))
    end)

    createCommand("give", "Gives you an item", { "item" }, function(arguments): ()
        local itemName: string = arguments[1]
        if not itemName then return end
        local item: (MeshPart | Instance)?

        for _, unknownItem: (MeshPart | Instance) in pickupsFolder:GetChildren() do
            if string_lower(itemName) == string_lower(unknownItem.Name) then
                item = unknownItem
                break
            end
        end

        if not item then return end
        local proximityPrompt: ProximityPrompt? = item:FindFirstChildOfClass("ProximityPrompt")
        if not proximityPrompt then return end
        local lastPosition: CFrame? = vortex.getCFrame(localPlayer)

        vortex.teleportTo(item)
        task.wait(0.25)
        fireproximityprompt(proximityPrompt)
        task.wait(0.5)

        if lastPosition then
            vortex.teleportTo(lastPosition)
        end
    end)
end
