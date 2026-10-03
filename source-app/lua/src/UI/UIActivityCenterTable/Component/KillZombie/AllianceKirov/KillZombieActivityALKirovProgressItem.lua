local base = UIBaseContainer
local KillZombieActivityALKirovProgressItem = BaseClass("KillZombieActivityALKirovProgressItem", base)
local progress_path = "Progress"

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
  self.progress = self:AddComponent(UISlider, progress_path)
end

local function ComponentDestroy(self)
  self.progress = nil
end

local function DataDefine(self)
  self.value = nil
end

local function DataDestroy(self)
  self.value = nil
end

local function RefreshProgress(self, value)
  if value then
    self.progress:SetValue(value)
  end
  self.value = value
end

KillZombieActivityALKirovProgressItem.OnCreate = OnCreate
KillZombieActivityALKirovProgressItem.OnDestroy = OnDestroy
KillZombieActivityALKirovProgressItem.OnEnable = OnEnable
KillZombieActivityALKirovProgressItem.OnDisable = OnDisable
KillZombieActivityALKirovProgressItem.ComponentDefine = ComponentDefine
KillZombieActivityALKirovProgressItem.ComponentDestroy = ComponentDestroy
KillZombieActivityALKirovProgressItem.DataDefine = DataDefine
KillZombieActivityALKirovProgressItem.DataDestroy = DataDestroy
KillZombieActivityALKirovProgressItem.RefreshProgress = RefreshProgress
return KillZombieActivityALKirovProgressItem
