local UIAccountIdBindBaseState = BaseClass("UIAccountIdBindBaseState")

function UIAccountIdBindBaseState:__init(view, viewState)
  self.view = view
  self.viewState = viewState
  self.openType = nil
  self.stateIndex = 0
  self.stateCount = 0
end

function UIAccountIdBindBaseState:GetView()
  return self.view
end

function UIAccountIdBindBaseState:GetViewState()
  return self.viewState
end

function UIAccountIdBindBaseState:GetOpenType()
  return self.openType
end

function UIAccountIdBindBaseState:GetStateIndex()
  return self.stateIndex
end

function UIAccountIdBindBaseState:GetStateCount()
  return self.stateCount
end

function UIAccountIdBindBaseState:GetAccountIdBindData()
  local view = self:GetView()
  if view then
    return view:GetAccountIdBindData()
  end
  return nil
end

function UIAccountIdBindBaseState:Enter(openType, stateIndex, stateCount)
  self.openType = openType
  self.stateIndex = stateIndex or 0
  self.stateCount = stateCount or 0
  self:OnEnter()
end

function UIAccountIdBindBaseState:Exit()
  self:OnExit()
end

function UIAccountIdBindBaseState:OnEnter()
end

function UIAccountIdBindBaseState:OnExit()
end

function UIAccountIdBindBaseState:JumpToPreState()
  if self.OnClickLeft then
    self:OnClickLeft()
    return
  end
end

return UIAccountIdBindBaseState
