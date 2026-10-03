local base = UIBaseView
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local SeasonMoneyRankItemCell = require("UI.LWSeason5.UILWSeasonMoneyRank.Rank.Comp.SeasonMoneyRankRankItemCell")
local p_text_title_path = "SafeRoot/root/top/p_text_title"
local p_text_title_rank_path = "SafeRoot/root/mid/content_rank/content_title/p_text_title_rank"
local p_text_title_name_path = "SafeRoot/root/mid/content_rank/content_title/p_text_title_name"
local p_text_title_score_path = "SafeRoot/root/mid/content_rank/content_title/p_text_title_score"
local p_scroll_view_path = "SafeRoot/root/mid/content_rank/content_rank/p_scroll_view"
local p_comp_cur_path = "SafeRoot/root/mid/content_rank/content_rank/p_comp_cur"
local p_text_empty_path = "SafeRoot/root/mid/content_rank/p_text_empty"
local p_btn_close_path = "SafeRoot/root/bottom/p_btn_close"
local p_toggle_range_type_path = "SafeRoot/root/mid/p_toggle_range_type"
local p_toggle_rank_type_path = "SafeRoot/root/mid/p_toggle_rank_type"
local p_comp_rank_tab_path = "SafeRoot/root/bottom/content_tab/p_comp_rank_tab"
local TCCommonDropDown = require("UI/LWUITC/Component/TCCommonDropDownComponent")
local SeasonMoneyRankRankView = BaseClass("SeasonMoneyRankRankView", UIBaseView)

function SeasonMoneyRankRankView:ComponentDefine()
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_text_title_rank = self:AddComponent(UITextMeshProUGUIEx, p_text_title_rank_path)
  self.p_text_title_name = self:AddComponent(UITextMeshProUGUIEx, p_text_title_name_path)
  self.p_text_title_score = self:AddComponent(UITextMeshProUGUIEx, p_text_title_score_path)
  self.p_scroll_view = self:AddComponent(UIScrollView, p_scroll_view_path)
  self.p_comp_cur = self:AddComponent(SeasonMoneyRankItemCell, p_comp_cur_path)
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

function SeasonMoneyRankRankView:ComponentDestroy()
  self.p_text_title = nil
  self.p_text_title_rank = nil
  self.p_text_title_name = nil
  self.p_text_title_score = nil
  self.p_scroll_view = nil
  self.p_comp_cur = nil
  self.p_text_empty = nil
  self.p_btn_close = nil
  self.p_toggle_range_type = nil
  self.p_toggle_rank_type = nil
  self.p_comp_rank_tab = nil
end

function SeasonMoneyRankRankView:DataDefine()
  self.Keys = {}
  self.Tab = -1
  self.CurRankData = nil
  local rankTypeEnum = DataCenter.SeasonMoneyRankManager.RankType
  self.LocKeys = {
    [rankTypeEnum.AllPerson] = {
      rankTitle = "zone_selection_location_UI_27",
      nameTitle = "zone_selection_location_UI_28",
      scoreTitle = "zone_selection_location_UI_29"
    },
    [rankTypeEnum.BankManage] = {
      rankTitle = "zone_selection_location_UI_27",
      nameTitle = "zone_selection_location_UI_30",
      scoreTitle = "zone_selection_location_UI_31"
    },
    [rankTypeEnum.Shoot] = {
      rankTitle = "zone_selection_location_UI_27",
      nameTitle = "zone_selection_location_UI_28",
      scoreTitle = "zone_selection_location_UI_29"
    },
    [rankTypeEnum.Train] = {
      rankTitle = "zone_selection_location_UI_27",
      nameTitle = "zone_selection_location_UI_28",
      scoreTitle = "zone_selection_location_UI_29"
    }
  }
end

function SeasonMoneyRankRankView:DataDestroy()
  self.Data = nil
end

function SeasonMoneyRankRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function SeasonMoneyRankRankView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMoneyRankRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMoneyRankRankUpdate, self.OnGetRankCallback)
end

function SeasonMoneyRankRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMoneyRankRankUpdate, self.OnGetRankCallback)
  base.OnRemoveListener(self)
end

function SeasonMoneyRankRankView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonMoneyRankRankView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.CurRangeToggleIndex = 0
    self.CurRankToggleIndex = 0
    self.CurPeriodToggleIndex = 0
    return true
  end
  return false
end

function SeasonMoneyRankRankView:InitUi()
  self:ResetUi()
  self.p_text_title:SetLocalText("season_s5_activity_1200046_name")
  self:ClearScroll()
  local defaultRankType = self.Data.DefaultTab or 1
  self:InitToggleRangeType(defaultRankType)
  self:InitDropDown(1)
end

function SeasonMoneyRankRankView:ResetUi()
  self.p_text_empty:SetActive(true)
  self.p_comp_cur:SetActive(false)
  self.p_scroll_view:SetActive(false)
end

function SeasonMoneyRankRankView:InitToggleRangeType(defaultIndex)
  local tabDataList = DataCenter.SeasonMoneyRankManager.RankViewTabRangeTypeData
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

function SeasonMoneyRankRankView:OnRangeTypeToggle(index, itemData)
  if self.CurRangeToggleIndex ~= index then
    self.CurRangeToggleIndex = index
    self.CurRankToggleIndex = -1
    self:InitToggleRankType(1)
  end
end

function SeasonMoneyRankRankView:InitToggleRankType(defaultIndex)
  local tabDataList = DataCenter.SeasonMoneyRankManager.RankViewTabRangeTypeData[self.CurRangeToggleIndex].RankType
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
end

function SeasonMoneyRankRankView:OnRankTypeToggle(index, itemData)
  if self.CurRankToggleIndex ~= index then
    self.CurRankToggleIndex = index
    self:UpdateRankUi()
  end
end

function SeasonMoneyRankRankView:InitDropDown(defaultIndex)
  local tabDataList = DataCenter.SeasonMoneyRankManager.RankViewTabPeriodTypeData
  self.PeriodTypeTabs = {}
  for _, tab in pairs(tabDataList) do
    local tabData = {}
    tabData.PeriodType = tab.PeriodType
    tabData.name = CS.GameEntry.Localization:GetString(tab.TabLocKey)
    table.insert(self.PeriodTypeTabs, tabData)
  end
  local curActState = DataCenter.SeasonMoneyRankManager:GetCurActState()
  if curActState == DataCenter.SeasonMoneyRankManager.ActState.EndShow then
    table.clear(self.PeriodTypeTabs)
    self.PeriodTypeTabs = {}
    local tabData = {}
    tabData.PeriodType = DataCenter.SeasonMoneyRankManager.PeriodType.Total
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
  self.p_comp_rank_tab:OnSelectIndexChange(defaultIndex)
end

function SeasonMoneyRankRankView:OnPeriodTypeToggle(index, itemData)
  local periodType = self.PeriodTypeTabs[index].PeriodType
  if self.CurPeriodToggleIndex ~= periodType then
    self.CurPeriodToggleIndex = periodType
    self:UpdateRankUi()
  end
end

function SeasonMoneyRankRankView:UpdateRankUi()
  local rankType = self:GetRealRankType()
  local rankTypeValid = 1 <= rankType and rankType <= 9
  local periodTypeValid = 1 <= self.CurPeriodToggleIndex and self.CurPeriodToggleIndex <= 3
  if not rankTypeValid or not periodTypeValid then
    return
  end
  self:ClearScroll()
  self:ResetUi()
  self:UpdateTitle()
  if self:UpdateData() then
    self:UpdateUi()
  else
    DataCenter.SeasonMoneyRankManager:SendGetRank(rankType, self.CurPeriodToggleIndex, DataCenter.SeasonMoneyRankManager.RankMode.Full)
  end
end

function SeasonMoneyRankRankView:UpdateTitle()
  self.p_text_title_rank:SetLocalText("302043")
  if self.CurRangeToggleIndex == DataCenter.SeasonMoneyRankManager.RangeType.Alliance then
    self.p_text_title_name:SetLocalText("season_s5_activity_1200046_desc28")
  else
    self.p_text_title_name:SetLocalText("season_s4_activity_1200010_desc23")
  end
  self.p_text_title_score:SetLocalText("season_s5_activity_1200046_desc19")
end

function SeasonMoneyRankRankView:GetRealRankType()
  return DataCenter.SeasonMoneyRankManager.RankViewTabRangeTypeData[self.CurRangeToggleIndex].RankType[self.CurRankToggleIndex].RankType
end

function SeasonMoneyRankRankView:UpdateData()
  local rankType = self:GetRealRankType()
  self.CurRankData = DataCenter.SeasonMoneyRankManager:GetCacheRankData(rankType, self.CurPeriodToggleIndex, DataCenter.SeasonMoneyRankManager.RankMode.Full)
  self.RankList = self.ctrl:ParseRankData(self.CurRankData)
  return self.RankList ~= nil
end

function SeasonMoneyRankRankView:UpdateUi()
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
      if self.CurRangeToggleIndex == DataCenter.SeasonMoneyRankManager.RangeType.Alliance and rank.allianceId == LuaEntry.Player.allianceId then
        curData = rank
        break
      end
      if self.CurRangeToggleIndex == DataCenter.SeasonMoneyRankManager.RangeType.Person and rank.uid == LuaEntry.Player.uid then
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

function SeasonMoneyRankRankView:ClearScroll()
  self.p_scroll_view:ClearCells()
  self.p_scroll_view:RemoveComponents(SeasonMoneyRankItemCell)
end

function SeasonMoneyRankRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.p_scroll_view:AddComponent(SeasonMoneyRankItemCell, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.RankList[index], false)
  end
end

function SeasonMoneyRankRankView:OnRankItemMoveOut(itemObj, index)
  self.p_scroll_view:RemoveComponent(itemObj.name, SeasonMoneyRankItemCell)
end

function SeasonMoneyRankRankView:OnBtnInfoClick()
  local actData = DataCenter.SeasonTetrisManager:GetActData()
  if actData ~= nil then
    local tips = CS.GameEntry.Localization:GetString("zone_selection_location_help_2", checknumber(actData.para_3))
    local title = CS.GameEntry.Localization:GetString("zone_selection_location_help_1")
    UIUtil.ShowMessage(tips, 0, nil, nil, nil, nil, nil, title)
  end
end

function SeasonMoneyRankRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function SeasonMoneyRankRankView:OnGetRankCallback(evtData)
  if evtData == nil then
    return
  end
  local curRankType = self:GetRealRankType()
  local rankType = checknumber(evtData.RankType)
  local periodType = checknumber(evtData.PeriodType)
  if rankType == curRankType and periodType == self.CurPeriodToggleIndex and self:UpdateData() then
    self:UpdateUi()
  end
end

return SeasonMoneyRankRankView
