local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local UIAccountIdBindFirstBindInputMailState = require("UI.UIAccountIdBind.State.UIAccountIdBindFirstBindInputMailState")
local UIAccountIdBindInputVerifyCodeState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputVerifyCodeState")
local UIAccountIdBindBindPlayerInfoState = require("UI.UIAccountIdBind.State.UIAccountIdBindBindPlayerInfoState")
local UIAccountIdBindActiveCardState = require("UI.UIAccountIdBind.State.UIAccountIdBindActiveCardState")
local UIAccountIdBindShowOldMailState = require("UI.UIAccountIdBind.State.UIAccountIdBindShowOldMailState")
local UIAccountIdBindInputChangeMailState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputChangeMailState")
local UIAccountIdBindInputOldMailVerifyCodeState = require("UI.UIAccountIdBind.State.UIAccountIdBindInputOldMailVerifyCodeState")
local UIAccountIdBindSwitchLogInState = require("UI.UIAccountIdBind.State.UIAccountIdBindSwitchLogInState")
local UIAccountIdBindInputChangeMailVerifyCode = require("UI.UIAccountIdBind.State.UIAccountIdBindInputChangeMailVerifyCode")
local uiAccountIdBindBindSuccessState = require("UI.UIAccountIdBind.State.UIAccountIdBindBindSuccessState")
local AccountIdBindData = require("UI.UIAccountIdBind.Data.AccountIdBindData")
local UIAccountIdBindStateMachine = BaseClass("UIAccountIdBindStateMachine")

function UIAccountIdBindStateMachine:__init(view)
  self.view = view
  self.stateClassMap = {
    [AccountScoreConst.ViewState.FirstBindInputMail] = UIAccountIdBindFirstBindInputMailState,
    [AccountScoreConst.ViewState.InputVerifyCode] = UIAccountIdBindInputVerifyCodeState,
    [AccountScoreConst.ViewState.BindPlayerInfo] = UIAccountIdBindBindPlayerInfoState,
    [AccountScoreConst.ViewState.ActiveCard] = UIAccountIdBindActiveCardState,
    [AccountScoreConst.ViewState.ShowOldMail] = UIAccountIdBindShowOldMailState,
    [AccountScoreConst.ViewState.InputChangeMail] = UIAccountIdBindInputChangeMailState,
    [AccountScoreConst.ViewState.InputOldMailVerifyCode] = UIAccountIdBindInputOldMailVerifyCodeState,
    [AccountScoreConst.ViewState.SignIn] = UIAccountIdBindSwitchLogInState,
    [AccountScoreConst.ViewState.InputChangeMailVerifyCode] = UIAccountIdBindInputChangeMailVerifyCode,
    [AccountScoreConst.ViewState.BindSuccess] = uiAccountIdBindBindSuccessState
  }
  self.stateObjCache = {}
  self.curOpenType = nil
  self.curStateOrder = nil
  self.curStateIndex = 0
  self.curStateObj = nil
  self.accountIdBindData = nil
end

function UIAccountIdBindStateMachine:Dispose()
  if self.curStateObj then
    self.curStateObj:Exit()
  end
  self.curStateObj = nil
  self.stateObjCache = nil
  self.stateClassMap = nil
  self.curOpenType = nil
  self.curStateOrder = nil
  self.curStateIndex = 0
  self.accountIdBindData = nil
  self.view = nil
end

function UIAccountIdBindStateMachine:InitAccountIdBindData()
  self.accountIdBindData = AccountIdBindData.New()
end

function UIAccountIdBindStateMachine:GetAccountIdBindData()
  return self.accountIdBindData
end

function UIAccountIdBindStateMachine:GetStateIndexByValue(stateOrder, viewState)
  for index, value in ipairs(stateOrder) do
    if value == viewState then
      return index
    end
  end
  return nil
end

function UIAccountIdBindStateMachine:GetOrCreateStateObj(viewState)
  local stateObj = self.stateObjCache[viewState]
  if stateObj ~= nil then
    return stateObj
  end
  local stateClass = self.stateClassMap[viewState]
  if stateClass ~= nil then
    stateObj = stateClass.New(self.view)
    self.stateObjCache[viewState] = stateObj
    return stateObj
  end
  Logger.LogError("[UIAccountIdBindStateMachine] missing state class, viewState = " .. tostring(viewState))
  return nil
end

function UIAccountIdBindStateMachine:EnterStateByIndex(targetIndex)
  local totalCount = #self.curStateOrder
  if targetIndex == 0 and self.view then
    self.view:OnBtnCloseClick()
    return false
  end
  if targetIndex > totalCount then
    if self.view then
      self.view:OnBtnCloseClick()
    end
    return false
  end
  if targetIndex < 1 or targetIndex > totalCount then
    return false
  end
  local oldState
  if 0 < self.curStateIndex then
    oldState = self.curStateOrder[self.curStateIndex]
  end
  local switchDir = 0
  if 0 < self.curStateIndex then
    if targetIndex > self.curStateIndex then
      switchDir = 1
    elseif targetIndex < self.curStateIndex then
      switchDir = -1
    end
  end
  if self.view and self.view.SetPendingContentTransitionDirection then
    self.view:SetPendingContentTransitionDirection(switchDir)
  end
  if self.curStateObj then
    self.curStateObj:Exit()
    self.curStateObj = nil
  end
  self.curStateIndex = targetIndex
  local newState = self.curStateOrder[self.curStateIndex]
  local nextStateObj = self:GetOrCreateStateObj(newState)
  if nextStateObj == nil then
    return false
  end
  self.curStateObj = nextStateObj
  self.curStateObj:Enter(self.curOpenType, self.curStateIndex, totalCount)
  if self.view and self.view.OnAccountIdBindStateChanged then
    self.view:OnAccountIdBindStateChanged(oldState, newState, self.curOpenType, self.curStateIndex, totalCount)
  end
  return true
end

function UIAccountIdBindStateMachine:EnterOpenType(openType, defaultViewState)
  local targetOpenType = openType or AccountScoreConst.OpenType.BindMail
  local stateOrder = AccountScoreConst.OpenStateMap[targetOpenType]
  if stateOrder == nil or #stateOrder <= 0 then
    Logger.LogError("[UIAccountIdBindStateMachine] invalid openType state map, openType = " .. tostring(targetOpenType))
    return
  end
  self.curOpenType = targetOpenType
  self.curStateOrder = stateOrder
  self.curStateIndex = 0
  self:InitAccountIdBindData()
  local targetIndex = 1
  if defaultViewState ~= nil then
    local customIndex = self:GetStateIndexByValue(stateOrder, defaultViewState)
    if customIndex ~= nil then
      targetIndex = customIndex
    else
      Logger.LogError("[UIAccountIdBindStateMachine] defaultViewState not in current openType map, state = " .. tostring(defaultViewState))
    end
  end
  self:EnterStateByIndex(targetIndex)
end

function UIAccountIdBindStateMachine:SwitchToNextState()
  if self.curStateOrder == nil then
    Logger.LogError("[UIAccountIdBindStateMachine] state order is nil")
    return false
  end
  return self:EnterStateByIndex(self.curStateIndex + 1)
end

function UIAccountIdBindStateMachine:SwitchToPrevState()
  if self.curStateOrder == nil then
    Logger.LogError("[UIAccountIdBindStateMachine] state order is nil")
    return false
  end
  return self:EnterStateByIndex(self.curStateIndex - 1)
end

function UIAccountIdBindStateMachine:GetCurOpenType()
  return self.curOpenType
end

function UIAccountIdBindStateMachine:GetCurViewState()
  if self.curStateOrder == nil or self.curStateIndex <= 0 then
    return nil
  end
  return self.curStateOrder[self.curStateIndex]
end

function UIAccountIdBindStateMachine:GetCurStateObj()
  return self.curStateObj
end

return UIAccountIdBindStateMachine
