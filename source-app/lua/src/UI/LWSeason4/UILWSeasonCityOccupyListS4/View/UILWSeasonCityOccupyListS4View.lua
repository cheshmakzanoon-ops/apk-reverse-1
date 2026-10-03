local UILWSeasonCityOccupyListS4View = BaseClass("UILWSeasonCityOccupyListS4View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonCityOccupyTip = require("UI.LWSeasonShared.Component.LWSeasonCityOccupyTip")
local DetailItem = require("UI.LWSeason4.UILWSeasonCityOccupyListS4.Component.UILWSeasonCityOccupyListS4Item")
local TradeStationListComponent = require("UI.LWSeason4.UILWSeasonCityOccupyListS4.Component.TradeStationListComponentS4")
local tradeStationListPrefab = "Assets/Main/SeasonRes/S4/Prefabs/UI/CityOccupy/TradeStationListCom.prefab"
local tab_item_stronghold_red_point_path = "Root/Tab/TabItemStronghold/TabItemStrongholdRedPoint"
local scroll_view_path = "Root/ScrollView"
local tab_item_city_path = "Root/Tab/TabItemCity"
local tab_item_stronghold_path = "Root/Tab/TabItemStronghold"
local world_time_text_path = "Root/ScrollView/WorldTimeBg/WorldTimeText"
local tips_count_path = "Root/ScrollView/tipsCount"
local tips_speed_path = "Root/ScrollView/tipsSpeed"
local res_icon_path = "Root/ScrollView/tipsSpeed/res_icon"
local btn_back_path = "Root/BottomBar/BtnBack"
local info_btn_path = "Root/TopBar/TitleContent/InfoBtn"
local tips_path = "Root/ScrollView/Tips"
local no_data_path = "Root/ScrollView/Tips/NoData"
local btn_collect_res_path = "Root/BottomBar/BtnCollectRes"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local tip_root_path = "Root/BottomBar/TipRoot"
local trade_station_path = "Root/Tab/TradeStation"
local dynamic_root_path = "Root/dynamicRoot"

function UILWSeasonCityOccupyListS4View:OnCreate()
  base.OnCreate(self)
  self.activeDataList = nil
  local index = self:GetUserData()
  if index then
    self.activeTabIndex = index
  else
    self.activeTabIndex = 0
  end
  self.serverCityDataList = {}
  self.serverStrongholdDataList = {}
  self:ComponentDefine()
end

function UILWSeasonCityOccupyListS4View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListS4View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
  self:AddUIListener(EventId.CrossOccupyStrongholdListUpdate, self.UpdateData)
  self:AddUIListener(EventId.CollectStrongholdResourceSuccess, self.OnCollectResourceSuccess)
  self:AddUIListener(EventId.BatchCollectStrongholdResourceSuccess, self.OnBatchCollectResourceSuccess)
  self:AddUIListener(EventId.GetAllAllianceTradeStationData, self.TradeStationDataUpdate)
end

function UILWSeasonCityOccupyListS4View:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.CrossOccupyStrongholdListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.CollectStrongholdResourceSuccess, self.OnCollectResourceSuccess)
  self:RemoveUIListener(EventId.BatchCollectStrongholdResourceSuccess, self.OnBatchCollectResourceSuccess)
  self:RemoveUIListener(EventId.GetAllAllianceTradeStationData, self.TradeStationDataUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonCityOccupyListS4View:ComponentDefine()
  self.tab_item_stronghold_red_point = self:AddComponent(UIImage, tab_item_stronghold_red_point_path)
  self.tip1 = self:AddComponent(UIText, "Root/BottomBar/tips1")
  self.tip2 = self:AddComponent(UIText, "Root/BottomBar/tips2")
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.world_time_text = self:AddComponent(UITextMeshProUGUIEx, world_time_text_path)
  self.tips_count = self:AddComponent(UITextMeshProUGUIEx, tips_count_path)
  self.tips_speed = self:AddComponent(UITextMeshProUGUIEx, tips_speed_path)
  self.res_icon = self:AddComponent(UIImage, res_icon_path)
  self.dynamic_root = self:AddComponent(UIBaseContainer, dynamic_root_path)
  self.info_btn:SetActive(false)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tips = self:AddComponent(UIBaseContainer, tips_path)
  self.no_data = self:AddComponent(UIText, no_data_path)
  self.tab_item_city = self:AddComponent(UIToggle, tab_item_city_path)
  self.tab_item_stronghold = self:AddComponent(UIToggle, tab_item_stronghold_path)
  self.trade_station = self:AddComponent(UIToggle, trade_station_path)
  self.tab_item_city:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(1)
    end
  end)
  self.tab_item_stronghold:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(2)
    end
  end)
  self.trade_station:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(3)
    end
  end)
  self.btn_collect_res = self:AddComponent(UIButton, btn_collect_res_path)
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.effect_tip_root = self:AddComponent(LWSeasonCityOccupyTip, tip_root_path)
  self.tab_item_stronghold_red_point:SetActive(false)
  self.effect_tip_root:SetActive(false)
  self.tips:SetActive(false)
  self.no_data:SetActive(false)
  self.no_data:SetLocalText("456513")
  self.btn_effect:SetOnClick(function()
    self:ShowEffectInfo()
  end)
  self.btn_collect_res:SetOnClick(function()
    self:CollectResource()
  end)
  self:UpdateData()
  self:Update1000MS()
end

function UILWSeasonCityOccupyListS4View:ComponentDestroy()
  self:ClearScroll()
  self.tab_item_city = nil
  self.tab_item_stronghold = nil
  self.info_btn = nil
  self.tabsList = nil
  self.text_title = nil
  self.btn_back = nil
  self.world_time_text = nil
  self.trade_station = nil
  self.dynamic_root = nil
end

function UILWSeasonCityOccupyListS4View:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(DetailItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.activeDataList[index], self.activeTabIndex == 1, self.ghostKingStatusList)
  end
end

function UILWSeasonCityOccupyListS4View:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, DetailItem)
end

function UILWSeasonCityOccupyListS4View:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(DetailItem)
end

function UILWSeasonCityOccupyListS4View:SelectTab(tabIndex)
  self.activeTabIndex = tabIndex
  if tabIndex ~= 2 then
    local hasReward = false
    if table.count(DataCenter.SeasonDataManager.CrossOccupyStrongholdList) > 0 then
      local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
      if RewardInfo and 0 < #RewardInfo then
        for _, v in ipairs(RewardInfo) do
          if v.leftNum and v.leftNum ~= 0 then
            hasReward = true
            break
          end
        end
      end
    end
    self.tab_item_stronghold_red_point:SetActive(hasReward)
  else
    self.tab_item_stronghold_red_point:SetActive(false)
  end
  if self.activeTabIndex == 1 or self.activeTabIndex == 2 then
    self.ScrollView:SetActive(true)
    self:TryHideTradeStation()
    self:UpdateUI()
  else
    self.ScrollView:SetActive(false)
    self.tip1:SetActive(false)
    self.tip2:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.GetAllAllianceTradeMessage, LuaEntry.Player:GetAllianceUid())
    self:TryShowTradeStation()
  end
end

function UILWSeasonCityOccupyListS4View:UpdateData()
  if self.tab_item_city == nil or self.tab_item_stronghold == nil then
    return
  end
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  local serverCityDataList = {}
  local ghostKingStatusList = {}
  local serverStrongholdDataList = {}
  local cityMeta
  for k, v in pairs(CrossOccupyCityList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.cityId), v.serverId)
    if cityMeta and cityMeta:IsCity() then
      serverCityDataList[cityMeta.id] = cityMeta
    end
    if v.isGhostKingAlive then
      ghostKingStatusList[toInt(v.cityId)] = v
    end
  end
  for k, v in pairs(CrossOccupyStrongholdList) do
    cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.id), v.serverId)
    if cityMeta then
      serverStrongholdDataList[cityMeta.id] = cityMeta
    end
  end
  self.serverCityDataList = serverCityDataList
  self.serverStrongholdDataList = serverStrongholdDataList
  self.ghostKingStatusList = ghostKingStatusList
  if self.activeTabIndex == nil or self.activeTabIndex == 0 then
    self.tab_item_city:SetIsOn(true)
    self:SelectTab(1)
  elseif self.activeTabIndex == 2 then
    self.tab_item_stronghold:SetIsOn(true)
    self:SelectTab(2)
  else
    self:UpdateUI()
  end
end

function UILWSeasonCityOccupyListS4View:UpdateUI()
  self:ClearScroll()
  local dailyDeclareNum = DataCenter.SeasonDataManager.dailyDeclareNum or 0
  local dailyOccupyNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyNum or 0
  local dailyOccupyMaxNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum or 0
  self.tip1:SetActive(true)
  self.tip2:SetActive(true)
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self.tip1:SetLocalText("season_s2_city_description_06", dailyOccupyMaxNum - dailyOccupyNum, dailyOccupyMaxNum)
  self.tip2:SetLocalText("season_s2_city_description_07", k6 - dailyDeclareNum, k6)
  local cityCount = 0
  local product_value = 0
  local seasonType = SeasonUtil.GetSeasonType()
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  self.effect_tip_root:SetActive(false)
  self.activeDataList = {}
  if self.activeTabIndex == 1 then
    for k, v in pairs(self.serverCityDataList) do
      table.insert(self.activeDataList, v)
      product_value = product_value + (v.season_snow_stone_value or 0)
      cityCount = cityCount + 1
    end
    for k, v in pairs(self.serverStrongholdDataList) do
      if 0 < v.season_snow_stone_value then
        table.insert(self.activeDataList, v)
        product_value = product_value + (v.season_snow_stone_value or 0)
      end
    end
  else
    local StrongholdList = {}
    for k, v in pairs(self.serverStrongholdDataList) do
      table.insert(self.activeDataList, v)
      product_value = product_value + (v.season_snow_coal_value or 0)
      StrongholdList[v.id] = true
      cityCount = cityCount + 1
    end
    local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
    if RewardInfo and 0 < #RewardInfo then
      for _, v in ipairs(RewardInfo) do
        if v and 0 < toInt(v.leftNum) then
          if StrongholdList[v.id] then
            v.dummyData = false
          else
            local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(v.id), v.serverId)
            if cityMeta then
              v.dummyData = true
              table.insert(self.activeDataList, cityMeta)
            end
          end
        end
      end
    end
  end
  if self.activeTabIndex == 1 then
    local CrossOccupyCityMaxNumLocal = DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal
    self.tips_count:SetLocalText("302290", cityCount .. "/" .. CrossOccupyCityMaxNumLocal)
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
    local meta = DataCenter.AllianceCityTemplateManager:GetCityByLevel(1, sourceServerId, WorldAllianceCityType.City)
    if meta then
      local resId = toInt(meta.season_snow_stone_id)
      if 0 < resId and resId ~= ResourceType.AllianceStone then
        self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resId))
      end
    end
  elseif self.activeTabIndex == 2 then
    local strongholdMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s4_stronghold", "k4", 6))
    local CrossOccupyStrongholdMaxNum = DataCenter.SeasonDataManager.CrossOccupyStrongholdMaxNum
    if CrossOccupyStrongholdMaxNum then
      local tmp = toInt(CrossOccupyStrongholdMaxNum[tostring(LuaEntry.Player:GetSourceServerId())])
      if 0 < tmp then
        strongholdMax = tmp
      end
    end
    self.tips_count:SetLocalText("season_s2_city_description_04", cityCount, strongholdMax)
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT))
    local meta = DataCenter.AllianceCityTemplateManager:GetCityByLevel(1, sourceServerId, WorldAllianceCityType.Stronghold)
    if meta then
      local resProductDict = meta.resProductDict
      if resProductDict then
        for strResId, nResCount in pairs(resProductDict) do
          local resId = toInt(strResId)
          if 0 < resId and resId ~= ResourceType.FLINT then
            self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resId))
          end
        end
      end
    end
  elseif self.activeTabIndex == 3 then
    local stationMax = 6
    local CrossOccupyStationMaxNum = DataCenter.SeasonDataManager.CrossOccupyStationMaxNum
    if seasonType == SeasonMapType.Darkness then
      stationMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s4_station", "k4", 6))
    elseif seasonType == SeasonMapType.NineNation then
      stationMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s5_station", "k4", 6))
    end
    if CrossOccupyStationMaxNum then
      local tmp = toInt(CrossOccupyStationMaxNum[tostring(LuaEntry.Player:GetSourceServerId())])
      if 0 < tmp then
        stationMax = tmp
      end
    end
    self.tips_count:SetLocalText("season_s2_city_description_04", cityCount, stationMax)
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
  end
  self.tips_speed:SetText(Localization:GetString("season_s2_city_description_05") .. string.GetFormattedStr2(product_value) .. "/h")
  if cityCount == 0 then
    self.no_data:SetActive(true)
    self.tips:SetActive(true)
    CS.UIGray.SetGray(self.btn_collect_res.transform, true, false)
    return
  end
  table.sort(self.activeDataList, function(a, b)
    if a.type == b.type then
      if a.level == b.level then
        return a.id > b.id
      end
      return a.level > b.level
    end
    return a.type < b.type
  end)
  self.btn_effect:SetActive(true)
  self.tips:SetActive(false)
  self.no_data:SetActive(false)
  self.ScrollView:SetTotalCount(#self.activeDataList)
  self.ScrollView:RefillCells()
  self:ReCalcResourceInfo()
end

function UILWSeasonCityOccupyListS4View:OnCollectResourceSuccess(t)
  local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
  if RewardInfo then
    for _, v in ipairs(RewardInfo) do
      if v.id == t.strongholdId and v.serverId == t.serverId then
        v.leftNum = 0
        break
      end
    end
  end
  self:ReCalcResourceInfo()
end

function UILWSeasonCityOccupyListS4View:OnBatchCollectResourceSuccess(serverId)
  DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo = nil
  CS.UIGray.SetGray(self.btn_collect_res.transform, true, false)
end

function UILWSeasonCityOccupyListS4View:ReCalcResourceInfo()
  local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
  if RewardInfo then
    local hasResource = false
    for k, v in pairs(RewardInfo) do
      if v and toInt(v.leftNum) > 0 then
        hasResource = true
        break
      end
    end
    CS.UIGray.SetGray(self.btn_collect_res.transform, not hasResource, hasResource)
  else
    CS.UIGray.SetGray(self.btn_collect_res.transform, true, false)
  end
end

function UILWSeasonCityOccupyListS4View:ShowEffectInfo()
  local cityCount = 0
  local effects = {}
  local isGhostKingAlive = false
  if self.serverCityDataList then
    local ghostKingStatusList = self.ghostKingStatusList
    for k, v in pairs(self.serverCityDataList) do
      local cityId = toInt(v.id)
      isGhostKingAlive = false
      if ghostKingStatusList and ghostKingStatusList[cityId] then
        isGhostKingAlive = ghostKingStatusList[cityId].isGhostKingAlive
      end
      if not isGhostKingAlive then
        if v and v.buff ~= nil and v.buff ~= "" and v.buff ~= 0 then
          local effectId, effectValue = string.match(v.buff, "([^;]+);([^;]+)")
          if effectId and effectValue then
            local nKey = toInt(effectId)
            effects[nKey] = (effects[nKey] or 0) + tonumber(effectValue)
          end
        end
        cityCount = cityCount + 1
      end
    end
  end
  if self.serverStrongholdDataList then
    for k, v in pairs(self.serverStrongholdDataList) do
      if v and v.buff ~= nil and v.buff ~= "" and v.buff ~= 0 then
        local effectId, effectValue = string.match(v.buff, "([^;]+);([^;]+)")
        if effectId and effectValue then
          local nKey = toInt(effectId)
          effects[nKey] = (effects[nKey] or 0) + tonumber(effectValue)
        end
      end
      cityCount = cityCount + 1
    end
  end
  if cityCount == 0 then
    self.effect_tip_root:ShowEffectInfo(nil)
    return
  end
  local appendData = {}
  local product_stone_value = 0
  for k, v in pairs(self.serverCityDataList) do
    product_stone_value = product_stone_value + (v.season_snow_stone_value or 0)
  end
  local product_coal_value = 0
  for k, v in pairs(self.serverStrongholdDataList) do
    product_coal_value = product_coal_value + (v.season_snow_coal_value or 0)
    product_stone_value = product_stone_value + (v.season_snow_stone_value or 0)
  end
  if 0 < product_stone_value then
    appendData.season_s2_city_description_08 = string.GetFormattedSeparatorNum(product_stone_value) .. "/h"
  end
  if 0 < product_coal_value then
    appendData.season_s2_city_description_09 = string.GetFormattedSeparatorNum(product_coal_value) .. "/h"
  end
  self.effect_tip_root:ShowEffectInfo(effects, appendData)
end

function UILWSeasonCityOccupyListS4View:Update1000MS()
  if self.world_time_text then
    local mgr = UITimeManager:GetInstance()
    if string.IsNullOrEmpty(self.worldText) then
      self.worldText = Localization:GetString("800811") .. ": "
    end
    self.world_time_text:SetText(self.worldText .. mgr:TimeStampToTimeForServer(mgr:GetServerTime()))
  end
end

function UILWSeasonCityOccupyListS4View:CollectResource()
  SFSNetwork.SendMessage(MsgDefines.BatchCollectStrongholdResource, LuaEntry.Player:GetSourceServerId())
end

function UILWSeasonCityOccupyListS4View:TryShowTradeStation()
  if self.tradeStationCom == nil then
    if self.tradeStationComReq == nil then
      self.tradeStationComReq = self:GameObjectInstantiateAsync(tradeStationListPrefab, function()
        local obj = self.tradeStationComReq.gameObject
        if obj == nil then
          return
        end
        local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
        obj.transform:SetParent(self.dynamic_root.transform)
        obj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        rectTransform:Set_offsetMin(0, 0)
        rectTransform:Set_offsetMax(0, 0)
        self.tradeStationCom = self.dynamic_root:AddComponent(TradeStationListComponent, obj.name)
        self.tradeStationCom:Init(TradeStationListShowType.Alliance)
        if self.activeTabIndex == 3 then
          self.tradeStationCom:Show()
        else
          self.tradeStationCom:Hide()
        end
      end)
    end
  else
    self.tradeStationCom:Show()
  end
end

function UILWSeasonCityOccupyListS4View:TryHideTradeStation()
  if self.tradeStationCom then
    self.tradeStationCom:Hide()
  end
end

function UILWSeasonCityOccupyListS4View:TradeStationDataUpdate()
  if self.tradeStationCom then
    self.tradeStationCom:RefreshData()
  end
end

return UILWSeasonCityOccupyListS4View
