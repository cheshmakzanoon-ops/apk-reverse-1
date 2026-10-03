local LWUIActRecycleExchangeHistoryView = BaseClass("LWUIActRecycleExchangeHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local LWUIActRecycleExchangeHistoryItem1Component = require("UI.LWUIActRecycle.ExchangeHistory.Component.LWUIActRecycleExchangeHistoryItem1Component")
local LWUIActRecycleExchangeHistoryItem2Component = require("UI.LWUIActRecycle.ExchangeHistory.Component.LWUIActRecycleExchangeHistoryItem2Component")

function LWUIActRecycleExchangeHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function LWUIActRecycleExchangeHistoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleExchangeHistoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compCommonActivityPopUpBgPart = self.viewSkin:AddComponent(self, CommonActivityPopUpBgPart, 2)
  self.scrollViewUICommonScrollViewVertical1 = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.scrollViewUICommonScrollViewVertical2 = self.viewSkin:AddComponent(self, UIScrollView, 4)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compContent1 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compContent2 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.textEmptyText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textEmptyText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.scrollViewUICommonScrollViewVertical1:SetOnItemMoveIn(function(itemObj, index)
    self:OnItem1MoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewVertical1:SetOnItemMoveOut(function(itemObj, index)
    self:OnItem1MoveOut(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewVertical2:SetOnItemMoveIn(function(itemObj, index)
    self:OnItem2MoveIn(itemObj, index)
  end)
  self.scrollViewUICommonScrollViewVertical2:SetOnItemMoveOut(function(itemObj, index)
    self:OnItem2MoveOut(itemObj, index)
  end)
  self.textEmptyText1:SetLocalText("avatar_tips004")
  self.textEmptyText1:SetActive(false)
  self.textEmptyText2:SetLocalText("avatar_tips004")
  self.textEmptyText2:SetActive(false)
end

function LWUIActRecycleExchangeHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.compCommonActivityPopUpBgPart = nil
  self.scrollViewUICommonScrollViewVertical1 = nil
  self.scrollViewUICommonScrollViewVertical2 = nil
  self.textTips = nil
  self.compContent1 = nil
  self.compContent2 = nil
  self.textEmptyText1 = nil
  self.textEmptyText2 = nil
end

function LWUIActRecycleExchangeHistoryView:DataDefine()
  self.hasSendReq1 = false
  self.hasSendReq2 = false
  self.dataList1 = nil
  self.dataList2 = nil
  self.activityId = 0
end

function LWUIActRecycleExchangeHistoryView:DataDestroy()
  self.hasSendReq1 = nil
  self.hasSendReq2 = nil
  self.dataList1 = nil
  self.dataList2 = nil
  self.activityId = nil
end

function LWUIActRecycleExchangeHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActRecycleReceiveConsumeHistoryMsg, self.OnReceiveConsumeHistoryMsg)
  self:AddUIListener(EventId.ActRecycleReceiveBuyHistoryMsg, self.OnReceiveBuyHistoryMsg)
end

function LWUIActRecycleExchangeHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActRecycleReceiveConsumeHistoryMsg, self.OnReceiveConsumeHistoryMsg)
  self:RemoveUIListener(EventId.ActRecycleReceiveBuyHistoryMsg, self.OnReceiveBuyHistoryMsg)
  base.OnRemoveListener(self)
end

function LWUIActRecycleExchangeHistoryView:OnOpen()
  self.activityId, self.defaultToggle = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.compContent1:SetActive(false)
  self.compContent2:SetActive(false)
  self.compCommonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.compCommonActivityPopUpBgPart:SetCloseCallback(function()
    self.ctrl:CloseSelf()
  end)
  self.compCommonActivityPopUpBgPart:SetTitle("activity_99165_record1_1_title")
  self.compCommonActivityPopUpBgPart:SetToggleText(1, Localization:GetString("activity_99165_record1_2_tab"))
  self.compCommonActivityPopUpBgPart:SetToggleText(2, Localization:GetString("activity_99165_record1_3_tab"))
  self.compCommonActivityPopUpBgPart:SetSelectCallback(function(index)
    self:OnSelectIndex(index)
  end)
  self.compCommonActivityPopUpBgPart:SetSelectIndex(self.defaultToggle)
end

function LWUIActRecycleExchangeHistoryView:OnSelectIndex(index)
  self.compContent1:SetActive(index == 1)
  self.compContent2:SetActive(index == 2)
  if self.index == 1 then
    self.textTips:SetLocalText("activity_99165_record1_4_desc")
  else
    self.textTips:SetLocalText("activity_99165_record2_1_desc")
  end
  if index == 1 and not self.hasSendReq1 then
    self.hasSendReq1 = true
    SFSNetwork.SendMessage(MsgDefines.RecycleConsumeLogs, tonumber(self.activityId))
  elseif index == 2 and not self.hasSendReq2 then
    self.hasSendReq2 = true
    SFSNetwork.SendMessage(MsgDefines.RecycleBuyLogs, tonumber(self.activityId))
  end
end

function LWUIActRecycleExchangeHistoryView:ClearScroll()
  self.scrollViewUICommonScrollViewVertical1:ClearCells()
  self.scrollViewUICommonScrollViewVertical1:RemoveComponents(LWUIActRecycleExchangeHistoryItem1Component)
  self.scrollViewUICommonScrollViewVertical2:ClearCells()
  self.scrollViewUICommonScrollViewVertical2:RemoveComponents(LWUIActRecycleExchangeHistoryItem2Component)
end

function LWUIActRecycleExchangeHistoryView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LWUIActRecycleExchangeHistoryView:OnReceiveConsumeHistoryMsg(msg)
  self.dataList1 = msg
  if not table.IsNullOrEmpty(self.dataList1) then
    self.scrollViewUICommonScrollViewVertical1:SetTotalCount(#self.dataList1)
    self.scrollViewUICommonScrollViewVertical1:RefillCells()
    self.textEmptyText1:SetActive(false)
  else
    self.textEmptyText1:SetActive(true)
  end
end

function LWUIActRecycleExchangeHistoryView:OnReceiveBuyHistoryMsg(msg)
  self.dataList2 = msg
  if not table.IsNullOrEmpty(self.dataList2) then
    self.scrollViewUICommonScrollViewVertical2:SetTotalCount(#self.dataList2)
    self.scrollViewUICommonScrollViewVertical2:RefillCells()
    self.textEmptyText2:SetActive(false)
  else
    self.textEmptyText2:SetActive(true)
  end
end

function LWUIActRecycleExchangeHistoryView:OnItem1MoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewVertical1:AddComponent(LWUIActRecycleExchangeHistoryItem1Component, itemObj)
  cellItem:SetActive(true)
  if self.dataList1 and self.dataList1[index] then
    cellItem:ReInit(self.dataList1[index], self.activityId)
  end
end

function LWUIActRecycleExchangeHistoryView:OnItem1MoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewVertical1:RemoveComponent(itemObj.name, LWUIActRecycleExchangeHistoryItem1Component)
end

function LWUIActRecycleExchangeHistoryView:OnItem2MoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewUICommonScrollViewVertical2:AddComponent(LWUIActRecycleExchangeHistoryItem2Component, itemObj)
  cellItem:SetActive(true)
  if self.dataList2 and self.dataList2[index] then
    cellItem:ReInit(self.dataList2[index])
  end
end

function LWUIActRecycleExchangeHistoryView:OnItem2MoveOut(itemObj, index)
  self.scrollViewUICommonScrollViewVertical2:RemoveComponent(itemObj.name, LWUIActRecycleExchangeHistoryItem2Component)
end

function LWUIActRecycleExchangeHistoryView:Update1000MS()
  if self.activityInfo ~= nil then
    local endTime = self.activityInfo:GetShowEndTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if endTime < curTime then
      self.ctrl:CloseSelf()
      return
    end
  end
end

return LWUIActRecycleExchangeHistoryView
