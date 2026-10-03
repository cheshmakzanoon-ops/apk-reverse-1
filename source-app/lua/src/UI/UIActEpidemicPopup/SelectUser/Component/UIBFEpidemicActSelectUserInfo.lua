local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseSelectUserInfo")
local UIBFEpidemicActSelectUserInfo = BaseClass("UIBFEpidemicActSelectUserInfo", base)

function UIBFEpidemicActSelectUserInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateData)
  self:AddUIListener(EventId.EpidemicActPlayerApplyRefresh, self.RefreshSelfApply)
end

function UIBFEpidemicActSelectUserInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.EpidemicActPlayerApplyRefresh, self.RefreshSelfApply)
  base.OnRemoveListener(self)
end

return UIBFEpidemicActSelectUserInfo
