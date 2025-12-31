local tf = math.random(0, 1) == 1
local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/Whatttt23/Scr/refs/heads/main/MN"))()
local rush = spawner.Create({
	Entity = {
		Name = "heloo",
		Asset = "rbxassetid://111174558997246",
		HeightOffset = 2
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
		Values = {7, 100, 0.1, 2} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 90,
		Delay = 0.1,
		Reversed = tf
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush",
		Min = 1,
		Max = 1,
		Delay = 0.1
	},
	Damage = {
		Enabled = true,
		Range = 50,
		Amount = 250
	},
	Crucifixion = {
		Enabled = false,
		Range = 100,
		Resist = false,
		Break = true
	},
	Death = {
		Cause = "Nightmare Rush"
	}
})
rush:SetCallback("OnSpawned", function()
local model = rush.Model
    model.Footsteps.Parent = model:FindFirstChildWhichIsA("BasePart")
    model:FindFirstChildWhichIsA("BasePart").Footsteps.PlaybackSpeed = 0.1
    model:FindFirstChildWhichIsA("BasePart").Footsteps.MaxDistance = 80
    local shift = Instance.new("PitchShiftSoundEffect")
         shift.Octave = 0.61
         shift.Parent = model:FindFirstChildWhichIsA("BasePart").Footsteps

    local distort = Instance.new("DistortionSoundEffect")
         distort.Parent = model:FindFirstChildWhichIsA("BasePart").Footsteps
         distort.Level = 0.75
end)
rush:Run()
