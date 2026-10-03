local UIPVETaskMsg = BaseClass("UIPVETaskMsg", UIBaseContainer)
local base = UIBaseContainer
local WarnList = 9999
local EffectWaitTime = 0.3

function UIPVETaskMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPVETaskMsg:OnDestroy()
  self:DeleteAutoHideTimer()
  self:DeleteAutoTime()
  if self.autoGo then
    self.autoGo:Stop()
    self.autoGo = nil
  end
  if self.delayGetReward then
    self.delayGetReward:Stop()
    self.delayGetReward = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVETaskMsg:OnEnable()
  base.OnEnable(self)
end

function UIPVETaskMsg:OnDisable()
  base.OnDisable(self)
end

function UIPVETaskMsg:GetQuest(callBackQuest)
  self.callBackQuest = callBackQuest
  self.questType = 0
end

function UIPVETaskMsg:ComponentDefine()
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

function UIPVETaskMsg:ComponentDestroy()
end

function UIPVETaskMsg:DataDefine()
  self.quest_hide = LuaEntry.DataConfig:TryGetNum("quest_pre", "k2")
  self.quest_auto = LuaEntry.DataConfig:TryGetNum("quest_pre", "k3")
  self.curPos = nil
  
  function self.timer_taskHide_action(temp)
    self:AutoHideTaskTime()
  end
  
  self.timer_auto = nil
  
  function self.timer_auto_action(temp)
    self:RefreshAutoTime()
  end
  
  self.questType = 0
  self.autoGoToList = {}
end

function UIPVETaskMsg:DataDestroy()
  self.autoGoToList = nil
end

function UIPVETaskMsg:Update()
  local pos
  if self.questType ~= 0 then
    local questCell = self.callBackQuest()
    if questCell then
      for i = 1, #questCell do
        if questCell[i].list == self.questType then
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

function UIPVETaskMsg:RefreshQuestInfo(taskData)
  self.animObj:SetActive(true)
  if taskData then
    if self.questType == WarnList then
      self._chapterIcon_img:LoadSprite(string.format(LoadPath.UIMainQuest, taskData.ballIcon))
      if taskData.param then
        if taskData.param.describePara then
          self._chapterDes_txt:SetLocalText(taskData.describe, table.unpack(taskData.param.describeParam))
        else
          self._chapterDes_txt:SetLocalText(taskData.describe)
        end
      else
        self._chapterDes_txt:SetLocalText(taskData.describe)
      end
      self._chapterProgress_txt:SetActive(false)
    else
      local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
      if questTemplate then
        self._chapterDes_txt:SetText(questTemplate:GetDesc())
        self._chapterIcon_img:LoadSprite(questTemplate:GetIconPath())
        self._chapterIcon_img:SetActive(true)
        self._chapterProgress_txt:SetActive(tonumber(questTemplate.progressshow) == 1)
        local num = 0
        if taskData.num >= questTemplate.para2 then
          num = questTemplate.para2
        elseif tonumber(questTemplate.gotype2) == QuestGoType.GoFelledTree then
          local numTree = DataCenter.TaskManager:GetFelledTree(taskData.id)
          if numTree and numTree ~= 0 then
            num = numTree
          else
            num = taskData.num
          end
        else
          num = taskData.num
        end
        self._chapterProgress_txt:SetText(string.format("(%d/%d)", num, questTemplate.para2))
      end
    end
  end
  self._effectClick_rect:SetActive(false)
end

function UIPVETaskMsg:GetCurMsgTaskId()
  if self.taskData then
    return self.taskData.id
  end
  return nil
end

function UIPVETaskMsg:PlayTaskShow(taskData, list, pos, type)
  self:DeleteAutoHideTimer()
  self:DeleteAutoTime()
  self.taskData = taskData
  self.questType = list
  self:RefreshQuestInfo(taskData)
  self.animObj.transform.position = pos
  self.curPos = pos
  if type == 1 then
    self.anim:Play("TaskShow")
    self:AddTaskHideTimer()
  else
    self.anim:Play("TaskShow2")
    self:AddAutoTimer()
  end
  if list ~= WarnList then
    self:CheckIsAutoGoTo(taskData)
  end
  self.isClick = false
end

function UIPVETaskMsg:PlayTaskHide(chapterType, pos)
  self:DeleteAutoHideTimer()
  self:DeleteAutoTime()
  self.animObj.transform.position = pos
  self.questType = 0
  self.anim:Play("TaskHide")
end

function UIPVETaskMsg:PlayTaskDefault()
  self:DeleteAutoHideTimer()
  self.anim:Play("Default")
end

function UIPVETaskMsg:ClickTask(taskData, list, pos)
  self.animObj:SetActive(true)
  self:DeleteAutoHideTimer()
  self:DeleteAutoTime()
  if self.changeTimer then
    self.changeTimer:Stop()
    self.changeTimer = nil
  end
  self._effectClick_rect:SetActive(false)
  self.isClick = false
  if self.questType == list then
    self.taskData = taskData
    self.animObj.transform.position = pos
    self:RefreshQuestInfo(taskData)
    if self.taskData.state == TaskState.CanReceive then
      self.anim:Play("TaskHide2")
    else
      self.anim:Play("TaskHide")
    end
    self.questType = 0
  elseif self.questType ~= 0 then
    if self.taskData.state == TaskState.CanReceive then
      self.anim:Play("TaskHide2")
    else
      self.anim:Play("TaskHide")
    end
    self.changeTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.changeTimer then
        self.changeTimer:Stop()
        self.changeTimer = nil
      end
      self.taskData = taskData
      self.animObj.transform.position = pos
      self.questType = list
      self:RefreshQuestInfo(taskData)
      if self.taskData.state == TaskState.CanReceive then
        self.anim:Play("TaskShow2")
        self:AddAutoTimer()
      else
        self.anim:Play("TaskShow")
        self:AddTaskHideTimer()
      end
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Task_Show, false)
    end, 0.2)
  else
    self.taskData = taskData
    self.animObj.transform.position = pos
    self.questType = list
    self:RefreshQuestInfo(taskData)
    self.anim:Stop()
    if self.taskData.state == TaskState.CanReceive then
      self.anim:Play("TaskShow2")
      self:AddAutoTimer()
    else
      self.anim:Play("TaskShow")
      self:AddTaskHideTimer()
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Task_Show, false)
  end
end

function UIPVETaskMsg:CheckIsAutoGoTo(taskData)
  if taskData then
    self.autoGo = TimerManager:GetInstance():DelayInvoke(function()
      local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
      if tonumber(questTemplate.gotype2) == QuestGoType.GoPveAutoTo then
        if self.autoGoToList[taskData.id] then
          return
        else
          self.autoGoToList[taskData.id] = taskData
          self:OnClickMsg()
        end
      end
    end, 1)
  end
end

function UIPVETaskMsg:OnClickMsg()
  self:DeleteAutoHideTimer()
  self.isClick = true
  local questType = self.questType
  local taskData = self.taskData
  self.questType = 0
  if questType == WarnList then
    self.anim:Play("TaskHide")
    local param = {}
    param.questType = questType
    EventManager:GetInstance():Broadcast(EventId.PveTaskGetReward, param)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
  elseif taskData.state == TaskState.CanReceive then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
    self._effectClick_rect:SetActive(true)
    self:QuestGetReward(questType, taskData)
  else
    self:QuestGoto(questType)
  end
end

function UIPVETaskMsg:QuestGetReward(questType, taskData)
  self.delayGetReward = TimerManager:GetInstance():DelayInvoke(function()
    self._effectClick_rect:SetActive(false)
    local ret1, time1 = self.anim:PlayAnimationReturnTime("TaskHide2")
    TimerManager:GetInstance():DelayInvoke(function()
      local param = {}
      param.questType = questType
      param.taskData = taskData
      EventManager:GetInstance():Broadcast(EventId.PveTaskGetReward, param)
    end, time1)
  end, EffectWaitTime)
end

function UIPVETaskMsg:QuestGoto(questType)
  self.anim:Play("TaskHide")
  local template = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
  GoToUtil.GoToByQuestId(template)
end

function UIPVETaskMsg:MainHide()
  self.questType = 0
  self.isClick = false
  self:DeleteAutoHideTimer()
  self:PlayTaskDefault()
end

function UIPVETaskMsg:AddTaskHideTimer()
  if self.timer_task == nil then
    self.timer_task = TimerManager:GetInstance():GetTimer(self.quest_hide, self.timer_taskHide_action, self, true, false, false)
    self.timer_task:Start()
  end
end

function UIPVETaskMsg:AutoHideTaskTime()
  if self.questType ~= 0 then
    if self.taskData.state == TaskState.CanReceive then
      self.anim:Play("TaskHide2")
    else
      self:PlayTaskHide(self.questType, self.animObj.transform.position)
    end
  end
  self.questType = 0
  self.view:CheckTaskCanReceive()
end

function UIPVETaskMsg:DeleteAutoHideTimer()
  if self.timer_task ~= nil then
    self.timer_task:Stop()
    self.timer_task = nil
  end
end

function UIPVETaskMsg:AddAutoTimer()
  if self.timer_auto == nil then
    self.timer_auto = TimerManager:GetInstance():GetTimer(self.quest_auto + 1, self.timer_auto_action, self, true, false, false)
    self.timer_auto:Start()
  end
end

function UIPVETaskMsg:RefreshAutoTime()
  if self.taskData.state == TaskState.CanReceive then
    self:OnClickMsg()
  end
end

function UIPVETaskMsg:DeleteAutoTime()
  if self.timer_auto ~= nil then
    self.timer_auto:Stop()
    self.timer_auto = nil
  end
end

function UIPVETaskMsg:GetCurIsShow()
  return self.questType
end

return UIPVETaskMsg
