local base = UIBaseContainer
local LWUIZoneMobilizationAttackRewardItemRender = BaseClass("LWUIZoneMobilizationAttackRewardItemRender", base)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local desText_path = "DesText"
local rewardScrollView_path = "RewardScrollView"
local receiveRewardBtn_path = "ReceiveRewardBtn"
local receiveRewardBtnText_path = "ReceiveRewardBtn/ReceiveRewardBtnText"
local notAchievedBtn_path = "NotAchievedBtn"
local notAchievedBtnText_path = "NotAchievedBtn/NotAchievedBtnText"
local finishState_path = "FinishState"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveRewardScroll()
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
  self.desText = self:AddComponent(UIText, desText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.receiveRewardBtn = self:AddComponent(UIButton, receiveRewardBtn_path)
  self.receiveRewardBtnText = self:AddComponent(UIText, receiveRewardBtnText_path)
  self.notAchievedBtn = self:AddComponent(UIButton, notAchievedBtn_path)
  self.notAchievedBtnText = self:AddComponent(UIText, notAchievedBtnText_path)
  self.finishState = self:AddComponent(UIBaseContainer, finishState_path)
  self.receiveRewardBtnText:SetLocalText("zone_mobilization_challenge_accept_btn")
  self.receiveRewardBtn:SetOnClick(function()
    self:ReceiveRewardBtnClick()
  end)
  self.notAchievedBtnText:SetLocalText("zone_mobilization_challenge_unfinished_btn")
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.desText = nil
  self.rewardScrollView = nil
  self.receiveRewardBtn = nil
  self.receiveRewardBtnText = nil
  self.notAchievedBtn = nil
  self.notAchievedBtnText = nil
  self.finishState = nil
end

local function DataDefine(self)
  self.rewardData = nil
  self.curDamage = 0
  self.index = 0
end

local function DataDestroy(self)
  self.rewardData = nil
  self.curDamage = nil
  self.index = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReceiveChallengeRewardSuccess, self.OnReceiveRewardSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReceiveChallengeRewardSuccess, self.OnReceiveRewardSuccess)
  base.OnRemoveListener(self)
end

local function OnReceiveRewardSuccess(self, index)
  if index == 0 or self.index == index then
    self:RefreshReceiveRewardState()
  end
end

local function InitData(self, index, data, curDamage)
  self.rewardData = data
  self.curDamage = curDamage
  self.index = index
  self.desText:SetLocalText("zone_mobilization_challenge_damege_desc", self.rewardData.targetValue)
  self:RefreshReceiveRewardState()
  self:RemoveRewardScroll()
  local rewardCount = table.count(self.rewardData.rewardList)
  if 0 < rewardCount then
    self.rewardScrollView:SetTotalCount(rewardCount)
    self.rewardScrollView:RefillCells()
  end
end

local function RefreshReceiveRewardState(self)
  self.finishState:SetActive(self.rewardData.rewarded)
  local isAchieved = self.curDamage >= self.rewardData.targetValue
  self.receiveRewardBtn:SetActive(isAchieved and not self.rewardData.rewarded)
  self.notAchievedBtn:SetActive(not isAchieved)
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(UICommonResItem, itemObj)
  if itemRender ~= nil then
    itemRender:SetLocalScaleXYZ(0.7, 0.7, 0.7)
    itemRender:ReInit(self.rewardData.rewardList[index])
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function RemoveRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(UICommonResItem)
end

local function ReceiveRewardBtnClick(self)
  SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationClaimChallengeReward, self.index)
end

LWUIZoneMobilizationAttackRewardItemRender.OnCreate = OnCreate
LWUIZoneMobilizationAttackRewardItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationAttackRewardItemRender.OnEnable = OnEnable
LWUIZoneMobilizationAttackRewardItemRender.OnDisable = OnDisable
LWUIZoneMobilizationAttackRewardItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationAttackRewardItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationAttackRewardItemRender.DataDefine = DataDefine
LWUIZoneMobilizationAttackRewardItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationAttackRewardItemRender.OnAddListener = OnAddListener
LWUIZoneMobilizationAttackRewardItemRender.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationAttackRewardItemRender.OnReceiveRewardSuccess = OnReceiveRewardSuccess
LWUIZoneMobilizationAttackRewardItemRender.InitData = InitData
LWUIZoneMobilizationAttackRewardItemRender.RefreshReceiveRewardState = RefreshReceiveRewardState
LWUIZoneMobilizationAttackRewardItemRender.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIZoneMobilizationAttackRewardItemRender.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIZoneMobilizationAttackRewardItemRender.RemoveRewardScroll = RemoveRewardScroll
LWUIZoneMobilizationAttackRewardItemRender.ReceiveRewardBtnClick = ReceiveRewardBtnClick
return LWUIZoneMobilizationAttackRewardItemRender
