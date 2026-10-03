local base = UIBaseContainer
local UILWSeasonTetrisMain = BaseClass("UILWSeasonTetrisMain", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")

function UILWSeasonTetrisMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textRankLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnRule = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnRule:SetOnClick(function()
    self:OnBtnRuleClick()
  end)
  self.textRuleLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textLevelName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textLevelDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textRewardTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compRewardTemplate = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.btnChallenge = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnChallenge:SetOnClick(function()
    self:OnBtnChallengeClick()
  end)
  self.compRedChallenge = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.textChallengeLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnResumeChallenge = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnResumeChallenge:SetOnClick(function()
    self:OnBtnResumeChallengeClick()
  end)
  self.textResumeLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.goLevelContent = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.goBtnGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.transRewardRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.textLevelProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textFinishToday = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.goRewardTemplate = self.compRewardTemplate.gameObject
  self.goRewardTemplate:GameObjectCreatePool()
  self.goRewardTemplate:SetActive(false)
end

function UILWSeasonTetrisMain:ComponentDestroy()
  self.transRewardRoot:RemoveComponents(UICommonResItem)
  self.goRewardTemplate:GameObjectRecycleAll()
  self.goRewardTemplate = nil
  self.viewSkin = nil
  self.btnTitle = nil
  self.btnRank = nil
  self.textRankLabel = nil
  self.btnRule = nil
  self.textRuleLabel = nil
  self.textRemainTime = nil
  self.textLevelName = nil
  self.textLevelDesc = nil
  self.textRewardTitle = nil
  self.compRewardTemplate = nil
  self.btnChallenge = nil
  self.compRedChallenge = nil
  self.textChallengeLabel = nil
  self.btnResumeChallenge = nil
  self.textResumeLabel = nil
  self.goLevelContent = nil
  self.goBtnGroup = nil
  self.transRewardRoot = nil
  self.textLevelProgress = nil
  self.textFinishToday = nil
end

function UILWSeasonTetrisMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWSeasonTetrisMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonTetrisMain:DataDefine()
end

function UILWSeasonTetrisMain:DataDestroy()
  self.GameData = nil
  self.Rewards = nil
  self.GameCell = nil
end

function UILWSeasonTetrisMain:SetData(actId, actData)
  self.ActId = actId
  self.ActData = actData
  self:Update1000MS()
end

function UILWSeasonTetrisMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTetrisGetInfoPayloadUpdate, self.OnGetInfoUpdate)
  self:AddUIListener(EventId.SeasonTetrisStartGame, self.OnStartUpdate)
end

function UILWSeasonTetrisMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTetrisGetInfoPayloadUpdate, self.OnGetInfoUpdate)
  self:RemoveUIListener(EventId.SeasonTetrisStartGame, self.OnStartUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonTetrisMain:ReInit()
  self:ResetLevelInfo()
  self:InitUi()
  self.RewardItems = {}
  DataCenter.SeasonTetrisManager:SendGetInfo()
end

function UILWSeasonTetrisMain:ResetLevelInfo()
  self.goLevelContent:SetActive(false)
  self.goBtnGroup:SetActive(false)
end

function UILWSeasonTetrisMain:InitUi()
  self.btnTitle:SetLocalText("season_s1_activity1200030_name")
  self.textRewardTitle:SetLocalText("activity_breakthrough_tips_5")
  self.textRankLabel:SetLocalText("390040")
  self.textRuleLabel:SetLocalText("458008")
  self.textChallengeLabel:SetLocalText("activity_breakthrough_tips_6")
  self.textResumeLabel:SetLocalText(400004)
end

function UILWSeasonTetrisMain:UpdateData()
  self.GameData = DataCenter.SeasonTetrisManager.GameData
  if self.GameData ~= nil then
    self.Rewards = nil
    local curLevel = DataCenter.SeasonTetrisManager:GetCurLevelIndex()
    local totalLevel = DataCenter.SeasonTetrisManager:GetTotalLevelCountToday()
    if curLevel <= totalLevel then
      local gameCell = self.GameData.GameCell
      if gameCell ~= nil then
        self.Rewards = DataCenter.RewardTemplateManager:GetList(gameCell.reward)
      end
    end
    if self.Rewards == nil and self.GameData.PreConfigId ~= nil then
      local preGameCell = LocalController:instance():getLine(TableName.SEASON_S1_BLOCK_GAME, self.GameData.PreConfigId)
      if preGameCell ~= nil then
        self.Rewards = DataCenter.RewardTemplateManager:GetList(preGameCell.reward)
      end
    end
    return true
  end
  return false
end

function UILWSeasonTetrisMain:UpdateUi()
  self:UpdateLevel()
  self.goRewardTemplate:GameObjectRecycleAll()
  self.transRewardRoot:RemoveComponents(UICommonResItem)
  if self.Rewards ~= nil and #self.Rewards > 0 then
    for i = 1, #self.Rewards do
      local levelName = "target_item_" .. i
      local goItem = self.goRewardTemplate:GameObjectSpawn(self.transRewardRoot.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      local theItem = self.transRewardRoot:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(self.Rewards[i])
    end
  end
end

function UILWSeasonTetrisMain:UpdateLevel()
  self.goLevelContent:SetActive(true)
  self.textLevelName:SetLocalText("season_s1_activity1200030_desc01")
  local curLevel = DataCenter.SeasonTetrisManager:GetCurLevelIndex()
  local totalLevel = DataCenter.SeasonTetrisManager:GetTotalLevelCountToday()
  self.textLevelProgress:SetLocalText("season_s1_activity1200030_desc02", math.min(curLevel, totalLevel), totalLevel)
  Logger.Log("\227\128\144\228\191\132\231\189\151\230\150\175\230\150\185\229\157\151\227\128\145\229\133\179\229\141\161\239\188\154" .. curLevel .. "/" .. totalLevel)
  local isAllFinished = DataCenter.SeasonTetrisManager:IsAllFinished()
  self.goBtnGroup:SetActive(not isAllFinished)
  if not isAllFinished then
    local isInGame = DataCenter.SeasonTetrisManager:IsInGame()
    self.btnChallenge:SetActive(not isInGame)
    self.btnResumeChallenge:SetActive(isInGame)
  end
  self.textFinishToday:SetLocalText("season_s4_activity_1200010_desc9")
  self.textFinishToday:SetActive(isAllFinished)
end

function UILWSeasonTetrisMain:TryGetTableItem(table, index)
  if self.Rewards == nil or #self.Rewards == 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #self.Rewards then
    return nil
  end
  local data = self.Rewards[index]
  local csItem = table:NewListViewItem("UICommonResItem")
  local cellItem = self.RewardItems[csItem]
  if cellItem == nil then
    local objName = tostring(self.RewardItemIndex)
    self.RewardItemIndex = self.RewardItemIndex + 1
    csItem.gameObject.name = objName
    cellItem = self.compRewardContent:AddComponent(UICommonResItem, objName)
    self.RewardItems[csItem] = cellItem
  end
  if cellItem ~= nil then
    cellItem:ReInit(data)
  end
  return csItem
end

function UILWSeasonTetrisMain:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTetrisRank)
end

function UILWSeasonTetrisMain:OnBtnRuleClick()
  local activityData = DataCenter.SeasonTetrisManager:GetActData()
  if activityData == nil then
    return
  end
  local param = {}
  param.howToPlayList = activityData.howtoplay
  param.story = activityData.story
  param.defaultTitle = activityData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UILWSeasonTetrisMain:OnBtnChallengeClick()
  local isInGame = DataCenter.SeasonTetrisManager:IsInGame()
  if isInGame then
    return
  end
  local curLevel = DataCenter.SeasonTetrisManager:GetCurLevelIndex()
  local totalLevel = DataCenter.SeasonTetrisManager:GetTotalLevelCountToday()
  if curLevel > totalLevel then
    return
  end
  DataCenter.SeasonTetrisManager:SendStart()
end

function UILWSeasonTetrisMain:OnBtnResumeChallengeClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTetrisGame)
end

function UILWSeasonTetrisMain:OnGetInfoUpdate(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonTetrisMain:OnStartUpdate(evt)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTetrisGame)
  self:UpdateLevel()
end

function UILWSeasonTetrisMain:Update1000MS()
  if self.ActData ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = math.max(0, self.ActData.endTime - now)
    self.textRemainTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

return UILWSeasonTetrisMain
