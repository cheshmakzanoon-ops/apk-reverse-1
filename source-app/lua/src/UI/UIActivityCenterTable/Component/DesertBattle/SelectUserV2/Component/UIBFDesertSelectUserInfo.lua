local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseSelectUserInfo")
local UIBFDesertSelectUserInfo = BaseClass("UIBFDesertSelectUserInfo", base)

function UIBFDesertSelectUserInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetDagonPlayerList, self.UpdateData)
end

function UIBFDesertSelectUserInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.UpdateData)
  base.OnRemoveListener(self)
end

return UIBFDesertSelectUserInfo
