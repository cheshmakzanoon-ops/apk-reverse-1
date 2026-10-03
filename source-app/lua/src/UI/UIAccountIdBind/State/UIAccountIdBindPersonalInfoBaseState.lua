local UIAccountIdBindSimpleState = require("UI.UIAccountIdBind.State.UIAccountIdBindSimpleState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindPersonalInfoBaseState = BaseClass("UIAccountIdBindPersonalInfoBaseState", UIAccountIdBindSimpleState)
local base = UIAccountIdBindSimpleState

function UIAccountIdBindPersonalInfoBaseState:__init(view, viewState, config)
  base.__init(self, view, viewState, config)
end

function UIAccountIdBindPersonalInfoBaseState:OnEnter()
  self.view:RefreshProgressBar(AccountScoreConst.AccountIdBindStage.Confirm, false)
  self.view:RefreshContent(AccountScoreConst.ComponentType.PersonalInfo, self)
  base.OnEnter(self)
end

function UIAccountIdBindPersonalInfoBaseState:OnClickRight()
end

return UIAccountIdBindPersonalInfoBaseState
