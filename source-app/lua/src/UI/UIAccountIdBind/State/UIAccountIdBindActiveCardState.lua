local UIAccountIdBindSimpleState = require("UI.UIAccountIdBind.State.UIAccountIdBindSimpleState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindActiveCardState = BaseClass("UIAccountIdBindActiveCardState", UIAccountIdBindSimpleState)
local base = UIAccountIdBindSimpleState

function UIAccountIdBindActiveCardState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.ActiveCard, {
    localization = {
      titleStr = "id_account_ID6_desc_1",
      activeBtnStr = "id_account1_name"
    }
  })
end

function UIAccountIdBindActiveCardState:OnEnter()
  self.view:RefreshProgressBar(AccountScoreConst.AccountIdBindStage.Confirm, false)
  self.view:RefreshContent(AccountScoreConst.ComponentType.CardActive, self)
  base.OnEnter(self)
end

return UIAccountIdBindActiveCardState
