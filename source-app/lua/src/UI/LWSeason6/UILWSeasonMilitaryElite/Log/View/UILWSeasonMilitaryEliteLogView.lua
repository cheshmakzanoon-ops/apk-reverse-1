local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local UILWSeasonMilitaryEliteLogCell = require("UI.LWSeason6.UILWSeasonMilitaryElite.Log.Comp.UILWSeasonMilitaryEliteLogCell")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UILWSeasonMilitaryEliteLogView = BaseClass("UILWSeasonMilitaryEliteLogView", UIBaseView)

function UILWSeasonMilitaryEliteLogView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textNoContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.listView = self.viewSkin:AddComponent(self, UILoopListView2, 4)
  self.transRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  local p_toggle_range_type_path = "safeArea/MiddleContentContainer/p_toggle_range_type"
  self.p_toggle_range_type = self:AddComponent(UICommonToggleListComponent, p_toggle_range_type_path)
end

function UILWSeasonMilitaryEliteLogView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnBack = nil
  self.textNoContent = nil
  self.listView = nil
  self.transRoot = nil
  self.p_toggle_range_type = nil
end

function UILWSeasonMilitaryEliteLogView:DataDefine()
end

function UILWSeasonMilitaryEliteLogView:DataDestroy()
  self.Data = nil
end

function UILWSeasonMilitaryEliteLogView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function UILWSeasonMilitaryEliteLogView:OnDestroy()
  DataCenter.SeasonMilitaryEliteManager:ClearLogCache()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryEliteLogView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryEliteLogUpdate, self.OnLogListUpdate)
end

function UILWSeasonMilitaryEliteLogView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryEliteLogUpdate, self.OnLogListUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryEliteLogView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryEliteLogView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.CurType = -1
    self.LogItems = {}
    self.NameIndex = 1
    return true
  end
  return false
end

function UILWSeasonMilitaryEliteLogView:InitUi()
  self.listView:InitListView(0, function(listView, index)
    return self:TryGetTableItem(listView, index)
  end)
  self.textTitle:SetLocalText("season_s5_activity_1200046_desc02")
  self.textNoContent:SetLocalText("season_s5_activity_1200046_desc29")
  self:SetListViewShow(false)
  self:InitToggle(self.Data.DefaultTab)
end

function UILWSeasonMilitaryEliteLogView:SetListViewShow(show)
  self.listView:SetActive(show)
  self.textNoContent:SetActive(not show)
end

function UILWSeasonMilitaryEliteLogView:TryGetTableItem(listView, index)
  index = index + 1
  if index < 1 or index > table.count(self.LogList) then
    return nil
  end
  local data = self.LogList[index]
  local csItem = listView:NewListViewItem("p_log_template")
  local cellItem = self.LogItems[csItem]
  if cellItem == nil then
    local goName = "LogItem_" .. self.NameIndex
    self.NameIndex = self.NameIndex + 1
    csItem.gameObject.name = goName
    cellItem = self.transRoot:AddComponent(UILWSeasonMilitaryEliteLogCell, goName)
    self.LogItems[csItem] = cellItem
  end
  if cellItem ~= nil then
    local logData = {}
    logData.LogData = data
    cellItem:ReInit(logData)
  end
  return csItem
end

function UILWSeasonMilitaryEliteLogView:InitToggle(defaultIndex)
  local tabs = {}
  for i = 1, 4 do
    local tabData = {}
    tabData.name = CS.GameEntry.Localization:GetString(DataCenter.SeasonMilitaryEliteManager.LogTabTitle[i])
    table.insert(tabs, tabData)
  end
  local toggleListData = {}
  toggleListData.itemsDataList = tabs
  toggleListData.defaultSelectIndex = defaultIndex
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnToggle(index)
  end
  
  self.p_toggle_range_type:ReInit(toggleListData)
end

function UILWSeasonMilitaryEliteLogView:OnToggleLoaded()
  local defaultTab = Mathf.Clamp(checknumber(self.Data.DefaultTab), 1, 4)
  self.compTabGroup:SelectTab(defaultTab)
end

function UILWSeasonMilitaryEliteLogView:OnToggle(index)
  if self.CurType == index then
    return
  end
  self:SetListViewShow(false)
  self.CurType = index
  if self:UpdateData() then
    self:UpdateUi()
  else
    DataCenter.SeasonMilitaryEliteManager:SendGetLog(self.CurType)
  end
end

function UILWSeasonMilitaryEliteLogView:UpdateData()
  self.LogList = DataCenter.SeasonMilitaryEliteManager:GetCacheLogData(self.CurType)
  return not table.IsNullOrEmpty(self.LogList)
end

function UILWSeasonMilitaryEliteLogView:ClearScroll()
  self.LogItems = {}
  self.transRoot:RemoveComponents(UILWSeasonMilitaryEliteLogCell)
  self.listView:ClearAllItems()
end

function UILWSeasonMilitaryEliteLogView:UpdateUi()
  self:SetListViewShow(true)
  self:ClearScroll()
  self.listView:SetListItemCount(#self.LogList, false, false)
end

function UILWSeasonMilitaryEliteLogView:Update1000MS()
end

function UILWSeasonMilitaryEliteLogView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UILWSeasonMilitaryEliteLogView:OnLogListUpdate(evtData)
  local logType = evtData
  if logType == self.CurType and self:UpdateData() then
    self:UpdateUi()
  end
end

return UILWSeasonMilitaryEliteLogView
