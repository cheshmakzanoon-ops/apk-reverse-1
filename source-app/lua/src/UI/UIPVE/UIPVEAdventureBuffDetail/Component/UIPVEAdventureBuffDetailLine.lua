local UIPVEAdventureBuffDetailLine = BaseClass("UIPVEAdventureBuffDetailLine", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
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
  self.bg_image = self:AddComponent(UIImage, this_path)
  self.left_text = self:AddComponent(UIText, left_path)
  self.right_text = self:AddComponent(UIText, right_path)
end

local function ComponentDestroy(self)
  self.bg_image = nil
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

local function SetData(self, data, index)
  self.bg_image:SetAlpha(index % 2 == 1 and 1 or 0)
  if data then
    local desc = GetTableData(TableName.EffectNumDesc, data.buff, "des")
    local valStr = CommonUtil.GetValueWithLocalType(data.val, data.localType)
    self.left_text:SetLocalText(desc)
    self.right_text:SetText(valStr)
  else
    self.left_text:SetText("")
    self.right_text:SetText("")
  end
end

UIPVEAdventureBuffDetailLine.OnCreate = OnCreate
UIPVEAdventureBuffDetailLine.OnDestroy = OnDestroy
UIPVEAdventureBuffDetailLine.ComponentDefine = ComponentDefine
UIPVEAdventureBuffDetailLine.ComponentDestroy = ComponentDestroy
UIPVEAdventureBuffDetailLine.DataDefine = DataDefine
UIPVEAdventureBuffDetailLine.DataDestroy = DataDestroy
UIPVEAdventureBuffDetailLine.OnEnable = OnEnable
UIPVEAdventureBuffDetailLine.OnDisable = OnDisable
UIPVEAdventureBuffDetailLine.OnAddListener = OnAddListener
UIPVEAdventureBuffDetailLine.OnRemoveListener = OnRemoveListener
UIPVEAdventureBuffDetailLine.SetData = SetData
return UIPVEAdventureBuffDetailLine
