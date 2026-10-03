local base = UIBaseView
local LWUITrailTowerSweepBattleResultView = BaseClass("LWUITrailTowerSweepBattleResultView", base)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local LWUITrailTowerBattleEndHeroItemRender = require("UI.LWTrailTower.BattleEnd.Component.LWUITrailTowerBattleEndHeroItemRender")
local UIGrowthList = require("UI.UIJeepAdventure.UITowerupBattleLose.Component.UITowerupBattleResultGrowthList")
local MailBattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")
local SkirmishBattleData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishBattleData")
local UILWPureDisplaySkirmishResultView = require("UI.UISkirmish.ResultPureDisplay.View.UILWPureDisplaySkirmishResultView")
local TabType = {Reward = 1, Stronger = 2}
local victoryBg_path = "Content/VictoryBg"
local victoryTitleText_path = "Content/VictoryBg/VictoryTitleBg/VictoryTitleText"
local normalBg_path = "Content/NormalBg"
local normalTitleText_path = "Content/NormalBg/NormalTitleBg/NormalTitleText"
local curProgressText_path = "Content/TopContent/CurProgressText"
local passNumText_path = "Content/TopContent/PassNumText"
local detailBtn_path = "Content/TopContent/DetailBtn"
local heroTipsText_path = "Content/MiddleContent/HeroTipsText"
local heroContent_path = "Content/MiddleContent/HeroContent"
local rewardBtn_path = "Content/MiddleContent/TabContent/RewardBtn"
local rewardBtnText_path = "Content/MiddleContent/TabContent/RewardBtn/RewardBtnText"
local strongerBtn_path = "Content/MiddleContent/TabContent/StrongerBtn"
local strongerBtnText_path = "Content/MiddleContent/TabContent/StrongerBtn/StrongerBtnText"
local rewardContentBg_path = "Content/MiddleContent/ReawrdContentBg"
local rewardContent_path = "Content/MiddleContent/ReawrdContentBg/RewardScrollView/Viewport/RewardContent"
local returnBtn_path = "ReturnBtn"
local heroObj_path = "BattleEndHeroItemRender"
local returnBtnText_path = "ReturnBtn/ReturnBtnText"
local highlightImage_path = "Content/MiddleContent/TabContent/HighlightImage"
local rewardBtnIcon_path = "Content/MiddleContent/TabContent/RewardBtn/RewardBtnIcon"
local strongerBtnIcon_path = "Content/MiddleContent/TabContent/StrongerBtn/StrongerBtnIcon"
local growGuideScroll_path = "Content/MiddleContent/GrowGuideScroll"

local function OnCreate(self)
  base.OnCreate(self)
  self.quitMidway, self.trailTowerStageId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearHero()
  self:ClearReward()
  self:ClearTabTween()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.victoryBg = self:AddComponent(UIBaseContainer, victoryBg_path)
  self.victoryTitleText = self:AddComponent(UIText, victoryTitleText_path)
  self.normalBg = self:AddComponent(UIBaseContainer, normalBg_path)
  self.normalTitleText = self:AddComponent(UIText, normalTitleText_path)
  self.curProgressText = self:AddComponent(UIText, curProgressText_path)
  self.passNumText = self:AddComponent(UIText, passNumText_path)
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.heroTipsText = self:AddComponent(UIText, heroTipsText_path)
  self.heroContent = self:AddComponent(UIBaseContainer, heroContent_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.rewardBtnText = self:AddComponent(UIText, rewardBtnText_path)
  self.strongerBtn = self:AddComponent(UIButton, strongerBtn_path)
  self.strongerBtnText = self:AddComponent(UIText, strongerBtnText_path)
  self.rewardContentBg = self:AddComponent(UIBaseContainer, rewardContentBg_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.returnBtn = self:AddComponent(UIButton, returnBtn_path)
  self.heroObj = self:AddComponent(UIBaseContainer, heroObj_path)
  self.returnBtnText = self:AddComponent(UIText, returnBtnText_path)
  self.highlightImage = self:AddComponent(UIBaseContainer, highlightImage_path)
  self.rewardBtnIcon = self:AddComponent(UIImage, rewardBtnIcon_path)
  self.strongerBtnIcon = self:AddComponent(UIImage, strongerBtnIcon_path)
  self.growGuideScroll = self:AddComponent(UIBaseContainer, growGuideScroll_path)
  self.growthList = self:AddComponent(UIGrowthList, growGuideScroll_path, self.ctrl, {
    enterType = PVEEnterType.TrailTower,
    notUseZombieBattleManagerExit = true
  })
  self.victoryTitleText:SetLocalText("trialtower_yijian_03")
  self.normalTitleText:SetLocalText("trialtower_yijian_04")
  self.heroTipsText:SetLocalText("trialtower_021")
  self.returnBtnText:SetLocalText("300520")
  self.rewardBtnText:SetLocalText("130065")
  self.strongerBtnText:SetLocalText("800799")
  self.returnBtn:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.detailBtn:SetOnClick(function()
    self:DetailBtnClick()
  end)
  self.rewardBtn:SetOnClick(function()
    self:RewardBtnClick()
  end)
  self.strongerBtn:SetOnClick(function()
    self:StrongerBtnClick()
  end)
  self.heroItemObj = self.transform:Find(heroObj_path).gameObject
  self.heroItemObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.victoryBg = nil
  self.victoryTitleText = nil
  self.normalBg = nil
  self.normalTitleText = nil
  self.curProgressText = nil
  self.passNumText = nil
  self.detailBtn = nil
  self.heroTipsText = nil
  self.heroContent = nil
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.strongerBtn = nil
  self.strongerBtnText = nil
  self.rewardContentBg = nil
  self.rewardContent = nil
  self.returnBtn = nil
  self.heroObj = nil
  self.returnBtnText = nil
  self.highlightImage = nil
  self.rewardBtnIcon = nil
  self.strongerBtnIcon = nil
  self.growGuideScroll = nil
  self.heroItemObj = nil
  self.growthList = nil
end

local function DataDefine(self)
  self.tabIndex = TabType.Reward
  self.tabTween = nil
end

local function DataDestroy(self)
  self.tabIndex = nil
  self.tabTween = nil
end

local function ReInit(self)
  DataCenter.LWTrailTowerManager:SetNeedShowBattleSweepResultStageId(-1, false)
  local isWin = DataCenter.LWTrailTowerManager.battleIsWin
  self.victoryBg:SetActive(isWin)
  self.normalBg:SetActive(not isWin)
  if isWin then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  end
  local stageOrder = LocalController:instance():getValue(TableName.LW_Trail_Tower_Level, self.trailTowerStageId, "level_order")
  local difficulty = LocalController:instance():getValue(TableName.LW_Trail_Tower_Level, self.trailTowerStageId, "level_group")
  local curProgressStr = Localization:GetString("trialtower_yijian_05", difficulty .. "-" .. stageOrder)
  self.curProgressText:SetText(curProgressStr)
  local passNumStr = Localization:GetString("trialtower_yijian_06", DataCenter.LWTrailTowerManager.winNum)
  self.passNumText:SetText(passNumStr)
  self:ShowHero()
  self:RefreshTabShow()
  local rewardCount = table.count(DataCenter.LWTrailTowerManager.battleEndReward)
  if 0 < rewardCount then
    self:RewardBtnClick()
  else
    self:StrongerBtnClick()
  end
end

local function ShowHero(self)
  self.heroItemList = {}
  local heroDic = DataCenter.LWTrailTowerManager.battleEndDisplayHeroDic
  local index = 0
  for heroUuid, heroDisplayData in pairs(heroDic) do
    local itemObj = self.heroItemObj:GameObjectSpawn(self.heroContent.transform)
    index = index + 1
    itemObj.name = "heroItem" .. index
    itemObj:SetActive(true)
    local heroItemRender = self.heroContent:AddComponent(LWUITrailTowerBattleEndHeroItemRender, itemObj.name)
    heroItemRender:SetData(heroDisplayData)
    table.insert(self.heroItemList, heroItemRender)
  end
end

local function ClearHero(self)
  self.heroContent:RemoveComponents(LWUITrailTowerBattleEndHeroItemRender)
  self.heroItemObj:GameObjectRecycleAll()
end

local function ShowReward(self)
  self.rewardContentBg:SetActive(true)
  self.growthList:SetActive(false)
  self.rewardContent:RemoveComponents(UIHeroCellSmall)
  self.rewardContent:RemoveComponents(UICommonResItem)
  self:ClearReward()
  self.rewardReqs = {}
  local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(DataCenter.LWTrailTowerManager.battleEndReward)
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
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(1, 1, 1)
        local cell
        if p.rewardType == RewardType.HERO then
          cell = self.rewardContent:AddComponent(UIHeroCellSmall, go)
          cell:SetData(p.heroUuid)
        else
          cell = self.rewardContent:AddComponent(UICommonResItem, go)
          cell:ReInit(p)
        end
      end)
      table.insert(self.rewardReqs, req)
    end
  end
end

local function ClearReward(self)
  if self.rewardReqs ~= nil then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
    self.rewardReqs = nil
  end
end

local function ShowStronger(self)
  self.rewardContentBg:SetActive(false)
  self.growthList:SetActive(true)
  self.growthList:RefreshView()
  self.growthList:FadeIn()
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

local function ClearTabTween(self)
  if self.tabTween then
    self.tabTween:Kill()
    self.tabTween = nil
  end
end

local function RewardBtnClick(self)
  self.tabIndex = TabType.Reward
  self:RefreshTabShow()
  self:ShowReward()
end

local function StrongerBtnClick(self)
  self.tabIndex = TabType.Stronger
  self:RefreshTabShow()
  self:ShowStronger()
end

local function CloseBtnClick(self)
  self.ctrl:CloseSelf()
end

local function DetailBtnClick(self)
  local message = {}
  if DataCenter.LWTrailTowerManager.content then
    message.content = DataCenter.LWTrailTowerManager.content
  end
  if DataCenter.LWTrailTowerManager.contentsArr then
    message.contentsArr = DataCenter.LWTrailTowerManager.contentsArr
  end
  local mailBattleReport = MailBattleReport.New()
  mailBattleReport:ParseContentForSkirmish(message)
  local panelParam = UILWPureDisplaySkirmishResultView.ParamDataClass.New()
  panelParam.battleData = SkirmishBattleData.New(mailBattleReport)
  panelParam.enterType = PVEEnterType.TrailTower
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPureDisplaySkirmishResult, {anim = false}, panelParam)
end

LWUITrailTowerSweepBattleResultView.OnCreate = OnCreate
LWUITrailTowerSweepBattleResultView.OnDestroy = OnDestroy
LWUITrailTowerSweepBattleResultView.OnEnable = OnEnable
LWUITrailTowerSweepBattleResultView.OnDisable = OnDisable
LWUITrailTowerSweepBattleResultView.ComponentDefine = ComponentDefine
LWUITrailTowerSweepBattleResultView.ComponentDestroy = ComponentDestroy
LWUITrailTowerSweepBattleResultView.DataDefine = DataDefine
LWUITrailTowerSweepBattleResultView.DataDestroy = DataDestroy
LWUITrailTowerSweepBattleResultView.ReInit = ReInit
LWUITrailTowerSweepBattleResultView.ShowHero = ShowHero
LWUITrailTowerSweepBattleResultView.ClearHero = ClearHero
LWUITrailTowerSweepBattleResultView.ShowReward = ShowReward
LWUITrailTowerSweepBattleResultView.ClearReward = ClearReward
LWUITrailTowerSweepBattleResultView.ShowStronger = ShowStronger
LWUITrailTowerSweepBattleResultView.RefreshTabShow = RefreshTabShow
LWUITrailTowerSweepBattleResultView.ClearTabTween = ClearTabTween
LWUITrailTowerSweepBattleResultView.RewardBtnClick = RewardBtnClick
LWUITrailTowerSweepBattleResultView.StrongerBtnClick = StrongerBtnClick
LWUITrailTowerSweepBattleResultView.CloseBtnClick = CloseBtnClick
LWUITrailTowerSweepBattleResultView.DetailBtnClick = DetailBtnClick
return LWUITrailTowerSweepBattleResultView
