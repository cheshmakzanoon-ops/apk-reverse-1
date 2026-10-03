local UIPVETask = BaseClass("UIPVETask", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local questbg_btn_path = "Btn_QuestBg"
local questNewAnim_path = ""
local scale = "Btn_QuestBg/scale"
local img_questIcon_path = "Btn_QuestBg/scale/Img_QuestIcon"
local anim_npc_path = "Btn_QuestBg/scale/Rect_Npc"
local img_npcIcon_path = "Btn_QuestBg/scale/Rect_Npc/Rect_NpcBg/QuestNpcIcon"
local rect_ballEffect_path = "Btn_QuestBg/scale/Rect_BallEffect"
local BallType = {Task = 1, Warn = 2}
local WarnList = 9999
local GuideEndWaitShowQuestTime = 0.8
local EffectWaitTime = 0.5

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
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
  self.anim_npc = self:AddComponent(UIAnimator, anim_npc_path)
  self.rect_ballEffect = self:AddComponent(UIBaseContainer, rect_ballEffect_path)
end

local function ComponentDestroy(self)
  self._questBg_btn = nil
  self.img_npcIcon = nil
  self.questNewAnim:Stop()
end

local function DataDefine(self)
  self.taskData = {}
  self.isHide = false
  self.timer_task = nil
  self.isClick = false
  
  function self.timer_task_action(temp)
    self:RefreshTaskTime()
  end
  
  self.guide_end_show_quest = nil
  
  function self.guide_end_show_quest_action(temp)
    self:GuideEndShowQuest()
  end
  
  self.firstShow = true
  self.rewardPos = nil
  self.state = 0
  self.isClickQuestObj = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MessageBallChange, self.OnWarningBallChange)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.MessageBallChange, self.OnWarningBallChange)
  base.OnRemoveListener(self)
end

local function DataDestroy(self)
  self.firstShow = nil
  self.taskData = nil
  self.isHide = nil
  self.isClick = nil
  self.hideFirst = nil
  self:DeleteChapterTimer()
  self:DeleteGuideEndShowQuestTimer()
  self:DeleteAllTimer()
  self.isClickQuestObj = nil
end

local function ReInit(self, list, levelId, msgAnim)
  self.levelId = levelId
  self.list = list
  if list == WarnList then
    self.ballState = BallType.Warn
  else
    self.ballState = BallType.Task
  end
  self.quest_early = LuaEntry.DataConfig:CheckSwitch("quest_early")
  self.quest_earlyId = LuaEntry.DataConfig:TryGetNum("quest_pre", "k1")
  self.quest_hide = LuaEntry.DataConfig:TryGetNum("quest_pre", "k2")
  self.quest_auto = LuaEntry.DataConfig:TryGetNum("quest_pre", "k3")
  self.quest_nextshow = LuaEntry.DataConfig:TryGetNum("quest_pre", "k4")
  local str = LuaEntry.DataConfig:TryGetStr("quest_pre", "k5")
  self.quest_arrow = string.split(str, ";")
  self.warnIsShow = false
  self.msgAnim = msgAnim
  self.firstShow = true
  self.hideFirst = true
  self:RefreshTask(1)
  self.twinkFirst = true
end

local function RefreshGuideSignal(self)
  self:AddGuideEndShowQuestTimer()
end

local function RefreshTask(self, param)
  self.rect_ballEffect:SetActive(false)
  self.anim_npc:Enable(false)
  if self.ballState == BallType.Task then
    self.img_npcIcon:LoadSprite(string.format(LoadPath.UITask, "UIMain_icon_npc_quest"))
    self.scale:LoadSprite(string.format(LoadPath.UITask, "Uichapter_img_btnbg01"))
    self.taskData = DataCenter.TaskManager:GetPveTaskByList(tonumber(self.list), self.levelId)
    if self.taskData and next(self.taskData) then
      self.questNewObj:SetActive(true)
      self.gameObject.name = self.taskData.id
      local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
      self._questIcon_img:LoadSprite(questTemplate:GetIconPath())
      if self.taskData.state == TaskState.CanReceive or param == 1 then
        if self.taskData.state == TaskState.CanReceive and not self.taskData.taskReward then
          self.taskData:SetTaskShowState()
          self:RefreshAnim()
        elseif param == 1 then
          self.taskData:SetTaskShowState()
          self:RefreshAnim()
        end
      elseif param == 2 then
        if not self.taskData.taskShow then
          self:RefreshAnim(2)
          self.taskData:SetTaskShowState()
        else
          self.questNewAnim:PlayAnimationReturnTime("Default")
        end
      elseif param == 3 then
        self:RefreshAnim(3)
      end
    else
      self.questNewObj:SetActive(false)
    end
  elseif self.ballState == BallType.Warn then
    self.rect_ballEffect:SetActive(true)
    self.anim_npc:Enable(true)
    self.img_npcIcon:LoadSprite(string.format(LoadPath.UITask, "UIMain_icon_npc_captain"))
    self.scale:LoadSprite(string.format(LoadPath.UITask, "Uichapter_img_btnbg02"))
    if param and param == 1 then
      local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_MAX_EXTRA)
      local curNum = DataCenter.ResourceItemDataManager:GetResourceItemTotalNumByType(ResourceItemType.Farming)
      local maxNum = DataCenter.ResourceItemDataManager:GetFreezerStorageMax(true) + storageCurExtra
      if curNum >= maxNum then
        DataCenter.WarningBallManager:CheckBag()
      end
      self.questNewObj:SetActive(false)
    end
  end
end

local function RefreshAnim(self, isGuid)
  if self.isHide then
    return
  end
  self.isClick = false
  local taskData = self.taskData
  if self.taskData.state == TaskState.CanReceive then
    if self.firstShow then
      self.firstShow = false
      TimerManager:GetInstance():DelayInvoke(function()
        self.questNewObj:SetActive(true)
        local ret = false
        local time = 0
        ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
        if ret then
          self.showTimer1 = TimerManager:GetInstance():GetTimer(time, function()
            if DataCenter.GuideManager:InGuide() then
              return
            end
            local isShow = self.msgAnim:GetCurIsShow()
            if isShow and isShow == 0 then
              taskData:SetTaskRewardState()
              local pos = self.questNewObj.transform.position
              self.msgAnim:PlayTaskShow(taskData, self.list, pos, 2)
            end
            if self.showTimer1 then
              self.showTimer1:Stop()
              self.showTimer1 = nil
            end
          end, self, true, false, false)
          self.showTimer1:Start()
        end
      end, 0.7)
    else
      self.questNewObj:SetActive(true)
      if not self.questNewAnim:IsPlaying("TaskShow2") then
        local ret = false
        local time = 0
        if DataCenter.TaskManager:GetPveRewardType(tonumber(self.list)) then
          ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
          DataCenter.TaskManager:SetPveRewardType(tonumber(self.list), false)
        else
          self.questNewAnim:PlayAnimationReturnTime("Default")
        end
        self.showTimer1 = TimerManager:GetInstance():GetTimer(time, function()
          if DataCenter.GuideManager:InGuide() then
            return
          end
          local isShow = self.msgAnim:GetCurIsShow()
          if isShow and isShow == 0 then
            taskData:SetTaskRewardState()
            local pos = self.questNewObj.transform.position
            self.msgAnim:PlayTaskShow(taskData, self.list, pos, 2)
          end
          if self.showTimer1 then
            self.showTimer1:Stop()
            self.showTimer1 = nil
          end
        end, self, true, false, false)
        self.showTimer1:Start()
      end
    end
  elseif self.firstShow then
    self.firstShow = false
    if self.view.isPlayTask then
      TimerManager:GetInstance():DelayInvoke(function()
        self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
      end, 0.7)
      return
    end
    self.view.isPlayTask = true
    self.showTimer5 = TimerManager:GetInstance():DelayInvoke(function()
      self.view.isPlayTask = false
      self.questNewObj:SetActive(true)
      local ret = false
      local time = 0
      ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
      self:DeleteChapterTimer()
      if ret then
        self.showTimer4 = TimerManager:GetInstance():GetTimer(time, function()
          if DataCenter.GuideManager:InGuide() then
            return
          end
          local isShow = self.msgAnim:GetCurIsShow()
          if isShow and isShow == 0 then
            local pos = self.questNewObj.transform.position
            self.msgAnim:PlayTaskShow(taskData, self.list, pos, 1)
            self:AddTaskTimer()
          end
          if self.showTimer4 then
            self.showTimer4:Stop()
            self.showTimer4 = nil
          end
        end, self, true, false, false)
        self.showTimer4:Start()
      end
    end, 0.7)
  else
    self.questNewObj:SetActive(true)
    if not self.questNewAnim:IsPlaying("TaskShow") then
      local ret = false
      local time = 0
      if DataCenter.TaskManager:GetPveRewardType(tonumber(self.list)) then
        ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
        DataCenter.TaskManager:SetPveRewardType(tonumber(self.list), false)
      else
        self.questNewAnim:PlayAnimationReturnTime("Default")
      end
      self:DeleteChapterTimer()
      self.showTimer2 = TimerManager:GetInstance():GetTimer(time, function()
        if DataCenter.GuideManager:InGuide() then
          return
        end
        local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
        if isGuid and questTemplate:GetGuidShow() == 1 then
          return
        end
        local isShow = self.msgAnim:GetCurIsShow()
        if isShow and isShow == 0 then
          local pos = self.questNewObj.transform.position
          self.msgAnim:PlayTaskShow(taskData, self.list, pos, 1)
          self:AddTaskTimer()
          questTemplate:SetGuidShow()
        end
        if self.showTimer2 then
          self.showTimer2:Stop()
          self.showTimer2 = nil
        end
      end, self, true, false, false)
      self.showTimer2:Start()
    end
  end
end

local function DeleteChapterTimer(self)
  if self.timer_task ~= nil then
    self.timer_task:Stop()
    self.timer_task = nil
  end
end

local function AddTaskTimer(self)
  if self.timer_task == nil then
    self.timer_task = TimerManager:GetInstance():GetTimer(self.quest_hide, self.timer_task_action, self, true, false, false)
    self.timer_task:Start()
  end
end

local function RefreshTaskTime(self)
end

local function OnClickQuest(self, manual)
  if self.quest_early then
    if manual then
      self.isClickQuestObj = true
    end
    self.questNewAnim:PlayAnimationReturnTime("Default")
    self:DeleteChapterTimer()
    DataCenter.ArrowManager:RemoveArrow()
    self.isCd = false
    local pos = self.questNewObj.transform.position
    self.msgAnim:ClickTask(self.taskData, self.list, pos)
    self.isClick = false
  end
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
  if self.showTimer4 then
    self.showTimer4:Stop()
    self.showTimer4 = nil
  end
  if self.showTimer5 then
    self.showTimer5:Stop()
    self.showTimer5 = nil
  end
  if self.showTimer6 then
    self.showTimer6:Stop()
    self.showTimer6 = nil
  end
  if self.showTimer7 then
    self.showTimer7:Stop()
    self.showTimer7 = nil
  end
end

local function DeleteGuideEndShowQuestTimer(self)
  if self.guide_end_show_quest ~= nil then
    self.guide_end_show_quest:Stop()
    self.guide_end_show_quest = nil
  end
end

local function AddGuideEndShowQuestTimer(self)
  self:DeleteGuideEndShowQuestTimer()
  if self.guide_end_show_quest == nil then
    self.guide_end_show_quest = TimerManager:GetInstance():GetTimer(GuideEndWaitShowQuestTime, self.guide_end_show_quest_action, self, true, false, false)
    self.guide_end_show_quest:Start()
  end
end

local function GuideEndShowQuest(self)
  self:DeleteGuideEndShowQuestTimer()
  if self.taskData then
    local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(self.taskData.id)
    if questTemplate and (questTemplate.autoopen == 1 or questTemplate.autoopen == 2) then
      return
    end
  end
  if self.ballState ~= BallType.Warn then
    self:RefreshTask(3)
  end
end

local function GetBallType(self)
  return self.ballState
end

local function CheckIsReward(self, param)
  if param and param.questType == self.list then
    local rewardPos = self.questNewObj.transform.position
    local taskData = param.taskData
    self.taskData = nil
    self.questNewAnim:Play("QuestNewHide")
    if param.questType == WarnList then
      self.warnIsShow = false
      return
    end
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
    DataCenter.TaskManager:SetPveRewardType(tonumber(self.list), true)
    if taskData.id ~= nil then
      local questId = taskData.id
      TimerManager:GetInstance():DelayInvoke(function()
        SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {id = questId})
      end, 0.5)
    end
  end
end

local function BallPlayHide(self)
  self.questNewAnim:Play("QuestNewHide")
  self.warnIsShow = false
  local isShow = self.msgAnim:GetCurIsShow()
  if isShow and isShow == WarnList then
    local pos = self.questNewObj.transform.position
    self.msgAnim:PlayTaskHide(nil, pos)
  end
  self.ballHide1 = TimerManager:GetInstance():DelayInvoke(function()
    self.questNewObj:SetActive(false)
  end, 0.5)
end

local function OnWarningBallChange(self, type)
  if self.warnIsShow or type ~= MessageBallType.BagMax or self.ballState ~= BallType.Warn then
    if self.warnIsShow then
      local isShow = self.msgAnim:GetCurIsShow()
      if isShow and isShow == 0 then
        local pos = self.questNewObj.transform.position
        self.msgAnim:PlayTaskShow(self.taskData, self.list, pos, 1)
      end
    end
    return
  end
  self.showTimer6 = TimerManager:GetInstance():DelayInvoke(function()
    local taskData = DataCenter.WarningBallManager:GetShowWarningBall(true)
    if taskData == nil then
      return
    end
    self.taskData = taskData
    self.warnIsShow = true
    self.questNewObj:SetActive(true)
    self._questIcon_img:LoadSprite(string.format(LoadPath.UIMainQuest, self.taskData.ballIcon))
    local ret = false
    local time = 0
    ret, time = self.questNewAnim:PlayAnimationReturnTime("QuestNewShow")
    if ret then
      self.showTimer7 = TimerManager:GetInstance():GetTimer(time, function()
        if DataCenter.GuideManager:InGuide() then
          return
        end
        local isShow = self.msgAnim:GetCurIsShow()
        if isShow and isShow == 0 then
          local pos = self.questNewObj.transform.position
          self.msgAnim:PlayTaskShow(self.taskData, self.list, pos, 1)
        end
        if self.showTimer7 then
          self.showTimer7:Stop()
          self.showTimer7 = nil
        end
      end, self, true, false, false)
      self.showTimer7:Start()
    end
  end, 0.6)
end

UIPVETask.OnCreate = OnCreate
UIPVETask.OnDestroy = OnDestroy
UIPVETask.OnEnable = OnEnable
UIPVETask.OnDisable = OnDisable
UIPVETask.ComponentDefine = ComponentDefine
UIPVETask.ComponentDestroy = ComponentDestroy
UIPVETask.OnAddListener = OnAddListener
UIPVETask.OnRemoveListener = OnRemoveListener
UIPVETask.DataDefine = DataDefine
UIPVETask.DataDestroy = DataDestroy
UIPVETask.RefreshGuideSignal = RefreshGuideSignal
UIPVETask.ReInit = ReInit
UIPVETask.RefreshTask = RefreshTask
UIPVETask.RefreshAnim = RefreshAnim
UIPVETask.DeleteChapterTimer = DeleteChapterTimer
UIPVETask.AddTaskTimer = AddTaskTimer
UIPVETask.RefreshTaskTime = RefreshTaskTime
UIPVETask.OnClickQuest = OnClickQuest
UIPVETask.DeleteGuideEndShowQuestTimer = DeleteGuideEndShowQuestTimer
UIPVETask.AddGuideEndShowQuestTimer = AddGuideEndShowQuestTimer
UIPVETask.GuideEndShowQuest = GuideEndShowQuest
UIPVETask.GetBallType = GetBallType
UIPVETask.DeleteAllTimer = DeleteAllTimer
UIPVETask.CheckIsReward = CheckIsReward
UIPVETask.OnWarningBallChange = OnWarningBallChange
UIPVETask.BallPlayHide = BallPlayHide
return UIPVETask
