local base = UIBaseView
local UILWBiuBiuActivity = BaseClass("UILWBiuBiuActivity", base)
local Localization = CS.GameEntry.Localization
local GameQualitySettings = require("Util.GameQualitySettings")
local webmVideoPath = "Assets/Main/Video/s5_banner_01_1.webm"
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
local txt_diff_path = "content/leftButtom/txt_challenge/txt_diff"
local refresh_shop_time_path = "bottom/refreshShopTime"
local btn_p_v_p_path = "bottom/BtnPVP"
local tip_text_path = "bottom/TipText"
local webm_bg_texture_path = "Image/RawImage"
local bg_texture_path = "Image"
local videoPlayer_rawImage = "Image/RawImage_Video"
local eff_ui_s5_preview_enviroment_path = "Image/Eff_ui_S5_preview_enviroment"

function UILWBiuBiuActivity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.itemViews = {}
  self.req = nil
end

function UILWBiuBiuActivity:OnDestroy()
  self.itemViews = nil
  self.gameView = nil
  self.req = nil
  self:DeleteTimer()
  self:ComponentDestroy()
  base.OnDestroy(self)
  if LuaEntry.DataConfig:CheckSwitch("video_alpha_channel") then
    CS.WebmVideoPlayerManager.Instance:PuseVideo(webmVideoPath)
  end
end

function UILWBiuBiuActivity:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

function UILWBiuBiuActivity:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGetBiuBiuInfo, self.SeasonGetBiuBiuInfoHandle)
  self:AddUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
  self:AddUIListener(EventId.SeasonBiuBiuPveStart, self.SeasonBiuBiuPveStartHandle)
  self:AddUIListener(EventId.SeasonBiuBiuPvpUpdateInfo, self.SeasonBiuBiuPvpUpdateInfoHandle)
  self:AddUIListener(EventId.OnVideoWebmAssetLoaded, self.OnVideoWebmAssetLoaded)
end

function UILWBiuBiuActivity:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGetBiuBiuInfo, self.SeasonGetBiuBiuInfoHandle)
  self:RemoveUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
  self:RemoveUIListener(EventId.SeasonBiuBiuPveStart, self.SeasonBiuBiuPveStartHandle)
  self:RemoveUIListener(EventId.SeasonBiuBiuPvpUpdateInfo, self.SeasonBiuBiuPvpUpdateInfoHandle)
  self:RemoveUIListener(EventId.OnVideoWebmAssetLoaded, self.OnVideoWebmAssetLoaded)
  base.OnRemoveListener(self)
end

function UILWBiuBiuActivity:ComponentDefine()
  self.left_buttom = self:AddComponent(UIBaseContainer, left_buttom_path)
  self.txt_challenge = self:AddComponent(UITextMeshProUGUIEx, txt_challenge_path)
  self.txt_diff = self:AddComponent(UITextMeshProUGUIEx, txt_diff_path)
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
  self.eff_ui_s5_preview_enviroment = self:AddComponent(UIBaseContainer, eff_ui_s5_preview_enviroment_path)
  self.webm_bg_texture = self:AddComponent(UIRawImage, webm_bg_texture_path)
  self.bg_texture = self:AddComponent(UIRawImage, bg_texture_path)
  self.videoPlayer_rawImage = self:AddComponent(UIRawImage, videoPlayer_rawImage)
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

function UILWBiuBiuActivity:ComponentDestroy()
  self.go_reward:GameObjectRecycleAll()
  self.go_reward = nil
  self.activityId = nil
  self.activityInfo = nil
  self.timer_action = nil
  self.left_buttom = nil
  self.txt_challenge = nil
  self.txt_diff = nil
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
  self.webm_bg_texture = nil
  self.bg_texture = nil
  self.eff_ui_s5_preview_enviroment = nil
end

function UILWBiuBiuActivity:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UILWBiuBiuActivity:SetData(activityId)
  if GameQualitySettings.IsLowGearQuality() then
    self.eff_ui_s5_preview_enviroment:SetActive(false)
  else
    self.eff_ui_s5_preview_enviroment:SetActive(true)
  end
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.LWBiuBiuDataManager:GetActivityData(self.activityId)
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
  SFSNetwork.SendMessage(MsgDefines.BiuBiuGetInfo)
  if LuaEntry.DataConfig:CheckSwitch("video_alpha_channel") then
    self.webm_bg_texture.gameObject:SetActive(true)
    self.bg_texture:SetEnable(false)
    self.videoPlayer_rawImage:SetEnable(false)
    CS.WebmVideoPlayerManager.Instance:LoadVideo(self.videoPlayer_rawImage.unityRawImage, webmVideoPath, 486, 810)
    self.videoPlayerCreater = self.videoPlayer_rawImage.gameObject:GetComponent(typeof(CS.VideoPlayerCreater))
    if self.videoPlayerCreater ~= nil then
      self.videoPlayerCreater.mCurentVideoPath = webmVideoPath
    end
  else
    self.webm_bg_texture.gameObject:SetActive(false)
    self.videoPlayer_rawImage:SetEnable(false)
    self.bg_texture:SetEnable(true)
  end
end

function UILWBiuBiuActivity:OnVideoWebmAssetLoaded()
  self.videoPlayer_rawImage:SetEnable(true)
end

function UILWBiuBiuActivity:CommonGetServerRewardHandle(reward)
  local configID = DataCenter.LWBiuBiuDataManager:GetUIShowLevelConfigID()
  local rewardId = tostring(GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, configID, "reward"))
  if reward[rewardId] ~= nil then
    self:RefreshReward(reward[rewardId])
  end
end

function UILWBiuBiuActivity:SeasonBiuBiuPveStartHandle()
  local function openWindow()
    if not self.gameView then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuGame, {
        anim = true,
        
        UIMainAnim = UIMainAnimType.AllHide
      })
      self.gameView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWBiuBiuGame)
    end
    if self.gameView == nil then
      return false
    end
    if self.gameView.View:InitFinish() then
      self.req = nil
      return true
    end
    return false
  end
  
  self.gameView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWBiuBiuGame)
  local curOpenCloudTime = Time.realtimeSinceStartup
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuCloud, {anim = true}, nil, function()
    Logger.LogInfo("[LWBiuBiu] UILWBiuBiuActivity UILWBiuBiuCloud Hold Func")
    if Time.realtimeSinceStartup - curOpenCloudTime >= 8 then
      if self.gameView ~= nil then
        self.gameView.View.ctrl:CloseSelf()
        self.gameView = nil
      end
      return true
    else
      return openWindow()
    end
  end)
end

function UILWBiuBiuActivity:SeasonBiuBiuPvpUpdateInfoHandle()
  self.req = nil
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  if not room:HasPvp() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuCreateRoom, {anim = true}, 2)
  elseif room:GetState() == LittleGameRoomState.WaitPlayer or room:GetState() == LittleGameRoomState.WaitReady then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuRoom, {anim = true})
  elseif room:GetState() == LittleGameRoomState.FightIng then
    DataCenter.LWBiuBiuManager:ReConnectPvp()
  elseif room:GetState() == LittleGameRoomState.FightDescribe or room:GetState() == LittleGameRoomState.FightEnd then
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc67")
  end
end

function UILWBiuBiuActivity:SeasonGetBiuBiuInfoHandle()
  self:Refresh()
end

function UILWBiuBiuActivity:OnGameClick()
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local resourceLoaded = DataCenter.LWBiuBiuDataManager:GetResourceLoaded()
  if not resourceLoaded then
    DataCenter.LWBiuBiuDataManager:ToLoadRes()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc34")
    return
  end
  if DataCenter.LWBiuBiuDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  if DataCenter.LWBiuBiuDataManager:IsPass() then
    UIUtil.ShowTipsId("season_s4_activity_1200010_desc17")
    return
  end
  if DataCenter.LWBiuBiuDataManager:IsDayPass() then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    UIUtil.ShowTips(Localization:GetString("season_s4_activity_1200010_desc15", tip))
    return
  end
  local cloud = UIManager:GetInstance():GetWindow(UIWindowNames.UILWBiuBiuCloud)
  if cloud ~= nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BiuBiuPVEGameStart, "Release" .. DataCenter.LWBiuBiuDataManager:GetVersion())
end

function UILWBiuBiuActivity:OnRuleClick()
  if DataCenter.LWBiuBiuDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  local actData = DataCenter.LWBiuBiuDataManager:GetActivityData()
  local param = {}
  param.howToPlayList = actData.howtoplay
  param.story = actData.story
  param.defaultTitle = actData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UILWBiuBiuActivity:OnRankClick()
  if DataCenter.LWBiuBiuDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuRank, {anim = true})
end

function UILWBiuBiuActivity:OnPvPClick()
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local pvpOpen, openTime = DataCenter.LWBiuBiuDataManager:IsPvpOpen()
  if not pvpOpen then
    local tip = UITimeManager:GetInstance():MilliSecondToFmtString(openTime)
    UIUtil.ShowTips(Localization:GetString("season_s5_activity_1200059_desc28", tip))
    return
  end
  if self.req then
    return
  end
  local resourceLoaded = DataCenter.LWBiuBiuDataManager:GetResourceLoaded()
  if not resourceLoaded then
    DataCenter.LWBiuBiuDataManager:ToLoadRes()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc34")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPInfo, 2)
  self.req = true
end

function UILWBiuBiuActivity:Refresh()
  if not DataCenter.LWBiuBiuDataManager:IsVail() then
    return
  end
  self:CheckRewards()
  local dayPass = DataCenter.LWBiuBiuDataManager:IsDayPass()
  local pass = DataCenter.LWBiuBiuDataManager:IsPass()
  local curLevel = DataCenter.LWBiuBiuDataManager:GetCurrentLevel()
  local maxLevel = DataCenter.LWBiuBiuDataManager:GetChallengeMaxLevel()
  local isNotLevel = pass or dayPass
  if isNotLevel then
    curLevel = maxLevel
  end
  self.txt_challenge:SetLocalText(800313, curLevel)
  local configID = DataCenter.LWBiuBiuDataManager:GetUIShowLevelConfigID()
  local diff = GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, configID, "difficulty")
  self.txt_diff:SetLocalText(diff)
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

function UILWBiuBiuActivity:CheckRewards()
  local levelConfigID = DataCenter.LWBiuBiuDataManager:GetUIShowLevelConfigID()
  if levelConfigID ~= 0 then
    local rewardId = tostring(GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, levelConfigID, "reward"))
    DataCenter.ClientRewardToServerDataManager:GetRewardById(rewardId)
  end
end

function UILWBiuBiuActivity:RefreshReward(reward)
  local pass = DataCenter.LWBiuBiuDataManager:IsPass() or DataCenter.LWBiuBiuDataManager:IsDayPass()
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

function UILWBiuBiuActivity:RefreshTime()
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
  local dayPass = DataCenter.LWBiuBiuDataManager:IsDayPass()
  if dayPass then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    self.refresh_shop_time:SetLocalText("season_s4_activity_1200010_desc15", tip)
  end
end

function UILWBiuBiuActivity:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return UILWBiuBiuActivity
