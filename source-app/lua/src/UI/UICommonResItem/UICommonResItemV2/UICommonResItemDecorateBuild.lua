local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemDecorateBuild = BaseClass("UICommonResItemDecorateBuild", UICommonResItemBase)
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
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.bUuid)
  if buildData then
    local level = buildData.level
    if 0 < level then
      self:SetFlagText(string.format("Lv.%d", level))
      self:SetFlagActive(true)
    else
      self:SetFlagActive(false)
    end
  end
  self:SetItemIconImage(DataCenter.BuildManager:GetBuildIconPath(self.param.itemId, 1))
  self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(BuildingUtils.GetDecorateColor(self.param.itemId, true), false))
  local buildTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
  self:SetNameText(CS.GameEntry.Localization:GetString(buildTemp.name))
end

local function OnClick(self)
  local buildTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
  if buildTemp ~= nil then
    local param = {}
    param.baseBuildingId = buildTemp.id - buildTemp.id % BuildLevelCap
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
  end
end

UICommonResItemDecorateBuild.OnCreate = OnCreate
UICommonResItemDecorateBuild.OnDestroy = OnDestroy
UICommonResItemDecorateBuild.ComponentDefine = ComponentDefine
UICommonResItemDecorateBuild.ComponentDestroy = ComponentDestroy
UICommonResItemDecorateBuild.DataDefine = DataDefine
UICommonResItemDecorateBuild.DataDestroy = DataDestroy
UICommonResItemDecorateBuild.OnReInit = OnReInit
UICommonResItemDecorateBuild.OnClick = OnClick
return UICommonResItemDecorateBuild
