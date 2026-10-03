local UILWDominatorCockatriceUnlockView = BaseClass("UILWDominatorCockatriceUnlockView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWDominatorCockatriceUnlockItemComponent = require("UI.UILWDominator.CockatriceUnlock.Detail.Component.UILWDominatorCockatriceUnlockItemComponent")

function UILWDominatorCockatriceUnlockView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorCockatriceUnlockView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorCockatriceUnlockView:ComponentDefine()
  self.btnUICommonBlackMask = self:AddComponent(UIButton, "UICommonBlackMask")
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compFragment01 = self:AddComponent(UILWDominatorCockatriceUnlockItemComponent, "Root/Map/Fragment01")
  self.compFragment02 = self:AddComponent(UILWDominatorCockatriceUnlockItemComponent, "Root/Map/Fragment02")
  self.compFragment03 = self:AddComponent(UILWDominatorCockatriceUnlockItemComponent, "Root/Map/Fragment03")
  self.compFragment04 = self:AddComponent(UILWDominatorCockatriceUnlockItemComponent, "Root/Map/Fragment04")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/TitleText")
  self.compEmpty = self:AddComponent(UIBaseContainer, "Root/Bottom/Empty")
  self.textEmpty = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/Empty/EmptyText")
  self.compTask = self:AddComponent(UIBaseContainer, "Root/Bottom/Task")
  self.textTaskTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/Task/TaskTitleText")
  self.textTaskDes = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/Task/TaskDesText")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/Bottom/Task/Rewards/Viewport/Content")
  self.btnGo = self:AddComponent(UIButton, "Root/Bottom/Task/GoBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textGo = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/Task/GoBtn/LW_Btn_Common_New_Base/GoText")
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/TipsText")
  self.btnLWClose = self:AddComponent(UIButton, "Root/LW_Btn_Close")
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnClaim = self:AddComponent(UIButton, "Root/Bottom/Task/ClaimBtn")
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.textClaim = self:AddComponent(UITextMeshProUGUIEx, "Root/Bottom/Task/ClaimBtn/LW_Btn_Common_New_Base/ClaimText")
  self.rawImgBackground = self:AddComponent(UIRawImage, "Root/Map/Background")
  self.compEffUiCockatriceKuang = self:AddComponent(UIBaseContainer, "Root/Bottom/Eff_ui_cockatrice_kuang")
  self.compEffUiCockatriceShow01 = self:AddComponent(UIBaseContainer, "Root/Map/Eff_ui_cockatrice_show01")
  self.compEffUiCockatriceShow02 = self:AddComponent(UIBaseContainer, "Root/Map/Eff_ui_cockatrice_show02")
  self.compEffUiCockatriceShow03 = self:AddComponent(UIBaseContainer, "Root/Map/Eff_ui_cockatrice_show03")
  self.compEffUiCockatriceShow04 = self:AddComponent(UIBaseContainer, "Root/Map/Eff_ui_cockatrice_show04")
  self.compEffUiCockatriceSaoguang = self:AddComponent(UIBaseContainer, "Root/Bottom/Eff_ui_cockatrice_saoguang")
  self.textTitle:SetLocalText("war_eagle_event_title_10")
  self.textEmpty:SetLocalText("war_eagle_event_desc_11")
  self.textGo:SetLocalText("450004")
  self.textClaim:SetLocalText("129054")
  self.textTips:SetLocalText("war_eagle_event_desc_12")
  self.compEffUiCockatriceKuang:SetActive(false)
  self.compEffUiCockatriceSaoguang:SetActive(false)
end

function UILWDominatorCockatriceUnlockView:ComponentDestroy()
  self:ClearRewards()
  self.btnUICommonBlackMask = nil
  self.compFragment01 = nil
  self.compFragment02 = nil
  self.compFragment03 = nil
  self.compFragment04 = nil
  self.textTitle = nil
  self.compEmpty = nil
  self.textEmpty = nil
  self.compTask = nil
  self.textTaskTitle = nil
  self.textTaskDes = nil
  self.compContent = nil
  self.btnGo = nil
  self.textGo = nil
  self.textTips = nil
  self.btnLWClose = nil
  self.btnClaim = nil
  self.textClaim = nil
  self.rawImgBackground = nil
  self.compEffUiCockatriceKuang = nil
  self.compEffUiCockatriceShow01 = nil
  self.compEffUiCockatriceShow02 = nil
  self.compEffUiCockatriceShow03 = nil
  self.compEffUiCockatriceShow04 = nil
  self.compEffUiCockatriceSaoguang = nil
end

function UILWDominatorCockatriceUnlockView:DataDefine()
  self.targetJumpUuid = nil
end

function UILWDominatorCockatriceUnlockView:DataDestroy()
  self.targetJumpUuid = nil
  self:StopDelayUpdateTimer()
end

function UILWDominatorCockatriceUnlockView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DetectEventGetRealPoint, self.DoGetEventRealPoint)
  self:AddUIListener(EventId.DominatorCockatriceUnlockClaimQuestGroupReward, self.OnGetDetectReward)
  self:AddUIListener(EventId.ShowTaskSuccessReward, self.OnClaimTask)
  self:AddUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:AddUIListener(EventId.DominatorCockatriceUnlockClaimTaskReward, self.OnTaskRewardClose)
end

function UILWDominatorCockatriceUnlockView:OnRemoveListener()
  self:RemoveUIListener(EventId.DetectEventGetRealPoint, self.DoGetEventRealPoint)
  self:RemoveUIListener(EventId.DominatorCockatriceUnlockClaimQuestGroupReward, self.OnGetDetectReward)
  self:RemoveUIListener(EventId.ShowTaskSuccessReward, self.OnClaimTask)
  self:RemoveUIListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:RemoveUIListener(EventId.DominatorCockatriceUnlockClaimTaskReward, self.OnTaskRewardClose)
  base.OnRemoveListener(self)
end

function UILWDominatorCockatriceUnlockView:OnOpen()
  self.groupIndex = self:GetUserData()
  if not self.groupIndex then
    self.ctrl:CloseSelf()
    return
  end
  local questDict = DataCenter.DominatorCockatriceUnlockManager:GetAllNormalQuestIdDict()
  self.questIds = questDict[self.groupIndex]
  if not self.questIds then
    self.ctrl:CloseSelf()
    return
  end
  self.selectIndex = 0
  local backgroundPath = DataCenter.DominatorCockatriceUnlockManager:GetQuestGroupBackgroundPath(self.groupIndex)
  if not string.IsNullOrEmpty(backgroundPath) then
    self.rawImgBackground:LoadSprite(backgroundPath)
  end
  self:UpdateAll()
  DataCenter.RadarCenterDataManager:GetDetectEventData()
  DataCenter.DominatorCockatriceUnlockManager:SetCurClaimingTaskIndex(nil)
  DataCenter.DominatorCockatriceUnlockManager:SetCurClaimingQuestGroupIndex(nil)
end

function UILWDominatorCockatriceUnlockView:UpdateAll()
  self:UpdateItems()
  self:UpdateSelection()
  self:UpdateDetailContent()
end

function UILWDominatorCockatriceUnlockView:UpdateItems()
  self.compFragment01:ReInit(self.questIds[1], 1)
  self.compFragment02:ReInit(self.questIds[2], 2)
  self.compFragment03:ReInit(self.questIds[3], 3)
  self.compFragment04:ReInit(self.questIds[4], 4)
end

function UILWDominatorCockatriceUnlockView:UpdateSelection()
  self.compFragment01:UpdateSelection(self.selectIndex == 1)
  self.compFragment02:UpdateSelection(self.selectIndex == 2)
  self.compFragment03:UpdateSelection(self.selectIndex == 3)
  self.compFragment04:UpdateSelection(self.selectIndex == 4)
end

function UILWDominatorCockatriceUnlockView:UpdateDetailContent(playEff)
  if self.selectIndex == 0 then
    self:UpdateDetailContentEmptySelect(playEff)
  else
    self:UpdateDetailContentHasSelect(playEff)
  end
end

function UILWDominatorCockatriceUnlockView:UpdateDetailContentEmptySelect(playEff)
  local isFinishedGroupQuest = DataCenter.DominatorCockatriceUnlockManager:IsFinishedNormalQuestTaskByIndex(self.groupIndex)
  if isFinishedGroupQuest then
    self.compEmpty:SetActive(false)
    self.compTask:SetActive(true)
    self.compEffUiCockatriceKuang:SetActive(true)
    if playEff then
      self:UpdateBackgroundEffect(false)
    else
      self:UpdateBackgroundEffect(true)
    end
    local eventId = DataCenter.DominatorCockatriceUnlockManager:GetNormalDetectEventIdByIndex(self.groupIndex)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(tostring(eventId))
    if not template then
      return
    end
    self.textTaskTitle:SetText(template:GetRealName())
    self.textTaskDes:SetLocalText(template.description)
    self:ClearRewards()
    local eventInfoArray = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
    if eventInfoArray[1] then
      local eventInfo = eventInfoArray[1]
      local rewardList = {}
      for k, v in ipairs(eventInfo.rewardList) do
        table.insert(rewardList, v)
      end
      self:UpdateRewards(rewardList)
      local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(eventInfo.uuid)
      local isCanGoType = eventInfo.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or eventInfo.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD
      self.btnGo:SetActive(isCanGoType and not isGoto)
      self.btnClaim:SetActive(eventInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
    end
  else
    self.compEmpty:SetActive(true)
    self.compTask:SetActive(false)
    self:UpdateBackgroundEffect(true)
    self.compEffUiCockatriceKuang:SetActive(false)
  end
end

function UILWDominatorCockatriceUnlockView:UpdateDetailContentHasSelect(playEff)
  self.compEmpty:SetActive(false)
  self.compTask:SetActive(true)
  self.compEffUiCockatriceKuang:SetActive(false)
  self:UpdateBackgroundEffect(true)
  local questId = self.questIds[self.selectIndex]
  local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
  if not questTemplate then
    return
  end
  local taskData = DataCenter.TaskManager:FindTaskInfo(questId)
  self.btnGo:SetActive(taskData ~= nil and taskData.state == TaskState.NoComplete)
  self.btnClaim:SetActive(taskData ~= nil and taskData.state == TaskState.CanReceive)
  self.textTaskDes:SetActive(taskData ~= nil)
  self.textTaskTitle:SetActive(taskData ~= nil)
  self.compContent:SetActive(taskData ~= nil)
  if taskData == nil then
    return
  end
  local desc = questTemplate:GetDesc(false)
  local curNum = taskData.num and taskData.num or 0
  local targetNum = QuestUtil.GetTargetNum(questTemplate)
  if curNum >= targetNum then
    curNum = targetNum
  end
  curNum = string.GetFormattedSeperatorNum(curNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  local process = string.format("(%s/%s)", curNum, targetNum)
  desc = desc .. process
  self.textTaskDes:SetText(desc)
  self.textTaskTitle:SetLocalText(questTemplate.name)
  self:ClearRewards()
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(questId)
  if taskInfo and taskInfo.rewardList then
    local list = {}
    if not table.IsNullOrEmpty(taskInfo.rewardList) then
      list = DataCenter.RewardManager:RewardItemList(taskInfo.rewardList)
    end
    self:UpdateRewards(list)
  end
  if playEff then
    self.compEffUiCockatriceSaoguang:SetActive(false)
    self.compEffUiCockatriceSaoguang:SetActive(true)
  end
end

function UILWDominatorCockatriceUnlockView:ClearRewards()
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

function UILWDominatorCockatriceUnlockView:UpdateRewards(rewards)
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

function UILWDominatorCockatriceUnlockView:SetSelectIndex(index)
  if self.selectIndex == index then
    return
  end
  self.selectIndex = index
  self:UpdateSelection()
  self:UpdateDetailContent()
end

function UILWDominatorCockatriceUnlockView:DoGetEventRealPoint(uuid)
  if self.targetJumpUuid == uuid then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
    if data ~= nil and data.state ~= DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      self.ctrl:GotoDetectEvent(uuid)
      GoToUtil.CloseAllWindows()
    end
  end
end

function UILWDominatorCockatriceUnlockView:GetDefaultIndex()
  if self.questIds then
    for i, v in ipairs(self.questIds) do
      local taskData = DataCenter.TaskManager:FindTaskInfo(v)
      if taskData and taskData.state ~= TaskState.Received then
        return i
      end
    end
  end
  return 0
end

function UILWDominatorCockatriceUnlockView:OnTaskRewardClose()
  local claimTaskIndex = DataCenter.DominatorCockatriceUnlockManager:GetCurClaimingTaskIndex()
  if claimTaskIndex then
    if claimTaskIndex == 1 then
      self.compFragment01:PlayUnlockAnim()
    elseif claimTaskIndex == 2 then
      self.compFragment02:PlayUnlockAnim()
    elseif claimTaskIndex == 3 then
      self.compFragment03:PlayUnlockAnim()
    elseif claimTaskIndex == 4 then
      self.compFragment04:PlayUnlockAnim()
    end
  end
  self:StopDelayUpdateTimer()
  self.delayUpdateTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.selectIndex = self:GetDefaultIndex()
    self:UpdateSelection()
    self:UpdateDetailContent(true)
    self:UpdateItems()
  end, 1)
  self.delayUpdateTimer:Start()
end

function UILWDominatorCockatriceUnlockView:OnClaimTask(message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, nil, nil, function()
      EventManager:GetInstance():Broadcast(EventId.DominatorCockatriceUnlockClaimTaskReward)
    end)
  end
end

function UILWDominatorCockatriceUnlockView:StopDelayUpdateTimer()
  if self.delayUpdateTimer ~= nil then
    self.delayUpdateTimer:Stop()
    self.delayUpdateTimer = nil
  end
end

function UILWDominatorCockatriceUnlockView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorCockatriceUnlockView:OnBtnGoClick()
  if self.selectIndex ~= 0 then
    local questId = self.questIds[self.selectIndex]
    local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(questId)
    if questTemplate then
      local goType = tonumber(questTemplate.gotype2)
      local goPara = questTemplate.gopara
      GoToUtil.GoToByTypeAndParam(goType, goPara, questTemplate)
    end
  else
    local isAllFinished = DataCenter.DominatorCockatriceUnlockManager:IsFinishedNormalQuestGroupByIndex(self.groupIndex)
    if not isAllFinished then
      local eventId = DataCenter.DominatorCockatriceUnlockManager:GetNormalDetectEventIdByIndex(self.groupIndex)
      local eventInfoArray = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
      if eventInfoArray[1] then
        local eventInfo = eventInfoArray[1]
        if eventInfo.template and eventInfo.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_2 then
          self.plotGroupId = checknumber(eventInfo.template.para2)
          if 0 < self.plotGroupId then
            EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
              plotGroupId = self.plotGroupId,
              hideMainUI = false
            })
          else
            self:GotoDetectEvent()
          end
        else
          self:GotoDetectEvent()
        end
      end
    end
  end
end

function UILWDominatorCockatriceUnlockView:OnPlotGroupDone(plotGroupId)
  if self.plotGroupId and self.plotGroupId == plotGroupId then
    self:GotoDetectEvent()
  end
end

function UILWDominatorCockatriceUnlockView:GotoDetectEvent()
  local eventId = DataCenter.DominatorCockatriceUnlockManager:GetNormalDetectEventIdByIndex(self.groupIndex)
  local eventInfoArray = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
  if eventInfoArray[1] then
    self.targetJumpUuid = eventInfoArray[1].uuid
    local closeNow = self.ctrl:GotoDetectEvent(eventInfoArray[1].uuid)
    if closeNow then
      GoToUtil.CloseAllWindows()
    end
  end
end

function UILWDominatorCockatriceUnlockView:OnBtnLWCloseClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorCockatriceUnlockView:OnBtnClaimClick()
  if self.selectIndex ~= 0 and self.questIds then
    local questId = self.questIds[self.selectIndex]
    local taskInfo = DataCenter.TaskManager:FindTaskInfo(questId)
    if taskInfo and taskInfo.state == TaskState.CanReceive then
      local data = {}
      data.id = taskInfo.id
      local rewardPos = self.btnClaim.transform.position
      DataCenter.ChapterTaskManager:QuestGetReward(data, rewardPos)
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
      DataCenter.DominatorCockatriceUnlockManager:SetCurClaimingTaskIndex(self.selectIndex)
    end
  else
    local isFinishedGroupQuest = DataCenter.DominatorCockatriceUnlockManager:IsFinishedNormalQuestTaskByIndex(self.groupIndex)
    if isFinishedGroupQuest then
      local eventId = DataCenter.DominatorCockatriceUnlockManager:GetNormalDetectEventIdByIndex(self.groupIndex)
      local eventInfoArray = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(eventId)
      if eventInfoArray[1] then
        local eventInfo = eventInfoArray[1]
        if eventInfo and eventInfo.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
          if not LuaEntry.Player:IsInSelfServer() then
            UIUtil.ShowTipsId("war_eagle_event_desc_16")
            return
          end
          DataCenter.RadarCenterDataManager:ClaimDetectEventRewardByEventData(eventInfo)
          DataCenter.DominatorCockatriceUnlockManager:SetCurClaimingQuestGroupIndex(self.groupIndex)
        end
      end
    end
  end
end

function UILWDominatorCockatriceUnlockView:OnGetDetectReward(evtData)
  self.ctrl:CloseSelf()
end

function UILWDominatorCockatriceUnlockView:GetBackgroundMaterialPath()
  if self.groupIndex == 1 then
    return "Assets/_Art_LastWar/Effect/Material/Material_Wsh/ui/ui_04/Eff_mat_shape_cockatrice_photo_1.mat"
  elseif self.groupIndex == 2 then
    return "Assets/_Art_LastWar/Effect/Material/Material_Wsh/ui/ui_04/Eff_mat_shape_cockatrice_photo_2.mat"
  elseif self.groupIndex == 3 then
    return "Assets/_Art_LastWar/Effect/Material/Material_Wsh/ui/ui_04/Eff_mat_shape_cockatrice_photo_3.mat"
  elseif self.groupIndex == 4 then
    return "Assets/_Art_LastWar/Effect/Material/Material_Wsh/ui/ui_04/Eff_mat_shape_cockatrice_photo_4.mat"
  end
end

function UILWDominatorCockatriceUnlockView:UpdateBackgroundEffect(hideAll)
  if hideAll then
    self.compEffUiCockatriceShow01:SetActive(false)
    self.compEffUiCockatriceShow02:SetActive(false)
    self.compEffUiCockatriceShow03:SetActive(false)
    self.compEffUiCockatriceShow04:SetActive(false)
  else
    self.compEffUiCockatriceShow01:SetActive(self.groupIndex == 1)
    self.compEffUiCockatriceShow02:SetActive(self.groupIndex == 2)
    self.compEffUiCockatriceShow03:SetActive(self.groupIndex == 3)
    self.compEffUiCockatriceShow04:SetActive(self.groupIndex == 4)
  end
end

return UILWDominatorCockatriceUnlockView
