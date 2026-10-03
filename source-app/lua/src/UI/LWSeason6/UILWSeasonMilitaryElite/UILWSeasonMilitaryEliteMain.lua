local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local p_content_my_total_rank_path = "Root/mid/content_entry/p_content_my_total_rank"
local p_text_my_total_rank_path = "Root/mid/content_entry/p_content_my_total_rank/p_text_my_total_rank"
local p_btn_total_rank_detail_path = "Root/mid/content_entry/p_content_my_total_rank/p_btn_total_rank_detail"
local UILWSeasonMilitaryEliteEntryComp = require("UI.LWSeason6.UILWSeasonMilitaryElite.Comp.UILWSeasonMilitaryEliteEntryComp")
local UILWSeasonMilitaryEliteTopThreeComp = require("UI.LWSeason6.UILWSeasonMilitaryElite.Comp.UILWSeasonMilitaryEliteTopThreeComp")
local TCCommonDropDown = require("UI/LWUITC/Component/TCCommonDropDownComponent")
local UILWSeasonMilitaryEliteMain = BaseClass("UILWSeasonMilitaryEliteMain", UIBaseContainer)

function UILWSeasonMilitaryEliteMain:ComponentDefine()
  self.p_content_my_total_rank = self:AddComponent(UICanvasGroup, p_content_my_total_rank_path)
  self.p_text_my_total_rank = self:AddComponent(UITextMeshProUGUIEx, p_text_my_total_rank_path)
  self.p_btn_total_rank_detail = self:AddComponent(UIButton, p_btn_total_rank_detail_path)
  self.p_btn_total_rank_detail:SetOnClick(BindCallback(self, self.OnTotalDetailClicked))
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "Root/top/title/TimeGroup/TimeBG/p_text_time")
  self.textActName = self:AddComponent(UITextMeshProUGUIEx, "Root/top/title/TitleGroup/p_act_name")
  self.btnRank = self:AddComponent(UIButton, "Root/top/btn_list/p_btn_rank")
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnReward = self:AddComponent(UIButton, "Root/top/btn_list/p_btn_reward")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.p_btn_royal = self:AddComponent(UIButton, "Root/top/btn_list/p_btn_royal")
  self.p_btn_royal:SetOnClick(function()
    self:OnRoyalClicked()
  end)
  self.btnInfo = self:AddComponent(UIButton, "Root/top/title/TitleGroup/p_btn_info")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compPTop3 = self:AddComponent(UILWSeasonMilitaryEliteTopThreeComp, "Root/mid/content_top_3/p_comp_top_3")
  self.compPTop3Other = self:AddComponent(UILWSeasonMilitaryEliteTopThreeComp, "Root/mid/content_top_3/p_comp_top_3_other")
  self.text_rank_1 = self:AddComponent(UITextMeshProUGUIEx, "Root/mid/content_top_3/text_rank_1"):SetText("1")
  self.text_rank_2 = self:AddComponent(UITextMeshProUGUIEx, "Root/mid/content_top_3/text_rank_2"):SetText("2")
  self.text_rank_3 = self:AddComponent(UITextMeshProUGUIEx, "Root/mid/content_top_3/text_rank_3"):SetText("3")
  self.p_scroll_view_entry = self:AddComponent(UIScrollViewSimple, "Root/mid/content_entry/p_scroll_view_entry")
  self.p_comp_rank_tab = self:AddComponent(TCCommonDropDown, "Root/bottom/p_comp_rank_tab")
  self.p_content_reward_tips = self:AddComponent(UIImage, "Root/top/btn_list/p_btn_reward/p_content_reward_tips")
  self.p_text_reward_tips = self:AddComponent(UITextMeshProUGUIEx, "Root/top/btn_list/p_btn_reward/p_content_reward_tips/p_text_reward_tips")
end

function UILWSeasonMilitaryEliteMain:ComponentDestroy()
  self.p_content_my_total_rank = nil
  self.p_text_my_total_rank = nil
  self.p_btn_total_rank_detail = nil
  self.text_rank_1 = nil
  self.text_rank_2 = nil
  self.text_rank_3 = nil
  self.textTime = nil
  self.textActName = nil
  self.btnRank = nil
  self.p_btn_royal = nil
  self.btnReward = nil
  self.btnInfo = nil
  self.compPTop3 = nil
  self.compPTop3Other = nil
  self.p_scroll_view_entry = nil
  self.p_comp_rank_tab = nil
  self.p_content_reward_tips = nil
  self.p_text_reward_tips = nil
end

function UILWSeasonMilitaryEliteMain:DataDefine()
end

function UILWSeasonMilitaryEliteMain:DataDestroy()
  self.ActId = nil
  self.ActData = nil
  DataCenter.SeasonMilitaryEliteManager:ClearRankData()
end

function UILWSeasonMilitaryEliteMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryEliteMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryEliteMain:SetData(actId, actData)
  self.ActId = actId
  self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if self.ActData ~= nil then
    self:ReInit()
  end
end

function UILWSeasonMilitaryEliteMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnRankUpdate)
  self:AddUIListener(EventId.SeasonMilitaryEliteEntryClick, self.OnEntryClicked)
end

function UILWSeasonMilitaryEliteMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnRankUpdate)
  self:RemoveUIListener(EventId.SeasonMilitaryEliteEntryClick, self.OnEntryClicked)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryEliteMain:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function UILWSeasonMilitaryEliteMain:InitData(data)
  self.CurRankType = DataCenter.SeasonMilitaryEliteManager.RankType.None
  self.CurPeriodToggleType = 0
  self.CurPeriodToggleIndex = 0
  self.CurRankComp = self.compPTop3
  self.OtherRankComp = self.compPTop3Other
  self.HasCrossToEnd = false
  self.EntryRankTypeArr = {
    DataCenter.SeasonMilitaryEliteManager.RankType.Person_All
  }
  for _, entryData in pairs(DataCenter.SeasonMilitaryEliteManager.EntryData) do
    table.insert(self.EntryRankTypeArr, entryData.RankType)
  end
  return true
end

function UILWSeasonMilitaryEliteMain:InitUi()
  self.p_scroll_view_entry:Init(UILWSeasonMilitaryEliteEntryComp)
  self.textActName:SetLocalText(self.ActData.name)
  self.CurRankComp:SetActive(false)
  self.OtherRankComp:SetActive(false)
  self.p_content_my_total_rank:SetActive(false)
  self.p_content_my_total_rank:SetInteractable(false)
  local curState = DataCenter.SeasonMilitaryEliteManager:GetCurActState()
  if curState == DataCenter.SeasonMilitaryEliteManager.ActState.EndShow then
    self.textActName:SetLocalText("season_military_rank_Onlyshow")
    self.HasCrossToEnd = true
  end
  local defaultPeriod = CommonUtil.PlayerPrefsGetInt(SettingKeys.S6_MILITARY_ELITE_DEFAULT_DROPDOWN, 2)
  self:InitDropDown(defaultPeriod)
  self:InitEntry()
  self:UpdateRewardTipsState()
  CommonUtil.PlayerPrefsSetLong(SettingKeys.S6_MILITARY_ELITE_REWARD_DAILY_SHOW, UITimeManager:GetInstance():GetServerSeconds())
end

function UILWSeasonMilitaryEliteMain:UpdateRewardTipsState()
  local lastTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.S6_MILITARY_ELITE_REWARD_DAILY_SHOW, 0)
  self.ShowRewardTips = not UITimeManager:GetInstance():IsSameDayForServer(lastTime, UITimeManager:GetInstance():GetServerSeconds())
  if self.ShowRewardTips then
    local now = UITimeManager:GetInstance():GetServerTime()
    self.NextTime = DataCenter.SeasonMilitaryManager:CalculateNextSettlementTime(now)
    if now < self.NextTime then
      self.p_content_reward_tips:SetActive(true)
    else
      self.ShowRewardTips = false
    end
  else
    self.p_content_reward_tips:SetActive(false)
  end
end

function UILWSeasonMilitaryEliteMain:UpdateRewardTipsTime()
  if self.ShowRewardTips then
    local leftTime = Mathf.Max(0, self.NextTime - UITimeManager:GetInstance():GetServerTime())
    if leftTime <= 0 then
      self:UpdateRewardTipsState()
    end
    self.p_text_reward_tips:SetLocalText("season_military_rank_settle_rewards_tips_limit", UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

function UILWSeasonMilitaryEliteMain:InitDropDown(defaultIndex)
  local tabDataList = DataCenter.SeasonMilitaryEliteManager.RankViewTabPeriodTypeData
  self.PeriodTypeTabs = {}
  local curActState = DataCenter.SeasonMilitaryEliteManager:GetCurActState()
  if curActState == DataCenter.SeasonMilitaryEliteManager.ActState.Normal then
    for _, tab in pairs(tabDataList) do
      local tabData = {}
      tabData.PeriodType = tab.PeriodType
      tabData.name = CS.GameEntry.Localization:GetString(tab.TabLocKey)
      table.insert(self.PeriodTypeTabs, tabData)
    end
  else
    local tabData = {}
    tabData.PeriodType = DataCenter.SeasonMilitaryEliteManager.PeriodType.Total
    tabData.name = CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc27")
    table.insert(self.PeriodTypeTabs, tabData)
  end
  self.p_comp_rank_tab:Clear()
  for _, tab in pairs(self.PeriodTypeTabs) do
    self.p_comp_rank_tab:Add(tab.name)
  end
  self.p_comp_rank_tab:BindIndexChangeEvent(function(index)
    self:OnPeriodTypeToggle(index)
  end)
  defaultIndex = Mathf.Clamp(defaultIndex, 1, #self.PeriodTypeTabs)
  self.p_comp_rank_tab:OnSelectIndexChange(defaultIndex)
end

function UILWSeasonMilitaryEliteMain:OnPeriodTypeToggle(index, itemData)
  CommonUtil.PlayerPrefsSetInt(SettingKeys.S6_MILITARY_ELITE_DEFAULT_DROPDOWN, index)
  if self.CurPeriodToggleIndex ~= index then
    self.CurPeriodToggleIndex = index
    local periodType = self.PeriodTypeTabs[index].PeriodType
    self.CurPeriodToggleType = periodType
    DataCenter.SeasonMilitaryEliteManager:SendGetRank(self.EntryRankTypeArr, periodType, DataCenter.SeasonMilitaryEliteManager.RankMode.Simple)
    self:InitEntry(self.CurRankType)
  end
end

function UILWSeasonMilitaryEliteMain:InitEntry(defaultRankType)
  self.p_scroll_view_entry:Clear()
  for _, entryData in pairs(DataCenter.SeasonMilitaryEliteManager.EntryData) do
    local data = {}
    data.RankType = entryData.RankType
    data.PeriodType = self.CurPeriodToggleType
    data.Selected = entryData.RankType == defaultRankType
    self.p_scroll_view_entry:AddData(data)
  end
  self.p_scroll_view_entry:Show()
end

function UILWSeasonMilitaryEliteMain:UpdateData()
  return true
end

function UILWSeasonMilitaryEliteMain:UpdateUi()
end

function UILWSeasonMilitaryEliteMain:OnBtnRankClick()
  local param = {}
  param.DefaultTab = 1
  param.DefaultDropDownIndex = checknumber(self.CurPeriodToggleIndex)
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonMilitaryEliteRank, {anim = true}, param)
end

function UILWSeasonMilitaryEliteMain:OnRoyalClicked()
  local infoData = DataCenter.SeasonMilitaryManager.InfoData
  if infoData ~= nil then
    local param = {}
    param.DefaultLevel = infoData:GetLevel()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMilitaryRoyal, {anim = true}, param)
  end
end

function UILWSeasonMilitaryEliteMain:OnBtnRewardClick()
  self.p_content_reward_tips:SetActive(false)
  local actCell = DataCenter.SeasonMilitaryEliteManager:GetActCell()
  if actCell ~= nil then
    local rewardList = {}
    local configId = checknumber(actCell.para)
    LocalController:instance():visitTable(TableName.LW_SEASON_MILITARY_RANK, function(id, lineData)
      if lineData and lineData.groupId == configId and lineData.reward_show == 1 then
        table.insert(rewardList, checknumber(lineData.rankId))
      end
    end)
    if table.count(rewardList) > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankMultipleReward, {anim = true}, rewardList)
    end
  end
end

function UILWSeasonMilitaryEliteMain:OnBtnInfoClick()
  if self.ActData ~= nil and self.ActData.story ~= nil then
    local param = {}
    param.activityId = self.ActId
    param.activityRulesStr = Localization:GetString(self.ActData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UILWSeasonMilitaryEliteMain:Update1000MS()
  if self.ActData ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local endTime = DataCenter.SeasonMilitaryEliteManager:GetEndShowStartTime()
    if now > endTime and not self.HasCrossToEnd then
      self.HasCrossToEnd = true
      if self:InitData() then
        self:InitUi()
      end
    end
    if now > endTime then
      endTime = self.ActData:GetShowEndTime()
    end
    local leftTime = math.max(0, endTime - now)
    self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    self:UpdateRewardTipsTime()
  end
end

function UILWSeasonMilitaryEliteMain:GetMoveDirection(rankType)
  local rankTypeEnum = DataCenter.SeasonMilitaryEliteManager.RankType
  local directionEnum = DataCenter.SeasonMilitaryEliteManager.TopThreeAnimDirection
  if self.CurRankType == rankTypeEnum.None then
    return directionEnum.None
  end
  if rankType == rankTypeEnum.Person_All then
    return directionEnum.Down
  end
  if self.CurRankType == rankTypeEnum.Person_All then
    return directionEnum.Up
  end
  local curOrder = DataCenter.SeasonMilitaryEliteManager.EntryOrder[self.CurRankType]
  local targetOrder = DataCenter.SeasonMilitaryEliteManager.EntryOrder[rankType]
  if curOrder < targetOrder then
    return directionEnum.Left
  end
  if curOrder > targetOrder then
    return directionEnum.Right
  end
  return directionEnum.None
end

function UILWSeasonMilitaryEliteMain:OnEntryClicked(evtData)
  if evtData == nil then
    return
  end
  if self.CurRankComp:IsMoving() or self.OtherRankComp:IsMoving() then
    return
  end
  local rankType = evtData.RankType
  local periodType = evtData.PeriodType
  if rankType == self.CurRankType then
    rankType = DataCenter.SeasonMilitaryEliteManager.RankType.Person_All
  end
  self:UpdateTopComp(rankType, periodType)
  EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryEliteEntrySelect, evtData)
end

function UILWSeasonMilitaryEliteMain:UpdateTopComp(rankType, periodType)
  local animDirection = self:GetMoveDirection(rankType)
  local rankData = DataCenter.SeasonMilitaryEliteManager:GetCacheRankData(rankType, periodType, DataCenter.SeasonMilitaryEliteManager.RankMode.Simple)
  if rankData == nil then
    return
  end
  self:UpdateMyRank(rankType, rankData)
  self.CurRankComp:SetActive(true)
  self.OtherRankComp:SetActive(true)
  self.CurRankType = rankType
  self.OtherRankComp:ReInit(rankData)
  self.OtherRankComp:AnimIn(animDirection, 0.1)
  self.CurRankComp:AnimOut(animDirection)
  self.CurRankComp, self.OtherRankComp = self.OtherRankComp, self.CurRankComp
end

function UILWSeasonMilitaryEliteMain:UpdateMyRank(rankType, rankData)
  self.p_content_my_total_rank:SetActive(true)
  self.p_content_my_total_rank:SetInteractable(true)
  if rankType == DataCenter.SeasonMilitaryEliteManager.RankType.Person_All then
    local myRankStr = CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc30")
    local myRank = checknumber(rankData.self.rank)
    if 200 < myRank then
      myRankStr = "200+"
    elseif 0 < myRank then
      myRankStr = myRank
    end
    self.p_text_my_total_rank:SetLocalText("season_military_rank_myrank", myRankStr)
    self.p_content_my_total_rank:SetAlpha(0)
    self.p_content_my_total_rank.unity_canvas_group:DOFade(1, 0.2)
    self.p_content_my_total_rank:SetInteractable(true)
  else
    self.p_content_my_total_rank.unity_canvas_group:DOFade(0, 0.2)
    self.p_content_my_total_rank:SetInteractable(false)
  end
end

function UILWSeasonMilitaryEliteMain:OnRankUpdate(evtData)
  if evtData == nil then
    return
  end
  local rankType = checknumber(evtData.RankType)
  local periodType = checknumber(evtData.PeriodType)
  local rankMode = checknumber(evtData.RankMode)
  local rankTypeEnum = DataCenter.SeasonMilitaryEliteManager.RankType
  if rankMode == DataCenter.SeasonMilitaryEliteManager.RankMode.Simple and (self.CurRankType == rankTypeEnum.None and rankType == rankTypeEnum.Person_All or self.CurRankType == rankType) and periodType == self.CurPeriodToggleType then
    self:UpdateTopComp(rankType, periodType)
  end
end

function UILWSeasonMilitaryEliteMain:OnTotalDetailClicked()
  local param = {}
  param.ConfigId = DataCenter.SeasonMilitaryEliteManager.RankType.Person_All
  UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryEliteScoreTipsView, {anim = true}, param)
end

return UILWSeasonMilitaryEliteMain
