local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/Whatttt23/Scr/refs/heads/main/Depth"))()
local depth = spawner.Create({
	Entity = {
		Name = "Depth",
		Asset = "rbxassetid://11535848347",
		HeightOffset = 5
	},
	Lights = {
		Flicker = {
			Enabled = false,
			Duration = 1
		},
		Shatter = false,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = true,
		Range = 50,
		Values = {5, 100, 0.1, 2} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 260,
		Delay = 5,
		Reversed = false
	},
	Rebounding = {
		Enabled = true,
		Type = "Ambush",
		Min = 1,
		Max = 2,
		Delay = 0.01
	},
	Damage = {
		Enabled = false,
		Range = 150,
		Amount = 250
	},
	Crucifixion = {
		Enabled = true,
		Range = 100,
		Resist = false,
		Break = true
	},
	Death = {
		Cause = "Depth"
	}
})
local color = Instance.new("ColorCorrectionEffect", game.Lighting)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CreditGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "CreditLabel"
TextLabel.Text = "!So Cold!"
TextLabel.TextTransparency = 1
TextLabel.Font = Enum.Font.Gotham
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextStrokeTransparency = 0
TextLabel.TextSize = 45
TextLabel.AnchorPoint = Vector2.new(0.5, 1)
TextLabel.Position = UDim2.new(0.5, 0, 1, -50)
TextLabel.Size = UDim2.new(0, 800, 0, 50)
TextLabel.BackgroundTransparency = 1
TextLabel.Parent = ScreenGui
game.TweenService:Create(TextLabel, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, TextColor3 = Color3.fromRGB(0, 100, 255)}):Play()
depth:SetCallback("OnSpawned", function()
  local model = depth.Model
  local entity = model:FindFirstChildWhichIsA("BasePart")
  local sound = entity:FindFirstChild("Sound")
  sound.Parent = workspace
    task.spawn(function()
    game.TweenService:Create(color, TweenInfo.new(10), {
        TintColor = Color3.fromRGB(0, 100, 255),
        Saturation = -0.7,
        Contrast = 0.2
    }):Play()
    end)
end)
depth:SetCallback("OnDespawning", function()
    task.spawn(function()
    game.TweenService:Create(color, TweenInfo.new(5), {
        TintColor = Color3.fromRGB(255, 255, 255),
        Saturation = 0,
        Contrast = 0
    }):Play()
    game.TweenService:Create(TextLabel, TweenInfo.new(3), {
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 1
    }):Play()
    end)
    wait(5)
    color:Destroy()
    ScreenGui:Destroy()
end)
depth:Run()
