local base = UIBaseView
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UILWSeasonCityAltarSkillRankCell = require("UI.LWSeason6.UILWSeasonCityAltar.Rank.Comp.UILWSeasonCityAltarSkillRankCell")
local p_text_title_path = "SafeRoot/root/top/p_text_title"
local p_scroll_view_path = "SafeRoot/root/mid/content_rank/content_rank/p_list_view"
local p_comp_cur_path = "SafeRoot/root/mid/content_rank/content_rank/p_comp_cur"
local p_text_empty_path = "SafeRoot/root/mid/content_rank/p_text_empty"
local p_btn_close_path = "SafeRoot/root/bottom/p_btn_close"
local p_toggle_range_type_path = "SafeRoot/root/mid/p_toggle_range_type"
local p_toggle_rank_type_path = "SafeRoot/root/mid/p_toggle_rank_type"
local p_comp_rank_tab_path = "SafeRoot/root/bottom/content_tab/p_comp_rank_tab"
local TCCommonDropDown = require("UI/LWUITC/Component/TCCommonDropDownComponent")
local UILWS6CityAltarSkillRankView = BaseClass("UILWS6CityAltarSkillRankView", UIBaseView)

function UILWS6CityAltarSkillRankView:ComponentDefine()
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_scroll_view = self:AddComponent(UILoopListViewSimple, p_scroll_view_path)
  self.p_scroll_view:Init(UILWSeasonCityAltarSkillRankCell)
  self.p_comp_cur = self:AddComponent(UILWSeasonCityAltarSkillRankCell, p_comp_cur_path)
  self.p_text_empty = self:AddComponent(UITextMeshProUGUIEx, p_text_empty_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_toggle_rank_type = self:AddComponent(UICommonToggleListComponent, p_toggle_rank_type_path)
  self.p_comp_rank_tab = self:AddComponent(TCCommonDropDown, p_comp_rank_tab_path)
  self.p_btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UILWS6CityAltarSkillRankView:ComponentDestroy()
  self.p_text_title = nil
  self.p_scroll_view = nil
  self.p_comp_cur = nil
  self.p_text_empty = nil
  self.p_btn_close = nil
  self.p_toggle_rank_type = nil
  self.p_comp_rank_tab = nil
end

function UILWS6CityAltarSkillRankView:DataDefine()
  self.CurRankData = nil
end

function UILWS6CityAltarSkillRankView:DataDestroy()
  self.Data = nil
  DataCenter.SeasonCityAltarManager:ClearRankData()
end

function UILWS6CityAltarSkillRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function UILWS6CityAltarSkillRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWS6CityAltarSkillRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCityAltarSkillRankUpdate, self.OnGetRankCallback)
end

function UILWS6CityAltarSkillRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCityAltarSkillRankUpdate, self.OnGetRankCallback)
  base.OnRemoveListener(self)
end

function UILWS6CityAltarSkillRankView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWS6CityAltarSkillRankView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.CurRankToggleIndex = 0
    self.CurPeriodToggleType = 0
    return true
  end
  return false
end

function UILWS6CityAltarSkillRankView:InitUi()
  self:ResetUi()
  local actData = DataCenter.SeasonCityAltarManager.ActData
  if actData ~= nil then
    self.p_text_title:SetLocalText(actData.name)
  end
  self.p_scroll_view:Clear()
  self:InitToggleRankType(self.Data.DefaultTab or 1)
  self:InitDropDown(self.Data.DefaultDropDownIndex or 1)
end

function UILWS6CityAltarSkillRankView:ResetUi()
  self.p_text_empty:SetActive(true)
  self.p_comp_cur:SetActive(false)
  self.p_scroll_view:SetActive(false)
end

function UILWS6CityAltarSkillRankView:InitToggleRankType(defaultIndex)
  local tabDataList = DataCenter.SeasonCityAltarManager:GetSkillRankTypeTabData()
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
  
  self.CurRankToggleIndex = -1
  self.p_toggle_rank_type:ReInit(toggleListData)
end

function UILWS6CityAltarSkillRankView:OnRankTypeToggle(index, itemData)
  if self.CurRankToggleIndex ~= index then
    self.CurRankToggleIndex = index
    self:UpdateRankUi()
  end
end

function UILWS6CityAltarSkillRankView:InitDropDown(defaultIndex)
  local tabDataList = DataCenter.SeasonCityAltarManager.RankPeriodTypeData
  self.PeriodTypeTabs = {}
  for _, tab in pairs(tabDataList) do
    local tabData = {}
    tabData.PeriodType = tab.PeriodType
    tabData.name = CS.GameEntry.Localization:GetString(tab.TabLocKey)
    table.insert(self.PeriodTypeTabs, tabData)
  end
  self.p_comp_rank_tab:Clear()
  for _, tab in pairs(self.PeriodTypeTabs) do
    self.p_comp_rank_tab:Add(tab.name)
  end
  self.p_comp_rank_tab:BindIndexChangeEvent(function(index)
    self:OnPeriodTypeToggle(index)
  end)
  self.CurPeriodToggleType = -1
  local count = table.count(self.PeriodTypeTabs)
  defaultIndex = Mathf.Clamp(checknumber(defaultIndex), 1, count)
  self.p_comp_rank_tab:OnSelectIndexChange(defaultIndex)
end

function UILWS6CityAltarSkillRankView:OnPeriodTypeToggle(index, itemData)
  local periodType = self.PeriodTypeTabs[index].PeriodType
  if self.CurPeriodToggleType ~= periodType then
    self.CurPeriodToggleType = periodType
    self:UpdateRankUi()
  end
end

function UILWS6CityAltarSkillRankView:UpdateRankUi()
  local rankType = self:GetRealRankType()
  local periodTypeValid = 0 <= self.CurPeriodToggleType and self.CurPeriodToggleType <= 2
  if not periodTypeValid then
    return
  end
  self.p_scroll_view:Clear()
  self:ResetUi()
  if self:UpdateData() then
    self:UpdateUi()
  else
    DataCenter.SeasonCityAltarManager:SendGetRank(rankType, self.CurPeriodToggleType)
  end
end

function UILWS6CityAltarSkillRankView:GetRealRankType()
  return DataCenter.SeasonCityAltarManager:Index2RankType(self.CurRankToggleIndex)
end

function UILWS6CityAltarSkillRankView:UpdateData()
  local rankType = self:GetRealRankType()
  self.CurRankData = DataCenter.SeasonCityAltarManager:GetCacheRankData(rankType, self.CurPeriodToggleType)
  self.RankList = self.ctrl:ParseRankData(self.CurRankData)
  return self.RankList ~= nil
end

function UILWS6CityAltarSkillRankView:UpdateUi()
  self.p_scroll_view:Clear()
  local empty = #self.RankList <= 0
  self.p_text_empty:SetActive(empty)
  self.p_comp_cur:SetActive(not empty)
  self.p_scroll_view:SetActive(not empty)
  if not empty then
    local curData
    for k, rankData in pairs(self.RankList) do
      self.p_scroll_view:AddData(rankData)
      if curData == nil and rankData.uid == LuaEntry.Player.uid then
        curData = rankData
      end
    end
    self.p_scroll_view:Show()
    if curData == nil then
      curData = self.ctrl:GetSelfData(self.CurRankData)
    end
    if curData ~= nil then
      self.p_comp_cur:ReInit(curData, true)
    end
  end
end

function UILWS6CityAltarSkillRankView:OnBtnInfoClick()
  local actData = DataCenter.SeasonCityAltarManager.ActData
  if actData ~= nil then
    local tips = CS.GameEntry.Localization:GetString("zone_selection_location_help_2", checknumber(actData.para_3))
    local title = CS.GameEntry.Localization:GetString("zone_selection_location_help_1")
    UIUtil.ShowMessage(tips, 0, nil, nil, nil, nil, nil, title)
  end
end

function UILWS6CityAltarSkillRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWS6CityAltarSkillRankView:OnGetRankCallback(evtData)
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

return UILWS6CityAltarSkillRankView
