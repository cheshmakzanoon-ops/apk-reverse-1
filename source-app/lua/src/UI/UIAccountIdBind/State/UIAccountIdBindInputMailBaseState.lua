local UIAccountIdBindSimpleState = require("UI.UIAccountIdBind.State.UIAccountIdBindSimpleState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindInputMailBaseState = BaseClass("UIAccountIdBindInputMailBaseState", UIAccountIdBindSimpleState)
local base = UIAccountIdBindSimpleState

function UIAccountIdBindInputMailBaseState:__init(view, viewState, config)
  base.__init(self, view, viewState, config)
end

function UIAccountIdBindInputMailBaseState:OnEnter()
  self.view:RefreshProgressBar(AccountScoreConst.AccountIdBindStage.Mail, false)
  self.view:RefreshContent(AccountScoreConst.ComponentType.InputMail, self)
  base.OnEnter(self)
end

function UIAccountIdBindInputMailBaseState:GetComponentParam()
  local param = {}
  if self.config.isEdit ~= nil then
    param.isEdit = self.config.isEdit
  else
    param.isEdit = true
  end
  if self.config.getDefaultMail then
    param.defaultMail = self.config.getDefaultMail(self)
  end
  return param
end

function UIAccountIdBindInputMailBaseState:OnClickRight(mailAddress)
  if self.config.onRequest then
    self.config.onRequest(self, mailAddress)
  end
end

return UIAccountIdBindInputMailBaseState
