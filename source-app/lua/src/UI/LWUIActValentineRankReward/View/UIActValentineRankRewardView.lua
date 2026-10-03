local UIActValentineRankRewardView = BaseClass("UIActValentineRankRewardView", UIBaseView)
local M = UIActValentineRankRewardView
local UIActValentineRankRewardItem = require("UI.LWUIActValentineRankReward.Component.UIActValentineRankRewardItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local reward_text_path = "Root/RewardText"
local reward_scroll_path = "Root/ScrollRect"
local reward_scroll_Content_path = "Root/ScrollRect/Viewport/Content"
local next_level_reward_text_path = "Root/NextLevelReward/NextLevelRewardText"
local next_level_reward_content_path = "Root/NextLevelReward/NextLevelRewardContent"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:ClearRewards()
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
  self.rewardScroll = self:AddComponent(UILoopListView2, reward_scroll_path)
  self.rewardScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, reward_scroll_Content_path)
  self.nextRewardText = self:AddComponent(UIText, next_level_reward_text_path)
  self.nextRewardContent = self:AddComponent(UIBaseContainer, next_level_reward_content_path)
  self.rewardText = self:AddComponent(UIText, reward_text_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "Root/CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.commonActivityPopUpBgPart:SetTitle("activity_99136_48")
end

function M:ComponentDestroy()
  self.panel = nil
  self.rewardScroll = nil
  self.rewardScrollContent = nil
  self.nextRewardText = nil
  self.nextRewardContent = nil
  self.rewardText = nil
end

function M:DataDefine()
  self.rewardList = {}
  self.itemIndex = 0
  self.activityId = 0
end

function M:DataDestroy()
  self.rewardList = nil
  self.itemIndex = nil
  self.activityId = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:InitView()
  self.rewardText:SetLocalText("activity_99136_49")
  self.nextRewardText:SetLocalText("activity_99136_50")
  self:RefreshScroll()
  self:SetNextLevelReward()
  self.commonActivityPopUpBgPart:InitByActivityId(self.activityId)
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardList then
    return nil
  end
  local rewardData = self.rewardList[index]
  local item = loopScroll:NewListViewItem("ItemContent")
  local script = self.rewardScrollContent:GetComponent(item.gameObject.name, UIActValentineRankRewardItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.rewardScrollContent:AddComponent(UIActValentineRankRewardItem, objectName)
  end
  script:SetActive(true)
  script:SetData(rewardData, self.activityId)
  return item
end

function M:RefreshScroll()
  local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  if not rData then
    return
  end
  self.rewardList = rData:GetRankReward()
  if self.rewardScroll == nil or #self.rewardList == 0 then
    self.rewardScroll:SetActive(false)
  else
    self.rewardScroll:SetActive(true)
    self.rewardScroll:SetListItemCount(#self.rewardList, false, false)
    self.rewardScroll:RefreshAllShownItem()
  end
end

function M:ClearScroll()
  self.rewardScrollContent:RemoveComponents(UIActValentineRankRewardItem)
  self.rewardScroll:ClearAllItems()
end

function M:SetNextLevelReward()
  local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  if not rData then
    return
  end
  local nextLevelReward = rData:GetNextLevelReward()
  self:InitNextReward(nextLevelReward)
end

function M:ClearRewards()
  self.nextRewardContent:RemoveComponents(UICommonResItem)
  if self.rewardItemList then
    for _, req in ipairs(self.rewardItemList) do
      self:GameObjectDestroy(req)
    end
  end
  self.rewardItemList = {}
end

function M:InitNextReward(nextLevelReward)
  self:ClearRewards()
  if not nextLevelReward or type(nextLevelReward) ~= "table" or table.length(nextLevelReward) == 0 then
    self.nextRewardContent:SetActive(false)
    return
  end
  for i, item in ipairs(nextLevelReward) do
    local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req == nil then
        return
      end
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local rewardName = "item_" .. i
      obj.name = rewardName
      obj:SetActive(true)
      obj.transform:SetParent(self.nextRewardContent.transform)
      obj.transform:Set_localScale(0.7, 0.7, 1)
      obj.transform:Set_sizeDelta(97, 102)
      obj.transform:Set_pivot(0, 1)
      local cell = self.nextRewardContent:AddComponent(UICommonResItem, rewardName)
      local param = {}
      param.itemId = item.itemId
      param.count = item.count
      param.rewardType = item.rewardType
      cell:ReInit(param)
    end)
    table.insert(self.rewardItemList, req)
  end
end

return UIActValentineRankRewardView
