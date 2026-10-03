local UIRadarZombieBusTrainEnterTip = BaseClass("UIRadarZombieBusTrainEnterTip", UIBaseContainer)
local base = UIBaseContainer
local firstInTip_path = "FirstInTip"
local fullTip_path = "FullTip"
local fullTip_text_path = "FullTip/TipTxt"
local bus_img = "FirstInTip/Icon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.firstInTip = self:AddComponent(UIButton, firstInTip_path)
  self.firstInTip:SetOnClick(function()
    self.holder:OnClick()
  end)
  self.fullTip = self:AddComponent(UIBaseContainer, fullTip_path)
  self.fullTipText = self:AddComponent(UIText, fullTip_text_path)
  self.fullTipText:SetLocalText("ghostrecon_077")
  self.fullTip:SetActive(false)
  self.iconImg = self:AddComponent(UIRawImage, bus_img)
end

local function ComponentDestroy(self)
  self.firstInTip = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.zombieBusEventInfo = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function Refresh(self)
  self.iconImg:SetActive(true)
  local zombieBusEventInfo = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
  self.zombieBusEventInfo = zombieBusEventInfo
  if self.zombieBusEventInfo.template then
    self.iconImg:LoadSpriteAsync(self.zombieBusEventInfo.template:GetDetectEventBannerImagePath())
  end
end

UIRadarZombieBusTrainEnterTip.OnCreate = OnCreate
UIRadarZombieBusTrainEnterTip.OnDestroy = OnDestroy
UIRadarZombieBusTrainEnterTip.OnEnable = OnEnable
UIRadarZombieBusTrainEnterTip.OnDisable = OnDisable
UIRadarZombieBusTrainEnterTip.ComponentDefine = ComponentDefine
UIRadarZombieBusTrainEnterTip.ComponentDestroy = ComponentDestroy
UIRadarZombieBusTrainEnterTip.DataDefine = DataDefine
UIRadarZombieBusTrainEnterTip.DataDestroy = DataDestroy
UIRadarZombieBusTrainEnterTip.OnAddListener = OnAddListener
UIRadarZombieBusTrainEnterTip.OnRemoveListener = OnRemoveListener
UIRadarZombieBusTrainEnterTip.Refresh = Refresh
return UIRadarZombieBusTrainEnterTip
