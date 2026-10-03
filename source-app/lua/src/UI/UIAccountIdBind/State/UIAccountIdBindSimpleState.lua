local UIAccountIdBindBaseState = require("UI.UIAccountIdBind.State.UIAccountIdBindBaseState")
local UIAccountIdBindSimpleState = BaseClass("UIAccountIdBindSimpleState", UIAccountIdBindBaseState)
local base = UIAccountIdBindBaseState

function UIAccountIdBindSimpleState:__init(view, viewState, config)
  base.__init(self, view, viewState)
  self.config = config or {}
end

function UIAccountIdBindSimpleState:OnEnter()
  base.OnEnter(self)
  if self.config.onEnter then
    self.config.onEnter(self)
  end
end

function UIAccountIdBindSimpleState:OnExit()
  if self.config.onExit then
    self.config.onExit(self)
  end
  base.OnExit(self)
end

function UIAccountIdBindSimpleState:GetStateLocalization()
  if self.config.localization ~= nil then
    return self.config.localization
  end
  return {}
end

function UIAccountIdBindSimpleState:GetComponentParam()
  if self.config.componentParam ~= nil then
    return self.config.componentParam
  end
  return {}
end

function UIAccountIdBindSimpleState:OnClickLeft()
  local view = self:GetView()
  if view then
    view:SwitchToPrevState()
  end
end

function UIAccountIdBindSimpleState:OnClickRight()
  local view = self:GetView()
  if view then
    view:SwitchToNextState()
  end
end

return UIAccountIdBindSimpleState
