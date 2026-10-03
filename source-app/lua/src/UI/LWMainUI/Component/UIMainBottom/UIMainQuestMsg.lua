local UIMainQuestMsg = BaseClass("UIMainQuestMsg", UIBaseContainer)
local base = UIBaseContainer
local recordId = {
  [1] = "1001762",
  [2] = "11015301",
  [3] = "1001750",
  [4] = "1001763",
  [5] = "1003820",
  [6] = "1001765",
  [7] = "1001761"
}
local EffectWaitTime = 0.3
local warningBall = 999

function UIMainQuestMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainQuestMsg:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainQuestMsg:OnEnable()
  base.OnEnable(self)
end

function UIMainQuestMsg:OnDisable()
  base.OnDisable(self)
end

function UIMainQuestMsg:GetQuest(callBackQuest)
  self.callBackQuest = callBackQuest
  self.questType = 0
end

function UIMainQuestMsg:GetBall(callBackBall)
  self.callBackBall = callBackBall
end

function UIMainQuestMsg:MoveContent(callBackMove)
  self.callBackMove = callBackMove
end

function UIMainQuestMsg:ReInit(msgList)
  self.msgList = msgList
end

function UIMainQuestMsg:ComponentDefine()
  self.animObj = self:AddComponent(UIBaseContainer, "")
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.anim:PlayAnimationReturnTime("Default")
  self._chapterDes_txt = self:AddComponent(UIText, "Btn_ChapterMsg/Txt_ChapterDes")
  self._chapterIcon_img = self:AddComponent(UIImage, "Btn_ChapterMsg/Img_ChapterIcon")
  self._chapterProgress_txt = self:AddComponent(UIText, "Btn_ChapterMsg/Txt_ChapterProgress")
  self._chapterMsg_btn = self:AddComponent(UIButton, "Btn_ChapterMsg")
  self._chapterMsg_btn:SetOnClick(function()
    self:OnClickMsg()
  end)
  self._effectClick_rect = self:AddComponent(UIBaseContainer, "Btn_ChapterMsg/Rect_EffectClick")
end

function UIMainQuestMsg:ComponentDestroy()
end

function UIMainQuestMsg:DataDefine()
  self.clickType = 0
  self.quest_hide = LuaEntry.DataConfig:TryGetNum("quest_pre", "k2")
  
  function self.timer_taskHide_action(temp)
    self:AutoHideTaskTime()
  end
  
  self.questGuidId = LuaEntry.DataConfig:TryGetNum("quest_pre", "k6")
  self.isGuid = false
  self.isNewOpen = DataCenter.ChapterTaskCellManager:CheckNewSwitch()
  self.isPvePowerState = false
end

function UIMainQuestMsg:DataDestroy()
end

function UIMainQuestMsg:RefreshQuestInfo(state, taskData)
  self.animObj:SetActive(true)
  if state == UIMainQuestState.Quest or state == UIMainQuestState.BubbleQuest then
    local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
    self._chapterDes_txt:SetText(questTemplate:GetDesc())
    self._chapterIcon_img:LoadSprite(questTemplate:GetIconPath())
    self._chapterIcon_img:SetActive(true)
    self._chapterProgress_txt:SetActive(tonumber(questTemplate.progressshow) == 1)
    local num = 0
    if taskData.num >= questTemplate.para2 then
      num = questTemplate.para2
    else
      num = taskData.num
    end
    self._chapterProgress_txt:SetText(string.format("(%d/%d)", num, questTemplate.para2))
  elseif state == UIMainQuestState.ChapterReward then
    self._chapterProgress_txt:SetActive(false)
    self._chapterIcon_img:SetActive(false)
    self._chapterDes_txt:SetLocalText(170459)
  end
  self._effectClick_rect:SetActive(false)
end

function UIMainQuestMsg:GetCurMsgTaskId()
  if self.taskData then
    return self.taskData.id
  end
  return nil
end

function UIMainQuestMsg:Update()
  local pos
  if self.state == UIMainQuestState.WarningBall then
    local ballObj = self.callBackBall()
    pos = ballObj.transform.position
  elseif self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.ChapterReward or self.state == UIMainQuestState.BubbleQuest then
    local questCell = self.callBackQuest()
    if questCell then
      for i = 1, #questCell do
        if questCell[i].chapterType == self.questType then
          pos = questCell[i].transform.position
          break
        end
      end
    end
  end
  if pos ~= nil then
    self.animObj.transform.position = pos
  end
end

function UIMainQuestMsg:DoMove(index, state, callBack)
  self.callBackMove(index, state, callBack)
end

function UIMainQuestMsg:PlayTaskShow(state, taskData, chapterType, pos, type, callBack, index)
  self:DeleteAutoHideTimer()
  self:RemoveFingerArrow()
  self.state = state
  self.taskData = taskData
  self:RefreshQuestInfo(state, taskData)
  self.animObj.transform.position = pos
  self.questType = chapterType
  if type == 1 then
    if callBack then
      self.callBackMove(index, true, callBack)
    end
    self.anim:Play("TaskShow")
    self:AddTaskHideTimer()
    if taskData then
      local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
      if chapterId <= 3 and state ~= UIMainQuestState.ChapterReward and taskData then
        local id = "2001" .. taskData.id
        DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
      end
    end
  else
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    if chapterId <= 3 and state ~= UIMainQuestState.ChapterReward and taskData then
      local id = "2002" .. taskData.id
      DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
    end
    if callBack then
      self.callBackMove(index, true, callBack)
    end
    self.anim:Play("TaskShow2")
  end
  self.isClick = false
  self:ShowFingerArrow()
  if self.state == UIMainQuestState.ChapterReward then
    self:PlayChapterReward()
  end
end

function UIMainQuestMsg:PlayTaskShowBox(type)
  self:DeleteAutoHideTimer()
  self._effectClick_rect:SetActive(false)
  self.isClick = false
  if type == 1 then
    self.anim:Play("BoxShow")
  else
    self.anim:Play("BoxJup")
  end
end

function UIMainQuestMsg:PlayTaskHide(chapterType, pos)
  self:DeleteAutoHideTimer()
  self:DeleteBoxTimer()
  self:RemoveFingerArrow()
  self.animObj.transform.position = pos
  self.questType = 0
  self.state = 0
  self.anim:Play("TaskHide")
end

function UIMainQuestMsg:PlayTaskHideBox(state, taskData, chapterType, pos)
  self:DeleteAutoHideTimer()
  self:DeleteBoxTimer()
  self:RemoveFingerArrow()
  self.state = state
  self.taskData = taskData
  self:RefreshQuestInfo(state, taskData)
  self.animObj.transform.position = pos
  self.questType = 0
  self.state = 0
  self.anim:Play("TaskHide2")
end

function UIMainQuestMsg:PlayTaskDefault()
  self:DeleteAutoHideTimer()
  self:DeleteBoxTimer()
  self:RemoveFingerArrow()
  if not self.isGuid then
    self.state = 0
    self.questType = 0
    self.anim:Play("Default")
  end
end

function UIMainQuestMsg:ClickTask(state, taskData, chapterType, pos, isGuid, isMove, index)
  self:DeleteAutoHideTimer()
  self:DeleteBoxTimer()
  self:RemoveFingerArrow()
  self:DeleteAutoGetTimer()
  if self.changeTimer then
    self.changeTimer:Stop()
    self.changeTimer = nil
  end
  self.isGuid = isGuid
  self._effectClick_rect:SetActive(false)
  self.isPvePowerState = DataCenter.ChapterTaskCellManager:GetPvePowerState()
  DataCenter.ChapterTaskCellManager:SetPvePowerState(false)
  self.isClick = false
  if isMove then
    self.callBackMove(index, true, isMove)
  end
  if self.questType == chapterType then
    self.state = state
    self.taskData = taskData
    self.animObj.transform.position = pos
    self:RefreshQuestInfo(state, taskData)
    DataCenter.TaskManager:SetTaskMsg(false)
    if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
      if self.taskData.state == TaskState.CanReceive then
        self.anim:Play("TaskHide2")
      else
        self.anim:Play("TaskHide")
      end
    elseif self.state == UIMainQuestState.ChapterReward then
      self.anim:Play("TaskHide2")
    end
    self.questType = 0
    self.state = 0
  elseif self.questType ~= 0 then
    if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
      if self.taskData.state == TaskState.CanReceive then
        self.anim:Play("TaskHide2")
      else
        self.anim:Play("TaskHide")
      end
    elseif self.state == UIMainQuestState.ChapterReward then
      self.anim:Play("TaskHide2")
    elseif self.state == UIMainQuestState.WarningBall then
      self.anim:Play("TaskHide")
    end
    self.changeTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.changeTimer then
        self.changeTimer:Stop()
        self.changeTimer = nil
      end
      self.state = state
      self.taskData = taskData
      self.animObj.transform.position = pos
      self:RefreshQuestInfo(state, taskData)
      self.questType = chapterType
      if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
        if self.taskData.state == TaskState.CanReceive then
          self.anim:Play("TaskShow2")
          self:AutoGetReward()
          local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
          if chapterId <= 3 and state ~= UIMainQuestState.ChapterReward and taskData then
            local id = "2002" .. taskData.id
            DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
          end
        else
          self.anim:Play("TaskShow")
          if not isGuid then
            self:AddTaskHideTimer()
          end
          if taskData then
            local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
            if chapterId <= 3 and state ~= UIMainQuestState.ChapterReward and taskData then
              local id = "2001" .. taskData.id
              DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
            end
          end
        end
        self:ShowFingerArrow()
      elseif self.state == UIMainQuestState.ChapterReward then
        self.anim:Play("TaskShow2")
        self:AutoGetReward()
      end
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Task_Show, false)
    end, 0.2)
  else
    DataCenter.TaskManager:SetTaskMsg(true)
    self.state = state
    self.taskData = taskData
    self.animObj.transform.position = pos
    self:RefreshQuestInfo(state, taskData)
    self.questType = chapterType
    self.anim:Stop()
    if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
      if self.taskData.state == TaskState.CanReceive then
        self.anim:Play("TaskShow2")
        self:AutoGetReward()
        local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
        if chapterId <= 3 and state ~= UIMainQuestState.ChapterReward and taskData then
          local id = "2002" .. taskData.id
          DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
        end
      else
        self.anim:Play("TaskShow")
        if not isGuid then
          self:AddTaskHideTimer()
        end
        if taskData then
          local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
          if chapterId <= 3 and state ~= UIMainQuestState.ChapterReward and taskData then
            local id = "2001" .. taskData.id
            DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
          end
        end
      end
      self:ShowFingerArrow()
    elseif self.state == UIMainQuestState.ChapterReward then
      self.anim:Play("TaskShow2")
      self:PlayChapterReward()
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Task_Show, false)
  end
end

function UIMainQuestMsg:AutoGetReward()
  if self.isNewOpen then
    local ret1, time1 = self.anim:GetAnimationReturnTime("TaskShow2")
    if ret1 then
      self.autoGet = TimerManager:GetInstance():DelayInvoke(function()
        self:OnClickMsg()
        if self.autoGet then
          self.autoGet:Stop()
          self.autoGet = nil
        end
      end, time1 + 0.5)
    end
  end
end

function UIMainQuestMsg:DeleteAutoGetTimer()
  if self.autoGet then
    self.autoGet:Stop()
    self.autoGet = nil
  end
end

function UIMainQuestMsg:PlayChapterReward()
  local ret1, time1 = self.anim:GetAnimationReturnTime("TaskShow2")
  if ret1 then
    self.boxJup = TimerManager:GetInstance():DelayInvoke(function()
      self:PlayTaskShowBox(2)
      self:AutoGetReward()
      if self.boxJup then
        self.boxJup:Stop()
        self.boxJup = nil
      end
    end, time1)
  end
end

function UIMainQuestMsg:DeleteBoxTimer()
  if self.boxShow then
    self.boxShow:Stop()
    self.boxShow = nil
  end
  if self.boxJup then
    self.boxJup:Stop()
    self.boxJup = nil
  end
end

function UIMainQuestMsg:OnClickMsg()
  self:DeleteBoxTimer()
  self.clickType = self.state
  if self.state == UIMainQuestState.WarningBall then
    if self.ballData then
      self.view.ctrl:OnWarningBallClick(self.ballData.msgType)
    end
    self.ballData = nil
    self.questType = 0
    self.state = 0
    self.anim:Play("TaskHide")
    DataCenter.WarningBallManager:SetBallMsg(false)
  end
  self:DeleteAutoHideTimer()
  self:RemoveFingerArrow()
  self.isClick = true
  DataCenter.TaskManager:SetTaskMsg(false)
  local questType = self.questType
  local state = self.state
  local taskData = self.taskData
  self.questType = 0
  self.state = 0
  if state == UIMainQuestState.ChapterReward then
    self:ChapterGetReward(questType)
  elseif state == UIMainQuestState.Quest or state == UIMainQuestState.BubbleQuest then
    if taskData.state == TaskState.CanReceive then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
      self._effectClick_rect:SetActive(true)
      self:QuestGetReward(questType, taskData, state)
    else
      self:QuestGoto(questType)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OnClickMsgNew, self.clickType)
end

function UIMainQuestMsg:ChapterGetReward(questType)
  local param = {}
  param.chapterId = DataCenter.ChapterTaskManager.chapterId
  local flag = DataCenter.GuideManager:GetSaveGuideValue(SaveNoShowGarbage)
  if flag == SaveGuideDoneValue then
    param.garbageRefresh = false
  end
  self._effectClick_rect:SetActive(true)
  SFSNetwork.SendMessage(MsgDefines.ChapterTask, param)
  DataCenter.ChapterTaskManager:SetRewardGetType(questType)
end

function UIMainQuestMsg:QuestGetReward(questType, taskData, state)
  DataCenter.ChapterTaskCellManager:SetLastList(questType)
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.Quest, tostring(taskData.id))
  TimerManager:GetInstance():DelayInvoke(function()
    self._effectClick_rect:SetActive(false)
    local ret1, time1 = self.anim:PlayAnimationReturnTime("TaskHide2")
    TimerManager:GetInstance():DelayInvoke(function()
      local param = {}
      param.questType = questType
      param.taskData = taskData
      param.state = state
      EventManager:GetInstance():Broadcast(EventId.ChapterAnimHide, param)
    end, time1 + EffectWaitTime)
  end, EffectWaitTime)
end

function UIMainQuestMsg:QuestGoto(questType)
  DataCenter.ChapterTaskManager:SetRewardGetType(questType + 100)
  self.anim:Play("TaskHide")
  if self.taskData.nextGuideId ~= nil then
    DataCenter.GuideManager:SetCurGuideId(self.taskData.nextGuideId)
    DataCenter.GuideManager:DoGuide()
  elseif not DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ShowNewQuest, tostring(self.taskData.id)) then
    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
    if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.QuestGoto, tostring(template.id)) then
    else
      GoToUtil.GoToByQuestId(template)
    end
  end
end

function UIMainQuestMsg:MainHide()
  self.questType = 0
  self.state = 0
  self.isClick = false
  self:DeleteAutoHideTimer()
  self:DeleteBoxTimer()
  self:RemoveFingerArrow()
  self:PlayTaskDefault()
end

function UIMainQuestMsg:AddTaskHideTimer()
  if self.taskData and tonumber(self.taskData.id) == self.questGuidId then
    return
  end
  if self.timer_task == nil then
    self.timer_task = TimerManager:GetInstance():GetTimer(self.quest_hide, self.timer_taskHide_action, self, true, false, false)
    self.timer_task:Start()
  end
end

function UIMainQuestMsg:AutoHideTaskTime()
  if DataCenter.ChapterTaskCellManager:GuidGetState() then
    self:DeleteAutoHideTimer()
    return
  end
  if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
    if self.taskData.state == TaskState.CanReceive then
      self.anim:Play("TaskHide2")
    else
      self:PlayTaskHide(self.questType, self.animObj.transform.position)
    end
    DataCenter.TaskManager:SetTaskMsg(false)
  elseif self.state == UIMainQuestState.WarningBall then
    self.anim:Play("TaskHide")
  end
  self.isGuid = false
  self.questType = 0
  self.state = 0
  self:RemoveFingerArrow()
  DataCenter.ChapterTaskCellManager:AddArrowTimer()
end

function UIMainQuestMsg:DeleteAutoHideTimer()
  if self.timer_task ~= nil then
    self.timer_task:Stop()
    self.timer_task = nil
  end
end

function UIMainQuestMsg:ShowFingerArrow()
  if self.state and self.state == UIMainQuestState.BubbleQuest then
    return
  end
  local id
  if self.taskData then
    id = tonumber(self.taskData.id)
  end
  self.fingerArrow = TimerManager:GetInstance():DelayInvoke(function()
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    if 2 < chapterId and not self.isPvePowerState then
      return
    end
    if DataCenter.GuideManager:InGuide() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
      return
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) then
      return
    end
    local scaleMsg = self._chapterMsg_btn:GetLocalScale()
    if scaleMsg.x == 0 then
      return
    end
    DataCenter.ArrowManager:RemoveArrow()
    WorldArrowManager:GetInstance():RemoveEffect()
    if not self.taskData then
      self.fingerArrow:Stop()
      self.fingerArrow = nil
      return
    end
    local param = {}
    param.position = self._chapterIcon_img.transform.position
    local halfWidth = self._chapterIcon_img.rectTransform.rect.width * 0.3
    local halfHeight = self._chapterIcon_img.rectTransform.rect.height * 0.5
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    param.position.x = param.position.x + scaleFactor * halfWidth
    param.position.y = param.position.y - scaleFactor * halfHeight
    param.positionType = PositionType.Screen
    param.isPanel = false
    param.id = id
    param.guidId = self.questGuidId
    DataCenter.ArrowManager:ShowFingerArrow(param)
  end, 0.5)
end

function UIMainQuestMsg:RemoveFingerArrow()
  if self.fingerArrow ~= nil then
    self.fingerArrow:Stop()
    self.fingerArrow = nil
  end
  DataCenter.ArrowManager:RemoveFingerArrow(true)
end

function UIMainQuestMsg:GetCurIsShow()
  return self.questType
end

function UIMainQuestMsg:RefreshBallInfo(ballData)
  self._chapterIcon_img:SetActive(true)
  self._chapterIcon_img:LoadSprite(string.format(LoadPath.UIMainQuest, ballData.ballIcon))
  if ballData.param then
    if ballData.param.describePara then
      self._chapterDes_txt:SetLocalText(ballData.describe, table.unpack(ballData.param.describeParam))
    else
      self._chapterDes_txt:SetLocalText(ballData.describe)
    end
  else
    self._chapterDes_txt:SetLocalText(ballData.describe)
  end
end

function UIMainQuestMsg:PlayBallShow(pos, ballData, isClick, index)
  self:DeleteAutoHideTimer()
  self:RemoveFingerArrow()
  local ballObj = self.callBackBall()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local halfHeight = self.msgList.rectTransform.rect.height * 0.5
  local listPos = self.msgList.transform.position
  local bottomPosY = listPos.y - halfHeight * scaleFactor
  local topPosY = listPos.y + halfHeight * scaleFactor
  if topPosY < ballObj.transform.position.y + 50 * scaleFactor then
    if isClick then
      self.callBackMove(index, true, topPosY - (ballObj.transform.position.y + 50 * scaleFactor))
    else
      return
    end
  elseif bottomPosY > ballObj.transform.position.y - 50 * scaleFactor then
    if isClick then
      self.callBackMove(index, true, bottomPosY - (ballObj.transform.position.y - 50 * scaleFactor))
    else
      return
    end
  end
  if self.questType ~= 0 then
    if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
      if self.taskData.state == TaskState.CanReceive then
        self.anim:Play("TaskHide2")
      else
        self.anim:Play("TaskHide")
      end
    elseif self.state == UIMainQuestState.ChapterReward then
      self.anim:Play("TaskHide2")
    elseif self.state == UIMainQuestState.WarningBall then
      self.anim:Play("TaskHide")
    end
    self.changeTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.changeTimer then
        self.changeTimer:Stop()
        self.changeTimer = nil
      end
      if ballData then
        self.state = UIMainQuestState.WarningBall
        self.ballData = ballData
        self.animObj.transform.position = pos
        self:RefreshBallInfo(ballData)
        self.questType = warningBall
        self.anim:Play("TaskShow")
        self._chapterProgress_txt:SetActive(false)
        self:AddTaskHideTimer()
      end
    end, 0.2)
  elseif ballData then
    self.state = UIMainQuestState.WarningBall
    self.questType = warningBall
    self.ballData = ballData
    self:RefreshBallInfo(ballData)
    self.animObj.transform.position = pos
    self.anim:Play("TaskShow")
    self._chapterProgress_txt:SetActive(false)
    self:AddTaskHideTimer()
  end
end

return UIMainQuestMsg
