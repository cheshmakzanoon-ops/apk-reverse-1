local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActWorldBoss = BaseClass("ActWorldBoss", base)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local txt_tips_path = "rect/GameObject/Txt_Tips"
local txt_act_extra_path = "rect/GameObject/Txt_ActExtra"
local txt_act_name_path = "rect/ActivityTopGo/Txt_ActName"
local info_desc_path = "rect/ActivityTopGo/InfoDesc"
local txt_desc_path = "rect/ActivityTopGo/InfoDesc/Txt_Desc"
local p_go_boss_end_time_path = "rect/ActivityTopGo/p_go_boss_end_time"
local p_text_boss_end_time_path = "rect/ActivityTopGo/p_go_boss_end_time/p_text_boss_end_time"
local btn_convert_time_path = "rect/ActivityTopGo/InfoDesc/BtnConvertTime"
local txt_times_path = "rect/ActivityTopGo/Txt_Times"
local txt_buff_path = "rect/GameObject/Txt_Buff"
local btn_go_path = "rect/BtnGo"
local txt_btn_time_path = "rect/BtnGo/btnTime"
local intro_btn_path = "rect/BtnList/IntroBtn"
local btn_rank_path = "rect/BtnList/BtnRank"
local btn_reward_path = "rect/BtnList/BtnReward"
local btn_task_path = "rect/BtnList/BtnTask"
local btn_record_path = "rect/BtnList/BtnRecord"
local task_title_path = "rect/GameObject/TaskTitle"
local item_path = "rect/GameObject/Item"
local content_path = "rect/GameObject/ScrollView/Viewport/Content"
local background_raw_image_path = "rect_mask/BackgroundRawImage"
local monster_raw_image_path = "rect_mask/MonsterRawImage"
local foreground_raw_image_path = "rect_mask/ForegroundRawImage"
local red_point_path = "rect/BtnList/BtnTask/RedPoint"
local red_point_go_path = "rect/BtnGo/RedPointGo"
local red_num_path = "rect/BtnList/BtnTask/RedPoint/RedNum"
local info_v_s_path = "rect/ActivityTopGo/InfoVS"
local intro_btn_vs1_path = "rect/ActivityTopGo/InfoVS/IntroBtnVs1"
local vs1_path = "rect/ActivityTopGo/InfoVS/vs1"
local vs2_path = "rect/ActivityTopGo/InfoVS/vs2"
local score_v_s_path = "rect/GameObject/ScoreVS"
local intro_btn_vs2_path = "rect/GameObject/ScoreVS/IntroBtnVs2"
local soldier_slider1_path = "rect/GameObject/ScoreVS/SoldierSlider1"
local vs11_path = "rect/GameObject/ScoreVS/SoldierSlider1/vs11"
local value1_path = "rect/GameObject/ScoreVS/SoldierSlider1/Fill Area/Fill/value1"
local soldier_slider2_path = "rect/GameObject/ScoreVS/SoldierSlider2"
local vs22_path = "rect/GameObject/ScoreVS/SoldierSlider2/vs22"
local value2_path = "rect/GameObject/ScoreVS/SoldierSlider2/Fill Area/Fill/value2"
local rect_path = "rect"
local extra_path = "extra"
local btn_extra_path = "extra/btn_extra"
local btn_list_path = "rect/BtnList"
local game_object_path = "rect/GameObject"
local Notifier = require("Common.Notifier")

function ActWorldBoss:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.itemReqs = {}
  self.itemList = {}
end

function ActWorldBoss:ComponentDefine()
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.txt_tips = self:AddComponent(UIText, txt_tips_path)
  self.info_desc = self:AddComponent(UIBaseContainer, info_desc_path)
  self.txt_desc = self:AddComponent(UIText, txt_desc_path)
  self.p_go_boss_end_time = self:AddComponent(UIImage, p_go_boss_end_time_path)
  self.p_text_boss_end_time = self:AddComponent(UITextMeshProUGUIEx, p_text_boss_end_time_path)
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_act_extra = self:AddComponent(UIText, txt_act_extra_path)
  self.txt_times = self:AddComponent(UIText, txt_times_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickGoBtn()
  end)
  self.txt_btn_time = self:AddComponent(UIText, txt_btn_time_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRankBtn()
  end)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_reward:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRewardBtn()
  end)
  self.btn_task = self:AddComponent(UIButton, btn_task_path)
  self.btn_task:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTaskBtn()
  end)
  self.txt_buff = self:AddComponent(UIText, txt_buff_path)
  self.task_title = self:AddComponent(UIText, task_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.background_raw_image = self:AddComponent(UIRawImage, background_raw_image_path)
  self.monster_raw_image = self:AddComponent(UIRawImage, monster_raw_image_path)
  self.foreground_raw_image = self:AddComponent(UIRawImage, foreground_raw_image_path)
  self.red_point = self:AddComponent(UICommonRedPoint, red_point_path)
  self.red_point:SetType(CommonRedPointPriority.Level1)
  self.red_point_go = self:AddComponent(UICommonRedPoint, red_point_go_path)
  self.red_point_go:SetType(CommonRedPointPriority.Level1)
  self.info_v_s = self:AddComponent(UIBaseContainer, info_v_s_path)
  self.intro_btn_vs1 = self:AddComponent(UIButton, intro_btn_vs1_path)
  self.vs1 = self:AddComponent(UIText, vs1_path)
  self.vs2 = self:AddComponent(UIText, vs2_path)
  self.score_v_s = self:AddComponent(UIBaseContainer, score_v_s_path)
  self.intro_btn_vs2 = self:AddComponent(UIButton, intro_btn_vs2_path)
  self.soldier_slider1 = self:AddComponent(UISlider, soldier_slider1_path)
  self.vs11 = self:AddComponent(UIText, vs11_path)
  self.value1 = self:AddComponent(UIText, value1_path)
  self.soldier_slider2 = self:AddComponent(UISlider, soldier_slider2_path)
  self.vs22 = self:AddComponent(UIText, vs22_path)
  self.value2 = self:AddComponent(UIText, value2_path)
  self.rect = self:AddComponent(UIBaseContainer, rect_path)
  self.extra = self:AddComponent(UIBaseContainer, extra_path)
  self.btn_list = self:AddComponent(UIBaseContainer, btn_list_path)
  self.go_rewardObj = self:AddComponent(UIImage, game_object_path)
  self.btn_extra = self:AddComponent(UIButton, btn_extra_path)
  self.btn_extra:SetOnClick(function()
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.BossLogin.Type)
  end)
  self.intro_btn_vs1:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("801489")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.intro_btn_vs2:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("801490")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.btn_record = self:AddComponent(UIButton, btn_record_path)
  self.btn_record:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossRecord, {anim = true})
  end)
  self.btn_convert_time = self:AddComponent(UIButton, btn_convert_time_path)
  self.btn_convert_time:SetOnClick(function()
    self:ClickConvertTimeBtn()
  end)
  self:OnAttackTimesRefresh()
end

function ActWorldBoss:ComponentDestroy()
  self.intro_btn = nil
  self.txt_act_name = nil
  self.txt_act_extra = nil
  self.txt_times = nil
  self.btn_list = nil
  self.btn_rank = nil
  self.btn_reward = nil
  self.btn_record = nil
  self.info_desc = nil
  self.p_go_boss_end_time = nil
  self.p_text_boss_end_time = nil
  self.rect = nil
  self.extra = nil
  self.btn_extra = nil
  self.btn_list = nil
  self.go_rewardObj = nil
end

function ActWorldBoss:UnloadAssetRequest()
  if self.background_raw_image_assetRequest ~= nil then
    self.background_raw_image_assetRequest:Release()
    self.background_raw_image_assetRequest.completed = nil
    self.background_raw_image_assetRequest = nil
  end
  if self.monster_raw_image_assetRequest ~= nil then
    self.monster_raw_image_assetRequest:Release()
    self.monster_raw_image_assetRequest.completed = nil
    self.monster_raw_image_assetRequest = nil
  end
  if self.foreground_raw_image_assetRequest ~= nil then
    self.foreground_raw_image_assetRequest:Release()
    self.foreground_raw_image_assetRequest.completed = nil
    self.foreground_raw_image_assetRequest = nil
  end
end

function ActWorldBoss:OnDestroy()
  self:UnloadAssetRequest()
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self:ComponentDestroy()
  self.itemReqs = nil
  self.itemList = nil
  base.OnDestroy(self)
end

function ActWorldBoss:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnActBossRankRefresh, self.RefreshTasks)
  self:AddUIListener(EventId.OnActBossDataRefresh, self.OnAttackTimesRefresh)
  self:AddUIListener(EventId.OnActBossAttackTimesRefresh, self.OnAttackTimesRefresh)
  self.notiBook = {}
  Notifier.AddListener("ActWorldBoss.RefreshReddot", self.OnActBossAttackTimesRefresh, self, self.notiBook)
end

function ActWorldBoss:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnActBossRankRefresh, self.RefreshTasks)
  self:RemoveUIListener(EventId.OnActBossDataRefresh, self.OnAttackTimesRefresh)
  self:RemoveUIListener(EventId.OnActBossAttackTimesRefresh, self.OnAttackTimesRefresh)
  Notifier.RemoveListenerByBook(self.notiBook)
end

function ActWorldBoss:OnAttackTimesRefresh()
  local crossInfo = DataCenter.ActBossDataManager.crossInfo
  self:Update1000MS()
  if crossInfo == nil then
    local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoNow()
    if roundInfo and roundInfo.curVsRound and not DataCenter.ZoneWarManager:IsCampBattle() then
      local s1, s2 = DataCenter.ZoneWarManager:GetBattleServer()
      if s1 and s2 then
        crossInfo = {
          {serverId = s1, damage = 0},
          {serverId = s2, damage = 0}
        }
      end
    end
  end
  if crossInfo then
    local myServerId = LuaEntry.Player:GetSourceServerId()
    local myData, enemyData
    for _, v in ipairs(crossInfo) do
      if v.serverId == myServerId then
        myData = v
      else
        enemyData = v
      end
    end
    if myData and enemyData and myData.damage == 0 and enemyData.damage == 0 then
      self.info_v_s:SetActive(true)
      self.score_v_s:SetActive(false)
      self.vs1:SetText("#" .. myData.serverId)
      self.vs2:SetText("#" .. enemyData.serverId)
    elseif myData and enemyData then
      self.info_v_s:SetActive(true)
      self.score_v_s:SetActive(true)
      self.vs1:SetText("#" .. myData.serverId)
      self.vs2:SetText("#" .. enemyData.serverId)
      self.soldier_slider1:SetValue(1)
      self.soldier_slider2:SetValue(1)
      self.vs11:SetText("#" .. myData.serverId)
      self.vs22:SetText("#" .. enemyData.serverId)
      self.value1:SetText(string.GetFormattedStr(myData.damage))
      self.value2:SetText(string.GetFormattedStr(enemyData.damage))
      local total = myData.damage + enemyData.damage
      if total == 0 then
        self.soldier_slider1:SetValue(0.506)
        self.soldier_slider2:SetValue(0.506)
      else
        local value = math.min(math.max(myData.damage / total, 0.18), 0.8)
        self.soldier_slider1:SetValue(value + 0.006)
        self.soldier_slider2:SetValue(1 - value + 0.006)
      end
    else
      self.info_v_s:SetActive(false)
      self.score_v_s:SetActive(false)
    end
  else
    self.info_v_s:SetActive(false)
    self.score_v_s:SetActive(false)
  end
  local hasExtraActivity = DataCenter.LWSeasonBossLoginDataManager:IsVail()
  self.extra:SetActive(hasExtraActivity)
  self.go_rewardObj:SetActive(not hasExtraActivity)
  self.btn_list:SetActive(not hasExtraActivity)
end

function ActWorldBoss:RefreshTasks()
  local count = 0
  local taskList = DataCenter.ActBossDataManager.AchievementTaskData
  self.red_point:SetActive(false)
  if taskList ~= nil then
    for _, v in ipairs(taskList) do
      if v ~= nil and v.state == TaskState.CanReceive then
        count = count + 1
      end
    end
  end
  self.red_point:SetNum(0 < count and 1 or 0)
end

function ActWorldBoss:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    self.btn_rank:SetActive(false)
    self.btn_reward:SetActive(false)
    self.btn_task:SetActive(false)
    return
  end
  self.btn_rank:SetActive(true)
  self.btn_reward:SetActive(true)
  self.btn_task:SetActive(true)
  self.lastRequestTime = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
  SFSNetwork.SendMessage(MsgDefines.UserGetActBossAchievement, tostring(activityId))
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.txt_act_name:SetLocalText(self.data.bannerTittle)
  local backgroundPicPath, monsterPicPath, foregroundPicPath = DataCenter.ActBossDataManager:GetActBossShowPictureBySeason()
  self:UnloadAssetRequest()
  self.background_raw_image:SetActive(false)
  self.monster_raw_image:SetActive(false)
  self.foreground_raw_image:SetActive(false)
  local type = typeof(CS.UnityEngine.Texture2D)
  if not string.IsNullOrEmpty(backgroundPicPath) then
    self.background_raw_image_assetRequest = Resource:LoadAssetAsync(backgroundPicPath, type)
    if self.background_raw_image_assetRequest ~= nil then
      function self.background_raw_image_assetRequest.completed(asset)
        self.background_raw_image:SetTexture(asset.asset)
        
        self.background_raw_image:SizeFit()
        self.background_raw_image:SetActive(true)
      end
    end
  end
  if not string.IsNullOrEmpty(monsterPicPath) then
    self.monster_raw_image_assetRequest = Resource:LoadAssetAsync(monsterPicPath, type)
    if self.monster_raw_image_assetRequest ~= nil then
      function self.monster_raw_image_assetRequest.completed(asset)
        self.monster_raw_image:SetTexture(asset.asset)
        
        self.monster_raw_image:SizeFit()
        self.monster_raw_image:SetNativeSize()
        self.monster_raw_image:SetActive(true)
      end
    end
  end
  if not string.IsNullOrEmpty(foregroundPicPath) then
    self.foreground_raw_image_assetRequest = Resource:LoadAssetAsync(foregroundPicPath, type)
    if self.foreground_raw_image_assetRequest ~= nil then
      function self.foreground_raw_image_assetRequest.completed(asset)
        self.foreground_raw_image:SetTexture(asset.asset)
        
        self.foreground_raw_image:SizeFit()
        self.foreground_raw_image:SetActive(true)
      end
    end
  end
  self:RefreshTasks()
  self:OnActBossAttackTimesRefresh()
  self:InitRefreshTime()
  self:Update1000MS()
  self.txt_buff:SetLocalText(DataCenter.ActBossDataManager:FetchConfig("buff_desc", ""))
  local attackCount = DataCenter.ActBossDataManager.actBossTransTimes
  local attackRewards = DataCenter.ActBossDataManager:GetRewardsDataByActId(activityId, 2)
  local attackReward, attackRewardMax
  for _, v in ipairs(attackRewards) do
    if attackCount < v.times and (attackReward == nil or attackReward.times > v.times) then
      attackReward = v
    end
    if attackRewardMax == nil or attackRewardMax.times < v.times then
      attackRewardMax = v
    end
  end
  if DataCenter.ActBossDataManager.actBossTransTimes >= DataCenter.ActBossDataManager.rewardMaxTimes then
    self.task_title:SetLocalText("world_boss_today_finish_desc")
  elseif attackReward ~= nil then
    self.task_title:SetLocalText("world_boss_today_reward_desc", attackReward.times)
  end
  if attackReward == nil then
    attackReward = attackRewardMax
  end
  if attackReward ~= nil then
    local extraRewards = attackReward.rewards
    if extraRewards ~= nil then
      local goItem, theItem
      self.content:RemoveComponents(UICommonResItem)
      self.theItem:GameObjectRecycleAll()
      for i, item in ipairs(extraRewards) do
        local theName = "item_" .. i
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = theName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UICommonResItem, theName)
        item.isShowReceFlag = DataCenter.ActBossDataManager.actBossTransTimes >= DataCenter.ActBossDataManager.rewardMaxTimes
        theItem:ReInit(item)
      end
    end
  end
  DataCenter.ActBossDataManager:HideRedPoint()
  local isVisible = LuaEntry.DataConfig:CheckSwitch("world_boss_record_switch")
  self.btn_record:SetActive(isVisible)
end

function ActWorldBoss:OnHeroClick(i)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, self.heroTipParam[i])
end

function ActWorldBoss:ClickTip()
  if self.data ~= nil and self.data.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.data.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function ActWorldBoss:ClickGoBtn()
  if self.inWaitMode then
    UIUtil.ShowTips(Localization:GetString("456055", DataCenter.ActBossDataManager.bossName))
  else
    local dataList = DataCenter.ActBossDataManager:GetActBossDataList()
    if dataList ~= nil then
      for k, v in pairs(dataList) do
        local pos = v.startPos
        local serverId = v.serverId
        local worldPointPos = SceneUtils.TileIndexToWorld(pos, ForceChangeScene.World)
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, nil, serverId, 0)
        return
      end
    end
    self.lastRequestTime = UITimeManager:GetInstance():GetServerTime()
    SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
    UIUtil.ShowTipsId(302243)
  end
end

function ActWorldBoss:Update1000MS()
  if DataCenter.ActBossDataManager:GetRestTransNum() == -1 then
    self.txt_act_extra:SetActive(false)
  else
    self.txt_act_extra:SetActive(true)
    self.txt_act_extra:SetLocalText(456058, DataCenter.ActBossDataManager:GetRestTransNum())
  end
  if self.data == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local attackStage = DataCenter.ActBossDataManager:GetAttackStageData()
  self.inWaitMode = true
  self.inBattleMode = false
  if attackStage == nil then
    self.txt_times:SetText("")
    self.txt_btn_time:SetText("")
  elseif type(attackStage) == "number" then
    local remainTime = attackStage - curTime
    self.inWaitMode = true
    if 0 < remainTime then
      self.txt_times:SetLocalText(456032, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.txt_tips:SetLocalText(456032, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.txt_times:SetText("")
      self.txt_btn_time:SetText("")
    end
  elseif attackStage.startTime ~= nil then
    if curTime < attackStage.startTime then
      local remainTime = attackStage.startTime - curTime
      self.inWaitMode = true
      self.txt_times:SetLocalText(456034, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime), DataCenter.ActBossDataManager.bossName)
      self.txt_tips:SetLocalText(456034, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime), DataCenter.ActBossDataManager.bossName)
    else
      local remainTime = attackStage.endTime - curTime
      self.inBattleMode = true
      self.inWaitMode = false
      if (self.lastRequestTime == nil or curTime > self.lastRequestTime + 3000) and DataCenter.ActBossDataManager:GetActBossDataCount() == 0 then
        SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
        self.lastRequestTime = curTime
      end
      self.txt_times:SetLocalText(456033, UITimeManager:GetInstance():MilliSecondToFmtString(remainTime), DataCenter.ActBossDataManager.bossName)
      self.txt_btn_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    end
  else
    self.txt_times:SetText("")
    self.txt_btn_time:SetText("")
  end
  self:OnActBossAttackTimesRefresh()
end

function ActWorldBoss:ClickRankBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossRank, {anim = true}, self.activityId)
end

function ActWorldBoss:ClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossReward, {anim = true}, self.activityId)
end

function ActWorldBoss:ClickTaskBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossTask, {anim = true}, self.activityId)
end

function ActWorldBoss:OnActBossAttackTimesRefresh()
  self.red_point_go:SetDefaultVisible(DataCenter.ActBossDataManager:CanShowGoBtnReddot())
  local restTimes = DataCenter.ActBossDataManager:GetRestTransNum()
  if restTimes == -1 then
    self.txt_act_extra:SetActive(false)
    self.btn_go:SetActive(not self.inWaitMode)
    self.txt_tips:SetActive(self.inWaitMode)
  else
    self.txt_act_extra:SetActive(true)
    self.txt_act_extra:SetLocalText(456058, restTimes)
    self.btn_go:SetActive(0 < restTimes and not self.inWaitMode)
    self.txt_tips:SetActive(restTimes <= 0 or self.inWaitMode)
  end
  if DataCenter.LWSeasonBossLoginDataManager:IsVail() then
    self.btn_go:SetActive(false)
  end
end

function ActWorldBoss:InitRefreshTime()
  self.IsAllDayFuncOpen = DataCenter.ActBossDataManager.IsAllDayFuncOpen
  self.info_desc:SetActive(true)
  self.p_go_boss_end_time:SetActive(false)
  self:InitRefreshTimeDesc()
  self.isShowSvrTimeDesc = DataCenter.ActBossDataManager.isShowSvrTimeDesc
  local sDesc = self.isShowSvrTimeDesc and self.sDescSvr or self.sDescLocal
  if string.IsNullOrEmpty(sDesc) then
    self.txt_desc:SetActive(false)
    self.btn_convert_time:SetActive(false)
  else
    self.txt_desc:SetActive(true)
    self.btn_convert_time:SetActive(true)
    self.txt_desc:SetText(sDesc)
  end
end

function ActWorldBoss:InitRefreshTimeDesc()
  if self.IsAllDayFuncOpen then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local curZeroTimeStamp = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime // 1000) * 1000
    local spawnHour = DataCenter.ActBossDataManager.NewStartTime
    local nSecondInDay = spawnHour * 3600
    local sTimerSvr = UITimeManager:GetInstance():SecondToFmtStringHM(nSecondInDay)
    self.sDescSvr = Localization:GetString("world_boss_server_time_tips") .. sTimerSvr
    local nTimeStampLocal = curZeroTimeStamp + nSecondInDay * 1000
    local sTimeLocal = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(nTimeStampLocal, true, true)
    self.sDescLocal = Localization:GetString("world_boss_local_time_tips") .. sTimeLocal
  else
    local sTimerSvr = self:GetRefreshTimeString(true)
    self.sDescSvr = Localization:GetString("worldboss_serverTime", sTimerSvr)
    local sTimeLocal = self:GetRefreshTimeString(false)
    self.sDescLocal = Localization:GetString("worldboss_localTime", sTimeLocal)
  end
end

function ActWorldBoss:ClickConvertTimeBtn()
  DataCenter.ActBossDataManager:SetIsShowSvrTimeDesc(not self.isShowSvrTimeDesc)
  self.isShowSvrTimeDesc = DataCenter.ActBossDataManager.isShowSvrTimeDesc
  local sDesc = self.isShowSvrTimeDesc and self.sDescSvr or self.sDescLocal
  self.txt_desc:SetText(sDesc)
end

function ActWorldBoss:GetRefreshTimeString(isSvrTime)
  local tTimeList = DataCenter.ActBossDataManager:GetBossRefreshTime(isSvrTime)
  local sDesc = ""
  for i, v in ipairs(tTimeList) do
    if i == 1 then
      sDesc = sDesc .. v
    else
      sDesc = sDesc .. "  " .. v
    end
  end
  return sDesc
end

return ActWorldBoss
