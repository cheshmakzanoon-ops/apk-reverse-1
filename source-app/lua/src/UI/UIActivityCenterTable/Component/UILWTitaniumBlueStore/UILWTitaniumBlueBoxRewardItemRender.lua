local UILWTitaniumBlueBoxRewardItemRender = BaseClass("UILWTitaniumBlueBoxRewardItemRender", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local receive_reward_btn_path = "ReceiveRewardBtn"
local ui_common_res_item_path = "UICommonResItem"
local count_text_path = "CountText"
local effect_go_path = "EffectGo"

function UILWTitaniumBlueBoxRewardItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWTitaniumBlueBoxRewardItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTitaniumBlueBoxRewardItemRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshTitaniumBlueBoxRewardData, self.RefreshState)
  self:AddUIListener(EventId.RefreshTitaniumBlueTotalScoreData, self.OnRefreshTotalScoreChange)
end

function UILWTitaniumBlueBoxRewardItemRender:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshTitaniumBlueBoxRewardData, self.RefreshState)
  self:RemoveUIListener(EventId.RefreshTitaniumBlueTotalScoreData, self.OnRefreshTotalScoreChange)
  base.OnRemoveListener(self)
end

function UILWTitaniumBlueBoxRewardItemRender:ComponentDefine()
  self.receive_reward_btn = self:AddComponent(UIButton, receive_reward_btn_path)
  self.receive_reward_btn:SetOnClick(function()
    self:ReceiveBtnClick()
  end)
  self.ui_common_res_item = self:AddComponent(UICommonResItem, ui_common_res_item_path)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.effect_go = self:AddComponent(UIBaseContainer, effect_go_path)
end

function UILWTitaniumBlueBoxRewardItemRender:ComponentDestroy()
  self.receive_reward_btn = nil
  self.ui_common_res_item = nil
  self.count_text = nil
  self.effect_go = nil
end

function UILWTitaniumBlueBoxRewardItemRender:RefreshState(targetIndex)
  if self.boxRewardData.index == targetIndex then
    self:SetState()
  end
end

function UILWTitaniumBlueBoxRewardItemRender:OnRefreshTotalScoreChange(addScore)
  self:SetState()
end

function UILWTitaniumBlueBoxRewardItemRender:SetData(activityId, boxRewardData)
  self.activityId = activityId
  self.boxRewardData = boxRewardData
  self.count_text:SetText(self.boxRewardData.targetCount)
  if table.IsNullOrEmpty(self.boxRewardData.rewardsList) then
    self.ui_common_res_item:SetActive(false)
    Logger.LogError("\233\146\155\232\147\157\229\149\134\229\186\151\239\188\140\229\174\157\231\174\177index\228\184\186: " .. tostring(self.boxRewardData.index) .. " \231\154\132\229\165\150\229\138\177\228\184\186\231\169\186")
  else
    self.ui_common_res_item:SetActive(true)
    self.ui_common_res_item:ReInit(self.boxRewardData.rewardsList[1])
  end
  self:SetState()
end

function UILWTitaniumBlueBoxRewardItemRender:SetState()
  self.state = DataCenter.LWTitaniumBlueStoreManager:GetBoxRewardState(self.boxRewardData.index)
  self.effect_go:SetActive(self.state == TitaniumBlueBoxRewardState.CanReceive)
  self.receive_reward_btn:SetActive(self.state == TitaniumBlueBoxRewardState.CanReceive)
  local showGray = self.state == TitaniumBlueBoxRewardState.Received
  UIGray.SetGray(self.ui_common_res_item.transform, showGray, true)
end

function UILWTitaniumBlueBoxRewardItemRender:ReceiveBtnClick()
  SFSNetwork.SendMessage(MsgDefines.BlueShopBoxReward, self.activityId, self.boxRewardData.index)
  self.receive_reward_btn:SetActive(false)
end

return UILWTitaniumBlueBoxRewardItemRender
