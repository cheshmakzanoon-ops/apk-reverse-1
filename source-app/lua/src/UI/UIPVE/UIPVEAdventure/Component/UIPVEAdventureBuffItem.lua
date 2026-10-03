local UIPVEAdventureBuffItem = BaseClass("UIPVEAdventureBuffItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local left_path = "Left"
local right_path = "Right"

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
  self.left_text = self:AddComponent(UIText, left_path)
  self.right_text = self:AddComponent(UIText, right_path)
end

local function ComponentDestroy(self)
  self.left_text = nil
  self.right_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  local desc = GetTableData(TableName.EffectNumDesc, data.buff, "des")
  local valStr = CommonUtil.GetValueWithLocalType(data.val, data.localType)
  self.left_text:SetLocalText(desc)
  self.right_text:SetText(valStr)
end

UIPVEAdventureBuffItem.OnCreate = OnCreate
UIPVEAdventureBuffItem.OnDestroy = OnDestroy
UIPVEAdventureBuffItem.ComponentDefine = ComponentDefine
UIPVEAdventureBuffItem.ComponentDestroy = ComponentDestroy
UIPVEAdventureBuffItem.DataDefine = DataDefine
UIPVEAdventureBuffItem.DataDestroy = DataDestroy
UIPVEAdventureBuffItem.OnEnable = OnEnable
UIPVEAdventureBuffItem.OnDisable = OnDisable
UIPVEAdventureBuffItem.OnAddListener = OnAddListener
UIPVEAdventureBuffItem.OnRemoveListener = OnRemoveListener
UIPVEAdventureBuffItem.SetData = SetData
return UIPVEAdventureBuffItem
