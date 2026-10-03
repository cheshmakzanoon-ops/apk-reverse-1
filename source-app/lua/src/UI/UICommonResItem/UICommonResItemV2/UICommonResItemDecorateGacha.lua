local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemDecorateGacha = BaseClass("UICommonResItemDecorateGacha", UICommonResItemBase)
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
  self:SetItemIconImage(DataCenter.BuildManager:GetBuildIconPath(self.param.itemId, 1))
  self:SetItemQualityImage(HeroUtils.GetQualityIconPath(BuildingUtils.GetDecorateColor(self.param.itemId, true), false))
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

UICommonResItemDecorateGacha.OnCreate = OnCreate
UICommonResItemDecorateGacha.OnDestroy = OnDestroy
UICommonResItemDecorateGacha.ComponentDefine = ComponentDefine
UICommonResItemDecorateGacha.ComponentDestroy = ComponentDestroy
UICommonResItemDecorateGacha.DataDefine = DataDefine
UICommonResItemDecorateGacha.DataDestroy = DataDestroy
UICommonResItemDecorateGacha.OnReInit = OnReInit
UICommonResItemDecorateGacha.OnClick = OnClick
return UICommonResItemDecorateGacha
