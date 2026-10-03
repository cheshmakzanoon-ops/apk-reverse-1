local UILWDominatorCockatriceUnlockMainView = BaseClass("UILWDominatorCockatriceUnlockMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWDominatorCockatriceUnlockMainItemComponent = require("UI.UILWDominator.CockatriceUnlock.Main.Component.UILWDominatorCockatriceUnlockMainItemComponent")

function UILWDominatorCockatriceUnlockMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorCockatriceUnlockMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorCockatriceUnlockMainView:ComponentDefine()
  self.btnUICommonBlackMask = self:AddComponent(UIButton, "UICommonBlackMask")
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textGuide = self:AddComponent(UITextMeshProUGUIEx, "Root/MiddleUpper/Guide/GuideText")
  self.compHornContent = self:AddComponent(UIBaseContainer, "Root/MiddleLower/HornContent")
  self.compFragment01 = self:AddComponent(UILWDominatorCockatriceUnlockMainItemComponent, "Root/MiddleLower/HornContent/FragmentContent/Fragment01")
  self.compFragment02 = self:AddComponent(UILWDominatorCockatriceUnlockMainItemComponent, "Root/MiddleLower/HornContent/FragmentContent/Fragment02")
  self.compFragment03 = self:AddComponent(UILWDominatorCockatriceUnlockMainItemComponent, "Root/MiddleLower/HornContent/FragmentContent/Fragment03")
  self.compFragment04 = self:AddComponent(UILWDominatorCockatriceUnlockMainItemComponent, "Root/MiddleLower/HornContent/FragmentContent/Fragment04")
  self.slider = self:AddComponent(UISlider, "Root/MiddleLower/HornContent/Slider")
  self.textProgress = self:AddComponent(UITextMeshProUGUIEx, "Root/MiddleLower/HornContent/Slider/ProgressText")
  self.compClaimContent = self:AddComponent(UIBaseContainer, "Root/MiddleLower/ClaimContent")
  self.textClaimTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/MiddleLower/ClaimContent/ClaimTitleText")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/MiddleLower/ClaimContent/Rewards/Viewport/Content")
  self.btnClaim = self:AddComponent(UIButton, "Root/MiddleLower/ClaimContent/ClaimBtn")
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textClaim = self:AddComponent(UITextMeshProUGUIEx, "Root/MiddleLower/ClaimContent/ClaimBtn/LW_Btn_Common_New_Base/ClaimText")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/TitleText")
  self.btnLWInfo = self:AddComponent(UIButton, "Root/Top/LW_Btn_Info")
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.btnArchive = self:AddComponent(UIButton, "Root/Top/ArchiveBtn")
  self.btnArchive:SetOnClick(function()
    self:OnBtnArchiveClick()
  end)
  self.textArchieve = self:AddComponent(UITextMeshProUGUIEx, "Root/Top/ArchiveBtn/ArchieveText")
  self.btnBack = self:AddComponent(UIButton, "Root/Bottom/BackBtn")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/TipsText")
  self.btnGoFinal = self:AddComponent(UIButton, "Root/Bottom/GoFinalBtn")
  self.btnGoFinal:SetOnClick(function()
    self:OnBtnGoFinalClick()
  end)
  self.textGoFinal = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/GoFinalBtn/LW_Btn_Common_New_Base/GoFinalText")
  self.compFragmentContent = self:AddComponent(UIBaseContainer, "Root/MiddleLower/HornContent/FragmentContent")
  self.compHorn = self:AddComponent(UIBaseContainer, "Root/MiddleLower/HornContent/Horn")
  self.imgHorn01 = self:AddComponent(UIImage, "Root/MiddleLower/HornContent/Horn/Horn01")
  self.imgHorn02 = self:AddComponent(UIImage, "Root/MiddleLower/HornContent/Horn/Horn02")
  self.imgHorn03 = self:AddComponent(UIImage, "Root/MiddleLower/HornContent/Horn/Horn03")
  self.imgHorn04 = self:AddComponent(UIImage, "Root/MiddleLower/HornContent/Horn/Horn04")
  self.compLine = self:AddComponent(UIBaseContainer, "Root/MiddleLower/HornContent/Line")
  self.compEffUiCockatriceComplete = self:AddComponent(UIBaseContainer, "Root/MiddleLower/HornContent/node_horn_show/Eff_ui_cockatrice_complete")
  self.animatorUILWDominatorCockatriceUnlockMain = self:AddComponent(UIAnimator, "")
  self.compArchiveRed = self:AddComponent(UIBaseContainer, "Root/Top/ArchiveBtn/ArchiveRed")
  self.compNodeHornShow = self:AddComponent(UIBaseContainer, "Root/MiddleLower/HornContent/node_horn_show")
  self.textGoFinal:SetLocalText(450004)
  self.textClaimTitle:SetLocalText("war_eagle_event_desc_9")
  self.textClaim:SetLocalText(129054)
end

function UILWDominatorCockatriceUnlockMainView:ComponentDestroy()
  self:ClearRewards()
  self.btnUICommonBlackMask = nil
  self.textGuide = nil
  self.compHornContent = nil
  self.compFragment01 = nil
  self.compFragment02 = nil
  self.compFragment03 = nil
  self.compFragment04 = nil
  self.slider = nil
  self.textProgress = nil
  self.compClaimContent = nil
  self.textClaimTitle = nil
  self.compContent = nil
  self.btnClaim = nil
  self.textClaim = nil
  self.textTitle = nil
  self.btnLWInfo = nil
  self.btnArchive = nil
  self.textArchieve = nil
  self.btnBack = nil
  self.textTips = nil
  self.btnGoFinal = nil
  self.textGoFinal = nil
  self.compFragmentContent = nil
  self.compHorn = nil
  self.imgHorn01 = nil
  self.imgHorn02 = nil
  self.imgHorn03 = nil
  self.imgHorn04 = nil
  self.compLine = nil
  self.compEffUiCockatriceComplete = nil
  self.animatorUILWDominatorCockatriceUnlockMain = nil
  self.compArchiveRed = nil
  self.compNodeHornShow = nil
end

function UILWDominatorCockatriceUnlockMainView:DataDefine()
  self.nextRefreshTime = nil
  self.hasRefreshByTime = false
  self.targetJumpUuid = nil
end

function UILWDominatorCockatriceUnlockMainView:DataDestroy()
  self.nextRefreshTime = nil
  self.hasRefreshByTime = nil
  self.targetJumpUuid = nil
  self:StopDelayTimer()
end

function UILWDominatorCockatriceUnlockMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorOnPushInfo, self.OnPushDominatorInfo)
  self:AddUIListener(EventId.DetectEventGetRealPoint, self.DoGetEventRealPoint)
  self:AddUIListener(EventId.LWDetectEventRewardReceive, self.OnGetDetectReward)
  self:AddUIListener(EventId.ReceiveQuestReward, self.OnGetQuestReward)
  self:AddUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
  self:AddUIListener(EventId.DominatorCockatriceUnlockClaimQuestGroupReward, self.OnClaimQuestGroupReward)
end

function UILWDominatorCockatriceUnlockMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorOnPushInfo, self.OnPushDominatorInfo)
  self:RemoveUIListener(EventId.DetectEventGetRealPoint, self.DoGetEventRealPoint)
  self:RemoveUIListener(EventId.LWDetectEventRewardReceive, self.OnGetDetectReward)
  self:RemoveUIListener(EventId.ReceiveQuestReward, self.OnGetQuestReward)
  self:RemoveUIListener(EventId.DominatorArchiveUnlockSuccess, self.OnArchiveUnlock)
  self:RemoveUIListener(EventId.DominatorCockatriceUnlockClaimQuestGroupReward, self.OnClaimQuestGroupReward)
  base.OnRemoveListener(self)
end

function UILWDominatorCockatriceUnlockMainView:OnBtnUICommonBlackMaskClick()
end

function UILWDominatorCockatriceUnlockMainView:OnBtnClaimClick()
  if not LuaEntry.Player:IsInSelfServer() then
    UIUtil.ShowTipsId("war_eagle_event_desc_16")
    return
  end
  local finalDetectInfo = DataCenter.DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
  if finalDetectInfo and finalDetectInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
    DataCenter.RadarCenterDataManager:ClaimDetectEventRewardByEventData(finalDetectInfo)
  end
end

function UILWDominatorCockatriceUnlockMainView:OnBtnLWInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("war_eagle_event_info_15")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWDominatorCockatriceUnlockMainView:OnBtnGoFinalClick()
  local isFinishedAllNormal = DataCenter.DominatorCockatriceUnlockManager:IsFinishedAllNormalQuest()
  if isFinishedAllNormal then
    local finalDetectInfo = DataCenter.DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
    if finalDetectInfo and (finalDetectInfo.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or finalDetectInfo.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD) then
      self.targetJumpUuid = finalDetectInfo.uuid
      local closeNow = self.ctrl:GotoDetectEvent(finalDetectInfo.uuid)
      if closeNow then
        GoToUtil.CloseAllWindows()
      end
    end
  end
end

function UILWDominatorCockatriceUnlockMainView:OnBtnArchiveClick()
  local info = DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice)
  if info then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorArchiveCockatrice, {anim = true}, info.uuid)
  end
end

function UILWDominatorCockatriceUnlockMainView:UpdateArchiveBtn()
  local info = DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice)
  self.compArchiveRed:SetActive(info ~= nil and info:HasAnyArchiveCanUnlock())
end

function UILWDominatorCockatriceUnlockMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorCockatriceUnlockMainView:OnOpen()
  self.textTitle:SetLocalText("war_eagle_event_title_1")
  self.textArchieve:SetLocalText("war_eagle_event_desc_8")
  self:UpdateContent()
  self:Update1000MS()
  self:UpdateArchiveBtn()
  self.compNodeHornShow:SetLocalScaleXYZ(CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1, 1, 1)
  DataCenter.RadarCenterDataManager:GetDetectEventData()
  self.animatorUILWDominatorCockatriceUnlockMain:Play("V_uiUILWDominatorCockatriceUnlockMain_in")
end

function UILWDominatorCockatriceUnlockMainView:CheckTipsText()
  self.nextRefreshTime = nil
  local isFinishedAllNormalQuest = DataCenter.DominatorCockatriceUnlockManager:IsFinishedAllNormalQuest()
  self.textTips:SetActive(not isFinishedAllNormalQuest)
  if not isFinishedAllNormalQuest then
    local curGroupIndex = DataCenter.DominatorCockatriceUnlockManager:GetCurFinishedNormalQuestGroupIndex()
    local nextGroupIndex = curGroupIndex + 1
    local nextGroupState = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(nextGroupIndex)
    if nextGroupState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Locked then
      self.nextRefreshTime = DataCenter.DominatorCockatriceUnlockManager:GetQuestGroupUnlockTime(nextGroupIndex)
    elseif nextGroupState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Going then
      self.textTips:SetLocalText("war_eagle_event_desc_6")
    end
  end
end

function UILWDominatorCockatriceUnlockMainView:Update1000MS()
  if not self.nextRefreshTime then
    return
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = math.max(0, self.nextRefreshTime - nowTime)
  local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textTips:SetText(Localization:GetString("war_eagle_event_desc_7", timeStr))
  if leftTime <= 0 and not self.hasRefreshByTime then
    self.hasRefreshByTime = true
    self:UpdateContent()
  end
end

function UILWDominatorCockatriceUnlockMainView:UpdateContent()
  local info = DataCenter.DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
  if info and info.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
    self.compClaimContent:SetActive(true)
    self.compHornContent:SetActive(false)
    self.compEffUiCockatriceComplete:SetActive(false)
    self:UpdateClaimContent()
  else
    self.compClaimContent:SetActive(false)
    self.compHornContent:SetActive(true)
    self:UpdateHornContent()
  end
  self:UpdateSpineText()
  self:CheckTipsText()
end

function UILWDominatorCockatriceUnlockMainView:UpdateSpineText()
  local info = DataCenter.DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
  if info then
    if info.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
      self.textGuide:SetLocalText("war_eagle_event_desc_5")
    else
      self.textGuide:SetLocalText("war_eagle_event_desc_4")
    end
  else
    local curGroupIndex = DataCenter.DominatorCockatriceUnlockManager:GetCurFinishedNormalQuestGroupIndex()
    local nextGroupIndex = curGroupIndex + 1
    local nextGroupState = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(nextGroupIndex)
    if nextGroupState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Going then
      self.textGuide:SetLocalText("war_eagle_event_desc_2", tostring(nextGroupIndex))
    elseif nextGroupState == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Locked then
      self.textGuide:SetLocalText("war_eagle_event_desc_3")
    end
  end
end

function UILWDominatorCockatriceUnlockMainView:UpdateHornContent()
  local isFinishedAllNormal = DataCenter.DominatorCockatriceUnlockManager:IsFinishedAllNormalQuest()
  self.compFragmentContent:SetActive(not isFinishedAllNormal)
  self.compLine:SetActive(not isFinishedAllNormal)
  self:UpdateHornImage()
  if isFinishedAllNormal then
    local finalDetectInfo = DataCenter.DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
    self.btnGoFinal:SetActive(finalDetectInfo ~= nil and (finalDetectInfo.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or finalDetectInfo.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD))
    self.slider:SetValue(1)
    self.textProgress:SetText("100%")
    self.compEffUiCockatriceComplete:SetActive(true)
    self.compEffUiCockatriceComplete:SetAnchoredPositionXY(CommonUtil.IsArabicAutoMirrorOpen() and 28.09 or 0, 0)
    return
  end
  self.btnGoFinal:SetActive(false)
  self.compEffUiCockatriceComplete:SetActive(false)
  self:UpdateAllHornItem()
  local curFinishedIndex = DataCenter.DominatorCockatriceUnlockManager:GetCurFinishedNormalQuestGroupIndex()
  self.slider:SetValue(curFinishedIndex / 4)
  self.textProgress:SetText(tostring(math.floor(curFinishedIndex / 4 * 100)) .. "%")
end

function UILWDominatorCockatriceUnlockMainView:UpdateAllHornItem()
  self.compFragment01:ReInit(1)
  self.compFragment02:ReInit(2)
  self.compFragment03:ReInit(3)
  self.compFragment04:ReInit(4)
end

function UILWDominatorCockatriceUnlockMainView:UpdateHornImage()
  local state01 = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(1)
  self.imgHorn01:SetActive(state01 == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Finished)
  local state02 = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(2)
  self.imgHorn02:SetActive(state02 == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Finished)
  local state03 = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(3)
  self.imgHorn03:SetActive(state03 == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Finished)
  local state04 = DataCenter.DominatorCockatriceUnlockManager:GetTaskGroupState(4)
  self.imgHorn04:SetActive(state04 == DataCenter.DominatorCockatriceUnlockManager.TaskGroupState.Finished)
end

function UILWDominatorCockatriceUnlockMainView:UpdateClaimContent()
  self.btnGoFinal:SetActive(false)
  self:ClearRewards()
  local info = DataCenter.DominatorCockatriceUnlockManager:GetFinalDetectEventInfo()
  if info then
    local rewardList = {}
    for k, v in ipairs(info.rewardList) do
      table.insert(rewardList, v)
    end
    self:UpdateRewards(rewardList)
  end
end

function UILWDominatorCockatriceUnlockMainView:DoGetEventRealPoint(uuid)
  if self.targetJumpUuid == uuid then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
    if data ~= nil and data.state ~= DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      self.ctrl:GotoDetectEvent(uuid)
      GoToUtil.CloseAllWindows()
    end
  end
end

function UILWDominatorCockatriceUnlockMainView:ClearRewards()
  if self.rewardRequests then
    if self.compContent then
      self.compContent:RemoveComponents(UICommonResItem)
    end
    for i, v in pairs(self.rewardRequests) do
      v:Destroy()
    end
  end
  self.rewardRequests = nil
end

function UILWDominatorCockatriceUnlockMainView:UpdateRewards(rewards)
  local index = 1
  self.rewardRequests = {}
  for _, v in ipairs(rewards) do
    local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      if self.compContent == nil then
        return
      end
      go.transform:SetParent(self.compContent.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_sizeDelta(150, 150)
      go.name = "item_" .. tostring(index)
      local cell = self.compContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(v)
      index = index + 1
    end)
    table.insert(self.rewardRequests, request)
  end
end

function UILWDominatorCockatriceUnlockMainView:OnGetDetectReward(evtData)
  if evtData then
    if evtData.eventUuid then
      local curGuideId = DataCenter.DominatorCockatriceUnlockManager:GetCurGuideId()
      if curGuideId == DominatorCockatriceUnlockProgress.GetWorker then
      else
        self.ctrl:CloseSelf()
      end
    end
    DataCenter.RewardManager:ShowCommonReward(evtData, nil, nil, nil, nil, nil, function()
      EventManager:GetInstance():Broadcast(EventId.DominatorCockatriceUnlockClaimQuestGroupReward)
    end)
  end
end

function UILWDominatorCockatriceUnlockMainView:OnGetQuestReward()
  self:UpdateContent()
end

function UILWDominatorCockatriceUnlockMainView:OnArchiveUnlock()
  self:UpdateArchiveBtn()
end

function UILWDominatorCockatriceUnlockMainView:OnClaimQuestGroupReward()
  local groupIndex = DataCenter.DominatorCockatriceUnlockManager:GetCurFinishedNormalQuestGroupIndex()
  if groupIndex then
    if groupIndex == 1 then
      self.animatorUILWDominatorCockatriceUnlockMain:Play("V_uiUILWDominatorCockatriceUnlockMain_horn1")
    elseif groupIndex == 2 then
      self.animatorUILWDominatorCockatriceUnlockMain:Play("V_uiUILWDominatorCockatriceUnlockMain_horn2")
    elseif groupIndex == 3 then
      self.animatorUILWDominatorCockatriceUnlockMain:Play("V_uiUILWDominatorCockatriceUnlockMain_horn3")
    elseif groupIndex == 4 then
      self.animatorUILWDominatorCockatriceUnlockMain:Play("V_uiUILWDominatorCockatriceUnlockMain_horn4")
    end
    self:StopDelayTimer()
    self.delayUpdateTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:UpdateContent()
    end, 1.5)
    self.delayUpdateTimer:Start()
    self.delayTriggerGuideTimer = TimerManager:GetInstance():DelayInvoke(function()
      if groupIndex == 1 then
        self:TryTriggerArchiveGuide()
      end
    end, 2.5)
    self.delayTriggerGuideTimer:Start()
  end
end

function UILWDominatorCockatriceUnlockMainView:TryTriggerArchiveGuide()
  if not DataCenter.DominatorCockatriceUnlockManager:IsHasShownArchiveGuide() then
    if not DataCenter.LWGuideFlowManager.Runner:IsRun() and not DataCenter.LWGuideFlowManager:ReadDone(5018) then
      DataCenter.LWGuideFlowManager.Runner:Run(5018)
    end
    DataCenter.DominatorCockatriceUnlockManager:SetHasShownArchiveGuide()
  end
end

function UILWDominatorCockatriceUnlockMainView:StopDelayTimer()
  if self.delayUpdateTimer ~= nil then
    self.delayUpdateTimer:Stop()
    self.delayUpdateTimer = nil
  end
  if self.delayTriggerGuideTimer ~= nil then
    self.delayTriggerGuideTimer:Stop()
    self.delayTriggerGuideTimer = nil
  end
end

function UILWDominatorCockatriceUnlockMainView:OnPushDominatorInfo()
  self:UpdateArchiveBtn()
  if self.delayUpdateTimer == nil or not self.delayUpdateTimer:IsOver() then
  else
  end
end

return UILWDominatorCockatriceUnlockMainView
