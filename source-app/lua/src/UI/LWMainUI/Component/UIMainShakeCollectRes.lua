local UIMainShakeCollectRes = BaseClass("UIMainShakeCollectRes", UIBaseContainer)
local base = UIBaseContainer
local SHAKE_OPEN = true
local SHAKE_CD = 10
local SHAKE_ASPEED = 13
local SHAKE_DELAY = 1
local SHAKE_TIME = 0
local ONE_KEY_COLLECT_FLAG = false
local CSInput = CS.UnityEngine.Input
local CSDebugKeyBoard = CS.UnityEngine.KeyCode.F12
local CSSupportsGyroscope = CS.SystemInfo.supportsGyroscope
local CSGyro = CS.UnityEngine.Input.gyro
local CSVibrator = CS.Vibrator
local Setting = CS.GameEntry.Setting
local UpdateDelta = 0.1
local MathAbs = math.abs
local IsDebug = CS.CommonUtils.IsDebug()
local CheckBuildId = {
  10201000,
  10202000,
  10207000,
  10209000,
  10210000,
  10211000
}
local LastBuildId = 10214000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
end

local function DataDefine(self)
  SHAKE_OPEN = LuaEntry.DataConfig:CheckSwitch("shake_collect")
  SHAKE_CD = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k1", SHAKE_CD)
  SHAKE_ASPEED = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k2", SHAKE_ASPEED)
  SHAKE_DELAY = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k3", SHAKE_DELAY)
  SHAKE_TIME = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k4", SHAKE_TIME)
  local cfgBuildId = LuaEntry.DataConfig:TryGetStr("shakeCollectRes_config", "k5")
  if cfgBuildId then
    local tab = string.split(cfgBuildId, ";")
    CheckBuildId = {}
    for index, value in ipairs(tab) do
      table.insert(CheckBuildId, tonumber(value))
    end
  end
  LastBuildId = LuaEntry.DataConfig:TryGetNum("shakeCollectRes_config", "k6", LastBuildId)
  table.insert(CheckBuildId, LastBuildId)
  DataCenter.BuildManager:SetShakeCollectCheckList(CheckBuildId)
  if SHAKE_OPEN then
    self.collectBuilds = {}
    self.lastBubble = nil
    self.isInCollect = false
    self.cd = 0
    self.truckCd = 0
    self.oldZ = 0
    self.newZ = 0
    self.preASpeed = 0
    self.delayTime = 0
    self.checkTimes = 0
    if not Config.IsPC() and CSSupportsGyroscope and CSGyro then
      CSGyro.enabled = true
      CSGyro.updateInterval = UpdateDelta
    end
    self.settingIsOn = Setting:GetBool(SettingKeys.SHAKE_COLLECT_RES, true)
    self.truckSettingIsOn = Setting:GetBool(SettingKeys.SHAKE_COLLECT_TRUCK_RES, false)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.RefreshShakeCollectResSetting, self.RefreshSetting)
  self:AddUIListener(EventId.TriggerOneKeyCollectAll, self.SetCollectFlagOn)
  self:AddUIListener(EventId.RefreshShakeCollectTruckResSetting, self.RefreshTruckSetting)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshShakeCollectResSetting, self.RefreshSetting)
  self:RemoveUIListener(EventId.TriggerOneKeyCollectAll, self.SetCollectFlagOn)
  self:RemoveUIListener(EventId.RefreshShakeCollectTruckResSetting, self.RefreshTruckSetting)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDestroy(self)
end

local function DataDestroy(self)
  self.collectBuilds = nil
  self.lastBubble = nil
  self.preASpeed = nil
  self.isInCollect = nil
  self.oldZ = nil
  self.newZ = nil
  self.preASpeed = nil
  self.delayTime = nil
  self.checkTimes = nil
  self.settingIsOn = nil
  self.truckSettingIsOn = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function Update100MS(self)
  if SHAKE_OPEN then
    if self.isInCollect then
      self:CollectRes()
    else
      local curSeconds = UITimeManager:GetInstance():GetServerSeconds()
      if self.settingIsOn and curSeconds > self.cd then
        local isCheckSuccess
        local canCollect = self:GetCanCollect()
        if self:CanOneKeyCollectRes() then
          isCheckSuccess = canCollect and ONE_KEY_COLLECT_FLAG
        end
        if not isCheckSuccess and not Config.IsPC() then
          isCheckSuccess = CSSupportsGyroscope ~= nil and CSGyro ~= nil and canCollect and self:GetIsShake()
        end
        if IsDebug and CSInput.GetKeyDown(CSDebugKeyBoard) or isCheckSuccess then
          ONE_KEY_COLLECT_FLAG = false
          self:RefreshCollectRes()
        end
      end
      if self.truckSettingIsOn and curSeconds > self.truckCd then
        local isCheckSuccess
        if not Config.IsPC() then
          isCheckSuccess = CSSupportsGyroscope ~= nil and CSGyro ~= nil and self:GetCanCollect() and self:GetIsShake()
        end
        if IsDebug and CSInput.GetKeyDown(CSDebugKeyBoard) or isCheckSuccess then
          self:CheckTruckResCollect()
        end
      end
    end
  end
end

local function RefreshCollectRes(self)
  self.collectBuilds = {}
  local haveRes = false
  for key, value in ipairs(CheckBuildId) do
    local buildList = BuildingUtils.GetBuildListByBuildId(value)
    if buildList ~= nil and table.count(buildList) ~= 0 and buildList[1] ~= nil then
      local total = 0
      for k, v in pairs(buildList) do
        local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
        total = total + storage
      end
      if 0 < total then
        table.insert(self.collectBuilds, value)
        haveRes = true
      end
    end
  end
  if haveRes then
    self.isInCollect = true
    self.cd = SHAKE_CD + UITimeManager:GetInstance():GetServerSeconds()
    if CSVibrator and CSVibrator.HapticsSupported() then
      if CS.SDKManager.IS_UNITY_ANDROID() then
        CSVibrator.Warning()
      elseif CS.SDKManager.IS_UNITY_IOS() then
        CSVibrator.Failure()
      end
    end
    PostEventLog.Track(PostEventLog.Defines.ShakeCollectRes, {})
  end
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

local function GetCanCollect(self)
  local canCollect = CS.SceneManager:IsInCity()
  if canCollect then
    local topWindow = UIManager:GetInstance():GetStackTopWindow()
    local UIMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    canCollect = UIMain ~= nil and UIMain.View ~= nil and (topWindow == nil or topWindow.Name == UIWindowNames.UIWorldTileUI)
  end
  canCollect = canCollect and LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SHAKE_COLLECT_RES) > 0
  return canCollect
end

local function CollectRes(self)
  local isInCollect = false
  if self.collectBuilds and #self.collectBuilds > 0 then
    local buildId = table.remove(self.collectBuilds, 1)
    if CS.SceneManager:IsInCity() and CS.SceneManager.World then
      local totalStorage = BuildingUtils.CityCollectionByItemId(tonumber(buildId))
      if totalStorage ~= nil and totalStorage ~= 0 then
        DataCenter.LWSoundManager:PlayBubbleEffect(buildId)
      end
      isInCollect = true
    end
  end
  self.isInCollect = isInCollect
end

local function RefreshSetting(self, isOn)
  self.settingIsOn = isOn
end

local function RefreshTruckSetting(self, isOn)
  self.truckSettingIsOn = isOn
end

local function SetCollectFlagOn(self, buildItemID)
  ONE_KEY_COLLECT_FLAG = true
end

local function CheckTruckResCollect(self)
  self.truckCd = SHAKE_CD + UITimeManager:GetInstance():GetServerSeconds()
  SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 1, true)
end

function UIMainShakeCollectRes:CanOneKeyCollectRes()
  return DataCenter.ProductLineManager:CanOneKeyCollectRes()
end

UIMainShakeCollectRes.OnCreate = OnCreate
UIMainShakeCollectRes.OnEnable = OnEnable
UIMainShakeCollectRes.OnAddListener = OnAddListener
UIMainShakeCollectRes.OnRemoveListener = OnRemoveListener
UIMainShakeCollectRes.OnDisable = OnDisable
UIMainShakeCollectRes.ComponentDefine = ComponentDefine
UIMainShakeCollectRes.ComponentDestroy = ComponentDestroy
UIMainShakeCollectRes.ComponentDestroy = ComponentDestroy
UIMainShakeCollectRes.DataDefine = DataDefine
UIMainShakeCollectRes.DataDestroy = DataDestroy
UIMainShakeCollectRes.OnDestroy = OnDestroy
UIMainShakeCollectRes.Update100MS = Update100MS
UIMainShakeCollectRes.RefreshCollectRes = RefreshCollectRes
UIMainShakeCollectRes.GetCanCollect = GetCanCollect
UIMainShakeCollectRes.GetIsShake = GetIsShake
UIMainShakeCollectRes.CollectRes = CollectRes
UIMainShakeCollectRes.RefreshSetting = RefreshSetting
UIMainShakeCollectRes.RefreshTruckSetting = RefreshTruckSetting
UIMainShakeCollectRes.SetCollectFlagOn = SetCollectFlagOn
UIMainShakeCollectRes.CheckTruckResCollect = CheckTruckResCollect
return UIMainShakeCollectRes
