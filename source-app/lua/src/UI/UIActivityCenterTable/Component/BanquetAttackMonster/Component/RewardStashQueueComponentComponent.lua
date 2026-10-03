local RewardStashQueueComponentComponent = BaseClass("RewardStashQueueComponentComponent", UIBaseContainer)
local StashRewardItemComponent = require("UI.UIActivityCenterTable.Component.BanquetAttackMonster.Component.StashRewardItemComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local stash_reward_item_path = "StashRewardItem"
local reward_item_root_path = "RewardItemRoot"
local LAYOUT_TOP = 15
local LAYOUT_BOTTOM = 30
local LAYOUT_SPACE = 5
local MAX_SHOW_ITEM_COUNT = 5
local POP_ALL_ITEM_TIME = 5

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
  self.rewardItemRoot = self:AddComponent(UIBaseContainer, reward_item_root_path)
  self.stashItem = self:AddComponent(UIBaseContainer, stash_reward_item_path)
  self.stashItem.transform:Set_pivot(0.5, 0)
  self.stashItem:SetAnchorMinXY(0.5, 0)
  self.stashItem:SetAnchorMaxXY(0.5, 0)
  self.stashItem.gameObject:GameObjectCreatePool()
  self.itemWidth = self.stashItem:GetSizeDelta().x or 0
  self.itemHeight = self.stashItem:GetSizeDelta().y or 0
end

local function ComponentDestroy(self)
  self.stashItem.gameObject:GameObjectRecycleAll()
  self.rewardItemRoot:RemoveAllComponentes(StashRewardItemComponent)
end

local function DataDefine(self)
  self.curAllStashRewardItemList = {}
  self.waitShowRewardDataList = {}
  self.rewardItemPool = {}
end

local function DataDestroy(self)
  self.curAllStashRewardItemList = nil
  self.waitShowRewardDataList = nil
  if self.checkClearTimer then
    self.checkClearTimer:Stop()
    self.checkClearTimer = nil
  end
  self.rewardItemPool = nil
  self.popItemCallback = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function RewardStashQueueComponentComponent:ReInit(popItemCallback)
  self.popItemCallback = popItemCallback
end

function RewardStashQueueComponentComponent:ClearAllRewardItem()
  for _, v in ipairs(self.curAllStashRewardItemList) do
    v:SetActive(false)
    table.insert(self.rewardItemPool, v)
  end
  self.curAllStashRewardItemList = {}
  self.gameObject:SetActive(false)
end

function RewardStashQueueComponentComponent:PushRewardToQueue(rewardDataList)
  if not rewardDataList then
    return
  end
  self.isPopAll = false
  for _, v in ipairs(rewardDataList) do
    self:PushOneReward(v)
  end
end

function RewardStashQueueComponentComponent:PushOneReward(rewardData)
  if self.curAllStashRewardItemList and #self.curAllStashRewardItemList >= MAX_SHOW_ITEM_COUNT then
    self:EnterWaitShowBuffList(rewardData)
    self:PopOneReward()
    return
  end
  local stashRewardItem
  if #self.rewardItemPool <= 0 then
    local gameObject = self.stashItem.gameObject:GameObjectSpawn(self.rewardItemRoot.transform)
    local name = tostring(NameCount)
    NameCount = NameCount + 1
    gameObject.name = name
    stashRewardItem = self.rewardItemRoot:AddComponent(StashRewardItemComponent, name)
  else
    stashRewardItem = self.rewardItemPool[1]
    stashRewardItem:SetActive(true)
    table.remove(self.rewardItemPool, 1)
  end
  table.insert(self.curAllStashRewardItemList, stashRewardItem)
  local index = #self.curAllStashRewardItemList
  stashRewardItem:ReInit(index, rewardData)
  self:UpdateItemPos(stashRewardItem, index)
  self:UpdateBGHeightByItemCount()
  self:CheckClearAllItemTimer()
end

function RewardStashQueueComponentComponent:CheckClearAllItemTimer()
  if self.checkClearTimer then
    self.checkClearTimer:Stop()
    self.checkClearTimer = nil
  end
  self.checkClearTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PopCurAllRewardItem()
  end, POP_ALL_ITEM_TIME)
end

function RewardStashQueueComponentComponent:EnterWaitShowBuffList(rewardData, startScreenPos)
  local params = {}
  params.rewardData = rewardData
  params.startScreenPos = startScreenPos
  table.insert(self.waitShowRewardDataList, params)
end

function RewardStashQueueComponentComponent:PopOneRewardFromBuff()
  if not self.waitShowRewardDataList or #self.waitShowRewardDataList <= 0 then
    return
  end
  local rewardParams = self.waitShowRewardDataList[1]
  table.remove(self.waitShowRewardDataList, 1)
  self:PushOneReward(rewardParams.rewardData, rewardParams.startScreenPos)
end

function RewardStashQueueComponentComponent:PopCurAllRewardItem()
  self.isPopAll = true
  self:PopOneReward()
end

function RewardStashQueueComponentComponent:PopOneReward()
  if not self.curAllStashRewardItemList or #self.curAllStashRewardItemList <= 0 then
    return
  end
  local firstRewardItem = self.curAllStashRewardItemList[1]
  if self.isPopAll then
    firstRewardItem:ShowPopAni(function()
      table.remove(self.curAllStashRewardItemList, 1)
      firstRewardItem:SetActive(false)
      table.insert(self.rewardItemPool, firstRewardItem)
      self:OnPopOneItem()
    end)
  else
    firstRewardItem:KillHideTimer()
    table.remove(self.curAllStashRewardItemList, 1)
    firstRewardItem:SetActive(false)
    table.insert(self.rewardItemPool, firstRewardItem)
    self:OnPopOneItem()
  end
end

function RewardStashQueueComponentComponent:OnPopOneItem()
  self:UpdateBGHeightByItemCount()
  self:PopOneRewardFromBuff()
  if self.isPopAll then
    self:PopOneReward()
  end
  self:UpdateAllItemIndex()
  self:UpdateAllItemPos()
  if self.isPopAll and #self.curAllStashRewardItemList <= 0 and 0 >= #self.waitShowRewardDataList then
    self.isPopAll = false
  end
  if self.popItemCallback then
    self.popItemCallback()
  end
end

function RewardStashQueueComponentComponent:UpdateAllItemIndex()
  if not self.curAllStashRewardItemList then
    return
  end
  for index, v in ipairs(self.curAllStashRewardItemList) do
    v.index = index
  end
end

function RewardStashQueueComponentComponent:UpdateAllItemPos()
  if not self.curAllStashRewardItemList then
    return
  end
  for _, v in ipairs(self.curAllStashRewardItemList) do
    self:UpdateItemPos(v, v.index)
  end
end

function RewardStashQueueComponentComponent:UpdateItemPos(item, index)
  local posY = self:GetTargetPosYByIndex(index)
  item.rectTransform:Set_anchoredPosition(0, posY)
end

function RewardStashQueueComponentComponent:GetTargetPosYByIndex(index)
  return LAYOUT_BOTTOM + (index - 1) * (self.itemHeight + LAYOUT_SPACE)
end

function RewardStashQueueComponentComponent:UpdateBGHeightByItemCount()
  local itemCount = 0
  if self.curAllStashRewardItemList then
    itemCount = #self.curAllStashRewardItemList
  end
  self.gameObject:SetActive(0 < itemCount)
  if itemCount <= 0 then
    return
  end
  local height = LAYOUT_TOP + LAYOUT_BOTTOM + (itemCount - 1) * LAYOUT_SPACE + itemCount * self.itemHeight
  local width = self.rectTransform.sizeDelta.x
  self.rectTransform.sizeDelta = Vector2(width, height)
end

function RewardStashQueueComponentComponent:GetMaxTargetHeight()
  return #self.curAllStashRewardItemList * (self.itemHeight + LAYOUT_SPACE)
end

RewardStashQueueComponentComponent.OnCreate = OnCreate
RewardStashQueueComponentComponent.OnDestroy = OnDestroy
RewardStashQueueComponentComponent.OnEnable = OnEnable
RewardStashQueueComponentComponent.OnDisable = OnDisable
RewardStashQueueComponentComponent.ComponentDefine = ComponentDefine
RewardStashQueueComponentComponent.ComponentDestroy = ComponentDestroy
RewardStashQueueComponentComponent.DataDefine = DataDefine
RewardStashQueueComponentComponent.DataDestroy = DataDestroy
RewardStashQueueComponentComponent.OnAddListener = OnAddListener
RewardStashQueueComponentComponent.OnRemoveListener = OnRemoveListener
return RewardStashQueueComponentComponent
