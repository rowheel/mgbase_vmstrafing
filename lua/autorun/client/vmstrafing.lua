-- lua/autorun/client/vmstrafing.lua
-- Registers a hook that tilts the view model when strafing left and right
-- Copyleft 2022 Garry's Mod Player. All rights reversed.

-- Parameter weapon is a reference to the active weapon
-- Returns true if the active weapon can be tilted, otherwise false
local function canTilt(weapon)
	return weapon.Base == "mg_base" and weapon:GetSlot() > 1
end

-- Parameter player is a reference to the local player
-- Returns true if the local player can lean, otherwise false
local function canLean(player)
	return player:KeyDown(IN_ATTACK2) and not player:KeyDown(IN_SPEED)
end

-- Parameter player is a reference to the local player
-- Returns true if the local player can strafe right, otherwise false
local function canStrafeRight(player)
	return player:KeyDown(IN_MOVERIGHT) and not player:KeyDown(IN_MOVELEFT)
end

-- Parameter player is a reference to the local player
-- Returns true if the local player can strafe left, otherwise false
local function canStrafeLeft(player)
	return player:KeyDown(IN_MOVELEFT) and not player:KeyDown(IN_MOVERIGHT)
end

-- Tilts the view model to target angle
-- Parameter weapon is a reference to the active weapon
-- Parameter targetAngle indicates the target angle to approach
local function tiltViewModel(weapon, targetAngle)
	local currentAngle = weapon.ViewModelOffsets.Aim.Angles.roll
	if math.abs(currentAngle) ~= math.abs(targetAngle) then
		local roll = math.ApproachAngle(currentAngle, targetAngle, 1)
		weapon.ViewModelOffsets.Aim.Angles.roll = roll
	end
end

-- Registers a hook that tilts the view model when strafing left and right
-- Returns nil
hook.Add("Think", "vmstrafing", function()
	if canTilt(LocalPlayer():GetActiveWeapon()) then
		if not canLean(LocalPlayer()) then
			return tiltViewModel(LocalPlayer():GetActiveWeapon(), 0)
		end
		if canStrafeRight(LocalPlayer()) then
			return tiltViewModel(LocalPlayer():GetActiveWeapon(), 45)
		end
		if canStrafeLeft(LocalPlayer()) then
			return tiltViewModel(LocalPlayer():GetActiveWeapon(), -45)
		end
	end
end)
