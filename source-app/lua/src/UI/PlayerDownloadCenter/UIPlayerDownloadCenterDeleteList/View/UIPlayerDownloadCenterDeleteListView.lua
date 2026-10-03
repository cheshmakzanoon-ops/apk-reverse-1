local UIPlayerDownloadCenterDeleteListView = BaseClass("UIPlayerDownloadCenterDeleteListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPlayerDownloadCenterDeleteListItem = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterDeleteList.Component.UIPlayerDownloadCenterDeleteListItem")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")

function UIPlayerDownloadCenterDeleteListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIPlayerDownloadCenterDeleteListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterDeleteListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.loopScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.scrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnDelete = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnDelete:SetOnClick(function()
    self:OnBtnDeleteClick()
  end)
  self.textDeleteName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.loopScrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 7)
  self.toggleSelectAll = self.viewSkin:AddComponent(self, UIToggle, 8)
  self.textSelectAllName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 10)
  self.textDeleteEmptyDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compSelectAll = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

function UIPlayerDownloadCenterDeleteListView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.loopScrollView = nil
  self.scrollContent = nil
  self.btnDelete = nil
  self.textDeleteName = nil
  self.loopScrollRect = nil
  self.toggleSelectAll = nil
  self.textSelectAllName = nil
  self.compUICommonToggleList = nil
  self.textDeleteEmptyDesc = nil
  self.compSelectAll = nil
  self.btnPanel = nil
end

function UIPlayerDownloadCenterDeleteListView:DataDefine()
  DataCenter.PlayerDownloadCenterManager:ClearToggleDeletePackageDic()
  self.tabCfgList = {}
  self.tabCfgList = DataCenter.PlayerDownloadCenterManager:GetDownloadTabCfgList()
  self.curTabIndex = 1
  self:InitShowDataList()
  self.itemScriptDic = {}
  self.toggleSelectAll:SetIsOn(false)
  self.toggleSelectAll:SetOnValueChanged(function(isOn)
    self:OnToggleValueChangedSelectAll(isOn)
  end)
  self.loopScrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
end

function UIPlayerDownloadCenterDeleteListView:DataDestroy()
  self.curTabIndex = nil
  self.tabCfgList = nil
  self.showItemDataList = nil
  self.loopScrollView:ClearAllItems()
  self.scrollContent:RemoveComponents(UIPlayerDownloadCenterDeleteListItem)
  self.itemScriptDic = nil
end

function UIPlayerDownloadCenterDeleteListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshPlayerDownloadDeleteList, self.RefreshDeleteState)
end

function UIPlayerDownloadCenterDeleteListView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshPlayerDownloadDeleteList, self.RefreshDeleteState)
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterDeleteListView:InitShowDataList()
  self.showItemDataList = {}
  self.curTabCfgId = self.tabCfgList[self.curTabIndex].id
  self.packageCfgList = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageTotalCfgListByTabId(self.curTabCfgId)
  for i = 1, #self.packageCfgList do
    local canDel = self:CanDeletePackage(self.packageCfgList[i])
    local resGroupData = DataCenter.PlayerDownloadCenterManager:GetResGroupData(self.packageCfgList[i].id)
    local downloadPackageState = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageState(self.packageCfgList[i].id)
    if downloadPackageState == nil then
      if CS.DownloadResGroupCommonManager.Instance:IsDownload(self.packageCfgList[i].id) then
        DataCenter.PlayerDownloadCenterManager:SetDownloadPackageState(self.packageCfgList[i].id, Const.DownloadState.Completed)
      else
        DataCenter.PlayerDownloadCenterManager:SetDownloadPackageState(self.packageCfgList[i].id, Const.DownloadState.Paused)
      end
    end
    local curResGroupSize = DataCenter.PlayerDownloadCenterManager:GetShowDownloadProgress(resGroupData)
    if 0 < curResGroupSize and canDel then
      table.insert(self.showItemDataList, {
        packageCfg = self.packageCfgList[i],
        curTabIndex = self.curTabIndex
      })
    end
  end
end

function UIPlayerDownloadCenterDeleteListView:CanDeletePackage(packageCfg)
  local canDel = packageCfg.can_del == 1 or packageCfg.can_del == 2
  local requiredPackages = CS.ResourcePackageManager.GetRequiredPackagesWithoutLog()
  if requiredPackages ~= nil and requiredPackages.Length > 0 then
    for i = 0, requiredPackages.Length - 1 do
      if requiredPackages[i] == packageCfg.pack_id then
        canDel = false
        break
      end
    end
  end
  return canDel
end

function UIPlayerDownloadCenterDeleteListView:RefreshView()
  self.textTitle:SetLocalText("download_center_del_title")
  self.textDeleteName:SetLocalText("download_center_del_button")
  self.textSelectAllName:SetLocalText("download_center_del_all")
  self.textDeleteEmptyDesc:SetLocalText("download_center_del_empty")
  self:RefreshToggles()
  self:RefreshScrollView()
end

function UIPlayerDownloadCenterDeleteListView:RefreshToggles()
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
  
  self.compUICommonToggleList:ReInit(toggleListData)
end

function UIPlayerDownloadCenterDeleteListView:RefreshScrollView()
  self.loopScrollRect:StopMovement()
  self.loopScrollRect:SetVerticalNormalizedPosition(1)
  self.loopScrollView:SetListItemCount(#self.showItemDataList, false, false)
  self.loopScrollView:RefreshAllShownItem()
  self.textDeleteEmptyDesc:SetActive(#self.showItemDataList <= 0)
  self.compSelectAll:SetActive(#self.showItemDataList > 0)
end

function UIPlayerDownloadCenterDeleteListView:RefreshDeleteState()
  self:InitShowDataList()
  self.loopScrollView:SetListItemCount(#self.showItemDataList, false, false)
  self.loopScrollView:RefreshAllShownItem()
  self.textDeleteEmptyDesc:SetActive(#self.showItemDataList <= 0)
  self.compSelectAll:SetActive(#self.showItemDataList > 0)
end

function UIPlayerDownloadCenterDeleteListView:OnSelectTabToggle(index, itemData)
  if self.curTabIndex == index then
    return
  end
  self.curTabIndex = index
  self:InitShowDataList()
  self:RefreshScrollView()
  local isSelect = self:GetToggleSelectAllState() or false
  self.toggleSelectAll:SetIsOnWithoutNotify(isSelect)
end

function UIPlayerDownloadCenterDeleteListView:GetToggleSelectAllState()
  local toggleDeletePackageDic = DataCenter.PlayerDownloadCenterManager:GetToggleDeletePackageDic()
  local isSelectAll = true
  for i = 1, #self.showItemDataList do
    isSelectAll = isSelectAll and toggleDeletePackageDic[self.showItemDataList[i].packageCfg.id]
    if not isSelectAll then
      return isSelectAll
    end
  end
  return isSelectAll
end

function UIPlayerDownloadCenterDeleteListView:OnGetItemByIndex(listview, index)
  if index < 0 or index >= #self.showItemDataList then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UIPlayerDownloadCenterDeleteListItem")
  if item == nil then
    Logger.LogError("\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 UIPlayerDownloadCenterDeleteListItem")
    return
  end
  local temp = self.itemScriptDic[item]
  if temp == nil then
    NameCount = NameCount + 1
    item.gameObject.name = item.gameObject.name .. tostring(NameCount)
    temp = self.scrollContent:AddComponent(UIPlayerDownloadCenterDeleteListItem, item.gameObject)
    temp:SetActive(true)
    self.itemScriptDic[item] = temp
  end
  temp:SetData(self.showItemDataList[index])
  local packageCfgId = self.showItemDataList[index].packageCfg.id
  local toggleDeletePackageDic = DataCenter.PlayerDownloadCenterManager:GetToggleDeletePackageDic()
  local isOn = toggleDeletePackageDic[packageCfgId] ~= nil and toggleDeletePackageDic[packageCfgId] or false
  temp:SetToggleState({
    setWithNotify = false,
    isOn = isOn,
    curTabIndex = self.curTabIndex
  })
  return item
end

function UIPlayerDownloadCenterDeleteListView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self.itemScriptDic[loopListViewItem]
  if script ~= nil and script.OnRecycleItem then
    script:OnRecycleItem()
  end
end

function UIPlayerDownloadCenterDeleteListView:OnToggleValueChangedSelectAll(isOn)
  for i = 1, #self.showItemDataList do
    local packageCfgId = self.showItemDataList[i].packageCfg.id
    DataCenter.PlayerDownloadCenterManager:SetToggleDeletePackageDic(packageCfgId, isOn)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadDeletePackage, {
    setWithNotify = false,
    isOn = isOn,
    curTabIndex = self.curTabIndex
  })
end

function UIPlayerDownloadCenterDeleteListView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function UIPlayerDownloadCenterDeleteListView:OnBtnDeleteClick()
  local packageCfgIdList = {}
  local toggleDeletePackageDic = DataCenter.PlayerDownloadCenterManager:GetToggleDeletePackageDic()
  for packageCfgId, state in pairs(toggleDeletePackageDic) do
    if state then
      DataCenter.PlayerDownloadCenterManager:SetPackageManualOperateType(packageCfgId, Const.ManualOperateType.Paused)
      table.insert(packageCfgIdList, packageCfgId)
    end
  end
  if #packageCfgIdList <= 0 then
    return
  end
  DataCenter.PlayerDownloadCenterManager:TryDeleteDownloadPackageList_Manual(packageCfgIdList)
end

return UIPlayerDownloadCenterDeleteListView
