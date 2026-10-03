local SeasonDeclareCityListView = BaseClass("SeasonDeclareCityListView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local UnityText = typeof(CS.UnityEngine.UI.Text)
local Localization = CS.GameEntry.Localization
local LWSeasonComboBox = require("UI.LWSeasonShared.Component.LWSeasonComboBox")
local DetailGroup = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareCityList.Component.SeasonDeclareCityListGroup")
local btn_back_path = "Root/BottomBar/BtnBack"
local scroll_view_path = "Root/PackList"
local viewport_path = "Root/PackList/Viewport"
local content_path = "Root/PackList/Viewport/Content"
local ui_attack_city_item_path = "Root/PackList/UIAttackCityItem"
local text_title_path = "Root/TopBar/TextTitle"
local tab_path = "Root/TopBar/Tab"
local tab_item_path = "Root/TopBar/Tab/TabItem"
local no_data_path = "Root/PackList/NoData"
local city_info_path = "Root/PackList/GameObject"
local city_count_value_path = "Root/PackList/GameObject/CityCountValue"
local city_loot_value_path = "Root/PackList/GameObject/CityLootValue"
local city_group_title_path = "Root/PackList/Viewport/CityGroupTitle"
local city_group_title_bg_path = "Root/PackList/Viewport/CityGroupTitle/bg"
local city_group_title_txt_path = "Root/PackList/Viewport/CityGroupTitle/Title"
local select_mode_path = "Root/PackList/SelectMode"
local city_count_root_path = "Root/PackList/CityCount"
local city_count_txt_path = "Root/PackList/CityCount/CityCountTxt"

function SeasonDeclareCityListView:OnCreate()
  base.OnCreate(self)
  DataCenter.SeasonDataManager:CleanCrossDeclareWarCityList()
  self:ComponentDefine()
end

function SeasonDeclareCityListView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonDeclareCityListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarCityList, self.UpdateData)
  self:AddUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
end

function SeasonDeclareCityListView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarCityList, self.UpdateData)
  self:RemoveUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function SeasonDeclareCityListView:ComponentDefine()
  self.city_group_title_root = self:AddComponent(UIImage, city_group_title_path)
  self.city_group_title_txt = self:AddComponent(UIText, city_group_title_txt_path)
  self.city_group_title_bg = self:AddComponent(UIBaseComponent, city_group_title_bg_path)
  self.city_group_title_root:SetActive(false)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("390876")
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.viewport = self:AddComponent(UIBaseComponent, viewport_path)
  self.city_info_root = self:AddComponent(UIBaseContainer, city_info_path)
  self.city_count_value = self:AddComponent(UIText, city_count_value_path)
  self.city_loot_value = self:AddComponent(UIText, city_loot_value_path)
  self.no_data = self:AddComponent(UIText, no_data_path)
  self.city_count_root = self:AddComponent(UIImage, city_count_root_path)
  self.city_count_txt = self:AddComponent(UITextMeshProUGUIEx, city_count_txt_path)
  self.city_count_value:SetLocalText("302290", 0)
  self.city_loot_value:SetLocalText("season_sever_intrusion_015", "0")
  self.select_mode = self:AddComponent(LWSeasonComboBox, select_mode_path)
  self.tab = self:AddComponent(UIBaseContainer, tab_path)
  self.theTabItem = self.transform:Find(tab_item_path).gameObject
  self.theTabItem:GameObjectCreatePool()
  self.theItem = self.transform:Find(ui_attack_city_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.scroll_view:AddValueChangeListener(function(vec)
    self:OnScrollValueChange()
  end)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local theFirstToggle, theFirstServerId
  local serverList = {}
  local cfg = DataCenter.SeasonDataManager:GetSeasonConfig()
  if cfg and cfg.server then
    serverList = string.split(cfg.server, ";")
  end
  if hasAlliance then
    table.insert(serverList, 1, 0)
  end
  self.serverList = serverList
  if serverList then
    local goItem, theToggle
    local myServerId = LuaEntry.Player:GetSourceServerId()
    local txt
    for k, serverId in ipairs(serverList) do
      local nServerId = toInt(serverId)
      if nServerId ~= myServerId then
        goItem = self.theTabItem:GameObjectSpawn(self.tab.transform)
        goItem.name = "tab_" .. k
        goItem:SetActive(true)
        if nServerId == 0 then
          txt = Localization:GetString("456507")
        else
          txt = "#" .. serverId
        end
        goItem.transform:Find("ConditionDark"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = txt
        goItem.transform:Find("ConditionSelect/Condition"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = txt
        theToggle = self.tab:AddComponent(UIToggle, goItem.name)
        theToggle:SetOnValueChanged(function(tf)
          if tf then
            self:OnTabChanged(nServerId)
          end
        end)
        if theFirstToggle == nil then
          theFirstServerId = nServerId
          theFirstToggle = theToggle
        end
      end
    end
  end
  local groupList = {}
  for i = 1, 8 do
    groupList[i] = self:AddComponent(DetailGroup, "Root/PackList/Viewport/Content/CityGroup" .. i)
  end
  self.groupList = groupList
  self.curServerId = nil
  self:InitComboBox()
  theFirstToggle:SetIsOn(true)
  if self.curServerId == nil and theFirstServerId then
    self:OnTabChanged(theFirstServerId)
  end
end

function SeasonDeclareCityListView:ComponentDestroy()
  self.btn_back = nil
  if self.groupList then
    for i = 1, 8 do
      self.groupList[i]:Clean()
    end
    self.groupList = nil
  end
  self.tab:RemoveComponents(UIToggle)
  self.theItem:GameObjectRecycleAll()
  self.theTabItem:GameObjectRecycleAll()
  self.select_mode = nil
  self.viewport = nil
  self.city_count_root = nil
  self.city_count_txt = nil
end

function SeasonDeclareCityListView:InitComboBox()
  local ComboBoxDataList = {}
  self.filter = {
    txt = "season_sever_declare_war_006",
    isLocal = false,
    check = function(info, curTime, allianceId)
      return info.hasDesertConnection and (info.protectTime == nil or info.protectTime == 0 or curTime > info.protectTime)
    end
  }
  table.insert(ComboBoxDataList, self.filter)
  table.insert(ComboBoxDataList, {
    txt = "season_sever_intrusion_012",
    isLocal = false,
    check = function(info, curTime, allianceId)
      return true
    end
  })
  table.insert(ComboBoxDataList, {
    txt = "300724",
    isLocal = false,
    check = function(info, curTime, allianceId)
      return allianceId == info.alId
    end
  })
  table.insert(ComboBoxDataList, {
    txt = "season_s1_activity1200029_desc04",
    isLocal = false,
    check = function(info, curTime, allianceId)
      return info.alId == nil or info.alId == ""
    end
  })
  table.insert(ComboBoxDataList, {
    txt = "season_s1_activity1200029_desc05",
    isLocal = false,
    check = function(info, curTime, allianceId)
      return info.alId ~= nil and info.alId ~= "" and allianceId ~= info.alId
    end
  })
  self.select_mode:SelectedIndexChanged(nil)
  self.select_mode:FillData(ComboBoxDataList, 1)
  self.select_mode:SelectedIndexChanged(function(index, data)
    self:OnSelectedIndexChanged(index, data)
  end)
end

function SeasonDeclareCityListView:OnSelectedIndexChanged(index, data)
  self.filter = data
  if self.curServerId ~= nil then
    self:UpdateData()
  end
end

function SeasonDeclareCityListView:OnScrollValueChange()
  if self.Updating then
    return
  end
  local topNode
  local top = self.content:GetAnchoredPositionY()
  local lastY = 0
  for i = 1, 8 do
    topNode = self.groupList[i]
    if topNode and topNode:GetActive() then
      local y = topNode:GetAnchoredPositionY() + top
      if 0 < y then
        if i ~= 1 and 0 <= lastY + 60 then
          topNode = nil
        end
        break
      end
      lastY = y
    end
    topNode = nil
  end
  if topNode then
    self.city_group_title_root:SetActive(true)
    self.city_group_title_txt:SetText(topNode.title:GetText())
    self.city_group_title_bg:SetActive(topNode.level == 8)
  else
    self.city_group_title_root:SetActive(false)
  end
end

function SeasonDeclareCityListView:OnTabChanged(serverId)
  if self.curServerId ~= serverId then
    self.curServerId = serverId
    if serverId == 0 then
      self.select_mode:SetActive(false)
      self.city_count_root:SetActive(false)
      self.viewport.transform.offsetMax = Vector2.New(0, -7)
    else
      self.select_mode:SetActive(true)
      self.city_count_root:SetActive(true)
      self.viewport.transform.offsetMax = Vector2.New(0, -80)
    end
    self:UpdateData()
  end
end

function SeasonDeclareCityListView:Update1000MS()
  if self.Updating then
    self.Updating = false
  end
end

function SeasonDeclareCityListView:UpdateData()
  if self.curServerId == nil then
    return
  end
  self.city_count_root:SetActive(false)
  self.city_group_title_root:SetActive(false)
  if self.groupList == nil then
    return
  end
  self.Updating = true
  local theGroupNode
  for i = 8, 1, -1 do
    theGroupNode = self.groupList[i]
    if theGroupNode then
      theGroupNode:SetActive(false)
    end
  end
  local cityList
  local curServerId = self.curServerId
  local theFilter = self.filter
  self.city_count_value:SetText("")
  self.city_loot_value:SetText("")
  if curServerId == 0 then
    theFilter = nil
    self.city_info_root:SetActive(true)
    cityList = DataCenter.SeasonDataManager.CrossOccupyCityList
    if cityList == nil then
      self.no_data:SetActive(false)
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
      return
    end
    local newList = {}
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(sourceServerId)
    for _, v in ipairs(cityList) do
      if v.cityId ~= kingCityId and v.serverId ~= sourceServerId then
        table.insert(newList, v)
      end
    end
    cityList = newList
    self.no_data:SetActive(#cityList == 0)
    self.no_data:SetLocalText("456513")
  else
    self.city_info_root:SetActive(false)
    self.no_data:SetActive(false)
    cityList = DataCenter.SeasonDataManager:GetCrossDeclareWarCityList(curServerId)
    if cityList == nil then
      SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarCityList, curServerId)
      return
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  local allianceId = LuaEntry.Player:GetAllianceUid()
  local dataLevelGroup = {}
  local occupied = 0
  local loot_value = 0
  local cityCount = 0
  if not isInAlliance then
    allianceId = "!WTF!"
  end
  for i, info in ipairs(cityList) do
    local cfg = DataCenter.AllianceCityTemplateManager:GetTemplate(info.cityId)
    local level = cfg.level
    if level < 7 and cfg then
      info.cfg = cfg
      info.isOccupy = curServerId == 0 or allianceId == info.alId
      if theFilter == nil or curServerId == 0 or theFilter.check(info, curTime, allianceId) then
        if dataLevelGroup[level] == nil then
          dataLevelGroup[level] = {}
        end
        table.insert(dataLevelGroup[level], info)
        cityCount = cityCount + 1
      end
      if info.isOccupy then
        loot_value = loot_value + cfg.force
        occupied = occupied + 1
      elseif theFilter == nil and info.hasDesertConnection and (info.protectTime == nil or info.protectTime == 0 or curTime > info.protectTime) then
        if dataLevelGroup[8] == nil then
          dataLevelGroup[8] = {}
        end
        table.insert(dataLevelGroup[8], info)
        cityCount = cityCount + 1
      end
    end
  end
  local full_height = 0
  if theFilter ~= nil then
    if cityCount == 0 then
      self.viewport:SetActive(false)
      self.no_data:SetActive(true)
      self.no_data:SetLocalText("season_s1_activity1200029_desc03")
    else
      self.viewport:SetActive(true)
      self.no_data:SetActive(false)
    end
    self.city_count_root:SetActive(true)
    self.city_count_txt:SetLocalText("season_s1_activity1200029_desc06", cityCount)
  else
    self.city_count_root:SetActive(false)
  end
  for i = 8, 1, -1 do
    theGroupNode = self.groupList[i]
    if i ~= 7 and dataLevelGroup[i] ~= nil then
      theGroupNode:SetActive(true)
      theGroupNode:ReInit(curServerId, i, dataLevelGroup[i], self.theItem)
      full_height = full_height + theGroupNode.full_height
    else
      theGroupNode:SetActive(false)
    end
  end
  local cityMax = SeasonUtil.GetOccupyCityMaxCount()
  self.content:SetSizeDeltaXY(780, full_height)
  self.city_count_value:SetLocalText("302290", occupied .. "/" .. cityMax)
  self.city_loot_value:SetLocalText("season_sever_intrusion_015", loot_value)
  self.scroll_view:SetVerticalNormalizedPosition(1)
end

return SeasonDeclareCityListView
