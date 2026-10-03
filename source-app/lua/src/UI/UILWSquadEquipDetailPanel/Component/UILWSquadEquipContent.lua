local UILWSquadEquipContent = BaseClass("UILWSquadEquipContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BagItem = require("UI.UILWBag.UILWBagMain.Component.UILWBagItem")
local LineItem = require("UI.UILWSquadEquipDetailPanel.Component.LineItem")
local empty_content_path = "EmptyContent"
local equipItem_path = "EquipItem"
local line_container_path = "Effects/Viewport/EffectsContent"
local line_template_path = "EffectLine"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.emptyContent = self:AddComponent(UIBaseContainer, empty_content_path)
  self.equipItem = self:AddComponent(BagItem, equipItem_path)
  self.lineTemplate = self:AddComponent(LineItem, line_template_path)
  self.lineContainer = self:AddComponent(UIBaseContainer, line_container_path)
  self.lineTemplate:SetActive(false)
  self.lineTemplateObj = self.lineTemplate.gameObject
  self.lineTemplateObj:GameObjectCreatePool()
end

local function DataDefine(self)
end

local function ClearAllLines(self)
  self.lineContainer:RemoveComponents(LineItem)
  if not IsNull(self.lineTemplateObj) then
    self.lineTemplateObj:GameObjectRecycleAll()
  end
end

local function OnDestroy(self)
  ClearAllLines(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.emptyContent = nil
  self.equipItem = nil
  self.lineTemplate = nil
  self.lineTemplateObj = nil
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
    ClearAllLines(self)
  else
    self.emptyContent:SetActive(false)
    local showData = {}
    showData.data = self.equipData
    showData.index = 1
    showData.type = BagItemType.CommonEquip
    showData.showRedPoint = false
    self.equipItem:SetData(showData)
    self.equipItem:SetActive(true)
    ClearAllLines(self)
    local effects = self.equipData:GetEffects()
    if not table.IsNullOrEmpty(effects) then
      for key, value in pairs(effects) do
        local lineItemIns = self.lineTemplateObj:GameObjectSpawn(self.lineContainer.transform)
        local keyStr = tostring(key)
        lineItemIns.name = keyStr
        lineItemIns:SetActive(true)
        local lineComp = self.lineContainer:AddComponent(LineItem, keyStr)
        local effectName = DataCenter.EffectNumberTemplateManager:GetEffectNumberName(key)
        local formattedEffectValueStr = HeroUtils.GetFormattedPropertyValue(key, value)
        formattedEffectValueStr = string.format("<color=#099b4a>%s</color>", formattedEffectValueStr)
        lineComp:SetData(effectName, formattedEffectValueStr)
      end
    end
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
