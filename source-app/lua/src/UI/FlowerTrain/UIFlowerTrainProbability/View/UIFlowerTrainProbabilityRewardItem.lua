local base = UIBaseContainer
local UIFlowerTrainProbabilityRewardItem = BaseClass("UIFlowerTrainProbabilityRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local item_title1_path = "TitleBg/itemTitle1"
local content1_path = "Content"
local reward_rate_item_path = "UICommonResItem"
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")

function UIFlowerTrainProbabilityRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIFlowerTrainProbabilityRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainProbabilityRewardItem:ComponentDefine()
  self.item_title1 = self:AddComponent(UITextMeshProUGUIEx, item_title1_path)
  self.reward_rate_item = self:AddComponent(UIBaseContainer, reward_rate_item_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, content1_path)
  self.reward_rate_item:SetActive(false)
  self.reward_rate_item.gameObject:GameObjectCreatePool()
end

function UIFlowerTrainProbabilityRewardItem:ComponentDestroy()
  self:ClearRewards()
  self.item_title1 = nil
  self.rewardContent = nil
  self.reward_rate_item = nil
end

function UIFlowerTrainProbabilityRewardItem:DataDefine()
  self.rewardList = {}
  self.rewardItemRequests = {}
end

function UIFlowerTrainProbabilityRewardItem:DataDestroy()
  self.rewardList = {}
  self.rewardItemRequests = {}
end

function UIFlowerTrainProbabilityRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainProbabilityRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainProbabilityRewardItem:RefreshView(data)
  if data then
    self.rewardList = FlowerTrainUtils.ParseRewardStr(data.sub_item)
  end
  self:RefreshRewardContent()
  self:RefreshSize()
end

function UIFlowerTrainProbabilityRewardItem:RefreshRewardContent()
  self:ClearRewards()
  for i = 1, #self.rewardList do
    local showData = self.rewardList[i]
    local item = self.reward_rate_item.gameObject:GameObjectSpawn(self.rewardContent.transform)
    item.name = "reward_rate_item" .. i
    local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
    obj:SetActive(true)
    obj:ReInit(showData)
    obj:SetLocalScaleXYZ(0.83, 0.83, ResetScale.z)
  end
end

function UIFlowerTrainProbabilityRewardItem:ClearRewards()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.reward_rate_item.gameObject:GameObjectRecycleAll()
end

function UIFlowerTrainProbabilityRewardItem:RefreshSize()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardContent.transform)
  local newHeight = self.rewardContent.rectTransform.rect.height
  self.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, newHeight)
end

return UIFlowerTrainProbabilityRewardItem
