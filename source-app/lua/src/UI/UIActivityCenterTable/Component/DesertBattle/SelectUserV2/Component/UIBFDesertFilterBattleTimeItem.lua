local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseFilterBattleTimeItem")
local UIBFDesertFilterBattleTimeItem = BaseClass("UIBFDesertFilterBattleTimeItem", base)

function UIBFDesertFilterBattleTimeItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetDagonPlayerList, self.OnGetPlayerList)
end

function UIBFDesertFilterBattleTimeItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.OnGetPlayerList)
  base.OnRemoveListener(self)
end

return UIBFDesertFilterBattleTimeItem
