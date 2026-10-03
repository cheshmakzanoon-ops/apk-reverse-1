local base = UIBaseContainer
local LWUIActRecycleDrawInfoReceiveItemComponent = BaseClass("LWUIActRecycleDrawInfoReceiveItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWUIActRecycleReceiveGiftPlayerItemComponent = require("UI.LWUIActRecycle.ReceiveGift.Component.LWUIActRecycleReceiveGiftPlayerItemComponent")

function LWUIActRecycleDrawInfoReceiveItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleDrawInfoReceiveItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleDrawInfoReceiveItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.scrollViewUICommonScrollViewHorizontal01 = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.textGiver = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.scrollViewUICommonScrollViewHorizontal02 = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.scrollViewUICommonScrollViewHorizontal01:SetFixedItemSize(135.0, 135.0)
  self.scrollViewUICommonScrollViewHorizontal01:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateItemCell(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewHorizontal01:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteItemCell(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewHorizontal02:SetFixedItemSize(100, 100)
  self.scrollViewUICommonScrollViewHorizontal02:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreatePlayerCell(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewHorizontal02:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeletePlayerCell(itemObj, index)
  end)
  self.textTitle:SetLocalText("activity_99165_reward1_4_desc")
  self.textGiver:SetLocalText("activity_99165_reward1_5")
end

function LWUIActRecycleDrawInfoReceiveItemComponent:ComponentDestroy()
  self:ClearItems()
  self:ClearPlayers()
  self.viewSkin = nil
  self.textTitle = nil
  self.textSubTitle = nil
  self.scrollViewUICommonScrollViewHorizontal01 = nil
  self.textGiver = nil
  self.scrollViewUICommonScrollViewHorizontal02 = nil
end

function LWUIActRecycleDrawInfoReceiveItemComponent:DataDefine()
end

function LWUIActRecycleDrawInfoReceiveItemComponent:DataDestroy()
end

function LWUIActRecycleDrawInfoReceiveItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleDrawInfoReceiveItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleDrawInfoReceiveItemComponent:ReInit(msgData, activityId)
  self.msgData = msgData
  self.activityId = activityId
  self.showRewards = DataCenter.RewardManager:ReturnRewardParamForMessage(self.msgData.reward)
  if not table.IsNullOrEmpty(self.showRewards) then
    self.scrollViewUICommonScrollViewHorizontal01:SetActive(true)
    self.scrollViewUICommonScrollViewHorizontal01:SetTotalCount(#self.showRewards)
    self.scrollViewUICommonScrollViewHorizontal01:RefillCells()
  else
    self.scrollViewUICommonScrollViewHorizontal01:SetActive(false)
  end
  self.showPlayers = self.msgData.recommendPlayers
  if not table.IsNullOrEmpty(self.showPlayers) then
    self.scrollViewUICommonScrollViewHorizontal02:SetActive(true)
    self.scrollViewUICommonScrollViewHorizontal02:SetTotalCount(#self.showPlayers)
    self.scrollViewUICommonScrollViewHorizontal02:RefillCells()
  else
    self.scrollViewUICommonScrollViewHorizontal02:SetActive(false)
  end
  self.textSubTitle:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMDHM(self.msgData.time or 0))
end

function LWUIActRecycleDrawInfoReceiveItemComponent:OnCreateItemCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewHorizontal01:AddComponent(UICommonResItem, itemObj)
  if self.showRewards and self.showRewards[index] then
    cellItem.transform:Set_localScale(0.9, 0.9, 0.9)
    cellItem:ReInit(self.showRewards[index], self.activityId)
  end
end

function LWUIActRecycleDrawInfoReceiveItemComponent:OnCreatePlayerCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewHorizontal02:AddComponent(LWUIActRecycleReceiveGiftPlayerItemComponent, itemObj)
  if self.showPlayers and self.showPlayers[index] then
    cellItem:ReInit(self.showPlayers[index], self.activityId)
  end
end

function LWUIActRecycleDrawInfoReceiveItemComponent:OnDeleteItemCell(itemObj, index)
  self.scrollViewUICommonScrollViewHorizontal01:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWUIActRecycleDrawInfoReceiveItemComponent:OnDeletePlayerCell(itemObj, index)
  self.scrollViewUICommonScrollViewHorizontal02:RemoveComponent(itemObj.name, LWUIActRecycleReceiveGiftPlayerItemComponent)
end

function LWUIActRecycleDrawInfoReceiveItemComponent:ClearItems()
  self.scrollViewUICommonScrollViewHorizontal01:ClearCells()
  self.scrollViewUICommonScrollViewHorizontal01:RemoveComponents(UICommonResItem)
end

function LWUIActRecycleDrawInfoReceiveItemComponent:ClearPlayers()
  self.scrollViewUICommonScrollViewHorizontal02:ClearCells()
  self.scrollViewUICommonScrollViewHorizontal02:RemoveComponents(LWUIActRecycleReceiveGiftPlayerItemComponent)
end

return LWUIActRecycleDrawInfoReceiveItemComponent
