local base = UIBaseView
local UILWGGGoActivity = BaseClass("UILWGGGoActivity", base)
local Localization = CS.GameEntry.Localization
local GameQualitySettings = require("Util.GameQualitySettings")
local left_buttom_path = "content/leftButtom"
local txt_title_path = "content/InfoVersion/content1/InfoVersion1_title1"
local go_title_path = "content/InfoVersion/content1/countdownParent"
local txt_time_path = "content/InfoVersion/content1/countdownParent/countdownRoot/countdown"
local btn_rule_path = "content/rightTop/DesBtn"
local btn_rank_path = "content/rightTop/RankBtn/rightTopRankBtn"
local txt_cur_level_path = "bottom/CurText"
local btn_game_path = "bottom/BtnGame"
local go_activity_Info_path = "content/InfoVersion"
local text_path = "bottom/BtnGame/Text"
local content_path = "content/leftButtom/content"
local reward_item_path = "content/leftButtom/content/rewardItem"
local txt_challenge_path = "content/leftButtom/txt_challenge"
local refresh_shop_time_path = "bottom/refreshShopTime"
local btn_p_v_p_path = "bottom/BtnPVP"
local tip_text_path = "bottom/TipText"
local bg_texture_path = "Image"

function UILWGGGoActivity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.itemViews = {}
  self.req = nil
end

function UILWGGGoActivity:OnDestroy()
  self.itemViews = nil
  self.req = nil
  self:DeleteTimer()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWGGGoActivity:OnEnable()
  base.OnEnable(self)
  self:Refresh()
  DataCenter.LWGGGoDataManager:SetReplayMode(false)
end

function UILWGGGoActivity:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGetGGGoInfo, self.SeasonGetGGGoInfoHandle)
  self:AddUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
  self:AddUIListener(EventId.SeasonGGGoPveStart, self.SeasonGGGoPveStartHandle)
  self:AddUIListener(EventId.SeasonGGGoPvpUpdateInfo, self.SeasonGGGoPvpUpdateInfoHandle)
end

function UILWGGGoActivity:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGetGGGoInfo, self.SeasonGetGGGoInfoHandle)
  self:RemoveUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
  self:RemoveUIListener(EventId.SeasonGGGoPveStart, self.SeasonGGGoPveStartHandle)
  self:RemoveUIListener(EventId.SeasonGGGoPvpUpdateInfo, self.SeasonGGGoPvpUpdateInfoHandle)
  base.OnRemoveListener(self)
end

function UILWGGGoActivity:ComponentDefine()
  self.left_buttom = self:AddComponent(UIBaseContainer, left_buttom_path)
  self.txt_challenge = self:AddComponent(UITextMeshProUGUIEx, txt_challenge_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.go_countdown = self:AddComponent(UIBaseContainer, go_title_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.btn_rule = self:AddComponent(UIButton, btn_rule_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.txt_cur_level = self:AddComponent(UIText, txt_cur_level_path)
  self.btn_game = self:AddComponent(UIButton, btn_game_path)
  self.go_activity_Info = self:AddComponent(UIBaseContainer, go_activity_Info_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.reward_item = self:AddComponent(UIBaseContainer, reward_item_path)
  self.refresh_shop_time = self:AddComponent(UITextMeshProUGUIEx, refresh_shop_time_path)
  self.btn_p_v_p = self:AddComponent(UIButton, btn_p_v_p_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.bg_texture = self:AddComponent(UIRawImage, bg_texture_path)
  self.go_reward = self.reward_item.gameObject
  self.go_reward:GameObjectCreatePool()
  self.btn_game:SetOnClick(BindCallback(self, self.OnGameClick))
  self.btn_rule:SetOnClick(BindCallback(self, self.OnRuleClick))
  self.btn_rank:SetOnClick(BindCallback(self, self.OnRankClick))
  self.btn_p_v_p:SetOnClick(BindCallback(self, self.OnPvPClick))
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
end

function UILWGGGoActivity:ComponentDestroy()
  self.go_reward:GameObjectRecycleAll()
  self.go_reward = nil
  self.activityId = nil
  self.activityInfo = nil
  self.timer_action = nil
  self.left_buttom = nil
  self.txt_challenge = nil
  self.txt_title = nil
  self.go_title = nil
  self.txt_time = nil
  self.btn_rule = nil
  self.btn_rank = nil
  self.txt_cur_level = nil
  self.btn_game = nil
  self.btn_p_v_p = nil
  self.text = nil
  self.content = nil
  self.reward_item = nil
  self.refresh_shop_time = nil
  self.tip_text = nil
  self.bg_texture = nil
end

function UILWGGGoActivity:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UILWGGGoActivity:SetData(activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.LWGGGoDataManager:GetActivityData(self.activityId)
  local tabData = LocalController:instance():getLine(TableName.Activity, toInt(activityId))
  if tabData == nil then
    return
  end
  self.go_activity_Info:SetActive(true)
  self.go_countdown:SetActive(true)
  if self.activityInfo then
    local name = Localization:GetString(self.activityInfo.name)
    self.txt_title:SetText(name)
    self.go_countdown:SetAnchoredPositionXY(0, -260)
    self:AddTimer(self.activityInfo)
  else
    self.go_countdown:SetActive(false)
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePveInfo, DataCenter.LWGGGoDataManager:GetActivityType())
  self.bg_texture:SetEnable(true)
end

function UILWGGGoActivity:CommonGetServerRewardHandle(reward)
  local configID = DataCenter.LWGGGoDataManager:GetUIShowLevelConfigID()
  local rewardId = tostring(GetTableData(TableName.SEASON_CAVE_EXPLORATION, configID, "reward"))
  if reward[rewardId] ~= nil then
    self:RefreshReward(reward[rewardId])
  end
end

function UILWGGGoActivity:SeasonGGGoPveStartHandle()
  if self.anim then
    self.anim:Play("moveout")
  end
  self.req = nil
end

function UILWGGGoActivity:SeasonGGGoPvpUpdateInfoHandle()
  self.req = nil
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  if not room:HasPvp() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoCreateRoom, {anim = true}, 2)
  elseif room:GetState() == LittleGameRoomState.WaitPlayer or room:GetState() == LittleGameRoomState.WaitReady then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoRoom, {anim = true})
  elseif room:GetState() == LittleGameRoomState.FightIng then
    DataCenter.LWGGGoManager:ReConnectPvp()
  elseif room:GetState() == LittleGameRoomState.FightDescribe or room:GetState() == LittleGameRoomState.FightEnd then
    UIUtil.ShowTipsId("season_s6_activity_minigame_latter_tips")
  end
end

function UILWGGGoActivity:SeasonGetGGGoInfoHandle()
  self:Refresh()
end

function UILWGGGoActivity:OnGameClick()
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local resourceLoaded = DataCenter.LWGGGoDataManager:GetResourceLoaded()
  if not resourceLoaded then
    DataCenter.LWGGGoDataManager:ToLoadRes()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc34")
    return
  end
  if DataCenter.LWGGGoDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  if DataCenter.LWGGGoDataManager:IsPass() then
    UIUtil.ShowTipsId("season_s4_activity_1200010_desc17")
    return
  end
  if DataCenter.LWGGGoDataManager:IsDayPass() then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    UIUtil.ShowTips(Localization:GetString("season_s4_activity_1200010_desc15", tip))
    return
  end
  local cloud = UIManager:GetInstance():GetWindow(UIWindowNames.UILWGGGoCloud)
  if cloud ~= nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePveStart, DataCenter.LWGGGoDataManager:GetVersion(), DataCenter.LWGGGoDataManager:GetActivityType())
end

function UILWGGGoActivity:OnRuleClick()
  if DataCenter.LWGGGoDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  local actData = DataCenter.LWGGGoDataManager:GetActivityData()
  local param = {}
  param.howToPlayList = actData.howtoplay
  param.story = actData.story
  param.defaultTitle = actData.name
  param.soundId = 6100057
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UILWGGGoActivity:OnRankClick()
  if DataCenter.LWGGGoDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoRank, {anim = true})
end

function UILWGGGoActivity:OnPvPClick()
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local pvpOpen, openTime = DataCenter.LWGGGoDataManager:IsPvpOpen()
  if not pvpOpen then
    local tip = UITimeManager:GetInstance():MilliSecondToFmtString(openTime)
    UIUtil.ShowTips(Localization:GetString("season_s5_activity_1200059_desc28", tip))
    return
  end
  if self.req then
    return
  end
  local resourceLoaded = DataCenter.LWGGGoDataManager:GetResourceLoaded()
  if not resourceLoaded then
    DataCenter.LWGGGoDataManager:ToLoadRes()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc34")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePvpInfo, 2, DataCenter.LWGGGoDataManager:GetActivityType())
  self.req = true
end

function UILWGGGoActivity:Refresh()
  if not DataCenter.LWGGGoDataManager:IsVail() then
    return
  end
  self:CheckRewards()
  local dayPass = DataCenter.LWGGGoDataManager:IsDayPass()
  local pass = DataCenter.LWGGGoDataManager:IsPass()
  local curLevel = DataCenter.LWGGGoDataManager:GetCurrentLevel()
  local maxLevel = DataCenter.LWGGGoDataManager:GetChallengeMaxLevel()
  local isNotLevel = pass or dayPass
  if isNotLevel then
    curLevel = maxLevel
  end
  self.txt_challenge:SetLocalText(800313, curLevel)
  self.btn_game:SetActive(not dayPass)
  self.refresh_shop_time:SetActive(dayPass)
  self.txt_cur_level:SetActive(not dayPass)
  self.tip_text:SetActive(dayPass)
  local anchoredPosition = self.btn_p_v_p:GetAnchoredPosition()
  self.btn_p_v_p:SetAnchoredPositionXY(135, anchoredPosition.y)
  if pass then
    self.refresh_shop_time:SetActive(false)
    self.tip_text:SetLocalText("season_s4_activity_1200010_desc17")
    self.btn_p_v_p:SetAnchoredPositionXY(0, anchoredPosition.y)
    return
  end
  if dayPass then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    self.refresh_shop_time:SetLocalText("season_s4_activity_1200010_desc15", tip)
    self.tip_text:SetLocalText("season_s4_activity_1200010_desc14")
    return
  end
  self.text:SetLocalText("activity_breakthrough_tips_6")
  self.txt_cur_level:SetLocalText(800313, Localization:GetString(135225, curLevel, maxLevel))
end

function UILWGGGoActivity:CheckRewards()
  local levelConfigID = DataCenter.LWGGGoDataManager:GetUIShowLevelConfigID()
  if levelConfigID ~= 0 then
    local rewardId = tostring(GetTableData(TableName.SEASON_CAVE_EXPLORATION, levelConfigID, "reward"))
    DataCenter.ClientRewardToServerDataManager:GetRewardById(rewardId)
  end
end

function UILWGGGoActivity:RefreshReward(reward)
  local pass = DataCenter.LWGGGoDataManager:IsPass() or DataCenter.LWGGGoDataManager:IsDayPass()
  local rewardParams = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
  if rewardParams then
    for i, paramInfo in ipairs(rewardParams) do
      local goName = "reward_item_" .. i
      local theItem = self.itemViews[goName]
      if theItem == nil then
        local goItem = self.go_reward:GameObjectSpawn(self.content.transform)
        goItem.name = goName
        theItem = self.content:AddComponent(UICommonResItem, goName)
        self.itemViews[goName] = theItem
      end
      theItem:SetActive(true)
      paramInfo.isShowReceFlag = pass
      theItem:ReInit(paramInfo)
    end
  end
end

function UILWGGGoActivity:RefreshTime()
  local data = self.activityInfo
  if data then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if data.endTime and curTime < data.endTime then
      self.txt_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(data.endTime - curTime))
    elseif data.endViewTime and curTime < data.endViewTime then
      local msg = Localization:GetString("370100")
      self.txt_time:SetText(msg .. "\n" .. UITimeManager:GetInstance():MilliSecondToFmtString(data.endViewTime - curTime))
    else
      self:DeleteTimer()
      self.go_countdown:SetActive(false)
    end
  else
    self:DeleteTimer()
    self.go_countdown:SetActive(false)
  end
  local dayPass = DataCenter.LWGGGoDataManager:IsDayPass()
  if dayPass then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    self.refresh_shop_time:SetLocalText("season_s4_activity_1200010_desc15", tip)
  end
end

function UILWGGGoActivity:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return UILWGGGoActivity
