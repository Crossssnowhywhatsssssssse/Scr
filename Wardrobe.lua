local ReplicatedStorage = game:GetService("ReplicatedStorage")

local latestRoom = ReplicatedStorage.GameData.LatestRoom

-- ===== OPTIONAL VISUAL =====
local function applyVisual(wardrobe)
    for _, part in ipairs(wardrobe:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.DiamondPlate
            part.Color = Color3.fromRGB(70, 70, 70)
        end
    end
end

-- ===== FORCE PLAY (NO DELAY) =====
local function forcePlay(sound)
    sound:Stop()
    sound.TimePosition = 0
    sound:Play()
end

-- ===== MAIN SETUP =====
local function setupWardrobes(room)
    for _, wardrobe in ipairs(room:GetDescendants()) do
        if wardrobe.Name ~= "Wardrobe" then continue end
        if wardrobe:GetAttribute("SoundHooked") then continue end
        wardrobe:SetAttribute("SoundHooked", true)

        -- visual (optional)
        applyVisual(wardrobe)

        local main = wardrobe:FindFirstChild("Main")
        if not main then continue end

        local enter = main:FindFirstChild("SoundEnter")
        local exit  = main:FindFirstChild("SoundExit")
        if not enter or not exit then continue end

        enter.SoundId = "rbxassetid://7309104360"
        exit.SoundId  = "rbxassetid://7309106429"

        local switching = false

        enter:GetPropertyChangedSignal("IsPlaying"):Connect(function()
            if not enter.IsPlaying or switching then return end
            switching = true

            exit:Stop()
            exit.TimePosition = 0
            forcePlay(enter)

            task.delay(0.05, function()
                switching = false
            end)
        end)

        exit:GetPropertyChangedSignal("IsPlaying"):Connect(function()
            if not exit.IsPlaying or switching then return end
            switching = true

            enter:Stop()
            enter.TimePosition = 0
            forcePlay(exit)

            task.delay(0.05, function()
                switching = false
            end)
        end)
    end
end

-- ===== ROOM HANDLING =====
local function onRoomChanged()
    local room = workspace.CurrentRooms:FindFirstChild(latestRoom.Value)
    if room then
        setupWardrobes(room)
    end
end

-- init
onRoomChanged()
latestRoom.Changed:Connect(onRoomChanged)
