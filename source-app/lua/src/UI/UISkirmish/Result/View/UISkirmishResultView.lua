local UISkirmishResultView = BaseClass("UISkirmishResultView", UIBaseView)
local base = UIBaseView
local HeroItem = require("UI.UISkirmish.Result.Component.HeroItem")
local PlayerInfoLine = require("UI.UISkirmish.Result.Component.PlayerInfoLine")
local Localization = CS.GameEntry.Localization
local DisplayComponents = {time = "time", rank = "rankChange"}

function UISkirmishResultView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:InitView()
  self:PlayShowSound()
end

function UISkirmishResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISkirmishResultView:DataDefine()
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  self.param = self:GetUserData()
  if self.param and type(self.param) == "table" and self.param.reward then
    DataCenter.RewardManager:ShowCommonReward(self.param)
  end
  self.topHeroLineReqs = {}
  self.topHeroLines = {}
  self.downHeroLineReqs = {}
  self.downHeroLines = {}
end

function UISkirmishResultView:DataDestroy()
  self.logic = nil
end

function UISkirmishResultView:ComponentDefine()
  self.back_btn = self:AddComponent(UIButton, "SafeArea/BackBtn")
  self.back_btn:SetOnClick(function()
    self:OnBtnHome()
  end)
  self.AgainBtn = self:AddComponent(UIButton, "SafeArea/AgainBtn")
  self.AgainBtn:SetOnClick(function()
    self:OnBtnAgain()
  end)
  self.time = self:AddComponent(UIBaseContainer, "SafeArea/bottomInfo/timeInfo")
  self.timeTxt = self:AddComponent(UIText, "SafeArea/bottomInfo/timeInfo/Time")
  self.enemyInfo = self:AddComponent(PlayerInfoLine, "SafeArea/contents/enemy")
  self.selfInfo = self:AddComponent(PlayerInfoLine, "SafeArea/contents/self")
  self.topHeroes = self:AddComponent(UIBaseContainer, "SafeArea/contents/TopHeroes")
  self.downHeroes = self:AddComponent(UIBaseContainer, "SafeArea/contents/DownHeroes")
  self.label1 = self:AddComponent(UIText, "SafeArea/contents/DownHeroes/TableHead/Label1")
  self.label2 = self:AddComponent(UIText, "SafeArea/contents/DownHeroes/TableHead/Label2")
  self.label3 = self:AddComponent(UIText, "SafeArea/contents/DownHeroes/TableHead/Label3")
  self.label4 = self:AddComponent(UIText, "SafeArea/contents/DownHeroes/TableHead/Label4")
  self.label5 = self:AddComponent(UIText, "SafeArea/contents/TopHeroes/TableHead/Label5")
  self.label6 = self:AddComponent(UIText, "SafeArea/contents/TopHeroes/TableHead/Label6")
  self.label7 = self:AddComponent(UIText, "SafeArea/contents/TopHeroes/TableHead/Label7")
  self.label8 = self:AddComponent(UIText, "SafeArea/contents/TopHeroes/TableHead/Label8")
  self.label1:SetLocalText(GameDialogDefine.DEAL_DAMAGE)
  self.label2:SetLocalText(GameDialogDefine.TAKE_DAMAGE)
  self.label3:SetLocalText(GameDialogDefine.ENHANCE)
  self.label4:SetLocalText(GameDialogDefine.WEAKEN)
  self.label5:SetLocalText(GameDialogDefine.DEAL_DAMAGE)
  self.label6:SetLocalText(GameDialogDefine.TAKE_DAMAGE)
  self.label7:SetLocalText(GameDialogDefine.ENHANCE)
  self.label8:SetLocalText(GameDialogDefine.WEAKEN)
  self.rankChange = self:AddComponent(UIText, "SafeArea/bottomInfo/rankChange")
  self.oldRank = self:AddComponent(UIText, "SafeArea/bottomInfo/rankChange/oldRank")
  self.newRank = self:AddComponent(UIText, "SafeArea/bottomInfo/rankChange/newRank")
end

function UISkirmishResultView:ComponentDestroy()
  self.back_btn = nil
  self.AgainBtn = nil
  self.time = nil
  self.timeTxt = nil
  self.topHeroes = nil
  self.downHeroes = nil
  self.timeCount = nil
  self.enemyInfo = nil
  self.selfInfo = nil
  self.rankChange = nil
  self.oldRank = nil
  self.newRank = nil
end

function UISkirmishResultView:OnAddListener()
  base.OnAddListener(self)
end

function UISkirmishResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISkirmishResultView:OnEnable()
  base.OnEnable(self)
end

local StatisticLinePath = "Assets/Main/Prefabs/UI/Skirmish/StatisticLine.prefab"

function UISkirmishResultView:InitView()
  local battleData = self.logic.battleData
  local player1 = battleData.playerData[1]
  local player2 = battleData.playerData[2]
  local isDetect = self:IsDetectBattle()
  self.AgainBtn:SetActive(not isDetect)
  local timeCount = self.logic.battleData.fightDuration
  self.timeTxt:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(timeCount))
  self.time:SetActive(true)
  local selfScoreInfo, enemyScoreInfo
  if self.param and type(self.param) == "table" and self.param.rankChange then
    local rankChange = self.param.rankChange
    self.rankChange:SetActive(true)
    self.oldRank:SetText(Localization:GetString("302043") .. "  " .. rankChange.oldRank)
    self.newRank:SetText(rankChange.curRank)
    local addColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)
    local delColor = Color.New(0.9764705882352941, 0.4392156862745098, 0.4666666666666667, 1)
    local ownerChangeScore = rankChange.ownerNewScore - rankChange.ownerOldScore
    local ownerAddStr = 0 <= ownerChangeScore and "+" .. ownerChangeScore or ownerChangeScore
    local ownerAddColor = 0 <= ownerChangeScore and addColor or delColor
    selfScoreInfo = {
      score = rankChange.ownerNewScore,
      addScore = ownerAddStr,
      addColor = ownerAddColor
    }
    local otherChangeScore = rankChange.otherNewScore - rankChange.otherOldScore
    local otherAddStr = 0 <= otherChangeScore and "+" .. otherChangeScore or otherChangeScore
    local otherAddColor = 0 <= otherChangeScore and addColor or delColor
    enemyScoreInfo = {
      score = rankChange.otherNewScore,
      addScore = otherAddStr,
      addColor = otherAddColor
    }
  else
    self.rankChange:SetActive(false)
  end
  self.enemyInfo:SetData(player2, self.logic.battleData.topPlayerWin, enemyScoreInfo)
  self.selfInfo:SetData(player1, not self.logic.battleData.topPlayerWin, selfScoreInfo)
  self:RefreshStatistic()
end

function UISkirmishResultView:RemoveLines()
  self.topHeroes:RemoveComponents(HeroItem)
  for i = 1, #self.topHeroLineReqs do
    self:GameObjectDestroy(self.topHeroLineReqs[i])
  end
  self.topHeroLineReqs = {}
  self.topHeroLines = {}
  self.downHeroes:RemoveComponents(HeroItem)
  for i = 1, #self.downHeroLineReqs do
    self:GameObjectDestroy(self.downHeroLineReqs[i])
  end
  self.downHeroLineReqs = {}
  self.downHeroLines = {}
end

local PRE_TABLE_INDEX = -1

function UISkirmishResultView:RefreshStatistic()
  local topHeroData = {}
  local downHeroData = {}
  for i = 1, PVPBattleSlot.SelfHero5 do
    local heroData = self.logic.battleData.heroData[i]
    if heroData then
      table.insert(downHeroData, heroData)
    end
  end
  if self.logic.battleData.heroData[PVPBattleSlot.SelfDominator] then
    table.insert(downHeroData, self.logic.battleData.heroData[PVPBattleSlot.SelfDominator])
  end
  for i = 6, PVPBattleSlot.EnemyHero5 do
    local heroData = self.logic.battleData.heroData[i]
    if heroData then
      table.insert(topHeroData, heroData)
    end
  end
  if self.logic.battleData.heroData[PVPBattleSlot.EnemyDominator] then
    table.insert(topHeroData, self.logic.battleData.heroData[PVPBattleSlot.EnemyDominator])
  end
  self.topHeroData = topHeroData
  self.downHeroData = downHeroData
  
  local function SetHeroLines(heroDatas, container, items, reqs, isTop)
    for i = 1, #heroDatas do
      if items and items[i] then
        items[i]:SetActive(true)
        local heroData
        if isTop then
          heroData = self.topHeroData[i]
        else
          heroData = self.downHeroData[i]
        end
        items[i]:SetData(self.battleData, heroData)
      elseif not reqs[i] then
        local lineReq = self:GameObjectInstantiateAsync(StatisticLinePath, function(req)
          local obj = req.gameObject
          if IsNull(obj) then
            return
          end
          local transform = obj.transform
          transform:SetParent(container.transform)
          transform:Set_localScale(1, 1, 1)
          transform:Set_localPosition(Vector3.zero)
          transform:SetSiblingIndex(i + PRE_TABLE_INDEX)
          local name = string.format("TopHeroLine%d", i)
          obj.name = name
          local lineItem = container:AddComponent(HeroItem, obj.name)
          local heroData
          if isTop then
            heroData = self.topHeroData[i]
          else
            heroData = self.downHeroData[i]
          end
          lineItem:SetData(self.logic.battleData, heroData)
          items[i] = lineItem
        end)
        reqs[i] = lineReq
      end
    end
    if items and #items > #heroDatas then
      for i = #heroDatas + 1, #items do
        items[i]:SetActive(false)
      end
    end
  end
  
  SetHeroLines(topHeroData, self.topHeroes, self.topHeroLines, self.topHeroLineReqs, true)
  SetHeroLines(downHeroData, self.downHeroes, self.downHeroLines, self.downHeroLineReqs, false)
end

function UISkirmishResultView:OnBtnAgain()
  self.ctrl:CloseSelf()
  PostEventLog.QuitReplayLog(2)
  DataCenter.LWBattleManager:Restart()
end

function UISkirmishResultView:OnBtnHome()
  self.ctrl:CloseSelf()
  local isDetect = self:IsDetectBattle()
  if not isDetect then
    PostEventLog.QuitReplayLog(1)
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():Exit(true)
end

function UISkirmishResultView:IsDetectBattle()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not logic then
    return false
  end
  local isDetect = false
  if logic.param.enterType == PVEEnterType.Radar or logic.param.enterType == PVEEnterType.TowerupJeepAdventure or logic.param.enterType == PVEEnterType.SeasonTower or logic.param.enterType == PVEEnterType.TruckRob or logic.param.enterType == PVEEnterType.HSRRob or logic.param.enterType == PVEEnterType.PVPArena or logic.param.enterType == PVEEnterType.ActivityArena or logic.param.enterType == PVEEnterType.ActivityArenaV2 or logic.param.enterType == PVEEnterType.NewPeakArena or logic.param.enterType == PVEEnterType.NewGaleArena or logic.param.enterType == PVEEnterType.BeginnerEvent or logic.param.enterType == PVEEnterType.DetectZombieBusTrain then
    isDetect = true
  end
  return isDetect
end

function UISkirmishResultView:PlayShowSound()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curEnterType == PVEEnterType.Radar then
    DataCenter.LWSoundManager:PlaySound(62269, false)
  end
end

return UISkirmishResultView
