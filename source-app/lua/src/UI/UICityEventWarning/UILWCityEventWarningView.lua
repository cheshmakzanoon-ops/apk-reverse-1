local UILWCityEventWarningView = BaseClass("UILWCityEventWarningView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local uavRepairTimerImgRes = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_jiesuowurenji04.png"
local zombieSeaTimerImgRes = "Assets/Main/Sprites/UI/LWUIBeginnerCityEvent/FX_xinshou_boss_time.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:PlaySound()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTip1 = self:AddComponent(UIText, "Bg/node/tip1")
  self.textTip2 = self:AddComponent(UIText, "Bg/node/tip2")
  self.textTip3 = self:AddComponent(UIText, "Bg/node/tip3")
  self.bannerUAVRepair = self:AddComponent(UIBaseContainer, "Bg/node/bannerUAVRepair")
  self.bannerUAVRepair:SetActive(false)
  self.bannerZombieSeaFirstStage = self:AddComponent(UIBaseContainer, "Bg/node/bannerZombieSeaFirstStage")
  self.bannerZombieSeaFirstStage:SetActive(false)
  self.bannerZombieSeaSecondStage = self:AddComponent(UIBaseContainer, "Bg/node/bannerZombieSeaSecondStage")
  self.bannerZombieSeaSecondStage:SetActive(false)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self:OnClick()
  end)
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  if cityEventId == -1 then
    self.ctrl:CloseSelf()
    return
  end
  self.endTime = DataCenter.LWBeginnerDirectorManager:GetCurCityEventEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.endTime then
    self.ctrl:CloseSelf()
    return
  end
  self.valid = true
  if cityEventId == BeginnerDirectorEvent.UAV_Repaire then
    self.bannerUAVRepair:SetActive(true)
  elseif cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage then
    self.bannerZombieSeaFirstStage:SetActive(true)
  elseif cityEventId == BeginnerDirectorEvent.ZombieSeaSecondStage then
    self.bannerZombieSeaSecondStage:SetActive(true)
  end
  local cityEventName = DataCenter.LWBeginnerDirectorManager:GetCurCityEventName()
  self.textTip1:SetLocalText(cityEventName)
  local cityEventDesc = DataCenter.LWBeginnerDirectorManager:GetCurCityEventDesc()
  self.textTip2:SetLocalText(cityEventDesc)
  self:UpdateTime()
  self.bgClockImg = self:AddComponent(UIImage, "Bg/node/bgClock")
  local timerImgResPath = self:GetEventRelatedSpritePath(cityEventId)
  if timerImgResPath then
    self.bgClockImg:LoadSprite(timerImgResPath)
  end
end

local function ComponentDestroy(self)
  self.textTip1 = nil
  self.textTip2 = nil
  self.textTip3 = nil
  self.bannerUAVRepair = nil
  self.bannerZombieSeaFirstStage = nil
  self.bannerZombieSeaSecondStage = nil
  self.bg = nil
  self.bgClockImg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.endTime = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UILWCityEventWarningView:Update1000MS()
  if self.valid then
    self:UpdateTime()
  end
end

function UILWCityEventWarningView:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTime - curTime
  local cityEventId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventID()
  self.textTip3:SetText(string.format("<color=%s>%s</color>", self:GetEventRelatedColor(cityEventId), UITimeManager:GetInstance():MilliSecondToFmtString(diff)))
  if diff <= 0 then
    self.valid = false
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end
end

function UILWCityEventWarningView:GetEventRelatedSpritePath(cityEventId)
  if cityEventId == BeginnerDirectorEvent.UAV_Repaire then
    return uavRepairTimerImgRes
  elseif cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage or cityEventId == BeginnerDirectorEvent.ZombieSeaSecondStage then
    return zombieSeaTimerImgRes
  end
end

function UILWCityEventWarningView:GetEventRelatedColor(cityEventId)
  if cityEventId == BeginnerDirectorEvent.UAV_Repaire then
    return "#54F2FE"
  elseif cityEventId == BeginnerDirectorEvent.ZombieSeaFirstStage or cityEventId == BeginnerDirectorEvent.ZombieSeaSecondStage then
    return "#FF3D3D"
  else
    return "#FF3D3D"
  end
end

function UILWCityEventWarningView:OnClick()
  self.ctrl:CloseSelf()
end

function UILWCityEventWarningView:PlaySound()
  local soundId = DataCenter.LWBeginnerDirectorManager:GetCurCityEventUIWarningSound()
  if soundId and 0 < soundId then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
end

UILWCityEventWarningView.OnCreate = OnCreate
UILWCityEventWarningView.OnDestroy = OnDestroy
UILWCityEventWarningView.OnEnable = OnEnable
UILWCityEventWarningView.OnDisable = OnDisable
UILWCityEventWarningView.ComponentDefine = ComponentDefine
UILWCityEventWarningView.ComponentDestroy = ComponentDestroy
UILWCityEventWarningView.DataDefine = DataDefine
UILWCityEventWarningView.DataDestroy = DataDestroy
UILWCityEventWarningView.OnAddListener = OnAddListener
UILWCityEventWarningView.OnRemoveListener = OnRemoveListener
return UILWCityEventWarningView
