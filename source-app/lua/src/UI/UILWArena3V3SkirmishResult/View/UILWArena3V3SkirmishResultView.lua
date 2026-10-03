local UILWArena3V3SkirmishResultView = BaseClass("UILWArena3V3SkirmishResultView", UIBaseView)
local base = UIBaseView
local HeroItem = require("UI.UISkirmish.Result.Component.HeroItem")
local SkirmishBattleData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishBattleData")
local MailBattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")
local PlayerInfoLine = require("UI.UISkirmish.Result.Component.PlayerInfoLine")
local UIGray = CS.UIGray

function UILWArena3V3SkirmishResultView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self.mailUuids = self:GetUserData()
  for k, v in pairs(self.mailUuids) do
    local mailData = DataCenter.MailDataManager:GetMailInfoById(v)
    if mailData then
      local ext = mailData:GetMailExt()
      self.mailBattleDetails[k] = ext
    end
  end
  self:GotoPage(1)
end

function UILWArena3V3SkirmishResultView:OnDestroy()
  BattleReportUtil.Cancel()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWArena3V3SkirmishResultView:DataDefine()
  self.mailBattleDetails = {}
  self.topHeroLineReqs = {}
  self.topHeroLines = {}
  self.downHeroLineReqs = {}
  self.downHeroLines = {}
end

function UILWArena3V3SkirmishResultView:DataDestroy()
  self.mailBattleDetails = nil
  self.heroData = nil
  self.battleData = nil
end

function UILWArena3V3SkirmishResultView:ComponentDefine()
  self.back_btn = self:AddComponent(UIButton, "SafeArea/BackBtn")
  self.back_btn:SetOnClick(function()
    self:OnBtnHome()
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
  self.roundIcon = self:AddComponent(UIImage, "SafeArea/bottomInfo/RoundIcon")
  self.nextRoundBtn = self:AddComponent(UIButton, "SafeArea/NextRoundBtn")
  self.nextRoundBtn:SetActive(false)
  self.nextRoundBtn:SetOnClick(function()
    self:GotoPage(self.curIndex + 1)
  end)
  self.prevRoundBtn = self:AddComponent(UIButton, "SafeArea/PrevRoundBtn")
  self.prevRoundBtn:SetActive(false)
  self.prevRoundBtn:SetOnClick(function()
    self:GotoPage(self.curIndex - 1)
  end)
end

function UILWArena3V3SkirmishResultView:ComponentDestroy()
  self.back_btn = nil
  self.time = nil
  self.timeTxt = nil
  self.topHeroes = nil
  self.downHeroes = nil
  self.timeCount = nil
  self.enemyInfo = nil
  self.selfInfo = nil
end

function UILWArena3V3SkirmishResultView:OnAddListener()
  base.OnAddListener(self)
end

function UILWArena3V3SkirmishResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWArena3V3SkirmishResultView:OnEnable()
  base.OnEnable(self)
end

function UILWArena3V3SkirmishResultView:RequestBattleDetail(index)
end

function UILWArena3V3SkirmishResultView:GotoPage(index)
  local battleData = self.mailBattleDetails[index]
  if battleData then
    self:InitView(battleData, index)
  end
end

function UILWArena3V3SkirmishResultView:InitView(battleData, index)
  if not battleData then
    return
  end
  local data = battleData
  local timeCount = battleData.totalTime / 1000
  self.timeTxt:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(timeCount))
  self.time:SetActive(true)
  local selfPlayerInfo, enemyPlayerInfo
  if battleData.isAttack then
    selfPlayerInfo = data.player[1]
    enemyPlayerInfo = data.player[2]
  else
    selfPlayerInfo = data.player[2]
    enemyPlayerInfo = data.player[1]
  end
  local topPlayerWin = not battleData.topPlayerWin
  self.enemyInfo:SetData(enemyPlayerInfo, not data.selfWin)
  self.selfInfo:SetData(selfPlayerInfo, data.selfWin)
  local heroData = {}
  for _, v in pairs(battleData.hero) do
    if battleData.isDefend then
      heroData[SkirmishBattleData.Swap(v.index)] = v
    else
      heroData[v.index] = v
    end
  end
  self.heroData = heroData
  self.battleData = battleData
  self:RefreshStatistic()
  self.roundIcon:LoadSprite(string.format("Assets/Main/Sprites/UI/LWPVPArena/zyf_3v3jingjichang_round%d.png", index))
  self.roundIcon:SetNativeSize()
  local x, y = self.roundIcon:GetSizeDeltaXY()
  self.roundIcon:SetSizeDeltaXY(x * 0.8, y * 0.8)
  self.roundIcon:SetActive(true)
  self.nextRoundBtn:SetActive(index < #self.mailUuids)
  self.prevRoundBtn:SetActive(1 < index)
  self.curIndex = index
end

function UILWArena3V3SkirmishResultView:OnBtnHome()
  self.ctrl:CloseSelf()
end

function UILWArena3V3SkirmishResultView:RemoveLines()
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

local StatisticLinePath = "Assets/Main/Prefabs/UI/Skirmish/StatisticLine.prefab"
local PRE_TABLE_INDEX = -1

function UILWArena3V3SkirmishResultView:RefreshStatistic()
  local topHeroData = {}
  local downHeroData = {}
  for i = 1, PVPBattleSlot.SelfHero5 do
    local heroData = self.heroData[i]
    if heroData then
      table.insert(downHeroData, heroData)
    end
  end
  if self.heroData[PVPBattleSlot.SelfDominator] then
    table.insert(downHeroData, self.heroData[PVPBattleSlot.SelfDominator])
  end
  for i = 6, PVPBattleSlot.EnemyHero5 do
    local heroData = self.heroData[i]
    if heroData then
      table.insert(topHeroData, heroData)
    end
  end
  if self.heroData[PVPBattleSlot.EnemyDominator] then
    table.insert(topHeroData, self.heroData[PVPBattleSlot.EnemyDominator])
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
          lineItem:SetData(self.battleData, heroData)
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

return UILWArena3V3SkirmishResultView
