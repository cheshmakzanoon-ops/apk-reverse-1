local UIParkourBattleWinView = BaseClass("UIParkourBattleWinView", UIBaseView)
local base = UIBaseView
local Time = _ENV.Time
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local LayoutLayer = "Layout/"
local get_coin_path = "Layout/GetCoin"
local get_txt_path = "Layout/GetCoin/GetTxt"
local coin_count_path = "Layout/GetCoin/CoinCount"
local alli_share_btn_path = "Layout/BtnGroup/AlliShareBtn"
local alli_share_btn_text_path = "Layout/BtnGroup/AlliShareBtn/AlliShareBtnText"
local UIStatisticList = require("UI.UIParkour.WinUI.Component.UIParkourBattleStatisticHeroList")
local SoundDelayTime = 1

function UIParkourBattleWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIParkourBattleWinView:OnDestroy()
  if self.scoreTween then
    self.scoreTween:Kill()
  end
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  if self.showRewardAnimCo then
    self.showRewardAnimCo = nil
  end
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
  if self.delayCheck then
    self.delayCheck:Stop()
    self.delayCheck = nil
  end
  if self.delaySound then
    self.delaySound:Stop()
    self.delaySound = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIParkourBattleWinView:ComponentDefine()
  local param = self:GetUserData()
  self.bg = self:AddComponent(UIImage, "Image")
  self.bg:SetAlpha(0)
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.layout:SetActive(false)
  self.backBtn = self:AddComponent(UIButton, "Layout/BtnGroup/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.nextBtn = self:AddComponent(UIButton, "Layout/BtnGroup/NextBtn")
  self.nextBtn:SetOnClick(function()
    self:OnNextBtnClick()
  end)
  self.shareBtn = self:AddComponent(UIButton, "ShareBtn")
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.get_coin = self:AddComponent(UIImage, get_coin_path)
  self.get_coin:SetActive(false)
  self.get_txt = self:AddComponent(UITextMeshProUGUIEx, get_txt_path)
  self.get_txt:SetLocalText(130067)
  self.coin_count = self:AddComponent(UITextMeshProUGUIEx, coin_count_path)
  self.alli_share_btn = self:AddComponent(UIButton, alli_share_btn_path)
  self.alli_share_btn:SetSafeClickMode(true)
  self.alli_share_btn:SetOnClick(function()
    self:OnAllianceShareBtnClick()
  end)
  self.alli_share_btn:SetActive(false)
  self.alli_share_btn_text = self:AddComponent(UITextMeshProUGUIEx, alli_share_btn_text_path)
  self.alli_share_btn_text:SetLocalText("season_s3_coinlevel_share_text_2")
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.levelText = self:AddComponent(UIText, LayoutLayer .. "LevelText")
  self.timeText = self:AddComponent(UIText, LayoutLayer .. "TimeText")
  self.timeText:SetActive(false)
  self.killNumText = self:AddComponent(UIText, LayoutLayer .. "KillNumText")
  self.killNumText:SetActive(false)
  self.rewardContent = self.transform:Find(LayoutLayer .. "RewardBg").gameObject
  self.rewardTitle1 = self:AddComponent(UIText, LayoutLayer .. "RewardBg/RewardTitle1")
  self.rewardGrid1 = self:AddComponent(UIBaseContainer, LayoutLayer .. "RewardBg/RewardGrid1")
  self.HeroRewardContent = self.transform:Find(LayoutLayer .. "HeroRewardBg").gameObject
  self.HeroRewardTitle1 = self:AddComponent(UIText, LayoutLayer .. "HeroRewardBg/RewardTitle2")
  self.HeroRewardGrid1 = self:AddComponent(UIBaseContainer, LayoutLayer .. "HeroRewardBg/RewardGrid2")
  self.WorkerRewardContent = self.transform:Find(LayoutLayer .. "WorkerRewardBg").gameObject
  self.WorkerRewardTitle1 = self:AddComponent(UIText, LayoutLayer .. "WorkerRewardBg/RewardTitle3")
  self.WorkerRewardGrid1 = self:AddComponent(UIBaseContainer, LayoutLayer .. "WorkerRewardBg/RewardGrid3")
  self.backBtnText = self:AddComponent(UIText, "Layout/BtnGroup/BackBtn/BackBtnText")
  self.nextBtnText = self:AddComponent(UIText, "Layout/BtnGroup/NextBtn/NextBtnText")
  self.nextBtnText:SetLocalText("activity_breakthrough_tips_27")
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.scoreEntry = self:AddComponent(UIBaseContainer, LayoutLayer .. "ScoreEntry")
  self.scoreText = self:AddComponent(UIText, LayoutLayer .. "ScoreEntry/txt_score")
  self.scoreEntry:SetActive(false)
  self.rankEntry = self:AddComponent(UIBaseContainer, LayoutLayer .. "RankEntry")
  self.rankText1 = self:AddComponent(UIText, LayoutLayer .. "RankEntry/txt_rank1")
  self.rankText2 = self:AddComponent(UIText, LayoutLayer .. "RankEntry/txt_rank2")
  self.rankText3 = self:AddComponent(UIText, LayoutLayer .. "RankEntry/txt_rank3")
  self.rankEntry:SetActive(false)
  self.block = self:AddComponent(UIBaseContainer, LayoutLayer .. "Block")
  if not CommonUtil.IsArabic() then
    self.rankText1:SetText(Localization:GetString("800827"))
    self.rankText3:SetText(Localization:GetString("800828"))
  else
    self.rankText1:SetText(Localization:GetString("800828"))
    self.rankText3:SetText(Localization:GetString("800827"))
  end
  local stageId = param.stageId
  local showStatistic = param.showStatistic
  local stageOrder = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
  self.levelText:SetText(Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name"), stageOrder))
  local backBtnName = 800306
  self.backBtnText:SetText(Localization:GetString(backBtnName))
  self.victoryText:SetText(Localization:GetString("311105"))
  self.rewardTitle1:SetText(Localization:GetString("800305"))
  self.HeroRewardTitle1:SetLocalText(800324)
  self.WorkerRewardTitle1:SetLocalText(800325)
  self.tabRoot = self:AddComponent(UIBaseContainer, "Layout/Tabs")
  self.tabBtns = {
    self:AddComponent(UIButton, "Layout/Tabs/MakeBtn"),
    self:AddComponent(UIButton, "Layout/Tabs/TakeBtn")
  }
  for i, tabBtn in ipairs(self.tabBtns) do
    local idx = i
    tabBtn:SetOnClick(function()
      self:OnTabBtnClick(idx)
    end)
  end
  self.makeDmgScrollObj = self.transform:Find("Layout/MakeDmgScroll").gameObject
  self.takeDmgScrollObj = self.transform:Find("Layout/TakeDmgScroll").gameObject
  self.tabIdx = 1
  self.highlightMask = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask")
  self.highlightInner = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask/Inner")
  self.highlightMask:SetAnchoredPositionXY(0, -1)
  self.highlightInner:SetAnchoredPositionXY(0, 0)
  self.transform:Find("Layout/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.ActFrontBreakSpace = self:AddComponent(UIBaseContainer, "Layout/ActFrontBreakSpace")
  self.ActFrontBreakTopRank = self:AddComponent(UIBaseContainer, "Layout/TopRank")
  self.ActFrontBreakTopRTitile = self:AddComponent(UIText, "Layout/TopRank/TopRTitle")
  self.ActFrontBreakTopRTitile:SetText(Localization:GetString("activity_breakthrough_tips_37"))
  self.ActFrontBreakTopRSrcNum = self:AddComponent(UIText, "Layout/TopRank/TopRSrcNum")
  self.ActFrontBreakTopRTargetNum = self:AddComponent(UIText, "Layout/TopRank/TopRTargetNum")
  self.ActFrontBreakALRank = self:AddComponent(UIBaseContainer, "Layout/ALRank")
  self.ActFrontBreakALRTitile = self:AddComponent(UIText, "Layout/ALRank/ALRTitle")
  self.ActFrontBreakALRTitile:SetText(Localization:GetString("activity_breakthrough_tips_13"))
  self.ActFrontBreakALRSrcNum = self:AddComponent(UIText, "Layout/ALRank/ALRSrcNum")
  self.ActFrontBreakALRTargetNum = self:AddComponent(UIText, "Layout/ALRank/ALRTargetNum")
  self.ActFrontBreakServerRank = self:AddComponent(UIBaseContainer, "Layout/ServerRank")
  self.ActFrontBreakServerRTitile = self:AddComponent(UIText, "Layout/ServerRank/SRTitle")
  self.ActFrontBreakServerRTitile:SetText(Localization:GetString("activity_breakthrough_tips_14"))
  self.ActFrontBreakServerRSrcNum = self:AddComponent(UIText, "Layout/ServerRank/SRSrcNum")
  self.ActFrontBreakServerRTargetNum = self:AddComponent(UIText, "Layout/ServerRank/SRTargetNum")
  self.ActFrontBreakLevelRemainSolider = self:AddComponent(UIBaseContainer, "Layout/LevelRemainSolider")
  self.ActFrontBreakLevelRemainSoliderTitle = self:AddComponent(UIText, "Layout/LevelRemainSolider/LevelRemainTitle")
  self.ActFrontBreakLevelRemainSoliderTitle:SetText(Localization:GetString("activity_breakthrough_tips_24"))
  self.ActFrontBreakLevelRemainSoliderCount = self:AddComponent(UIText, "Layout/LevelRemainSolider/LevelRemainCount")
  self.ActFrontBreakTotalRemainSolider = self:AddComponent(UIBaseContainer, "Layout/TotalRemainSolider")
  self.ActFrontBreakTotalRemainSoliderTitle = self:AddComponent(UIText, "Layout/TotalRemainSolider/TotalRemainTitle")
  self.ActFrontBreakTotalRemainSoliderTitle:SetText(Localization:GetString("activity_breakthrough_tips_25"))
  self.ActFrontBreakTotalRemainSoliderCount = self:AddComponent(UIText, "Layout/TotalRemainSolider/TotalRemainCount")
  self.ActFrontBreakTotalRemainSoliderNewRecord = self:AddComponent(UIBaseContainer, "Layout/TotalRemainSolider/TotalRemainCount/NewRecord")
  self.ActFrontBreakTotalRemainSoliderNewRecordTitle = self:AddComponent(UIText, "Layout/TotalRemainSolider/TotalRemainCount/NewRecord/RecordTitle")
  self.ActFrontBreakTotalRemainSoliderNewRecordTitle:SetLocalText("activity_breakthrough_tips_30")
  self.FrontBreakSundayRankTip = self:AddComponent(UIBaseContainer, "Layout/FrontBreakSundayRankTips")
  self.FrontBreakSundayRankCriteriaLabel = self:AddComponent(UIText, "Layout/FrontBreakSundayRankTips/RankCriteriaLabel")
  self.FrontBreakSundayRankCriteriaLabel:SetLocalText("activity_breakthrough_tips_38")
  self.FrontBreakSundayRankCriteriaStageLabel = self:AddComponent(UIText, "Layout/FrontBreakSundayRankTips/CriteriaStageLabel")
  self.FrontBreakSundayRankCriteriaRemainSoliderLabel = self:AddComponent(UIText, "Layout/FrontBreakSundayRankTips/CriteriaRemainSolider")
  self.ActFrontBreakSpace:SetActive(false)
  self.ActFrontBreakTopRank:SetActive(false)
  self.ActFrontBreakALRank:SetActive(false)
  self.ActFrontBreakServerRank:SetActive(false)
  self.ActFrontBreakTotalRemainSolider:SetActive(false)
  self.ActFrontBreakLevelRemainSolider:SetActive(false)
  self.FrontBreakSundayRankTip:SetActive(false)
  self.emptyGroupContainer = self:AddComponent(UIBaseContainer, "Layout/EmptyGroup")
  self.btnGroupContainer = self:AddComponent(UIBaseContainer, "Layout/BtnGroup")
  self.btnGroupLayoutElement = self:AddComponent(UILayoutElement, "Layout/BtnGroup")
  self.emptyGroupContainer:SetActive(false)
  self.btnGroupLayoutElement:SetIgnoreLayout(false)
  if param.fromChapter then
    self.bg:SetAlpha(0.9568627450980393)
    self.layout:SetActive(true)
    self.canvasGroup.alpha = 1
    self.tabRoot:SetActive(false)
    self.makeDmgScrollObj:SetActive(false)
    self.takeDmgScrollObj:SetActive(false)
    self.backBtn:SetActive(true)
    self.backBtn.transform:Set_localScale(1, 1, 1)
    self.levelText:SetActive(true)
    self.levelText.transform:Set_localScale(1, 1, 1)
    self.scoreEntry:SetActive(true)
    self.rankEntry:SetActive(true)
    self.nextBtn:SetActive(false)
    self.shareBtn:SetActive(true)
    self.block:SetActive(true)
    if param.fromHelpResult then
      self.backBtnText:SetLocalText("100178")
    end
    if self.scoreTween then
      self.scoreTween:Kill()
    end
    self.tempScore = 0
    self.scoreText:SetText("X 0")
    self.scoreTween = CS.DG.Tweening.DOTween.To(function()
      return self.tempScore
    end, function(value)
      self.tempScore = value
      self.scoreText:SetText("X " .. math.floor(value))
    end, param.score, 1):SetEase(CS.DG.Tweening.Ease.OutQuad):SetDelay(0.5):OnComplete(function()
      self.scoreText:SetText("X " .. param.score)
    end)
    self.rankText2:SetText(string.format("%s", param.rank))
    return
  elseif param.fromActFrontBreakSunday then
    self.bg:SetAlpha(0.9568627450980393)
    self.layout:SetActive(true)
    self.canvasGroup.alpha = 1
    self.tabRoot:SetActive(false)
    self.makeDmgScrollObj:SetActive(false)
    self.takeDmgScrollObj:SetActive(false)
    self.backBtn:SetActive(true)
    self.backBtn.transform:Set_localScale(1, 1, 1)
    self.shareBtn:SetActive(true)
    self.levelText:SetActive(true)
    self.levelText.transform:Set_localScale(1, 1, 1)
    local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId)
    local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
    local levelTitle = Localization:GetString("activity_breakthrough_tips_19", stageIdIndex, stagesCount)
    self.levelText:SetText(levelTitle)
    self.ActFrontBreakTotalRemainSoliderCount:SetText(string.format("x%d", param.totalLeft or 0))
    self.ActFrontBreakLevelRemainSoliderCount:SetText(string.format("x%d", param.curLeft or 0))
    self.ActFrontBreakSpace:SetActive(true)
    self.ActFrontBreakTotalRemainSolider:SetActive(true)
    self.ActFrontBreakLevelRemainSolider:SetActive(true)
    self.block:SetActive(false)
    if stageIdIndex == stagesCount then
      local isInAlliance = LuaEntry.Player:IsInAlliance()
      local topRankOld = param.topRankOld or 0
      local topRankNew = param.topRankNew or 0
      self.ActFrontBreakTopRank:SetActive(0 < topRankNew and (topRankOld == 0 or topRankOld > topRankNew))
      self.ActFrontBreakTopRSrcNum:SetText(topRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or topRankOld)
      self.ActFrontBreakTopRTargetNum:SetText(topRankNew)
      local alRankOld = param.alRankOld or 0
      local alRankNew = param.alRankNew or 0
      self.ActFrontBreakALRank:SetActive(isInAlliance and 0 < alRankNew and (alRankOld == 0 or alRankOld > alRankNew))
      self.ActFrontBreakALRSrcNum:SetText(alRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or alRankOld)
      self.ActFrontBreakALRTargetNum:SetText(alRankNew)
      local serRankOld = param.serRankOld or 0
      local serRankNew = param.serRankNew or 0
      self.ActFrontBreakServerRank:SetActive(0 < serRankNew and (serRankOld == 0 or serRankOld > serRankNew))
      self.ActFrontBreakServerRSrcNum:SetText(serRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or serRankOld)
      self.ActFrontBreakServerRTargetNum:SetText(serRankNew)
      local newRecord = param.newRecord and true or false
      self.ActFrontBreakTotalRemainSoliderNewRecord:SetActive(newRecord)
      self.FrontBreakSundayRankTip:SetActive(true)
      local criteriaStage = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaStage(param.frontBreakSundayActId)
      self.FrontBreakSundayRankCriteriaStageLabel:SetLocalText("activity_breakthrough_tips_15", criteriaStage)
      local criteriaRemainSolider = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaRemainSolider(param.frontBreakSundayActId)
      self.FrontBreakSundayRankCriteriaRemainSoliderLabel:SetText(string.format("x%d", criteriaRemainSolider))
      self.shareBtn:SetActive(true)
      self.nextBtn:SetActive(false)
    else
      self.ActFrontBreakTopRank:SetActive(false)
      self.ActFrontBreakALRank:SetActive(false)
      self.ActFrontBreakServerRank:SetActive(false)
      self.shareBtn:SetActive(false)
      self.nextBtn:SetActive(true)
      self.ActFrontBreakTotalRemainSoliderNewRecord:SetActive(false)
    end
    self.levelText:SetActive(true)
    self.killNumText:SetActive(false)
    self.timeText:SetActive(false)
    self.scoreEntry:SetActive(false)
    self.rankEntry:SetActive(false)
    self.ActFrontBreakSpace:SetActive(true)
    if self.scoreTween then
      self.scoreTween:Kill()
    end
  elseif param.enterType == PVEEnterType.DetectCaveExploreEnter then
    self.nextBtn:SetActive(false)
    self.backBtnText:SetText(Localization:GetString(backBtnName))
  elseif param.enterType == PVEEnterType.DetectZombieBusTrain then
    self.block:SetActive(true)
    self.shareBtn:SetActive(false)
    local showNextBtn = false
    if param.zombieBusTrainData then
      local isInWorldEnter = param.zombieBusTrainData.isInWorld
      local curBusIndex = param.zombieBusTrainData.busIndex
      local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
      showNextBtn = isInWorldEnter and nextBusData ~= nil
    end
    self.levelText:SetText("")
    self.nextBtn:SetActive(showNextBtn)
  else
    self.block:SetActive(true)
    self.nextBtn:SetActive(false)
    self.shareBtn:SetActive(false)
  end
  if showStatistic then
    self.bg:SetAlpha(0.9568627450980393)
    self.layout:SetActive(true)
    self.killNumText:SetActive(false)
    self.timeText:SetActive(false)
    self.backBtn:SetActive(true)
    self.backBtn.transform:Set_localScale(1, 1, 1)
    self.levelText:SetActive(true)
    self.levelText.transform:Set_localScale(1, 1, 1)
    self.rewardContent:SetActive(false)
    self.HeroRewardContent:SetActive(false)
    self.WorkerRewardContent:SetActive(false)
    self.tabRoot:SetActive(true)
    self.makeDmgScrollObj:SetActive(self.tabIdx == 1)
    self.takeDmgScrollObj:SetActive(self.tabIdx == 2)
  else
    self.canvasGroup.alpha = 1
    self.tabRoot:SetActive(false)
    self.makeDmgScrollObj:SetActive(false)
    self.takeDmgScrollObj:SetActive(false)
    if not param.fromActFrontBreakSunday then
      self.alli_share_btn:SetActive(false)
      self.level_type = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.stageId, "level_type")
      self.isGoldLevel = self.level_type and tonumber(self.level_type) == 1
      if self.isGoldLevel then
        self.showSeq = {
          self.levelText,
          self.get_coin,
          self.rewardContent,
          self.HeroRewardContent,
          self.WorkerRewardContent,
          self.backBtn
        }
      else
        self.showSeq = {
          self.levelText,
          self.killNumText,
          self.timeText,
          self.rewardContent,
          self.HeroRewardContent,
          self.WorkerRewardContent,
          self.backBtn
        }
      end
      for _, c in ipairs(self.showSeq) do
        c:SetActive(false)
        c.transform:Set_localScale(0, 0, 0)
      end
      if DataCenter.ParkourManager.reward and DataCenter.ParkourManager.rewardStageId == stageId then
        self:OnGetReward(DataCenter.ParkourManager.reward)
      end
      if param.enterType == PVEEnterType.DetectZombieBusTrain then
        local reward = DataCenter.RadarCenterDataManager:GetRecentZombieBusReward()
        if reward then
          self:OnGetReward(reward)
        end
      end
      self:ShowRewardAnim()
    end
  end
end

function UIParkourBattleWinView:DataDefine()
  self.flyRewardList = {}
  self.heroId = nil
end

function UIParkourBattleWinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ParkourBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIParkourBattleWinView:OnRemoveListener()
  self:RemoveUIListener(EventId.ParkourBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIParkourBattleWinView:ComponentDestroy()
  self.back_btn = nil
  self.get_coin = nil
  self.get_txt = nil
  self.coin_count = nil
  self.alli_share_btn = nil
  self.alli_share_btn_text = nil
end

function UIParkourBattleWinView:RefreshView()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  local param = self:GetUserData()
  local showStatistic = param.showStatistic
  if showStatistic then
    TimerManager:GetInstance():DelayInvoke(function()
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIParkourBattleWin) then
        self.canvasGroup:DOFade(1, 0.2)
        self:ShowStatisticalData()
      end
    end, 1.5)
  else
    local time = param.time
    local kill = param.kill
    if kill then
      self.killNumText:SetText(Localization:GetString("800303") .. " " .. kill)
    end
    if time then
      self.timeText:SetText(Localization:GetString("800304") .. " " .. UITimeManager:GetInstance():SecondToFmtStringWithoutHour(time))
    end
    local goldCount = self:GetGoldCount()
    if goldCount then
      self.coin_count:SetText("\195\151" .. string.GetFormattedSeparatorNum(goldCount))
    end
  end
  self.delayCheck = TimerManager:GetInstance():DelayInvoke(function()
    self:CheckShowFirstPay()
  end, 2)
end

function UIParkourBattleWinView:GetGoldCount()
  local logic = DataCenter.LWBattleManager.logic
  if logic and logic.GetGoods then
    local goods = logic:GetGoods()
    if goods and goods[2] then
      return goods[2]
    end
  end
end

function UIParkourBattleWinView:ShowStatisticalData()
  if self.tabComps == nil then
    self.tabComps = {
      self:AddComponent(UIStatisticList, "Layout/MakeDmgScroll", "makeDmg"),
      self:AddComponent(UIStatisticList, "Layout/TakeDmgScroll", "takeDmg")
    }
  end
  for i, tabComp in ipairs(self.tabComps) do
    if i == self.tabIdx then
      tabComp:SetActive(true)
      tabComp:RefreshView()
      tabComp:FadeIn()
    else
      tabComp:SetActive(false)
    end
  end
end

function UIParkourBattleWinView:OnTabBtnClick(idx)
  if self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  self:ShowStatisticalData()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.highlightMask:GetAnchoredPositionX()
  end, function(value)
    self.highlightMask:SetAnchoredPositionXY(value, -1)
    self.highlightInner:SetAnchoredPositionXY(-value, 0)
  end, (self.tabIdx - 1) * 334, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function UIParkourBattleWinView:OnNextBtnClick()
  self.ctrl:CloseSelf()
  local userdata = self:GetUserData()
  if userdata.fromActFrontBreakSunday then
    DataCenter.LWBattleManager:Destroy()
    local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(userdata.frontBreakSundayActId):GetStageIndex(userdata.stageId)
    local stages = DataCenter.ActFrontBreakSundayDataManager:GetActData(userdata.frontBreakSundayActId).stageIds
    local nextStageId = stages[math.min(stageIdIndex + 1, #stages)]
    DataCenter.ActFrontBreakSundayDataManager:RequestToEnterStage(nextStageId)
  elseif userdata.zombieBusTrainData then
    local isInWorldEnter = userdata.zombieBusTrainData.isInWorld
    local curBusIndex = userdata.zombieBusTrainData.busIndex
    local curEventId = userdata.zombieBusTrainData.eventUuid
    local nextBusData, nextBusIndex = DataCenter.RadarCenterDataManager:GetNextOneCanAttackZombieBusData(curBusIndex)
    if isInWorldEnter and nextBusData then
      DataCenter.LWBattleManager:Destroy()
      local lastPosition, lastEuler = DataCenter.RadarCenterDataManager:GetLastZombieBusBattleEnterPosAndEuler()
      DataCenter.RadarCenterDataManager:ClickAttackWorldZombieBus(nextBusData, nextBusIndex, curEventId, lastPosition, lastEuler)
    else
      self:OnBackBtnClick()
    end
  else
    local curId = userdata.stageId
    local cfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), curId)
    local nextLevel = 0
    LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), function(id, lineData)
      if lineData.order == cfg.order + 1 then
        nextLevel = lineData.id
        return true
      end
    end)
    if 0 < nextLevel then
      local param = {}
      param.type = PVEType.Parkour
      param.levelId = nextLevel
      DataCenter.LWBattleManager:Destroy()
      DataCenter.LWBattleManager:Enter(param)
    else
      self:OnBackBtnClick()
    end
  end
end

function UIParkourBattleWinView:OnBackBtnClick()
  local userdata = self:GetUserData()
  if userdata.fromHelpResult then
    self.ctrl:CloseSelf()
    return
  end
  local cfg = {}
  for i, v in ipairs(self.flyRewardList) do
    cfg[i] = {
      v[1].position,
      v[2]
    }
  end
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
  if userdata.fromActFrontBreakSunday then
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.ActFrontBreakSunday)
    local preLoadAssets = {
      [UIAssets.ActivityTabGroupItem] = true,
      [UIAssets.UIActivityListItem] = true,
      [UIAssets.FrontBreakSunday] = true
    }
    DataCenter.ActFrontBreakSundayDataManager:SetNeedPlaySoliderFlyAnim(true)
    GoToUtil.GotoOpenView_BattleReturnOpt(UIWindowNames.UIActivityCenterTable, preLoadAssets, userdata.frontBreakSundayActId, preLoadAssets)
  end
end

function UIParkourBattleWinView:CheckShowFirstPay()
  local param = self:GetUserData()
  local monopolyEnter
  if param and param.enterType and param.enterType == PVEEnterType.Monopoly then
    monopolyEnter = true
  end
  local showFirstPay
  if monopolyEnter then
    local logic = DataCenter.LWBattleManager.logic
    if logic and logic.initUnitDeath then
      showFirstPay = true
    end
  end
  local curMonopoly = DataCenter.MonopolyManager.player.curId
  local realShow
  if showFirstPay then
    local lastMonopoly = CS.GameEntry.Setting:GetPrivateInt(SettingKeys.LAST_MONOPOLY_FIRSTPAY, 0)
    local passCount = LuaEntry.DataConfig:TryGetNum("first_cost_intensifying", "k1", -1)
    local endCount = LuaEntry.DataConfig:TryGetNum("first_cost_intensifying", "k2", -1)
    if -1 < endCount and curMonopoly > endCount then
      realShow = false
    elseif passCount == -1 then
      realShow = false
    elseif passCount == 0 then
      realShow = true
    elseif passCount < curMonopoly - lastMonopoly then
      realShow = true
    else
      realShow = false
    end
  end
  if realShow then
    local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
    local hasFirstPayGift = false
    if isNewFirstPay then
      local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
      hasFirstPayGift = firstPayPack ~= nil
    else
      local firstPayState = DataCenter.FirstPayManager:GetState()
      hasFirstPayGift = firstPayState >= FirstPayState.Unrepaired and firstPayState < FirstPayState.HasReceivedNormalReward
    end
  end
end

function UIParkourBattleWinView:OnGetReward(param)
  param = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.rewardCells = {}
  self.workersCells = {}
  self.herosCells = {}
  local s = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), self:GetUserData().stageId, "visitor_event")
  if tonumber(s) then
    table.insert(param, {
      rewardType = RewardType.WORKER
    })
  elseif type(s) == "string" then
    local spl = string.split(s, "|")
    for _, v in ipairs(spl) do
      if tonumber(v) then
        table.insert(param, {
          rewardType = RewardType.WORKER
        })
      end
    end
  end
  self.reqs = {}
  self.flyRewardList = {}
  local index = 0
  for _, v in pairs(param) do
    local req
    local p = v
    if p.rewardType == RewardType.HERO then
      req = Resource:InstantiateAsync(UIAssets.UIHeroCellSmall)
    else
      req = Resource:InstantiateAsync(UIAssets.UICommonResItem)
    end
    index = index + 1
    local name = index
    req:completed("+", function(req)
      local go = req.gameObject
      go.name = name
      CommonUtil.CallAutoArabicMirrorManually(req)
      if p.rewardType == RewardType.HERO then
        go.transform:SetParent(self.HeroRewardGrid1.transform)
        table.insert(self.herosCells, go)
        self.heroId = p.heroUuid
      elseif p.rewardType == RewardType.WORKER then
        go.transform:SetParent(self.WorkerRewardGrid1.transform)
        table.insert(self.workersCells, go)
      else
        go.transform:SetParent(self.rewardGrid1.transform)
        table.insert(self.rewardCells, go)
      end
      go.transform:Set_localScale(0, 0, 0)
      local cell
      if p.rewardType == RewardType.HERO then
        cell = self:AddComponent(UIHeroCellSmall, go)
        cell:SetData(p.heroUuid)
      else
        cell = self:AddComponent(UICommonResItem, go)
        cell:ReInit(p)
      end
      cell.gameObject:SetActive(false)
      table.insert(self.flyRewardList, {
        go.transform,
        p
      })
    end)
    table.insert(self.reqs, req)
  end
  DataCenter.ParkourManager.reward = nil
  DataCenter.ParkourManager.rewardStageId = nil
  local userData = self:GetUserData()
  if userData and userData.enterType == PVEEnterType.DetectZombieBusTrain then
    DataCenter.RadarCenterDataManager:SaveZombieBusReward(nil)
  end
end

function UIParkourBattleWinView:ShowRewardAnim()
  local delay = 0.1
  local scaledelay = 0.2
  local finalScale = 1
  local finalScale2 = 1
  self.showRewardAnimCo = coroutine.start(function()
    coroutine.waitforseconds(1.5)
    self.layout:SetActive(true)
    if not IsNull(self.bg.unity_image) then
      self.bg.unity_image:DOFade(0.8784313725490196, 0.3)
    end
    coroutine.waitforseconds(1)
    for i = 1, #self.showSeq - 4 do
      coroutine.waitforseconds(delay)
      self.showSeq[i]:SetActive(true)
      if not IsNull(self.showSeq[i].transform) then
        self.showSeq[i].transform:DOScale(finalScale, scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
      end
    end
    coroutine.waitforseconds(delay)
    for i, cells in ipairs({
      self.rewardCells,
      self.herosCells,
      self.workersCells
    }) do
      if 0 < #cells then
        local trans = self.showSeq[#self.showSeq - (4 - i)].transform
        if not IsNull(trans) then
          self.showSeq[#self.showSeq - (4 - i)]:SetActive(true)
          self.showSeq[#self.showSeq - (4 - i)].transform:DOScale(finalScale, scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
          for i = 1, #cells do
            coroutine.waitforseconds(delay)
            cells[i]:SetActive(true)
            cells[i].transform:DOScale(finalScale2, scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
          end
        end
      end
      coroutine.waitforseconds(delay)
    end
    if self.heroId and DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroId) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, self.heroId, {
        self.heroId
      }, nil, true)
    end
    self.showSeq[#self.showSeq]:SetActive(true)
    if self.isGoldLevel and self.alli_share_btn then
      self.alli_share_btn:SetActive(true)
    end
  end)
end

function UIParkourBattleWinView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UIParkourBattleWinView:OnShareBtnClick()
  local stage_share_time = CommonUtil.PlayerPrefsGetLong(SettingKeys.STAGE_FEATURE_SHARE_TIME, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaMinTime = LuaEntry.DataConfig:TryGetNum("Breakthrough_config", "k3", 0) * 1000
  if curTime <= stage_share_time + deltaMinTime then
    UIUtil.ShowTips(Localization:GetString("breakthough_tips_03"))
    return
  end
  if self.isGoldLevel then
    local shareParam = {}
    shareParam.post = PostType.GoldRelic
    shareParam.param = {
      goldCount = self:GetGoldCount() or 0
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
    return
  end
  local param = self:GetUserData()
  local shareParam = {}
  shareParam.param = {}
  local stageId = param.stageId or 0
  if param.fromChapter then
    shareParam.post = PostType.STAGE_FEATURE_CHAPTER
    shareParam.param.stageId = stageId
    local stageOrder = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order") or 0
    shareParam.param.stageOrder = stageOrder
    shareParam.param.fromChapter = true
    shareParam.param.score = param.score or 0
    shareParam.param.rank = param.rank or 0
  elseif param.fromActFrontBreakSunday then
    shareParam.post = PostType.FrontBreakSunday
    shareParam.param.stageId = stageId
    shareParam.param.fromActFrontBreakSunday = true
    shareParam.param.win = true
    shareParam.param.totalLeft = param.totalLeft or 0
    shareParam.param.frontBreakSundayActId = param.frontBreakSundayActId
    shareParam.param.ActFrontBreakTopRankOld = param.topRankOld or 0
    shareParam.param.ActFrontBreakTopRankNew = param.topRankNew or 0
    shareParam.param.ActFrontBreakAlRankOld = param.alRankOld or 0
    shareParam.param.ActFrontBreakAlRankNew = param.alRankNew or 0
    shareParam.param.ActFrontBreakSerRankOld = param.serRankOld or 0
    shareParam.param.ActFrontBreakSerRankNew = param.serRankNew or 0
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UIParkourBattleWinView:OnAllianceShareBtnClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("456550")
    return
  end
  local goldCount = self:GetGoldCount()
  if not goldCount then
    return
  end
  local shareParam = {}
  shareParam.post = PostType.GoldRelic
  shareParam.param = {goldCount = goldCount}
  local chatData = {}
  local allianceChannelRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
  if string.IsNullOrEmpty(allianceChannelRoomId) then
    return
  end
  chatData.roomId = allianceChannelRoomId
  chatData.post = shareParam.post
  chatData.param = shareParam.param
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
  local cfg = {}
  for i, v in ipairs(self.flyRewardList) do
    cfg[i] = {
      v[1].position,
      v[2]
    }
  end
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

return UIParkourBattleWinView
