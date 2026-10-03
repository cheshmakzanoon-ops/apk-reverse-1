local ServerBattleActivityPopupItem = BaseClass("ServerBattleActivityPopupItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function ServerBattleActivityPopupItem:OnCreate()
  base.OnCreate(self)
end

function ServerBattleActivityPopupItem:OnDestroy()
  base.OnDestroy(self)
end

function ServerBattleActivityPopupItem:OnEnable()
  base.OnEnable(self)
end

function ServerBattleActivityPopupItem:OnDisable()
  base.OnDisable(self)
end

function ServerBattleActivityPopupItem:ReInit(index, dataConfig, dataServer)
end

function ServerBattleActivityPopupItem:Update1000MS()
end

return ServerBattleActivityPopupItem
