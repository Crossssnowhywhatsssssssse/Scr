local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = player.PlayerGui

local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera

local NORMAL_FOV = 70
local SPRINT_FOV = 85
local FOV_TWEEN_TIME = 1

local currentFovTween

local function setFOV(targetFov)
	if currentFovTween then
		currentFovTween:Cancel()
	end

	currentFovTween = TweenService:Create(
		camera,
		TweenInfo.new(
			FOV_TWEEN_TIME,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{FieldOfView = targetFov}
	)

	currentFovTween:Play()
end

local sprintBarBackground = Instance.new("Frame")
sprintBarBackground.Size = UDim2.new(0.4, 0, 0.04, 0)
sprintBarBackground.Position = UDim2.new(0.3, 0, 0.8, 0)
sprintBarBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sprintBarBackground.BorderSizePixel = 5
sprintBarBackground.Parent = screenGui

local sprintBar = Instance.new("Frame")
sprintBar.Size = UDim2.new(1, 0, 1, 0)
sprintBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
sprintBar.BorderSizePixel = 5
sprintBar.Parent = sprintBarBackground

local darkScreen = Instance.new("Frame")
darkScreen.Size = UDim2.new(1,0,1,0)
darkScreen.BackgroundColor3 = Color3.fromRGB(0,0,0)
darkScreen.BackgroundTransparency = 1
darkScreen.Parent = screenGui

local sprinting = false
local maxStamina = 100
local currentStamina = maxStamina
local staminaRegenRate = 5
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
sprintButton.Size = UDim2.new(0.1, 0, 0.1, 0)
sprintButton.Position = UDim2.new(0.9, 0, 0.5, 0)
sprintButton.Text = " "
sprintButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sprintButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sprintButton.Parent = screenGui

local UIS = game:GetService("UserInputService")

sprintButton.MouseButton1Down:Connect(function()
	if canSprint and currentStamina > 0 then
		sprinting = true
		player.Character:SetAttribute("SpeedBoost", 3)
		setFOV(SPRINT_FOV)
	end
end)

sprintButton.MouseButton1Up:Connect(function()
	sprinting = false
	player.Character:SetAttribute("SpeedBoost", 0)
	setFOV(NORMAL_FOV)
end)

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		if canSprint and currentStamina > 0 then
			sprinting = true
			player.Character:SetAttribute("SpeedBoost", 3)
			setFOV(SPRINT_FOV)
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		sprinting = false
		player.Character:SetAttribute("SpeedBoost", 0)
		setFOV(NORMAL_FOV)
	end
end)

local runService = game:GetService("RunService")

runService.RenderStepped:Connect(function()
	if sprinting then
		camera.FieldOfView = math.max(camera.FieldOfView, SPRINT_FOV)
	end
end)

runService.Heartbeat:Connect(function(dt)
    if sprinting then
        if currentStamina > 0 then
            currentStamina -= staminaDrainRate * dt
        else
            sprinting = false
            canSprint = false
            player.Character:SetAttribute("SpeedBoost", 0)
            setFOV(NORMAL_FOV)

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
