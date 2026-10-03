local UIActValentineBoxProbabilityView = BaseClass("UIActValentineBoxProbabilityView", UIBaseView)
local UIActValentineBoxProbabilityItem = require("UI.LWUIActValentineBoxProbability.Component.UIActValentineBoxProbabilityItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local panel_path = "panel"
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = UIActValentineBoxProbabilityView
local empty_reward_tip_text_path = "Root/RewardGained/EmptyRewardTipText"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:ReInit()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll = self:AddComponent(UILoopListView2, "Root/ScrollRect")
  self.scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content")
  self.rewardGainedScrollRect = self:AddComponent(UILoopListView2, "Root/RewardGained/RewardGainedScrollRect")
  self.rewardGainedScrollRect:InitListView(0, function(loopView, index)
    return self:OnGetRewardGainedItemByIndex(loopView, index)
  end)
  self.rewardGainedContent = self:AddComponent(UIBaseContainer, "Root/RewardGained/RewardGainedScrollRect/Viewport/RewardGainedContent")
  self.rewardGainedText = self:AddComponent(UIText, "Root/RewardGained/RewardGainedText")
  self.emptyStackRewardTipTextObj = self:AddComponent(UIBaseComponent, empty_reward_tip_text_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "Root/CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.commonActivityPopUpBgPart:SetTitle("activity_99136_45")
end

function M:ClearScroll()
  self.content:RemoveComponents(UIActValentineBoxProbabilityItem)
  self.rewardGainedContent:RemoveComponents(UICommonResItem)
  self.scroll:ClearAllItems()
  self.rewardGainedScrollRect:ClearAllItems()
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.probabilityData then
    return nil
  end
  local packData = self.probabilityData[index]
  local item = loopScroll:NewListViewItem("ItemContent")
  local script = self.content:GetComponent(item.gameObject.name, UIActValentineBoxProbabilityItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(UIActValentineBoxProbabilityItem, objectName)
  end
  script:SetActive(true)
  script:SetData(packData, self.actId)
  return item
end

function M:OnGetRewardGainedItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.gainedRewardList then
    return nil
  end
  local item = loopScroll:NewListViewItem("ResItem")
  local script = self.rewardGainedContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(self.gainRewardItemIndex)
    self.gainRewardItemIndex = self.gainRewardItemIndex + 1
    item.gameObject.name = objectName
    script = self.rewardGainedContent:AddComponent(UICommonResItem, objectName)
  end
  local rewardData = self.gainedRewardList[index]
  script:SetActive(true)
  local param = {}
  param.itemId = rewardData.value.id
  param.count = rewardData.value.num
  param.rewardType = rewardData.type
  item.transform:Set_localScale(0.8, 0.8, 1)
  script:ReInit(param)
  return item
end

function M:ComponentDestroy()
  self.panel = nil
  self.scroll = nil
  self.content = nil
  self.rewardGainedScrollRect = nil
  self.rewardGainedContent = nil
  self.rewardGainedText = nil
end

function M:DataDefine()
  self.probabilityData = {}
  self.activityId = 0
  self.itemIndex = 0
  self.gainRewardItemIndex = 0
  self.gainedRewardList = {}
end

function M:DataDestroy()
  self.probabilityData = nil
  self.activityId = nil
  self.itemIndex = nil
  self.gainRewardItemIndex = nil
  self.gainedRewardList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnBtnLWCloseClick()
  self.ctrl.CloseSelf()
end

function M:ReInit()
  self.rewardGainedText:SetLocalText("activity_99136_47")
  local receiveData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  if not receiveData then
    return
  end
  self.probabilityData = receiveData:GetBoxProbabilityData()
  self.gainedRewardList = receiveData:GetTotalReward()
  self:RefreshUI()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
end

function M:RefreshUI()
  self:RefreshScroll()
  self:RefreshRewardGainedScrollRect()
end

function M:RefreshScroll()
  if self.probabilityData == nil or #self.probabilityData == 0 then
    self.scroll:SetActive(false)
  else
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.probabilityData, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

function M:RefreshRewardGainedScrollRect()
  if self.gainedRewardList == nil or #self.gainedRewardList == 0 then
    self.rewardGainedScrollRect:SetActive(false)
    self.emptyStackRewardTipTextObj:SetActive(true)
  else
    self.rewardGainedScrollRect:SetActive(true)
    self.rewardGainedScrollRect:SetListItemCount(#self.gainedRewardList, false, false)
    self.rewardGainedScrollRect:RefreshAllShownItem()
    self.emptyStackRewardTipTextObj:SetActive(false)
  end
end

return UIActValentineBoxProbabilityView
