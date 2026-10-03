local base = UIBaseContainer
local KillZombieActivityALKirovPanel = BaseClass("KillZombieActivityALKirovPanel", base)
local KillZombieALKirovModelPanel = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieALKirovModelPanel")
local KillZombieActivityALKirovReward = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieActivityALKirovReward")
local Localization = CS.GameEntry.Localization
local ActivityKillZombieManager = DataCenter.ActivityKillZombieManager
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local left_btn_path = "SwitchGroup/LeftBtnRoot/LeftBtn"
local right_btn_path = "SwitchGroup/RightBtnRoot/RightBtn"
local al_list_btn_path = "AlListBtn"
local u_i_model_panel_path = "PlaceGroup/UIModelPanel"
local reward_group_path = "RewardGroup"
local effect_root_path = "BgMask/EffectRoot"
local join_btn_path = "BottomGroup/JoinBtn"
local normal_root_path = "BottomGroup/NormalRoot"
local btn_text_path = "BottomGroup/NormalRoot/ChallengeBtn/BtnText"
local finish_icon_path = "BottomGroup/NormalRoot/FinishIcon"
local finished_text_path = "BottomGroup/NormalRoot/FinishIcon/FinishedText"
local rank_btn_path = "RankBtn"
local rank_btn_text_path = "RankBtn/RankBtnText"
local reward_btn_path = "BottomGroup/RewardBtn"
local calendar_add_btn_content_path = "CountDownArea/localTimeTextContent/localTimeText/CalendarAddBtnContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.isFirst = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.isFirst = false
  self.operated = false
end

local function ComponentDefine(self)
  self.rawImgBgRawImage = self:AddComponent(UIRawImage, "BgMask/BgRawImage")
  self.textContent = self:AddComponent(UITextMeshProUGUIEx, "ContentText")
  self.btnChallenge = self:AddComponent(UIButton, "BottomGroup/NormalRoot/ChallengeBtn")
  self.btnChallenge:SetOnClick(BindCallback(self, self.OnBtnChallengeClick))
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.left_btn:SetOnClick(BindCallback(self, self.OnBtnLeftClick))
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn:SetOnClick(BindCallback(self, self.OnBtnRightClick))
  self.alList_btn = self:AddComponent(UIButton, al_list_btn_path)
  self.alList_btn:SetOnClick(function()
    self:OnShowAlListBtnClick()
  end)
  self.u_i_model_panel = self:AddComponent(KillZombieALKirovModelPanel, u_i_model_panel_path)
  self.reward_group = self:AddComponent(KillZombieActivityALKirovReward, reward_group_path)
  self.effect_root = self:AddComponent(UIBaseContainer, effect_root_path)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(BindCallback(self, self.OnJoinBtnClick))
  self.normal_root = self:AddComponent(UIBaseContainer, normal_root_path)
  self.finish_icon = self:AddComponent(UIBaseContainer, finish_icon_path)
  self.finished_text = self:AddComponent(UITextMeshProUGUIEx, finished_text_path)
  self.finished_text:SetLocalText("challenge_zombie_end_btn")
  self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
  self.rank_btn:SetOnClick(BindCallback(self, self.OnRankBtnClick))
  self.rank_btn_text = self:AddComponent(UITextMeshProUGUIEx, rank_btn_text_path)
  self.rank_btn_text:SetLocalText("challenge_zombie_rank_btn")
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.reward_btn:SetOnClick(BindCallback(self, self.OnRewardBtnClick))
  self.obj_count_down = self:AddComponent(UIBaseContainer, "CountDownArea")
  self.obj_last_record = self:AddComponent(UIBaseContainer, "LastRecordArea")
  self.btn_Go_Plan_Boss = self:AddComponent(UIButton, "CountDownArea")
  self.btn_Go_Plan_Boss:SetOnClick(function()
    self:GoToPlanBoss()
  end)
  self.text_count_down = self:AddComponent(UITextMeshProUGUIEx, "CountDownArea/countDownText")
  self.text_local_time = self:AddComponent(UITextMeshProUGUIEx, "CountDownArea/localTimeTextContent/localTimeText")
  self.text_last_record = self:AddComponent(UITextMeshProUGUIEx, "LastRecordArea/numText")
  self.calendar_add_btn_content = self:AddComponent(CalendarAddBtnContent, calendar_add_btn_content_path)
end

local function ComponentDestroy(self)
  self.rawImgBgRawImage = nil
  self.textContent = nil
  self.btnChallenge = nil
  self.btn_text = nil
  self.left_btn = nil
  self.right_btn = nil
  self.alList_btn = nil
  self.u_i_model_panel = nil
  self.reward_group = nil
  self.effect_root = nil
  self.join_btn = nil
  self.normal_root = nil
  self.finish_icon = nil
  self.finished_text = nil
  self.rank_btn = nil
  self.rank_btn_text = nil
  self.reward_btn = nil
  self.obj_last_record = nil
  self.text_last_record = nil
  self.calendar_add_btn_content = nil
end

local function DataDefine(self)
  self.level = 0
  self.maxLevel = nil
  self.stage = nil
  self.selectedConfigId = nil
  self.curLevelBossId = nil
  self.sendMessage = nil
  self.validTime = nil
  self.isFirst = nil
  self.conditionDifficulty = nil
end

local function DataDestroy(self)
  self.level = nil
  self.maxLevel = nil
  self.stage = nil
  self.selectedConfigId = nil
  self.curLevelBossId = nil
  self.sendMessage = nil
  self.validTime = nil
  self.actData = nil
  self.isFirst = nil
  self.conditionDifficulty = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChallengeZombieOnUIModelClicked, self.OnBtnChallengeClick)
  self:AddUIListener(EventId.ChallengeZombieGetLaunchStationPoint, self.OnPutPointGot)
  self:AddUIListener(EventId.ChallengeZombieGetLaunchStationPoint, self.OnPutPointGot)
  self:AddUIListener(EventId.ChallengeZombieChangeLevelRight, self.OnBtnRightClick)
  self:AddUIListener(EventId.ChallengeZombieChangeLevelLeft, self.OnBtnLeftClick)
  self:AddUIListener(EventId.ChallengeZombieNewAlDataChanged, self.OnNewAlDataChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChallengeZombieOnUIModelClicked, self.OnBtnChallengeClick)
  self:RemoveUIListener(EventId.ChallengeZombieGetLaunchStationPoint, self.OnPutPointGot)
  self:RemoveUIListener(EventId.ChallengeZombieChangeLevelRight, self.OnBtnRightClick)
  self:RemoveUIListener(EventId.ChallengeZombieChangeLevelLeft, self.OnBtnLeftClick)
  self:RemoveUIListener(EventId.ChallengeZombieNewAlDataChanged, self.OnNewAlDataChanged)
  base.OnRemoveListener(self)
end

local function SetData(self, actData)
  self.actData = actData
  self:InitData()
  self:RefreshUI()
end

local function InitData(self)
  local dataList = ActivityKillZombieManager:GetListByType(2)
  local select_difficulty = 0
  local newAlData = ActivityKillZombieManager.newAlData
  if newAlData and 0 < newAlData.stage then
    local difficulty = GetTableData(TableName.activity_challenge_zombie, newAlData.configId, "difficulty")
    if difficulty then
      select_difficulty = difficulty % 1000
    end
  end
  local extraData = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if extraData then
    local maxUnReachProgress = 0
    local maxUnReachDifficulty = 0
    local maxSuccessDifficulty = 0
    local maxSelectDifficult = 0
    for difficulty = dataList.min, dataList.max do
      local cfgData = dataList.data[difficulty]
      if cfgData and ActivityKillZombieManager:CheckShowOpenCondition(cfgData.openTime.season, cfgData.openTime.seasonDay) then
        local serverData = extraData[tostring(difficulty)]
        local serverDataStatus = serverData and serverData.status or -1
        if serverDataStatus ~= 2 then
          local canInvoke, progressPercent = ActivityKillZombieManager:CanInvokeBossZombieAndProgress(difficulty)
          if canInvoke then
            maxSelectDifficult = difficulty
          elseif maxUnReachProgress < progressPercent then
            maxUnReachProgress = progressPercent
            maxUnReachDifficulty = difficulty
          end
        else
          maxSuccessDifficulty = math.max(maxSuccessDifficulty, difficulty)
        end
      end
    end
    if select_difficulty == 0 then
      select_difficulty = maxSelectDifficult
    end
    if select_difficulty == 0 then
      if maxSuccessDifficulty >= dataList.max then
        select_difficulty = dataList.max
      else
        select_difficulty = 0 < maxUnReachDifficulty and maxUnReachDifficulty or 1
      end
    end
  end
  self.level = select_difficulty == 0 and 1 or select_difficulty
  self.maxLevel = ActivityKillZombieManager.maxAlOpenDifficulty
  self.defaultChallengeLevel = self.level
  self.isPlanFuncOpen = ActivityKillZombieManager:GetIsPlanTimeFuncOpen()
  local planTime = ActivityKillZombieManager:GetBossPlanTimeFromServer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.obj_count_down:SetActive(self.isPlanFuncOpen and planTime and planTime > curTime)
  self:Update1000MS()
  self:ShowCalendatBtnContent()
end

function KillZombieActivityALKirovPanel:OnNewAlDataChanged()
  self:ShowCalendatBtnContent()
end

function KillZombieActivityALKirovPanel:ShowCalendatBtnContent()
  local planTime = ActivityKillZombieManager:GetBossPlanTimeFromServer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.isPlanFuncOpen and planTime and planTime > curTime then
    self.calendar_add_btn_content:SetActive(true)
    local startTime = toInt(planTime / 1000)
    local endTime = startTime
    self.calendar_add_btn_content:SetDataWithDefautValue(12, startTime, endTime, CalendarSourcePath.Activity)
  else
    self.calendar_add_btn_content:SetActive(false)
  end
end

function KillZombieActivityALKirovPanel:Update1000MS()
  if not self.isPlanFuncOpen then
    return
  end
  local planTime = ActivityKillZombieManager:GetBossPlanTimeFromServer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if not planTime or planTime <= curTime then
    if self.obj_count_down.gameObject.activeSelf then
      self.obj_count_down:SetActive(false)
    end
    return
  end
  local leftTime = planTime - curTime
  if 0 < leftTime then
    self.obj_count_down:SetActive(true)
    self.text_count_down:SetLocalText("appointment_time_preparation", UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    local localTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(planTime)
    self.text_local_time:SetLocalText("appointment_time_current_time", localTime)
  else
    self.obj_count_down:SetActive(false)
  end
end

local function RefreshUI(self)
  self:RefreshContent(self.level)
  self:RefreshBg()
  self.alList_btn:SetActive(LuaEntry.Player:IsInAlliance())
  self:UpdateSwitchState()
  self:RefreshLastRecord()
end

local function RefreshLastRecord(self)
  local lastDamage = ActivityKillZombieManager:GetLastDamage()
  if lastDamage ~= 0 then
    local lastConfigId = ActivityKillZombieManager:GetLastConfigId()
    if lastConfigId == self.selectedConfigId then
      local open = false
      if self.stage == ChallengeZombieAlStageStatus.Prepare or self.stage == ChallengeZombieAlStageStatus.Battle then
        open = true
      elseif self.isPlanFuncOpen then
        local planTime = ActivityKillZombieManager:GetBossPlanTimeFromServer()
        open = planTime and planTime ~= 0
      end
      self.obj_last_record:SetActive(not open)
      if not open then
        local lastDamageStr = string.GetFormattedStr0(lastDamage)
        self.text_last_record:SetLocalText("challenge_zombie_alliance_score", lastDamageStr)
      end
    else
      self.obj_last_record:SetActive(false)
    end
  else
    self.obj_last_record:SetActive(false)
  end
end

local function RefreshContent(self, level)
  if level == 0 then
    return
  end
  local cfgData = ActivityKillZombieManager:GetDataWithTypeAndLevel(2, level)
  if cfgData then
    local curLevelBossId = cfgData.advanced_challenge_boss
    self.selectedConfigId = cfgData.id
    self.curLevelBossId = curLevelBossId
    self.u_i_model_panel:RefreshPanel(curLevelBossId)
    self:RefreshRewardGroup(curLevelBossId)
    local extraData = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
    local serverData = extraData and extraData[tostring(level)]
    self:RefreshBtnGroup(serverData, level)
    local conditionList = cfgData.conditionList
    local show = false
    local conditionDifficulty
    if conditionList ~= nil then
      for _, v in ipairs(conditionList) do
        if v.data.ui_type == 1 then
          local canAttack = DataCenter.ActivityKillZombieManager:CanInvokeBossZombie(level)
          local tipMsg = ""
          local finish_count = serverData and serverData.progress or 0
          if canAttack then
            tipMsg = Localization:GetString("challenge_zombie_open_condition", finish_count, v.count, v.data.relDifficultyInLevel)
          else
            tipMsg = Localization:GetString("challenge_zombie_open_condition_1", finish_count, v.count, v.data.relDifficultyInLevel)
          end
          conditionDifficulty = v.data.difficulty
          self.textContent:SetText(tipMsg)
          show = true
        end
      end
    end
    self.conditionDifficulty = conditionDifficulty
    self.textContent:SetActive(show)
  end
end

local function RefreshRewardGroup(self, bossId)
  local newAlData = DataCenter.ActivityKillZombieManager.newAlData
  if newAlData and newAlData.bossId == bossId then
    self.reward_group:RefreshView(bossId, newAlData.personalDamage, newAlData.allianceDamage)
  else
    self.reward_group:RefreshView(bossId, 0, 0)
  end
  if self.isFirst then
    if self.isFirst then
      self.isFirst = false
    end
    self.reward_group:ShowDefaultRewardBubble(true, true)
  elseif not self.operated then
    self.reward_group:ShowDefaultRewardBubble(true)
  else
    self.reward_group:ShowDefaultRewardBubble(false)
  end
end

local function RefreshBg(self)
  if self.curLevelBossId then
    local template = DataCenter.AdvancedChallengeBossTemplateManager:GetTemplate(self.curLevelBossId)
    if template then
      local newAlData = ActivityKillZombieManager.newAlData
      if newAlData and newAlData.bossId == self.curLevelBossId then
        if newAlData.stage == ChallengeZombieAlBossStage.Battle then
          self.rawImgBgRawImage:LoadSprite(template.advanced_challenge_banner_ui)
        else
          self.rawImgBgRawImage:LoadSprite(template.advanced_challenge_box_ui)
        end
      else
        self.rawImgBgRawImage:LoadSprite(template.advanced_challenge_box_ui)
      end
      self:InstanceBgEffect(template.advanced_challenge_effect_ui_env)
    end
  end
end

local function RefreshBtnGroup(self, serverData, level)
  if level == 0 then
    return
  end
  local stage = ChallengeZombieAlStageStatus.None
  if LuaEntry.Player:IsInAlliance() then
    stage = ChallengeZombieAlStageStatus.Unreached
    local serverDataStatus = serverData and serverData.status or -1
    if serverDataStatus ~= 2 then
      local canInvoke, _ = ActivityKillZombieManager:CanInvokeBossZombieAndProgress(level)
      if canInvoke then
        stage = ChallengeZombieAlStageStatus.Reached
      end
      if ActivityKillZombieManager.isNewFuncOpen then
        local newAlData = ActivityKillZombieManager.newAlData
        if newAlData and newAlData.bossUuid and 0 < newAlData.bossUuid then
          if newAlData.bossId == self.curLevelBossId then
            if newAlData.stage == ChallengeZombieAlBossStage.Prepare then
              stage = ChallengeZombieAlStageStatus.Prepare
            elseif newAlData.stage == ChallengeZombieAlBossStage.Settlement then
              stage = ChallengeZombieAlStageStatus.Settlement
            else
              stage = ChallengeZombieAlStageStatus.Battle
            end
          else
            stage = ChallengeZombieAlStageStatus.OpenOther
          end
        end
      end
    else
      stage = ChallengeZombieAlStageStatus.Settlement
    end
  end
  self.stage = stage
  if stage == ChallengeZombieAlStageStatus.None then
    self.normal_root:SetActive(false)
    self.join_btn:SetActive(true)
  else
    self.normal_root:SetActive(true)
    self.join_btn:SetActive(false)
    if stage == ChallengeZombieAlStageStatus.OpenOther then
      self.btnChallenge:SetActive(true)
      self.btn_text:SetLocalText("challenge_zombie_open_condition_btn")
      self.finish_icon:SetActive(false)
      CS.UIGray.SetGray(self.btnChallenge.transform, true, true)
    else
      CS.UIGray.SetGray(self.btnChallenge.transform, false, true)
      if stage == ChallengeZombieAlStageStatus.Settlement then
        self.btnChallenge:SetActive(false)
        self.finish_icon:SetActive(true)
      else
        self.btnChallenge:SetActive(true)
        self.finish_icon:SetActive(false)
        if stage == ChallengeZombieAlStageStatus.Unreached or stage == ChallengeZombieAlStageStatus.Reached then
          self.btn_text:SetLocalText("challenge_zombie_start_btn")
        elseif stage == ChallengeZombieAlStageStatus.Prepare or stage == ChallengeZombieAlStageStatus.Battle then
          self.btn_text:SetLocalText("challenge_zombie_fighting_btn")
        end
      end
    end
  end
end

local function UpdateSwitchState(self)
  local leftShow = true
  if self.level == 1 then
    leftShow = false
  end
  self.left_btn:SetActive(leftShow)
end

local function SendChallengeMsg(self)
  if self.selectedConfigId and not self.sendMessage then
    self.sendMessage = true
    SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewBuildPoint, self.selectedConfigId)
  end
end

local function OnPutPointGot(self, message)
  self.sendMessage = false
end

local function OnBtnChallengeClick(self)
  print("self.selectedConfigId: " .. self.selectedConfigId)
  if self.stage == ChallengeZombieAlStageStatus.Unreached then
    UIUtil.ShowTipsId("challenge_zombie_open_condition_num")
  elseif self.stage == ChallengeZombieAlStageStatus.Reached then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local validTime = self.validTime * 60 * 60 * 1000
    local endTime = self.actData and self.actData.endTime or 0
    local remain = endTime - curTime
    if validTime > remain then
      local context = Localization:GetString("challenge_zombie_count_down_hour", self.validTime)
      UIUtil.ShowTips(context)
      return
    end
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      if 0 < self.level and self.curLevelBossId then
        if self.isPlanFuncOpen then
          local param = {}
          param.curSelectedConfigId = self.selectedConfigId
          param.maxCanChallengeLevel = self.defaultChallengeLevel
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceKirovPlanTime, {anim = true}, param)
        else
          self:SendChallengeMsg()
        end
      end
    else
      UIUtil.ShowTipsId("challenge_zombie_start_person_tips")
    end
  elseif self.stage >= ChallengeZombieAlStageStatus.Prepare and self.stage <= ChallengeZombieAlStageStatus.Settlement then
    local newAlData = ActivityKillZombieManager.newAlData
    local point = newAlData and newAlData.bossPointId or 0
    local bossServerId = newAlData and newAlData.bossServerId or nil
    ActivityKillZombieManager:GotoWorldPos(point, function(point)
      GoToUtil.OnClickWorldPoint(point)
    end, bossServerId)
  elseif self.stage == ChallengeZombieAlStageStatus.OpenOther then
    UIUtil.ShowTipsId("challenge_zombie_open_condition_tips")
  end
end

local function OnBtnLeftClick(self)
  if self.level == 1 then
    return
  end
  self.operated = true
  self.level = self.level - 1
  self:RefreshUI()
end

local function OnBtnRightClick(self)
  if self.level == self.maxLevel then
    UIUtil.ShowTipsId("challenge_zombie_level_select_tips")
    return
  end
  self.operated = true
  self.level = self.level + 1
  self:RefreshUI()
end

local function OnShowAlListBtnClick(self)
  if self.conditionDifficulty and self.conditionDifficulty > 0 then
    local param = {
      difficulty = self.conditionDifficulty,
      curDifficult = self.level
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIALChallengeRank, {anim = true}, param)
  end
end

local function OnJoinBtnClick(self)
  local params = {
    guide = false,
    al_success_callback = function()
      SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlCreateJoin)
      self:InitData()
      self:RefreshUI()
    end,
    al_lose_callback = function()
    end
  }
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true}, params)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

local function OnRankBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.KillZombieAlChallengeRank)
end

local function OnRewardBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIKillZombieAlReward, self.level, self.maxLevel)
end

local function InstanceBgEffect(self, path)
  if self.effectData and self.effectData.path == path and self.effectData.req then
    return
  end
  self:ClearBgEffect()
  self.effectData = {}
  self.effectData.path = path
  self.effectData.req = self:GameObjectInstantiateAsync(path, function(request)
    if request.isError then
      return
    end
    if self.effect_root then
      local go = request.gameObject
      go.transform:SetParent(self.effect_root.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    end
  end)
end

local function ClearBgEffect(self)
  if self.effectData then
    if self.effectData.req then
      self.effectData.req:Destroy()
    end
    self.effectData = nil
  end
end

local function GetValidTime(self)
  local value = LuaEntry.DataConfig:TryGetNum("advanced_challenge", "k13", 0)
  self.validTime = value
  return self.validTime
end

function KillZombieActivityALKirovPanel:GoToPlanBoss()
  local newAlData = ActivityKillZombieManager.newAlData
  if newAlData and newAlData.bossPointId and newAlData.bossPointId > 0 then
    local point = newAlData.bossPointId
    local bossServerId = newAlData.bossServerId
    ActivityKillZombieManager:GotoWorldPos(point, function(point)
      GoToUtil.OnClickWorldPoint(point)
    end, bossServerId)
  end
end

KillZombieActivityALKirovPanel.OnCreate = OnCreate
KillZombieActivityALKirovPanel.OnDestroy = OnDestroy
KillZombieActivityALKirovPanel.OnEnable = OnEnable
KillZombieActivityALKirovPanel.OnDisable = OnDisable
KillZombieActivityALKirovPanel.ComponentDefine = ComponentDefine
KillZombieActivityALKirovPanel.ComponentDestroy = ComponentDestroy
KillZombieActivityALKirovPanel.DataDefine = DataDefine
KillZombieActivityALKirovPanel.DataDestroy = DataDestroy
KillZombieActivityALKirovPanel.OnAddListener = OnAddListener
KillZombieActivityALKirovPanel.OnRemoveListener = OnRemoveListener
KillZombieActivityALKirovPanel.SetData = SetData
KillZombieActivityALKirovPanel.RefreshUI = RefreshUI
KillZombieActivityALKirovPanel.RefreshContent = RefreshContent
KillZombieActivityALKirovPanel.RefreshRewardGroup = RefreshRewardGroup
KillZombieActivityALKirovPanel.RefreshBg = RefreshBg
KillZombieActivityALKirovPanel.RefreshBtnGroup = RefreshBtnGroup
KillZombieActivityALKirovPanel.OnBtnChallengeClick = OnBtnChallengeClick
KillZombieActivityALKirovPanel.UpdateSwitchState = UpdateSwitchState
KillZombieActivityALKirovPanel.OnBtnLeftClick = OnBtnLeftClick
KillZombieActivityALKirovPanel.OnBtnRightClick = OnBtnRightClick
KillZombieActivityALKirovPanel.OnShowAlListBtnClick = OnShowAlListBtnClick
KillZombieActivityALKirovPanel.OnJoinBtnClick = OnJoinBtnClick
KillZombieActivityALKirovPanel.OnRankBtnClick = OnRankBtnClick
KillZombieActivityALKirovPanel.OnRewardBtnClick = OnRewardBtnClick
KillZombieActivityALKirovPanel.InitData = InitData
KillZombieActivityALKirovPanel.SendChallengeMsg = SendChallengeMsg
KillZombieActivityALKirovPanel.OnPutPointGot = OnPutPointGot
KillZombieActivityALKirovPanel.InstanceBgEffect = InstanceBgEffect
KillZombieActivityALKirovPanel.ClearBgEffect = ClearBgEffect
KillZombieActivityALKirovPanel.getters.validTime = GetValidTime
KillZombieActivityALKirovPanel.RefreshLastRecord = RefreshLastRecord
return KillZombieActivityALKirovPanel
