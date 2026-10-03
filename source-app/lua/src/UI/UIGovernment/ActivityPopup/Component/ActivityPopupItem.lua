local ActivityPopupItem = BaseClass("ActivityPopupItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ActivityPopupItem:OnCreate()
  base.OnCreate(self)
end

function ActivityPopupItem:OnDestroy()
  base.OnDestroy(self)
end

function ActivityPopupItem:OnEnable()
  base.OnEnable(self)
end

function ActivityPopupItem:OnDisable()
  base.OnDisable(self)
end

function ActivityPopupItem:ReInit(index, dataConfig, dataServer)
end

function ActivityPopupItem:Update1000MS()
end

return ActivityPopupItem
