local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseFilterBattleTimeItem")
local UIBFDsbDuelActFilterBattleTimeItem = BaseClass("UIBFDsbDuelActFilterBattleTimeItem", base)

function UIBFDsbDuelActFilterBattleTimeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActPlayerListUpdate, self.OnGetPlayerList)
end

function UIBFDsbDuelActFilterBattleTimeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActPlayerListUpdate, self.OnGetPlayerList)
  base.OnRemoveListener(self)
end

return UIBFDsbDuelActFilterBattleTimeItem
