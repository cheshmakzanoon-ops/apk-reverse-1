local UIEquipDetailPropertyLineItem = BaseClass("UIEquipDetailPropertyLineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local upgradeContentPath = "UpgradeContent"
local upgrade_unlockContentPath = "UpgradeContent/UnlockContent"
local upgrade_unlockContent_nameTextPath = "UpgradeContent/UnlockContent/Content/NameText"
local upgrade_unlockContent_valueTextPath = "UpgradeContent/UnlockContent/Content/ValueText"
local upgarde_unlockContent_unlockLevelTextPath = "UpgradeContent/UnlockContent/UnlockLevelBg/UnlockLevelText"
local upgrade_unlockContent_effectPath = "UpgradeContent/UnlockContent/Eff_ui_hero_xiangqing_qianghua_shuaguang"
local upgrade_lockContentPath = "UpgradeContent/LockContent"
local upgrade_lockContent_nameTextPath = "UpgradeContent/LockContent/Content/NameText2"
local upgrade_lockContent_valueTextPath = "UpgradeContent/LockContent/Content/ValueText2"
local upgrade_lockContent_unlockLevelTextPath = "UpgradeContent/LockContent/UnlockLevelBg/UnlockLevelText2"
local promoteContentPath = "PromoteContent"
local promote_unpromoteContentPath = "PromoteContent/UnpromoteContent"
local promote_unpromoteContent_nameTextPath = "PromoteContent/UnpromoteContent/NameText3"
local promote_unpromoteContent_valueTextPath = "PromoteContent/UnpromoteContent/ValueText3"
local promote_promotedContentPath = "PromoteContent/PromotedContent"
local promote_promotedContent_nameTextPath = "PromoteContent/PromotedContent/NameText4"
local promote_promotedContent_valueTextPath = "PromoteContent/PromotedContent/ValueText4"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.propertyData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.upgradeContent = self:AddComponent(UIBaseContainer, upgradeContentPath)
  self.upgrade_unlockContent = self:AddComponent(UIBaseContainer, upgrade_unlockContentPath)
  self.upgrade_unlockContent_nameText = self:AddComponent(UILWScienceDetailDesc, upgrade_unlockContent_nameTextPath)
  self.upgrade_unlockContent_valueText = self:AddComponent(UIText, upgrade_unlockContent_valueTextPath)
  self.upgarde_unlockContent_unlockLevelText = self:AddComponent(UIText, upgarde_unlockContent_unlockLevelTextPath)
  self.upgrade_unlockContent_effect = self:AddComponent(UIBaseContainer, upgrade_unlockContent_effectPath)
  self.upgrade_unlockContent_effect:SetActive(false)
  self.upgrade_lockContent = self:AddComponent(UIBaseContainer, upgrade_lockContentPath)
  self.upgrade_lockContent_nameText = self:AddComponent(UILWScienceDetailDesc, upgrade_lockContent_nameTextPath)
  self.upgrade_lockContent_valueText = self:AddComponent(UIText, upgrade_lockContent_valueTextPath)
  self.upgarde_lockContent_unlockLevelText = self:AddComponent(UIText, upgrade_lockContent_unlockLevelTextPath)
  self.promoteContent = self:AddComponent(UIBaseContainer, promoteContentPath)
  self.promote_unpromoteContent = self:AddComponent(UIBaseContainer, promote_unpromoteContentPath)
  self.promote_unpromoteContent_nameText = self:AddComponent(UILWScienceDetailDesc, promote_unpromoteContent_nameTextPath)
  self.promote_unpromoteContent_valueText = self:AddComponent(UIText, promote_unpromoteContent_valueTextPath)
  self.promote_promotedContent = self:AddComponent(UIBaseContainer, promote_promotedContentPath)
  self.promote_promotedContent_nameText = self:AddComponent(UILWScienceDetailDesc, promote_promotedContent_nameTextPath)
  self.promote_promotedContent_valueText = self:AddComponent(UIText, promote_promotedContent_valueTextPath)
end

local function ComponentDestroy(self)
  self.upgradeContent = nil
  self.upgrade_unlockContent = nil
  self.upgrade_unlockContent_nameText = nil
  self.upgrade_unlockContent_valueText = nil
  self.upgarde_unlockContent_unlockLevelText = nil
  self.upgrade_unlockContent_effect = nil
  self.upgrade_lockContent = nil
  self.upgrade_lockContent_nameText = nil
  self.upgrade_lockContent_valueText = nil
  self.upgarde_lockContent_unlockLevelText = nil
  self.promoteContent = nil
  self.promote_unpromoteContent = nil
  self.promote_unpromoteContent_nameText = nil
  self.promote_unpromoteContent_valueText = nil
  self.promote_promotedContent = nil
  self.promote_promotedContent_nameText = nil
  self.promote_promotedContent_valueText = nil
end

local function SetUpradeData(self, data, level)
  if not data then
    return
  end
  self.upgradeContent:SetActive(true)
  self.promoteContent:SetActive(false)
  local nameText, valueText, unlockLevelText
  local isUnlock = level >= data.unlockLevel
  if isUnlock then
    nameText = self.upgrade_unlockContent_nameText
    valueText = self.upgrade_unlockContent_valueText
    unlockLevelText = self.upgarde_unlockContent_unlockLevelText
    self.upgrade_unlockContent:SetActive(true)
    self.upgrade_lockContent:SetActive(false)
  else
    nameText = self.upgrade_lockContent_nameText
    valueText = self.upgrade_lockContent_valueText
    unlockLevelText = self.upgarde_lockContent_unlockLevelText
    self.upgrade_unlockContent:SetActive(false)
    self.upgrade_lockContent:SetActive(true)
  end
  if nameText ~= nil then
    local propertyName = HeroUtils.GetHeroPropertyNameId(data.id)
    
    local function ProcessDesc(desc)
      if isUnlock then
        local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#FFAC40"))
        modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
        return modifiedText
      else
        local modifiedText = string.gsub(desc, "<link=", "<u><link=")
        modifiedText = string.gsub(modifiedText, "</link>", "</link></u>")
        return modifiedText
      end
    end
    
    local des = propertyName
    des = Localization:GetString(des)
    des = ProcessDesc(des)
    nameText:SetText(des)
  end
  if valueText ~= nil then
    local formattedPropertyValueStr = HeroUtils.GetFormattedPropertyValue(data.id, data.value)
    valueText:SetText(formattedPropertyValueStr)
  end
  if unlockLevelText ~= nil then
    unlockLevelText:SetText(data.unlockLevel)
  end
end

local function SetPromoteData(self, data, promoteLevel)
  if not data then
    return
  end
  self.upgradeContent:SetActive(false)
  self.promoteContent:SetActive(true)
  local nameText, valueText
  local needPromoteLv = 0
  if data.needPromoteLv then
    needPromoteLv = data.needPromoteLv
  end
  local isPromoted = promoteLevel >= needPromoteLv
  if isPromoted then
    nameText = self.promote_promotedContent_nameText
    valueText = self.promote_promotedContent_valueText
    self.promote_promotedContent:SetActive(true)
    self.promote_unpromoteContent:SetActive(false)
  else
    nameText = self.promote_unpromoteContent_nameText
    valueText = self.promote_unpromoteContent_valueText
    self.promote_promotedContent:SetActive(false)
    self.promote_unpromoteContent:SetActive(true)
  end
  if nameText ~= nil then
    local propertyName = HeroUtils.GetHeroPropertyNameId(data.id)
    
    local function ProcessDesc(desc)
      local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#FFAC40"))
      modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
      return modifiedText
    end
    
    local des = propertyName
    des = Localization:GetString(des)
    des = ProcessDesc(des)
    nameText:SetText(des)
  end
  if valueText ~= nil then
    local formattedPropertyValueStr = HeroUtils.GetFormattedPropertyValue(data.id, data.value)
    valueText:SetText(formattedPropertyValueStr)
  end
end

UIEquipDetailPropertyLineItem.OnCreate = OnCreate
UIEquipDetailPropertyLineItem.OnDestroy = OnDestroy
UIEquipDetailPropertyLineItem.OnEnable = OnEnable
UIEquipDetailPropertyLineItem.OnDisable = OnDisable
UIEquipDetailPropertyLineItem.DataDefine = DataDefine
UIEquipDetailPropertyLineItem.DataDestroy = DataDestroy
UIEquipDetailPropertyLineItem.ComponentDefine = ComponentDefine
UIEquipDetailPropertyLineItem.ComponentDestroy = ComponentDestroy
UIEquipDetailPropertyLineItem.SetUpradeData = SetUpradeData
UIEquipDetailPropertyLineItem.SetPromoteData = SetPromoteData
return UIEquipDetailPropertyLineItem
