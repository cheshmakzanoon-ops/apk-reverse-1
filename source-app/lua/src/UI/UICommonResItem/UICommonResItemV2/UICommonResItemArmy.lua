local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemArmy = BaseClass("UICommonResItemArmy", UICommonResItemBase)
local base = UICommonResItemBase

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  self:SetFlagActive(false)
  if self.param.itemId then
    local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
    if army ~= nil then
      self:SetItemIconImage(string.format(LoadPath.SoldierIcons, army.icon))
      self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
      self:SetNameText(CS.GameEntry.Localization:GetString(army.name))
    end
  end
end

UICommonResItemArmy.OnCreate = OnCreate
UICommonResItemArmy.OnDestroy = OnDestroy
UICommonResItemArmy.ComponentDefine = ComponentDefine
UICommonResItemArmy.ComponentDestroy = ComponentDestroy
UICommonResItemArmy.DataDefine = DataDefine
UICommonResItemArmy.DataDestroy = DataDestroy
UICommonResItemArmy.OnReInit = OnReInit
return UICommonResItemArmy
