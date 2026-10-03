local UIAccountIdBindBindPlayerInfoBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindBindPlayerInfoBaseState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindBindPlayerInfoState = BaseClass("UIAccountIdBindBindPlayerInfoState", UIAccountIdBindBindPlayerInfoBaseState)
local base = UIAccountIdBindBindPlayerInfoBaseState

function UIAccountIdBindBindPlayerInfoState:__init(view)
  base.__init(self, view, AccountScoreConst.ViewState.BindPlayerInfo, {
    componentType = AccountScoreConst.ComponentType.PersonalInfo,
    localization = {
      titleStr = "id_account_ID5_desc_1",
      contentStr = "",
      confirmBtnStr = "id_account_ID_btn_signup",
      noteStr = "id_account_ID5_btn_2"
    }
  })
end

function UIAccountIdBindBindPlayerInfoState:OnClickRight()
  self.view:SwitchToNextState()
end

return UIAccountIdBindBindPlayerInfoState
