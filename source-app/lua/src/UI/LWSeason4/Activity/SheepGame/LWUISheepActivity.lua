local base = UIBaseView
local LWUISheepActivity = BaseClass("LWUISheepActivity", base)
local Localization = CS.GameEntry.Localization
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
local spine_chuanglian_path = "Image/Eff_chuanlian_fx/spine_chuanglian/SkeletonGraphic"
local DEFINE_DIFF_TEXT_IDS = {
  [1] = "season_s4_activity_1200010_desc28",
  [2] = "season_s4_activity_1200010_desc29",
  [3] = "season_s4_activity_1200010_desc30"
}

function LWUISheepActivity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.itemViews = {}
end

function LWUISheepActivity:OnDestroy()
  self.itemViews = nil
  self:DeleteTimer()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepActivity:OnEnable()
  base.OnEnable(self)
  SFSNetwork.SendMessage(MsgDefines.LWSheepGetInfo)
  self:Refresh()
end

function LWUISheepActivity:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGetSheepInfo, self.SeasonGetSheepInfoHandle)
  self:AddUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
end

function LWUISheepActivity:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGetSheepInfo, self.SeasonGetSheepInfoHandle)
  self:RemoveUIListener(EventId.CommonGetServerReward, self.CommonGetServerRewardHandle)
  base.OnRemoveListener(self)
end

function LWUISheepActivity:ComponentDefine()
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
  self.spine_chuanglian = self:AddComponent(UISpineLogic, spine_chuanglian_path)
  self.spine_chuanglian.spine:SetEmptyAnimation(0, 0)
  self.spine_chuanglian:SetPlayerMap({
    anims = {
      [1] = {animName = "in"},
      [2] = {animName = "idle"}
    }
  }, self.spine_chuanglian.UISpineLogicType.Once)
  self.spine_chuanglian.spine.animationState:Update(0)
  self.spine_chuanglian.spine.skeletonGraphic:Update(0)
  self.go_reward = self.reward_item.gameObject
  self.go_reward:GameObjectCreatePool()
  self.btn_game:SetOnClick(BindCallback(self, self.OnGameClick))
  self.btn_rule:SetOnClick(BindCallback(self, self.OnRuleClick))
  self.btn_rank:SetOnClick(BindCallback(self, self.OnRankClick))
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
end

function LWUISheepActivity:ComponentDestroy()
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
  self.text = nil
  self.content = nil
  self.reward_item = nil
  self.refresh_shop_time = nil
  self.spine_chuanglian = nil
end

function LWUISheepActivity:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function LWUISheepActivity:SetData(activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.LWSheepDataManager:GetActivityData(self.activityId)
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
end

function LWUISheepActivity:SeasonGetSheepInfoHandle()
  self:Refresh()
end

function LWUISheepActivity:CommonGetServerRewardHandle(reward)
  local blockId = DataCenter.LWSheepDataManager:GetCurBlockId()
  local normalId = tostring(GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "reward"))
  if reward[normalId] ~= nil then
    self:RefreshReward(reward[normalId])
  end
end

function LWUISheepActivity:OnGameClick()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  if DataCenter.LWSheepDataManager:IsPass() then
    UIUtil.ShowTipsId("season_s4_activity_1200010_desc17")
    return
  end
  if DataCenter.LWSheepDataManager:IsDayPass() then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    UIUtil.ShowTips(Localization:GetString("season_s4_activity_1200010_desc15", tip))
    return
  end
  
  local function openWindow()
    if not self.opened then
      self.opened = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISheepGame, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    end
    local sheepGameView = UIManager:GetInstance():GetWindow(UIWindowNames.LWUISheepGame)
    if sheepGameView == nil then
      return false
    end
    if sheepGameView.View:InitFinish() then
      self.opened = true
      return true
    end
    return false
  end
  
  self.opened = false
  local needToSendMsg = DataCenter.LWSheepDataManager:CheckNeedSendStartGameMsgOrOnlyCheck(true)
  if needToSendMsg then
    local waitTime = 8
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILUISheepCloud, {anim = true}, nil, function()
      waitTime = waitTime - 1
      if waitTime <= 0 then
        UIUtil.ShowTipsId(129063)
        return true
      else
        if not DataCenter.LWSheepDataManager:CheckNeedSendStartGameMsgOrOnlyCheck(false) then
          return openWindow()
        end
        return false
      end
    end)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILUISheepCloud, {anim = true}, nil, function()
      return openWindow()
    end)
  end
end

function LWUISheepActivity:OnRuleClick()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  local actData = DataCenter.LWSheepDataManager:GetActivityData()
  local param = {}
  param.howToPlayList = actData.howtoplay
  param.story = actData.story
  param.defaultTitle = actData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function LWUISheepActivity:OnRankClick()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISheepRank, {anim = true})
end

function LWUISheepActivity:Refresh()
  if not DataCenter.LWSheepDataManager:IsVail() then
    return
  end
  self:CheckRewards()
  local dayPass = DataCenter.LWSheepDataManager:IsDayPass()
  local pass = DataCenter.LWSheepDataManager:IsPass()
  local curLevel = DataCenter.LWSheepDataManager:GetCurrentLevel()
  local maxLevel = DataCenter.LWSheepDataManager:GetChallengeMaxLevel()
  local isNotLevel = pass or dayPass
  self.left_buttom:SetActive(not isNotLevel)
  if not isNotLevel then
    self.txt_challenge:SetLocalText(800313, DataCenter.LWSheepDataManager:GetCurrentLevel())
    local blockId = DataCenter.LWSheepDataManager:GetCurrentLevel() + 10000
    local diff = GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "difficulty")
    self.txt_diff:SetLocalText(DEFINE_DIFF_TEXT_IDS[diff])
  end
  self.btn_game:SetActive(not dayPass)
  self.refresh_shop_time:SetActive(dayPass)
  if dayPass then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    self.refresh_shop_time:SetLocalText("season_s4_activity_1200010_desc15", tip)
    self.txt_cur_level:SetLocalText("season_s4_activity_1200010_desc14")
    return
  end
  local notPlayed = DataCenter.LWSheepDataManager:NotPlayGame()
  if notPlayed then
    self.text:SetLocalText("activity_breakthrough_tips_6")
    self.txt_cur_level:SetLocalText("season_s4_activity_1200010_desc12")
    return
  end
  self.text:SetLocalText(400004)
  self.txt_cur_level:SetLocalText(800313, Localization:GetString(135225, curLevel, maxLevel))
end

function LWUISheepActivity:CheckRewards()
  if not DataCenter.LWSheepDataManager:IsPass() and not DataCenter.LWSheepDataManager:IsDayPass() then
    local blockId = DataCenter.LWSheepDataManager:GetCurBlockId()
    if blockId ~= nil then
      local normalId = tostring(GetTableData(TableName.SEASON_BLOCK_REMOVAL, blockId, "reward"))
      DataCenter.ClientRewardToServerDataManager:GetRewardById(normalId)
    end
  end
end

function LWUISheepActivity:RefreshReward(reward)
  if DataCenter.LWSheepDataManager:IsPass() or DataCenter.LWSheepDataManager:IsDayPass() then
    self.content:SetActive(false)
    return
  end
  self.content:SetActive(true)
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
      theItem:ReInit(paramInfo)
    end
  end
end

function LWUISheepActivity:RefreshTime()
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
  local dayPass = DataCenter.LWSheepDataManager:IsDayPass()
  if dayPass then
    local zeroTime = UITimeManager:GetInstance():GetTomorrowZero() / 1000
    local serverTime = UITimeManager:GetInstance():GetServerSeconds()
    local tip = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(zeroTime - serverTime)
    self.refresh_shop_time:SetLocalText("season_s4_activity_1200010_desc15", tip)
  end
end

function LWUISheepActivity:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return LWUISheepActivity
