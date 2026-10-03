local ActLotteryDraw100ResultRowItem = BaseClass("ActLotteryDraw100ResultRowItem", UIBaseContainer)
local HeroCardItem = require("UI.UIActLottery.ActLotteryDrawResult.Component.ActLotteryDrawResultItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.heroCardItemList = {}
  for i = 1, 3 do
    local heroCardItem = self:AddComponent(HeroCardItem, string.format("UIHero100RecruitRewardCell%s", i))
    table.insert(self.heroCardItemList, heroCardItem)
  end
end

local function ComponentDestroy(self)
  self.heroCardItemList = nil
end

local function DataDefine(self)
  self.curAniCardItem = nil
  self.nextRowItem = nil
end

local function DataDestroy(self)
  self.curAniCardItem = nil
  self.nextRowItem = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ActLotteryDraw100ResultRowItem:SetData(heroDataList)
  self.heroDataList = heroDataList
  self:RefreshUI()
end

function ActLotteryDraw100ResultRowItem:RefreshUI()
  self.allNeedShowAniList = {}
  local prevCardItem
  for i, v in ipairs(self.heroCardItemList) do
    local cardItem = v
    if self.heroDataList[i] == nil then
      cardItem:SetActive(false)
    else
      cardItem.gameObject:SetActive(true)
      cardItem:SetData(i, self.heroDataList[i], nil, true)
      if not self.curAniCardItem then
        self.curAniCardItem = cardItem
      end
      if prevCardItem then
        prevCardItem.nextCardItem = cardItem
      end
      prevCardItem = cardItem
    end
  end
end

function ActLotteryDraw100ResultRowItem:ExecuteOneAniStep()
  if not self.curAniCardItem then
    return nil
  end
  local needTime, screenPos, isRepeatHeroChip = self.curAniCardItem:PlayShowAni()
  self.curAniCardItem = self.curAniCardItem.nextCardItem
  return needTime, screenPos, isRepeatHeroChip
end

function ActLotteryDraw100ResultRowItem:IsAniAllFinish()
  return self.curAniCardItem == nil
end

function ActLotteryDraw100ResultRowItem:GetAllHeroCardScreenPos()
  local posList = {}
  for _, k in ipairs(self.heroCardItemList) do
    if k.gameObject.activeSelf then
      local cardScreenPos = PosConverse.UIWorldToScreenPos(k.transform.position)
      table.insert(posList, cardScreenPos)
    end
  end
  return posList
end

ActLotteryDraw100ResultRowItem.OnCreate = OnCreate
ActLotteryDraw100ResultRowItem.OnDestroy = OnDestroy
ActLotteryDraw100ResultRowItem.OnEnable = OnEnable
ActLotteryDraw100ResultRowItem.OnDisable = OnDisable
ActLotteryDraw100ResultRowItem.ComponentDefine = ComponentDefine
ActLotteryDraw100ResultRowItem.ComponentDestroy = ComponentDestroy
ActLotteryDraw100ResultRowItem.DataDefine = DataDefine
ActLotteryDraw100ResultRowItem.DataDestroy = DataDestroy
ActLotteryDraw100ResultRowItem.OnAddListener = OnAddListener
ActLotteryDraw100ResultRowItem.OnRemoveListener = OnRemoveListener
return ActLotteryDraw100ResultRowItem
