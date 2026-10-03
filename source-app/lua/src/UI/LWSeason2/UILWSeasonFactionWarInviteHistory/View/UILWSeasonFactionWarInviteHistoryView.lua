local UILWSeasonFactionWarInviteHistoryView = BaseClass("UILWSeasonFactionWarInviteHistoryView", UIBaseView)
local base = UIBaseView
local hasDataALL = {}
local theHistoryData = {}
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData
local HistoryItem = require("UI.LWSeason2.UILWSeasonFactionWarInviteHistory.Component.UILWSeasonFactionWarInviteHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local scroll_view_path = "Root/MiddleContent/ScrollView"
local content_path = "Root/MiddleContent/ScrollView/Viewport/Content"
local tab_item1_path = "Root/Tab/TabItem1"
local tab_item2_path = "Root/Tab/TabItem2"
local drop_round_path = "Root/Tab/drop_round"
local empty_path = "Root/MiddleContent/Empty"

function UILWSeasonFactionWarInviteHistoryView:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self.dataList = {}
  self:ComponentDefine()
  if self.tabIndex == nil then
    self.tab_item1:SetIsOn(true)
    if self.tabIndex == nil then
      self:OnTabChanged(1)
    end
  end
end

function UILWSeasonFactionWarInviteHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarInviteHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionInviteHistoryUpdate, self.OnInviteHistory)
end

function UILWSeasonFactionWarInviteHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionInviteHistoryUpdate, self.OnInviteHistory)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionWarInviteHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.empty = self:AddComponent(UITextMeshProUGUIEx, empty_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.drop_round = self:AddComponent(UIDropdown, drop_round_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
  if actInfo and actInfo.currStep ~= nil and toInt(actInfo.round) > 1 then
    for round = 1, actInfo.round do
      local temp = OptionData()
      temp.text = Localization:GetString("312094", round)
      self.drop_round:Add(temp)
    end
    self.maxRound = toInt(actInfo.round)
    self.activeRound = toInt(actInfo.round)
    self.drop_round:SetActive(true)
    self.drop_round:SetText(Localization:GetString("312094", actInfo.round))
    self.drop_round:SetValue(self.activeRound - 1)
    self.drop_round:SetOnValueChanged(function(selectedIndex)
      if self.activeRound ~= selectedIndex + 1 then
        self.activeRound = selectedIndex + 1
        self.drop_round:SetText(Localization:GetString("312094", self.activeRound))
        if self.tabIndex == 1 then
          SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarInviteHistory, 0, 100, 0, self.activeRound)
        else
          SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarInviteHistory, 0, 100, 1, self.activeRound)
        end
        self:OnInviteHistory(nil)
      end
    end)
  else
    self.maxRound = 1
    self.activeRound = 1
    self.drop_round:SetActive(false)
  end
end

function UILWSeasonFactionWarInviteHistoryView:OnTabChanged(tabIndex)
  self.tabIndex = tabIndex
  if tabIndex == 1 then
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarInviteHistory, 0, 100, 0, self.activeRound)
  else
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarInviteHistory, 0, 100, 1, self.activeRound)
  end
  self:OnInviteHistory(nil)
end

function UILWSeasonFactionWarInviteHistoryView:ComponentDestroy()
  self:RemoveItems()
  self.drop_round:Clear()
  self.content = nil
  self.close_btn = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.drop_round = nil
end

function UILWSeasonFactionWarInviteHistoryView:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(HistoryItem)
  self.ScrollView:ClearAllItems()
end

function UILWSeasonFactionWarInviteHistoryView:OnInviteHistory(t)
  local hasNewData = false
  local myAlId = LuaEntry.Player.allianceId
  if t and t.pageNum and t.pageSize and t.list then
    for k, v in pairs(t.list) do
      if theHistoryData[v.uuid] == nil then
        hasNewData = true
        v.round = t.round
        v.pageType = t.pageType
        theHistoryData[v.uuid] = v
      end
    end
    local key = string.format("%s_%s", self.tabIndex, self.activeRound)
    if hasDataALL[key] and not hasNewData then
      return
    end
    if #t.list >= t.pageSize then
      if self.tabIndex == 1 then
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarHistory, t.pageNum + 1, 100, 0, self.activeRound)
      else
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarHistory, t.pageNum + 1, 100, 1, self.activeRound)
      end
    else
      hasDataALL[key] = true
    end
    if not hasNewData then
      return
    end
  end
  local dataList = {}
  for k, v in pairs(theHistoryData) do
    if self.activeRound == 0 or self.activeRound == v.round then
      if self.tabIndex == 1 and v.pageType == 0 then
        table.insert(dataList, v)
      elseif self.tabIndex == 2 and v.pageType == 1 then
        table.insert(dataList, v)
      end
    end
  end
  local dataCount = #dataList
  if 0 < dataCount then
    table.sort(dataList, function(a, b)
      return a.eventTime > b.eventTime
    end)
    self.dataList = dataList
    self.empty:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetListItemCount(#self.dataList, hasNewData or t == nil, false)
    self.ScrollView:RefreshAllShownItem()
  else
    self.empty:SetActive(true)
    self.ScrollView:SetActive(false)
  end
end

function UILWSeasonFactionWarInviteHistoryView:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("FactionWarInviteHistoryItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "HistoryItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(HistoryItem, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, dataList[index])
  end
  return csItem
end

return UILWSeasonFactionWarInviteHistoryView
