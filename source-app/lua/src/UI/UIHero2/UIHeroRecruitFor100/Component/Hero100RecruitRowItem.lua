local Hero100RecruitRowItem = BaseClass("Hero100RecruitRowItem", UIBaseContainer)
local HeroCardItem = require("UI.UIHero2.UIHeroRecruitFor100.Component.Hero100RecruitHeroCard")
local HERO_CARD_ITEM_PATH = "Assets/Main/Prefabs/UI/UIHero/New/UIHero100RecruitRewardCell.prefab"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local MAX_CARD_COUNT_PRE_ROW = 3

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
end

local function ComponentDestroy(self)
  self:ClearAllCardItem()
  self.heroCardItemList = nil
  self.allReqCardItemList = nil
  self.existCardItemList = nil
end

local function DataDefine(self)
  self.curAniCardItem = nil
  self.nextRowItem = nil
  self.allReqCardItemList = {}
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

function Hero100RecruitRowItem:SetData(heroDataList, isHeroDraw, loadFinishCallback)
  self.heroDataList = heroDataList
  self.loadFinishCallback = loadFinishCallback
  self.isHeroDraw = isHeroDraw
  self:ClearAllUnDoneReq()
  self:StartGenCardItem()
end

function Hero100RecruitRowItem:StartGenCardItem()
  if not self:IsAllCardLoadFinish() then
    self:GenerateCardItem()
    return
  end
  self:OnAllCardLoadFinish()
end

function Hero100RecruitRowItem:OnAllCardLoadFinish()
  self:RefreshUI()
  if self.loadFinishCallback then
    self.loadFinishCallback()
  end
end

function Hero100RecruitRowItem:GenerateCardItem()
  for index, v in ipairs(self.heroDataList) do
    local cardItem = self.heroCardItemList[index]
    if not cardItem then
      local loadCardReq = self:GameObjectInstantiateAsync(HERO_CARD_ITEM_PATH, function(request)
        if request.isError then
          return
        end
        local gameObject = request.gameObject
        gameObject.transform:SetParent(self.transform)
        gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local cardName = string.format("UIHero100RecruitRewardCell%s", index)
        gameObject.name = cardName
        cardItem = self:AddComponent(HeroCardItem, cardName)
        self.heroCardItemList[index] = cardItem
        if self:IsAllCardLoadFinish() then
          self:OnAllCardLoadFinish()
        end
      end)
      table.insert(self.allReqCardItemList, loadCardReq)
    end
  end
end

function Hero100RecruitRowItem:RefreshUI()
  local prevCardItem
  for i, v in ipairs(self.heroCardItemList) do
    local cardItem = v
    if self.heroDataList[i] == nil then
      cardItem:SetActive(false)
    else
      cardItem.gameObject:SetActive(true)
      cardItem:SetData(self.heroDataList[i], self.isHeroDraw)
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

function Hero100RecruitRowItem:ExecuteOneAniStep()
  if not self:IsAllCardLoadFinish() then
    function self.loadFinishCallback()
      EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, true)
    end
    
    self:GenerateCardItem()
    return nil
  end
  if not self.curAniCardItem then
    return nil
  end
  local needTime, screenPos, isRepeatHeroChip = self.curAniCardItem:PlayShowAni()
  self.curAniCardItem:SetIsFlippedState(true)
  self.curAniCardItem = self.curAniCardItem.nextCardItem
  return needTime, screenPos, isRepeatHeroChip
end

function Hero100RecruitRowItem:IsAniAllFinish()
  return self.curAniCardItem == nil
end

function Hero100RecruitRowItem:GetAllHeroCardScreenPos()
  local posList = {}
  for _, k in ipairs(self.heroCardItemList) do
    if k.gameObject.activeSelf then
      local cardScreenPos = PosConverse.UIWorldToScreenPos(k.transform.position)
      table.insert(posList, cardScreenPos)
    end
  end
  return posList
end

function Hero100RecruitRowItem:ResetState()
  self.curAniCardItem = nil
  self.nextRowItem = nil
  if not IsNull(self.gameObject) then
    self:SetActive(false)
  end
  self:ClearAllUnDoneReq()
  self:ResetRowCardsState()
end

function Hero100RecruitRowItem:ResetRowCardsState()
  for i, v in ipairs(self.heroCardItemList) do
    local cardItem = v
    cardItem:SetActive(false)
    cardItem:ClearAllDynamicEff()
  end
end

function Hero100RecruitRowItem:IsAllCardLoadFinish()
  return #self.heroCardItemList >= #self.heroDataList
end

function Hero100RecruitRowItem:ClearAllCardItem()
  self.heroCardItemList = {}
  if self.allReqCardItemList then
    for _, v in ipairs(self.allReqCardItemList) do
      self:GameObjectDestroy(v)
    end
    self.allReqCardItemList = {}
  end
end

function Hero100RecruitRowItem:ClearAllUnDoneReq()
  if not self.allReqCardItemList then
    return
  end
  for _, v in ipairs(self.allReqCardItemList) do
    if not v.isDone then
      self:GameObjectDestroy(v)
    end
  end
end

function Hero100RecruitRowItem:ShowCardFlyEff()
  if not self:IsAllCardLoadFinish() then
    return
  end
  for i = 1, #self.heroDataList do
    self.heroCardItemList[i]:ShowCardFlyEff()
  end
end

function Hero100RecruitRowItem:SetScriptName(name)
  self.scriptName = name
end

function Hero100RecruitRowItem:GetScriptName()
  return self.scriptName
end

Hero100RecruitRowItem.OnCreate = OnCreate
Hero100RecruitRowItem.OnDestroy = OnDestroy
Hero100RecruitRowItem.OnEnable = OnEnable
Hero100RecruitRowItem.OnDisable = OnDisable
Hero100RecruitRowItem.ComponentDefine = ComponentDefine
Hero100RecruitRowItem.ComponentDestroy = ComponentDestroy
Hero100RecruitRowItem.DataDefine = DataDefine
Hero100RecruitRowItem.DataDestroy = DataDestroy
Hero100RecruitRowItem.OnAddListener = OnAddListener
Hero100RecruitRowItem.OnRemoveListener = OnRemoveListener
return Hero100RecruitRowItem
