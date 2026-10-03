local BountyHunterBossLogCardComponent = BaseClass("BountyHunterBossLogCardComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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

function BountyHunterBossLogCardComponent:SetData(data)
  self.data = data
end

BountyHunterBossLogCardComponent.OnCreate = OnCreate
BountyHunterBossLogCardComponent.OnDestroy = OnDestroy
BountyHunterBossLogCardComponent.OnEnable = OnEnable
BountyHunterBossLogCardComponent.OnDisable = OnDisable
BountyHunterBossLogCardComponent.ComponentDefine = ComponentDefine
BountyHunterBossLogCardComponent.ComponentDestroy = ComponentDestroy
BountyHunterBossLogCardComponent.DataDefine = DataDefine
BountyHunterBossLogCardComponent.DataDestroy = DataDestroy
BountyHunterBossLogCardComponent.OnAddListener = OnAddListener
BountyHunterBossLogCardComponent.OnRemoveListener = OnRemoveListener
return BountyHunterBossLogCardComponent
