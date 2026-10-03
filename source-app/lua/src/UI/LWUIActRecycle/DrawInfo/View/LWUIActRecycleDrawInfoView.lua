local LWUIActRecycleDrawInfoView = BaseClass("LWUIActRecycleDrawInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local LWUIActRecycleDrawInfoReceiveItemComponent = require("UI.LWUIActRecycle.DrawInfo.Component.LWUIActRecycleDrawInfoReceiveItemComponent")
local LWUIActRecycleDrawInfoPreviewItemComponent = require("UI.LWUIActRecycle.DrawInfo.Component.LWUIActRecycleDrawInfoPreviewItemComponent")

function LWUIActRecycleDrawInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function LWUIActRecycleDrawInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleDrawInfoView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compCommonActivityPopUpBgPart = self.viewSkin:AddComponent(self, CommonActivityPopUpBgPart, 2)
  self.compReceiveContent = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.scrollViewUICommonScrollViewVertical01 = self.viewSkin:AddComponent(self, UIScrollView, 4)
  self.compBottom = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textTotal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.scrollViewUICommonScrollViewHorizontal = self.viewSkin:AddComponent(self, UIScrollView, 7)
  self.compPreviewContent = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.scrollViewUICommonScrollViewVertical02 = self.viewSkin:AddComponent(self, UIScrollView, 9)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.scrollViewUICommonScrollViewVertical01:SetFixedItemSize(702, 344)
  self.scrollViewUICommonScrollViewVertical01:SetOnItemMoveIn(function(itemObj, index)
    self:OnItem1MoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewVertical01:SetOnItemMoveOut(function(itemObj, index)
    self:OnItem1MoveOut(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewVertical02:SetFixedItemSize(702, 344)
  self.scrollViewUICommonScrollViewVertical02:SetOnItemMoveIn(function(itemObj, index)
    self:OnItem2MoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewVertical02:SetOnItemMoveOut(function(itemObj, index)
    self:OnItem2MoveOut(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewHorizontal:SetFixedItemSize(150, 150)
  self.scrollViewUICommonScrollViewHorizontal:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemTotalRewardMoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewHorizontal:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemTotalRewardMoveOut(itemObj, index)
  end)
  self.textTotal:SetLocalText("activity_99165_reward1_6")
  self.textEmpty:SetLocalText("avatar_tips004")
  self.textEmpty:SetActive(false)
end

function LWUIActRecycleDrawInfoView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.compCommonActivityPopUpBgPart = nil
  self.compReceiveContent = nil
  self.scrollViewUICommonScrollViewVertical01 = nil
  self.compBottom = nil
  self.textTotal = nil
  self.scrollViewUICommonScrollViewHorizontal = nil
  self.compPreviewContent = nil
  self.scrollViewUICommonScrollViewVertical02 = nil
  self.textEmpty = nil
end

function LWUIActRecycleDrawInfoView:DataDefine()
  self.hasInit1 = false
  self.hasInit2 = false
  self.activityId = 0
end

function LWUIActRecycleDrawInfoView:DataDestroy()
  self.hasInit1 = nil
  self.hasInit2 = nil
  self.activityId = nil
end

function LWUIActRecycleDrawInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActRecycleReceiveLotteryHistoryMsg, self.OnReceiveLotteryHistoryMsg)
end

function LWUIActRecycleDrawInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActRecycleReceiveLotteryHistoryMsg, self.OnReceiveLotteryHistoryMsg)
  base.OnRemoveListener(self)
end

function LWUIActRecycleDrawInfoView:OnOpen()
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.compPreviewContent:SetActive(false)
  self.compReceiveContent:SetActive(false)
  self.compBottom:SetActive(false)
  self.compCommonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.compCommonActivityPopUpBgPart:SetCloseCallback(function()
    self.ctrl:CloseSelf()
  end)
  self.compCommonActivityPopUpBgPart:SetTitle("activity_99165_reward1_1_title")
  self.compCommonActivityPopUpBgPart:SetToggleText(1, Localization:GetString("activity_99165_reward1_2_tab"))
  self.compCommonActivityPopUpBgPart:SetToggleText(2, Localization:GetString("activity_99165_reward1_3_tab"))
  self.compCommonActivityPopUpBgPart:SetSelectCallback(function(index)
    self:OnSelectIndex(index)
  end)
  self.compCommonActivityPopUpBgPart:SetSelectIndex(1)
end

function LWUIActRecycleDrawInfoView:OnSelectIndex(index)
  self.compReceiveContent:SetActive(index == 1)
  self.compPreviewContent:SetActive(index == 2)
  if index == 1 and not self.hasInit1 then
    self.hasInit1 = true
    SFSNetwork.SendMessage(MsgDefines.RecycleLotteryLogs, tonumber(self.activityId))
  elseif index == 2 and not self.hasInit2 then
    self.hasInit2 = true
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityInfo == nil then
      return
    end
    local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
    if mainTemplate == nil then
      return
    end
    self.probabilityDataList = mainTemplate:GetLotteryProbabilityDataList()
    if not table.IsNullOrEmpty(self.probabilityDataList) then
      self.scrollViewUICommonScrollViewVertical02:SetTotalCount(#self.probabilityDataList)
      self.scrollViewUICommonScrollViewVertical02:RefillCells()
      self.compPreviewContent:SetActive(true)
    end
  end
end

function LWUIActRecycleDrawInfoView:OnReceiveLotteryHistoryMsg(msg)
  self.receiveDataList = msg
  self.totalRewardList = {}
  if not table.IsNullOrEmpty(self.receiveDataList) then
    self.scrollViewUICommonScrollViewVertical01:SetTotalCount(#self.receiveDataList)
    self.scrollViewUICommonScrollViewVertical01:RefillCells()
    for _, receiveData in ipairs(self.receiveDataList) do
      local showReward = DataCenter.RewardManager:ReturnRewardParamForMessage(receiveData.reward)
      if not table.IsNullOrEmpty(showReward) then
        for _, v in ipairs(showReward) do
          table.insert(self.totalRewardList, v)
        end
      end
    end
    self.totalRewardList = DataCenter.RewardManager:CombineRewardList(self.totalRewardList)
    if not table.IsNullOrEmpty(self.totalRewardList) then
      self.scrollViewUICommonScrollViewHorizontal:SetTotalCount(#self.totalRewardList)
      self.scrollViewUICommonScrollViewHorizontal:RefillCells()
      self.compBottom:SetActive(true)
    end
    self.textEmpty:SetActive(false)
  else
    self.textEmpty:SetActive(true)
  end
end

function LWUIActRecycleDrawInfoView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LWUIActRecycleDrawInfoView:OnItem1MoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewVertical01:AddComponent(LWUIActRecycleDrawInfoReceiveItemComponent, itemObj)
  cellItem:SetActive(true)
  if self.receiveDataList and self.receiveDataList[index] then
    cellItem:ReInit(self.receiveDataList[index], self.activityId)
  end
end

function LWUIActRecycleDrawInfoView:OnItem1MoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewVertical01:RemoveComponent(itemObj.name, LWUIActRecycleDrawInfoReceiveItemComponent)
end

function LWUIActRecycleDrawInfoView:OnItem2MoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewVertical02:AddComponent(LWUIActRecycleDrawInfoPreviewItemComponent, itemObj)
  cellItem:SetActive(true)
  if self.probabilityDataList and self.probabilityDataList[index] then
    cellItem:ReInit(self.probabilityDataList[index].index, self.probabilityDataList[index].probability, self.probabilityDataList[index].rewardId, self.activityId)
  end
end

function LWUIActRecycleDrawInfoView:OnItem2MoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewVertical02:RemoveComponent(itemObj.name, LWUIActRecycleDrawInfoPreviewItemComponent)
end

function LWUIActRecycleDrawInfoView:OnItemTotalRewardMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewHorizontal:AddComponent(UICommonResItem, itemObj)
  cellItem:SetActive(true)
  if self.totalRewardList and self.totalRewardList[index] then
    cellItem.transform:Set_localScale(0.9, 0.9, 0.9)
    cellItem:ReInit(self.totalRewardList[index])
  end
end

function LWUIActRecycleDrawInfoView:OnItemTotalRewardMoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewHorizontal:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWUIActRecycleDrawInfoView:ClearScroll()
  self.scrollViewUICommonScrollViewVertical02:ClearCells()
  self.scrollViewUICommonScrollViewVertical02:RemoveComponents(LWUIActRecycleDrawInfoPreviewItemComponent)
  self.scrollViewUICommonScrollViewVertical01:ClearCells()
  self.scrollViewUICommonScrollViewVertical01:RemoveComponents(LWUIActRecycleDrawInfoReceiveItemComponent)
  self.scrollViewUICommonScrollViewHorizontal:ClearCells()
  self.scrollViewUICommonScrollViewHorizontal:RemoveComponents(UICommonResItem)
end

function LWUIActRecycleDrawInfoView:Update1000MS()
  if self.activityInfo ~= nil then
    local endTime = self.activityInfo:GetShowEndTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if endTime < curTime then
      self.ctrl:CloseSelf()
      return
    end
  end
end

return LWUIActRecycleDrawInfoView
