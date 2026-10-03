local UIAllianceTaskItem = BaseClass("UIAllianceTaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local taskName_path = "Txt_Title"
local bg_path = "bg"
local taskDesc_path = "Txt_Complete"
local shareBtn_path = "shareBtn"
local claimRank_path = "Rect_Reward/Txt_QuestCondition"
local rewardsContainer_path = "ScrollView/Viewport/Content"
local rewards_path = "ScrollView/Viewport/Content/UIRewardCell"
local prog_path = "ProgressSlider"
local progTxt_path = "ProgressSlider/Txt_Progress"
local progEndTime_path = "ProgressSlider/Txt_Time"
local startTimeN_path = "startTime"
local startTime_path = "startTime/startTime"
local not_start_tip_path = "startTime/notStartTip"
local endTip_path = "endTip"
local end_prog_text_path = "endTip/endProgText"
local arrowL_path = "Rect_Reward/arrowL"
local arrowR_path = "Rect_Reward/arrowR"
local rewardBg_path = "Rect_Reward/RewardBg2"
local claimBtn_path = "Btn_AcceptReward"
local completeMark_path = "completeMark"
local finishTime_path = "completeMark/finishTip"
local jumpBtn_path = "jumpBtn"
local taskStatus_path = "Rect_Reward/Txt_QuestState"
local unlockModule_path = "ScrollView/Viewport/Content/UIRewardCell5"
local unlockModuleIcon_path = "ScrollView/Viewport/Content/UIRewardCell4/UICommonResItem/clickBtn/ItemIcon"
local unlockModuleBtn_path = "ScrollView/Viewport/Content/UIRewardCell4/UICommonResItem/clickBtn"
local claimEff_path = "Rect_Reward/claimEff"
local questBg_path = "bgIcon"
local unableClaimRewardMark_path = "unableClaimMark"
local unableClaimRewardFinishTime_path = "unableClaimMark/unableClaimFinishTip"
local unableClaimRewardTip_path = "unableClaimMark/unableClaimRewardTip"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DelTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.taskNameN = self:AddComponent(UIText, taskName_path)
  self.bgN = self:AddComponent(UIImage, bg_path)
  self.taskDescN = self:AddComponent(UIText, taskDesc_path)
  self.claimRankN = self:AddComponent(UIText, claimRank_path)
  self.shareBtnN = self:AddComponent(UIButton, shareBtn_path)
  self.shareBtnN:SetOnClick(function()
    self:OnClickShareBtn()
  end)
  self.taskProgN = self:AddComponent(UISlider, prog_path)
  self.progTxtN = self:AddComponent(UIText, progTxt_path)
  self.progEndTimeN = self:AddComponent(UIText, progEndTime_path)
  self.startTimeN = self:AddComponent(UIBaseContainer, startTimeN_path)
  self.startTimeText = self:AddComponent(UIText, startTime_path)
  self.not_start_tip = self:AddComponent(UIText, not_start_tip_path)
  self.finishedTipN = self:AddComponent(UIText, finishTime_path)
  self.endTipN = self:AddComponent(UIText, endTip_path)
  self.end_prog_text = self:AddComponent(UIText, end_prog_text_path)
  self.arrowLN = self:AddComponent(UIButton, arrowL_path)
  self.arrowLN:SetOnClick(function()
    self:OnClickArrowL()
  end)
  self.arrowRN = self:AddComponent(UIButton, arrowR_path)
  self.arrowRN:SetOnClick(function()
    self:OnClickArrowR()
  end)
  self.rewardBgN = self:AddComponent(UIImage, rewardBg_path)
  self.rewardsContainerN = self:AddComponent(UIBaseContainer, rewardsContainer_path)
  self.rewardItemsTb = {}
  for i = 1, 4 do
    local newOne = {}
    local tempItem = self:AddComponent(UIBaseContainer, rewards_path .. i)
    newOne.rootN = tempItem
    newOne.itemN = tempItem:AddComponent(UICommonResItem, "UICommonResItem")
    newOne.effN = tempItem:AddComponent(UIBaseContainer, "Rect_RewardEffect")
    newOne.duihao = tempItem:AddComponent(UIBaseContainer, "duihao")
    table.insert(self.rewardItemsTb, newOne)
  end
  self.claimBtnN = self:AddComponent(UIButton, claimBtn_path)
  self.claimBtnN:SetOnClick(function()
    self:OnClickClaimBtn()
  end)
  self.completeMarkN = self:AddComponent(UIBaseContainer, completeMark_path)
  self.completeMarkN:SetActive(false)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickJumpBtn()
  end)
  self.taskStautsN = self:AddComponent(UIText, taskStatus_path)
  self.timerTxtN = nil
  self.unlockModuleN = self:AddComponent(UIBaseContainer, unlockModule_path)
  self.unlockModuleIconN = self:AddComponent(UIImage, unlockModuleIcon_path)
  self.unlockModuleBtnN = self:AddComponent(UIButton, unlockModuleBtn_path)
  self.unlockModuleBtnN:SetOnClick(function()
    self:OnClickUnlockModule()
  end)
  self.questBgN = self:AddComponent(UIImage, questBg_path)
  self.unableClaimRewardMarkN = self:AddComponent(UIBaseContainer, unableClaimRewardMark_path)
  self.unableClaimRewardMarkN:SetActive(false)
  self.unableClaimRewardFinishTimeN = self:AddComponent(UIText, unableClaimRewardFinishTime_path)
  self.unableClaimRewardTipN = self:AddComponent(UIText, unableClaimRewardTip_path)
end

local function ComponentDestroy(self)
  self.taskNameN = nil
  self.taskDescN = nil
  self.claimRankN = nil
  self.shareBtnN = nil
  self.taskProgN = nil
  self.progTxtN = nil
  self.progEndTimeN = nil
  self.startTimeText = nil
  self.finishedTipN = nil
  self.endTipN = nil
  self.arrowLN = nil
  self.arrowRN = nil
  self.rewardItemsTb = nil
  self.claimBtnN = nil
  self.jumpBtnN = nil
  self.timerTxtN = nil
  self.questBgN = nil
  self.unableClaimRewardMarkN = nil
  self.unableClaimRewardFinishTimeN = nil
  self.unableClaimRewardTipN = nil
end

local function DataDefine(self)
  self.taskInfo = nil
  self.taskConf = nil
  self.curRewardRank = 1
  if DataCenter.AllianceBaseDataManager:IsSelfLeader() then
    self.curRewardRank = 1
  elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
    self.curRewardRank = 2
  else
    self.curRewardRank = 3
  end
end

local function DataDestroy(self)
  self.taskInfo = nil
  self.taskConf = nil
  self.curRewardRank = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnUpdateAllianceTask, self.OnUpdateAllianceTask)
end

local function OnUpdateAllianceTask(self, taskId)
  if taskId then
    local nTaskId = toInt(taskId)
    if toInt(self.taskInfo.taskId) == nTaskId or toInt(self.taskConf.id) == nTaskId then
      self:RefreshAll()
    end
  else
    self:RefreshAll()
  end
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnUpdateAllianceTask, self.OnUpdateAllianceTask)
  base.OnRemoveListener(self)
end

local function SetItem(self, taskConf, isSeason)
  self.taskConf = taskConf
  self.isSeason = isSeason
  self:RefreshAll()
end

local function RefreshAll(self)
  if self.isSeason then
    self.taskInfo = DataCenter.AllianceSeasonTaskManager:GetTaskInfo(self.taskConf.id)
  else
    self.taskInfo = DataCenter.AllianceTaskManager:GetTaskInfo(self.taskConf.id)
  end
  self.taskNameN:SetLocalText(self.taskConf.name)
  if self.taskConf.jump == 10 then
    local name1 = LocalController:instance():getValue(TableName.AlScienceTab, tostring(self.taskConf.param2), "name", "")
    name1 = Localization:GetString(name1)
    self.taskDescN:SetLocalText(self.taskConf.desc, name1)
  else
    local param2 = self.taskConf.param2
    if self.taskConf.type == 15 then
      local buildId = string.match(param2, "([^;]+);?")
      local tmp = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
      if tmp and tmp.name then
        param2 = Localization:GetString(tmp.name)
      end
      self.taskDescN:SetLocalText(self.taskConf.desc, param2)
    elseif self.taskConf.type == 16 then
      local buildId = string.match(param2, "([^;]+);?")
      local tmp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      if tmp and tmp.name then
        param2 = Localization:GetString(tmp.name)
      end
      self.taskDescN:SetLocalText(self.taskConf.desc, self.taskConf.param, param2)
    elseif self.taskConf.type == 18 then
      self.taskDescN:SetLocalText(self.taskConf.desc, param2)
    else
      self.taskDescN:SetLocalText(self.taskConf.desc, self.taskConf.param, param2)
    end
  end
  self.jumpBtnN:SetActive(self.taskConf.jump and self.taskConf.jump > 0)
  if not string.IsNullOrEmpty(self.taskConf.icon) then
    self.questBgN:LoadSpriteAsync(self.taskConf.icon)
  else
    self.questBgN:LoadSpriteAsync(string.format(LoadPath.UIWorldTrend, self.taskConf.quest_pic))
  end
  self.questBgN:SetColor(Color.New(1, 1, 1, 1))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local taskStatus, tempTime = self.taskInfo:GetTaskStatus()
  if taskStatus == 1 then
    self.startTimeN:SetActive(true)
    self.timerEndT = tempTime
    self.timerTxtN = self.startTimeText
    self.not_start_tip:SetLocalText(455049)
    local days = (tempTime - curTime) / 86400000
    if 1 <= days then
      self:DelTimer()
      local strD = math.ceil(days) .. Localization:GetString("100104")
      self.timerTxtN:SetText(strD)
    else
      self:AddTimer()
      self:SetRemainTime()
    end
    self.taskProgN:SetActive(false)
    self.endTipN:SetActive(false)
    self.completeMarkN:SetActive(false)
    self.unableClaimRewardMarkN:SetActive(false)
    CS.UIGray.SetGray(self.questBgN.transform, false, false)
    self.questBgN:SetColor(Color.New(0.4, 0.4, 0.4, 1))
  elseif taskStatus == 2 then
    self.taskProgN:SetActive(true)
    self.taskProgN:SetValue(self.taskInfo.curProg / self.taskConf.param)
    self.progTxtN:SetText(self.taskInfo.curProg .. "/" .. self.taskConf.param)
    self.timerEndT = tempTime
    self.timerTxtN = self.progEndTimeN
    self:AddTimer()
    self:SetRemainTime()
    self.startTimeN:SetActive(false)
    self.endTipN:SetActive(false)
    self.completeMarkN:SetActive(false)
    self.unableClaimRewardMarkN:SetActive(false)
    CS.UIGray.SetGray(self.questBgN.transform, false, false)
  elseif taskStatus == 3 then
    local strFinishTime = UITimeManager:GetInstance():GetTimeToMD(math.modf(tempTime / 1000))
    self.finishedTipN:SetLocalText(390979, strFinishTime)
    self.timerEndT = 0
    self.timerTxtN = nil
    self:DelTimer()
    self.startTimeN:SetActive(false)
    self.taskProgN:SetActive(false)
    self.endTipN:SetActive(false)
    self.completeMarkN:SetActive(true)
    self.unableClaimRewardMarkN:SetActive(false)
    CS.UIGray.SetGray(self.questBgN.transform, false, false)
  elseif taskStatus == 5 then
    local strFinishTime = UITimeManager:GetInstance():GetTimeToMD(math.modf(tempTime / 1000))
    self.unableClaimRewardFinishTimeN:SetLocalText(390979, strFinishTime)
    self.unableClaimRewardTipN:SetLocalText("alliance_milestone_rewardErr_01")
    self.timerEndT = 0
    self.timerTxtN = nil
    self:DelTimer()
    self.startTimeN:SetActive(false)
    self.taskProgN:SetActive(false)
    self.endTipN:SetActive(false)
    self.completeMarkN:SetActive(false)
    self.unableClaimRewardMarkN:SetActive(true)
    CS.UIGray.SetGray(self.questBgN.transform, false, false)
  else
    self.endTipN:SetActive(true)
    self.endTipN:SetLocalText(390980)
    self.end_prog_text:SetText(self.taskInfo.curProg .. "/" .. self.taskConf.param)
    self.timerEndT = 0
    self.timerTxtN = nil
    self:DelTimer()
    self.startTimeN:SetActive(false)
    self.taskProgN:SetActive(false)
    self.completeMarkN:SetActive(false)
    self.unableClaimRewardMarkN:SetActive(false)
    CS.UIGray.SetGray(self.questBgN.transform, true, false)
  end
  if taskStatus == 1 then
    CS.UIGray.SetGray(self.rewardBgN.transform, true, false)
    CS.UIGray.SetGray(self.bgN.transform, true, false)
  else
    CS.UIGray.SetGray(self.rewardBgN.transform, false, false)
    CS.UIGray.SetGray(self.bgN.transform, false, false)
  end
  if taskStatus == 1 then
    self.taskStautsN:SetLocalText(390978)
  else
    self.taskStautsN:SetText("")
  end
  self:RefreshRewards(taskStatus)
end

local function RefreshRewards(self, taskStatus)
  if taskStatus == nil then
    taskStatus, _ = self.taskInfo:GetTaskStatus()
  end
  local canClaim = self.taskInfo:CheckIfCanClaim()
  local rewardsArr = self.taskInfo.rewards[self.curRewardRank]
  local rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardsArr)
  local isGray = taskStatus == 4
  local showDuihao = false
  if self.taskInfo.state == 2 then
    isGray = false
    showDuihao = true
    canClaim = false
  end
  for i, v in ipairs(self.rewardItemsTb) do
    if i <= #rewardsList then
      v.rootN:SetActive(true)
      v.itemN:ReInit(rewardsList[i])
      v.itemN:SetGray(isGray, true)
      v.effN:SetActive(canClaim)
      v.duihao:SetActive(showDuihao)
    else
      v.rootN:SetActive(false)
    end
  end
  self.unlockModuleN:SetActive(false)
  self.claimBtnN:SetActive(canClaim)
  if self.curRewardRank == 1 then
    self.claimRankN:SetLocalText(390975)
  elseif self.curRewardRank == 2 then
    self.claimRankN:SetLocalText(390977)
  elseif self.curRewardRank == 3 then
    self.claimRankN:SetLocalText(390976)
  end
end

local function AddTimer(self)
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

local function SetRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.timerEndT - curTime
  if 0 < remainTime then
    if self.timerTxtN then
      self.timerTxtN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    end
  else
    if self.timerTxtN then
      self.timerTxtN:SetText("")
    end
    self:DelTimer()
    self:RefreshAll()
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClickShareBtn(self)
  local status, tempTime = self.taskInfo:GetTaskStatus()
  if status == 3 or status == 4 then
    UIUtil.ShowTipsId(391036)
    return
  end
  if status == 1 then
    UIUtil.ShowTipsId(455056)
    return
  end
  self.view.ctrl:ShareTask(self.taskConf, self.taskInfo, tempTime)
end

local function OnClickClaimBtn(self)
  SFSNetwork.SendMessage(MsgDefines.ClaimAllianceTaskReward, self.taskConf.id)
end

local function OnClickJumpBtn(self)
  self.view.ctrl:JumpTo(self.taskConf.jump, self.taskConf.param2)
end

local function OnClickArrowR(self)
  if self.curRewardRank < #self.taskInfo.rewards then
    self.curRewardRank = self.curRewardRank + 1
  else
    self.curRewardRank = 1
  end
  self:RefreshRewards()
end

local function OnClickArrowL(self)
  if self.curRewardRank > 1 then
    self.curRewardRank = self.curRewardRank - 1
  else
    self.curRewardRank = #self.taskInfo.rewards
  end
  self:RefreshRewards()
end

local function OnClickUnlockModule(self)
  local param = {}
  param.itemName = self.taskConf.funcName
  param.itemDesc = self.taskConf.funcDesc
  param.alignObject = self.unlockModuleIconN
  param.isLocal = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UIAllianceTaskItem.OnCreate = OnCreate
UIAllianceTaskItem.OnDestroy = OnDestroy
UIAllianceTaskItem.ComponentDefine = ComponentDefine
UIAllianceTaskItem.ComponentDestroy = ComponentDestroy
UIAllianceTaskItem.DataDefine = DataDefine
UIAllianceTaskItem.DataDestroy = DataDestroy
UIAllianceTaskItem.OnAddListener = OnAddListener
UIAllianceTaskItem.OnRemoveListener = OnRemoveListener
UIAllianceTaskItem.RefreshAll = RefreshAll
UIAllianceTaskItem.RefreshRewards = RefreshRewards
UIAllianceTaskItem.OnUpdateAllianceTask = OnUpdateAllianceTask
UIAllianceTaskItem.OnClickShareBtn = OnClickShareBtn
UIAllianceTaskItem.OnClickClaimBtn = OnClickClaimBtn
UIAllianceTaskItem.OnClickJumpBtn = OnClickJumpBtn
UIAllianceTaskItem.AddTimer = AddTimer
UIAllianceTaskItem.SetRemainTime = SetRemainTime
UIAllianceTaskItem.DelTimer = DelTimer
UIAllianceTaskItem.OnClickArrowR = OnClickArrowR
UIAllianceTaskItem.OnClickArrowL = OnClickArrowL
UIAllianceTaskItem.OnClickUnlockModule = OnClickUnlockModule
UIAllianceTaskItem.SetItem = SetItem
return UIAllianceTaskItem
