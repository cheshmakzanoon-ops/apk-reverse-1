local UILWPureDisplaySkirmishResultView = BaseClass("UILWPureDisplaySkirmishResultView", UIBaseView)
local base = UIBaseView
local HeroItem = require("UI.UISkirmish.Result.Component.HeroItem")
local PlayerInfoLine = require("UI.UISkirmish.Result.Component.PlayerInfoLine")
local ParamData = {
  battleData = nil,
  reward = nil,
  enterType = nil
}
UILWPureDisplaySkirmishResultView.ParamDataClass = DataClass("ParamDataClass", ParamData)

function UILWPureDisplaySkirmishResultView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:InitView()
end

function UILWPureDisplaySkirmishResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWPureDisplaySkirmishResultView:DataDefine()
  self.param = self:GetUserData()
  self.topHeroLineReqs = {}
  self.topHeroLines = {}
  self.downHeroLineReqs = {}
  self.downHeroLines = {}
end

function UILWPureDisplaySkirmishResultView:DataDestroy()
  self.param = nil
end

function UILWPureDisplaySkirmishResultView:ComponentDefine()
  self.back_btn = self:AddComponent(UIButton, "SafeArea/BackBtn")
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.AgainBtn = self:AddComponent(UIButton, "SafeArea/AgainBtn")
  self.AgainBtn:SetOnClick(function()
    self:OnAgainBtnClick()
  end)
  self.time = self:AddComponent(UIText, "SafeArea/bottomInfo/timeInfo")
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
end

function UILWPureDisplaySkirmishResultView:ComponentDestroy()
  self.back_btn = nil
  self.AgainBtn = nil
  self.time = nil
  self.timeTxt = nil
  self.enemyInfo = nil
  self.selfInfo = nil
  self.topHeroes = nil
  self.downHeroes = nil
end

function UILWPureDisplaySkirmishResultView:OnAddListener()
  base.OnAddListener(self)
end

function UILWPureDisplaySkirmishResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWPureDisplaySkirmishResultView:OnEnable()
  base.OnEnable(self)
end

function UILWPureDisplaySkirmishResultView:InitView()
  if self.param and self.param.reward then
    DataCenter.RewardManager:ShowCommonReward(self.param)
  end
  local data = self.param.battleData.extData
  local isShowAgainBtn = self:IsShowAgainBtn()
  self.AgainBtn:SetActive(isShowAgainBtn)
  local timeCount = self.param.battleData.fightDuration
  self.timeTxt:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(timeCount))
  self.time:SetActive(true)
  self.enemyInfo:SetData(self.param.battleData.playerData[2], self.param.battleData.topPlayerWin)
  self.selfInfo:SetData(self.param.battleData.playerData[1], not self.param.battleData.topPlayerWin)
  self:RefreshStatistic()
end

function UILWPureDisplaySkirmishResultView:OnAgainBtnClick()
  self.ctrl:CloseSelf()
end

function UILWPureDisplaySkirmishResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
end

function UILWPureDisplaySkirmishResultView:IsShowAgainBtn()
  return false
end

local StatisticLinePath = "Assets/Main/Prefabs/UI/Skirmish/StatisticLine.prefab"
local PRE_TABLE_INDEX = -1

function UILWPureDisplaySkirmishResultView:RefreshStatistic()
  local topHeroData = {}
  local downHeroData = {}
  for i = 1, PVPBattleSlot.SelfHero5 do
    local heroData = self.param.battleData.heroData[i]
    if heroData then
      table.insert(downHeroData, heroData)
    end
  end
  if self.param.battleData.heroData[PVPBattleSlot.SelfDominator] then
    table.insert(downHeroData, self.param.battleData.heroData[PVPBattleSlot.SelfDominator])
  end
  for i = 6, PVPBattleSlot.EnemyHero5 do
    local heroData = self.param.battleData.heroData[i]
    if heroData then
      table.insert(topHeroData, heroData)
    end
  end
  if self.param.battleData.heroData[PVPBattleSlot.EnemyDominator] then
    table.insert(topHeroData, self.param.battleData.heroData[PVPBattleSlot.EnemyDominator])
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
          lineItem:SetData(self.param.battleData, heroData)
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

return UILWPureDisplaySkirmishResultView
