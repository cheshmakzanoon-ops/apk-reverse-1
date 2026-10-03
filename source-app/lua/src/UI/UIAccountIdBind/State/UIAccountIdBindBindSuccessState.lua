local UIAccountIdBindBindPlayerInfoBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindBindPlayerInfoBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindBindSuccessState = BaseClass("UIAccountIdBindBindSuccessState", UIAccountIdBindBindPlayerInfoBaseState)
local base = UIAccountIdBindBindPlayerInfoBaseState

function UIAccountIdBindBindSuccessState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.BindSuccess, {
    componentType = AccountScoreConst.ComponentType.PersonalInfo,
    localization = {
      titleStr = "id_account_ID9_title_1",
      contentStr = "id_account_ID9_desc_2",
      confirmBtnStr = "id_account_ID_btn_confirm",
      noteStr = "id_account_ID9_btn_3"
    }
  })
end

function UIAccountIdBindBindSuccessState:OnClickRight()
  self.view:SwitchToNextState()
end

return UIAccountIdBindBindSuccessState
