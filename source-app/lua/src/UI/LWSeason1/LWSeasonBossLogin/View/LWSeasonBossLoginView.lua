local base = UIBaseContainer
local LWSeasonBossLoginView = BaseClass("LWSeasonBossLoginView", base)
local Localization = CS.GameEntry.Localization
local LWSeasonBossLoginBossItem = require("UI.LWSeason1.LWSeasonBossLogin.Component.LWSeasonBossLoginBossItem")
local txt_remainTime_path = "Content/Detail/ContentTime/TimeTextBg/remainTime"
local img_Type_path = "Content/Center/img_Type"
local txt_addDamageTip_path = "Content/Center/txt_addDamageTip"
local go_item_left_path = "Content/Bottom/item_left"
local go_item_right_path = "Content/Bottom/item_right"
local txt_title_path = "Content/Detail/txt_title"
local btn_BtnRecord_path = "Content/Detail/BtnList/BtnRecord"
local btn_BtnRank_path = "Content/Detail/BtnList/BtnRank"
local btn_BtnTask_path = "Content/Detail/BtnList/BtnTask"
local btn_IntroBtn_path = "Content/Detail/IntroBtn"
local txt_resistance_path = "Content/Bottom/InfoPanel/txt_resistanceTip"
local txt_damageTip_path = "Content/Bottom/InfoPanel/txt_damageTip"
local img_ImgWarn_path = "Content/Bottom/InfoPanel/ImgWarn"
local txt_Tip_path = "Content/Bottom/txt_Tip"
local go_task_reddot_path = "Content/Detail/BtnList/BtnTask/go_task_reddot"
local rImg_BgTop_path = "Content/Bg/Mask/BgTop"
local go_InfoPanel_path = "Content/Bottom/InfoPanel"
local img_boss_real1_path = "Content/Center2/go_img_boss1/img_boss_real1"
local img_boss_real2_path = "Content/Center2/go_img_boss2/img_boss_real2"
local go_img_boss1_path = "Content/Center2/go_img_boss1"
local go_img_boss2_path = "Content/Center2/go_img_boss2"
local go_weakPanel1_path = "Content/Center2/go_img_boss1_weak/weakPanel1"
local go_weakPanel2_path = "Content/Center2/go_img_boss2_weak/weakPanel2"

function LWSeasonBossLoginView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonBossLoginView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonBossLoginView:ComponentDefine()
  self.txt_remainTime = self:AddComponent(UIText, txt_remainTime_path)
  self.img_Type = self:AddComponent(UIImage, img_Type_path)
  self.txt_addDamageTip = self:AddComponent(UIText, txt_addDamageTip_path)
  self.go_item_left = self:AddComponent(LWSeasonBossLoginBossItem, go_item_left_path)
  self.go_item_right = self:AddComponent(LWSeasonBossLoginBossItem, go_item_right_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.btn_BtnRecord = self:AddComponent(UIButton, btn_BtnRecord_path)
  self.btn_BtnRank = self:AddComponent(UIButton, btn_BtnRank_path)
  self.btn_BtnTask = self:AddComponent(UIButton, btn_BtnTask_path)
  self.btn_IntroBtn = self:AddComponent(UIButton, btn_IntroBtn_path)
  self.txt_resistance = self:AddComponent(UIText, txt_resistance_path)
  self.txt_damageTip = self:AddComponent(UIText, txt_damageTip_path)
  self.img_ImgWarn = self:AddComponent(UIImage, img_ImgWarn_path)
  self.txt_Tip = self:AddComponent(UIText, txt_Tip_path)
  self.go_task_reddot = self:AddComponent(UIBaseContainer, go_task_reddot_path)
  self.rImg_BgTop = self:AddComponent(UIRawImage, rImg_BgTop_path)
  self.go_InfoPanel = self:AddComponent(UIBaseContainer, go_InfoPanel_path)
  self.img_boss_real1 = self:AddComponent(UIImage, img_boss_real1_path)
  self.img_boss_real2 = self:AddComponent(UIImage, img_boss_real2_path)
  self.go_img_boss1 = self:AddComponent(UIBaseContainer, go_img_boss1_path)
  self.go_img_boss2 = self:AddComponent(UIBaseContainer, go_img_boss2_path)
  self.go_weakPanel1 = self:AddComponent(UIBaseContainer, go_weakPanel1_path)
  self.go_weakPanel2 = self:AddComponent(UIBaseContainer, go_weakPanel2_path)
  self.btn_BtnRank:SetOnClick(BindCallback(self, self.ClickRankBtn))
  self.btn_BtnTask:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTaskBtn()
  end)
  self.btn_BtnRecord:SetOnClick(function()
    if self:isActivityFunctionEnd(true) then
      return
    end
    if self:isNexBossRefreshTime(true) then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonBossLoginRecord, {anim = true})
  end)
  self.btn_IntroBtn:SetOnClick(function()
    local param = {}
    local actData = DataCenter.LWSeasonBossLoginDataManager:GetActivityData()
    if actData ~= nil then
      param.activityRulesStr = Localization:GetString(actData.story)
    else
      param.activityRulesStr = Localization:GetString("activity_s1pre_boss_desc")
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.needSendPro = nil
end

function LWSeasonBossLoginView:ComponentDestroy()
  self.txt_remainTime = nil
  self.img_Type = nil
  self.txt_addDamageTip = nil
  self.go_item_left = nil
  self.go_item_right = nil
  self.txt_title = nil
  self.btn_BtnRecord = nil
  self.btn_BtnRank = nil
  self.btn_BtnTask = nil
  self.btn_IntroBtn = nil
  self.txt_resistance = nil
  self.txt_damageTip = nil
  self.img_ImgWarn = nil
  self.txt_Tip = nil
  self.go_task_reddot = nil
  self.rImg_BgTop = nil
  self.go_InfoPanel = nil
  self.img_boss_real1 = nil
  self.img_boss_real2 = nil
  self.go_img_boss1 = nil
  self.go_img_boss2 = nil
  self.go_weakPanel1 = nil
  self.go_weakPanel2 = nil
  self.needSendPro = nil
  self.timer_action = nil
  self.activityId = nil
  self.data = nil
  self:DeleteTimer()
end

function LWSeasonBossLoginView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnActBossDataRefresh, self.RefreshView)
  self:AddUIListener(EventId.OnActBossRankRefresh, self.RefreshView)
  self:AddUIListener(EventId.SeasonVirusBossReddot, self.RefreshReddot)
end

function LWSeasonBossLoginView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnActBossDataRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.OnActBossRankRefresh, self.RefreshView)
  self:RemoveUIListener(EventId.SeasonVirusBossReddot, self.RefreshReddot)
end

function LWSeasonBossLoginView:ClickRankBtn()
  if self:isActivityFunctionEnd(true) then
    return
  end
  if self:isNexBossRefreshTime(true) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossRank, {anim = true}, DataCenter.LWSeasonBossLoginDataManager:GetActBossActivityId())
end

function LWSeasonBossLoginView:ClickTaskBtn()
  if self:isActivityFunctionEnd(true) then
    return
  end
  if self:isNexBossRefreshTime(true) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonBossLoginTask, {anim = true}, DataCenter.LWSeasonBossLoginDataManager:GetActBossActivityId())
end

function LWSeasonBossLoginView:SetData(activityId)
  self.go_item_left:SetActive(false)
  self.go_item_right:SetActive(false)
  self.go_InfoPanel:SetActive(false)
  self.go_img_boss1:SetActive(false)
  self.go_img_boss2:SetActive(false)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.data == nil then
    return
  end
  if self.data then
    local name = Localization:GetString(self.data.name)
    self.txt_title:SetText(name)
    self:AddTimer(self.data)
  end
  self.startTime = self.data.startTime
  self.endTime = self.data.endTime
  self:RefreshView()
  self:RefreshTime()
  self.lastRequestTime = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusInfo)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusAchievementRewardInfo)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusAchievementTaskInfo, tostring(DataCenter.LWSeasonBossLoginDataManager.activityId))
end

function LWSeasonBossLoginView:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function LWSeasonBossLoginView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWSeasonBossLoginView:RefreshTime()
  local data = self.data
  if data then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.startTime then
      deltaTime = self.startTime - curTime
    elseif curTime < self.endTime then
      deltaTime = self.endTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.txt_remainTime:SetText(showTime)
    else
      self.txt_remainTime:SetText("00:00:00")
      self:DeleteTimer()
    end
  else
    self:DeleteTimer()
  end
end

function LWSeasonBossLoginView:RefreshView()
  if not self.activityId then
    return
  end
  if self.data == nil then
    return
  end
  local _, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
  if seasonBoss == nil then
    return
  end
  local bossConfig = DataCenter.MonsterTemplateManager:GetMonsterTemplate(seasonBoss.monsterId)
  self.txt_addDamageTip:SetLocalText(DataCenter.LWSeasonBossLoginDataManager:FetchConfig("desc", ""))
  self.img_Type:LoadSprite(DataCenter.LWSeasonBossLoginDataManager:FetchConfig("icon", ""))
  local curResistanceValue = SeasonUtil.GetSelfSeasonResistanceValue() + (DataCenter.LWSpreadResearchDataManager.resistance or 0)
  local targetNeedResistance = bossConfig.monster_resistance
  local selfPercent = SeasonUtil.GetSeasonResistance1Self(curResistanceValue, targetNeedResistance)
  if 1 <= selfPercent then
    self.txt_resistance:SetColorHex("#5fef87")
    self.txt_damageTip:SetColorHex("#5fef87")
    self.img_ImgWarn:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/Mjc_saijijianzhu_tanhao_04.png")
  else
    self.txt_resistance:SetColorHex("#f97077")
    self.txt_damageTip:SetColorHex("#f97077")
    self.img_ImgWarn:LoadSprite("Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_tanhao_03.png")
  end
  self.txt_resistance:SetLocalText("activity_s1pre_boss_resistance", curResistanceValue, targetNeedResistance)
  if selfPercent < 1 then
    self.txt_damageTip:SetLocalText("activity_s1pre_boss_damage_redu", "-" .. string.GetFormattedPercentStr(math.abs(selfPercent - 1)))
  else
    self.txt_damageTip:SetLocalText("activity_s1pre_boss_damage_redu", "+" .. string.GetFormattedPercentStr(math.abs(selfPercent - 1)))
  end
  self:RefreshBossInfo()
  self:RefreshReddot()
  self.go_item_left:SetActive(true)
  self.go_item_right:SetActive(true)
  self.go_InfoPanel:SetActive(true)
  self.go_img_boss1:SetActive(true)
  self.go_img_boss2:SetActive(true)
end

function LWSeasonBossLoginView:RefreshReddot()
  self.go_task_reddot:SetActive(DataCenter.LWSeasonBossLoginDataManager:GetReddotType1())
end

function LWSeasonBossLoginView:RefreshBossInfo()
  local actBoss, seasonBoss = DataCenter.LWSeasonBossLoginDataManager:GetBossData()
  if actBoss ~= nil then
    self.go_item_left:SetData(false, actBoss, self.img_boss_real1, self.go_weakPanel1, self)
  end
  if seasonBoss ~= nil then
    self.go_item_right:SetData(true, seasonBoss, self.img_boss_real2, self.go_weakPanel2, self)
  end
  self.rImg_BgTop:LoadSpriteAsync(DataCenter.LWSeasonBossLoginDataManager:FetchConfig("boss_bg"))
end

function LWSeasonBossLoginView:ClickGoTo(bossData)
  if self.inWaitMode then
    if self:isActivityFunctionEnd(true) then
      return
    end
    if self:isNexBossRefreshTime(true) then
      return
    end
    UIUtil.ShowTips(Localization:GetString("456055", DataCenter.ActBossDataManager.bossName))
  else
    if bossData == nil then
      self.lastRequestTime = UITimeManager:GetInstance():GetServerTime()
      SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
      return
    end
    local pos = bossData.startPos
    local serverId = bossData.serverId
    local worldPointPos = SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, function()
      GoToUtil.OnClickWorldPoint(nil, nil, bossData.uuid)
    end, serverId, 0)
  end
end

function LWSeasonBossLoginView:isActivityFunctionEnd(tip)
  local isActivityFunctionEnd = DataCenter.LWSeasonBossLoginDataManager:GetActivityFunctionEnd()
  if isActivityFunctionEnd and tip then
    UIUtil.ShowTipsId(370100)
  end
  return isActivityFunctionEnd
end

function LWSeasonBossLoginView:isNexBossRefreshTime(tip)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isSeven = UITimeManager:GetInstance():GetNowWeekdayIndex() == 7
  local isSix = UITimeManager:GetInstance():GetNowWeekdayIndex() == 6
  local dayEnd = UITimeManager:GetInstance():GetTomorrowZero()
  local nextOpenTime = 0
  local isInTDay = dayEnd - curTime <= 3600000
  if isSeven or isSix and isInTDay then
    local nextWeek = UITimeManager:GetInstance():GetNextWeekDay(1)
    nextOpenTime = nextWeek - curTime
  elseif isInTDay then
    nextOpenTime = dayEnd - curTime
  end
  if 0 < nextOpenTime and tip then
    UIUtil.ShowTipsId(370100)
  end
  return 0 < nextOpenTime, nextOpenTime
end

function LWSeasonBossLoginView:SetActivityGoTo(active)
  self.go_item_right.btn_btn:SetActive(active)
  self.go_item_left.btn_btn:SetActive(active)
end

function LWSeasonBossLoginView:SetAttackState()
  self.txt_Tip:SetActive(self.inWaitMode)
  self:SetActivityGoTo(not self.inWaitMode)
end

function LWSeasonBossLoginView:Update1000MS()
  if self.data == nil then
    return
  end
  local isActivityFunctionEnd = DataCenter.LWSeasonBossLoginDataManager:GetActivityFunctionEnd()
  if isActivityFunctionEnd then
    self.txt_Tip:SetLocalText(370100)
    self.inWaitMode = true
    self:SetAttackState()
    return
  end
  local open, remainTime = self:isNexBossRefreshTime(false)
  if open then
    self.needSendPro = true
    self.inWaitMode = true
    self.txt_Tip:SetLocalText("activity_s1pre_boss_leave_desc", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    self:SetAttackState()
    return
  end
  if self.needSendPro then
    self.needSendPro = false
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local attackStage = DataCenter.ActBossDataManager:GetAttackStageData()
  self.inWaitMode = true
  self.txt_Tip:SetActive(false)
  if attackStage == nil then
    self.inWaitMode = true
  elseif type(attackStage) == "number" then
    self.inWaitMode = true
  elseif attackStage.startTime ~= nil then
    if curTime < attackStage.startTime then
      self.inWaitMode = true
      local remainTime = attackStage.startTime - curTime
      self.txt_Tip:SetLocalText("activity_s1pre_boss_leave_desc", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.inWaitMode = false
      if (self.lastRequestTime == nil or curTime > self.lastRequestTime + 3000) and DataCenter.ActBossDataManager:GetActBossDataCount() == 0 then
        SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
        self.lastRequestTime = curTime
      end
    end
  end
  self:SetAttackState()
end

return LWSeasonBossLoginView
