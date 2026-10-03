local base = UIBaseContainer
local SuppliesShowCountItem = BaseClass("SuppliesShowCountItem", base)
local level_path = "levelDes"
local num_path = "num"

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
end

local function ComponentDestroy(self)
  self.level = nil
  self.num = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SuppliesShowCountItem:ReInit(index, data)
  self.level:SetLocalText("season_s2_ice_supplies_3", data.level)
  self.num:SetText(data.count)
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
