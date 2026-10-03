local UIPlayerDownloadCenterProgressListView = BaseClass("UIPlayerDownloadCenterProgressListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UIPlayerDownloadCenterProgressListItem = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterProgressList.Component.UIPlayerDownloadCenterProgressListItem")
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")
local UIGray = CS.UIGray

function UIPlayerDownloadCenterProgressListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIPlayerDownloadCenterProgressListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterProgressListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.loopScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.scrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnPauseAll = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPauseAll:SetOnClick(function()
    self:OnBtnPauseAllClick()
  end)
  self.btnStartAll = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnStartAll:SetOnClick(function()
    self:OnBtnStartAllClick()
  end)
  self.textPauseAllName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textStartAlllName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.loopScrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 10)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textDownloadEmptyDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
end

function UIPlayerDownloadCenterProgressListView:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonToggleList = nil
  self.textTitle = nil
  self.btnClose = nil
  self.loopScrollView = nil
  self.scrollContent = nil
  self.btnPauseAll = nil
  self.btnStartAll = nil
  self.textPauseAllName = nil
  self.textStartAlllName = nil
  self.loopScrollRect = nil
  self.btnPanel = nil
  self.textDownloadEmptyDesc = nil
end

function UIPlayerDownloadCenterProgressListView:DataDefine()
  self.downloadTabCfg = self:GetUserData()
  self.tabCfgList = DataCenter.PlayerDownloadCenterManager:GetDownloadTabCfgList()
  self.curTabIndex = 1
  for i = 1, #self.tabCfgList do
    if self.tabCfgList[i].id == self.downloadTabCfg.id then
      self.curTabIndex = i
      break
    end
  end
  self:InitShowDataList()
  self.itemScriptDic = {}
  self.loopScrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
end

function UIPlayerDownloadCenterProgressListView:DataDestroy()
  self.curTabIndex = nil
  self.tabCfgList = nil
  self.showItemDataList = nil
  self.loopScrollView:ClearAllItems()
  self.scrollContent:RemoveComponents(UIPlayerDownloadCenterProgressListItem)
  self.itemScriptDic = nil
end

function UIPlayerDownloadCenterProgressListView:OnAddListener()
  base.OnAddListener(self)
end

function UIPlayerDownloadCenterProgressListView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterProgressListView:InitShowDataList()
  self.showItemDataList = {}
  self.curTabCfgId = self.tabCfgList[self.curTabIndex].id
  self.packageCfgList = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageCfgListByTabId(self.curTabCfgId)
  for i = 1, #self.packageCfgList do
    table.insert(self.showItemDataList, {
      packageCfg = self.packageCfgList[i]
    })
  end
end

function UIPlayerDownloadCenterProgressListView:RefreshView()
  self.textTitle:SetLocalText("download_center_list_title")
  self.textPauseAllName:SetLocalText("download_center_list_all_pause_btn")
  self.textStartAlllName:SetLocalText("download_center_list_all_begin_btn")
  self.textDownloadEmptyDesc:SetLocalText("download_center_list_empty")
  self:RefreshToggles()
  self:RefreshScrollView()
  self:RefreshBtnState()
end

function UIPlayerDownloadCenterProgressListView:RefreshToggles()
  if self.tabCfgList == nil then
    return
  end
  local itemsDataList = {}
  for i = 1, #self.tabCfgList do
    table.insert(itemsDataList, {
      name = Localization:GetString(self.tabCfgList[i].name or "")
    })
  end
  local toggleListData = {}
  toggleListData.itemsDataList = itemsDataList
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnSelectTabToggle(index, itemData)
  end
  
  toggleListData.defaultSelectIndex = self.curTabIndex
  self.compUICommonToggleList:ReInit(toggleListData)
  self.compUICommonToggleList:ScrollToIndexTab(self.curTabIndex)
end

function UIPlayerDownloadCenterProgressListView:RefreshScrollView()
  self.loopScrollRect:StopMovement()
  self.loopScrollRect:SetVerticalNormalizedPosition(1)
  self.loopScrollView:SetListItemCount(#self.showItemDataList, false, false)
  self.loopScrollView:RefreshAllShownItem()
  self.textDownloadEmptyDesc:SetActive(#self.showItemDataList <= 0)
end

function UIPlayerDownloadCenterProgressListView:RefreshBtnState()
  if self.packageCfgList == nil or #self.packageCfgList <= 0 then
    UIGray.SetGray(self.btnStartAll.transform, true, true)
    UIGray.SetGray(self.btnPauseAll.transform, true, true)
    return
  end
  local isAllStartBtnGray = true
  for i = 1, #self.packageCfgList do
    local packageCfg = self.packageCfgList[i]
    local downloadPackageState = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageState(packageCfg.id)
    isAllStartBtnGray = isAllStartBtnGray and (downloadPackageState == Const.DownloadState.Downloading or downloadPackageState == Const.DownloadState.Completed)
  end
  UIGray.SetGray(self.btnStartAll.transform, isAllStartBtnGray, true)
  local isAllPauseBtnGray = true
  for i = 1, #self.packageCfgList do
    local packageCfg = self.packageCfgList[i]
    local downloadPackageState = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageState(packageCfg.id)
    isAllPauseBtnGray = isAllPauseBtnGray and downloadPackageState ~= Const.DownloadState.Downloading
  end
  UIGray.SetGray(self.btnPauseAll.transform, isAllPauseBtnGray, true)
end

function UIPlayerDownloadCenterProgressListView:OnSelectTabToggle(index, itemData)
  if self.curTabIndex == index then
    return
  end
  self.curTabIndex = index
  self:InitShowDataList()
  self:RefreshScrollView()
  self:RefreshBtnState()
end

function UIPlayerDownloadCenterProgressListView:OnGetItemByIndex(listview, index)
  if index < 0 or index >= #self.showItemDataList then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UIPlayerDownloadCenterProgressListItem")
  if item == nil then
    Logger.LogError("\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 UIPlayerDownloadCenterProgressListItem")
    return
  end
  local temp = self.itemScriptDic[item]
  if temp == nil then
    NameCount = NameCount + 1
    item.gameObject.name = item.gameObject.name .. tostring(NameCount)
    temp = self.scrollContent:AddComponent(UIPlayerDownloadCenterProgressListItem, item.gameObject)
    temp:SetActive(true)
    self.itemScriptDic[item] = temp
  end
  temp:SetData(self.showItemDataList[index])
  return item
end

function UIPlayerDownloadCenterProgressListView:OnRecycleItemFunc(loopListViewItem)
end

function UIPlayerDownloadCenterProgressListView:Update1000MS()
  self:RefreshBtnState()
  EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadProgressListItem, {packageCfgId = -1})
end

function UIPlayerDownloadCenterProgressListView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function UIPlayerDownloadCenterProgressListView:OnBtnPauseAllClick()
  if self.packageCfgList == nil or #self.packageCfgList <= 0 then
    return
  end
  DataCenter.PlayerDownloadCenterManager:PauseAllTabPackageDownload(self.curTabCfgId)
  self:RefreshBtnState()
end

function UIPlayerDownloadCenterProgressListView:OnBtnStartAllClick()
  if self.packageCfgList == nil or #self.packageCfgList <= 0 then
    return
  end
  DataCenter.PlayerDownloadCenterManager:StartAllTabPackageDownload(self.curTabCfgId)
  self:RefreshBtnState()
end

return UIPlayerDownloadCenterProgressListView
