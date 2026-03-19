local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = player.PlayerGui

local TweenService = game:GetService("TweenService")

local sprintBarBackground = Instance.new("Frame")
sprintBarBackground.Size = UDim2.new(0.4, 0, 0.04, 0)
sprintBarBackground.Position = UDim2.new(0.3, 0, 0.8, 0)
sprintBarBackground.BackgroundColor3 = Color3.fromRGB(39,32,32)
sprintBarBackground.BorderSizePixel = 0
sprintBarBackground.Parent = screenGui

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0.3,0)
bgCorner.Parent = sprintBarBackground

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 3
stroke.Parent = sprintBarBackground

local gradientStroke = Instance.new("UIGradient")
gradientStroke.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(0,135,145)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(105,245,255))
}
gradientStroke.Rotation = -90
gradientStroke.Parent = stroke

local sprintBar = Instance.new("Frame")
sprintBar.Size = UDim2.new(1, 0, 1, 0)
sprintBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
sprintBar.BorderSizePixel = 0
sprintBar.Parent = sprintBarBackground

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0.3,0)
barCorner.Parent = sprintBar

local barGradient = Instance.new("UIGradient")
barGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(0,135,145)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(105,245,255))
}
barGradient.Rotation = 0
barGradient.Parent = sprintBar

local darkScreen = Instance.new("Frame")
darkScreen.Size = UDim2.new(1,0,1,0)
darkScreen.BackgroundColor3 = Color3.fromRGB(0,0,0)
darkScreen.BackgroundTransparency = 1
darkScreen.Parent = screenGui

local sprinting = false
local maxStamina = 120
local currentStamina = maxStamina
local staminaRegenRate = 10
local staminaDrainRate = 10
local canSprint = true

local function updateSprintBar()
    sprintBar.Size = UDim2.new(currentStamina / maxStamina, 0, 1, 0)
end

local function updateDarkScreen()
    if currentStamina < 70 then
        local percent = math.clamp(1 - (currentStamina / 70), 0, 1)
        darkScreen.BackgroundTransparency = 1 - (percent * 0.4)
    else
        darkScreen.BackgroundTransparency = 1
    end
end

local sprintButton = Instance.new("TextButton")
sprintButton.Size = UDim2.new(0, 80, 0, 80)
sprintButton.Position = UDim2.new(0.9, -50, 0.4, -50)
sprintButton.Text = "Sprint"
sprintButton.TextScaled = true
sprintButton.Font = Enum.Font.GothamBold
sprintButton.TextColor3 = Color3.fromRGB(255,255,255)

sprintButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
sprintButton.BackgroundTransparency = 0.1
sprintButton.BorderSizePixel = 0
sprintButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2,0)
corner.Parent = sprintButton

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150,150,150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100,100,100))
}
bgGradient.Rotation = 90
bgGradient.Parent = sprintButton

local stroke = Instance.new("UIStroke")
stroke.Thickness = 4
stroke.Color = Color3.fromRGB(105,245,255)
stroke.Transparency = 0
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = sprintButton

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,Color3.fromRGB(55,125,130)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(105,245,255))
}
strokeGradient.Rotation = -90
strokeGradient.Parent = stroke

local UIS = game:GetService("UserInputService")

sprintButton.MouseButton1Down:Connect(function()
    sprintButton.TextTransparency = 0.3
    sprintButton.BackgroundTransparency = 0.4
	if canSprint and currentStamina > 0 then
		sprinting = true
		player.Character:SetAttribute("SpeedBoost", 3)
	end
end)

sprintButton.MouseButton1Up:Connect(function()
    sprintButton.TextTransparency = 0
    sprintButton.BackgroundTransparency = 0.1
	sprinting = false
	player.Character:SetAttribute("SpeedBoost", 0)
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.LeftShift then
	sprintButton.TextTransparency = 0.3
	sprintButton.BackgroundTransparency = 0.4
		if canSprint and currentStamina > 0 then
			sprinting = true
			player.Character:SetAttribute("SpeedBoost", 4)
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
	sprintButton.TextTransparency = 0
	sprintButton.BackgroundTransparency = 0.1
		sprinting = false
		player.Character:SetAttribute("SpeedBoost", 0)
	end
end)

local runService = game:GetService("RunService")

runService.Heartbeat:Connect(function(dt)
    if sprinting then
        if currentStamina > 0 then
            currentStamina -= staminaDrainRate * dt
        else
            sprinting = false
            canSprint = false
            player.Character:SetAttribute("SpeedBoost", 0)
            
            local noStamernaSound = Instance.new("Sound",workspace)
			noStamernaSound.SoundId = "rbxassetid://8258601891"
			noStamernaSound.Volume = 0.8
			noStamernaSound.PlayOnRemove = true
			noStamernaSound:Destroy()
            require(player.PlayerGui.MainUI.Initiator.Main_Game).caption("You're exhausted", true)
            
        end
    else
        if currentStamina < maxStamina then
            currentStamina += staminaRegenRate * dt
        end
    end

    if currentStamina >= maxStamina then
        canSprint = true
    end

    currentStamina = math.clamp(currentStamina, 0, maxStamina)

    updateSprintBar()
    updateDarkScreen()
end)
