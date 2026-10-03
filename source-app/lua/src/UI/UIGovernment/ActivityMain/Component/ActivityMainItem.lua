local ActivityMainItem = BaseClass("ActivityMainItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ActivityMainItem:OnCreate()
  base.OnCreate(self)
end

function ActivityMainItem:OnDestroy()
  base.OnDestroy(self)
end

function ActivityMainItem:OnEnable()
  base.OnEnable(self)
end

function ActivityMainItem:OnDisable()
  base.OnDisable(self)
end

function ActivityMainItem:ReInit(index, dataConfig, dataServer)
end

function ActivityMainItem:Update1000MS()
end

return ActivityMainItem
