local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SeasonMoneyRankEntryComp = require("UI.LWSeason5.UILWSeasonMoneyRank.Comp.SeasonMoneyRankEntryComp")
local SeasonMoneyRankTopThreeComp = require("UI.LWSeason5.UILWSeasonMoneyRank.Comp.SeasonMoneyRankTopThreeComp")
local SeasonMoneyRankMain = BaseClass("SeasonMoneyRankMain", UIBaseContainer)

function SeasonMoneyRankMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textBtnRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textActName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRecord = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.transEntryRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compEntryTemplate = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.compPTop3 = self.viewSkin:AddComponent(self, SeasonMoneyRankTopThreeComp, 12)
  self.compPTop3Other = self.viewSkin:AddComponent(self, SeasonMoneyRankTopThreeComp, 13)
  local text_rank_1_path = "Root/mid/content_top_3/text_rank_1"
  local text_rank_2_path = "Root/mid/content_top_3/text_rank_2"
  local text_rank_3_path = "Root/mid/content_top_3/text_rank_3"
  self.text_rank_1 = self:AddComponent(UITextMeshProUGUIEx, text_rank_1_path):SetText("1")
  self.text_rank_2 = self:AddComponent(UITextMeshProUGUIEx, text_rank_2_path):SetText("2")
  self.text_rank_3 = self:AddComponent(UITextMeshProUGUIEx, text_rank_3_path):SetText("3")
  self.goEntryTemplate = self.compEntryTemplate.gameObject
  self.goEntryTemplate:GameObjectCreatePool()
  self.compEntryTemplate:SetActive(false)
end

function SeasonMoneyRankMain:ComponentDestroy()
  self.transEntryRoot:RemoveComponents(SeasonMoneyRankEntryComp)
  self.goEntryTemplate:GameObjectRecycleAll()
  self.goEntryTemplate = nil
  self.text_rank_1 = nil
  self.text_rank_2 = nil
  self.text_rank_3 = nil
  self.viewSkin = nil
  self.textBtnRank = nil
  self.textTime = nil
  self.textActName = nil
  self.textRecord = nil
  self.btnRank = nil
  self.textReward = nil
  self.btnRecord = nil
  self.btnReward = nil
  self.btnInfo = nil
  self.transEntryRoot = nil
  self.compEntryTemplate = nil
  self.compPTop3 = nil
  self.compPTop3Other = nil
end

function SeasonMoneyRankMain:DataDefine()
end

function SeasonMoneyRankMain:DataDestroy()
  self.ActId = nil
  self.ActData = nil
  DataCenter.SeasonMoneyRankManager:ClearRankData()
end

function SeasonMoneyRankMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonMoneyRankMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMoneyRankMain:SetData(actId, actData)
  self.ActId = actId
  self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if self.ActData ~= nil then
    self:ReInit()
  end
end

function SeasonMoneyRankMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMoneyRankRankUpdate, self.OnRankUpdate)
  self:AddUIListener(EventId.SeasonMoneyRankEntryClick, self.OnEntryClicked)
end

function SeasonMoneyRankMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMoneyRankRankUpdate, self.OnRankUpdate)
  self:RemoveUIListener(EventId.SeasonMoneyRankEntryClick, self.OnEntryClicked)
  base.OnRemoveListener(self)
end

function SeasonMoneyRankMain:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function SeasonMoneyRankMain:InitData(data)
  self.MainRankReady = false
  self.CurRankType = DataCenter.SeasonMoneyRankManager.RankType.None
  self.CurRankComp = self.compPTop3
  self.OtherRankComp = self.compPTop3Other
  self.HasCrossToEnd = false
  return true
end

function SeasonMoneyRankMain:InitUi()
  self.textActName:SetLocalText(self.ActData.name)
  self.CurRankComp:SetActive(false)
  self.OtherRankComp:SetActive(false)
  local curState = DataCenter.SeasonMoneyRankManager:GetCurActState()
  if curState == DataCenter.SeasonMoneyRankManager.ActState.EndShow then
    self.textActName:SetLocalText("season_s5_activity_1200046_name02")
    self.HasCrossToEnd = true
  end
  self:InitEntry()
end

function SeasonMoneyRankMain:InitEntry()
  local entryRankTypeArr = {
    DataCenter.SeasonMoneyRankManager.RankType.AllPerson
  }
  self.goEntryTemplate:GameObjectRecycleAll()
  self.transEntryRoot:RemoveComponents(SeasonMoneyRankEntryComp)
  local curActState = DataCenter.SeasonMoneyRankManager:GetCurActState()
  local periodType
  for i = 1, 4 do
    local entryData = DataCenter.SeasonMoneyRankManager.EntryData[i]
    periodType = entryData.PeriodType[curActState]
    local goName = "entry_" .. entryData.RankType .. "_" .. periodType
    local goItem = self.goEntryTemplate:GameObjectSpawn(self.transEntryRoot.transform)
    goItem.name = goName
    goItem:SetActive(true)
    local comp = self.transEntryRoot:AddComponent(SeasonMoneyRankEntryComp, goName)
    comp:ReInit(entryData)
    table.insert(entryRankTypeArr, entryData.RankType)
  end
  DataCenter.SeasonMoneyRankManager:SendGetRank(entryRankTypeArr, periodType, DataCenter.SeasonMoneyRankManager.RankMode.Simple)
end

function SeasonMoneyRankMain:UpdateData()
  return true
end

function SeasonMoneyRankMain:UpdateUi()
end

function SeasonMoneyRankMain:OnBtnRankClick()
  local param = {}
  param.DefaultTab = 1
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonMoneyRankRank, {anim = true}, param)
end

function SeasonMoneyRankMain:OnBtnRecordClick()
  local param = {}
  param.DefaultTab = DataCenter.SeasonMoneyRankManager.LogType.BankTrans
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonMoneyRankLog, {anim = true}, param)
end

function SeasonMoneyRankMain:OnBtnRewardClick()
  local actCell = DataCenter.SeasonMoneyRankManager:GetActCell()
  if actCell ~= nil then
    local rewardList = {}
    local configId = checknumber(actCell.para)
    LocalController:instance():visitTable(TableName.LW_SEASON_MONEY_RANK, function(id, lineData)
      if lineData and lineData.groupId == configId and lineData.reward_show == 1 then
        table.insert(rewardList, checknumber(lineData.rankId))
      end
    end)
    if table.count(rewardList) > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICommonRankMultipleReward, {anim = true}, rewardList)
    end
  end
end

function SeasonMoneyRankMain:OnBtnInfoClick()
  if self.ActData ~= nil and self.ActData.story ~= nil then
    local param = {}
    param.activityId = self.ActId
    param.activityRulesStr = Localization:GetString(self.ActData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SeasonMoneyRankMain:Update1000MS()
  if self.ActData ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local endTime = DataCenter.SeasonMoneyRankManager:GetEndShowStartTime()
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
  end
end

function SeasonMoneyRankMain:GetMoveDirection(rankType)
  local rankTypeEnum = DataCenter.SeasonMoneyRankManager.RankType
  local directionEnum = DataCenter.SeasonMoneyRankManager.TopThreeAnimDirection
  if self.CurRankType == rankTypeEnum.None then
    return directionEnum.None
  end
  if rankType == rankTypeEnum.AllPerson then
    return directionEnum.Down
  end
  if self.CurRankType == rankTypeEnum.AllPerson then
    return directionEnum.Up
  end
  local curOrder = DataCenter.SeasonMoneyRankManager.EntryOrder[self.CurRankType]
  local targetOrder = DataCenter.SeasonMoneyRankManager.EntryOrder[rankType]
  if curOrder < targetOrder then
    return directionEnum.Left
  end
  if curOrder > targetOrder then
    return directionEnum.Right
  end
  return directionEnum.None
end

function SeasonMoneyRankMain:OnEntryClicked(evtData)
  if evtData == nil then
    return
  end
  if self.CurRankComp:IsMoving() or self.OtherRankComp:IsMoving() then
    return
  end
  local rankType = evtData.RankType
  local curState = DataCenter.SeasonMoneyRankManager:GetCurActState()
  local periodType = evtData.PeriodType[curState]
  if rankType == self.CurRankType then
    rankType = DataCenter.SeasonMoneyRankManager.RankType.AllPerson
  end
  self:UpdateTopComp(rankType, periodType)
  EventManager:GetInstance():Broadcast(EventId.SeasonMoneyRankEntrySelect, evtData)
end

function SeasonMoneyRankMain:UpdateTopComp(rankType, periodType)
  local animDirection = self:GetMoveDirection(rankType)
  local rankData = DataCenter.SeasonMoneyRankManager:GetCacheRankData(rankType, periodType, DataCenter.SeasonMoneyRankManager.RankMode.Simple)
  if rankData == nil then
    return
  end
  self.CurRankComp:SetActive(true)
  self.OtherRankComp:SetActive(true)
  self.CurRankType = rankType
  self.OtherRankComp:ReInit(rankData)
  self.OtherRankComp:AnimIn(animDirection, 0.1)
  self.CurRankComp:AnimOut(animDirection)
  self.CurRankComp, self.OtherRankComp = self.OtherRankComp, self.CurRankComp
end

function SeasonMoneyRankMain:OnRankUpdate(evtData)
  if evtData == nil then
    return
  end
  local rankType = checknumber(evtData.RankType)
  local periodType = checknumber(evtData.PeriodType)
  local rankMode = checknumber(evtData.RankMode)
  if rankType == DataCenter.SeasonMoneyRankManager.RankType.AllPerson and rankMode == DataCenter.SeasonMoneyRankManager.RankMode.Simple then
    self.MainRankReady = true
    self:UpdateTopComp(rankType, periodType)
  end
end

return SeasonMoneyRankMain
