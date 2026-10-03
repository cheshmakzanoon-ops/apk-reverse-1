local BountyHunterRewardStashQueueComponentComponent = BaseClass("BountyHunterRewardStashQueueComponentComponent", UIBaseContainer)
local StashRewardItemComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Component.StashRewardItemComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local stash_reward_item_path = "StashRewardItem"
local reward_item_root_path = "RewardItemRoot"
local LAYOUT_TOP = 30
local LAYOUT_BOTTOM = 30
local LAYOUT_SPACE = 10
local MAX_SHOW_ITEM_COUNT = 4
local POP_ALL_ITEM_TIME = 20
local FLY_TIME = 0.7

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
  if self.updateHeightTween ~= nil then
    self.updateHeightTween:Kill()
    self.updateHeightTween = nil
  end
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

function BountyHunterRewardStashQueueComponentComponent:ReInit(popItemCallback)
  self.popItemCallback = popItemCallback
end

function BountyHunterRewardStashQueueComponentComponent:ClearAllRewardItem()
  for _, v in ipairs(self.curAllStashRewardItemList) do
    v:SetActive(false)
    table.insert(self.rewardItemPool, v)
  end
  self.curAllStashRewardItemList = {}
  self.gameObject:SetActive(false)
end

function BountyHunterRewardStashQueueComponentComponent:PushRewardToQueue(rewardDataList, startWorldPos, playJumpAnim)
  if not rewardDataList then
    return
  end
  if rewardDataList.rewardDataHasBornEffect then
    for _, v in ipairs(rewardDataList.rewardDataHasBornEffect) do
      self:PushOneReward(v, startWorldPos, playJumpAnim, true)
    end
  end
  if rewardDataList.rewardDataNoBornEffect then
    for _, v in ipairs(rewardDataList.rewardDataNoBornEffect) do
      self:PushOneReward(v, startWorldPos, playJumpAnim, false)
    end
  end
end

function BountyHunterRewardStashQueueComponentComponent:PushOneReward(rewardData, startWorldPos, playJumpAnim, showBornEffect)
  self:CheckClearAllItemTimer()
  if self.curAllStashRewardItemList and #self.curAllStashRewardItemList >= MAX_SHOW_ITEM_COUNT then
    self:EnterWaitShowBuffList(rewardData, startWorldPos, playJumpAnim, showBornEffect)
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
  
  local function getTargetWorldPosFunc(targetIndex)
    local localPosY = self:GetTargetPosYByIndex(targetIndex)
    local worldPos = self.rewardItemRoot.transform:TransformPoint(0, localPosY, 0)
    return worldPos
  end
  
  local function finishCallback()
  end
  
  local function startFlyCallback()
    self:UpdateBGHeightByItemCount()
  end
  
  stashRewardItem:ReInit(index, rewardData, self.rectTransform, getTargetWorldPosFunc, finishCallback, startFlyCallback)
  stashRewardItem:DelayPlayFlyAni(startWorldPos, FLY_TIME, 0, playJumpAnim, showBornEffect)
end

function BountyHunterRewardStashQueueComponentComponent:CheckClearAllItemTimer()
  if self.checkClearTimer then
    self.checkClearTimer:Stop()
    self.checkClearTimer = nil
  end
  self.checkClearTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PopCurAllRewardItem()
  end, POP_ALL_ITEM_TIME)
end

function BountyHunterRewardStashQueueComponentComponent:EnterWaitShowBuffList(rewardData, startWorldPos, playJumpAnim, showBornEffect)
  local params = {}
  params.rewardData = rewardData
  params.startWorldPos = startWorldPos
  params.playJumpAnim = playJumpAnim
  params.showBornEffect = showBornEffect
  table.insert(self.waitShowRewardDataList, params)
end

function BountyHunterRewardStashQueueComponentComponent:PopOneRewardFromBuff()
  if not self.waitShowRewardDataList or #self.waitShowRewardDataList <= 0 then
    return
  end
  local rewardParams = self.waitShowRewardDataList[1]
  table.remove(self.waitShowRewardDataList, 1)
  self:PushOneReward(rewardParams.rewardData, rewardParams.startWorldPos, rewardParams.playJumpAnim, rewardParams.showBornEffect)
end

function BountyHunterRewardStashQueueComponentComponent:PopCurAllRewardItem()
  self.isPopAll = true
  self:PopOneReward()
end

function BountyHunterRewardStashQueueComponentComponent:PopOneReward()
  if not self.curAllStashRewardItemList or #self.curAllStashRewardItemList <= 0 then
    return
  end
  local firstRewardItem = self.curAllStashRewardItemList[1]
  table.remove(self.curAllStashRewardItemList, 1)
  firstRewardItem:ShowPopAni(function()
    firstRewardItem:SetActive(false)
    table.insert(self.rewardItemPool, firstRewardItem)
  end, function()
    self:OnPopOneItem()
  end)
end

function BountyHunterRewardStashQueueComponentComponent:OnPopOneItem()
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

function BountyHunterRewardStashQueueComponentComponent:UpdateAllItemIndex()
  if not self.curAllStashRewardItemList then
    return
  end
  for index, v in ipairs(self.curAllStashRewardItemList) do
    v.index = index
  end
end

function BountyHunterRewardStashQueueComponentComponent:UpdateAllItemPos()
  if not self.curAllStashRewardItemList then
    return
  end
  for _, v in ipairs(self.curAllStashRewardItemList) do
    if v:IsInList() then
      self:UpdateItemPos(v, v.index)
    end
  end
end

function BountyHunterRewardStashQueueComponentComponent:UpdateItemPos(item, index)
  local posY = self:GetTargetPosYByIndex(index)
  item.rectTransform:Set_anchoredPosition(0, posY)
end

function BountyHunterRewardStashQueueComponentComponent:GetTargetPosYByIndex(index)
  return LAYOUT_BOTTOM + (index - 1) * (self.itemHeight + LAYOUT_SPACE)
end

function BountyHunterRewardStashQueueComponentComponent:UpdateBGHeightByItemCount()
  if not self.gameObject then
    return
  end
  local itemCount = 0
  if self.curAllStashRewardItemList then
    itemCount = #self.curAllStashRewardItemList
  end
  self.gameObject:SetActive(0 < itemCount)
  if itemCount <= 0 then
    return
  end
  if self.updateHeightTween ~= nil and self.updateHeightTween:IsPlaying() then
    self.updateHeightTween:Kill()
    self.updateHeightTween = nil
  end
  local height = LAYOUT_TOP + LAYOUT_BOTTOM + (itemCount - 1) * LAYOUT_SPACE + itemCount * self.itemHeight
  self.updateHeightTween = self.rectTransform:DOSizeDelta(Vector2.New(self.rectTransform.sizeDelta.x, height), 0.06):SetDelay(0.3):OnComplete(function()
    self.updateHeightTween = nil
  end)
end

BountyHunterRewardStashQueueComponentComponent.OnCreate = OnCreate
BountyHunterRewardStashQueueComponentComponent.OnDestroy = OnDestroy
BountyHunterRewardStashQueueComponentComponent.OnEnable = OnEnable
BountyHunterRewardStashQueueComponentComponent.OnDisable = OnDisable
BountyHunterRewardStashQueueComponentComponent.ComponentDefine = ComponentDefine
BountyHunterRewardStashQueueComponentComponent.ComponentDestroy = ComponentDestroy
BountyHunterRewardStashQueueComponentComponent.DataDefine = DataDefine
BountyHunterRewardStashQueueComponentComponent.DataDestroy = DataDestroy
BountyHunterRewardStashQueueComponentComponent.OnAddListener = OnAddListener
BountyHunterRewardStashQueueComponentComponent.OnRemoveListener = OnRemoveListener
return BountyHunterRewardStashQueueComponentComponent
