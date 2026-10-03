local LWUIActEasterEggEditView = BaseClass("LWUIActEasterEggEditView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = LWUIActEasterEggEditView
local gatheringEggItem = require("UI.LWUIActEasterEgg.LWUIActEasterEggEdit.Component.LWUIActEasterGatheringEggEditItem")
local voteEggItem = require("UI.LWUIActEasterEgg.LWUIActEasterEggEdit.Component.LWUIActEasterVoteEggEditItem")
local eggEditViewConfig = {
  [ActEasterEggType.Gathering] = {
    title = "activity_99144_ui_13",
    titleImage = "Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggEdit/lrb_FHJ_reng_xiaoxiegg.png",
    prefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterGatheringEggEditItem.prefab",
    script = gatheringEggItem
  },
  [ActEasterEggType.Vote] = {
    title = "activity_99144_ui_14",
    titleImage = "Assets/Main/ActivityRes/2025EasterMod/Sprites/UI/LWUIActEasterEggEdit/lrb_FHJ_reng_topiaoegg.png",
    prefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterVoteEggEditItem.prefab",
    script = voteEggItem
  }
}
local AnimName = {Throw = "throw"}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  self:ClearItem()
  self:StopThrowTimer()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.compContent = self:AddComponent(UIBaseContainer, "Content")
  self.btnLWClose = self:AddComponent(UIButton, "LW_Btn_Close")
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textGatheringEggBtn = self:AddComponent(UITextMeshProUGUIEx, "GatheringEggBtn/GatheringEggBtnText")
  self.compGatheringEggBtnFrame = self:AddComponent(UIBaseContainer, "GatheringEggBtn/GatheringEggBtnFrame")
  self.textVoteEggBtn = self:AddComponent(UITextMeshProUGUIEx, "VoteEggBtn/VoteEggBtnText")
  self.compVoteEggBtnFrame = self:AddComponent(UIBaseContainer, "VoteEggBtn/VoteEggBtnFrame")
  self.btnGatheringEgg = self:AddComponent(UIButton, "GatheringEggBtn")
  self.btnGatheringEgg:SetOnClick(function()
    self:OnBtnGatheringEggClick()
  end)
  self.btnVoteEgg = self:AddComponent(UIButton, "VoteEggBtn")
  self.btnVoteEgg:SetOnClick(function()
    self:OnBtnVoteEggClick()
  end)
  self.textEggTypeTitle = self:AddComponent(UITextMeshProUGUIEx, "EggTypeTitle")
  self.imgEggType = self:AddComponent(UIImage, "EggTypeImage")
  self.compGatheringEggItemNode = self:AddComponent(UIBaseContainer, "Content/GatheringEggItemNode")
  self.compVoteEggItemNode = self:AddComponent(UIBaseContainer, "Content/VoteEggItemNode")
  self.gatheringItem = nil
  self.voteEggItem = nil
  self.textGatheringEggBtn:SetLocalText("activity_99144_ui_18a")
  self.textVoteEggBtn:SetLocalText("activity_99144_ui_18b")
  self.animator = self:AddComponent(UIAnimator, "")
  self.animator:Enable(true)
  self.contentCloseKeyboardBtn = self:AddComponent(UIButton, "ContentCloseKeyboardBtn")
  self.contentCloseKeyboardBtn:SetActive(false)
  self.contentCloseKeyboardBtn:SetOnClick(function()
    EventManager:GetInstance():Broadcast(EventId.EasterEggPostOrVoteCloseKeyboard)
    self.clickTimes = self.clickTimes + 1
    if self.clickTimes >= 2 then
      self.clickTimes = 0
      self.contentCloseKeyboardBtn:SetActive(false)
    end
  end)
end

function M:ComponentDestroy()
  self.compContent = nil
  self.btnLWClose = nil
  self.btnPanel = nil
  self.textGatheringEggBtn = nil
  self.compGatheringEggBtnFrame = nil
  self.textVoteEggBtn = nil
  self.compVoteEggBtnFrame = nil
  self.btnGatheringEgg = nil
  self.btnVoteEgg = nil
  self.textEggTypeTitle = nil
  self.imgEggType = nil
  self.compGatheringEggItemNode = nil
  self.compVoteEggItemNode = nil
  self.gatheringItem = nil
  self.voteEggItem = nil
  self.animator = nil
end

function M:DataDefine()
  self.curEggType = ActEasterEggType.Gathering
  self.delayThrowTimer = nil
  self.isThrowing = false
  self.clickTimes = 0
end

function M:DataDestroy()
  self.curEggType = nil
  self.delayThrowTimer = nil
  self.isThrowing = false
  self.clickTimes = 0
end

function M:ClearItem()
  if self.gatheringItem then
    self.compGatheringEggItemNode:RemoveComponents(gatheringEggItem)
    self:GameObjectDestroy(self.gatheringItem.gameObject)
    self.gatheringItem = nil
  end
  if self.voteEggItem then
    self.compVoteEggItemNode:RemoveComponents(voteEggItem)
    self:GameObjectDestroy(self.voteEggItem.gameObject)
    self.voteEggItem = nil
  end
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggGetActivityEditThrow, self.onRecThrow)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggGetActivityEditThrow, self.onRecThrow)
end

function M:OnBtnLWCloseClick()
  if self.isThrowing then
    return
  end
  self.ctrl.CloseSelf()
end

function M:OnBtnPanelClick()
  if self.isThrowing then
    return
  end
  self.ctrl.CloseSelf()
end

function M:OnBtnGatheringEggClick()
  self.curEggType = ActEasterEggType.Gathering
  self:RefreshView()
end

function M:OnBtnVoteEggClick()
  self.curEggType = ActEasterEggType.Vote
  self:RefreshView()
end

function M:RefreshView()
  self.compGatheringEggBtnFrame:SetActive(self.curEggType == ActEasterEggType.Gathering)
  self.compVoteEggBtnFrame:SetActive(self.curEggType == ActEasterEggType.Vote)
  self.compGatheringEggItemNode:SetActive(self.curEggType == ActEasterEggType.Gathering)
  self.compVoteEggItemNode:SetActive(self.curEggType == ActEasterEggType.Vote)
  local config = eggEditViewConfig[self.curEggType]
  if not config then
    Logger.LogError("LWUIActEasterEggEditView.RefreshView error, config is nil, curEggType = " .. self.curEggType)
    return
  end
  self.textEggTypeTitle:SetText(Localization:GetString(config.title))
  self.imgEggType:LoadSprite(config.titleImage)
  self:RefreshContent(config.prefabPath, config.script)
end

function M:RefreshContent()
  local item, prefabPath, script, parentNode
  if self.curEggType == ActEasterEggType.Gathering then
    item = self.gatheringItem
  elseif self.curEggType == ActEasterEggType.Vote then
    item = self.voteEggItem
  end
  if item then
    item:UpdateItem(self.ctrl)
  else
    prefabPath = eggEditViewConfig[self.curEggType].prefabPath
    script = eggEditViewConfig[self.curEggType].script
    if self.curEggType == ActEasterEggType.Gathering then
      parentNode = self.compGatheringEggItemNode
    elseif self.curEggType == ActEasterEggType.Vote then
      parentNode = self.compVoteEggItemNode
    end
    self:LoadEggItem(prefabPath, script, parentNode)
  end
end

function M:LoadEggItem(path, script, parentNode)
  self:GameObjectInstantiateAsync(path, function(request)
    if IsNull(request.gameObject) then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(parentNode.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localPosition(0, 0, 0)
    local cell = parentNode:AddComponent(script, go)
    if self.curEggType == ActEasterEggType.Gathering then
      self.gatheringItem = cell
    elseif self.curEggType == ActEasterEggType.Vote then
      self.voteEggItem = cell
    end
    cell:UpdateItem(self.ctrl)
  end)
end

function M:onRecThrow()
  local throwData = DataCenter.ActEasterEggManager:GetThrowData()
  if not throwData then
    return
  end
  local checkSuccess = false
  if throwData.type == ActEasterEggType.Gathering then
    local checkContent, content = throwData:CheckContent()
    if not checkContent then
      UIUtil.ShowTips(Localization:GetString("activity_99144_6"), nil, nil, nil, nil, 445)
      if self.gatheringItem then
        self.gatheringItem:SetContentText(content)
      end
    else
      checkSuccess = true
    end
  elseif throwData.type == ActEasterEggType.Vote then
    local checkContent, content = throwData:CheckContent()
    local optionACheck, optionA = throwData:CheckOptionA()
    local optionBCheck, optionB = throwData:CheckOptionB()
    if not checkContent then
      UIUtil.ShowTips(Localization:GetString("activity_99144_6"), nil, nil, nil, nil, 445)
      if self.voteEggItem then
        self.voteEggItem:SetContentText(content)
      end
    elseif not optionACheck then
      UIUtil.ShowTips(Localization:GetString("activity_99144_6"), nil, nil, nil, nil, 445)
      if self.voteEggItem then
        self.voteEggItem:SetAnswerAText(optionA)
      end
    elseif not optionBCheck then
      UIUtil.ShowTips(Localization:GetString("activity_99144_6"), nil, nil, nil, nil, 445)
      if self.voteEggItem then
        self.voteEggItem:SetAnswerBText(optionB)
      end
    else
      checkSuccess = true
    end
  end
  if checkSuccess then
    self.animator:Play("throw")
    self.isThrowing = true
    self:StopThrowTimer()
    if self.gatheringItem then
      self.gatheringItem:SetKeyboardClickpanelBtnState(false)
    end
    if self.voteEggItem then
      self.voteEggItem:SetKeyboardClickpanelBtnState(false)
    end
    local ret, time = self.animator:PlayAnimationReturnTime(AnimName.Throw)
    self.delayThrowTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.delayThrowTimer ~= nil then
        self.delayThrowTimer:Stop()
        self.delayThrowTimer = nil
      end
      self.animator:Enable(false)
      self.ctrl.CloseSelf()
    end, self, true, false, false)
    self.delayThrowTimer:Start()
    local robotPlaySendAniDelay = 0.6
    self.sendMsgTimer = TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityPlayRobotRelease)
      self.sendMsgTimer = nil
    end, robotPlaySendAniDelay)
  else
    self:SetThrowFalse()
  end
end

function M:StopThrowTimer()
  if self.delayThrowTimer ~= nil then
    self.delayThrowTimer:Stop()
    self.delayThrowTimer = nil
  end
  if self.sendMsgTimer then
    self.sendMsgTimer:Stop()
    self.sendMsgTimer = nil
  end
end

function M:ChangeContentCloseKeyboardBtnState(state)
  self.contentCloseKeyboardBtn:SetActive(state)
  if state then
    self.clickTimes = 0
  end
end

function M:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function M:SetThrowFalse()
  if self.gatheringItem then
    self.gatheringItem:SetThrowFalse()
  end
  if self.voteEggItem then
    self.voteEggItem:SetThrowFalse()
  end
end

return LWUIActEasterEggEditView
