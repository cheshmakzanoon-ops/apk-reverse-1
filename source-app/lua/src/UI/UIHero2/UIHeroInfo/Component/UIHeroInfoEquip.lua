local UIHeroInfoEquip = BaseClass("UIHeroInfoEquip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
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

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function InitData(self, heroUuid)
end

UIHeroInfoEquip.OnCreate = OnCreate
UIHeroInfoEquip.OnDestroy = OnDestroy
UIHeroInfoEquip.OnEnable = OnEnable
UIHeroInfoEquip.OnDisable = OnDisable
UIHeroInfoEquip.ComponentDefine = ComponentDefine
UIHeroInfoEquip.ComponentDestroy = ComponentDestroy
UIHeroInfoEquip.OnAddListener = OnAddListener
UIHeroInfoEquip.OnRemoveListener = OnRemoveListener
UIHeroInfoEquip.InitData = InitData
return UIHeroInfoEquip
