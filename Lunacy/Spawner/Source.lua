return function(SCRIPT_ID, callback)
	local RS = game:GetService("ReplicatedStorage")
	local LatestRoom = RS:WaitForChild("GameData"):WaitForChild("LatestRoom")

	local function getSeed(roomValue)
		local job = game.JobId or "0"
		local base = tonumber(job:gsub("%D", "")) or 0
		
		return (base ~ (roomValue * 131)) + (SCRIPT_ID * 997)
	end

	local function getRandom(roomValue)
		return Random.new(getSeed(roomValue))
	end

	local function run(roomValue)
		local rng = getRandom(roomValue)
		pcall(callback, roomValue, rng)
	end

	LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
		run(LatestRoom.Value)
	end)
end
