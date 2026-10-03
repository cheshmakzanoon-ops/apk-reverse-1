local UIMainQuest = BaseClass("UIMainQuest", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local questbg_btn_path = "Btn_QuestBg"
local questNewAnim_path = ""
local scale = "Btn_QuestBg/scale"
local img_questIcon_path = "Btn_QuestBg/scale/Img_QuestIcon"
local img_npcIcon_path = "Btn_QuestBg/scale/Rect_NpcBg/QuestNpcIcon"
local GuideEndWaitShowQuestTime = 0.8
local EffectWaitTime = 0.5

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:OnAddListener()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.scale = self:AddComponent(UIButton, scale)
  self._questBg_btn = self:AddComponent(UIBaseContainer, questbg_btn_path)
  self.scale:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local manual = true
    self:OnClickQuest(manual)
  end)
  self.questNewObj = self:AddComponent(UIBaseContainer, questNewAnim_path)
  self.questNewAnim = self:AddComponent(UISimpleAnimation, questNewAnim_path)
  self._questIcon_img = self:AddComponent(UIImage, img_questIcon_path)
  self.img_npcIcon = self:AddComponent(UIImage, img_npcIcon_path)
end

local function ComponentDestroy(self)
  self._questBg_btn = nil
  self.img_npcIcon = nil
end

local function DataDefine(self)
  self.lod = 0
  self.taskData = {}
  self.isHide = false
  self.isChapter = true
  self.timer_task = nil
  self.isClick = false
  
  function self.timer_task_action(temp)
    self:RefreshTaskTime()
  end
  
  self.firstShow = true
  self.rewardPos = nil
  self.quest_arrow_timer = nil
  
  function self.quest_arrow_action(temp)
    self:RefreshArrowTimer()
  end
  
  self.quest_twinkle_timer = nil
  
  function self.quest_twinkle_action(temp)
    self:RefreshTwinkleTimer()
  end
  
  self.isClickQuestObj = false
  self.isNewOpen = DataCenter.ChapterTaskCellManager:CheckNewSwitch()
end

local function DataDestroy(self)
  self.firstShow = nil
  self.taskData = nil
  self.isHide = nil
  self.isChapter = nil
  self.isClick = nil
  self.hideFirst = nil
  self:DeleteChapterTimer()
  self:DeleteArrowTimer()
  self:DeleteAllTimer()
  self:DeleteTwinkleTimer(true)
  self.isClickQuestObj = nil
end

local function ReInit(self, param, msgAnim, isMain, msgList, state)
  self.isMain = isMain
  if isMain then
    self.chapterType = tonumber(param) + 1000
  else
    self.chapterType = tonumber(param)
  end
  self.msgList = msgList
  self.quest_early = LuaEntry.DataConfig:CheckSwitch("quest_early")
  self.quest_earlyId = LuaEntry.DataConfig:TryGetNum("quest_pre", "k1")
  self.quest_hide = LuaEntry.DataConfig:TryGetNum("quest_pre", "k2")
  self.quest_auto = LuaEntry.DataConfig:TryGetNum("quest_pre", "k3")
  self.quest_nextshow = LuaEntry.DataConfig:TryGetNum("quest_pre", "k4")
  local str = LuaEntry.DataConfig:TryGetStr("quest_pre", "k5")
  self.quest_arrow = string.split(str, ";")
  self.questGuidId = LuaEntry.DataConfig:TryGetNum("quest_pre", "k6")
  self.msgAnim = msgAnim
  self.isPlayCreate = false
  if state then
    self.firstShow = false
    self.hideFirst = false
    self.twinkFirst = false
    if self.state == 0 then
      self.isPlayCreate = true
    end
  else
    self.firstShow = true
    self.hideFirst = true
    self.twinkFirst = true
  end
  self:RefreshTask()
end

local function UpdateInfo(self, param, msgAnim, isMain, msgList)
  self.isMain = isMain
  if isMain then
    self.chapterType = tonumber(param) + 1000
  else
    self.chapterType = tonumber(param)
  end
  self.msgList = msgList
  self.quest_early = LuaEntry.DataConfig:CheckSwitch("quest_early")
  self.quest_earlyId = LuaEntry.DataConfig:TryGetNum("quest_pre", "k1")
  self.quest_hide = LuaEntry.DataConfig:TryGetNum("quest_pre", "k2")
  self.quest_auto = LuaEntry.DataConfig:TryGetNum("quest_pre", "k3")
  self.quest_nextshow = LuaEntry.DataConfig:TryGetNum("quest_pre", "k4")
  local str = LuaEntry.DataConfig:TryGetStr("quest_pre", "k5")
  self.quest_arrow = string.split(str, ";")
  self.msgAnim = msgAnim
  self.firstShow = false
  self.hideFirst = false
  self.twinkFirst = false
  local isCreate = true
  self:RefreshTask(1, isCreate)
end

local function GetObj(self, callBackBall)
  self.callBackBall = callBackBall
end

local function PlaceBuildHandel(self)
  self.isHide = false
end

local function GuidEndSetState(self, state)
  if self.taskData then
    local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
    if questTemplate then
      questTemplate:SetGuidShow(state)
    end
  end
end

local function RefreshGuideSignal(self)
  self:DeleteArrowTimer()
  self:DeleteTwinkleTimer()
  self:GuidEndSetState(true)
  if not DataCenter.GuideManager:IsCanShowQuest() then
    self:DeleteChapterTimer()
    local questType = self.msgAnim:GetCurIsShow()
    if questType and questType ~= 0 then
      DataCenter.ChapterTaskManager.isTaskCompleteNew = true
    end
  end
end

local function CheckListQuest(self)
  if not self.isMain then
    local taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(self.chapterType)
    if taskData then
      if taskData.state == TaskState.CanReceive then
        return false
      else
        return true
      end
    else
      return false
    end
  end
end

local function RefreshTask(self, param, isCreate, isIgnore)
  local fakeQuest = DataCenter.GuideManager:GetFakeQuest()
  if fakeQuest == nil then
    self.img_npcIcon:LoadSprite(string.format(LoadPath.UITask, "UIMain_icon_npc_quest"))
    local allNum = DataCenter.ChapterTaskManager:GetAllNum()
    if 0 < allNum or self.isMain then
      if self.isMain then
        self.taskData = DataCenter.TaskManager:GetBubbleTaskByType(self.chapterType - 1000)
        if self.taskData then
          self.gameObject.name = self.taskData.id
          self.state = UIMainQuestState.BubbleQuest
        else
          self.isChapter = true
          self.state = UIMainQuestState.None
          self.questNewObj:SetActive(false)
          return
        end
      else
        self.taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(self.chapterType)
        local completeNum = DataCenter.ChapterTaskManager:GetCompleteNum()
        if allNum <= completeNum then
          local other = DataCenter.ChapterTaskManager:GetCurQuestState()
          if other and other ~= self.chapterType then
            self.isChapter = true
            self.state = UIMainQuestState.None
            self.questNewObj:SetActive(false)
            return
          end
          self.state = UIMainQuestState.ChapterReward
          self.gameObject.name = "ChapterReward_" .. completeNum
          DataCenter.ChapterTaskManager:SetCurQuestState(self.chapterType)
        else
          DataCenter.ChapterTaskManager:SetCurQuestState(nil)
          if self.taskData then
            self.gameObject.name = self.taskData.id
            self.state = UIMainQuestState.Quest
          else
            self.isChapter = true
            self.state = UIMainQuestState.None
            self.questNewObj:SetActive(false)
            return
          end
        end
      end
      self._questBg_btn:SetActive(true)
      if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
        local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
        self._questIcon_img:LoadSprite(questTemplate:GetIconPath())
      elseif self.state == UIMainQuestState.ChapterReward then
        self.questNewObj:SetActive(true)
        self._questIcon_img:LoadSprite(string.format(LoadPath.UIMainQuest, "UIchat_img_gift"))
      end
      if isCreate or self.isPlayCreate then
        self.isPlayCreate = false
        self.questNewObj:SetActive(true)
        self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
        return
      end
      if not self.quest_early then
        return
      end
      if not DataCenter.UnlockBtnManager:IsShowBtn(UnlockBtnType.Quest) then
        return
      end
      if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
        if self.taskData.state == TaskState.CanReceive or DataCenter.ChapterTaskManager:GetRewardGetType(self.chapterType) == self.chapterType then
          if self.taskData.state == TaskState.CanReceive then
            if not self.taskData.taskReward then
              self:RefreshAnim()
            end
          else
            self:RefreshAnim()
          end
        elseif param == 3 then
          local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
          if questTemplate and questTemplate.autoopen ~= 1 and questTemplate.autoopen ~= 2 and not self.isMain then
            self:RefreshAnim(3)
          end
        elseif DataCenter.ChapterTaskManager.isTaskCompleteNew or DataCenter.TaskManager.isTaskCompleteNew then
          local isRefreshShow = DataCenter.ChapterTaskManager:GetRewardGetType(self.chapterType) == self.chapterType
          self:RefreshAnim(1, isIgnore)
        end
      elseif self.state == UIMainQuestState.ChapterReward then
        self:RefreshAnim()
      end
    else
      self.isChapter = false
      self._questBg_btn:SetActive(false)
      self.state = UIMainQuestState.None
    end
  else
    if not self.quest_early then
      return
    end
    if not DataCenter.UnlockBtnManager:IsShowBtn(UnlockBtnType.Quest) then
      return
    end
    self.isChapter = true
    self.firstShow = false
    self._questBg_btn:SetActive(true)
    self.taskData = fakeQuest
    self.state = UIMainQuestState.Quest
    self.img_npcIcon:LoadSprite(string.format(LoadPath.UIMainNew, fakeQuest.npcName))
    self._questIcon_img:LoadSprite(string.format(LoadPath.UIMainQuest, fakeQuest.iconName))
    self:RefreshAnim()
    DataCenter.ChapterTaskManager:SetRewardGetType(self.chapterType + 100, self.isMain)
  end
end

local function RefreshAnim(self, isGuid, isIgnore)
  if self.isHide then
    return
  end
  self:DeleteNewQuestGuideTimer()
  if DataCenter.GuideManager:IsCanShowQuest() then
    self.isClick = false
    if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
      if self.taskData.state == TaskState.CanReceive then
        if self.firstShow then
        elseif DataCenter.ChapterTaskManager.isTaskCompleteNew or DataCenter.TaskManager.isTaskCompleteNew then
          self.questNewObj:SetActive(true)
          if not self.questNewAnim:IsPlaying("TaskShow2") then
            local ret = false
            local time = 0
            local value = DataCenter.ChapterTaskManager:GetRewardGetType(self.chapterType)
            if value and value ~= self.chapterType + 100 then
              ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
            else
              self.questNewAnim:PlayAnimationReturnTime("Default")
            end
            if ret then
              DataCenter.TaskManager:SetCompleteNew()
              self.showTimer1 = TimerManager:GetInstance():GetTimer(time, function()
                if self.isNewOpen then
                  self.questNewAnim:Play("fangda")
                end
                if self:CheckTaskBallMsg() then
                  if self.taskData then
                    if self.taskData.id ~= nil then
                      DataCenter.ChapterTaskManager:SetCompleteNew()
                    end
                  else
                    return
                  end
                  self.taskData:SetTaskRewardState()
                  if not self.isNewOpen then
                    DataCenter.TaskManager:SetTaskMsg(true)
                    local pos = self.questNewObj.transform.position
                    self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 2, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                  elseif self:CheckObjIsHide() then
                    self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                  end
                  DataCenter.ArrowManager:RemoveArrow()
                end
                if self.showTimer1 then
                  self.showTimer1:Stop()
                  self.showTimer1 = nil
                end
              end, self, true, false, false)
              self.showTimer1:Start()
            else
              if self.isNewOpen then
                self.questNewAnim:Play("fangda")
              end
              if self:CheckTaskBallMsg() then
                if not self.isNewOpen then
                  DataCenter.TaskManager:SetTaskMsg(true)
                  local pos = self.questNewObj.transform.position
                  self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 2, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                elseif self:CheckObjIsHide() then
                  self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                end
                if self.taskData.id ~= nil then
                  DataCenter.ChapterTaskManager:SetCompleteNew()
                  DataCenter.TaskManager:SetCompleteNew()
                end
                DataCenter.ArrowManager:RemoveArrow()
              elseif DataCenter.TaskManager:GetTaskMsg() and self.msgAnim:GetCurMsgTaskId() == self.taskData.id then
                self.taskData:SetTaskRewardState()
                if not self.isNewOpen then
                  DataCenter.TaskManager:SetTaskMsg(true)
                  local pos = self.questNewObj.transform.position
                  self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 2, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                elseif self:CheckObjIsHide() then
                  self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                end
                if self.taskData.id ~= nil then
                  DataCenter.ChapterTaskManager:SetCompleteNew()
                  DataCenter.TaskManager:SetCompleteNew()
                end
                DataCenter.ArrowManager:RemoveArrow()
              end
            end
          end
        end
      elseif self.firstShow then
      elseif DataCenter.ChapterTaskManager.isTaskCompleteNew or CS.SceneManager.IsInCity() or DataCenter.TaskManager.isTaskCompleteNew then
        self.questNewObj:SetActive(true)
        if not self.questNewAnim:IsPlaying("TaskShow") then
          local ret = false
          local time = 0
          local isTaskShow = true
          if DataCenter.ChapterTaskManager:GetRewardGetType(self.chapterType) ~= self.chapterType + 100 then
            ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
          else
            self.questNewAnim:PlayAnimationReturnTime("Default")
            isTaskShow = false
          end
          local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
          if questTemplate and questTemplate.autoopen ~= 2 then
            if ret then
              DataCenter.TaskManager:SetCompleteValue(true)
              DataCenter.TaskManager:SetCompleteNew()
              self.showTimer2 = TimerManager:GetInstance():GetTimer(time, function()
                if self:CheckTaskBallMsg() then
                  DataCenter.ChapterTaskManager:SetCompleteNew()
                  self:DeleteChapterTimer()
                  if not self.isNewOpen then
                    DataCenter.TaskManager:SetTaskMsg(true)
                    DataCenter.TaskManager:SetCompleteValue(false)
                    local pos = self.questNewObj.transform.position
                    self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 1, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                  elseif self:CheckObjIsHide() then
                    self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                  end
                  questTemplate:SetGuidShow()
                  self:AddTaskTimer()
                end
                if self.showTimer2 then
                  self.showTimer2:Stop()
                  self.showTimer2 = nil
                end
              end, self, true, false, false)
              self.showTimer2:Start()
            else
              if isGuid == 3 and self.chapterType == 1 and self.taskData then
                isTaskShow = true
              elseif isGuid == 3 and self.chapterType ~= 1 then
                local taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(1)
                if taskData == nil then
                  isTaskShow = true
                end
              elseif isIgnore and not DataCenter.TaskManager:GetCompleteValue() then
                isTaskShow = true
              end
              if self:CheckTaskBallMsg() and isTaskShow then
                self:DeleteChapterTimer()
                if isGuid == 3 and questTemplate:GetGuidShow() == 1 then
                  return
                end
                questTemplate:SetGuidShow()
                DataCenter.ChapterTaskManager:SetCompleteNew()
                DataCenter.TaskManager:SetCompleteNew()
                if not self.isNewOpen then
                  DataCenter.TaskManager:SetTaskMsg(true)
                  local pos = self.questNewObj.transform.position
                  self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 1, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                elseif self:CheckObjIsHide() then
                  self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                end
                self:AddTaskTimer()
              end
            end
          end
          if self.taskData.id ~= nil and not self.isMain then
            do
              local questId = self.taskData.id
              self.NewQuestGuideTimer = TimerManager:GetInstance():DelayInvoke(function()
                self.NewQuestGuideTimer = nil
                DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ShowNewQuest, tostring(questId))
              end, 2)
            end
          end
        end
      end
    elseif self.state == UIMainQuestState.ChapterReward then
      if self.firstShow then
        self.firstShow = false
      elseif DataCenter.ChapterTaskManager.isTaskCompleteNew then
        self.questNewObj:SetActive(true)
        if not self:CheckTaskBallMsg() then
          return
        end
        local ret = false
        local time = 0
        ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
        self:DeleteChapterTimer()
        DataCenter.ChapterTaskManager:SetCompleteNew()
        DataCenter.TaskManager:SetCompleteNew()
        if DataCenter.WarningBallManager:GetBallMsg() then
          return
        end
        if ret then
          self.showTimer3 = TimerManager:GetInstance():GetTimer(time, function()
            if self.isNewOpen then
              self.questNewAnim:Play("fangda")
            end
            if not self.isNewOpen then
              DataCenter.TaskManager:SetTaskMsg(true)
              local pos = self.questNewObj.transform.position
              self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 2, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
            elseif self:CheckObjIsHide() then
              self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
            end
            if self.showTimer3 then
              self.showTimer3:Stop()
              self.showTimer3 = nil
            end
          end, self, true, false, false)
          self.showTimer3:Start()
        else
          if self.isNewOpen then
            self.questNewAnim:Play("fangda")
          end
          if not self.isNewOpen then
            local pos = self.questNewObj.transform.position
            self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 2, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
          elseif self:CheckObjIsHide() then
            self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
          end
        end
        DataCenter.ArrowManager:RemoveArrow()
        local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
        local id = "100000100" .. chapterId
        DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
      end
    end
  else
    self.msgAnim:PlayTaskDefault()
    self:DeleteChapterTimer()
    self.questNewObj:SetActive(true)
    if self.state == UIMainQuestState.Quest then
      if self.taskData.state == TaskState.CanReceive and self.isNewOpen then
        self.questNewAnim:Play("fangda")
      else
        self.questNewAnim:PlayAnimationReturnTime("Default")
      end
    end
  end
end

local function CheckTaskBallMsg(self)
  if not DataCenter.WarningBallManager:GetBallMsg() and not DataCenter.TaskManager:GetTaskMsg() then
    return true
  end
  return false
end

local function SetLod(self, lod)
  self.lod = lod
end

local function DeleteChapterTimer(self)
  if self.timer_task ~= nil then
    self.timer_task:Stop()
    self.timer_task = nil
  end
end

local function AddTaskTimer(self)
  if self.taskData and tonumber(self.taskData.id) == self.questGuidId then
    return
  end
  if self.timer_task == nil and not self.isMain then
    self.timer_task = TimerManager:GetInstance():GetTimer(self.quest_hide, self.timer_task_action, self, true, false, false)
    self.timer_task:Start()
  end
end

local function RefreshTaskTime(self)
  if DataCenter.ChapterTaskCellManager:GuidGetState() then
    self:DeleteChapterTimer()
    return
  end
  self:AddTwinkleTimer()
end

local function ResetArrowTime(self)
  self.arrowWaitTime = TimerManager:GetInstance():DelayInvoke(function()
    self.arrowWaitTime:Stop()
    self.arrowWaitTime = nil
    self.isCd = false
    if self.isHide == false then
      self:AddArrowTimer()
    end
  end, tonumber(self.quest_arrow[4]))
end

local function AddArrowTimer(self)
  local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
  if chapterId == 0 then
    return
  end
  if chapterId <= tonumber(self.quest_arrow[1]) then
    local type = self.callBackBall()
    if type == self.chapterType and self.quest_arrow_timer == nil and not self.isCd then
      self.waitArrow = 0
      self.quest_arrow_timer = TimerManager:GetInstance():GetTimer(1, self.quest_arrow_action, self, false, false, false)
      self.quest_arrow_timer:Start()
    end
  end
end

local function RefreshArrowTimer(self)
  local questType = self.msgAnim:GetCurIsShow()
  if questType and questType ~= 0 then
    DataCenter.ChapterTaskCellManager:DeleteArrowTimer()
    return
  end
  if self:CheckObjIsHide() then
    return
  end
  if not self.questNewObj:GetActive() then
    DataCenter.ChapterTaskCellManager:AddArrowTimer()
    return
  end
  if self.isNewOpen then
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    if chapterId < 3 and self.taskData.state == TaskState.NoComplete then
      local param = {}
      param.position = self.questNewObj.transform.position
      local halfWidth = self.questNewObj.rectTransform.rect.width * 0.5
      local halfHeight = self.questNewObj.rectTransform.rect.height * 0.5
      local scaleFactor = UIManager:GetInstance():GetScaleFactor()
      param.position.x = param.position.x + scaleFactor * halfWidth
      param.position.y = param.position.y - scaleFactor * halfHeight
      param.positionType = PositionType.Screen
      param.isPanel = false
      DataCenter.ArrowManager:ShowFingerArrow(param)
      return
    end
  end
  DataCenter.ArrowManager:RemoveArrow()
  WorldArrowManager:GetInstance():RemoveEffect()
  if 3 < self.lod then
    DataCenter.ChapterTaskCellManager:AddArrowTimer()
    return
  end
  local param = {}
  param.position = self.questNewObj.transform.position
  param.position.y = param.position.y + 10
  param.position.x = param.position.x + 20
  param.arrowType = ArrowType.Chapter
  param.positionType = PositionType.Screen
  param.isReversal = true
  param.isPanel = false
  param.YisReversal = true
  param.isAutoClose = tonumber(self.quest_arrow[3])
  param.quest = true
  self.isCd = true
  DataCenter.ArrowManager:ShowArrow(param)
end

local function DeleteArrowTimer(self)
  if self.quest_arrow_timer ~= nil then
    self.quest_arrow_timer:Stop()
    self.quest_arrow_timer = nil
  end
end

local function CheckObjIsHide(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local halfHeight = self.msgList.rectTransform.rect.height * 0.5
  local listPos = self.msgList.transform.position
  local topPosY = listPos.y + halfHeight * scaleFactor
  local bottomPosY = listPos.y - halfHeight * scaleFactor
  if topPosY < self.transform.position.y + 50 * scaleFactor then
    return topPosY - (self.transform.position.y + 50 * scaleFactor)
  elseif bottomPosY > self.transform.position.y - 50 * scaleFactor then
    return bottomPosY - (self.transform.position.y - 50 * scaleFactor)
  end
  return false
end

local function HandleArrow(self, state)
  if state == 1 then
    self:DeleteArrowTimer()
  elseif state == 2 then
    self.isCd = false
    self:AddArrowTimer()
  end
end

local function AddTwinkleTimer(self)
  local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
  if chapterId == 0 or self.isMain then
    return
  end
  if chapterId < DataCenter.BuildManager.MainLv and chapterId < 10 then
    local typeList = DataCenter.ChapterTaskManager:GetCurChapterAllType()
    if typeList and next(typeList) then
      local type = self.callBackBall()
      if type == self.chapterType and self.quest_twinkle_timer == nil then
        self.twinkNum = 0
        local time = 60
        if self.twinkFirst == true then
          time = 1
          self.twinkFirst = false
        end
        self.quest_twinkle_timer = TimerManager:GetInstance():GetTimer(time, self.quest_twinkle_action, self, false, false, false)
        self.quest_twinkle_timer:Start()
      end
    end
  end
end

local function RefreshTwinkleTimer(self)
  if self.twinkNum == 1 then
    self:DeleteTwinkleTimer()
    return
  end
  if self.state == UIMainQuestState.ChapterReward then
    self:DeleteTwinkleTimer()
    return
  end
  if UIManager:GetInstance():HasWindow() or CS.SceneManager.IsInPVE() or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIPVELoading) or CrossServerUtil:GetIsCrossServer() then
    self:DeleteArrowTimer()
    return
  end
  if DataCenter.TaskManager:GetTaskMsg() and self.msgAnim:GetCurMsgTaskId() == self.taskData.id then
    return
  end
  self.questNewAnim:Play("fangda")
  self.twinkNum = self.twinkNum + 1
  DataCenter.ArrowManager:RemoveArrow()
  WorldArrowManager:GetInstance():RemoveEffect()
  local param = {}
  param.position = self.questNewObj.transform.position
  param.position.y = param.position.y + 10
  param.position.x = param.position.x + 20
  param.arrowType = ArrowType.Chapter
  param.positionType = PositionType.Screen
  param.isReversal = true
  param.isPanel = false
  param.YisReversal = true
  self.isClickQuestObj = false
  self:DeleteArrowTimer()
  if not self.isHide then
    if self:CheckObjIsHide() then
      return
    end
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

local function DeleteTwinkleTimer(self, isDestroy)
  if self.quest_twinkle_timer ~= nil then
    self.quest_twinkle_timer:Stop()
    self.quest_twinkle_timer = nil
  end
  if isDestroy then
    return
  end
end

local function OnClickQuest(self, manual, isGuid)
  if self.quest_early then
    if manual then
      self.isClickQuestObj = true
      self:DeleteTwinkleTimer()
      self:AddTwinkleTimer()
    end
    self.questNewAnim:PlayAnimationReturnTime("Default")
    DataCenter.ChapterTaskManager:SetRewardGetType(self.chapterType + 100, self.isMain)
    self:DeleteChapterTimer()
    DataCenter.ChapterTaskCellManager:DeleteArrowTimer()
    DataCenter.ArrowManager:RemoveArrow()
    DataCenter.ChapterTaskCellManager:SetCdState()
    local pos = self.questNewObj.transform.position
    local isMove = self:CheckObjIsHide()
    self.msgAnim:ClickTask(self.state, self.taskData, self.chapterType, pos, isGuid, isMove, self.transform:GetSiblingIndex())
    if not isGuid then
      self:AddTaskTimer()
    end
    self.isClick = false
  end
  EventManager:GetInstance():Broadcast(EventId.OnClickMsgNew, self.state)
end

local function DeleteAllTimer(self)
  if self.showTimer1 then
    self.showTimer1:Stop()
    self.showTimer1 = nil
  end
  if self.showTimer2 then
    self.showTimer2:Stop()
    self.showTimer2 = nil
  end
  if self.showTimer3 then
    self.showTimer3:Stop()
    self.showTimer3 = nil
  end
end

local function CheckIsShowMsgChapter(self, isMove)
  if self.quest_early then
    if DataCenter.UnlockBtnManager:IsShowBtn(UnlockBtnType.Quest) then
      self.questNewObj:SetActive(true)
      self.isHide = false
      if self.isChapter then
        self.questNewAnim:PlayAnimationReturnTime("Default")
        if DataCenter.GuideManager:IsCanShowQuest() then
          self.isHide = false
          self.isClick = false
          if self.state == 0 then
            self.questNewObj:SetActive(false)
            self.firstShow = false
          elseif self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
            if self.taskData.state == TaskState.CanReceive and self:CheckTaskBallMsg() then
              self.firstShow = false
              if isMove then
                DataCenter.ChapterTaskCellManager:DeleteArrowTimer()
              end
              if self.isNewOpen then
                self.questNewAnim:Play("fangda")
              end
              if not DataCenter.ChapterTaskCellManager:GetMainAnimShowState() then
                DataCenter.ChapterTaskCellManager:SetMainAnimShowState(true)
                self.mainAnimShow = TimerManager:GetInstance():DelayInvoke(function()
                  if not self.isNewOpen then
                    local questType = self.msgAnim:GetCurIsShow()
                    if questType and questType == 0 then
                      DataCenter.TaskManager:SetTaskMsg(true)
                      local pos = self.questNewObj.transform.position
                      self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 2, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                    end
                  elseif self:CheckObjIsHide() then
                    self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                  end
                  DataCenter.ChapterTaskCellManager:SetMainAnimShowState(false)
                  if self.mainAnimShow ~= nil then
                    self.mainAnimShow:Stop()
                    self.mainAnimShow = nil
                  end
                end, 0.4)
                DataCenter.ArrowManager:RemoveArrow()
              end
            elseif self.firstShow then
              self.firstShow = false
              local typeList = DataCenter.ChapterTaskManager:GetCurChapterAllType()
              for i = 1, #typeList do
                if typeList[i] == self.chapterType then
                  local isArrow = false
                  local taskData = DataCenter.ChapterTaskManager:GetChapterTaskType(typeList[i])
                  if taskData then
                    local template = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
                    if template and template.questPre ~= "" then
                      local taskInfo = DataCenter.ChapterTaskManager:FindTaskInfo(template.questPre)
                      if taskInfo and taskInfo.state == TaskState.Received then
                        isArrow = true
                      end
                    else
                      isArrow = true
                    end
                    if not isArrow then
                      return
                    end
                  end
                end
              end
              if self:CheckTaskBallMsg() then
                local show = CS.GameEntry.Setting:GetBool(SettingKeys.CHAPTER_FIRST_SHOW .. LuaEntry.Player.uid, true)
                if show then
                  CS.GameEntry.Setting:SetBool(SettingKeys.CHAPTER_FIRST_SHOW .. LuaEntry.Player.uid, false)
                  TimerManager:GetInstance():DelayInvoke(function()
                    local ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
                    TimerManager:GetInstance():DelayInvoke(function()
                      if not self.isNewOpen then
                        DataCenter.TaskManager:SetTaskMsg(true)
                        local pos = self.questNewObj.transform.position
                        self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 1, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                      elseif self:CheckObjIsHide() then
                        self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                      end
                      self:AddTaskTimer()
                    end, time)
                  end, 0.2)
                elseif not DataCenter.ChapterTaskCellManager:GetMainAnimShowState() then
                  DataCenter.ChapterTaskCellManager:SetMainAnimShowState(true)
                  self.mainAnimShow = TimerManager:GetInstance():DelayInvoke(function()
                    if not self.isNewOpen then
                      DataCenter.TaskManager:SetTaskMsg(true)
                      local pos = self.questNewObj.transform.position
                      self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 1, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
                    elseif self:CheckObjIsHide() then
                      self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
                    end
                    DataCenter.ChapterTaskCellManager:SetMainAnimShowState(false)
                    if self.mainAnimShow ~= nil then
                      self.mainAnimShow:Stop()
                      self.mainAnimShow = nil
                    end
                  end, 0.4)
                  self:AddTaskTimer()
                end
              end
            else
              self:AddTwinkleTimer()
            end
          elseif self.state == UIMainQuestState.ChapterReward and not DataCenter.WarningBallManager:GetBallMsg() then
            local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
            local id = "100000100" .. chapterId
            DataCenter.GuideManager:SendLogToNet(id, StatTTType.Guide)
            DataCenter.ChapterTaskCellManager:DeleteArrowTimer()
            self:AddTwinkleTimer()
            if self.isNewOpen then
              self.questNewAnim:Play("fangda")
            end
            self.mainAnimShow = TimerManager:GetInstance():DelayInvoke(function()
              if not self.isNewOpen then
                DataCenter.TaskManager:SetTaskMsg(true)
                local pos = self.questNewObj.transform.position
                self.msgAnim:PlayTaskShow(self.state, self.taskData, self.chapterType, pos, 2, self:CheckObjIsHide(), self.transform:GetSiblingIndex())
              elseif self:CheckObjIsHide() then
                self.msgAnim:DoMove(self.transform:GetSiblingIndex(), true, self:CheckObjIsHide())
              end
              DataCenter.ChapterTaskCellManager:SetMainAnimShowState(false)
              if self.mainAnimShow ~= nil then
                self.mainAnimShow:Stop()
                self.mainAnimShow = nil
              end
            end, 0.4)
          end
        else
          if self.state == 0 then
            self.questNewObj:SetActive(false)
          end
          self.firstShow = false
        end
      elseif self.chapterType == 1 then
        self._questBg_btn:SetActive(false)
      else
        self.questNewObj:SetActive(false)
      end
    else
      self.isHide = false
    end
  end
end

local function HideMsgChapter(self, HideType)
  DataCenter.ChapterTaskCellManager:SetMainAnimShowState(false)
  if self.mainAnimShow ~= nil then
    self.mainAnimShow:Stop()
    self.mainAnimShow = nil
  end
  if HideType == 2 then
    if self.chapterType then
      DataCenter.ChapterTaskManager:SetRewardGetType(self.chapterType + 100, self.isMain)
    end
    self.isHide = true
    self.questNewAnim:PlayAnimationReturnTime("Default")
    self.msgAnim:MainHide()
    self.questNewObj:SetActive(false)
    DataCenter.TaskManager:SetTaskMsg(false)
  end
  self:DeleteChapterTimer()
  self:DeleteTwinkleTimer()
  if self.isChapter then
    local questType = self.msgAnim:GetCurIsShow()
    if questType and questType ~= 0 then
      if HideType == 1 then
        DataCenter.ChapterTaskManager:SetRewardGetType(self.chapterType + 100, self.isMain)
        if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
          DataCenter.TaskManager:SetTaskMsg(false)
          local pos = self.questNewObj.transform.position
          if self.taskData.state == TaskState.CanReceive then
            self.msgAnim:PlayTaskHideBox(self.chapterType, pos)
          else
            self.msgAnim:PlayTaskHide(self.state, self.taskData, self.chapterType, pos)
          end
        elseif self.state == UIMainQuestState.ChapterReward then
          DataCenter.TaskManager:SetTaskMsg(false)
          self.questNewAnim:Play("TaskHide2")
        end
      end
    elseif self.hideFirst then
      self.hideFirst = false
      DataCenter.TaskManager:SetTaskMsg(false)
    else
      DataCenter.TaskManager:SetTaskMsg(false)
    end
  end
end

local function OnClickBall(self)
  self:DeleteChapterTimer()
  self:DeleteTwinkleTimer()
  if self.isChapter then
    local questType = self.msgAnim:GetCurIsShow()
    if questType and questType ~= 0 then
      if self.state == UIMainQuestState.Quest or self.state == UIMainQuestState.BubbleQuest then
        DataCenter.ChapterTaskManager:SetRewardGetType(self.chapterType + 100, self.isMain)
        DataCenter.TaskManager:SetTaskMsg(false)
        if self.taskData.state == TaskState.CanReceive then
          self.questNewAnim:Play("TaskHide2")
        else
          self.questNewAnim:Play("TaskHide")
        end
      elseif self.state == UIMainQuestState.ChapterReward then
        DataCenter.ChapterTaskManager:SetRewardGetType(self.chapterType + 100, self.isMain)
        DataCenter.TaskManager:SetTaskMsg(false)
        self.questNewAnim:Play("TaskHide2")
      end
    end
  end
end

local function DeleteNewQuestGuideTimer(self)
  if self.NewQuestGuideTimer ~= nil then
    self.NewQuestGuideTimer:Stop()
    self.NewQuestGuideTimer = nil
  end
end

local function DoMoveAnim(self)
  local pos = self:GetAnchoredPositionY()
  self.rectTransform:DOAnchorPosY(pos + 104, 0.2)
end

local function GetPos(self)
  return self.questNewObj.transform.position
end

local function GetSiblingIndex(self)
  return self.transform:GetSiblingIndex()
end

local function CheckIsReward(self, param)
  if param and param.questType == self.chapterType then
    local rewardPos = self.questNewObj.transform.position
    local taskData = param.taskData
    self.questNewAnim:Play("QuestNewHide")
    if taskData.rewardList ~= nil then
      local tempType = {}
      for i, v in ipairs(taskData.rewardList) do
        if v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY then
          table.insert(tempType, RewardToResType[v.rewardType])
        end
      end
      EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
      for i, v in ipairs(taskData.rewardList) do
        local rewardType = v.rewardType
        local itemId = v.itemId
        local pic = RewardUtil.GetPic(rewardType, itemId)
        if pic ~= "" then
          UIUtil.DoFly(tonumber(rewardType), 3, pic, rewardPos, Vector3.New(0, 0, 0), nil, nil, nil, nil, 1)
        end
      end
    end
    if taskData.id ~= nil then
      local questId = taskData.id
      DataCenter.ChapterTaskManager:SetRewardGetType(self.chapterType, self.isMain)
      TimerManager:GetInstance():DelayInvoke(function()
        SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {id = questId})
      end, self.quest_nextshow)
    elseif taskData.nextGuideId ~= nil and not self.isMain then
      local questId = taskData.nextGuideId
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.GuideManager:ClearFakeQuest()
        self:RefreshTask(1)
        DataCenter.GuideManager:SetCurGuideId(questId)
        DataCenter.GuideManager:DoGuide()
      end, 0.3)
    end
  end
end

UIMainQuest.OnCreate = OnCreate
UIMainQuest.OnDestroy = OnDestroy
UIMainQuest.OnEnable = OnEnable
UIMainQuest.OnDisable = OnDisable
UIMainQuest.ComponentDefine = ComponentDefine
UIMainQuest.ComponentDestroy = ComponentDestroy
UIMainQuest.DataDefine = DataDefine
UIMainQuest.DataDestroy = DataDestroy
UIMainQuest.GetObj = GetObj
UIMainQuest.GuidEndSetState = GuidEndSetState
UIMainQuest.PlaceBuildHandel = PlaceBuildHandel
UIMainQuest.RefreshGuideSignal = RefreshGuideSignal
UIMainQuest.CheckListQuest = CheckListQuest
UIMainQuest.UpdateInfo = UpdateInfo
UIMainQuest.ReInit = ReInit
UIMainQuest.RefreshTask = RefreshTask
UIMainQuest.RefreshAnim = RefreshAnim
UIMainQuest.DeleteChapterTimer = DeleteChapterTimer
UIMainQuest.AddTaskTimer = AddTaskTimer
UIMainQuest.RefreshTaskTime = RefreshTaskTime
UIMainQuest.OnClickBall = OnClickBall
UIMainQuest.OnClickQuest = OnClickQuest
UIMainQuest.CheckIsShowMsgChapter = CheckIsShowMsgChapter
UIMainQuest.HideMsgChapter = HideMsgChapter
UIMainQuest.AddArrowTimer = AddArrowTimer
UIMainQuest.RefreshArrowTimer = RefreshArrowTimer
UIMainQuest.DeleteArrowTimer = DeleteArrowTimer
UIMainQuest.ResetArrowTime = ResetArrowTime
UIMainQuest.CheckObjIsHide = CheckObjIsHide
UIMainQuest.DeleteNewQuestGuideTimer = DeleteNewQuestGuideTimer
UIMainQuest.HandleArrow = HandleArrow
UIMainQuest.DeleteAllTimer = DeleteAllTimer
UIMainQuest.AddTwinkleTimer = AddTwinkleTimer
UIMainQuest.RefreshTwinkleTimer = RefreshTwinkleTimer
UIMainQuest.DeleteTwinkleTimer = DeleteTwinkleTimer
UIMainQuest.CheckTaskBallMsg = CheckTaskBallMsg
UIMainQuest.DoMoveAnim = DoMoveAnim
UIMainQuest.GetPos = GetPos
UIMainQuest.GetSiblingIndex = GetSiblingIndex
UIMainQuest.CheckIsReward = CheckIsReward
UIMainQuest.SetLod = SetLod
return UIMainQuest
