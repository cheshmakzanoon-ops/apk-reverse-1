local UIMainShakeMainBaseDisco = BaseClass("UIMainShakeMainBaseDisco", UIBaseContainer)
local base = UIBaseContainer
local SHAKE_CD = 10
local SHAKE_ASPEED = 13
local SHAKE_DELAY = 1
local SHAKE_TIME = 0
local CSInput = CS.UnityEngine.Input
local CSDebugKeyBoard = CS.UnityEngine.KeyCode.F12
local CSSupportsGyroscope = CS.SystemInfo.supportsGyroscope
local CSGyro = CS.UnityEngine.Input.gyro
local UpdateDelta = 0.1
local MathAbs = math.abs
local IsDebug = CS.CommonUtils.IsDebug()

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
end

local function DataDefine(self)
  SHAKE_CD = LuaEntry.DataConfig:TryGetNum("s4_disco", "k3", SHAKE_CD)
  SHAKE_ASPEED = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k2", SHAKE_ASPEED)
  SHAKE_DELAY = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k3", SHAKE_DELAY)
  SHAKE_TIME = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k4", SHAKE_TIME)
  self.cd = 0
  self.oldZ = 0
  self.newZ = 0
  self.preASpeed = 0
  self.delayTime = 0
  self.checkTimes = 0
  if not Config.IsPC() and CSSupportsGyroscope and CSGyro then
    CSGyro.enabled = true
    CSGyro.updateInterval = UpdateDelta
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.OnPhoneShakeHappen, self.RequestPlayMainBaseDiscoEffect)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnPhoneShakeHappen, self.RequestPlayMainBaseDiscoEffect)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
end

local function DataDestroy(self)
  self.preASpeed = nil
  self.oldZ = nil
  self.newZ = nil
  self.preASpeed = nil
  self.delayTime = nil
  self.checkTimes = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function Update100MS(self)
end

local function GetIsShake(self)
  if CSSupportsGyroscope and CSGyro then
    self.newZ = CSGyro.attitude.eulerAngles.z
    local diff = CSGyro.rotationRateUnbiased.z
    local absDiff = MathAbs(diff)
    if absDiff > SHAKE_ASPEED then
      if self.preASpeed == 0 then
        self.preASpeed = diff
        self.delayTime = 0
        self.checkTimes = 0
      elseif self.preASpeed > 0 and diff < SHAKE_ASPEED or self.preASpeed < 0 and diff > SHAKE_ASPEED then
        self.checkTimes = self.checkTimes + 1
      end
      if self.checkTimes >= SHAKE_TIME then
        self.preASpeed = 0
        self.delayTime = 0
        self.checkTimes = 0
        return true
      else
        self.preASpeed = diff
      end
    end
    if self.preASpeed ~= 0 then
      self.delayTime = self.delayTime + UpdateDelta
      if self.delayTime > SHAKE_DELAY then
        self.preASpeed = 0
        self.delayTime = 0
        self.checkTimes = 0
      end
    end
    self.oldZ = self.newZ
  end
  return false
end

local function CanPlayMainBaseDiscoEffect(self)
  local inWolrd = CS.SceneManager:IsInWorld()
  if not inWolrd then
    return false
  end
  return true
end

local function RequestPlayMainBaseDiscoEffect(self)
  local isInSeason = SeasonUtil.IsInSeason(false)
  if isInSeason then
    SFSNetwork.SendMessage(MsgDefines.RequestMainBaseDisco)
  end
end

UIMainShakeMainBaseDisco.OnCreate = OnCreate
UIMainShakeMainBaseDisco.OnEnable = OnEnable
UIMainShakeMainBaseDisco.OnAddListener = OnAddListener
UIMainShakeMainBaseDisco.OnRemoveListener = OnRemoveListener
UIMainShakeMainBaseDisco.OnDisable = OnDisable
UIMainShakeMainBaseDisco.ComponentDefine = ComponentDefine
UIMainShakeMainBaseDisco.ComponentDestroy = ComponentDestroy
UIMainShakeMainBaseDisco.ComponentDestroy = ComponentDestroy
UIMainShakeMainBaseDisco.DataDefine = DataDefine
UIMainShakeMainBaseDisco.DataDestroy = DataDestroy
UIMainShakeMainBaseDisco.OnDestroy = OnDestroy
UIMainShakeMainBaseDisco.Update100MS = Update100MS
UIMainShakeMainBaseDisco.GetIsShake = GetIsShake
UIMainShakeMainBaseDisco.CanPlayMainBaseDiscoEffect = CanPlayMainBaseDiscoEffect
UIMainShakeMainBaseDisco.RequestPlayMainBaseDiscoEffect = RequestPlayMainBaseDiscoEffect
return UIMainShakeMainBaseDisco
