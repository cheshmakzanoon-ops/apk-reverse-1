local UIEquipPromoteAdditionLineItem = BaseClass("UIEquipPromoteAdditionLineItem", UIBaseContainer)
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local unpromoteContentPath = "UnpromoteContent"
local unpromote_nameTextPath = "UnpromoteContent/NameText"
local unpromote_valueTextPath = "UnpromoteContent/CurValueText"
local unpromote_arrowIconPath = "UnpromoteContent/ArrowIcon"
local unpromote_nextValueTextPath = "UnpromoteContent/NextValueText"
local promotedContentPath = "PromotedContent"
local promoted_nameTextPath = "PromotedContent/NameText2"
local promoted_valueTextPath = "PromotedContent/ValueText2"
local lockContentPath = "LockContent"
local lock_nameTextPath = "LockContent/NameText3"
local lock_valueTextPath = "LockContent/ValueText3"

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
  self.bg = self:AddComponent(UIImage, "")
  self.unpromoteContent = self:AddComponent(UIBaseContainer, unpromoteContentPath)
  self.unpromoteNameText = self:AddComponent(UILWScienceDetailDesc, unpromote_nameTextPath)
  self.unpromoteValueText = self:AddComponent(UIText, unpromote_valueTextPath)
  self.unpromoteArrowIcon = self:AddComponent(UIImage, unpromote_arrowIconPath)
  self.unpromoteNextValueText = self:AddComponent(UIText, unpromote_nextValueTextPath)
  self.promotedContent = self:AddComponent(UIBaseContainer, promotedContentPath)
  self.promotedNameText = self:AddComponent(UILWScienceDetailDesc, promoted_nameTextPath)
  self.promotedValueText = self:AddComponent(UIText, promoted_valueTextPath)
  self.lockContent = self:AddComponent(UIBaseContainer, lockContentPath)
  self.lockNameText = self:AddComponent(UILWScienceDetailDesc, lock_nameTextPath)
  self.lockValueText = self:AddComponent(UIText, lock_valueTextPath)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.unpromoteContent = nil
  self.unpromoteNameText = nil
  self.unpromoteValueText = nil
  self.unpromoteArrowIcon = nil
  self.unpromoteNextValueText = nil
  self.promotedContent = nil
  self.promotedNameText = nil
  self.promotedValueText = nil
  self.lockContent = nil
  self.lockNameText = nil
  self.lockValueText = nil
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

local function RefreshShowData(self)
  local nameText, valueText, nextValueText
  if self.propertyData.needPromoteLv <= self.promoteLv then
    self.promotedContent:SetActive(true)
    self.unpromoteContent:SetActive(false)
    self.lockContent:SetActive(false)
    nameText = self.promotedNameText
    valueText = self.promotedValueText
  elseif self.propertyData.isPromoteAdd then
    self.promotedContent:SetActive(false)
    self.lockContent:SetActive(true)
    self.unpromoteContent:SetActive(false)
    nameText = self.lockNameText
    valueText = self.lockValueText
  else
    self.promotedContent:SetActive(false)
    self.lockContent:SetActive(false)
    self.unpromoteContent:SetActive(true)
    nameText = self.unpromoteNameText
    valueText = self.unpromoteValueText
    if self.propertyData.nextValue and self.propertyData.nextValue ~= self.propertyData.value then
      self.unpromoteNextValueText:SetActive(true)
      self.unpromoteArrowIcon:SetActive(true)
      nextValueText = self.unpromoteNextValueText
    else
      self.unpromoteNextValueText:SetActive(false)
      self.unpromoteArrowIcon:SetActive(false)
    end
  end
  if nameText then
    local propertyName = HeroUtils.GetHeroPropertyNameId(self.propertyData.id)
    
    local function ProcessDesc(desc)
      if self.propertyData.needPromoteLv > self.promoteLv and self.propertyData.isPromoteAdd then
        local modifiedText = string.gsub(desc, "<link=", "<u><link=")
        modifiedText = string.gsub(modifiedText, "</link>", "</link></u>")
        return modifiedText
      else
        local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#FFAC40"))
        modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
        return modifiedText
      end
    end
    
    local des = propertyName
    des = Localization:GetString(des)
    des = ProcessDesc(des)
    nameText:SetText(des)
  end
  if valueText then
    local formattedPropertyValueStr = HeroUtils.GetFormattedPropertyValue(self.propertyData.id, self.propertyData.value)
    valueText:SetText(formattedPropertyValueStr)
  end
  if nextValueText then
    local formattedPropertyValueStr = HeroUtils.GetFormattedPropertyValue(self.propertyData.id, self.propertyData.nextValue)
    nextValueText:SetText(formattedPropertyValueStr)
    if valueText then
      valueText.transform:Set_anchoredPosition(60.5 * CommonUtil.ArabicAutoMirrorFactor(), -1.43)
      valueText.transform:Set_sizeDelta(95, 42)
    end
  elseif valueText then
    valueText.transform:Set_anchoredPosition(183.5 * CommonUtil.ArabicAutoMirrorFactor(), -1.43)
    valueText.transform:Set_sizeDelta(175, 42)
  end
end

local function SetData(self, data, promoteLv)
  if not data then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.propertyData = data
  self.promoteLv = promoteLv
  RefreshShowData(self)
end

UIEquipPromoteAdditionLineItem.OnCreate = OnCreate
UIEquipPromoteAdditionLineItem.OnDestroy = OnDestroy
UIEquipPromoteAdditionLineItem.ComponentDefine = ComponentDefine
UIEquipPromoteAdditionLineItem.ComponentDestroy = ComponentDestroy
UIEquipPromoteAdditionLineItem.DataDefine = DataDefine
UIEquipPromoteAdditionLineItem.DataDestroy = DataDestroy
UIEquipPromoteAdditionLineItem.OnEnable = OnEnable
UIEquipPromoteAdditionLineItem.OnDisable = OnDisable
UIEquipPromoteAdditionLineItem.SetData = SetData
return UIEquipPromoteAdditionLineItem
