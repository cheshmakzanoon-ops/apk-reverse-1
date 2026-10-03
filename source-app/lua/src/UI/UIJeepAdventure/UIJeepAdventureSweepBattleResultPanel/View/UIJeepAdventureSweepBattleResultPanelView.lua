local UIJeepAdventureSweepBattleResultPanelView = BaseClass("UIJeepAdventureSweepBattleResultPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITowerupBattleResultGrowthList = require("UI.UIJeepAdventure.UITowerupBattleLose.Component.UITowerupBattleResultGrowthList")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local Resource = CS.GameEntry.Resource
local TabType = {Reward = 1, Stronger = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compVictoryBg = self:AddComponent(UIBaseContainer, "Content/VictoryBg")
  self.compNormalBg = self:AddComponent(UIBaseContainer, "Content/NormalBg")
  self.textVictoryTitle = self:AddComponent(UITextMeshProUGUIEx, "Content/VictoryBg/VictoryTitleBg/VictoryTitleText")
  self.textNormalTitle = self:AddComponent(UITextMeshProUGUIEx, "Content/NormalBg/NormalTitleBg/NormalTitleText")
  self.btnReward = self:AddComponent(UIButton, "Content/MiddleContent/TabContent/RewardBtn")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.btnStronger = self:AddComponent(UIButton, "Content/MiddleContent/TabContent/StrongerBtn")
  self.btnStronger:SetOnClick(function()
    self:OnBtnStrongerClick()
  end)
  self.compRewardContent = self:AddComponent(UIBaseContainer, "Content/MiddleContent/RewardContentBg/RewardScrollView/Viewport/RewardContent")
  self.compRewardContentBg = self:AddComponent(UIBaseContainer, "Content/MiddleContent/RewardContentBg")
  self.btnReturn = self:AddComponent(UIButton, "ReturnBtn")
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.textReturnBtn = self:AddComponent(UITextMeshProUGUIEx, "ReturnBtn/ReturnBtnText")
  self.textRewardBtn = self:AddComponent(UITextMeshProUGUIEx, "Content/MiddleContent/TabContent/RewardBtn/RewardBtnText")
  self.textStrongerBtn = self:AddComponent(UITextMeshProUGUIEx, "Content/MiddleContent/TabContent/StrongerBtn/StrongerBtnText")
  self.compGrowGuideScroll = self:AddComponent(UITowerupBattleResultGrowthList, "Content/MiddleContent/GrowGuideScroll", self.ctrl, {
    enterType = PVEEnterType.TowerupJeepAdventure,
    useHummerSceneManagerExit = true
  })
  self.highlightImage = self:AddComponent(UIImage, "Content/MiddleContent/TabContent/HighlightImage")
  self.rewardBtnIcon = self:AddComponent(UIImage, "Content/MiddleContent/TabContent/RewardBtn/RewardBtnIcon")
  self.strongerBtnIcon = self:AddComponent(UIImage, "Content/MiddleContent/TabContent/StrongerBtn/StrongerBtnIcon")
  self.rewardBtnText = self:AddComponent(UIText, "Content/MiddleContent/TabContent/RewardBtn/RewardBtnText")
  self.strongerBtnText = self:AddComponent(UIText, "Content/MiddleContent/TabContent/StrongerBtn/StrongerBtnText")
  self.textReturnBtn:SetLocalText("300520")
  self.rewardBtnText:SetLocalText("130065")
  self.strongerBtnText:SetLocalText("800799")
  self.curProgressText = self:AddComponent(UIText, "Content/TopContent/CurProgressText")
  self.passNumText = self:AddComponent(UIText, "Content/TopContent/PassNumText")
end

local function ComponentDestroy(self)
  self.compVictoryBg = nil
  self.compNormalBg = nil
  self.textVictoryTitle = nil
  self.textNormalTitle = nil
  self.btnReward = nil
  self.btnStronger = nil
  self.compRewardContent = nil
  self.compRewardContentBg = nil
  self.btnReturn = nil
  self.textReturnBtn = nil
  self.textRewardBtn = nil
  self.textStrongerBtn = nil
  self.compGrowGuideScroll = nil
  self.highlightImage = nil
  self.rewardBtnIcon = nil
  self.strongerBtnIcon = nil
  self.rewardBtnText = nil
  self.strongerBtnText = nil
end

local function DataDefine(self)
  self.pageType, self.resultType, self.rewardList, self.sweepNum, self.callback = self:GetUserData()
  self.tabIndex = TabType.Reward
  self:ReInit()
end

local function DataDestroy(self)
  self:ClearTabTween()
  self:ClearReward()
  self.pageType = nil
  self.resultType = nil
  self.rewardList = nil
  self.sweepNum = nil
  self.tabIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnRewardClick(self)
  self.tabIndex = TabType.Reward
  self:RefreshTabShow()
  self:ShowReward()
end

local function OnBtnStrongerClick(self)
  self.tabIndex = TabType.Stronger
  self:RefreshTabShow()
  self:ShowStronger()
end

local function OnBtnReturnClick(self)
  if self.callback then
    self.callback()
  end
  self.ctrl:CloseSelf()
end

local function ShowReward(self)
  self.compRewardContentBg:SetActive(true)
  self.compGrowGuideScroll:SetActive(false)
  self:ClearReward()
  self.rewardReqs = {}
  local rewardList = self.rewardList
  if rewardList ~= nil then
    local index = 0
    for _, v in pairs(rewardList) do
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
        go.transform:SetParent(self.compRewardContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        local cell
        if p.rewardType == RewardType.HERO then
          cell = self.compRewardContent:AddComponent(UIHeroCellSmall, go)
          cell:SetData(p.heroUuid)
        else
          cell = self.compRewardContent:AddComponent(UICommonResItem, go)
          cell:ReInit(p)
        end
      end)
      table.insert(self.rewardReqs, req)
    end
  end
end

local function ClearReward(self)
  self.compRewardContent:RemoveComponents(UIHeroCellSmall)
  self.compRewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs ~= nil then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
    self.rewardReqs = nil
  end
end

local function ShowStronger(self)
  self.compRewardContentBg:SetActive(false)
  self.compGrowGuideScroll:SetActive(true)
  self.compGrowGuideScroll:RefreshView()
  self.compGrowGuideScroll:FadeIn()
end

local function ReInit(self)
  if self.resultType == JeepStageSweepResultType.Victory then
    self.compVictoryBg:SetActive(true)
    self.compNormalBg:SetActive(false)
    self.textVictoryTitle:SetLocalText("armed_truck_challenge_win")
  elseif self.resultType == JeepStageSweepResultType.Lose then
    self.compVictoryBg:SetActive(false)
    self.compNormalBg:SetActive(true)
    self.textNormalTitle:SetLocalText("armed_truck_challenge_lose")
  else
    self.compVictoryBg:SetActive(true)
    self.compNormalBg:SetActive(false)
    self.textVictoryTitle:SetLocalText("armed_truck_challenge_suspend")
  end
  if self.rewardList and #self.rewardList > 0 then
    self:OnBtnRewardClick()
  else
    self:OnBtnStrongerClick()
  end
  local curStageId = DataCenter.LWJeepAdventureManager:GetCurStageIdByType(self.pageType)
  local nextTemplate = DataCenter.LWJeepAdventureManager:GetStageMetaByType(curStageId + 1, self.pageType)
  if nextTemplate == nil then
    nextTemplate = DataCenter.LWJeepAdventureManager:GetStageMetaByType(curStageId, self.pageType)
  end
  self.curProgressText:SetLocalText("trialtower_yijian_05", nextTemplate:GetName())
  self.passNumText:SetLocalText("trialtower_yijian_06", self.sweepNum)
end

local function ClearTabTween(self)
  if self.tabTween then
    self.tabTween:Kill()
    self.tabTween = nil
  end
end

local function RefreshTabShow(self)
  self:ClearTabTween()
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.highlightImage:GetAnchoredPositionX()
  end, function(value)
    self.highlightImage:SetAnchoredPositionXY(value, -1)
  end, (self.tabIndex - 1) * 317, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
  self.rewardBtnIcon:SetColor(self.tabIndex == TabType.Reward and TrailTowerBlackColor or TrailTowerGrayColor)
  self.rewardBtnText:SetColor(self.tabIndex == TabType.Reward and TrailTowerBlackColor or TrailTowerGrayColor)
  self.strongerBtnIcon:SetColor(self.tabIndex == TabType.Stronger and TrailTowerBlackColor or TrailTowerGrayColor)
  self.strongerBtnText:SetColor(self.tabIndex == TabType.Stronger and TrailTowerBlackColor or TrailTowerGrayColor)
end

UIJeepAdventureSweepBattleResultPanelView.OnCreate = OnCreate
UIJeepAdventureSweepBattleResultPanelView.OnDestroy = OnDestroy
UIJeepAdventureSweepBattleResultPanelView.OnEnable = OnEnable
UIJeepAdventureSweepBattleResultPanelView.OnDisable = OnDisable
UIJeepAdventureSweepBattleResultPanelView.ComponentDefine = ComponentDefine
UIJeepAdventureSweepBattleResultPanelView.ComponentDestroy = ComponentDestroy
UIJeepAdventureSweepBattleResultPanelView.DataDefine = DataDefine
UIJeepAdventureSweepBattleResultPanelView.DataDestroy = DataDestroy
UIJeepAdventureSweepBattleResultPanelView.OnAddListener = OnAddListener
UIJeepAdventureSweepBattleResultPanelView.OnRemoveListener = OnRemoveListener
UIJeepAdventureSweepBattleResultPanelView.OnBtnRewardClick = OnBtnRewardClick
UIJeepAdventureSweepBattleResultPanelView.OnBtnStrongerClick = OnBtnStrongerClick
UIJeepAdventureSweepBattleResultPanelView.OnBtnReturnClick = OnBtnReturnClick
UIJeepAdventureSweepBattleResultPanelView.ReInit = ReInit
UIJeepAdventureSweepBattleResultPanelView.ClearTabTween = ClearTabTween
UIJeepAdventureSweepBattleResultPanelView.RefreshTabShow = RefreshTabShow
UIJeepAdventureSweepBattleResultPanelView.ShowReward = ShowReward
UIJeepAdventureSweepBattleResultPanelView.ClearReward = ClearReward
UIJeepAdventureSweepBattleResultPanelView.ShowStronger = ShowStronger
return UIJeepAdventureSweepBattleResultPanelView
