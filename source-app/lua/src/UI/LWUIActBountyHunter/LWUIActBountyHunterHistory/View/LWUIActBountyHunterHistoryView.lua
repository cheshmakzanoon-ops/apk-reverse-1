local LWUIActBountyHunterHistoryView = BaseClass("LWUIActBountyHunterHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NormalCard = require("UI.LWUIActBountyHunter.LWUIActBountyHunterReward.Component.BountyHunterNormalLogCardComponent")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")

function LWUIActBountyHunterHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  if not self.activityId then
    self.ctrl:CloseSelf()
    return
  end
  if self.activityId then
    self.activityData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  end
  if not self.activityData then
    self.ctrl:CloseSelf()
    return
  end
  local bountyHunterTmpData = self.activityData.hunterActTmpData
  self.convertItemId = -1
  if bountyHunterTmpData then
    self.convertItemId = bountyHunterTmpData.convert_id
  end
  self:OnOpen()
end

function LWUIActBountyHunterHistoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterHistoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compBattleLogArea = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.loopListView2BatLogScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.compBattleLogContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textLogEmptyTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compRewardInfoArea = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.gridInfinityScrollViewCanClaimRewardContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 8)
  self.scrollRectCanClaimScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 9)
  self.textCanClaimEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 11)
  self.scrollRectStoredScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 12)
  self.gridInfinityScrollViewStoredRewardContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 13)
  self.textStoredEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textRewardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.btnClaimStashReward = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnClaimStashReward:SetOnClick(function()
    self:OnBtnClaimStashRewardClick()
  end)
  self.imgHasUsedIcon = self.viewSkin:AddComponent(self, UIImage, 17)
  self.textHasUsedValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compUIActBountyHunterHistory = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  local bindFunc1CanClaim = BindCallback(self, self.OnInitScrollCanClaim)
  local bindFunc2CanClaim = BindCallback(self, self.OnUpdateScrollCanClaim)
  local bindFunc3CanClaim = BindCallback(self, self.OnDestroyScrollItemCanClaim)
  self.gridInfinityScrollViewCanClaimRewardContent:Init(bindFunc1CanClaim, bindFunc2CanClaim, bindFunc3CanClaim)
  local bindFunc1Stored = BindCallback(self, self.OnInitScrollStored)
  local bindFunc2Stored = BindCallback(self, self.OnUpdateScrollStored)
  local bindFunc3Stored = BindCallback(self, self.OnDestroyScrollItemStored)
  self.gridInfinityScrollViewStoredRewardContent:Init(bindFunc1Stored, bindFunc2Stored, bindFunc3Stored)
  self.loopListView2BatLogScrollView:InitListView(0, function(loopView, index)
    return self:GetLogScrollItem(loopView, index)
  end)
end

function LWUIActBountyHunterHistoryView:ComponentDestroy()
  self:ClearCanClaimItems()
  self:ClearStoredItems()
  self:ClearHistoryItems()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.compBattleLogArea = nil
  self.loopListView2BatLogScrollView = nil
  self.compBattleLogContent = nil
  self.textLogEmptyTip = nil
  self.compRewardInfoArea = nil
  self.gridInfinityScrollViewCanClaimRewardContent = nil
  self.scrollRectCanClaimScrollView = nil
  self.textCanClaimEmpty = nil
  self.compUICommonToggleList = nil
  self.scrollRectStoredScrollView = nil
  self.gridInfinityScrollViewStoredRewardContent = nil
  self.textStoredEmpty = nil
  self.textRewardTips = nil
  self.btnClaimStashReward = nil
  self.imgHasUsedIcon = nil
  self.textHasUsedValue = nil
  self.compUIActBountyHunterHistory = nil
end

function LWUIActBountyHunterHistoryView:DataDefine()
  self.hasInitLog = false
  self.activityData = nil
  self.hasRequestBatLog = false
  self.logItems = {}
  self.logItemIndex = 1
  self.activityId = nil
end

function LWUIActBountyHunterHistoryView:DataDestroy()
  self.hasInitLog = nil
  self.activityData = nil
  self.hasRequestBatLog = nil
  self.logItems = nil
  self.logItemIndex = nil
  self.activityId = nil
end

function LWUIActBountyHunterHistoryView:OnOpen()
  self:InitToggle()
end

function LWUIActBountyHunterHistoryView:InitToggle()
  local data = {}
  local data1 = {}
  data1.name = Localization:GetString("activity_hunter_record_title_1")
  local data2 = {}
  data2.name = Localization:GetString("activity_hunter_record_desc4")
  data.itemsDataList = {data1, data2}
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.defaultSelectIndex = 1
  
  function data.isShowRed(index, itemData)
    if index == 1 and self.activityData then
      local canClaimRewardDataList = self.activityData:GetCurStashRewardData()
      return 0 < #canClaimRewardDataList
    end
    return false
  end
  
  self.compUICommonToggleList:ReInit(data)
end

function LWUIActBountyHunterHistoryView:OnSelectToggle(index, itemData)
  if index == 1 then
    self:RefreshReward()
  elseif index == 2 then
    self:RefreshLog()
  end
end

function LWUIActBountyHunterHistoryView:RefreshReward()
  self.compRewardInfoArea:SetActive(true)
  self.compBattleLogArea:SetActive(false)
  local canClaimRewardDataList = self.activityData:GetCurStashRewardData()
  local isCanClaimEmpty = #canClaimRewardDataList == 0
  self.textCanClaimEmpty:SetActive(isCanClaimEmpty)
  self.scrollRectCanClaimScrollView:SetActive(not isCanClaimEmpty)
  if not isCanClaimEmpty then
    table.sort(canClaimRewardDataList, function(a, b)
      local templateA = DataCenter.ItemTemplateManager:GetItemTemplate(a.value.id)
      local templateB = DataCenter.ItemTemplateManager:GetItemTemplate(b.value.id)
      if templateA and templateB and templateA.quality ~= templateB.quality then
        return templateA.quality > templateB.quality
      end
      return checknumber(a.value.id) < checknumber(b.value.id)
    end)
    self.canClaimRewardDataList = canClaimRewardDataList
    self.gridInfinityScrollViewCanClaimRewardContent:SetItemCount(#self.canClaimRewardDataList)
  end
  self.btnClaimStashReward:SetActive(not isCanClaimEmpty)
  self.textRewardTips:SetActive(isCanClaimEmpty)
  local storedRewardDataList = self.activityData:GetHistoryClaimRewardData()
  local isStoredEmpty = #storedRewardDataList == 0
  self.scrollRectStoredScrollView:SetActive(not isStoredEmpty)
  self.textStoredEmpty:SetActive(isStoredEmpty)
  if not isStoredEmpty then
    table.sort(storedRewardDataList, function(a, b)
      local templateA = DataCenter.ItemTemplateManager:GetItemTemplate(a.value.id)
      local templateB = DataCenter.ItemTemplateManager:GetItemTemplate(b.value.id)
      if templateA and templateB and templateA.quality ~= templateB.quality then
        return templateA.quality > templateB.quality
      end
      return checknumber(a.value.id) < checknumber(a.value.id)
    end)
    self.storedRewardDataList = storedRewardDataList
    self.gridInfinityScrollViewStoredRewardContent:SetItemCount(#self.storedRewardDataList)
  end
  if self.activityData.hunterActTmpData then
    local itemIcon = DataCenter.ItemTemplateManager:GetIconPath(self.activityData.hunterActTmpData.cost_id)
    self.imgHasUsedIcon:LoadSprite(itemIcon)
    self.textHasUsedValue:SetText(self.activityData:GetTotalConsumeTime() * self.activityData.hunterActTmpData.cost_num)
  end
end

function LWUIActBountyHunterHistoryView:RefreshLog()
  self.compRewardInfoArea:SetActive(false)
  self.compBattleLogArea:SetActive(true)
  self:ClearHistoryItems()
  local dataCount = self.ctrl:GetBatLogDataCnt(self.activityId)
  local isEmpty = dataCount <= 0
  self.textLogEmptyTip:SetActive(isEmpty)
  local isAlreadySynFullData = false
  if self.activityData then
    isAlreadySynFullData = self.activityData.isFullSynedLogData
  end
  if isEmpty or not isAlreadySynFullData then
    if not self.hasRequestBatLog then
      self.ctrl:ReqBatLogData(self.activityId)
      self.hasRequestBatLog = true
    end
  else
    self.loopListView2BatLogScrollView:SetListItemCount(dataCount, false, false)
  end
end

function LWUIActBountyHunterHistoryView:ClearCanClaimItems()
  self.scrollRectCanClaimScrollView:RemoveComponents(UICommonResItem)
  self.gridInfinityScrollViewCanClaimRewardContent:DestroyChildNode()
end

function LWUIActBountyHunterHistoryView:ClearStoredItems()
  self.scrollRectStoredScrollView:RemoveComponents(UICommonResItem)
  self.gridInfinityScrollViewStoredRewardContent:DestroyChildNode()
end

function LWUIActBountyHunterHistoryView:ClearHistoryItems()
  self.compBattleLogContent:RemoveComponents(NormalCard)
  self.loopListView2BatLogScrollView:ClearAllItems()
  self.logItems = {}
end

function LWUIActBountyHunterHistoryView:GetLogScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > self.ctrl:GetBatLogDataCnt(self.activityId) then
    return nil
  end
  local item_data = self.ctrl:GetItemByIndex(self.activityId, index) or {}
  local prefabName, scriptName = self.ctrl:GetPrefabAndScriptName(item_data)
  local item = listview:NewListViewItem(prefabName)
  if self.logItems[item] == nil then
    self.logItemIndex = self.logItemIndex + 1
    local nameStr = tostring(self.logItemIndex)
    item.gameObject.name = nameStr
    local mailItem = self.compBattleLogContent:AddComponent(scriptName, nameStr)
    self.logItems[item] = mailItem
  else
    self.logItemIndex = self.logItemIndex + 1
    local nameStr = tostring(self.logItemIndex)
    item.gameObject.name = nameStr
  end
  self.logItems[item]:SetData(item_data)
  return item
end

function LWUIActBountyHunterHistoryView:OnInitScrollCanClaim(go, index)
  if not self.canClaimItems then
    self.canClaimItems = {}
  end
  local item = self.scrollRectCanClaimScrollView:AddComponent(UICommonResItem, go)
  self.canClaimItems[index] = item
end

function LWUIActBountyHunterHistoryView:OnUpdateScrollCanClaim(go, index)
  if not self.canClaimItems or not self.canClaimItems[index + 1] then
    return
  end
  if not self.canClaimRewardDataList or not self.canClaimRewardDataList[index + 1] then
    return
  end
  go.transform:Set_localScale(1, 1, 1)
  local cellItem = self.canClaimItems[index + 1]
  go.name = "item_" .. index
  local rewardData = self.canClaimRewardDataList[index + 1]
  cellItem:ParseInfo(rewardData)
  cellItem:SetActive(true)
  self:CheckConvertItemShowExactNum(cellItem, rewardData)
end

function LWUIActBountyHunterHistoryView:CheckConvertItemShowExactNum(cellItem, rewardData)
  if not (cellItem and rewardData and rewardData.value and rewardData.value.id) or not rewardData.value.num then
    return
  end
  if rewardData.value.id ~= tostring(self.convertItemId) then
    return
  end
  cellItem:SetItemCount(tostring(rewardData.value.num))
end

function LWUIActBountyHunterHistoryView:OnDestroyScrollItemCanClaim(go, index)
end

function LWUIActBountyHunterHistoryView:OnInitScrollStored(go, index)
  if not self.storedItems then
    self.storedItems = {}
  end
  local item = self.scrollRectStoredScrollView:AddComponent(UICommonResItem, go)
  self.storedItems[index] = item
end

function LWUIActBountyHunterHistoryView:OnUpdateScrollStored(go, index)
  if not self.storedItems or not self.storedItems[index + 1] then
    return
  end
  if not self.storedRewardDataList or not self.storedRewardDataList[index + 1] then
    return
  end
  go.transform:Set_localScale(0.9, 0.9, 0.9)
  local cellItem = self.storedItems[index + 1]
  go.name = "item_" .. index
  local rewardData = self.storedRewardDataList[index + 1]
  cellItem:ParseInfo(rewardData)
  cellItem:SetActive(true)
  self:CheckConvertItemShowExactNum(cellItem, rewardData)
end

function LWUIActBountyHunterHistoryView:OnDestroyScrollItemStored(go, index)
end

function LWUIActBountyHunterHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BountyHunterSuccessGetStashReward, self.OnSuccessGetStashReward)
  self:AddUIListener(EventId.BountyHunterReceiveBatLogData, self.OnReceiveBatLogData)
  self:AddUIListener(EventId.BountyHunterReceiveActInfo, self.OnReceiveReceiveActInfo)
end

function LWUIActBountyHunterHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.BountyHunterSuccessGetStashReward, self.OnSuccessGetStashReward)
  self:RemoveUIListener(EventId.BountyHunterReceiveBatLogData, self.OnReceiveBatLogData)
  self:RemoveUIListener(EventId.BountyHunterReceiveActInfo, self.OnReceiveReceiveActInfo)
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterHistoryView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIActBountyHunterHistoryView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIActBountyHunterHistoryView:OnReceiveReceiveActInfo()
  if self.activityId then
    self.ctrl:ReqBatLogData(self.activityId)
  end
end

function LWUIActBountyHunterHistoryView:OnBtnClaimStashRewardClick()
  if self.activityId then
    self.ctrl:ReqClaimStashReward(self.activityId)
  end
end

function LWUIActBountyHunterHistoryView:OnSuccessGetStashReward()
  local curIndex = self.compUICommonToggleList:GetCurSelectIndex()
  if curIndex == 1 then
    self:RefreshReward()
  end
  self.compUICommonToggleList:UpdateRed()
end

function LWUIActBountyHunterHistoryView:OnReceiveBatLogData()
  local curIndex = self.compUICommonToggleList:GetCurSelectIndex()
  if curIndex == 2 then
    self:RefreshLog()
  end
end

return LWUIActBountyHunterHistoryView
