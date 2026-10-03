local ShakeUtil = {}
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local theCamera, theTouchCamera, theCameraTransform
local theShakePos = Vector3.zero
local theShakeTotal, theCameraTween
local defaultShakeDur = 0.5
local defaultShakeStrength = Vector3.New(0.5, 0.5, 0)
local defaultShakeVibrato = 30

local function CameraShakeUpdate()
  if IsNull(theCameraTransform) or theShakeTotal == nil or theShakePos == nil then
    return
  end
  local shakeOffsetX = theShakePos.x - theShakeTotal.x
  local shakeOffsetY = theShakePos.y - theShakeTotal.y
  local shakeOffsetZ = theShakePos.z - theShakeTotal.z
  theShakeTotal.x = theShakePos.x
  theShakeTotal.y = theShakePos.y
  theShakeTotal.z = theShakePos.z
  local x, y, z = theCameraTransform:Get_position()
  theCameraTransform:Set_position(x + shakeOffsetX, y + shakeOffsetY, z + shakeOffsetZ)
end

local function ShakeTweenGetter()
  return theShakePos
end

local function ShakeTweenSetter(pos)
  theShakePos = pos
  CameraShakeUpdate()
end

function ShakeUtil.DoVibration(intensity, sharpness, duration)
  local theIntensity = tonumber(intensity)
  local theSharpness = tonumber(sharpness)
  local theDuration = tonumber(duration)
  if theIntensity ~= nil and theSharpness ~= nil and theDuration ~= nil then
    CS.MoreMountains.NiceVibrations.MMVibrationManager.ContinuousHaptic(theIntensity, theSharpness, theDuration)
  end
end

function ShakeUtil.TryDoVibration(param_vibrate)
  if type(param_vibrate) == "string" then
    local intensity, sharpness, duration = string.match(param_vibrate, "([^;|]+)[;|]([^;|]+)[;|]([^;|]+)")
    if intensity ~= nil and sharpness ~= nil and duration ~= nil then
      ShakeUtil.DoVibration(intensity, sharpness, duration)
    end
  end
end

function ShakeUtil.DoCameraShake(param_shake)
  if theCameraTween ~= nil then
    return
  end
  theCamera = CS.UnityEngine.Camera.main
  if theCamera then
    theTouchCamera = theCamera:GetComponent(typeof(MobileTouchCamera))
    if theTouchCamera then
      theCameraTransform = theTouchCamera.transform
    end
  end
  if theCamera and theTouchCamera and theCameraTransform then
    local duration = defaultShakeDur
    local strength = defaultShakeStrength
    local vibrato = defaultShakeVibrato
    if type(param_shake) == "string" then
      local str1, str2, str3, str4, str5 = string.match(param_shake, "([^;|]+)[;|]([^;|]+)[;|]([^;|]+)[;|]([^;|]+)[;|]([^;|]+)")
      if str1 ~= nil and str2 ~= nil and str3 ~= nil and str4 ~= nil and str5 ~= nil then
        duration = tonumber(str1) or defaultShakeDur
        strength = Vector3.New(tonumber(str2) or 0.5, tonumber(str3) or 0.5, tonumber(str4) or 0)
        vibrato = tonumber(str5) or defaultShakeVibrato
      end
    elseif param_shake and (param_shake.duration or param_shake.strength or param_shake.vibrato) then
      duration = param_shake.duration or defaultShakeDur
      strength = param_shake.strength or defaultShakeStrength
      vibrato = param_shake.vibrato or defaultShakeVibrato
    end
    theShakePos = Vector3.zero
    theShakeTotal = Vector3.zero
    theCameraTween = DOTween.Shake(ShakeTweenGetter, ShakeTweenSetter, duration, strength, vibrato, 90, true):OnComplete(function()
      theCameraTween = nil
      theShakePos = Vector3.zero
    end)
  end
end

function ShakeUtil.DoCameraShakeKillExist(param_shake)
  if theCameraTween then
    theCameraTween:Kill()
    theCameraTween = nil
  end
  ShakeUtil.DoCameraShake(param_shake)
end

function ShakeUtil.KillShake()
  if theCameraTween then
    theCameraTween:Kill()
    theCameraTween = nil
  end
end

return ConstClass("ShakeUtil", ShakeUtil)
