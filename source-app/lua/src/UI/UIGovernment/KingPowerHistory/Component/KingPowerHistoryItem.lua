local KingPowerHistoryItem = BaseClass("KingPowerHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function KingPowerHistoryItem:OnCreate()
  base.OnCreate(self)
end

function KingPowerHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function KingPowerHistoryItem:OnEnable()
  base.OnEnable(self)
end

function KingPowerHistoryItem:OnDisable()
  base.OnDisable(self)
end

function KingPowerHistoryItem:ReInit(index, dataConfig, dataServer)
end

function KingPowerHistoryItem:Update1000MS()
end

return KingPowerHistoryItem
