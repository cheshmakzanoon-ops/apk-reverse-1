local UISkyBattleWinView = BaseClass("UISkyBattleWinView", UIBaseView)
local base = UIBaseView
local Time = _ENV.Time
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local LayoutLayer = "Layout/"
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")
local UISkyBattleRewardItem = require("UI.UILWStageSkyBattleChapter.Components.UISkyBattleRewardItem")

function UISkyBattleWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UISkyBattleWinView:OnDestroy()
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
  self.nextChapterId = nil
  self.nextStageId = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISkyBattleWinView:ComponentDefine()
  local param = self:GetUserData()
  self.bg = self:AddComponent(UIImage, "Image")
  self.backBtn = self:AddComponent(UIButton, "Layout/BtnGroup/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.nextBtn = self:AddComponent(UIButton, "Layout/BtnGroup/NextBtn")
  self.nextBtn:SetOnClick(function()
    self:OnNextBtnClick()
  end)
  self.retryBtn = self:AddComponent(UIButton, "Layout/BtnGroup/RetryBtn")
  self.retryBtn:SetOnClick(function()
    self:OnRetryBtnClick()
  end)
  self.shareBtn = self:AddComponent(UIButton, "ShareBtn")
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.shareBtn:SetActive(false)
  self.levelText = self:AddComponent(UIText, LayoutLayer .. "LevelText")
  self.StarGoalContent = self.transform:Find(LayoutLayer .. "StarGoal").gameObject
  self.StarGoalStar1Shine = self:AddComponent(UIImage, LayoutLayer .. "StarGoal/TotalStars/Star1/Shine1")
  self.StarGoalStar2Shine = self:AddComponent(UIImage, LayoutLayer .. "StarGoal/TotalStars/Star2/Shine2")
  self.StarGoalStar3Shine = self:AddComponent(UIImage, LayoutLayer .. "StarGoal/TotalStars/Star3/Shine3")
  self.StarGoalItem1CheckBox = self:AddComponent(UIImage, LayoutLayer .. "StarGoal/GoalItem1/CheckBox1")
  self.StarGoalItem2CheckBox = self:AddComponent(UIImage, LayoutLayer .. "StarGoal/GoalItem2/CheckBox2")
  self.StarGoalItem3CheckBox = self:AddComponent(UIImage, LayoutLayer .. "StarGoal/GoalItem3/CheckBox3")
  self.StarGoalItem1Desc = self:AddComponent(UITextMeshProUGUIEx, LayoutLayer .. "StarGoal/GoalItem1/GoalItem1Desc")
  self.StarGoalItem2Desc = self:AddComponent(UITextMeshProUGUIEx, LayoutLayer .. "StarGoal/GoalItem2/GoalItem2Desc")
  self.StarGoalItem3Desc = self:AddComponent(UITextMeshProUGUIEx, LayoutLayer .. "StarGoal/GoalItem3/GoalItem3Desc")
  self.rewardContent = self.transform:Find(LayoutLayer .. "RewardBg").gameObject
  self.rewardTitle1 = self:AddComponent(UIText, LayoutLayer .. "RewardBg/RewardTitle1")
  self.rewardTitle1:SetLocalText("800305")
  self.rewardGrid1 = self:AddComponent(UIBaseContainer, LayoutLayer .. "RewardBg/RewardGrid1")
  self.backBtnText = self:AddComponent(UIText, "Layout/BtnGroup/BackBtn/BackBtnText")
  self.backBtnText:SetLocalText("plane_chapter_btn_01")
  self.nextBtnText = self:AddComponent(UIText, "Layout/BtnGroup/NextBtn/NextBtnText")
  self.nextBtnText:SetLocalText("plane_chapter_btn_02")
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.victoryText:SetText(Localization:GetString("311105"))
  self.backBtn:SetActive(true)
  self.retryBtn:SetActive(false)
  self.resultDetailContent = self:AddComponent(UIBaseContainer, LayoutLayer .. "ResultDetailContent")
  self.resultDetailContent:SetActive(true)
  self.resultKillLabel = self:AddComponent(UITextMeshProUGUIEx, LayoutLayer .. "ResultDetailContent/KillContent/KillLabel")
  self.resultKillLabel:SetLocalText("800303")
  self.resultKillNum = self:AddComponent(UITextMeshProUGUIEx, LayoutLayer .. "ResultDetailContent/KillContent/KillNumTxt")
  self.resultTimeLabel = self:AddComponent(UITextMeshProUGUIEx, LayoutLayer .. "ResultDetailContent/TimeContent/TimeLabel")
  self.resultTimeLabel:SetLocalText("800304")
  self.resultTimeNum = self:AddComponent(UITextMeshProUGUIEx, LayoutLayer .. "ResultDetailContent/TimeContent/TimeNumTxt")
end

function UISkyBattleWinView:DataDefine()
end

function UISkyBattleWinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleReward, self.OnGetReward)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UISkyBattleWinView:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleReward, self.OnGetReward)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UISkyBattleWinView:ComponentDestroy()
  self.back_btn = nil
end

function UISkyBattleWinView:RefreshView()
  local param = self:GetUserData()
  local stageId = param.stageId
  local stageOrder = GetTableData(TableName.LW_Stage_SkyBattle, stageId, "order")
  self.levelText:SetText(Localization:GetString(GetTableData(TableName.LW_Stage_SkyBattle, stageId, "name"), stageOrder))
  local growthMode = param.growthMode
  local fromChapter = param.fromChapter
  self.resultKillNum:SetText(string.format("%d", param.kill or 0))
  self.resultTimeNum:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(param.time or 0))
  if fromChapter then
    self.levelText:SetActive(true)
    local chapterMgr = growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
    local hasNext, nextChapterId, nextStageId = chapterMgr:FindNextChapterStage(param.stageId)
    self.nextChapterId = nextChapterId
    self.nextStageId = nextStageId
    self.nextBtn:SetActive(hasNext)
    self.rewardContent:SetActive(growthMode)
    self.StarGoalContent:SetActive(true)
    self.rewardTitle1:SetActive(growthMode)
    if param.stageStarConditionMeet then
      self.StarGoalItem1CheckBox:SetActive(param.stageStarConditionMeet[1] or false)
      self.StarGoalItem2CheckBox:SetActive(param.stageStarConditionMeet[2] or false)
      self.StarGoalItem3CheckBox:SetActive(param.stageStarConditionMeet[3] or false)
    end
    local starCount = param.stageStarCounts or 0
    self.StarGoalStar1Shine:SetActive(0 < starCount)
    self.StarGoalStar2Shine:SetActive(1 < starCount)
    self.StarGoalStar3Shine:SetActive(2 < starCount)
    local condition1Txt = ""
    local condition2Txt = ""
    local condition3Txt = ""
    local mgr = growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
    local stageConditions = mgr:GetStageStarCondition(stageId)
    if stageConditions then
      condition1Txt = mgr:GetConditionLocalKey(stageConditions[1].type, stageConditions[1].value)
      condition2Txt = mgr:GetConditionLocalKey(stageConditions[2].type, stageConditions[2].value)
      condition3Txt = mgr:GetConditionLocalKey(stageConditions[3].type, stageConditions[3].value)
    end
    self.StarGoalItem1Desc:SetText(condition1Txt)
    self.StarGoalItem2Desc:SetText(condition2Txt)
    self.StarGoalItem3Desc:SetText(condition3Txt)
  else
    self.levelText:SetActive(false)
    self.nextBtn:SetActive(false)
    self.rewardContent:SetActive(false)
    self.StarGoalContent:SetActive(false)
    self.nextChapterId = nil
    self.nextStageId = nil
  end
  local reward = growthMode and DataCenter.LWSkyBattleGrowthChapterManager.reward or DataCenter.LWSkyBattleChapterManager.reward
  local rewardStageId = growthMode and DataCenter.LWSkyBattleGrowthChapterManager.rewardStageId or DataCenter.LWSkyBattleChapterManager.rewardStageId
  if reward and rewardStageId and rewardStageId == stageId then
    self:OnGetReward({reward = reward, isGrowthMode = growthMode})
  end
  DataCenter.LWSoundManager:PlaySound(10027)
end

function UISkyBattleWinView:OnNextBtnClick()
  if self.nextChapterId and self.nextStageId then
    local param = self:GetUserData()
    local growthMode = param.growthMode
    local chapterMgr = growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
    local stageEnterConditionMatch = chapterMgr:CheckChapterStageMatchEnterCondition(self.nextChapterId, self.nextStageId, true)
    if stageEnterConditionMatch then
      local nextChapterId = self.nextChapterId
      local nextStageId = self.nextStageId
      self.ctrl:CloseSelf()
      DataCenter.LWBattleManager:Destroy()
      chapterMgr:EnterChapterStage(nextChapterId, nextStageId)
    end
  end
end

function UISkyBattleWinView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

function UISkyBattleWinView:OnGetReward(param)
  if not param then
    return
  end
  local reward = param.reward
  local isGrowthMode = param.isGrowthMode
  if isGrowthMode then
    self:OnGetSkyBattleReward(reward)
  else
    self:OnGetNormalReward(reward)
  end
end

function UISkyBattleWinView:OnGetNormalReward(reward)
  if not reward then
    return
  end
  local rewardParam = DataCenter.RewardManager:ReturnRewardParamForMessage(reward) or {}
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.rewardCells = {}
  self.reqs = {}
  local index = 0
  for _, v in pairs(rewardParam) do
    local req
    local p = v
    req = Resource:InstantiateAsync(UIAssets.UICommonResItem)
    index = index + 1
    local name = index
    req:completed("+", function(req)
      local go = req.gameObject
      go.name = name
      CommonUtil.CallAutoArabicMirrorManually(req)
      go.transform:SetParent(self.rewardGrid1.transform)
      go.transform.localScale = Vector3.one
      table.insert(self.rewardCells, go)
      local cell = self:AddComponent(UICommonResItem, go)
      cell:ReInit(p)
      cell.gameObject:SetActive(true)
    end)
    table.insert(self.reqs, req)
  end
  DataCenter.LWSkyBattleChapterManager.reward = nil
  DataCenter.LWSkyBattleChapterManager.rewardStageId = nil
end

local skyBattleRewardPath = "Assets/Main/Prefabs/UI/LWUIStageSkyBattleChapter/SkyBattleReward.prefab"

function UISkyBattleWinView:OnGetSkyBattleReward(reward)
  if not reward then
    return
  end
  local rewardParam = DataCenter.LWSkyBattleGrowthChapterManager:ReturnRewardParamForMessage(reward) or {}
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.rewardCells = {}
  self.reqs = {}
  local index = 0
  for _, v in ipairs(rewardParam) do
    local req
    local p = v
    req = Resource:InstantiateAsync(skyBattleRewardPath)
    index = index + 1
    local name = index
    req:completed("+", function(req)
      local go = req.gameObject
      go.name = name
      CommonUtil.CallAutoArabicMirrorManually(req)
      go.transform:SetParent(self.rewardGrid1.transform)
      go.transform.localScale = Vector3.one
      table.insert(self.rewardCells, go)
      local cell = self:AddComponent(UISkyBattleRewardItem, go)
      cell:ReInit(p)
      cell.gameObject:SetActive(true)
    end)
    table.insert(self.reqs, req)
  end
  DataCenter.LWSkyBattleGrowthChapterManager.reward = nil
  DataCenter.LWSkyBattleGrowthChapterManager.rewardStageId = nil
end

function UISkyBattleWinView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UISkyBattleWinView:OnShareBtnClick()
end

return UISkyBattleWinView
