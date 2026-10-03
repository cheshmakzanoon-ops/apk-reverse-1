local LWSeasonServerBattleV8DetailItem = BaseClass("LWSeasonServerBattleV8DetailItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function LWSeasonServerBattleV8DetailItem:OnCreate()
  base.OnCreate(self)
end

function LWSeasonServerBattleV8DetailItem:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonServerBattleV8DetailItem:OnEnable()
  base.OnEnable(self)
end

function LWSeasonServerBattleV8DetailItem:OnDisable()
  base.OnDisable(self)
end

function LWSeasonServerBattleV8DetailItem:ReInit(index, dataConfig, dataServer)
end

function LWSeasonServerBattleV8DetailItem:Update1000MS()
end

return LWSeasonServerBattleV8DetailItem
