local UILimitDropHistoryView = BaseClass("UILimitDropHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local InfoExpandBarComponent = require("UI.UILimitDropHistory.Component.InfoExpandBarComponent")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGoupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local TAB_KEY_CONFIG = {
  [LimitDropHistoryTabType.NormalDrop] = "drop_record_board_page_name1",
  [LimitDropHistoryTabType.PayDrop] = "drop_record_board_page_name2"
}

function UILimitDropHistoryView:OnCreate()
  base.OnCreate(self)
  self.activityId = self:GetUserData() and toInt(self:GetUserData()) or -1
  self.festivalInterfaceCfg = UIActivityCenterCommonUtil.GetGetFestivalInterfaceCfgByActivity(self.activityId)
  self:ComponentDefine()
  self:DataDefine()
end

function UILimitDropHistoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILimitDropHistoryView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compCommonActivityPopUpBgPart = self.viewSkin:AddComponent(self, CommonActivityPopUpBgPart, 1)
  self.compItemRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.loopListView2ScrollViewRoot = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compFixedTopBar = self.viewSkin:AddComponent(self, InfoExpandBarComponent, 6)
  self.compFixedBottomBar = self.viewSkin:AddComponent(self, InfoExpandBarComponent, 7)
  self.scrollRectScrollViewRoot = self.viewSkin:AddComponent(self, UIScrollRect, 8)
  self.compViewport = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compUICommonTabGroup = self.viewSkin:AddComponent(self, UICommonTabGroup, 10)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compEmptyTipsText = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.compItemRoot:SetActive(false)
  local listInitDefaultPara = CS.SuperScrollView.LoopListViewInitParam.CopyDefaultInitParam()
  listInitDefaultPara.mDistanceForRecycle0 = 20
  listInitDefaultPara.mDistanceForRecycle1 = 20
  listInitDefaultPara.mDistanceForNew0 = 10
  listInitDefaultPara.mDistanceForNew1 = 10
  self.loopListView2ScrollViewRoot:InitListViewParam(0, function(loopView, index)
    return self:GetLogScrollItem(loopView, index)
  end, listInitDefaultPara)
  self.scrollRectScrollViewRoot:AddValueChangeListener(function()
    self:OnScrollRectValueChange()
  end)
  self.compUICommonTabGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style4Activity)
  self:InitTabGroup()
  self.compCommonActivityPopUpBgPart:InitByActivityId(self.activityId, UIWindowNames.UILimitDropHistory)
  self.textTitle:SetLocalText("drop_record_board_title")
end

function UILimitDropHistoryView:ComponentDestroy()
  self.compContent:RemoveAllComponentes()
  self.viewSkin = nil
  self.compCommonActivityPopUpBgPart = nil
  self.compItemRoot = nil
  self.loopListView2ScrollViewRoot = nil
  self.compContent = nil
  self.btnClose = nil
  self.compFixedTopBar = nil
  self.compFixedBottomBar = nil
  self.scrollRectScrollViewRoot = nil
  self.compViewport = nil
  self.compUICommonTabGroup = nil
  self.textTitle = nil
  self.btnPanel = nil
  self.compEmptyTipsText = nil
end

function UILimitDropHistoryView:DataDefine()
  self.expandDayDic = nil
  self.autoReqDataFlagDic = nil
end

function UILimitDropHistoryView:DataDestroy()
  self.expandDayDic = nil
  self.autoReqDataFlagDic = nil
end

function UILimitDropHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLimitedTimeFeastHistoryDataUpdate, self.OnHistoryDataUpdate)
  self:AddUIListener(EventId.ActLimitedTimeFestHistoryExpandStateChange, self.OnDayTitleItemExpandChange)
end

function UILimitDropHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActLimitedTimeFeastHistoryDataUpdate, self.OnHistoryDataUpdate)
  self:RemoveUIListener(EventId.ActLimitedTimeFestHistoryExpandStateChange, self.OnDayTitleItemExpandChange)
  base.OnRemoveListener(self)
end

function UILimitDropHistoryView:InitTabGroup()
  local groupList = self:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
    return false
  end
  
  self.compUICommonTabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function UILimitDropHistoryView:GetTabGroupList()
  self.tabList = {}
  table.insert(self.tabList, LimitDropHistoryTabType.NormalDrop)
  table.insert(self.tabList, LimitDropHistoryTabType.PayDrop)
  local tabCfg = UIActivityCenterCommonUtil.GetActivityTabGroupCfg(self.activityId)
  local groupList = {}
  for index, value in ipairs(self.tabList) do
    local temp = CommonTabGoupItemTemplate.New()
    local keyStr = TAB_KEY_CONFIG[value]
    temp.title = Localization:GetString(keyStr)
    temp.minWidth = 350
    temp.minHeight = 53
    temp.selectBgPath = tabCfg.selectPath
    temp.unSelectBgPath = tabCfg.unSelectPath
    groupList[index] = temp
  end
  return groupList
end

function UILimitDropHistoryView:OnGroupLoadFinsh()
  local defaultSelectTab = LimitDropHistoryTabType.NormalDrop
  if self.params and self.params.tabType then
    local canGoto = false
    for _, v in ipairs(self.tabList) do
      if v == self.params.tabType then
        canGoto = true
        break
      end
    end
    if canGoto then
      defaultSelectTab = self.params.tabType
    end
  end
  self.compUICommonTabGroup:SelectTab(defaultSelectTab)
end

function UILimitDropHistoryView:OnClickTab(index)
  self.expandDayDic = {}
  self.selectIndex = index
  self.curSelectTab = self.tabList[index]
  self:RefreshView()
  self:RefreshPreviewItemShowHide()
end

function UILimitDropHistoryView:RefreshView()
  if not self.activityId then
    return
  end
  if not self:IsExistAnyDayExpand() then
    local curDayIndex = self.ctrl:GetLastExistDataDayIndex(self.activityId, self.curSelectTab)
    self:SetDayExpandState(curDayIndex, true)
  end
  self:RefreshSkinView()
  self:RefreshLoopList()
end

function UILimitDropHistoryView:RefreshLoopList()
  self.autoReqDataFlagDic = self.autoReqDataFlagDic or {}
  local isHadReqForThisTab = self.autoReqDataFlagDic[self.curSelectTab]
  if not isHadReqForThisTab then
    self.autoReqDataFlagDic[self.curSelectTab] = true
  end
  local isUseCache = isHadReqForThisTab
  local dropDataList = self.ctrl:GetDayLogData(self.activityId, self.curSelectTab, self.expandDayDic, isUseCache)
  if not dropDataList then
    self.loopListView2ScrollViewRoot:SetListItemCount(0, false, false)
    self:ClearAllExpandState()
    self.compEmptyTipsText:SetActive(true)
    return
  end
  self.curDropDataList = dropDataList
  self.loopListView2ScrollViewRoot:SetListItemCount(#self.curDropDataList, false, false)
  self.loopListView2ScrollViewRoot:RefreshAllShownItem()
  if 0 < #self.curDropDataList then
    self.loopListView2ScrollViewRoot:MovePanelToItemIndex(#self.curDropDataList - 1, 0)
  end
  self.loopListView2ScrollViewRoot.unity_looplistview2:ForceUpdate()
  local isEmpty = self:IsEmptyData()
  self.compEmptyTipsText:SetActive(isEmpty)
end

function UILimitDropHistoryView:RefreshSkinView()
end

function UILimitDropHistoryView:RefreshTab()
end

function UILimitDropHistoryView:RefreshCurHistoryDay()
end

function UILimitDropHistoryView:GetLogScrollItem(loopView, index)
  index = index + 1
  if index < 1 or index > #self.curDropDataList then
    return nil
  end
  local item_data = self.curDropDataList[index]
  local prefabName, scriptName = self.ctrl:GetPrefabAndScriptName(item_data)
  if not prefabName or not scriptName then
    return nil
  end
  self.logItems = self.logItems or {}
  local item = loopView:NewListViewItem(prefabName)
  local nameStr = tostring(NameCount)
  NameCount = NameCount + 1
  local logItem = self.logItems[item.gameObject]
  if not logItem then
    item.gameObject.name = nameStr
    logItem = self.compContent:AddComponent(require(scriptName), nameStr)
    self.logItems[item.gameObject] = logItem
  else
    item.gameObject.name = nameStr
  end
  if logItem.SetData then
    logItem:SetData(item_data)
  end
  return item
end

function UILimitDropHistoryView:OnDayTitleItemExpandChange(params)
  local activityId = params.activityId
  local dayIndex = params.dayIndex
  local expandState = params.expandState
  if activityId ~= self.activityId then
    return
  end
  self:SetDayExpandState(dayIndex, expandState)
  self:RefreshLoopList()
end

function UILimitDropHistoryView:SetDayExpandState(day, expandState)
  self.expandDayDic = self.expandDayDic or {}
  self:ClearAllExpandState()
  self.expandDayDic[day] = expandState
end

function UILimitDropHistoryView:ClearAllExpandState()
  self.expandDayDic = self.expandDayDic or {}
  for k, v in pairs(self.expandDayDic) do
    self.expandDayDic[k] = false
  end
end

function UILimitDropHistoryView:GetDayExpandState(day)
  if not self.expandDayDic then
    return false
  end
  return self.expandDayDic[day]
end

function UILimitDropHistoryView:OnHistoryDataUpdate()
  if not self:IsExistAnyDayExpand() then
    local curDayIndex = self.ctrl:GetLastExistDataDayIndex(self.activityId, self.curSelectTab)
    self:SetDayExpandState(curDayIndex, true)
  end
  self:RefreshView()
end

function UILimitDropHistoryView:IsExistAnyDayExpand()
  if not self.expandDayDic then
    return false
  end
  for _, v in pairs(self.expandDayDic) do
    if v then
      return true
    end
  end
  return false
end

function UILimitDropHistoryView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILimitDropHistoryView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILimitDropHistoryView:OnScrollRectValueChange()
  self:RefreshPreviewItemShowHide()
end

function UILimitDropHistoryView:RefreshPreviewItemShowHide()
  if self:IsEmptyData() then
    self.compFixedTopBar:SetActive(false)
    self.compFixedBottomBar:SetActive(false)
    return
  end
  self:RefreshTopPreviewItemShowHide()
  self:RefreshBottomPreviewItemShowHide()
end

function UILimitDropHistoryView:IsEmptyData()
  return not self.curDropDataList or #self.curDropDataList <= 0
end

function UILimitDropHistoryView:RefreshTopPreviewItemShowHide()
  if not self.logItems then
    return
  end
  local firstItemObj = self.loopListView2ScrollViewRoot:GetShownItemByIndex(0)
  if not firstItemObj then
    return
  end
  local item = self.logItems[firstItemObj.gameObject]
  if not item then
    self.compFixedTopBar:SetActive(false)
    return
  end
  local itemType = item.type
  if not itemType then
    self.compFixedTopBar:SetActive(false)
    return
  end
  local itemData = item.itemData
  local customData = item.data
  if not customData or not itemData then
    self.compFixedTopBar:SetActive(false)
    return
  end
  if itemType == LimitDropHistoryItemType.DayTitleItem then
    local dayIndex = customData.dayIndex or 1
    local isExpandState = self:GetDayExpandState(dayIndex)
    if not isExpandState then
      self.compFixedTopBar:SetActive(false)
      return
    end
    local screenPos = PosConverse.UIWorldToScreenPos(item.transform.position)
    local localPoint = PosConverse.ScreenToUIPos(self.compViewport.rectTransform, screenPos)
    if 0 < localPoint.y then
      self.compFixedTopBar:SetActive(true)
      self.compFixedTopBar:SetData(itemData, true)
    else
      self.compFixedTopBar:SetActive(false)
    end
  else
    local fromTitleData = itemData.fromTitleData
    if fromTitleData then
      self.compFixedTopBar:SetActive(true)
      self.compFixedTopBar:SetData(fromTitleData, true)
    else
      self.compFixedTopBar:SetActive(false)
    end
  end
end

function UILimitDropHistoryView:RefreshBottomPreviewItemShowHide()
  if not self.logItems then
    return
  end
  local lastShowItemIndex = self.loopListView2ScrollViewRoot.unity_looplistview2.ShownItemCount
  local lastItemObj = self.loopListView2ScrollViewRoot:GetShownItemByIndex(lastShowItemIndex - 1)
  if not lastItemObj then
    return
  end
  local item = self.logItems[lastItemObj.gameObject]
  if not item then
    self.compFixedBottomBar:SetActive(false)
    return
  end
  local itemType = item.type
  if not itemType then
    self.compFixedBottomBar:SetActive(false)
    return
  end
  local itemData = item.itemData
  local customData = item.data
  if not customData or not itemData then
    self.compFixedBottomBar:SetActive(false)
    return
  end
  if itemType ~= LimitDropHistoryItemType.DayTitleItem then
    if itemData.fromTitleData and itemData.fromTitleData.nextTitleShowData then
      self.compFixedBottomBar:SetActive(true)
      self.compFixedBottomBar:SetData(itemData.fromTitleData.nextTitleShowData)
    else
      self.compFixedBottomBar:SetActive(false)
    end
  else
    local screenPos = PosConverse.UIWorldToScreenPos(item.transform.position)
    local localPoint = PosConverse.ScreenToUIPos(self.compViewport.rectTransform, screenPos)
    local viewportHeight = self.compViewport.rectTransform.rect.height
    local itemHeight = item.rectTransform.rect.height
    if localPoint.y - itemHeight < -viewportHeight then
      self.compFixedBottomBar:SetActive(true)
      self.compFixedBottomBar:SetData(itemData)
    else
      self.compFixedBottomBar:SetActive(false)
    end
  end
end

return UILimitDropHistoryView
