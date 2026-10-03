local UIAccountIdBindSimpleState = require("UI.UIAccountIdBind.State.UIAccountIdBindSimpleState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindSwitchLogInState = BaseClass("UIAccountIdBindSwitchLogInState", UIAccountIdBindSimpleState)
local base = UIAccountIdBindSimpleState

function UIAccountIdBindSwitchLogInState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.SignIn, {
    localization = {
      titleStr = "id_account_ID19_title_1",
      contentStr = "id_account_ID19_desc_2",
      signUpBtnStr = "id_account_ID_desc_login"
    }
  })
end

function UIAccountIdBindSwitchLogInState:OnEnter()
  self.view:RefreshProgressBar(AccountScoreConst.AccountIdBindStage.Mail, false)
  self.view:RefreshContent(AccountScoreConst.ComponentType.SwitchLogIn, self)
  base.OnEnter(self)
end

return UIAccountIdBindSwitchLogInState
