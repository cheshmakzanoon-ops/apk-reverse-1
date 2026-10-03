local Season5DeclareCityHistoryView = BaseClass("Season5DeclareCityHistoryView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local TabItem = require("UI.LWSeason5.DeclareCity.Season5DeclareCityHistory.Component.Season5DeclareCityHistoryTabItem")
local HistoryItem = require("UI.LWSeason5.DeclareCity.Season5DeclareCityHistory.Component.Season5DeclareCityHistoryItem")
local close_btn_path = "PopUpTitle/CloseBtn"
local scrollView_path = "PopUpTitle/Common_bg_orange2/ScrollView"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Content"
local no_data_path = "PopUpTitle/Common_bg_orange2/ScrollView/no_data"
local tab_path = "PopUpTitle/Common_bg_orange2/TopBar/Tab"
local tab_item_path = "PopUpTitle/Common_bg_orange2/TopBar/Tab/TabItem"

function Season5DeclareCityHistoryView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self.listGO = {}
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarHistoryInfo)
end

function Season5DeclareCityHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareCityHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarHistoryInfo, self.UpdateData)
end

function Season5DeclareCityHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarHistoryInfo, self.UpdateData)
  base.OnRemoveListener(self)
end

function Season5DeclareCityHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel = self:AddComponent(UIButton, "panel")
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollView = self:AddComponent(UIScrollRect, scrollView_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.tabRoot = self:AddComponent(UIBaseContainer, tab_path)
  self.no_data = self:AddComponent(UIText, no_data_path)
  self.no_data:SetActive(false)
  self.no_data:SetLocalText("2010346")
  self.theTabItem = self.transform:Find(tab_item_path).gameObject
  self.theTabItem:GameObjectCreatePool()
  local goItem, theTabItem, theFirstTabItem
  for i = 1, 6 do
    local tabIndex = i
    goItem = self.theTabItem:GameObjectSpawn(self.tabRoot.transform)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
    theTabItem = self.tabRoot:AddComponent(TabItem, goItem.name)
    theTabItem:ReInit(tabIndex)
    theTabItem:SetOnValueChanged(function(tf)
      if tf then
        self:OnTabChanged(tabIndex)
      end
    end)
    if theFirstTabItem == nil then
      theFirstTabItem = theTabItem
    end
  end
  if self.tabIndex == nil and theFirstTabItem then
    theFirstTabItem:SetIsOn(true)
    if self.tabIndex == nil then
      self:OnTabChanged(1)
    end
  end
end

function Season5DeclareCityHistoryView:ComponentDestroy()
  self:ClearItemCell()
  self.tabRoot:RemoveComponents(TabItem)
  self.theTabItem:GameObjectRecycleAll()
  self.close_btn = nil
end

function Season5DeclareCityHistoryView:OnTabChanged(tabIndex)
  self.tabIndex = tabIndex
  self:UpdateData()
end

function Season5DeclareCityHistoryView:UpdateData()
  local fightStartTime = DataCenter.SeasonDataManager.CrossDeclareWarStartTime
  local tabIndex = self.tabIndex
  if tabIndex == nil then
    self.no_data:SetActive(true)
    return
  end
  if self.hisList ~= nil then
    self:DoDataFilter(tabIndex)
    return
  end
  local data = DataCenter.SeasonDataManager.CrossDeclareWarHistoryInfo
  if data == nil then
    self.no_data:SetActive(true)
    return
  end
  if data.hisList == nil or #data.hisList == 0 then
    self.no_data:SetActive(true)
    return
  end
  local weekTime = 7 * OneDayTime * 1000
  local dataList = data.hisList
  for k, v in ipairs(dataList) do
    if v and v.weekIndex == nil then
      v.weekIndex = math.min(6, math.max(1, math.ceil((v.startTime - fightStartTime) / weekTime)))
    end
  end
  table.sort(dataList, function(a, b)
    if a.endTime == b.endTime then
      if a.startTime == b.startTime then
        if a.cityId == b.cityId then
          return a.serverId > b.serverId
        end
        return a.cityId > b.cityId
      end
      return a.startTime > b.startTime
    end
    return a.endTime > b.endTime
  end)
  self.hisList = dataList
  self:DoDataFilter(tabIndex)
end

function Season5DeclareCityHistoryView:DoDataFilter(tabIndex)
  if self.hisList ~= nil then
    local dataList = {}
    for k, v in ipairs(self.hisList) do
      if v and v.weekIndex == tabIndex then
        table.insert(dataList, v)
      end
    end
    self.dataList = dataList
    self.content:SetItemCount(#self.dataList)
    self.content:ForceUpdate()
    self.ScrollView:SetVerticalNormalizedPosition(1)
    self.no_data:SetActive(#dataList == 0)
  else
    self.no_data:SetActive(true)
  end
end

function Season5DeclareCityHistoryView:OnInitScroll(go, index)
  local item = self.ScrollView:AddComponent(HistoryItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function Season5DeclareCityHistoryView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    cellItem:SetActive(true)
    cellItem:ReInit(self.dataList[index + 1])
  end
end

function Season5DeclareCityHistoryView:OnDestroyScrollItem(go, index)
end

function Season5DeclareCityHistoryView:ClearItemCell()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  self.ScrollView:RemoveComponents(HistoryItem)
  self.content:DestroyChildNode()
end

return Season5DeclareCityHistoryView
