local base = require("UI.BattleFieldBase.SelectUser.Component.UIBFBaseSelectUserItem")
local UIBFEpidemicActSelectUserItem = BaseClass("UIBFEpidemicActSelectUserItem", base)

function UIBFEpidemicActSelectUserItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateData)
  self:AddUIListener(EventId.EpidemicActPlayerApplyRefresh, self.RefreshMyApply)
end

function UIBFEpidemicActSelectUserItem:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.EpidemicActPlayerApplyRefresh, self.RefreshMyApply)
  base.OnRemoveListener(self)
end

function UIBFEpidemicActSelectUserItem:RefreshMyApply()
  if self.selfRank == self.rank then
    self:FocusTo(LuaEntry.Player:GetUid())
  end
end

return UIBFEpidemicActSelectUserItem
