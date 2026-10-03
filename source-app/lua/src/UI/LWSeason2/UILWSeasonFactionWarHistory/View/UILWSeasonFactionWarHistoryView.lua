local UILWSeasonFactionWarHistoryView = BaseClass("UILWSeasonFactionWarHistoryView", UIBaseView)
local base = UIBaseView
local theHistoryData = {}
local Localization = CS.GameEntry.Localization
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData
local HistoryItem = require("UI.LWSeason2.UILWSeasonFactionWarHistory.Component.UILWSeasonFactionWarHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local scroll_view_path = "Root/MiddleContent/ScrollView"
local content_path = "Root/MiddleContent/ScrollView/Viewport/Content"
local tab_item1_path = "Root/Tab/TabItem1"
local tab_item2_path = "Root/Tab/TabItem2"
local drop_round_path = "Root/Tab/drop_round"
local empty_path = "Root/MiddleContent/Empty"

function UILWSeasonFactionWarHistoryView:OnCreate()
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

function UILWSeasonFactionWarHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionBattleHistory, self.OnBattleHistory)
end

function UILWSeasonFactionWarHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionBattleHistory, self.OnBattleHistory)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionWarHistoryView:ComponentDefine()
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
          SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionBattleHistory, 1, self.activeRound)
        else
          SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionBattleHistory, 0, self.activeRound)
        end
        self:OnBattleHistory(nil)
      end
    end)
  else
    self.maxRound = 1
    self.activeRound = 1
    self.drop_round:SetActive(false)
  end
end

function UILWSeasonFactionWarHistoryView:OnTabChanged(tabIndex)
  self.tabIndex = tabIndex
  if tabIndex == 1 then
    self.drop_round:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionBattleHistory, 1, self.activeRound)
  else
    self.drop_round:SetActive(1 < self.maxRound)
    SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionBattleHistory, 0, self.activeRound)
  end
  self:OnBattleHistory(nil)
end

function UILWSeasonFactionWarHistoryView:ComponentDestroy()
  self:RemoveItems()
  self.drop_round:Clear()
  self.content = nil
  self.close_btn = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.drop_round = nil
end

function UILWSeasonFactionWarHistoryView:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(HistoryItem)
  self.ScrollView:ClearAllItems()
end

function UILWSeasonFactionWarHistoryView:OnBattleHistory(t)
  local key = ""
  if t and t.list then
    key = t.round .. "_" .. t.type
    theHistoryData[key] = t.list
  end
  if self.tabIndex == 1 then
    key = self.activeRound .. "_1"
  else
    key = self.activeRound .. "_0"
  end
  local dataList = theHistoryData[key] or {}
  local dataCount = #dataList
  if 0 < dataCount then
    self.dataList = dataList
    self.empty:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetListItemCount(dataCount, true, false)
    self.ScrollView:RefreshAllShownItem()
  else
    self.empty:SetActive(true)
    self.ScrollView:SetActive(false)
  end
end

function UILWSeasonFactionWarHistoryView:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("FactionWarBattleHistoryItem")
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

return UILWSeasonFactionWarHistoryView
