local DecoStarDesc = BaseClass("DecoStarDesc", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local property_icon_path = "LayoutContent/PropertyIconRoot/PropertyIcon"
local accelerate_text_path = "LayoutContent/AccelerateText"
local add_value_path = "LayoutContent/AddValue"
local PROPERTY_ICON_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/"

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
  self.effectIcon = self:AddComponent(UIImage, property_icon_path)
  self.propNameText = self:AddComponent(UIText, accelerate_text_path)
  self.addPropText = self:AddComponent(UIText, add_value_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function DecoStarDesc:ReInit(param)
  local effectId = param.effectId
  local effectVal = param.effectValue
  local temp, temp1 = WorkerUtil.GetEffectText(effectId, effectVal, true)
  self.propNameText:SetText(temp)
  self.addPropText:SetText(temp1)
  self:RefreshPropertyIcon(effectId)
end

function DecoStarDesc:RefreshPropertyIcon(effectId)
  local effectIconName = GetTableData(TableName.LW_Effect_Number, effectId, "small_icon")
  if string.IsNullOrEmpty(effectIconName) then
    self.effectIcon:SetActive(false)
    return
  end
  self.effectIcon:SetActive(true)
  local path = PROPERTY_ICON_PATH .. effectIconName
  self.effectIcon:LoadSprite(path)
end

DecoStarDesc.OnCreate = OnCreate
DecoStarDesc.OnDestroy = OnDestroy
DecoStarDesc.OnEnable = OnEnable
DecoStarDesc.OnDisable = OnDisable
DecoStarDesc.ComponentDefine = ComponentDefine
DecoStarDesc.ComponentDestroy = ComponentDestroy
DecoStarDesc.DataDefine = DataDefine
DecoStarDesc.DataDestroy = DataDestroy
DecoStarDesc.OnAddListener = OnAddListener
DecoStarDesc.OnRemoveListener = OnRemoveListener
return DecoStarDesc
