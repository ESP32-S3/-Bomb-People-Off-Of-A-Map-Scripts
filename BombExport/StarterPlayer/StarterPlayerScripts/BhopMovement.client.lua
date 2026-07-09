local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ══════════════════════════════════════════════
-- bhop constants
-- ══════════════════════════════════════════════
local WALK_MAX = 30
local RUN_MAX = 40
local BHOP_MAX = 55
local ACCEL = 33
local DECEL = 44
local BHOP_BOOST = 14
local LEAN_ANGLE = math.rad(6)
local LEAN_SPEED = 0.12
local SWAY_UP = 1.15
local SWAY_LAND = 0.35
local SWAY_SPEED = 0.14
local BHOP_WINDOW = 0.2

-- ══════════════════════════════════════════════
-- sound ids, swap 0 for your rbxassetid numbers
-- ══════════════════════════════════════════════
local SFX = {
	Walk   = { id = 0, volume = 0.5, pitch = 1.0 },
	Sprint = { id = 124251857925873, volume = 0.35, pitch = 1.15 },
	Jump   = { id = 126869109123818, volume = 0.6, pitch = 1.0 },
	Land   = { id = 128671923914413, volume = 0.6, pitch = 0.9 },
}

-- ══════════════════════════════════════════════
-- state
-- ══════════════════════════════════════════════
local currentSpeed = 0
local leanCurrent = 0
local leanTarget = 0
local swayCurrent = 0
local swayTarget = 0
local isSprinting = false
local justLanded = false
local landedTimer = 0
local spaceHeld = false
local activeHum = nil
local isInGame = false

-- ══════════════════════════════════════════════
-- game state tracking
-- ══════════════════════════════════════════════
local stateEvent = ReplicatedStorage:WaitForChild("RoundEvents"):WaitForChild("StateChanged")

local function applyBhopSettings(hum)
	hum.WalkSpeed = WALK_MAX
	hum.JumpPower = 52
	hum.AutoJumpEnabled = true
	player.CameraMode = Enum.CameraMode.LockFirstPerson
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end

local function resetToDefault(hum)
	hum.WalkSpeed = 16
	hum.JumpPower = 50
	hum.AutoJumpEnabled = false
	hum.CameraOffset = Vector3.new(0, 0, 0)
	player.CameraMode = Enum.CameraMode.Classic
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	currentSpeed = 0
	leanCurrent = 0
	leanTarget = 0
	swayCurrent = 0
	swayTarget = 0
	justLanded = false
	landedTimer = 0
end

stateEvent.OnClientEvent:Connect(function(state)
	local wasInGame = isInGame
	isInGame = (state == "InGame")

	if isInGame and not wasInGame and activeHum then
		applyBhopSettings(activeHum)
	elseif wasInGame and not isInGame and activeHum then
		resetToDefault(activeHum)
	end
end)

-- ══════════════════════════════════════════════
-- helpers
-- ══════════════════════════════════════════════
local function makeSound(root, key, looped)
	local s = Instance.new("Sound")
	s.Name = "SFX_" .. key
	s.SoundId = "rbxassetid://" .. SFX[key].id
	s.Volume = SFX[key].volume
	s.PlaybackSpeed = SFX[key].pitch
	s.RollOffMaxDistance = 40
	s.Looped = looped or false
	s.Parent = root
	return s
end

-- ══════════════════════════════════════════════
-- character setup
-- ══════════════════════════════════════════════
local function setupCharacter(char)
	local hum = char:WaitForChild("Humanoid")
	local rootPart = char:WaitForChild("HumanoidRootPart")

	activeHum = hum
	currentSpeed = 0
	leanCurrent = 0
	leanTarget = 0
	swayCurrent = 0
	swayTarget = 0
	justLanded = false
	landedTimer = 0
	spaceHeld = false

	-- default (lobby) settings
	hum.WalkSpeed = 16
	hum.JumpPower = 50
	hum.AutoJumpEnabled = false
	player.CameraMode = Enum.CameraMode.Classic
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default

	-- override with bhop settings if already in game
	if isInGame then
		applyBhopSettings(hum)
	end

	-- build sounds
	local sndWalk   = makeSound(rootPart, "Walk",   true)
	local sndSprint = makeSound(rootPart, "Sprint",  true)
	local sndJump   = makeSound(rootPart, "Jump",   false)
	local sndLand   = makeSound(rootPart, "Land",   false)

	hum.StateChanged:Connect(function(_, new)
		if not isInGame then return end

		if new == Enum.HumanoidStateType.Landed then
			justLanded = true
			landedTimer = BHOP_WINDOW
			swayTarget = -SWAY_LAND
			if SFX.Land.id ~= 0 then sndLand:Play() end
		elseif new == Enum.HumanoidStateType.Jumping then
			justLanded = false
			swayTarget = SWAY_UP
			if SFX.Jump.id ~= 0 then sndJump:Play() end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if not isInGame then return end

		if input.KeyCode == Enum.KeyCode.Space then
			if spaceHeld then return end
			spaceHeld = true

			if hum:GetState() == Enum.HumanoidStateType.Freefall then
				return
			end

			local wasInBhopWindow =
				justLanded or
				hum:GetState() == Enum.HumanoidStateType.Running

			hum:ChangeState(Enum.HumanoidStateType.Jumping)

			if isSprinting and wasInBhopWindow and currentSpeed >= RUN_MAX * 0.8 then
				currentSpeed = math.min(currentSpeed + BHOP_BOOST, BHOP_MAX)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Space then
			spaceHeld = false
		end
	end)

	RunService.RenderStepped:Connect(function(dt)
		if not char.Parent then return end
		if not isInGame then return end

		isSprinting = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

		local moving = hum.MoveDirection.Magnitude > 0.1
		local onGround = hum.FloorMaterial ~= Enum.Material.Air
		local targetMax = isSprinting and RUN_MAX or WALK_MAX

		-- sound: footstep loop management
		if SFX.Walk.id ~= 0 or SFX.Sprint.id ~= 0 then
			local wantWalk   = moving and onGround and not isSprinting
			local wantSprint = moving and onGround and isSprinting

			if wantWalk and not sndWalk.IsPlaying   then sndWalk:Play()   end
			if not wantWalk and sndWalk.IsPlaying    then sndWalk:Stop()   end
			if wantSprint and not sndSprint.IsPlaying then sndSprint:Play() end
			if not wantSprint and sndSprint.IsPlaying then sndSprint:Stop() end
		end

		if moving then
			local accelRate = ACCEL * (isSprinting and 1.6 or 1)

			if currentSpeed < targetMax then
				currentSpeed = math.min(currentSpeed + accelRate * dt, targetMax)
			elseif currentSpeed > targetMax then
				currentSpeed = math.max(currentSpeed - DECEL * dt, targetMax)
			end
		else
			currentSpeed = math.max(currentSpeed - DECEL * 1.5 * dt, 0)
		end

		if landedTimer > 0 then
			landedTimer -= dt

			if landedTimer <= 0 then
				justLanded = false
			end
		end

		if hum.FloorMaterial == Enum.Material.Air then
			local vy = rootPart.AssemblyLinearVelocity.Y

			if vy < -2 then
				swayTarget = math.max(
					swayTarget,
					-math.clamp(-vy * 0.02, 0, SWAY_LAND)
				)
			end
		else
			swayTarget = 0
		end

		hum.WalkSpeed = math.max(currentSpeed, WALK_MAX * 0.6)

		local moveDir = hum.MoveDirection

		if moveDir.Magnitude > 0.1 then
			local dot = moveDir:Dot(camera.CFrame.RightVector)
			leanTarget = -dot * LEAN_ANGLE
		else
			leanTarget = 0
		end

		leanCurrent =
			leanCurrent +
			(leanTarget - leanCurrent) *
			(1 - math.exp(-dt / LEAN_SPEED))

		swayCurrent =
			swayCurrent +
			(swayTarget - swayCurrent) *
			(1 - math.exp(-dt / SWAY_SPEED))

		hum.CameraOffset = Vector3.new(0, swayCurrent, 0)
		camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, leanCurrent)
	end)
end

player.CharacterAdded:Connect(setupCharacter)

if player.Character then
	setupCharacter(player.Character)
end
