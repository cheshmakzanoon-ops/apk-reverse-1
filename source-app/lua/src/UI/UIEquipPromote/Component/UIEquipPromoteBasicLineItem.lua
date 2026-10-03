local UIEquipPromoteBasicLineItem = BaseClass("UIEquipPromoteBasicLineItem", UIBaseContainer)
local base = UIBaseContainer
local attriNameTextPath = "AttriNameText"
local attriValueContainerPath = "AttriValue"
local attriCurValueTextPath = "AttriValue/CurValueText"
local attriArrowIconPath = "AttriValue/ArrowIcon"
local attriNextValueTextPath = "AttriValue/NextValueText"
local effectPath = "Eff_ui_hero_xiangqing_qianghua_shuaguang"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.attriNameText = self:AddComponent(UIText, attriNameTextPath)
  self.attriValueContainer = self:AddComponent(UIBaseContainer, attriValueContainerPath)
  self.attriCurValueText = self:AddComponent(UIText, attriCurValueTextPath)
  self.attriArrowIcon = self:AddComponent(UIImage, attriArrowIconPath)
  self.attriNextValueText = self:AddComponent(UIText, attriNextValueTextPath)
  self.effect = self:AddComponent(UIBaseContainer, effectPath)
  self.effect:SetActive(false)
end

local function ComponentDestroy(self)
  self.attriNameText = nil
  self.attriValueContainer = nil
  self.attriCurValueText = nil
  self.attriArrowIcon = nil
  self.attriNextValueText = nil
  self.effect = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetData(self, data)
  if not data then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.attriNameText:SetLocalText(HeroUtils.GetHeroPropertyNameId(data.id))
  self.data = data
  local curValue = self.data.value
  local nextValue = self.data.nextValue
  self.attriCurValueText:SetText(HeroUtils.GetFormattedPropertyValue(data.id, curValue))
  if nextValue == nil or nextValue == curValue then
    self.attriArrowIcon:SetActive(false)
    self.attriNextValueText:SetText("")
    self.attriCurValueText:SetAnchoredPositionXY(300, -21)
    self.attriCurValueText:SetSizeDeltaXY(260, 42)
  else
    self.attriArrowIcon:SetActive(true)
    self.attriNextValueText:SetText(HeroUtils.GetFormattedPropertyValue(data.id, nextValue))
    self.attriCurValueText:SetAnchoredPositionXY(141, -21)
    self.attriCurValueText:SetSizeDeltaXY(95, 42)
  end
end

local function ShowEffect(self)
  if not self.active then
    return
  end
  self.effect:SetActive(false)
  self.effect:SetActive(true)
end

UIEquipPromoteBasicLineItem.OnCreate = OnCreate
UIEquipPromoteBasicLineItem.OnDestroy = OnDestroy
UIEquipPromoteBasicLineItem.ComponentDefine = ComponentDefine
UIEquipPromoteBasicLineItem.ComponentDestroy = ComponentDestroy
UIEquipPromoteBasicLineItem.DataDefine = DataDefine
UIEquipPromoteBasicLineItem.DataDestroy = DataDestroy
UIEquipPromoteBasicLineItem.OnEnable = OnEnable
UIEquipPromoteBasicLineItem.OnDisable = OnDisable
UIEquipPromoteBasicLineItem.SetData = SetData
UIEquipPromoteBasicLineItem.ShowEffect = ShowEffect
return UIEquipPromoteBasicLineItem
