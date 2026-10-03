local AllyDrillMvpItem = BaseClass("AllyDrillMvpItem", UIBaseContainer)
local base = UIBaseContainer

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
  self.damageTxt1 = self:AddComponent(UIText, "backmark/damageTxt1")
  self.multiTxt1 = self:AddComponent(UIText, "backmark/multiTxt1")
  self.checkmark = self:AddComponent(UIBaseComponent, "checkmark")
  self.damageTxt2 = self:AddComponent(UIText, "checkmark/damageTxt2")
  self.multiTxt2 = self:AddComponent(UIText, "checkmark/multiTxt2")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, data, isCheck)
  self.checkmark:SetActive(isCheck)
  local min = string.GetFormattedStr2(data.min)
  local max = data.max and string.GetFormattedStr2(data.max) or "..."
  if isCheck then
    self.damageTxt2:SetText(min .. "~" .. max)
    self.multiTxt2:SetText("x" .. data.bonus)
  else
    self.damageTxt1:SetText(min .. "~" .. max)
    self.multiTxt1:SetText("x" .. data.bonus)
  end
end

AllyDrillMvpItem.OnCreate = OnCreate
AllyDrillMvpItem.OnDestroy = OnDestroy
AllyDrillMvpItem.ComponentDefine = ComponentDefine
AllyDrillMvpItem.ComponentDestroy = ComponentDestroy
AllyDrillMvpItem.DataDefine = DataDefine
AllyDrillMvpItem.DataDestroy = DataDestroy
AllyDrillMvpItem.SetData = SetData
return AllyDrillMvpItem
