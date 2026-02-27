local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local function spawncruxy(pos, parent)
    local success, objects = pcall(function()
        return game:GetObjects("rbxassetid://11631916882")
    end)
    
    if not success or #objects == 0 then 
        return 
    end

    local v63 = objects[1]
    local vu64 = v63.Handle:Clone()
    v63:Destroy()
    
    vu64.Name = "Cruxy7"
    vu64.Position = pos
    vu64.Anchored = true
    vu64.Parent = parent

    local randomRot = math.random(-90, 90)
    vu64.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(randomRot), math.rad(-90))

    local light1 = Instance.new("PointLight", vu64)
    light1.Brightness = 10000
    light1.Color = Color3.fromRGB(255, 0, 0)
    light1.Range = 2

    local light2 = Instance.new("PointLight", vu64)
    light2.Brightness = 3
    light2.Color = Color3.fromRGB(0, 255, 255)
    light2.Range = 10
    
    local highlight = Instance.new("Highlight")
	highlight.Parent = vu64
	highlight.FillTransparency = 0.8
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
	highlight.OutlineTransparency = 0
			
    local prompt = Instance.new("ProximityPrompt", vu64)
    prompt.Name = "prompty"
    prompt.Style = Enum.ProximityPromptStyle.Custom
    prompt.MaxActivationDistance = 5
    prompt.ObjectText = "Crucifix"
    prompt.ActionText = "Grab"

    prompt.Triggered:Connect(function()
    vu64:Destroy()

    local shadow=game:GetObjects("rbxassetid://11631916882")[1]
    shadow.Parent = game.Players.LocalPlayer.Backpack
    local Players = game:GetService("Players")
    local Plr = Players.LocalPlayer
    local Char = Plr.Character or Plr.CharacterAdded:Wait()
    local Hum = Char:WaitForChild("Humanoid")
    local RightArm = Char:WaitForChild("RightUpperArm")
    local LeftArm = Char:WaitForChild("LeftUpperArm")
    local RightC1 = RightArm.RightShoulder.C1
    local LeftC1 = LeftArm.LeftShoulder.C1
    local MainGame = require(Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
    
         local function setupCrucifix(tool)
         RightArm.Name = "R_Arm"
         LeftArm.Name = "L_Arm"
         RightArm.RightShoulder.C1 = RightC1 * CFrame.Angles(math.rad(-90), math.rad(-15), 0)
         LeftArm.LeftShoulder.C1 = LeftC1 * CFrame.new(-0.2, -0.3, -0.5) * CFrame.Angles(math.rad(-125), math.rad(25), math.rad(25))
         end

         local highlight = Instance.new("Highlight")
     	highlight.Parent = shadow.Handle
     	highlight.FillTransparency = 0.8
     	highlight.FillColor = Color3.fromRGB(0, 255, 255)
    	 highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    	 highlight.OutlineTransparency = 0

        shadow.Equipped:Connect(function()
        setupCrucifix(shadow)
        end)
 
        shadow.Unequipped:Connect(function()
        RightArm.Name = "RightUpperArm"
        LeftArm.Name = "LeftUpperArm"
        
        RightArm.RightShoulder.C1 = RightC1
        LeftArm.LeftShoulder.C1 = LeftC1
        end)

        MainGame.caption("You grab the crucifix.", true)
        task.wait(3)
        MainGame.caption("It has a text on the back: \"Made in China\"", true)
        task.wait(3)
        MainGame.caption("It only works with custom entities.", true)
        task.wait(5)
        
        shadow.Equipped:Connect(function()
        MainGame.caption("It only works with custom entities.", true)
        end)
    end)
end

ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function(roomValue)
    task.wait(0.5)
    local roomPath = Workspace.CurrentRooms:FindFirstChild(tostring(roomValue))
    if not roomPath or not roomPath:FindFirstChild("Assets") then return end

    for _, item in pairs(roomPath.Assets:GetDescendants()) do
        if item.Name == "Table" and item:FindFirstChild("Main") then
            spawncruxy(item.Main.Position + Vector3.new(0, 1.8, 0), item)
            break
        end
    end
end)
