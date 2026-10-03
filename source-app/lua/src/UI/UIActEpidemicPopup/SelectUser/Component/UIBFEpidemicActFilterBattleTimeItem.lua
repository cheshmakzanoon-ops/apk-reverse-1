local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseFilterBattleTimeItem")
local UIBFEpidemicActFilterBattleTimeItem = BaseClass("UIBFEpidemicActFilterBattleTimeItem", base)

function UIBFEpidemicActFilterBattleTimeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicActPlayerListRefresh, self.OnGetPlayerList)
end

function UIBFEpidemicActFilterBattleTimeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicActPlayerListRefresh, self.OnGetPlayerList)
  base.OnRemoveListener(self)
end

return UIBFEpidemicActFilterBattleTimeItem
