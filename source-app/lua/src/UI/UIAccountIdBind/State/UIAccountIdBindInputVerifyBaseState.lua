local UIAccountIdBindSimpleState = require("UI.UIAccountIdBind.State.UIAccountIdBindSimpleState")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindInputVerifyBaseState = BaseClass("UIAccountIdBindInputVerifyBaseState", UIAccountIdBindSimpleState)
local base = UIAccountIdBindSimpleState

function UIAccountIdBindInputVerifyBaseState:__init(view, viewState, config)
  base.__init(self, view, viewState, config)
  self.config = config or {}
end

function UIAccountIdBindInputVerifyBaseState:OnEnter()
  local view = self:GetView()
  if view then
    view:RefreshProgressBar(AccountScoreConst.AccountIdBindStage.Verify, true)
    local componentType = self.config.componentType
    if componentType ~= nil and AccountScoreConst.ComponentConfigMap[componentType] ~= nil then
      view:RefreshContent(componentType, self)
    end
  end
  base.OnEnter(self)
end

function UIAccountIdBindInputVerifyBaseState:OnClickRight(verifyCode)
  if self.config.onRequest then
    self.config.onRequest(self, verifyCode)
  end
end

function UIAccountIdBindInputVerifyBaseState:OnClickResend()
  if self.config.onResendRequest then
    self.config.onResendRequest(self)
  end
end

return UIAccountIdBindInputVerifyBaseState
