local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonCampDestroyMain = BaseClass("SeasonCampDestroyMain", base)
local lua_SeasonCampDestroyZoneMap = "UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyZoneMap"
local lua_SeasonCampDestroyCampPreview = "UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyCampPreview"
local lua_SeasonCampDestroyCampAchievement = "UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyAchievement"
local lua_SeasonCampDestroyIdleDay = "UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyIdleDay"
local lua_SeasonCampDestroyBattleWait = "UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyBattleWait"
local lua_SeasonCampDestroyBattleDetail = "UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyBattleDetail"
local Localization = CS.GameEntry.Localization
local MID_INDEX = 5
local TOGGLE_INFO = 1
local TOGGLE_BATTLE = 2
local TOGGLE_ACHIEVEMENT = 3
local PathBgInfo = "Assets/Main/SeasonRes/S6/Textures/CampDestroy/mjc_S6_ZYDK_1_banner.png"
local PathBgBattle = "Assets/Main/SeasonRes/S6/Textures/CampDestroy/mjc_S6_ZYDK_2_banner.png"
local PathBgAchievement = "Assets/Main/SeasonRes/S6/Textures/CampDestroy/mjc_S6_ZYDK_3_banner.png"

function SeasonCampDestroyMain:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyMain:OnDestroy()
  self:DestroyDynamic()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnRules = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnRules:SetOnClick(function()
    self:OnBtnRulesClick()
  end)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnFriendInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnFriendInfo:SetOnClick(function()
    self:OnBtnFriendInfoClick()
  end)
  self.btnBattleHistory = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnBattleHistory:SetOnClick(function()
    self:OnBtnBattleHistoryClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnBattle = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnBattle:SetOnClick(function()
    self:OnBtnBattleClick()
  end)
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compMidRect = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnPRank = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnPRank:SetOnClick(function()
    self:OnBtnPRankClick()
  end)
  self.btnPCityList = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnPCityList:SetOnClick(function()
    self:OnBtnPCityListClick()
  end)
  self.compActInfo = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.textTmpActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnTips = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnTips:SetOnClick(function()
    self:OnBtnTipsClick()
  end)
  self.compTimeRect = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.textTmpCountdown = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textTmpActDescription = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 19)
  self.compImgBgBase2 = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.compImgBgBase = self.viewSkin:AddComponent(self, UIBaseComponent, 21)
  self.btnAchievement = self.viewSkin:AddComponent(self, UIButton, 22)
  self.btnAchievement:SetOnClick(function()
    self:OnBtnAchievementClick()
  end)
  self.compRedPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.btnBg = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.cbRefreshBgSize = Bind(self, self.RefreshBgSize)
  self.btnPRank:SetButtonNameLocal("season_s5_activity_1200059_desc07")
  self.btnPCityList:SetButtonNameLocal("390876")
  self.btnRules:SetButtonNameLocal("activity_hunter_info_tab3")
  self.btnRank:SetButtonNameLocal("activity_1200043_tips6")
  self.btnFriendInfo:SetButtonNameLocal("season_s6_activity_1200112_btn01")
  self.btnBattleHistory:SetButtonNameLocal("season_s6_activity_1200112_btn02")
  self.btnReward:SetButtonNameLocal("456066")
  self.textTmpTitle:SetLocalText(self:GetSeasonName())
  self.textTmpActName:SetLocalText("season_s6_activity_1200112_name")
  self.textTmpActDescription:SetLocalText("season_s6_activity_1200112_desc01")
  SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
  self.achievementTemp = self:GetAchievementTemp()
  self:InitToggles()
  self:InitDynamic()
  self:SetToggle(TOGGLE_INFO)
  self:RefreshBattleStage()
  self.mgr:MarkActivityOpened()
end

function SeasonCampDestroyMain:GetSeasonName()
  local config = DataCenter.SeasonDataManager:GetServerSeasonConfig()
  if config ~= nil and config.name then
    return config.name
  end
  return ""
end

function SeasonCampDestroyMain:InitToggles()
  self.toggles = {}
  self.toggles[TOGGLE_INFO] = {
    activeNode = self.btnInfo.transform:Find("ActiveNode").gameObject,
    inactiveNode = self.btnInfo.transform:Find("InActiveNode").gameObject
  }
  self.toggles[TOGGLE_BATTLE] = {
    activeNode = self.btnBattle.transform:Find("ActiveNode").gameObject,
    inactiveNode = self.btnBattle.transform:Find("InActiveNode").gameObject
  }
  UIUtil.SetTextLit(self.btnInfo.transform, "ActiveNode/LbName", "season_s6_activity_1200112_tab01")
  UIUtil.SetTextLit(self.btnInfo.transform, "InActiveNode/LbName", "season_s6_activity_1200112_tab01")
  UIUtil.SetTextLit(self.btnBattle.transform, "ActiveNode/LbName", "season_s6_activity_1200112_tab02")
  UIUtil.SetTextLit(self.btnBattle.transform, "InActiveNode/LbName", "season_s6_activity_1200112_tab02")
  if not self.achievementTemp then
    self.btnAchievement:SetActive(false)
  else
    self.btnAchievement:SetActive(true)
    self.toggles[TOGGLE_ACHIEVEMENT] = {
      activeNode = self.btnAchievement.transform:Find("ActiveNode").gameObject,
      inactiveNode = self.btnAchievement.transform:Find("InActiveNode").gameObject
    }
    UIUtil.SetTextLit(self.btnAchievement.transform, "ActiveNode/LbName", self.achievementTemp.tab_title)
    UIUtil.SetTextLit(self.btnAchievement.transform, "InActiveNode/LbName", self.achievementTemp.tab_title)
    local actId = self.mgr:GetActId()
    if actId then
      self:BindRedPointUI(self.compRedPoint, nil, {
        RedDef.Season,
        tostring(actId),
        RedDef.SeasonCampAchievementReward
      })
    end
  end
end

function SeasonCampDestroyMain:InitDynamic()
  self.dCompZoneMap = UIAsyncLoaderBridge.New(self, "dCompZoneMap", self.compMidRect.transform, UIAssets.UILWSeasonCampDestroyZoneMap, lua_SeasonCampDestroyZoneMap, false)
  self.dCompCampPreview = UIAsyncLoaderBridge.New(self, "dCompCampPreview", self.compMidRect.transform, UIAssets.UILWSeasonCampDestroyCampPreview, lua_SeasonCampDestroyCampPreview, false)
  self.dCompCampAchievement = UIAsyncLoaderBridge.New(self, "dCompCampAchievement", self.compMidRect.transform, UIAssets.UILWSeasonCampDestroyAchievement, lua_SeasonCampDestroyCampAchievement, false)
  self.dCompBattleIdle = UIAsyncLoaderBridge.New(self, "dCompBattleIdle", self.compMidRect.transform, UIAssets.UILWSeasonCampDestroyIdleDay, lua_SeasonCampDestroyIdleDay, false)
  self.dCompBattleWait = UIAsyncLoaderBridge.New(self, "dCompBattleWait", self.compMidRect.transform, UIAssets.UILWSeasonCampDestroyBattleWait, lua_SeasonCampDestroyBattleWait, false)
  self.dCompBattleDetail = UIAsyncLoaderBridge.New(self, "dCompBattleDetail", self.compMidRect.transform, UIAssets.UILWSeasonCampDestroyBattleDetail, lua_SeasonCampDestroyBattleDetail, false)
end

function SeasonCampDestroyMain:DestroyDynamic()
  self.dCompZoneMap:Delete()
  self.dCompZoneMap = nil
  self.dCompCampPreview:Delete()
  self.dCompCampPreview = nil
  self.dCompCampAchievement:Delete()
  self.dCompCampAchievement = nil
  self.dCompBattleIdle:Delete()
  self.dCompBattleIdle = nil
  self.dCompBattleWait:Delete()
  self.dCompBattleWait = nil
  self.dCompBattleDetail:Delete()
  self.dCompBattleDetail = nil
end

function SeasonCampDestroyMain:SetToggle(toggleId)
  for k, v in ipairs(self.toggles) do
    v.activeNode:SetActive(k == toggleId)
    v.inactiveNode:SetActive(k ~= toggleId)
  end
  self.currentToggle = toggleId
  self:RefreshMainView()
  self:RefreshBg()
  self:RefreshRightButtons()
  self:RefreshBottomButtons()
end

function SeasonCampDestroyMain:RefreshBottomButtons()
  if self.currentToggle == TOGGLE_BATTLE then
    self.btnPRank:SetActive(true)
    self.btnPCityList:SetActive(true)
  elseif self.currentToggle == TOGGLE_INFO then
    self.btnPRank:SetActive(false)
    self.btnPCityList:SetActive(false)
  else
    self.btnPRank:SetActive(false)
    self.btnPCityList:SetActive(false)
  end
end

function SeasonCampDestroyMain:RefreshRightButtons()
  self.btnRules:SetActive(false)
  if self.currentToggle == TOGGLE_INFO then
    self.btnRank:SetActive(true)
    self.btnReward:SetActive(true)
    self.btnFriendInfo:SetActive(false)
    self.btnBattleHistory:SetActive(false)
  elseif self.currentToggle == TOGGLE_BATTLE then
    self.btnRank:SetActive(false)
    self.btnReward:SetActive(false)
    self.btnFriendInfo:SetActive(true)
    self.btnBattleHistory:SetActive(true)
  else
    self.btnRank:SetActive(false)
    self.btnReward:SetActive(false)
    self.btnFriendInfo:SetActive(false)
    self.btnBattleHistory:SetActive(false)
  end
end

function SeasonCampDestroyMain:RefreshMainView()
  if self.currentToggle == TOGGLE_INFO then
    self.dCompZoneMap:SetActive(true)
    self.dCompCampPreview:SetActive(true)
    self.dCompZoneMap:Refresh()
    self.dCompCampPreview:Refresh()
    self.dCompBattleIdle:SetActive(false)
    self.dCompBattleWait:SetActive(false)
    self.dCompBattleDetail:SetActive(false)
    self.dCompCampAchievement:SetActive(false)
    self.compActInfo:SetActive(true)
  elseif self.currentToggle == TOGGLE_BATTLE then
    self.dCompZoneMap:SetActive(false)
    self.dCompCampPreview:SetActive(false)
    self.dCompCampAchievement:SetActive(false)
    self.compActInfo:SetActive(true)
    if self.currentBattleStage == SeasonCampDestroyStage.Idle then
      self.dCompBattleIdle:SetActive(true)
      self.dCompBattleWait:SetActive(false)
      self.dCompBattleDetail:SetActive(false)
      self.dCompBattleIdle:Refresh()
    elseif self.currentBattleStage == SeasonCampDestroyStage.Wait then
      self.dCompBattleIdle:SetActive(false)
      self.dCompBattleWait:SetActive(true)
      self.dCompBattleDetail:SetActive(false)
      self.dCompBattleWait:Refresh()
    elseif self.currentBattleStage == SeasonCampDestroyStage.Fight then
      local declareCount, beDeclareCount = self:GetDeclareCount()
      local hasBattleInfo = 0 < declareCount or 0 < beDeclareCount
      if hasBattleInfo then
        self.dCompBattleIdle:SetActive(false)
        self.dCompBattleWait:SetActive(false)
        self.dCompBattleDetail:SetActive(true)
        self.dCompBattleDetail:Refresh()
      else
        self.dCompBattleIdle:SetActive(false)
        self.dCompBattleWait:SetActive(true)
        self.dCompBattleDetail:SetActive(false)
        self.dCompBattleWait:Refresh()
      end
    else
      self.dCompBattleIdle:SetActive(false)
      self.dCompBattleWait:SetActive(false)
      self.dCompBattleDetail:SetActive(false)
    end
  else
    self.compActInfo:SetActive(false)
    self.dCompZoneMap:SetActive(false)
    self.dCompCampPreview:SetActive(false)
    self.dCompBattleIdle:SetActive(false)
    self.dCompBattleWait:SetActive(false)
    self.dCompBattleDetail:SetActive(false)
    self.dCompCampAchievement:SetActive(true)
    self.dCompCampAchievement:Refresh(self.achievementTemp)
  end
end

function SeasonCampDestroyMain:GetDeclareCount()
  if not self.mgr then
    return 0, 0
  end
  local declare = 0
  local beDeclare = 0
  local declareList = self.mgr:GetDeclareList()
  local beDeclareList = self.mgr:GetBeDeclareList()
  declare = #declareList
  beDeclare = #beDeclareList
  return declare, beDeclare
end

function SeasonCampDestroyMain:RefreshBgSize()
  if IsNotNull(self.rawImgBg) then
    self.rawImgBg:SetNativeSize()
  end
end

function SeasonCampDestroyMain:RefreshBg()
  if self.currentToggle == TOGGLE_BATTLE then
    self.rawImgBg:LoadSpriteAuto(PathBgBattle, self.cbRefreshBgSize)
    self.compImgBgBase:SetActive(false)
    self.compImgBgBase2:SetActive(true)
  elseif self.currentToggle == TOGGLE_INFO then
    self.rawImgBg:LoadSpriteAuto(PathBgInfo, self.cbRefreshBgSize)
    self.compImgBgBase:SetActive(true)
    self.compImgBgBase2:SetActive(false)
  else
    self.rawImgBg:LoadSpriteAuto(PathBgAchievement, self.cbRefreshBgSize)
    self.compImgBgBase:SetActive(false)
    self.compImgBgBase2:SetActive(false)
  end
end

function SeasonCampDestroyMain:ComponentDestroy()
  self.viewSkin = nil
  self.btnRules = nil
  self.btnRank = nil
  self.btnFriendInfo = nil
  self.btnBattleHistory = nil
  self.btnReward = nil
  self.btnInfo = nil
  self.btnBattle = nil
  self.textTmpTitle = nil
  self.compMidRect = nil
  self.btnBack = nil
  self.btnPRank = nil
  self.btnPCityList = nil
  self.compActInfo = nil
  self.textTmpActName = nil
  self.btnTips = nil
  self.compTimeRect = nil
  self.textTmpCountdown = nil
  self.textTmpActDescription = nil
  self.rawImgBg = nil
  self.compImgBgBase2 = nil
  self.compImgBgBase = nil
  self.btnAchievement = nil
  self.compRedPoint = nil
  self.btnBg = nil
  self.toggles = nil
  self.cbRefreshBgSize = nil
end

function SeasonCampDestroyMain:DataDefine()
  self.mgr = DataCenter.SeasonCampDestroyManager
  self.currentToggle = nil
  self.serverMode = true
  self.selectedZoneIndex = 0
  self:InitDeclareWarInfo()
end

function SeasonCampDestroyMain:InitDeclareWarInfo()
  local actId = self.mgr.actId
  if not actId then
    return
  end
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if not activityData then
    return
  end
  local para4 = activityData.para4
  local startTime = activityData.startTime
  local fightStartTime = startTime + toInt(para4) * OneHourTime * 1000
  DataCenter.SeasonDataManager.CrossDeclareWarStartTime = fightStartTime
  if not DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData() then
    DataCenter.UILWSeasonAllianceWarTimeManager:SendGetInfo()
  end
end

function SeasonCampDestroyMain:OnZoneClick(index)
  self.selectedZoneIndex = index
end

function SeasonCampDestroyMain:DataDestroy()
  self.mgr = nil
  self.currentToggle = nil
  self.currentBattleStage = nil
  self.currentTimeIndex = nil
  self.achievementTemp = nil
end

function SeasonCampDestroyMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
end

function SeasonCampDestroyMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyMain:OnBtnRulesClick()
  UIUtil.ShowTips("OnBtnRulesClick")
end

function SeasonCampDestroyMain:OnBtnRankClick()
  local actId = self.mgr.actId
  if not actId then
    UIUtil.ShowTipsId(120018)
    return
  end
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if not activityData or not activityData.rankRewardParam then
    UIUtil.ShowTipsId(120018)
    return
  end
  local rankIdList = {}
  for _, v in ipairs(activityData.rankRewardParam) do
    local rankId = toInt(v)
    if rankId and 0 < rankId then
      table.insert(rankIdList, rankId)
    end
  end
  if #rankIdList == 0 then
    UIUtil.ShowTipsId(120018)
    return
  end
  local rankConfigs = {}
  local toggleTextList = {}
  local rankTitleList = {}
  local powerTips = {}
  for i, rankId in ipairs(rankIdList) do
    local config = LocalController:instance():getLine(TableName.LW_Season_rank, rankId)
    if config then
      rankConfigs[i] = config
      table.insert(toggleTextList, config.name)
      table.insert(rankTitleList, {
        "302129",
        config.score_name or "456533"
      })
      table.insert(powerTips, Localization:GetString(config.desc))
    end
  end
  for _, rankId in ipairs(rankIdList) do
    self.mgr:SendGetRank(rankId)
  end
  
  local function getRankDataFunc(toggleIndex)
    local config = rankConfigs[toggleIndex]
    if not config then
      return {
        rankList = {},
        myRank = {}
      }
    end
    local rankId = toInt(config.id)
    local cacheData = self.mgr:GetRankCacheData(rankId)
    if not cacheData then
      return {
        rankList = {},
        myRank = {}
      }
    end
    local rankList = {}
    local rawList = cacheData.rank or {}
    for _, item in ipairs(rawList) do
      local user = item.user or {}
      local rankItem = {
        rank = item.rank,
        score = tonumber(item.score) or 0,
        uid = item.uid or user.uid,
        name = user.name,
        abbr = user.abbr,
        pic = user.pic,
        picVer = user.picVer,
        serverId = user.serverId or user.srcServer,
        isAlliance = false
      }
      table.insert(rankList, rankItem)
    end
    local myRank = {
      rank = cacheData.selfRank or 0,
      score = cacheData.selfScore or 0,
      uid = LuaEntry.Player.uid,
      name = LuaEntry.Player.name,
      serverId = LuaEntry.Player:GetSourceServerId(),
      isAlliance = false
    }
    return {rankList = rankList, myRank = myRank}
  end
  
  local param = {
    titleText = "302043",
    toggleTextList = toggleTextList,
    rankTitleList = rankTitleList,
    powerTipsList = powerTips,
    getRankDataFunc = getRankDataFunc,
    refreshEventId = EventId.SeasonCampDestroyRankRefresh,
    bottomDesc = "season_s6_activity_1200112_desc21"
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonRank, {anim = true}, param)
end

function SeasonCampDestroyMain:OnBtnFriendInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonCampDestroyWarTimeView)
end

function SeasonCampDestroyMain:OnBtnBattleHistoryClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonCampDestroyWarHistory)
end

function SeasonCampDestroyMain:OnBtnRewardClick()
  local actId = self.mgr.actId
  if not actId then
    UIUtil.ShowTipsId(120018)
    return
  end
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if not activityData or not activityData.rankRewardParam then
    UIUtil.ShowTipsId(120018)
    return
  end
  local rankIdList = {}
  for _, v in ipairs(activityData.rankRewardParam) do
    local rankId = toInt(v)
    if rankId and 0 < rankId then
      table.insert(rankIdList, rankId)
    end
  end
  if 0 < table.count(rankIdList) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankMultipleReward, {anim = true}, rankIdList)
  else
    UIUtil.ShowTipsId(120018)
  end
end

function SeasonCampDestroyMain:OnBtnInfoClick()
  self:SetToggle(TOGGLE_INFO)
end

function SeasonCampDestroyMain:OnBtnBattleClick()
  self:SetToggle(TOGGLE_BATTLE)
end

function SeasonCampDestroyMain:OnBtnAchievementClick()
  self:SetToggle(TOGGLE_ACHIEVEMENT)
end

function SeasonCampDestroyMain:OnBtnPCityListClick()
  if not self.mgr then
    return
  end
  local cityOpenLevel = self.mgr:GetCityOpenLevel()
  if cityOpenLevel == 1 then
    UIUtil.ShowTipsId("456522")
    return
  end
  if LuaEntry.Player:IsInAlliance() then
    DataCenter.WorldAllianceCityDataManager:FetchBitMapCityWarInfo()
    SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityDetail)
  else
    UIUtil.ShowTipsId(2010218)
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
  end
end

function SeasonCampDestroyMain:OnBtnPRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank)
end

function SeasonCampDestroyMain:OnBattleStageChanged(newStage, timeIndex)
  if not self.mgr then
    return
  end
  self.currentBattleStage = newStage
  self.currentTimeIndex = timeIndex and timeIndex - 1
  if self.currentToggle == TOGGLE_BATTLE then
    self:RefreshMainView()
  end
end

function SeasonCampDestroyMain:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function SeasonCampDestroyMain:Update1000MS()
  self:RefreshBattleStage()
  self:RefreshCountdown()
end

function SeasonCampDestroyMain:RefreshCountdown()
  if not self.mgr then
    return
  end
  local actInfo = self.mgr:GetActInfo()
  if not actInfo or actInfo.actEndTime <= 0 then
    self.compTimeRect:SetActive(false)
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local remain = actInfo.actEndTime - now
  if 0 < remain then
    self.compTimeRect:SetActive(true)
    local timeStr = UITimeManager:GetInstance():SecondToFmtString(math.floor(remain / 1000))
    self.textTmpCountdown:SetText(timeStr)
  else
    self.compTimeRect:SetActive(false)
  end
end

function SeasonCampDestroyMain:RefreshBattleStage()
  local curStage = self.currentBattleStage
  local newStage, timeIndex = self.mgr:GetCurrentBattleStage()
  if curStage ~= newStage then
    self:OnBattleStageChanged(newStage, timeIndex)
  end
end

function SeasonCampDestroyMain:OnSeasonCampDestroyActRefresh()
  self:RefreshBattleStage()
  self:RefreshMainView()
end

function SeasonCampDestroyMain:IsServerMode()
  return self.serverMode
end

function SeasonCampDestroyMain:SetServerMode(serverMode)
  self.serverMode = serverMode
  self.dCompCampPreview:RefreshServerMode()
  self.dCompZoneMap:RefreshServerMode()
end

function SeasonCampDestroyMain:OnBtnTipsClick()
  local actId = self.mgr.actId
  local actConfig = self.mgr.actConfig
  if actId and actConfig and actConfig.desc then
    local param = {}
    param.activityId = actId
    param.activityRulesStr = Localization:GetString(actConfig.desc)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SeasonCampDestroyMain:GetAchievementTemp()
  local list = DataCenter.SeasonRewardDataManager:GetAchievementsGroups(SeasonAchivementFlagFilter.Camp)
  return list and list[1]
end

function SeasonCampDestroyMain:OnBtnBgClick()
end

function SeasonCampDestroyMain:GetSageTimeIndex()
  local time = DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
  if not time then
    return -9527
  end
  return time.TimeIndex or -9527
end

return SeasonCampDestroyMain
