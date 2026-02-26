local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local FunctionsURL = "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"
local Success, Functions = pcall(function()
    return loadstring(game:HttpGet(FunctionsURL))()
end)

if not Success then warn("Không thể load Functions module!") return end

local MainGame = require(Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)

local clicknumber = 0

ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function(roomValue)
    local lastroom = tostring(roomValue)
    local currentRoomModel = Workspace.CurrentRooms:FindFirstChild(lastroom)
    
    if not currentRoomModel then return end
    
    local fakedoor = currentRoomModel:FindFirstChild("Sideroom")
    
    if fakedoor then
        local customRoomURL = "https://raw.githubusercontent.com/Voor-Pr00/Dreda/refs/heads/main/rrrrrrrrrrrrr.rbxm?raw=true"
        local customRoom = Functions.LoadCustomInstance(customRoomURL)
        
        if customRoom then
            customRoom.Name = "custom"
            customRoom.Parent = currentRoomModel
            
            local newCFrame = fakedoor:GetPivot()
            customRoom:PivotTo(newCFrame)
            
            local reversedCFrame = customRoom:GetPivot() * CFrame.Angles(0, math.rad(180), 0)
            customRoom:PivotTo(reversedCFrame)
            
            fakedoor:Destroy()
        end
    else
        print("Sideroom (fakedoor) not found in room: " .. lastroom)
    end

    local customlast = currentRoomModel:WaitForChild("custom", 5)
    if customlast then
        clicknumber = 0 -- Reset lượt click cho phòng mới
        
        local assets = customlast:FindFirstChild("Assets")
        if not assets then return end

        local p1 = assets:FindFirstChild("Painting_Big1")
        local p4 = assets:FindFirstChild("Painting_Tall")
        local w2 = assets:FindFirstChild("Wardrobe2")
        local cx = assets:FindFirstChild("Crucifix")

        if p1 and p1:FindFirstChild("PaintPrompt") then
            p1.PaintPrompt.Triggered:Connect(function()
                clicknumber = clicknumber + 1
                
                if clicknumber < 25 then
                    MainGame.caption("This painting is titled ''??'' ", true)
                elseif clicknumber == 25 then
                    MainGame.caption("Stop spam clicking me.", true)
                elseif clicknumber == 50 then
                    MainGame.caption("Okay, this is what you got.", true)
                    local hum = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health -= 25 end
                elseif clicknumber == 75 then
                    MainGame.caption("Ok i'm done.", true)
                    if p1:FindFirstChild("Canvas") and p1.Canvas:FindFirstChild("SurfaceGui") then
                        p1.Canvas.SurfaceGui:ClearAllChildren()
                    end
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Voor-Pr00/Bloopies/refs/heads/main/Hahaahentityfunny"))()
                elseif clicknumber >= 76 then
                    MainGame.caption("There is no painting.", true)
                end
            end)
        end

        if p4 and p4:FindFirstChild("InteractPrompt") then
            p4.InteractPrompt.Triggered:Connect(function()
                MainGame.caption("This painting is titled ''Mohner Liser''. Drawn by ThatOneAmethystIceCube.", true)
            end)
        end

        if w2 and w2:FindFirstChild("HidePrompt") then
            w2.HidePrompt.Triggered:Connect(function()
                MainGame.caption("The Door is stuck.", true)
            end)
        end

        if cx and cx:FindFirstChild("CrucifixPrompt") then
            cx.CrucifixPrompt.Triggered:Connect(function()
                MainGame.caption("The Crucifix emits a strange aura.", true)
            end)
        end
    end
end)
