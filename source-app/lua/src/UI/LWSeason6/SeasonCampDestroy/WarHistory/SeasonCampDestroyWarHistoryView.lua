local SeasonCampDestroyWarHistoryView = BaseClass("SeasonCampDestroyWarHistoryView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local TabItem = require("UI.LWSeason6.SeasonCampDestroy.WarHistory.SeasonCampDestroyWarHistoryTabItem")
local HistoryItem = require("UI.LWSeason6.SeasonCampDestroy.WarHistory.SeasonCampDestroyWarHistoryIR")
local close_btn_path = "PopUpTitle/CloseBtn"
local scrollView_path = "PopUpTitle/Common_bg_orange2/ScrollView"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Content"
local no_data_path = "PopUpTitle/Common_bg_orange2/ScrollView/no_data"
local tab_path = "PopUpTitle/Common_bg_orange2/TopBar/Tab"
local tab_item_path = "PopUpTitle/Common_bg_orange2/TopBar/Tab/TabItem"

function SeasonCampDestroyWarHistoryView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self.listGO = {}
  self:ComponentDefine()
  SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarHistoryInfo)
end

function SeasonCampDestroyWarHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarHistoryInfo, self.UpdateData)
end

function SeasonCampDestroyWarHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarHistoryInfo, self.UpdateData)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyWarHistoryView:ComponentDefine()
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
  self.theTabItem:SetActive(false)
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

function SeasonCampDestroyWarHistoryView:ComponentDestroy()
  self:ClearItemCell()
  self.tabRoot:RemoveComponents(TabItem)
  self.theTabItem:GameObjectRecycleAll()
  self.close_btn = nil
end

function SeasonCampDestroyWarHistoryView:OnTabChanged(tabIndex)
  self.tabIndex = tabIndex
  self:UpdateData()
end

function SeasonCampDestroyWarHistoryView:UpdateData()
  local fightStartTime = DataCenter.SeasonDataManager.CrossDeclareWarStartTime
  if fightStartTime == nil or fightStartTime == 0 then
    fightStartTime = UITimeManager:GetInstance():GetServerTime() - 15 * OneDayTime * 1000
  end
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
    if a.startTime == b.startTime then
      if a.cityId == b.cityId then
        return a.serverId > b.serverId
      end
      return a.cityId > b.cityId
    end
    return a.startTime > b.startTime
  end)
  self.hisList = dataList
  self:DoDataFilter(tabIndex)
end

function SeasonCampDestroyWarHistoryView:DoDataFilter(tabIndex)
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

function SeasonCampDestroyWarHistoryView:OnInitScroll(go, index)
  local item = self.ScrollView:AddComponent(HistoryItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function SeasonCampDestroyWarHistoryView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    cellItem:SetActive(true)
    cellItem:ReInit(self.dataList[index + 1])
  end
end

function SeasonCampDestroyWarHistoryView:OnDestroyScrollItem(go, index)
end

function SeasonCampDestroyWarHistoryView:ClearItemCell()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  self.ScrollView:RemoveComponents(HistoryItem)
  self.content:DestroyChildNode()
end

return SeasonCampDestroyWarHistoryView
