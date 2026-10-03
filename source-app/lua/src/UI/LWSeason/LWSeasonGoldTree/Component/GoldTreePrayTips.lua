local base = UIBaseContainer
local GoldTreePrayTips = BaseClass("GoldTreePrayTips", base)
local btnBack_path = "BtnClose"

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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
end

local function ComponentDestroy(self)
  self.btnBack = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

GoldTreePrayTips.OnCreate = OnCreate
GoldTreePrayTips.OnDestroy = OnDestroy
GoldTreePrayTips.OnEnable = OnEnable
GoldTreePrayTips.OnDisable = OnDisable
GoldTreePrayTips.ComponentDefine = ComponentDefine
GoldTreePrayTips.ComponentDestroy = ComponentDestroy
GoldTreePrayTips.DataDefine = DataDefine
GoldTreePrayTips.DataDestroy = DataDestroy
return GoldTreePrayTips
