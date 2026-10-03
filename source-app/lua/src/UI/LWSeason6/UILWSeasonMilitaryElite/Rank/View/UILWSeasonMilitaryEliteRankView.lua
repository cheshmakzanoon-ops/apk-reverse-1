local base = UIBaseView
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UILWSeasonMilitaryEliteRankItemCell = require("UI.LWSeason6.UILWSeasonMilitaryElite.Rank.Comp.UILWSeasonMilitaryEliteRankItemCell")
local p_text_title_path = "SafeRoot/root/top/p_text_title"
local p_scroll_view_path = "SafeRoot/root/mid/content_rank/content_rank/p_scroll_view"
local p_comp_cur_path = "SafeRoot/root/mid/content_rank/content_rank/p_comp_cur"
local p_text_empty_path = "SafeRoot/root/mid/content_rank/p_text_empty"
local p_btn_close_path = "SafeRoot/root/bottom/p_btn_close"
local p_toggle_range_type_path = "SafeRoot/root/mid/p_toggle_range_type"
local p_toggle_rank_type_path = "SafeRoot/root/mid/p_toggle_rank_type"
local p_comp_rank_tab_path = "SafeRoot/root/bottom/content_tab/p_comp_rank_tab"
local TCCommonDropDown = require("UI/LWUITC/Component/TCCommonDropDownComponent")
local UILWSeasonMilitaryEliteRankView = BaseClass("UILWSeasonMilitaryEliteRankView", UIBaseView)

function UILWSeasonMilitaryEliteRankView:ComponentDefine()
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_scroll_view = self:AddComponent(UIScrollView, p_scroll_view_path)
  self.p_comp_cur = self:AddComponent(UILWSeasonMilitaryEliteRankItemCell, p_comp_cur_path)
  self.p_text_empty = self:AddComponent(UITextMeshProUGUIEx, p_text_empty_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_toggle_range_type = self:AddComponent(UICommonToggleListComponent, p_toggle_range_type_path)
  self.p_toggle_rank_type = self:AddComponent(UICommonToggleListComponent, p_toggle_rank_type_path)
  self.p_comp_rank_tab = self:AddComponent(TCCommonDropDown, p_comp_rank_tab_path)
  self.p_btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.p_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.p_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function UILWSeasonMilitaryEliteRankView:ComponentDestroy()
  self.p_text_title = nil
  self.p_scroll_view = nil
  self.p_comp_cur = nil
  self.p_text_empty = nil
  self.p_btn_close = nil
  self.p_toggle_range_type = nil
  self.p_toggle_rank_type = nil
  self.p_comp_rank_tab = nil
end

function UILWSeasonMilitaryEliteRankView:DataDefine()
  self.CurRankData = nil
end

function UILWSeasonMilitaryEliteRankView:DataDestroy()
  self.Data = nil
end

function UILWSeasonMilitaryEliteRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function UILWSeasonMilitaryEliteRankView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryEliteRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnGetRankCallback)
end

function UILWSeasonMilitaryEliteRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnGetRankCallback)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryEliteRankView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryEliteRankView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.CurRangeToggleIndex = 0
    self.CurRankToggleIndex = 0
    self.CurPeriodToggleType = 0
    return true
  end
  return false
end

function UILWSeasonMilitaryEliteRankView:InitUi()
  self:ResetUi()
  local actData = DataCenter.SeasonMilitaryEliteManager:GetActData()
  self.p_text_title:SetLocalText(actData.name)
  local curState = DataCenter.SeasonMilitaryEliteManager:GetCurActState()
  if curState == DataCenter.SeasonMilitaryEliteManager.ActState.EndShow then
    self.p_text_title:SetLocalText("season_military_rank_Onlyshow")
  end
  self:ClearScroll()
  local defaultRankType = Mathf.Clamp(self.Data.DefaultTab or 1, 1, 2)
  self:InitToggleRangeType(defaultRankType)
  self:InitDropDown(self.Data.DefaultDropDownIndex)
end

function UILWSeasonMilitaryEliteRankView:ResetUi()
  self.p_text_empty:SetActive(true)
  self.p_comp_cur:SetActive(false)
  self.p_scroll_view:SetActive(false)
end

function UILWSeasonMilitaryEliteRankView:InitToggleRangeType(defaultIndex)
  local tabDataList = DataCenter.SeasonMilitaryEliteManager.RankViewTabRangeTypeData
  local tabs = {}
  for _, tab in pairs(tabDataList) do
    local tabData = {}
    tabData.name = CS.GameEntry.Localization:GetString(tab.TabLocKey)
    table.insert(tabs, tabData)
  end
  local toggleListData = {}
  toggleListData.itemsDataList = tabs
  toggleListData.defaultSelectIndex = defaultIndex
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnRangeTypeToggle(index, itemData)
  end
  
  self.p_toggle_range_type:ReInit(toggleListData)
end

function UILWSeasonMilitaryEliteRankView:OnRangeTypeToggle(index, itemData)
  if self.CurRangeToggleIndex ~= index then
    self.CurRangeToggleIndex = index
    self.CurRankToggleIndex = -1
    local defaultSubIndex = Mathf.Clamp(self.Data ~= nil and checknumber(self.Data.DefaultSubTab) or 1, 1, 7)
    self:InitToggleRankType(defaultSubIndex)
  end
end

function UILWSeasonMilitaryEliteRankView:InitToggleRankType(defaultIndex)
  local tabDataList = DataCenter.SeasonMilitaryEliteManager.RankViewTabRangeTypeData[self.CurRangeToggleIndex].RankType
  local tabs = {}
  for _, tab in pairs(tabDataList) do
    local tabData = {}
    tabData.name = CS.GameEntry.Localization:GetString(tab.TabLocKey)
    table.insert(tabs, tabData)
  end
  local toggleListData = {}
  toggleListData.itemsDataList = tabs
  toggleListData.defaultSelectIndex = defaultIndex
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnRankTypeToggle(index, itemData)
  end
  
  self.p_toggle_rank_type:ReInit(toggleListData)
  local focusIndex = Mathf.Clamp(defaultIndex - 1, 1, 7)
  self.p_toggle_rank_type:ScrollToIndexTab(focusIndex)
end

function UILWSeasonMilitaryEliteRankView:OnRankTypeToggle(index, itemData)
  if self.CurRankToggleIndex ~= index then
    self.CurRankToggleIndex = index
    self:UpdateRankUi()
  end
end

function UILWSeasonMilitaryEliteRankView:InitDropDown(defaultIndex)
  local tabDataList = DataCenter.SeasonMilitaryEliteManager.RankViewTabPeriodTypeData
  self.PeriodTypeTabs = {}
  local curActState = DataCenter.SeasonMilitaryEliteManager:GetCurActState()
  if curActState == DataCenter.SeasonMilitaryEliteManager.ActState.Normal then
    for _, tab in pairs(tabDataList) do
      local tabData = {}
      tabData.PeriodType = tab.PeriodType
      tabData.name = CS.GameEntry.Localization:GetString(tab.TabLocKey)
      table.insert(self.PeriodTypeTabs, tabData)
    end
  else
    local tabData = {}
    tabData.PeriodType = DataCenter.SeasonMilitaryEliteManager.PeriodType.Total
    tabData.name = CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc27")
    table.insert(self.PeriodTypeTabs, tabData)
  end
  self.p_comp_rank_tab:Clear()
  for _, tab in pairs(self.PeriodTypeTabs) do
    self.p_comp_rank_tab:Add(tab.name)
  end
  self.p_comp_rank_tab:BindIndexChangeEvent(function(index)
    self:OnPeriodTypeToggle(index)
  end)
  local count = table.count(self.PeriodTypeTabs)
  defaultIndex = Mathf.Clamp(checknumber(defaultIndex), 1, count)
  self.p_comp_rank_tab:OnSelectIndexChange(defaultIndex)
end

function UILWSeasonMilitaryEliteRankView:OnPeriodTypeToggle(index, itemData)
  local periodType = self.PeriodTypeTabs[index].PeriodType
  if self.CurPeriodToggleType ~= periodType then
    self.CurPeriodToggleType = periodType
    self:UpdateRankUi()
  end
end

function UILWSeasonMilitaryEliteRankView:UpdateRankUi()
  local rankType = self:GetRealRankType()
  local rankTypeValid = 101 <= rankType and rankType <= 116
  local periodTypeValid = 1 <= self.CurPeriodToggleType and self.CurPeriodToggleType <= 3
  if not rankTypeValid or not periodTypeValid then
    return
  end
  self:ClearScroll()
  self:ResetUi()
  if self:UpdateData() then
    self:UpdateUi()
  else
    DataCenter.SeasonMilitaryEliteManager:SendGetRank(rankType, self.CurPeriodToggleType, DataCenter.SeasonMilitaryEliteManager.RankMode.Full)
  end
end

function UILWSeasonMilitaryEliteRankView:GetRealRankType()
  return DataCenter.SeasonMilitaryEliteManager.RankViewTabRangeTypeData[self.CurRangeToggleIndex].RankType[self.CurRankToggleIndex].RankType
end

function UILWSeasonMilitaryEliteRankView:UpdateData()
  local rankType = self:GetRealRankType()
  self.CurRankData = DataCenter.SeasonMilitaryEliteManager:GetCacheRankData(rankType, self.CurPeriodToggleType, DataCenter.SeasonMilitaryEliteManager.RankMode.Full)
  self.RankList = self.ctrl:ParseRankData(self.CurRankData)
  return self.RankList ~= nil
end

function UILWSeasonMilitaryEliteRankView:UpdateUi()
  self:ClearScroll()
  local empty = #self.RankList <= 0
  self.p_text_empty:SetActive(empty)
  self.p_comp_cur:SetActive(not empty)
  self.p_scroll_view:SetActive(not empty)
  if not empty then
    self.p_scroll_view:SetTotalCount(#self.RankList)
    self.p_scroll_view:RefillCells()
    local curData
    for k, rank in pairs(self.RankList) do
      if self.CurRangeToggleIndex == DataCenter.SeasonMilitaryEliteManager.RangeType.Alliance and rank.allianceId == LuaEntry.Player.allianceId then
        curData = rank
        break
      end
      if self.CurRangeToggleIndex == DataCenter.SeasonMilitaryEliteManager.RangeType.Person and rank.uid == LuaEntry.Player.uid then
        curData = rank
        break
      end
    end
    if curData == nil then
      curData = self.ctrl:GetSelfData(self.CurRankData)
    end
    if curData ~= nil then
      self.p_comp_cur:SetData(curData, true)
    end
  end
end

function UILWSeasonMilitaryEliteRankView:ClearScroll()
  self.p_scroll_view:ClearCells()
  self.p_scroll_view:RemoveComponents(UILWSeasonMilitaryEliteRankItemCell)
end

function UILWSeasonMilitaryEliteRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.p_scroll_view:AddComponent(UILWSeasonMilitaryEliteRankItemCell, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.RankList[index], false)
  end
end

function UILWSeasonMilitaryEliteRankView:OnRankItemMoveOut(itemObj, index)
  self.p_scroll_view:RemoveComponent(itemObj.name, UILWSeasonMilitaryEliteRankItemCell)
end

function UILWSeasonMilitaryEliteRankView:OnBtnInfoClick()
  local actData = DataCenter.SeasonMilitaryEliteManager:GetActData()
  if actData ~= nil then
    local tips = CS.GameEntry.Localization:GetString("zone_selection_location_help_2", checknumber(actData.para_3))
    local title = CS.GameEntry.Localization:GetString("zone_selection_location_help_1")
    UIUtil.ShowMessage(tips, 0, nil, nil, nil, nil, nil, title)
  end
end

function UILWSeasonMilitaryEliteRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWSeasonMilitaryEliteRankView:OnGetRankCallback(evtData)
  if evtData == nil then
    return
  end
  local curRankType = self:GetRealRankType()
  local rankType = checknumber(evtData.RankType)
  local periodType = checknumber(evtData.PeriodType)
  if rankType == curRankType and periodType == self.CurPeriodToggleType and self:UpdateData() then
    self:UpdateUi()
  end
end

return UILWSeasonMilitaryEliteRankView
