local Resource = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local LWSeasonTowerCameraLogic = BaseClass("LWSeasonTowerCameraLogic")
local defaultShakeDur = 0.7
local defaultShakeStrength = Vector3.New(0.8, 0.8, 0)
local defaultShakeVibrato = 20
local theShakePos = Vector3.zero
local theShakeTotal, theCameraTween, theCamera, theTouchCamera, theCameraTransform

function LWSeasonTowerCameraLogic:__init()
  self.active = false
  self.cameraLoadRequest = nil
  self.camera = nil
  self.touchCamera = nil
  self.followCameraTarget = nil
  self.cameraOffsetIdle = 7
  self.cameraOffsetMove = -1.5
  self.cameraOffsetSmooth = 6
  self.cameraOffset = self.cameraOffsetIdle
  self.cameraFollowLocked = false
  self.cameraLockLookAtPos = nil
  self.finalCameraHoldLocked = false
  self.finalCameraHoldPos = nil
  self.cameraPrefabPath = nil
  self.cameraConfig = nil
  self.getSquadRoot = nil
  self.isLogicActive = nil
end

function LWSeasonTowerCameraLogic:__delete()
  self:Shutdown()
end

function LWSeasonTowerCameraLogic:Init(param)
  param = param or {}
  self.active = true
  self.cameraPrefabPath = param.cameraPrefabPath
  self.cameraConfig = param.cameraConfig or {}
  self.getSquadRoot = param.getSquadRoot
  self.isLogicActive = param.isLogicActive
  self.cameraOffsetIdle = param.cameraOffsetIdle or 7
  self.cameraOffsetMove = param.cameraOffsetMove or -1.5
  self.cameraOffsetSmooth = param.cameraOffsetSmooth or 6
  self.cameraOffset = self.cameraOffsetIdle
  self.cameraFollowLocked = false
  self.cameraLockLookAtPos = nil
  self.finalCameraHoldLocked = false
  self.finalCameraHoldPos = nil
  self.followCameraTarget = nil
  local req = Resource:InstantiateAsync(self.cameraPrefabPath)
  req:completed("+", function(request)
    if not self.active or self.isLogicActive and not self.isLogicActive() then
      request:Destroy()
      return
    end
    local camera = request.gameObject:GetComponent(typeof(Camera))
    if camera == nil then
      Logger.LogError("LWSeasonTowerCameraLogic:Init camera component is nil")
      return
    end
    camera.fieldOfView = self.cameraConfig.FOV
    camera.transform:Set_eulerAngles(self.cameraConfig.ROTATION, 0, 0)
    self.camera = camera
    local touchCamera = camera:GetComponent(typeof(MobileTouchCamera))
    if touchCamera == nil then
      Logger.LogError("LWSeasonTowerCameraLogic:Init MobileTouchCamera component is nil")
      return
    end
    touchCamera.CanMoveing = false
    touchCamera.CamZoom = self.cameraConfig.HEIGHT
    touchCamera.LodLevel = 1
    local offsetZ = self.cameraConfig.HEIGHT / math.tan(self.cameraConfig.ROTATION * math.pi / 180)
    touchCamera:SetZoomParams(1, self.cameraConfig.HEIGHT, offsetZ, 25)
    touchCamera.CamZoomMin = 20
    self.touchCamera = touchCamera
    self:Sync(true)
    if Config.IsPC() then
      local viewRect = CS.UnityEngine.Camera.main.rect
      if self.camera ~= nil then
        self.camera.rect = CS.UnityEngine.Rect(viewRect.x, viewRect.y, viewRect.width, viewRect.height)
      end
      EventManager:GetInstance():AddListenerWithSelf(EventId.ChatViewSplitRatioChange, self.OnRatioChange, self)
    end
  end)
  self.cameraLoadRequest = req
end

function LWSeasonTowerCameraLogic:OnRatioChange(ratio)
  if self.camera then
    local viewRect = self.camera.rect
    local data = tonumber(ratio)
    self.camera.rect = CS.UnityEngine.Rect(viewRect.x, viewRect.y, data, viewRect.height)
  end
end

function LWSeasonTowerCameraLogic:Shutdown()
  if Config.IsPC() then
    EventManager:GetInstance():RemoveListener2(EventId.ChatViewSplitRatioChange, self.OnRatioChange, self)
  end
  self.active = false
  if self.cameraLoadRequest then
    self.cameraLoadRequest:Destroy()
    self.cameraLoadRequest = nil
  end
  self.camera = nil
  self.touchCamera = nil
  self.followCameraTarget = nil
  self.cameraFollowLocked = false
  self.cameraLockLookAtPos = nil
  self.finalCameraHoldLocked = false
  self.finalCameraHoldPos = nil
  self.getSquadRoot = nil
  self.isLogicActive = nil
end

function LWSeasonTowerCameraLogic:ResetSweepState()
  self.finalCameraHoldLocked = false
  self.finalCameraHoldPos = nil
end

function LWSeasonTowerCameraLogic:SetFollowLock(enabled)
  if enabled then
    self.cameraFollowLocked = true
    self.cameraLockLookAtPos = self:GetLookTargetPos()
    return
  end
  self.cameraFollowLocked = false
  self.cameraLockLookAtPos = nil
end

function LWSeasonTowerCameraLogic:SetFinalFollowLock(enabled, finalTargetPosZ, moveSpeed)
  if enabled then
    local squadRoot = self.getSquadRoot and self.getSquadRoot() or nil
    if squadRoot == nil then
      return nil
    end
    self.finalCameraHoldPos = self:GetLookTargetPos()
    self.finalCameraHoldLocked = true
    self.finalTargetPosZ = finalTargetPosZ
    self.moveSpeed = moveSpeed
    return
  end
  self.finalCameraHoldLocked = false
  self.finalCameraHoldPos = nil
  self.finalTargetPosZ = nil
  self.moveSpeed = nil
end

function LWSeasonTowerCameraLogic:UpdateMoveState(dt, squadNewPosZ, isSquadMoving)
  if self.cameraFollowLocked and self.cameraLockLookAtPos ~= nil then
    local relativeOffset = self.cameraLockLookAtPos.z - squadNewPosZ
    if relativeOffset <= self.cameraOffsetMove then
      self.cameraFollowLocked = false
      self.cameraOffset = self.cameraOffsetMove
      self.cameraLockLookAtPos = nil
    end
  end
  local desiredCameraOffset = self.cameraOffsetIdle
  if isSquadMoving and not self.finalCameraHoldLocked then
    desiredCameraOffset = self.cameraOffsetMove
  end
  local cameraOffsetT = math.min(1, dt * self.cameraOffsetSmooth)
  self.cameraOffset = self.cameraOffset + (desiredCameraOffset - self.cameraOffset) * cameraOffsetT
  if self.finalCameraHoldLocked and self.moveSpeed then
    self.finalCameraHoldPos.z = self.finalCameraHoldPos.z + self.moveSpeed * Time.deltaTime
  end
end

function LWSeasonTowerCameraLogic:GetLookTargetPos()
  local squadRoot = self.getSquadRoot and self.getSquadRoot() or nil
  if squadRoot == nil then
    return nil
  end
  if self.finalCameraHoldLocked then
    local posZ = math.min(self.finalTargetPosZ + self.cameraOffsetIdle, self.finalCameraHoldPos.z)
    return Vector3.New(self.finalCameraHoldPos.x, self.finalCameraHoldPos.y, posZ)
  end
  if self.cameraFollowLocked and self.cameraLockLookAtPos ~= nil then
    return Vector3.New(self.cameraLockLookAtPos.x, self.cameraLockLookAtPos.y, self.cameraLockLookAtPos.z)
  end
  local x, y, z = squadRoot.transform:Get_position()
  return Vector3.New(x, y, z + (self.cameraOffset or self.cameraOffsetIdle or 7))
end

function LWSeasonTowerCameraLogic:CameraFollowLookAt(targetPos)
  if self.touchCamera == nil or targetPos == nil then
    return
  end
  if self.followCameraTarget == nil then
    self.followCameraTarget = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
    self.touchCamera:LookAt(targetPos)
    return
  end
  local transform = self.touchCamera.transform
  local x, y, z = transform:Get_position()
  local offsetX = targetPos.x - self.followCameraTarget.x
  local offsetY = targetPos.y - self.followCameraTarget.y
  local offsetZ = targetPos.z - self.followCameraTarget.z
  transform:Set_position(x + offsetX, y + offsetY, z + offsetZ)
  self.followCameraTarget.x = targetPos.x
  self.followCameraTarget.y = targetPos.y
  self.followCameraTarget.z = targetPos.z
end

function LWSeasonTowerCameraLogic:Sync(force)
  if self.touchCamera == nil then
    return
  end
  local targetPos = self:GetLookTargetPos()
  if targetPos == nil then
    return
  end
  if force then
    self.followCameraTarget = nil
  end
  self:CameraFollowLookAt(targetPos)
end

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

function LWSeasonTowerCameraLogic:DoCameraShake(param_shake)
  if theCameraTween ~= nil then
    return
  end
  if theCameraTween then
    theCameraTween:Kill()
    theCameraTween = nil
  end
  theCamera = self.camera
  theTouchCamera = self.touchCamera
  theCameraTransform = self.touchCamera.transform
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

return LWSeasonTowerCameraLogic
