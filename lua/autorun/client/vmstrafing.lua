-- file: lua/autorun/client/vmstrafing.lua
-- brief: Causes the Modern Warfare Base view models to tilt when strafing left and right
-- copyright: Copyleft 2022 Garry's Mod Player. All rights reversed.

-- param: weapon is a reference to the active weapon
-- returns: true if the active weapon can be tilted, otherwise false
local function CanTilt(weapon)
  return weapon.Base == "mg_base" and weapon:GetSlot() > 1
end

-- param: player is a reference to the local player
-- returns: true if the local player can lean, otherwise false
local function CanLean(player)
  return player:KeyDown(IN_ATTACK2) and not player:KeyDown(IN_SPEED)
end

-- param: player is a reference to the local player
-- returns: true if the local player can lean right, otherwise false
local function CanLeanRight(player)
  return CanLean(player) and player:KeyDown(IN_MOVERIGHT) and not player:KeyDown(IN_MOVELEFT)
end

-- param: player is a reference to the local player
-- returns: true if the local player can lean left, otherwise false
local function CanLeanLeft(player)
  return CanLean(player) and not player:KeyDown(IN_MOVERIGHT) and player:KeyDown(IN_MOVELEFT)
end

-- brief: Tilt the weapon's view model to target angle
-- param: weapon is a reference to the active weapon
-- param: targetAngle indicates the target angle to approach
local function TiltViewModel(weapon, targetAngle)
  local currentAngle = weapon.ViewModelOffsets.Aim.Angles.roll
  if math.abs(currentAngle) != math.abs(targetAngle) then
    local roll = math.ApproachAngle(currentAngle, targetAngle, 1)
    weapon.ViewModelOffsets.Aim.Angles.roll = roll
  end
end

-- brief: Causes the Modern Warfare Base view models to tilt when strafing left and right
hook.Add("Think", "vmstrafing", function()
  if CanTilt(LocalPlayer():GetActiveWeapon()) then
    if not CanLean(LocalPlayer()) then
      return TiltViewModel(LocalPlayer():GetActiveWeapon(), 0)
    end
    if CanLeanRight(LocalPlayer()) then
      return TiltViewModel(LocalPlayer():GetActiveWeapon(), 45)
    end
    if CanLeanLeft(LocalPlayer()) then
      return TiltViewModel(LocalPlayer():GetActiveWeapon(), -45)
    end
  end
end)
