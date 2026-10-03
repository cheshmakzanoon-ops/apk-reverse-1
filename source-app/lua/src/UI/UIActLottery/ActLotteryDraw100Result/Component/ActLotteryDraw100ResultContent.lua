local ActLotteryDraw100ResultContent = BaseClass("ActLotteryDraw100ResultContent", UIBaseContainer)
local HeroCardRowItem = require("UI.UIActLottery.ActLotteryDraw100Result.Component.ActLotteryDraw100ResultRowItem")
local row_item_path = "ActLotteryDrawItemsRowItem"
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
  self.rowItemObj = self:AddComponent(UIBaseContainer, row_item_path).gameObject
  self.rowItemObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.rowItemObj = nil
end

local function DataDefine(self)
  self.curAniRowItem = nil
  self.allRowItemList = {}
end

local function DataDestroy(self)
  self.curAniRowItem = nil
  self.allRowItemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ActLotteryDraw100ResultContent:SetData(heroDataList)
  self:ClearAllItem()
  local heroCount = table.count(heroDataList)
  local cardCountPerRow = 3
  local rowItemCount = math.ceil(heroCount / cardCountPerRow)
  local prevRowItem
  for i = 1, rowItemCount do
    local rowHeroList = {}
    local startIndex = 1 + cardCountPerRow * (i - 1)
    for j = startIndex, startIndex + cardCountPerRow do
      if heroDataList[j] then
        table.insert(rowHeroList, heroDataList[j])
      end
    end
    local name = "content_" .. i
    local rowItemObj = self.rowItemObj:GameObjectSpawn(self.transform)
    rowItemObj.name = name
    local rowItem = self:AddComponent(HeroCardRowItem, name)
    rowItem:SetData(rowHeroList)
    table.insert(self.allRowItemList, rowItem)
    if not self.curAniRowItem then
      self.curAniRowItem = rowItem
    end
    if prevRowItem then
      prevRowItem.nextRowItem = rowItem
    end
    prevRowItem = rowItem
  end
end

function ActLotteryDraw100ResultContent:ClearAllItem()
  self.rowItemObj:GameObjectRecycleAll()
  self:RemoveAllComponentes(HeroCardRowItem)
  self.allRowItemList = {}
end

function ActLotteryDraw100ResultContent:ExecuteOneAniStep()
  if self:IsAniAllFinish() then
    return
  end
  local needTime, screenPos, isRepeatHeroChip = self.curAniRowItem:ExecuteOneAniStep()
  if self.curAniRowItem:IsAniAllFinish() then
    self.curAniRowItem = self.curAniRowItem.nextRowItem
  end
  return needTime, screenPos, isRepeatHeroChip
end

function ActLotteryDraw100ResultContent:IsAniAllFinish()
  return self.curAniRowItem == nil
end

function ActLotteryDraw100ResultContent:GetAllHeroCardScreenPos()
  local ret = {}
  for _, j in ipairs(self.allRowItemList) do
    local posList = j:GetAllHeroCardScreenPos()
    for _, k in ipairs(posList) do
      table.insert(ret, k)
    end
  end
  return ret
end

ActLotteryDraw100ResultContent.OnCreate = OnCreate
ActLotteryDraw100ResultContent.OnDestroy = OnDestroy
ActLotteryDraw100ResultContent.OnEnable = OnEnable
ActLotteryDraw100ResultContent.OnDisable = OnDisable
ActLotteryDraw100ResultContent.ComponentDefine = ComponentDefine
ActLotteryDraw100ResultContent.ComponentDestroy = ComponentDestroy
ActLotteryDraw100ResultContent.DataDefine = DataDefine
ActLotteryDraw100ResultContent.DataDestroy = DataDestroy
ActLotteryDraw100ResultContent.OnAddListener = OnAddListener
ActLotteryDraw100ResultContent.OnRemoveListener = OnRemoveListener
return ActLotteryDraw100ResultContent
