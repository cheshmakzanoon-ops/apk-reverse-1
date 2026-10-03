local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseSelectUserInfo")
local UIBFDsbDuelActSelectUserInfo = BaseClass("UIBFDsbDuelActSelectUserInfo", base)

function UIBFDsbDuelActSelectUserInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActPlayerListUpdate, self.UpdateData)
  self:AddUIListener(EventId.DsbDuelActTeamSelfApplySuccess, self.RefreshSelfApply)
end

function UIBFDsbDuelActSelectUserInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActPlayerListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.DsbDuelActTeamSelfApplySuccess, self.RefreshSelfApply)
  base.OnRemoveListener(self)
end

return UIBFDsbDuelActSelectUserInfo
