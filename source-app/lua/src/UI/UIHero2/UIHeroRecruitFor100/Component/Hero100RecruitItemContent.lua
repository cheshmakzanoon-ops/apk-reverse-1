local Hero100RecruitItemContent = BaseClass("Hero100RecruitItemContent", UIBaseContainer)
local Hero100RecruitResItem = require("UI.UIHero2.UIHeroRecruitFor100.Component.Hero100RecruitResItem")
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
  self.recruitResItemObj = self:AddComponent(UIBaseContainer, "UI100RecruitResItem").gameObject
  self.recruitResItemObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.recruitResItemObj = nil
end

local function DataDefine(self)
  self.allResItemList = {}
  self.curAniIndex = 1
  self.showAniTimer = nil
  self.showItemInterval = 0.05
end

local function DataDestroy(self)
  self.allResItemList = nil
  self.curAniIndex = nil
  self.showAniTimer = nil
  self.showItemInterval = nil
  self.itemDataList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function Hero100RecruitItemContent:SetData(itemDataList, isHeroDraw)
  if self.allResItemList then
    for _, v in ipairs(self.allResItemList) do
      v:ResetData()
    end
  end
  self.curAniIndex = 1
  self.itemDataList = itemDataList
  self.isHeroDraw = isHeroDraw
  for i, v in ipairs(self.itemDataList) do
    local resItem
    if self.allResItemList and i <= #self.allResItemList then
      resItem = self.allResItemList[i]
    else
      local name = "item_" .. i
      local itemObj = self.recruitResItemObj:GameObjectSpawn(self.transform)
      itemObj.name = name
      resItem = self:AddComponent(Hero100RecruitResItem, name)
      table.insert(self.allResItemList, resItem)
    end
    resItem:SetData(v, self.isHeroDraw)
    resItem:SetShowHideState(false)
  end
end

function Hero100RecruitItemContent:InstRewardItem()
  if not self.itemDataList then
    return
  end
  for i, v in ipairs(self.itemDataList) do
    local resItem = self.allResItemList[i]
    if not resItem then
      return
    end
    resItem:SetData(v, self.isHeroDraw)
  end
end

function Hero100RecruitItemContent:ClearAllItem()
  self.recruitResItemObj:GameObjectRecycleAll()
  self:RemoveAllComponentes(Hero100RecruitResItem)
end

function Hero100RecruitItemContent:IsAniAllFinish()
  return self.curAniIndex and self.itemDataList[self.curAniIndex] == nil
end

function Hero100RecruitItemContent:ExecuteOneAniStep()
  if self.curAniIndex > #self.allResItemList or not self.allResItemList[self.curAniIndex] then
    return
  end
  if self.curAniIndex == 1 then
    self:OnAniStartPlay()
  end
  self.allResItemList[self.curAniIndex]:SetShowHideState(true, true)
  local screenPos = PosConverse.UIWorldToScreenPos(self.allResItemList[self.curAniIndex].transform.position)
  self.curAniIndex = self.curAniIndex + 1
  return self.showItemInterval, screenPos
end

function Hero100RecruitItemContent:ShowAllItem()
  if self.allResItemList then
    for _, v in pairs(self.allResItemList) do
      if not v.emptyData then
        v:SetShowHideState(true, false)
      end
    end
  end
end

function Hero100RecruitItemContent:OnAniStartPlay()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Recruit100NormalItemShow)
end

function Hero100RecruitItemContent:StopAllTimer()
  if self.showAniTimer then
    self.showAniTimer:Stop()
    self.showAniTimer = nil
  end
end

Hero100RecruitItemContent.OnCreate = OnCreate
Hero100RecruitItemContent.OnDestroy = OnDestroy
Hero100RecruitItemContent.OnEnable = OnEnable
Hero100RecruitItemContent.OnDisable = OnDisable
Hero100RecruitItemContent.ComponentDefine = ComponentDefine
Hero100RecruitItemContent.ComponentDestroy = ComponentDestroy
Hero100RecruitItemContent.DataDefine = DataDefine
Hero100RecruitItemContent.DataDestroy = DataDestroy
Hero100RecruitItemContent.OnAddListener = OnAddListener
Hero100RecruitItemContent.OnRemoveListener = OnRemoveListener
return Hero100RecruitItemContent
