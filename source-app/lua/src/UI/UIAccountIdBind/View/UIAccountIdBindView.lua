local UIAccountIdBindView = BaseClass("UIAccountIdBindView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Ease = CS.DG.Tweening.Ease
local UIAccountIdBindProgressBar = require("UI.UIAccountIdBind.Component.UIAccountIdBindProgressBar")
local UIAccountIdBindStateMachine = require("UI.UIAccountIdBind.State.UIAccountIdBindStateMachine")
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")

function UIAccountIdBindView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIAccountIdBindView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountIdBindView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.compProgressBar = self.viewSkin:AddComponent(self, UIAccountIdBindProgressBar, 3)
end

function UIAccountIdBindView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.compContent = nil
  self.compProgressBar = nil
end

function UIAccountIdBindView:DataDefine()
  self.stateMachine = UIAccountIdBindStateMachine.New(self)
  self.curContentReq = nil
  self.pendingContentReq = nil
  self.curContentObj = nil
  self.curContentClass = nil
  self.curContentPrefabPath = nil
  self.curContentName = nil
  self.curContentState = nil
  self.transitionOutContentReq = nil
  self.transitionOutContentObj = nil
  self.transitionOutContentClass = nil
  self.transitionOutContentName = nil
  self.contentRefreshVersion = 0
  self.pendingContentTransitionDirection = 0
  self.contentTransitionSeq = nil
  self.isContentTransitioning = false
  self.isContentLoading = false
  self.curOpenParam = nil
end

function UIAccountIdBindView:DataDestroy()
  self:ClearContent()
  if self.stateMachine then
    self.stateMachine:Dispose()
    self.stateMachine = nil
  end
end

function UIAccountIdBindView:OnEnable()
  base.OnEnable(self)
end

function UIAccountIdBindView:OnDisable()
  base.OnDisable(self)
end

function UIAccountIdBindView:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountIdBindView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountIdBindView:OnBtnCloseClick()
  if self.curOpenParam and self.curOpenParam == AccountScoreConst.OpenType.ChangeMail and self.stateMachine and self.stateMachine:GetCurViewState() ~= AccountScoreConst.ViewState.BindSuccess then
    UIUtil.ShowMessage(Localization:GetString("email_bind_cancel_des"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.ctrl:CloseSelf()
    end, nil, nil, "email_bind_cancel_title")
    return
  end
  self.ctrl:CloseSelf()
end

function UIAccountIdBindView:InitView()
  self.compProgressBar:ReInit()
  self:InitOpenState()
end

function UIAccountIdBindView:InitOpenState()
  local openParam = self:GetUserData()
  self.curOpenParam = openParam
  self.stateMachine:EnterOpenType(openParam)
end

function UIAccountIdBindView:OnAccountIdBindStateChanged(oldState, newState, openType, curIndex, totalCount)
  Logger.Log("[UIAccountIdBindView] openType = " .. tostring(openType) .. ", state = " .. tostring(oldState) .. " -> " .. tostring(newState) .. ", index = " .. tostring(curIndex) .. "/" .. tostring(totalCount))
end

function UIAccountIdBindView:IsContentBusy()
  return self.isContentLoading or self.isContentTransitioning
end

function UIAccountIdBindView:SwitchToNextState()
  if self:IsContentBusy() then
    return false
  end
  return self.stateMachine:SwitchToNextState()
end

function UIAccountIdBindView:SwitchToPrevState()
  if self:IsContentBusy() then
    return false
  end
  return self.stateMachine:SwitchToPrevState()
end

function UIAccountIdBindView:GetCurOpenType()
  return self.stateMachine:GetCurOpenType()
end

function UIAccountIdBindView:GetCurViewState()
  return self.stateMachine:GetCurViewState()
end

function UIAccountIdBindView:GetCurStateObj()
  return self.stateMachine:GetCurStateObj()
end

function UIAccountIdBindView:GetAccountIdBindData()
  if self.stateMachine then
    return self.stateMachine:GetAccountIdBindData()
  end
  return nil
end

function UIAccountIdBindView:RefreshProgressBar(progress, playAni)
  if self.compProgressBar then
    self.compProgressBar:MoveToProgress(progress, playAni)
  end
end

function UIAccountIdBindView:ClearContent()
  self.contentRefreshVersion = (self.contentRefreshVersion or 0) + 1
  self:KillContentTransitionSeq()
  self:CleanupTransitionOutContent()
  self.isContentLoading = false
  self.isContentTransitioning = false
  if self.pendingContentReq ~= nil then
    self.pendingContentReq:Destroy()
    self.pendingContentReq = nil
  end
  if self.curContentReq ~= nil then
    self.curContentReq:Destroy()
    self.curContentReq = nil
  end
  self:RemoveContentComponent(self.curContentObj, self.curContentClass, self.curContentName)
  self.curContentObj = nil
  self.curContentClass = nil
  self.curContentPrefabPath = nil
  self.curContentName = nil
  self.curContentState = nil
  self.pendingContentTransitionDirection = 0
end

function UIAccountIdBindView:SetPendingContentTransitionDirection(direction)
  self.pendingContentTransitionDirection = direction or 0
end

function UIAccountIdBindView:KillContentTransitionSeq()
  if self.contentTransitionSeq then
    self.contentTransitionSeq:Kill()
  end
end

function UIAccountIdBindView:ResetContentPosition(contentObj)
  if contentObj and IsNotNull(contentObj.gameObject) then
    contentObj.transform:DOKill()
    contentObj.transform:Set_localPosition(0, 0, 0)
  end
end

function UIAccountIdBindView:CleanupTransitionOutContent()
  self:RemoveContentComponent(self.transitionOutContentObj, self.transitionOutContentClass, self.transitionOutContentName)
  self:DestroyContentRequest(self.transitionOutContentReq)
  self.transitionOutContentReq = nil
  self.transitionOutContentObj = nil
  self.transitionOutContentClass = nil
  self.transitionOutContentName = nil
end

function UIAccountIdBindView:RemoveContentComponent(contentObj, contentClass, contentName)
  if not self.compContent or not contentClass then
    return
  end
  if contentObj and contentObj.GetName then
    local compName = contentName or contentObj:GetName()
    if not string.IsNullOrEmpty(compName) then
      self.compContent:RemoveComponent(compName, contentClass)
      return
    end
  end
  self.compContent:RemoveComponents(contentClass)
end

function UIAccountIdBindView:DestroyContentRequest(contentReq)
  if not contentReq then
    return
  end
  contentReq:Destroy()
end

function UIAccountIdBindView:GetContentTransitionOffsetX()
  if not self.compContent or IsNull(self.compContent.transform) then
    return 480
  end
  local width = 0
  local parent = self.compContent.transform.parent
  if IsNotNull(parent) and parent.rect then
    width = parent.rect.width
  end
  if width <= 0 then
    width = self.compContent.transform.rect.width
  end
  if width <= 0 then
    return 480
  end
  return math.max(width * 1.1, width + 40)
end

function UIAccountIdBindView:PlayContentTransition(oldObj, oldClass, oldName, oldReq, newObj, switchDir)
  if not oldObj or IsNull(oldObj.gameObject) then
    self:DestroyContentRequest(oldReq)
    self:ResetContentPosition(newObj)
    return
  end
  if switchDir == 0 then
    self:RemoveContentComponent(oldObj, oldClass, oldName)
    self:DestroyContentRequest(oldReq)
    self:ResetContentPosition(newObj)
    return
  end
  self:KillContentTransitionSeq()
  self:CleanupTransitionOutContent()
  self.isContentTransitioning = true
  self.transitionOutContentReq = oldReq
  self.transitionOutContentObj = oldObj
  self.transitionOutContentClass = oldClass
  self.transitionOutContentName = oldName
  self:ResetContentPosition(oldObj)
  newObj:SetAsLastSibling()
  local moveOffsetX = self:GetContentTransitionOffsetX()
  local duration = 0.25
  local oldTargetX = -switchDir * moveOffsetX
  newObj.transform:DOKill()
  local seq = DOTween.Sequence()
  seq:Join(oldObj.transform:DOLocalMoveX(oldTargetX, duration):SetEase(Ease.OutCubic))
  seq:Join(newObj.transform:DOLocalMoveX(0, duration):SetEase(Ease.OutCubic))
  seq:OnComplete(function()
    self:ResetContentPosition(newObj)
    self:CleanupTransitionOutContent()
    self.isContentTransitioning = false
    self.contentTransitionSeq = nil
  end)
  seq:OnKill(function()
    self:ResetContentPosition(newObj)
    self:CleanupTransitionOutContent()
    self.isContentTransitioning = false
    self.contentTransitionSeq = nil
  end)
  self.contentTransitionSeq = seq
end

function UIAccountIdBindView:RefreshContent(componentType, state, param)
  local componentConfig = AccountScoreConst.ComponentConfigMap[componentType]
  if not componentConfig or string.IsNullOrEmpty(componentConfig.prefabPath) or string.IsNullOrEmpty(componentConfig.compPath) then
    self.isContentLoading = false
    Logger.LogError("can't find component config, componentType = " .. tostring(componentType))
    return
  end
  local componentClass = require(componentConfig.compPath)
  if self.curContentObj and self.curContentClass == componentClass and self.curContentPrefabPath == componentConfig.prefabPath and self.curContentState == state and IsNotNull(self.curContentObj.gameObject) then
    self.curContentObj:Init(state, param)
    self.pendingContentTransitionDirection = 0
    return
  end
  self.contentRefreshVersion = (self.contentRefreshVersion or 0) + 1
  self:KillContentTransitionSeq()
  self:CleanupTransitionOutContent()
  self.isContentLoading = true
  self.isContentTransitioning = false
  local oldContentObj = self.curContentObj
  local oldContentClass = self.curContentClass
  local oldContentName = self.curContentName
  local oldContentReq = self.curContentReq
  local switchDir = self.pendingContentTransitionDirection or 0
  self.pendingContentTransitionDirection = 0
  if self.pendingContentReq ~= nil then
    self:DestroyContentRequest(self.pendingContentReq)
    self.pendingContentReq = nil
  end
  if oldContentReq and (not oldContentObj or IsNull(oldContentObj.gameObject)) then
    self:DestroyContentRequest(oldContentReq)
    self.curContentReq = nil
    oldContentReq = nil
  end
  local refreshVersion = self.contentRefreshVersion
  self.pendingContentReq = self:GameObjectInstantiateAsync(componentConfig.prefabPath, function(req)
    if refreshVersion ~= self.contentRefreshVersion or self.pendingContentReq ~= req then
      req:Destroy()
      return
    end
    local gameObject = req.gameObject
    if IsNull(gameObject) then
      self.pendingContentReq = nil
      self.isContentLoading = false
      return
    end
    local transform = gameObject.transform
    gameObject:SetActive(true)
    transform:SetParent(self.compContent.transform)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform:Set_localPosition(0, 0, 0)
    local name = gameObject.name .. "_" .. tostring(refreshVersion)
    gameObject.name = name
    local newCompObj = self.compContent:AddComponent(componentClass, name)
    local moveOffsetX = self:GetContentTransitionOffsetX()
    if oldContentObj and IsNotNull(oldContentObj.gameObject) and switchDir ~= 0 then
      transform:Set_localPosition(switchDir * moveOffsetX, 0, 0)
    end
    newCompObj:Init(state, param)
    self.curContentObj = newCompObj
    self.curContentClass = componentClass
    self.curContentPrefabPath = componentConfig.prefabPath
    self.curContentName = name
    self.curContentState = state
    self.curContentReq = req
    self.pendingContentReq = nil
    self.isContentLoading = false
    if oldContentObj and IsNotNull(oldContentObj.gameObject) then
      self:PlayContentTransition(oldContentObj, oldContentClass, oldContentName, oldContentReq, newCompObj, switchDir)
    else
      self:DestroyContentRequest(oldContentReq)
      self:ResetContentPosition(newCompObj)
    end
  end)
  if self.pendingContentReq == nil then
    self.isContentLoading = false
  end
end

return UIAccountIdBindView
