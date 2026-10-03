local UILWCrossServerAttackCityRankView = BaseClass("UILWCrossServerAttackCityRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RankItem = require("UI.LWSeason1.UILWCrossServerAttackCityRank.Component.UILWCrossServerAttackCityRankItem")
local TabItem = require("UI.LWSeason1.UILWCrossServerAttackCityRank.Component.UILWCrossServerAttackCityTabItem")
local last_rank_index = 1
local week_index_1 = 1
local week_index_2 = 1
local ally_toggle_1 = false
local ally_toggle_2 = false
local btn_back_white_path = "safeArea/BottomBar/BtnBackWhite"
local my_ally_toggle_path = "safeArea/BottomBar/MyAllyToggle"
local rect_scroll_path = "safeArea/panelContainer/RectScroll"
local content_path = "safeArea/panelContainer/RectScroll/ViewPort/Content"
local self_obj_path = "safeArea/panelContainer/SelfObj"
local text_title_path = "safeArea/TopBar/TextTitle"
local toggle1_path = "safeArea/TopBar/subTabSv/Toggle1"
local toggle2_path = "safeArea/TopBar/subTabSv/Toggle2"
local toggle3_path = "safeArea/TopBar/subTabSv/Toggle3"
local toggle4_path = "safeArea/TopBar/subTabSv/Toggle4"
local toggle5_path = "safeArea/TopBar/subTabSv/Toggle5"
local toggle6_path = "safeArea/TopBar/subTabSv/Toggle6"
local tab1_path = "safeArea/TopBar/mainTabSv/Viewport/Content/Tab1"
local tab2_path = "safeArea/TopBar/mainTabSv/Viewport/Content/Tab2"
local text_title1_path = "safeArea/TopBar/BG2/TextTitle1"
local text_title2_path = "safeArea/TopBar/BG2/TextTitle2"
local text_title3_path = "safeArea/TopBar/BG2/TextTitle3"
local info_btn_path = "safeArea/TopBar/BG2/InfoBtn"
local loading_path = "safeArea/panelContainer/loading"
local txt_empty_path = "safeArea/panelContainer/TxtEmpty"

function UILWCrossServerAttackCityRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local nowWeek = 1
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonCrossAttackCityActivity.Type)
  if activityData then
    local para_5 = toInt(activityData.para_5)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local startTime = toInt(activityData.startTime)
    nowWeek = math.ceil((curTime - startTime) / OneWeekTime / 1000)
    if para_5 == 0 then
      last_rank_index = 1
      self.tab2:SetActive(false)
    else
      self.tab2:SetActive(true)
    end
  end
  self.isFilterOn = ally_toggle_1
  self.txt_empty:SetActive(false)
  self.my_ally_toggle:SetIsOn(ally_toggle_1)
  self.toggle1:ReInit(nowWeek, 1, self)
  self.toggle2:ReInit(nowWeek, 2, self)
  self.toggle3:ReInit(nowWeek, 3, self)
  self.toggle4:ReInit(nowWeek, 4, self)
  self.toggle5:ReInit(nowWeek, 5, self)
  self.toggle6:ReInit(nowWeek, 0, self)
  self.tab1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnRankTypeChanged(1)
    end
  end)
  self.tab2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnRankTypeChanged(2)
    end
  end)
  self.my_ally_toggle:SetOnValueChanged(function(isOn)
    self:OnDataFilter(isOn)
  end)
  self.my_ally_toggle:SetActive(false)
  self.loading:SetActive(true)
  if last_rank_index == 1 then
    self.tab1:SetIsOn(true)
    self:OnRankTypeChanged(1)
  else
    self.tab2:SetIsOn(true)
    self:OnRankTypeChanged(2)
  end
  if self.rank_type == nil or self.week_index == nil then
    self:OnRankTypeChanged(last_rank_index)
  end
end

function UILWCrossServerAttackCityRankView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWCrossServerAttackCityRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonRankUpdateNew, self.OnRankUpdate)
end

function UILWCrossServerAttackCityRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonRankUpdateNew, self.OnRankUpdate)
  base.OnRemoveListener(self)
end

function UILWCrossServerAttackCityRankView:ComponentDefine()
  self.txt_empty = self:AddComponent(UITextMeshProUGUIEx, txt_empty_path)
  self.loading = self:AddComponent(UIBaseComponent, loading_path)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_title:SetLocalText("390040")
  self.btn_back = self:AddComponent(UIButton, btn_back_white_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.my_ally_toggle = self:AddComponent(UIToggle, my_ally_toggle_path)
  self.self_obj = self:AddComponent(RankItem, self_obj_path)
  self.toggle1 = self:AddComponent(TabItem, toggle1_path)
  self.toggle2 = self:AddComponent(TabItem, toggle2_path)
  self.toggle3 = self:AddComponent(TabItem, toggle3_path)
  self.toggle4 = self:AddComponent(TabItem, toggle4_path)
  self.toggle5 = self:AddComponent(TabItem, toggle5_path)
  self.toggle6 = self:AddComponent(TabItem, toggle6_path)
  self.tab1 = self:AddComponent(UIToggle, tab1_path)
  self.tab2 = self:AddComponent(UIToggle, tab2_path)
  self.text_title1 = self:AddComponent(UITextMeshProUGUIEx, text_title1_path)
  self.text_title2 = self:AddComponent(UITextMeshProUGUIEx, text_title2_path)
  self.text_title3 = self:AddComponent(UITextMeshProUGUIEx, text_title3_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.ScrollView = self:AddComponent(UIScrollView, rect_scroll_path)
  self.ScrollView:SetFixedItemSize(750, 136)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.info_btn:SetOnClick(function()
    if self.hero_event_id == nil or self.hero_event_id == 0 then
      return
    end
    if self.rank_type == 1 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCrossServerAttackDetail, {anim = true}, {
        id = self.hero_event_id,
        title = "season_alliance_event_name_120016",
        desc = "season_alliance_event_desc_120016"
      })
    elseif self.rank_type == 2 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCrossServerAttackDetail, {anim = true}, {
        id = self.hero_event_id,
        title = "season_alliance_event_name_120017",
        desc = "season_alliance_event_desc_120017"
      })
    end
  end)
end

function UILWCrossServerAttackCityRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = UIUtil.GetLoopListItemIndex()
  local cellItem = self.ScrollView:AddComponent(RankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.rank_type, self.week_index, index, self.rankList[index])
  end
end

function UILWCrossServerAttackCityRankView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RankItem)
end

function UILWCrossServerAttackCityRankView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RankItem)
end

function UILWCrossServerAttackCityRankView:OnRankTypeChanged(rank_type)
  if self.rank_type == rank_type then
    return
  end
  last_rank_index = rank_type
  local hero_event_id = 0
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonCrossAttackCityActivity.Type)
  self.rank_type = rank_type
  self.week_index = nil
  if rank_type == 1 then
    self.text_title1:SetLocalText("challenge_zombie_rank")
    self.text_title2:SetLocalText("challenge_zombie_person")
    self.text_title3:SetLocalText("challenge_zombie_record")
    if actData ~= nil then
      hero_event_id = toInt(actData.para_6)
    end
    self.isFilterOn = ally_toggle_1
    self.my_ally_toggle:SetIsOn(ally_toggle_1)
    self:OnWeekChanged(week_index_1)
  elseif rank_type == 2 then
    self.text_title1:SetLocalText("challenge_zombie_rank")
    self.text_title2:SetLocalText("challenge_zombie_alliance")
    self.text_title3:SetLocalText("challenge_zombie_record")
    if actData ~= nil then
      hero_event_id = toInt(actData.para_7)
    end
    self.isFilterOn = ally_toggle_2
    self.my_ally_toggle:SetIsOn(ally_toggle_2)
    self:OnWeekChanged(week_index_2)
  end
  self.hero_event_id = hero_event_id
  self.info_btn:SetActive(0 < hero_event_id)
end

function UILWCrossServerAttackCityRankView:OnWeekChanged(week_index)
  if self.week_index == week_index then
    return
  end
  if self.rank_type == 1 then
    week_index_1 = week_index
  elseif self.rank_type == 2 then
    week_index_2 = week_index
  end
  if week_index == 0 then
    self.toggle6:SetIsOn(true)
  else
    local node = self["toggle" .. week_index]
    if node ~= nil then
      node:SetIsOn(true)
    end
  end
  self.week_index = week_index
  if self.rank_type ~= nil and self.week_index ~= nil then
    self:RefreshData()
  end
end

function UILWCrossServerAttackCityRankView:OnDataFilter(isOn)
  if self.rank_type ~= nil and self.week_index ~= nil then
    self.isFilterOn = isOn
    if self.rank_type == 1 then
      ally_toggle_1 = isOn
    elseif self.rank_type == 2 then
      ally_toggle_2 = isOn
    end
    self:RefreshData()
  end
end

function UILWCrossServerAttackCityRankView:ComponentDestroy()
  self.btn_back = nil
  self.btn_back_white = nil
  self.my_ally_toggle = nil
  self.ScrollView = nil
  self.txt_empty = nil
  self.content = nil
  self.self_obj = nil
  self.text_title = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.toggle3 = nil
  self.toggle4 = nil
  self.toggle5 = nil
  self.toggle6 = nil
  self.tab1 = nil
  self.tab2 = nil
  self.text_title1 = nil
  self.text_title2 = nil
  self.text_title3 = nil
  self.info_btn = nil
  self.loading = nil
end

local theRanDataCache = {}

function UILWCrossServerAttackCityRankView:OnRankUpdate(data)
  if theRanDataCache == nil then
    theRanDataCache = {}
  end
  if data.rankType ~= nil and data.weekNum ~= nil and data.periodType ~= nil then
    local rank_data = theRanDataCache[data.rankType] or {}
    rank_data[data.weekNum] = data
    theRanDataCache[data.rankType] = rank_data
    self:RefreshData()
  end
end

function UILWCrossServerAttackCityRankView:GetData()
  if self.rank_type == nil or self.week_index == nil then
    return nil
  end
  local week_data
  if theRanDataCache ~= nil then
    local rank_data = theRanDataCache[self.rank_type]
    if rank_data ~= nil then
      week_data = rank_data[self.week_index]
    end
  end
  if week_data == nil or week_data.requestTime == nil or UITimeManager:GetInstance():GetServerTime() - week_data.requestTime > 15000 then
    if self.week_index == 0 then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonCrossInvasionRankInfo, self.rank_type, 0, 1)
    else
      SFSNetwork.SendMessage(MsgDefines.GetSeasonCrossInvasionRankInfo, self.rank_type, self.week_index, 0)
    end
  end
  return week_data
end

function UILWCrossServerAttackCityRankView:RefreshData()
  local dataList = self:GetData()
  if dataList == nil or self.rank_type == nil or self.week_index == nil then
    self:ClearScroll()
    self.loading:SetActive(true)
    self.self_obj:SetActive(false)
    self.txt_empty:SetActive(false)
    self.my_ally_toggle:SetActive(false)
    return
  end
  self.loading:SetActive(false)
  self:ClearScroll()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local allianceId = LuaEntry.Player:GetAllianceUid()
  local rankList = dataList.ranks or {}
  local rankSelf = dataList.self or {score = 0, rank = 0}
  if self.isFilterOn and hasAlliance then
    local filterList = {}
    for _, value in pairs(rankList) do
      if value.allianceId == allianceId then
        table.insert(filterList, value)
      end
    end
    self.rankList = filterList
  else
    self.rankList = rankList
  end
  local dataCount = #self.rankList
  if 0 < dataCount then
    self.txt_empty:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  else
    self.ScrollView:SetActive(false)
    if self.isFilterOn and hasAlliance then
      self.txt_empty:SetLocalText("activity_berserkboss_desc_05")
    else
      self.txt_empty:SetLocalText("zone_mobilization_player_no_data")
    end
    self.txt_empty:SetActive(true)
  end
  if self.rank_type == 1 or hasAlliance then
    self.self_obj:SetActive(true)
    self.self_obj:ReInit(self.rank_type, self.week_index, rankSelf.rank, rankSelf, true)
    self.my_ally_toggle:SetActive(self.rank_type == 1 and hasAlliance)
  else
    self.self_obj:SetActive(false)
    self.my_ally_toggle:SetActive(false)
  end
end

return UILWCrossServerAttackCityRankView
