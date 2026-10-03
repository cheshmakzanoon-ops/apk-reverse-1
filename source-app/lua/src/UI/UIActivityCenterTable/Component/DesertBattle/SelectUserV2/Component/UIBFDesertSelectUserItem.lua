local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseSelectUserItem")
local UIBFDesertSelectUserItem = BaseClass("UIBFDesertSelectUserItem", base)

function UIBFDesertSelectUserItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetDagonPlayerList, self.UpdateData)
end

function UIBFDesertSelectUserItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.UpdateData)
  base.OnRemoveListener(self)
end

return UIBFDesertSelectUserItem
