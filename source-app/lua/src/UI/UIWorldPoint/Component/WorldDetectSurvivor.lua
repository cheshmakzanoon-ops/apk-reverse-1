local base = UIBaseContainer
local WorldDetectSurvivor = BaseClass("WorldDetectSurvivor", base)
local animator_path = ""
local unfrozen_path = "BuildInfo/content/description"

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
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.unfrozen = self:AddComponent(UIText, unfrozen_path)
end

local function ComponentDestroy(self)
  self.animator = nil
  self.unfrozen = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function WorldDetectSurvivor:RefreshData(data)
  self.unfrozen:SetText(data.detailInfo)
end

WorldDetectSurvivor.OnCreate = OnCreate
WorldDetectSurvivor.OnDestroy = OnDestroy
WorldDetectSurvivor.OnEnable = OnEnable
WorldDetectSurvivor.OnDisable = OnDisable
WorldDetectSurvivor.ComponentDefine = ComponentDefine
WorldDetectSurvivor.ComponentDestroy = ComponentDestroy
WorldDetectSurvivor.DataDefine = DataDefine
WorldDetectSurvivor.DataDestroy = DataDestroy
return WorldDetectSurvivor
