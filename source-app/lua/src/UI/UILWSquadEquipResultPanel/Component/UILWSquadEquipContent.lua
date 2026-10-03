local UILWSquadEquipContent = BaseClass("UILWSquadEquipContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BagItem = require("UI.UILWBag.UILWBagMain.Component.UILWBagItem")
local empty_content_path = "EmptyContent"
local effect_name_text_path = "EffectNameText"
local effect_value_text_path = "EffectValueText"
local equipItem_path = "EquipItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.emptyContent = self:AddComponent(UIBaseContainer, empty_content_path)
  self.effectNameText = self:AddComponent(UIText, effect_name_text_path)
  self.effectValueText = self:AddComponent(UIText, effect_value_text_path)
  self.equipItem = self:AddComponent(BagItem, equipItem_path)
end

local function DataDefine(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.emptyContent = nil
  self.effectNameText = nil
  self.effectValueText = nil
  self.equipItem = nil
end

local function DataDestroy(self)
  self.index = nil
  self.tabData = nil
  self.selected = nil
end

local function SetData(self, equipData)
  self.equipData = equipData
  if not self.equipData then
    self.emptyContent:SetActive(true)
    self.equipItem:SetActive(false)
    self.effectNameText:SetText("")
    self.effectValueText:SetText("")
  else
    self.emptyContent:SetActive(false)
    local showData = {}
    showData.data = self.equipData
    showData.index = 1
    showData.type = BagItemType.CommonEquip
    showData.showRedPoint = false
    self.equipItem:SetData(showData)
    self.equipItem:SetActive(true)
    local effects = self.equipData:GetEffects()
    local effectNumber, effectValue
    if not table.IsNullOrEmpty(effects) then
      for key, value in pairs(effects) do
        effectNumber = key
        effectValue = value
        break
      end
    end
    if not effectNumber then
      self.effectNameText:SetText("")
      self.effectValueText:SetText("")
      return
    end
    local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(effectNumber)
    self.effectNameText:SetText(effectName)
    local formattedEffectValueStr = HeroUtils.GetFormattedPropertyValue(effectNumber, effectValue)
    formattedEffectValueStr = string.format("<color=#099b4a>%s</color>", formattedEffectValueStr)
    self.effectValueText:SetText(formattedEffectValueStr)
  end
end

UILWSquadEquipContent.OnCreate = OnCreate
UILWSquadEquipContent.OnDestroy = OnDestroy
UILWSquadEquipContent.ComponentDefine = ComponentDefine
UILWSquadEquipContent.ComponentDestroy = ComponentDestroy
UILWSquadEquipContent.DataDefine = DataDefine
UILWSquadEquipContent.DataDestroy = DataDestroy
UILWSquadEquipContent.SetData = SetData
return UILWSquadEquipContent
