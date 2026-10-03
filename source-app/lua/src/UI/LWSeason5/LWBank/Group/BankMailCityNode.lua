local base = UIAsyncContainer
local BankMailCityNode = BaseClass("BankMailCityNode", base)
local cityIcon_path = "cityIcon"
local cityLvText_path = "cityLvText"
local cityNameText_path = "cityNameText"
local citySliderYellow_path = "citySliderYellow"
local citySliderRed_path = "citySliderRed"
local citySliderText_path = "citySliderText"
local rootHpLost_path = "CityIconBubble"
local cityHpLost_path = "CityIconBubble/cityHpLost"
local skillHpLost_path = "CityIconBubble/skillHpLost"
local cityProgressIcon_path = "cityProgressIcon"
local cityHpIcon_path = "CityIconBubble/cityHpLost/cityHpIcon"
local sKillHpIcon_path = "CityIconBubble/skillHpLost/sKillHpIcon"
local cityBanner_path = "CityBanner"

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
  self.cityIcon = self:AddComponent(UIImage, cityIcon_path)
  self.cityLvText = self:AddComponent(UIText, cityLvText_path)
  self.cityNameText = self:AddComponent(UIText, cityNameText_path)
  self.citySliderYellow = self:AddComponent(UISlider, citySliderYellow_path)
  self.citySliderRed = self:AddComponent(UISlider, citySliderRed_path)
  self.citySliderText = self:AddComponent(UIText, citySliderText_path)
  self.rootHpLost = self:AddComponent(UIBaseContainer, rootHpLost_path)
  self.cityHpLost = self:AddComponent(UIText, cityHpLost_path)
  self.skillHpLost = self:AddComponent(UIText, skillHpLost_path)
  self.cityProgressIcon = self:AddComponent(UIImage, cityProgressIcon_path)
  self.cityHpIcon = self:AddComponent(UIImage, cityHpIcon_path)
  self.sKillHpIcon = self:AddComponent(UIImage, sKillHpIcon_path)
  self.cityBanner = self:AddComponent(UIRawImage, cityBanner_path)
end

local function ComponentDestroy(self)
  self.cityIcon = nil
  self.cityLvText = nil
  self.cityNameText = nil
  self.citySliderYellow = nil
  self.citySliderRed = nil
  self.citySliderText = nil
  self.rootHpLost = nil
  self.cityHpLost = nil
  self.skillHpLost = nil
  self.cityProgressIcon = nil
  self.cityHpIcon = nil
  self.sKillHpIcon = nil
  self.cityBanner = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankMailCityNode:ReInit(data, player2)
  self.data = data
  self:UpdateData()
end

function BankMailCityNode:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  self:SetAnchoredPositionXY(0, 0)
  local data = self.data
  local hpData = data.hpData
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(hpData.strongholdId, data._battleServerId)
  if not meta then
    return
  end
  self.cityLvText:SetLocalText("140002", meta.level or "")
  self.cityNameText:SetLocalText(meta and meta.name)
  self.citySliderYellow:SetValue(hpData.afterAmount / hpData.maxAmount)
  self.citySliderRed:SetValue(hpData.beforeAmount / hpData.maxAmount)
  self.citySliderText:SetText(string.format("%s/%s", hpData.afterAmount, hpData.maxAmount))
  self.cityHpLost:SetText(string.format("+%s", hpData.beforeAmount - hpData.afterAmount))
  if self.rootHpLost ~= nil and self.skillHpLost ~= nil then
    self.skillHpLost:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cityHpLost.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skillHpLost.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rootHpLost.transform)
  end
  DataCenter.SeasonBankManager:LoadItemIcon(self.cityProgressIcon, meta)
  DataCenter.SeasonBankManager:LoadItemIcon(self.cityHpIcon, meta)
  DataCenter.SeasonBankManager:LoadItemIcon(self.sKillHpIcon, meta)
end

BankMailCityNode.OnCreate = OnCreate
BankMailCityNode.OnDestroy = OnDestroy
BankMailCityNode.OnEnable = OnEnable
BankMailCityNode.OnDisable = OnDisable
BankMailCityNode.ComponentDefine = ComponentDefine
BankMailCityNode.ComponentDestroy = ComponentDestroy
BankMailCityNode.DataDefine = DataDefine
BankMailCityNode.DataDestroy = DataDestroy
return BankMailCityNode
