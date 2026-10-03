local BountyHunterPhaseItemComponent = BaseClass("BountyHunterPhaseItemComponent", UIBaseContainer)
local BountyHunterRewardItemComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Component.BountyHunterRewardItemComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bounty_hunter_reward_item_path = "BountyHunterRewardItem"
local need_score_text_path = "NeedScoreText"
local separator_img_path = "SeparatorImg"
local eff_point_obj_path = "EffPointObj"
local receive_obj_path = "ReceiveObj"
local click_btn_path = "ClickBtn"

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
  self.rewardItem = self:AddComponent(BountyHunterRewardItemComponent, bounty_hunter_reward_item_path)
  self.needScoreText = self:AddComponent(UIText, need_score_text_path)
  self.separatorImgObj = self:AddComponent(UIBaseContainer, separator_img_path)
  self.battle_pass_effect = self:AddComponent(UIVfx, eff_point_obj_path, UIAssets.BattlePassEffect, {
    lifeType = UIVfxLifeType.Stay
  })
  self.receivedObj = self:AddComponent(UIBaseContainer, receive_obj_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:TryReceiveStageReward()
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.battle_pass_effect = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function BountyHunterPhaseItemComponent:ReInit(params)
  if not params then
    return
  end
  self.activityId = params.activityId
  local rewardData = params.rewardData
  self.needScore = rewardData.needScore
  local isLastIndex = params.isLastIndex
  local isReceived = params.isReceived
  local curScore = params.curScore or 0
  local scoreEnough = curScore >= self.needScore
  local isCanReceiveReward = scoreEnough and not isReceived
  self.rewardItem:ReInit(rewardData)
  self.separatorImgObj:SetActive(not isLastIndex)
  self.needScoreText:SetText(self.needScore)
  self.receivedObj:SetActive(isReceived)
  self:SetEffectState(isCanReceiveReward)
  self.clickBtn:SetActive(isCanReceiveReward)
end

function BountyHunterPhaseItemComponent:SetEffectState(state)
  if state then
    self.battle_pass_effect:SetActive(true)
    self.battle_pass_effect:Replay()
  else
    self.battle_pass_effect:SetActive(false)
  end
end

function BountyHunterPhaseItemComponent:TryReceiveStageReward()
  if not self.activityId then
    Logger.LogError("BountyHunterPhaseItemComponent:TryReceiveStageReward: activityId is nil")
    return
  end
  if not self.needScore then
    Logger.LogError("BountyHunterPhaseItemComponent:TryReceiveStageReward: needScore is nil")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BountyHunterReceivePhaseReward, self.activityId, self.needScore)
end

BountyHunterPhaseItemComponent.OnCreate = OnCreate
BountyHunterPhaseItemComponent.OnDestroy = OnDestroy
BountyHunterPhaseItemComponent.OnEnable = OnEnable
BountyHunterPhaseItemComponent.OnDisable = OnDisable
BountyHunterPhaseItemComponent.ComponentDefine = ComponentDefine
BountyHunterPhaseItemComponent.ComponentDestroy = ComponentDestroy
BountyHunterPhaseItemComponent.DataDefine = DataDefine
BountyHunterPhaseItemComponent.DataDestroy = DataDestroy
BountyHunterPhaseItemComponent.OnAddListener = OnAddListener
BountyHunterPhaseItemComponent.OnRemoveListener = OnRemoveListener
return BountyHunterPhaseItemComponent
