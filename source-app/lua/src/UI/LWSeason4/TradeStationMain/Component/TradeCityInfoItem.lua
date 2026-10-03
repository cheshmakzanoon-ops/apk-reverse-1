local base = UIBaseContainer
local TradeCityInfoItem = BaseClass("TradeCityInfoItem", base)
local icon_path = "Icon"
local cityName_path = "TxtCityName"
local endTime_path = "TxtTimes"
local desc_path = "TxtDesc"
local btnGoto_path = "BtnGoto"

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
  self.cityName = self:AddComponent(UIText, cityName_path)
  self.endTime = self:AddComponent(UIText, endTime_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.btnGoto = self:AddComponent(UIButton, btnGoto_path)
  self.btnGoto:SetOnClick(function()
    DataCenter.SeasonTradeDataManager:GotoTradeStation(self.tradeCityData)
  end)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    DataCenter.SeasonTradeDataManager:GotoTradeStation(self.tradeCityData)
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.cityName = nil
  self.endTime = nil
  self.desc = nil
  self.btnGoto = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeCityInfoItem:ReInit(tradeCityData)
  self.tradeCityData = tradeCityData
  if tradeCityData == nil then
    self:SetActive(false)
    return
  end
  local temp = DataCenter.AllianceCityTemplateManager:GetTemplate(tradeCityData.tradeId, LuaEntry.Player:GetCurServerId())
  local nameStr = string.format("Lv.%s %s", temp.level, temp:GetName())
  self.cityName:SetText(nameStr)
  self.icon:LoadSprite(tradeCityData.iconPath)
  self.icon:SetNativeSize()
  self.StartTime = nil
  self.EndTime = nil
  self.btnGoto:SetActive(false)
  local state, targetTime = tradeCityData:GetTimeState()
  if state == AllianceCityShowTimeState.TradeLock then
    self.desc:SetLocalText("season_s3_activity_1000072_desc02")
    self.StartTime = targetTime
    self.endTime:SetActive(true)
  elseif state == AllianceCityShowTimeState.TradeBattle then
    self.desc:SetLocalText("457044")
    self.EndTime = targetTime
    self.endTime:SetActive(true)
  else
    self.desc:SetLocalText("winter_battlefield_interface_tips1007")
  end
  self:Update1000MS()
  self:SetActive(true)
end

function TradeCityInfoItem:Update1000MS()
  if UIUtil.SetLeftTimeText(self.endTime, self.StartTime, self.EndTime) then
    self.StartTime = nil
    self.EndTime = nil
    self.endTime:SetActive(false)
    self.btnGoto:SetActive(true)
  end
end

TradeCityInfoItem.OnCreate = OnCreate
TradeCityInfoItem.OnDestroy = OnDestroy
TradeCityInfoItem.OnEnable = OnEnable
TradeCityInfoItem.OnDisable = OnDisable
TradeCityInfoItem.ComponentDefine = ComponentDefine
TradeCityInfoItem.ComponentDestroy = ComponentDestroy
TradeCityInfoItem.DataDefine = DataDefine
TradeCityInfoItem.DataDestroy = DataDestroy
return TradeCityInfoItem
