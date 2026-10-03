local UIActBanquetAttackMonsterHistoryView = BaseClass("UIActBanquetAttackMonsterHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NormalCard = require("UI.UIActBanquetAttackMonsterHistory.Component.BanquetAttackNormalLogCard")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")

function UIActBanquetAttackMonsterHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.activityId = param.activityId
  self.partyNewId = param.partyNewId
  if not self.activityId then
    self.ctrl:CloseSelf()
    return
  end
  self:OnOpen()
end

function UIActBanquetAttackMonsterHistoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActBanquetAttackMonsterHistoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compBattleLogArea = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.loopListView2BatLogScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compBattleLogContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textLogEmptyTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compRewardInfoArea = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.gridInfinityScrollViewCanClaimRewardContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 7)
  self.scrollRectCanClaimScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 8)
  self.textCanClaimEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 10)
  self.scrollRectStoredScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 11)
  self.gridInfinityScrollViewStoredRewardContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 12)
  self.textStoredEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textRewardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnClaimStashReward = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnClaimStashReward:SetOnClick(function()
    self:OnBtnClaimStashRewardClick()
  end)
  self.imgHasUsedIcon = self.viewSkin:AddComponent(self, UIImage, 16)
  self.textHasUsedValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.compUIActBanquetAttackMonsterHistory = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.compCommonActivityPopUpBgPart = self.viewSkin:AddComponent(self, CommonActivityPopUpBgPart, 19)
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
  self.compCommonActivityPopUpBgPart:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIActBanquetAttackMonsterHistoryView:ComponentDestroy()
  self:ClearCanClaimItems()
  self:ClearStoredItems()
  self:ClearHistoryItems()
  self.viewSkin = nil
  self.btnPanel = nil
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
  self.compUIActBanquetAttackMonsterHistory = nil
  self.compCommonActivityPopUpBgPart = nil
end

function UIActBanquetAttackMonsterHistoryView:DataDefine()
  self.hasInitLog = false
  self.hasRequestBatLog = false
  self.logItems = {}
  self.activityId = nil
  self.partyNewId = nil
end

function UIActBanquetAttackMonsterHistoryView:DataDestroy()
  self.hasInitLog = nil
  self.hasRequestBatLog = nil
  self.logItems = nil
  self.activityId = nil
  self.partyNewId = nil
end

function UIActBanquetAttackMonsterHistoryView:OnOpen()
  self:InitToggle()
  self:InitBg()
  self.ctrl:ReqBatLogData(self.activityId, self.partyNewId)
end

function UIActBanquetAttackMonsterHistoryView:InitBg()
  if not self.activityId then
    return
  end
  self.compCommonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.imgHasUsedIcon:SetActive(false)
end

function UIActBanquetAttackMonsterHistoryView:InitToggle()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, activityInfo:GetFestivalInterfaceCfgId())
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. toggleData.actData:GetFestivalInterfaceCfgId())
    return
  end
  local selectBgPath = ""
  local unselectBgPath = ""
  local selectColor, unselectColorPath
  if not string.IsNullOrEmpty(lineData.board_page) then
    local pageList = string.split(lineData.board_page, "|")
    if 4 <= #pageList then
      selectBgPath = string.format(LoadPath.ActivityThemPath, pageList[1])
      unselectBgPath = string.format(LoadPath.ActivityThemPath, pageList[2])
      local selectWorldColorArr = string.split(pageList[3], ",")
      local unSelectWorldColorArr = string.split(pageList[4], ",")
      selectColor = Color.New(tonumber(selectWorldColorArr[1]) / 255, tonumber(selectWorldColorArr[2]) / 255, tonumber(selectWorldColorArr[3]) / 255, tonumber(selectWorldColorArr[4] / 255))
      unselectColorPath = Color.New(tonumber(unSelectWorldColorArr[1]) / 255, tonumber(unSelectWorldColorArr[2]) / 255, tonumber(unSelectWorldColorArr[3]) / 255, tonumber(unSelectWorldColorArr[4] / 255))
    end
  end
  local data = {}
  local data1 = {}
  data1.name = Localization:GetString("activity_hunter_record_title_1")
  data1.selectBgPath = selectBgPath
  data1.unselectBgPath = unselectBgPath
  data1.selectTextColor = selectColor
  data1.unselectTextColor = unselectColorPath
  local data2 = {}
  data2.name = Localization:GetString("activity_hunter_record_desc4")
  data2.selectBgPath = selectBgPath
  data2.unselectBgPath = unselectBgPath
  data2.selectTextColor = selectColor
  data2.unselectTextColor = unselectColorPath
  data.itemsDataList = {data1, data2}
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.defaultSelectIndex = 1
  self.compUICommonToggleList:ReInit(data)
end

function UIActBanquetAttackMonsterHistoryView:OnSelectToggle(index, itemData)
  if index == 1 then
    self.compRewardInfoArea:SetActive(true)
    self.compBattleLogArea:SetActive(false)
  elseif index == 2 then
    self.compRewardInfoArea:SetActive(false)
    self.compBattleLogArea:SetActive(true)
  end
end

function UIActBanquetAttackMonsterHistoryView:RefreshReward(refreshStashReward)
  local canClaimRewardDataList = self.ctrl:GetExtraReward()
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
  if refreshStashReward then
    local storedRewardDataList = self.ctrl:GetHistoryReward()
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
    local costItem1PicPath = self.ctrl:GetHasUsedIcon()
    self.imgHasUsedIcon:LoadSprite(costItem1PicPath)
    self.imgHasUsedIcon:SetActive(true)
    self.textHasUsedValue:SetText(self.ctrl:GetCostItems())
  end
end

function UIActBanquetAttackMonsterHistoryView:RefreshLog()
  self:ClearHistoryItems()
  local dataCount = self.ctrl:GetBatLogDataCnt(self.activityId)
  local isEmpty = dataCount <= 0
  self.textLogEmptyTip:SetActive(isEmpty)
  self.loopListView2BatLogScrollView:SetListItemCount(dataCount, false, false)
end

function UIActBanquetAttackMonsterHistoryView:ClearCanClaimItems()
  self.scrollRectCanClaimScrollView:RemoveComponents(UICommonResItem)
  self.gridInfinityScrollViewCanClaimRewardContent:DestroyChildNode()
end

function UIActBanquetAttackMonsterHistoryView:ClearStoredItems()
  self.scrollRectStoredScrollView:RemoveComponents(UICommonResItem)
  self.gridInfinityScrollViewStoredRewardContent:DestroyChildNode()
end

function UIActBanquetAttackMonsterHistoryView:ClearHistoryItems()
  self.compBattleLogContent:RemoveComponents(NormalCard)
  self.loopListView2BatLogScrollView:ClearAllItems()
  self.logItems = {}
end

function UIActBanquetAttackMonsterHistoryView:GetLogScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > self.ctrl:GetBatLogDataCnt(self.activityId) then
    return nil
  end
  local item_data = self.ctrl:GetItemByIndex(self.activityId, index) or {}
  local prefabName, scriptName = self.ctrl:GetPrefabAndScriptName(item_data)
  local item = listview:NewListViewItem(prefabName)
  if self.logItems[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local mailItem = self.compBattleLogContent:AddComponent(scriptName, nameStr)
    self.logItems[item] = mailItem
  else
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
  end
  self.logItems[item]:SetData(item_data)
  return item
end

function UIActBanquetAttackMonsterHistoryView:OnInitScrollCanClaim(go, index)
  if not self.canClaimItems then
    self.canClaimItems = {}
  end
  local item = self.scrollRectCanClaimScrollView:AddComponent(UICommonResItem, go)
  self.canClaimItems[index] = item
end

function UIActBanquetAttackMonsterHistoryView:OnUpdateScrollCanClaim(go, index)
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

function UIActBanquetAttackMonsterHistoryView:CheckConvertItemShowExactNum(cellItem, rewardData)
  if not (cellItem and rewardData and rewardData.value and rewardData.value.id) or not rewardData.value.num then
    return
  end
  if rewardData.value.id ~= tostring(self.convertItemId) then
    return
  end
  cellItem:SetItemCount(tostring(rewardData.value.num))
end

function UIActBanquetAttackMonsterHistoryView:OnDestroyScrollItemCanClaim(go, index)
end

function UIActBanquetAttackMonsterHistoryView:OnInitScrollStored(go, index)
  if not self.storedItems then
    self.storedItems = {}
  end
  local item = self.scrollRectStoredScrollView:AddComponent(UICommonResItem, go)
  self.storedItems[index] = item
end

function UIActBanquetAttackMonsterHistoryView:OnUpdateScrollStored(go, index)
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

function UIActBanquetAttackMonsterHistoryView:OnDestroyScrollItemStored(go, index)
end

function UIActBanquetAttackMonsterHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BanquetReceiveBatLogData, self.OnReceiveBatLogData)
  self:AddUIListener(EventId.BanquetSuccessGetStashReward, self.OnSuccessGetStashReward)
end

function UIActBanquetAttackMonsterHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.BanquetReceiveBatLogData, self.OnReceiveBatLogData)
  self:RemoveUIListener(EventId.BanquetSuccessGetStashReward, self.OnSuccessGetStashReward)
  base.OnRemoveListener(self)
end

function UIActBanquetAttackMonsterHistoryView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActBanquetAttackMonsterHistoryView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActBanquetAttackMonsterHistoryView:OnBtnClaimStashRewardClick()
  if self.activityId then
    self.ctrl:ReqClaimStashReward(self.activityId)
  end
end

function UIActBanquetAttackMonsterHistoryView:OnSuccessGetStashReward(refreshStashReward)
  self:RefreshReward(refreshStashReward)
  self.compUICommonToggleList:UpdateRed()
end

function UIActBanquetAttackMonsterHistoryView:OnReceiveBatLogData()
  self:RefreshLog()
end

return UIActBanquetAttackMonsterHistoryView
