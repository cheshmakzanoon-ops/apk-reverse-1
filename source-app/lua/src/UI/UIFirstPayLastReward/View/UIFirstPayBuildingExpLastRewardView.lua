local UIFirstPayBuildingExpLastRewardView = BaseClass("UIFirstPayBuildingExpLastRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIFirstPayBuildingExpLastRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local rewardServerDataList = self:GetUserData() or {}
  self.rewardDataList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardServerDataList)
  self.loopListView2RewardList:InitListView(0, function(loopView, index)
    return self:OnGetRewardItemByIndex(loopView, index)
  end)
  self:RefreshRewardList()
  UIUtil.ShowTipsId("fp_tips_5")
end

function UIFirstPayBuildingExpLastRewardView:OnDestroy()
  self:ClearRewardList()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFirstPayBuildingExpLastRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.loopListView2RewardList = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compItemRoot:SetActive(false)
  self.contentLayoutCpt = self.compContent.gameObject:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
end

function UIFirstPayBuildingExpLastRewardView:ComponentDestroy()
  self.viewSkin = nil
  self.btnConfirm = nil
  self.compItemRoot = nil
  self.loopListView2RewardList = nil
  self.compContent = nil
end

function UIFirstPayBuildingExpLastRewardView:DataDefine()
  self.rewardDataList = nil
  self.itemIndex = 0
end

function UIFirstPayBuildingExpLastRewardView:DataDestroy()
  self.rewardDataList = nil
  self.itemIndex = nil
end

function UIFirstPayBuildingExpLastRewardView:OnGetRewardItemByIndex(loopScroll, index)
  index = index + 1
  if not self.rewardDataList or index < 1 or index > #self.rewardDataList then
    return nil
  end
  local rewardData = self.rewardDataList[index]
  local item = loopScroll:NewListViewItem("UICommonResItem")
  item.transform.localScale = Vector3.New(0.9, 0.9, 0.9)
  local script = self.compContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = "reward_item_" .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(rewardData)
  return item
end

function UIFirstPayBuildingExpLastRewardView:RefreshRewardList()
  if not self.loopListView2RewardList or not self.compContent then
    return
  end
  if not self.rewardDataList or #self.rewardDataList == 0 then
    self.loopListView2RewardList:SetActive(false)
    return
  end
  self.loopListView2RewardList:SetActive(true)
  self.loopListView2RewardList:SetListItemCount(#self.rewardDataList, false, false)
  self.loopListView2RewardList:RefreshAllShownItem()
  self.contentLayoutCpt.enabled = #self.rewardDataList <= 5
  if #self.rewardDataList <= 5 then
    self.compContent.rectTransform:Set_sizeDelta(620, self.compContent.rectTransform.rect.height)
  end
end

function UIFirstPayBuildingExpLastRewardView:ClearRewardList()
  if self.compContent then
    self.compContent:RemoveComponents(UICommonResItem)
  end
  if self.loopListView2RewardList then
    self.loopListView2RewardList:ClearAllItems()
  end
end

function UIFirstPayBuildingExpLastRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UIFirstPayBuildingExpLastRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFirstPayBuildingExpLastRewardView:OnBtnConfirmClick()
  self:ShowFlyReward()
  self.ctrl:CloseSelf()
end

function UIFirstPayBuildingExpLastRewardView:ShowFlyReward()
  if not self.rewardDataList or #self.rewardDataList <= 0 or not self.compContent then
    return
  end
  local count = math.min(#self.rewardDataList, self.compContent.transform.childCount)
  for i = 1, count do
    local child = self.compContent.transform:GetChild(i - 1)
    local img = child.gameObject.transform:Find("clickBtn/ItemIcon")
    local pic = DataCenter.RewardManager:GetPicByType(self.rewardDataList[i].rewardType, self.rewardDataList[i].itemId)
    local flyPos = Vector3.New(0, 0, 0)
    UIUtil.DoFly(self.rewardDataList[i].rewardType, 2, pic, img.gameObject.transform.position, flyPos, 100, 100)
  end
end

return UIFirstPayBuildingExpLastRewardView
