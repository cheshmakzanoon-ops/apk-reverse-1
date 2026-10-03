local UIBFDsbDuelBattleBuildDetailItem = BaseClass("UIBFDsbDuelBattleBuildDetailItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelBattleBuildDetailItem:OnCreate()
  base.OnCreate(self)
end

function UIBFDsbDuelBattleBuildDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelBattleBuildDetailItem:OnEnable()
  base.OnEnable(self)
end

function UIBFDsbDuelBattleBuildDetailItem:OnDisable()
  base.OnDisable(self)
end

function UIBFDsbDuelBattleBuildDetailItem:ReInit(index, dataConfig, dataServer)
end

function UIBFDsbDuelBattleBuildDetailItem:Update1000MS()
end

return UIBFDsbDuelBattleBuildDetailItem
