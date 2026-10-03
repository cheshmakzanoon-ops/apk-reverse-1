local base = UIBaseContainer
local TradeStationHonorTitleItem = BaseClass("TradeStationHonorTitleItem", base)
local icon_path = "bgIcon"
local desc_path = "title"
local bgEmpty_path = "bgEmpty"
local unlockTips_path = "bgEmpty/unlockTIps"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.bgEmpty = self:AddComponent(UIBaseContainer, bgEmpty_path)
  self.unlockTips = self:AddComponent(UIText, unlockTips_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.desc = nil
  self.bgEmpty = nil
  self.unlockTips = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeStationHonorTitleItem:ReInit(data)
  local config = DataCenter.SeasonTradeDataManager:GetTitleTemplateByLevel(data.level)
  if not config then
    Logger.LogError("TradeStationHonorTitleItem:ReInit level is nil; level=" .. data.level)
    return
  end
  self.icon:LoadSprite(config.title_show_icon)
  self.desc:SetLocalText(config.name)
  self.StartTime = nil
  if data.empty then
    self.bgEmpty:SetActive(true)
    self.StartTime = DataCenter.SeasonTradeDataManager:GetTradeStationOpenTime(data.level)
    if self.StartTime then
      self.unlockTips:SetActive(true)
      self:Update1000MS()
    else
      self.unlockTips:SetActive(false)
    end
  else
    self.bgEmpty:SetActive(false)
  end
end

function TradeStationHonorTitleItem:Update1000MS()
  if self.StartTime then
    UIUtil.SetLeftTimeText(self.unlockTips, self.StartTime, nil, "season_s3_trade_city051")
  end
end

TradeStationHonorTitleItem.OnCreate = OnCreate
TradeStationHonorTitleItem.OnDestroy = OnDestroy
TradeStationHonorTitleItem.OnEnable = OnEnable
TradeStationHonorTitleItem.OnDisable = OnDisable
TradeStationHonorTitleItem.ComponentDefine = ComponentDefine
TradeStationHonorTitleItem.ComponentDestroy = ComponentDestroy
TradeStationHonorTitleItem.DataDefine = DataDefine
TradeStationHonorTitleItem.DataDestroy = DataDestroy
return TradeStationHonorTitleItem
