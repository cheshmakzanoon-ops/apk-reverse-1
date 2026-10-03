local UILWSeasonCityOccupyListView = BaseClass("UILWSeasonCityOccupyListView", UIBaseView)
local base = UIBaseView
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
local Localization = CS.GameEntry.Localization
local LWSeasonCityOccupyTip = require("UI.LWSeasonShared.Component.LWSeasonCityOccupyTip")
local OccupyListGroup = require("UI.LWSeason1.UILWSeasonCityOccupyList.Component.UILWSeasonCityOccupyListGroup")
local OccupyListTitle = require("UI.LWSeason1.UILWSeasonCityOccupyList.Component.UILWSeasonCityOccupyListTitle")
local OccupyListEmpty = require("UI.LWSeason1.UILWSeasonCityOccupyList.Component.UILWSeasonCityOccupyListEmpty")
local scroll_view_path = "Root/PackList"
local content_path = "Root/PackList/Viewport/Content"
local text_title_path = "Root/TopBar/TitleContent/TextTitle"
local tab_path = "Root/TopBar/Tab"
local tab_item_path = "Root/TopBar/Tab/TabItem"
local btn_back_path = "Root/BottomBar/BtnBack"
local info_bottom_btn_path = "Root/BottomBar/group/tips1/InfoBottomBtn"
local tips_path = "Root/Tips"
local no_data_path = "Root/Tips/NoData"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local tip_root_path = "Root/BottomBar/TipRoot"
local info_btn_path = "Root/TopBar/TitleContent/InfoBtn"
local world_time_text_path = "Root/PackList/WorldTimeBg/WorldTimeText"

function UILWSeasonCityOccupyListView:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self:ComponentDefine()
end

function UILWSeasonCityOccupyListView:OnDestroy()
  self.items = {}
  self.content:RemoveComponents(OccupyListGroup)
  self.content:RemoveComponents(OccupyListTitle)
  self.content:RemoveComponents(OccupyListEmpty)
  self.ScrollView:ClearAllItems()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
  self:AddUIListener(EventId.CrossOccupyStrongholdListUpdate, self.UpdateData)
end

function UILWSeasonCityOccupyListView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.CrossOccupyStrongholdListUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonCityOccupyListView:ComponentDefine()
  self.tip1 = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/group/tips1")
  self.tip2 = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/tips2")
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.world_time_text = self:AddComponent(UITextMeshProUGUIEx, world_time_text_path)
  self.info_bottom_btn = self:AddComponent(UIButton, info_bottom_btn_path)
  self.info_btn:SetActive(true)
  self.info_btn:SetOnClick(function()
    self:ShowEffectInfoNew()
  end)
  self.info_bottom_btn:SetOnClick(function()
    UIUtil.ShowS1HowToPlay(101006)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tips = self:AddComponent(UIBaseContainer, tips_path)
  self.no_data = self:AddComponent(UITextMeshProUGUIEx, no_data_path)
  self.tab = self:AddComponent(UIBaseContainer, tab_path)
  self.theTabItem = self.transform:Find(tab_item_path).gameObject
  self.theTabItem:GameObjectCreatePool()
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.effect_tip_root = self:AddComponent(LWSeasonCityOccupyTip, tip_root_path)
  self.text_title:SetLocalText("456505")
  self.effect_tip_root:SetActive(false)
  self.tips:SetActive(false)
  self.no_data:SetActive(false)
  self.no_data:SetLocalText("456513")
  self.btn_effect:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCrossOccupyDetail)
  end)
  self.activeTabIndex = nil
  self.tabsList = nil
  self:UpdateData()
  self:Update1000MS()
end

function UILWSeasonCityOccupyListView:ComponentDestroy()
  self.tab:RemoveComponents(UIToggle)
  self.theTabItem:GameObjectRecycleAll()
  self.info_btn = nil
  self.tabsList = nil
  self.text_title = nil
  self.btn_back = nil
  self.world_time_text = nil
  self.info_bottom_btn = nil
end

function UILWSeasonCityOccupyListView:SelectTab(tabIndex)
  self.activeTabIndex = tabIndex
  self:UpdateUI()
end

function UILWSeasonCityOccupyListView:UpdateData()
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  local serverDataList = {}
  local cityMeta
  serverDataList[sourceServerId] = {}
  for k, v in pairs(CrossOccupyCityList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.cityId), v.serverId)
    if cityMeta and cityMeta:IsCity() then
      if serverDataList[v.serverId] == nil then
        serverDataList[v.serverId] = {}
      end
      serverDataList[v.serverId][cityMeta.id] = cityMeta
    end
  end
  for k, v in pairs(CrossOccupyStrongholdList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.id), v.serverId)
    if cityMeta then
      if serverDataList[v.serverId] == nil then
        serverDataList[v.serverId] = {}
      end
      serverDataList[v.serverId][cityMeta.id] = cityMeta
    end
  end
  local tabsList = self.tabsList or {}
  local goItem, theToggle, txt
  local minServerId = sourceServerId
  for serverId, dataList in pairs(serverDataList) do
    local nServerId = toInt(serverId)
    if tabsList[nServerId] == nil then
      txt = "#" .. serverId
      if serverId == sourceServerId then
        txt = Localization:GetString("power_level_tips_7")
      end
      goItem = self.theTabItem:GameObjectSpawn(self.tab.transform)
      goItem.name = "tab_" .. serverId
      goItem:SetActive(true)
      goItem.transform:Find("ConditionDark"):GetComponent(UnityTextMeshProEx).text = txt
      goItem.transform:Find("ConditionSelect/Condition"):GetComponent(UnityTextMeshProEx).text = txt
      theToggle = self.tab:AddComponent(UIToggle, goItem.name)
      theToggle:SetOnValueChanged(function(tf)
        if tf then
          self:SelectTab(nServerId)
        end
      end)
      tabsList[nServerId] = theToggle
    end
    if tabsList[nServerId] and tabsList[nServerId].transform then
      if sourceServerId == nServerId then
        tabsList[nServerId].transform:SetSiblingIndex(0)
      else
        tabsList[nServerId].transform:SetSiblingIndex(nServerId)
      end
    end
    minServerId = math.min(minServerId, nServerId)
  end
  self.tabsList = tabsList
  self.serverDataList = serverDataList
  if self.activeTabIndex == nil and tabsList[minServerId] then
    if tabsList[sourceServerId] then
      tabsList[sourceServerId]:SetIsOn(true)
      self:SelectTab(sourceServerId)
    else
      tabsList[minServerId]:SetIsOn(true)
      self:SelectTab(minServerId)
    end
  elseif self.activeTabIndex ~= nil then
    self:UpdateUI()
  end
end

function UILWSeasonCityOccupyListView:UpdateUI()
  self.effect_tip_root:SetActive(false)
  self.tooltip_tick = 0
  if self.serverDataList == nil or self.activeTabIndex == nil then
    return
  end
  local dataList = self.serverDataList[self.activeTabIndex] or {}
  local OccupyCityList = {}
  local OccupyStrongholdList = {}
  local cityOccupyInfo = {
    type = "GroupTitle",
    force = 0,
    isCity = true
  }
  local strongholdOccupyInfo = {
    type = "GroupTitle",
    force = 0,
    isCity = false
  }
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  self.activeDataList = {}
  for k, v in pairs(dataList) do
    if v.type == WorldAllianceCityType.Stronghold then
      table.insert(OccupyStrongholdList, v)
      strongholdOccupyInfo.force = strongholdOccupyInfo.force + v.force
    elseif v.type == WorldAllianceCityType.City then
      table.insert(OccupyCityList, v)
      cityOccupyInfo.force = cityOccupyInfo.force + v.force
    end
    table.insert(self.activeDataList, v)
  end
  local strongholdMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s1_stronghold", "k4", 30))
  local CrossOccupyStrongholdMaxNum = DataCenter.SeasonDataManager.CrossOccupyStrongholdMaxNum
  if CrossOccupyStrongholdMaxNum then
    local tmp = toInt(CrossOccupyStrongholdMaxNum[tostring(self.activeTabIndex)])
    if 0 < tmp then
      strongholdMax = tmp
    end
  end
  cityOccupyInfo.has = #OccupyCityList
  strongholdOccupyInfo.has = #OccupyStrongholdList
  strongholdOccupyInfo.max = strongholdMax
  if sourceServerId == self.activeTabIndex then
    cityOccupyInfo.max = DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal
    cityOccupyInfo.txt = Localization:GetString("power_level_tips_6", cityOccupyInfo.has, DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal)
    strongholdOccupyInfo.txt = Localization:GetString("season_stronghold_count", strongholdOccupyInfo.has .. "/" .. strongholdMax)
  else
    local cityCount = 0
    for k1, v1 in pairs(self.serverDataList) do
      if sourceServerId ~= toInt(k1) then
        for k2, v2 in pairs(v1) do
          if v2.type == WorldAllianceCityType.City then
            cityCount = cityCount + 1
          end
        end
      end
    end
    cityOccupyInfo.txt = Localization:GetString("season_s1_city_info10", "") .. cityCount .. "/" .. DataCenter.SeasonDataManager.CrossOccupyCityMaxNumOther
    strongholdOccupyInfo.txt = Localization:GetString("season_stronghold_count", strongholdOccupyInfo.has .. "/" .. strongholdMax)
  end
  table.sort(OccupyCityList, function(a, b)
    if a.level == b.level then
      return a.id > b.id
    end
    return a.level > b.level
  end)
  table.sort(OccupyStrongholdList, function(a, b)
    if a.level == b.level then
      return a.id > b.id
    end
    return a.level > b.level
  end)
  self.btn_effect:SetActive(true)
  self.tips:SetActive(false)
  self.no_data:SetActive(false)
  local theDataList = {}
  table.insert(theDataList, cityOccupyInfo)
  if cityOccupyInfo.has == 0 then
    table.insert(theDataList, {
      type = "NoData",
      serverId = self.activeTabIndex,
      isCity = true
    })
  else
    for i = 1, cityOccupyInfo.has, 3 do
      table.insert(theDataList, {
        type = WorldAllianceCityType.City,
        data = {
          OccupyCityList[i],
          OccupyCityList[i + 1],
          OccupyCityList[i + 2]
        }
      })
    end
  end
  table.insert(theDataList, strongholdOccupyInfo)
  if strongholdOccupyInfo.has == 0 then
    table.insert(theDataList, {
      type = "NoData",
      serverId = self.activeTabIndex,
      isCity = false
    })
  else
    for i = 1, strongholdOccupyInfo.has, 3 do
      table.insert(theDataList, {
        type = WorldAllianceCityType.Stronghold,
        data = {
          OccupyStrongholdList[i],
          OccupyStrongholdList[i + 1],
          OccupyStrongholdList[i + 2]
        }
      })
    end
  end
  self.dataList = theDataList
  self.ScrollView:SetListItemCount(#self.dataList, self.lastActiveTab ~= self.activeTabIndex, false)
  self.ScrollView:RefreshAllShownItem()
  self.lastActiveTab = self.activeTabIndex
  local dailyDeclareNum = DataCenter.SeasonDataManager.dailyDeclareNum or 0
  local dailyOccupyNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyNum or 0
  local dailyOccupyMaxNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum or 0
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self.tip1:SetLocalText("season_s1_citylist_02", dailyOccupyMaxNum - dailyOccupyNum, dailyOccupyMaxNum)
  self.tip2:SetLocalText("season_s2_city_description_07", k6 - dailyDeclareNum, k6)
end

function UILWSeasonCityOccupyListView:ShowEffectInfoNew()
  local effects = {}
  if self.activeDataList then
    for k, v in ipairs(self.activeDataList) do
      if v and v.buff ~= nil and v.buff ~= "" and v.buff ~= 0 then
        local effectId, effectValue = string.match(v.buff, "([^;]+);([^;]+)")
        if effectId and effectValue then
          local nKey = toInt(effectId)
          effects[nKey] = (effects[nKey] or 0) + tonumber(effectValue)
        end
      end
    end
  end
  if effects == nil or table.count(effects) == 0 then
    local msg = Localization:GetString("456514")
    UIUtil.ShowDetail(msg, "456512", nil, false, true)
  else
    local msg = "<align=\"center\">" .. Localization:GetString("456509")
    for effectId, effectValue in pairs(effects) do
      local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
      msg = msg .. "\n" .. Localization:GetString(effectName .. "") .. (buffAddNum or "")
    end
    UIUtil.ShowDetail(msg .. "</align>", "456512", nil, false, true)
  end
end

function UILWSeasonCityOccupyListView:ShowEffectInfo()
  local effects = {}
  if self.activeDataList then
    for k, v in ipairs(self.activeDataList) do
      if v and v.buff ~= nil and v.buff ~= "" and v.buff ~= 0 then
        local effectId, effectValue = string.match(v.buff, "([^;]+);([^;]+)")
        if effectId and effectValue then
          local nKey = toInt(effectId)
          effects[nKey] = (effects[nKey] or 0) + tonumber(effectValue)
        end
      end
    end
  end
  if effects == nil or table.count(effects) == 0 then
    self.effect_tip_root:ShowEffectInfo(nil)
    return
  end
  self.effect_tip_root:ShowEffectInfo(effects, nil)
end

function UILWSeasonCityOccupyListView:Update1000MS()
  if self.world_time_text then
    local mgr = UITimeManager:GetInstance()
    if string.IsNullOrEmpty(self.worldText) then
      self.worldText = Localization:GetString("800811") .. ": "
    end
    self.world_time_text:SetText(self.worldText .. mgr:TimeStampToTimeForServer(mgr:GetServerTime()))
  end
end

function UILWSeasonCityOccupyListView:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  if data.type == WorldAllianceCityType.City then
    csItem = listview:NewListViewItem("LineTemplate")
    theScript = OccupyListGroup
  elseif data.type == WorldAllianceCityType.Stronghold then
    csItem = listview:NewListViewItem("LineTemplate")
    theScript = OccupyListGroup
  elseif data.type == "GroupTitle" then
    csItem = listview:NewListViewItem("GroupTitle")
    theScript = OccupyListTitle
  elseif data.type == "NoData" then
    csItem = listview:NewListViewItem("NoData")
    theScript = OccupyListEmpty
  else
    return nil
  end
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, data, self.activeTabIndex, self.dataList)
  end
  return csItem
end

return UILWSeasonCityOccupyListView
