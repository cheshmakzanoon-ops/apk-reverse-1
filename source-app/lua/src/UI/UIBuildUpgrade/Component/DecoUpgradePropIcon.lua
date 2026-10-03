local DecoUpgradePropIcon = BaseClass("DecoUpgradePropIcon", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local PROPERTY_ICON_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/"
local property_icon_path = "Root/PropertyIcon"
local add_value_path = "Root/AddValue"

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
  self.addValText = self:AddComponent(UIText, add_value_path)
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

function DecoUpgradePropIcon:ReInit(param)
  local effectId = param.effectId
  local changeVal = math.floor(param.changeNumVal * 10000 + 0.5) / 10000
  local temp, temp1 = WorkerUtil.GetEffectText(effectId, changeVal, true)
  self.addValText:SetText(string.format("%s", temp1))
  local effectIconName = GetTableData(TableName.LW_Effect_Number, effectId, "small_icon")
  if string.IsNullOrEmpty(effectIconName) then
    self.effectIcon:SetActive(false)
    return
  end
  self.effectIcon:SetActive(true)
  local path = PROPERTY_ICON_PATH .. effectIconName
  self.effectIcon:LoadSprite(path)
end

DecoUpgradePropIcon.OnCreate = OnCreate
DecoUpgradePropIcon.OnDestroy = OnDestroy
DecoUpgradePropIcon.OnEnable = OnEnable
DecoUpgradePropIcon.OnDisable = OnDisable
DecoUpgradePropIcon.ComponentDefine = ComponentDefine
DecoUpgradePropIcon.ComponentDestroy = ComponentDestroy
DecoUpgradePropIcon.DataDefine = DataDefine
DecoUpgradePropIcon.DataDestroy = DataDestroy
DecoUpgradePropIcon.OnAddListener = OnAddListener
DecoUpgradePropIcon.OnRemoveListener = OnRemoveListener
return DecoUpgradePropIcon
