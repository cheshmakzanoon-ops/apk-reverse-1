local UIAccountIdBindSimpleState = require("UI.UIAccountIdBind.State.UIAccountIdBindSimpleState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindBindPlayerInfoBaseState = BaseClass("UIAccountIdBindBindPlayerInfoBaseState", UIAccountIdBindSimpleState)
local base = UIAccountIdBindSimpleState

function UIAccountIdBindBindPlayerInfoBaseState:__init(view, viewState, config)
  base.__init(self, view, viewState, config)
  self.config = config or {}
end

function UIAccountIdBindBindPlayerInfoBaseState:OnEnter()
  self.view:RefreshProgressBar(AccountScoreConst.AccountIdBindStage.Confirm, false)
  self.view:RefreshContent(AccountScoreConst.ComponentType.PersonalInfo, self)
  base.OnEnter(self)
end

return UIAccountIdBindBindPlayerInfoBaseState
