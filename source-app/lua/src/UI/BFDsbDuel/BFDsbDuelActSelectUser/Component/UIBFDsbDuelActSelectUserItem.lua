local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseSelectUserItem")
local UIBFDsbDuelActSelectUserItem = BaseClass("UIBFDsbDuelActSelectUserItem", base)

function UIBFDsbDuelActSelectUserItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActPlayerListUpdate, self.UpdateData)
end

function UIBFDsbDuelActSelectUserItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActPlayerListUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

return UIBFDsbDuelActSelectUserItem
