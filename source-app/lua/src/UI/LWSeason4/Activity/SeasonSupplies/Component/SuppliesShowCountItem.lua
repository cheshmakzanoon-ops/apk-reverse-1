local base = UIBaseContainer
local SuppliesShowCountItem = BaseClass("SuppliesShowCountItem", base)
local level_path = "levelDes"
local num_path = "num"
local finish_path = "finish"
local box_path = "levelDes/box"

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
  self.level = self:AddComponent(UIText, level_path)
  self.num = self:AddComponent(UIText, num_path)
  self.finish = self:AddComponent(UIBaseContainer, finish_path)
  self.box = self:AddComponent(UIBaseContainer, box_path)
end

local function ComponentDestroy(self)
  self.level = nil
  self.num = nil
  self.finish = nil
  self.box = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SuppliesShowCountItem:SetData(data, curValue)
  local condition = data.condition or 0
  local unlockNum = data.unlockNum or 0
  self.level:SetText(condition)
  self.num:SetText(unlockNum)
  self.finish:SetActive(curValue >= condition)
end

SuppliesShowCountItem.OnCreate = OnCreate
SuppliesShowCountItem.OnDestroy = OnDestroy
SuppliesShowCountItem.OnEnable = OnEnable
SuppliesShowCountItem.OnDisable = OnDisable
SuppliesShowCountItem.ComponentDefine = ComponentDefine
SuppliesShowCountItem.ComponentDestroy = ComponentDestroy
SuppliesShowCountItem.DataDefine = DataDefine
SuppliesShowCountItem.DataDestroy = DataDestroy
return SuppliesShowCountItem
