local UILWSeasonCityAltarTitleCell = require("UI.LWSeasonShared.UILWSeasonCityAltar.Comp.UILWSeasonCityAltarTitleCell")
local UILWSeasonCityAltarGroupCell = require("UI.LWSeasonShared.UILWSeasonCityAltar.Comp.UILWSeasonCityAltarGroupCell")
local base = UIBaseContainer
local UILWSeasonCityAltarListComp = BaseClass("UILWSeasonCityAltarListComp", UIBaseContainer)

function UILWSeasonCityAltarListComp:ComponentDefine()
  local p_list_view_path = "p_list_view"
  local p_go_no_content_path = "p_go_no_content"
  local p_text_altar_num_path = "BottomBar/content/p_text_altar_num"
  local p_text_add_up_path = "BottomBar/content/p_text_add_up"
  local btn_back_path = "BottomBar/BtnBack"
  self.p_list_view = self:AddComponent(UILoopListViewSimple, p_list_view_path)
  self.p_go_no_content = self:AddComponent(UIBaseContainer, p_go_no_content_path)
  self.p_text_altar_num = self:AddComponent(UITextMeshProUGUIEx, p_text_altar_num_path)
  self.p_text_add_up = self:AddComponent(UITextMeshProUGUIEx, p_text_add_up_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self, self.OnCloseClicked))
end

function UILWSeasonCityAltarListComp:ComponentDestroy()
  self.p_list_view = nil
  self.p_go_no_content = nil
  self.p_text_altar_num = nil
  self.p_text_add_up = nil
  self.btn_back = nil
end

function UILWSeasonCityAltarListComp:DataDefine()
  self.AddUpTime = 0
  self.AddUpCount = 0
end

function UILWSeasonCityAltarListComp:DataDestroy()
  self.AddUpTime = 0
  self.AddUpCount = 0
end

function UILWSeasonCityAltarListComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonCityAltarListComp:OnDestroy()
  DataCenter.SeasonCityAltarManager:ClearCityAltarList()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAltarListComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCityAltarListUpdate, self.OnCityAltarListUpdate)
end

function UILWSeasonCityAltarListComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCityAltarListUpdate, self.OnCityAltarListUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonCityAltarListComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateListData() then
      self:UpdateList()
    else
      DataCenter.SeasonCityAltarManager:SendGetCityAltarList()
    end
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function UILWSeasonCityAltarListComp:InitData(data)
  return true
end

function UILWSeasonCityAltarListComp:InitUi()
  self.p_go_no_content:SetActive(true)
  self.p_list_view:SetActive(false)
  self:UpdateAltarCount()
end

function UILWSeasonCityAltarListComp:UpdateData()
  self.AddUpTime, self.AddUpCount = DataCenter.SeasonCityAltarManager:GetNextAddUpInfo()
  return true
end

function UILWSeasonCityAltarListComp:UpdateListData()
  self.CityAltarList = DataCenter.SeasonCityAltarManager:GetCacheCityAltarList()
  if not table.IsNullOrEmpty(self.CityAltarList) then
    self.CityAltarGroupData = {}
    for _, cityInfo in pairs(self.CityAltarList) do
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityInfo.id, cityInfo.sid)
      if cityTemplate ~= nil then
        if self.CityAltarGroupData[cityTemplate.level] == nil then
          self.CityAltarGroupData[cityTemplate.level] = {}
          self.CityAltarGroupData[cityTemplate.level].Level = cityTemplate.level
          self.CityAltarGroupData[cityTemplate.level].List = {}
        end
        table.insert(self.CityAltarGroupData[cityTemplate.level].List, cityTemplate)
      end
    end
    table.sort(self.CityAltarGroupData, function(a, b)
      return a.Level > b.Level
    end)
    return true
  end
  return false
end

function UILWSeasonCityAltarListComp:UpdateList()
  self.p_go_no_content:SetActive(false)
  self.p_list_view:SetActive(true)
  self.p_list_view:Init(UILWSeasonCityAltarTitleCell, UILWSeasonCityAltarGroupCell)
  self.p_list_view:Clear()
  if not table.IsNullOrEmpty(self.CityAltarGroupData) then
    for _, groupData in pairs(self.CityAltarGroupData) do
      local firstCell = table.getFirst(groupData.List)
      if firstCell ~= nil then
        self.p_list_view:AddData(firstCell:GetFullName())
      end
      local index = 0
      local group = {}
      for i, cityTemplate in pairs(groupData.List) do
        table.insert(group, cityTemplate)
        index = index + 1
        if index == 3 then
          self.p_list_view:AddData(group, 2)
          group = {}
          index = 0
        end
      end
      if 0 < index then
        self.p_list_view:AddData(group, 2)
      end
    end
    self.p_list_view:Show()
  end
  self:UpdateAltarCount()
end

function UILWSeasonCityAltarListComp:UpdateUi()
end

function UILWSeasonCityAltarListComp:UpdateAltarCount()
  local totalCount = DataCenter.SeasonCityAltarManager:GetMaxAltarCount()
  local curCount = 0
  if not table.IsNullOrEmpty(self.CityAltarGroupData) then
    for _, groupData in pairs(self.CityAltarGroupData) do
      curCount = curCount + table.count(groupData.List)
    end
  end
  self.p_text_altar_num:SetLocalText("season_s6_activity1200109_desc11", curCount, totalCount)
end

function UILWSeasonCityAltarListComp:OnCityAltarListUpdate(evt)
  if self:UpdateListData() then
    self:UpdateList()
  end
end

function UILWSeasonCityAltarListComp:OnCloseClicked()
  self.holder.view.ctrl:CloseSelf()
end

function UILWSeasonCityAltarListComp:Update1000MS()
  local nextTime = checknumber(self.AddUpTime)
  if 0 < nextTime then
    local leftTime = nextTime - UITimeManager:GetInstance():GetServerTime()
    if 0 <= leftTime then
      self.p_text_add_up:SetActive(true)
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.p_text_add_up:SetLocalText("season_s6_activity1200109_desc26", timeStr, checknumber(self.AddUpCount))
    elseif self:UpdateData() then
      self:UpdateUi()
    end
  else
    self.p_text_add_up:SetActive(false)
  end
end

return UILWSeasonCityAltarListComp
