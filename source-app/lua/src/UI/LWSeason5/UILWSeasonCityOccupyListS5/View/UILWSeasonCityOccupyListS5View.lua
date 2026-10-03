local UILWSeasonCityOccupyListS5View = BaseClass("UILWSeasonCityOccupyListS5View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonCityOccupyTip = require("UI.LWSeasonShared.Component.LWSeasonCityOccupyTip")
local DetailItem = require("UI.LWSeason5.UILWSeasonCityOccupyListS5.Component.UILWSeasonCityOccupyListS5Item")
local DetailBankItem = require("UI.LWSeason5.UILWSeasonCityOccupyListS5.Component.UILWSeasonCityOccupyListS5BankItem")
local TradeStationListComponent = require("UI.LWSeason5.UILWSeasonCityOccupyListS5.Component.TradeStationListComponentS5")
local tradeStationListPrefab = "Assets/Main/SeasonRes/S5/Prefabs/UI/CityOccupy/TradeStationListCom.prefab"
local tab_item_stronghold_red_point_path = "Root/Tab/TabItemStronghold/TabItemStrongholdRedPoint"
local tab_item_city_red_point_path = "Root/Tab/TabItemCity/TabItemCityRedPoint"
local trade_station_red_point_path = "Root/Tab/TradeStation/TradeStationRedPoint"
local content_path = "Root/Content"
local scroll_view_path = "Root/Content/ScrollView"
local scroll_view2_path = "Root/Content/ScrollView2"
local tab_item_city_path = "Root/Tab/TabItemCity"
local tab_item_stronghold_path = "Root/Tab/TabItemStronghold"
local world_time_text_path = "Root/Content/WorldTimeBg/WorldTimeText"
local tips_count_path = "Root/Content/tipsCount"
local tips_speed_path = "Root/Content/tipsSpeed"
local res_icon_path = "Root/Content/tipsSpeed/res_icon"
local btn_back_path = "Root/BottomBar/BtnBack"
local info_btn_path = "Root/TopBar/TitleContent/InfoBtn"
local tips_path = "Root/Content/Tips"
local no_data_path = "Root/Content/Tips/NoData"
local btn_collect_city_res_path = "Root/BottomBar/BtnCollectCityRes"
local btn_collect_res_path = "Root/BottomBar/BtnCollectRes"
local btn_view_bank_path = "Root/BottomBar/BtnBankView"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local tip_root_path = "Root/BottomBar/TipRoot"
local trade_station_path = "Root/Tab/TradeStation"
local dynamic_root_path = "Root/dynamicRoot"

function UILWSeasonCityOccupyListS5View:OnCreate()
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
  self:UpdateData()
  self:Update1000MS()
end

function UILWSeasonCityOccupyListS5View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListS5View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
  self:AddUIListener(EventId.CrossOccupyStrongholdListUpdate, self.UpdateData)
  self:AddUIListener(EventId.CollectAllianceCityResourceSuccess, self.OnCollectCityResourceSuccess)
  self:AddUIListener(EventId.BatchCollectAllianceCityResourceSuccess, self.OnBatchCollectCityResourceSuccess)
  self:AddUIListener(EventId.GetAllAllianceTradeStationData, self.TradeStationDataUpdate)
end

function UILWSeasonCityOccupyListS5View:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossOccupyCityListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.CrossOccupyStrongholdListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.CollectAllianceCityResourceSuccess, self.OnCollectCityResourceSuccess)
  self:RemoveUIListener(EventId.BatchCollectAllianceCityResourceSuccess, self.OnBatchCollectCityResourceSuccess)
  self:RemoveUIListener(EventId.GetAllAllianceTradeStationData, self.TradeStationDataUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonCityOccupyListS5View:ComponentDefine()
  self.tab_item_stronghold_red_point = self:AddComponent(UIImage, tab_item_stronghold_red_point_path)
  self.tab_item_city_red_point = self:AddComponent(UIImage, tab_item_city_red_point_path)
  self.trade_station_red_point = self:AddComponent(UIImage, trade_station_red_point_path)
  self.tipsInfo = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/tipsInfo")
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.world_time_text = self:AddComponent(UITextMeshProUGUIEx, world_time_text_path)
  self.tips_count = self:AddComponent(UITextMeshProUGUIEx, tips_count_path)
  self.tips_speed = self:AddComponent(UITextMeshProUGUIEx, tips_speed_path)
  self.res_icon = self:AddComponent(UIImage, res_icon_path)
  self.dynamic_root = self:AddComponent(UIBaseContainer, dynamic_root_path)
  self.info_btn:SetActive(true)
  self.info_btn:SetOnClick(function()
    self:ShowEffectInfoNew()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.ScrollView2 = self:AddComponent(UIScrollView, scroll_view2_path)
  self.ScrollView2:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn2(itemObj, index)
  end)
  self.ScrollView2:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut2(itemObj, index)
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
  self.btn_view_bank = self:AddComponent(UIButton, btn_view_bank_path)
  self.btn_collect_city_res = self:AddComponent(UIButton, btn_collect_city_res_path)
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.effect_tip_root = self:AddComponent(LWSeasonCityOccupyTip, tip_root_path)
  self.tab_item_stronghold_red_point:SetActive(false)
  self.tab_item_city_red_point:SetActive(false)
  self.trade_station_red_point:SetActive(false)
  self.effect_tip_root:SetActive(false)
  self.tips:SetActive(false)
  self.no_data:SetActive(false)
  self.no_data:SetLocalText("456513")
  self.btn_effect:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonS5CrossOccupyDetail)
  end)
  self.btn_collect_res:SetOnClick(function()
    self:CollectResource()
  end)
  self.btn_view_bank:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankCity, {anim = true})
  end)
  self.btn_collect_city_res:SetOnClick(function()
    self:CollectCityResource()
  end)
end

function UILWSeasonCityOccupyListS5View:ComponentDestroy()
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

function UILWSeasonCityOccupyListS5View:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(DetailItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.activeDataList[index], self.activeTabIndex == 1)
  end
end

function UILWSeasonCityOccupyListS5View:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, DetailItem)
end

function UILWSeasonCityOccupyListS5View:OnRankItemMoveIn2(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView2:AddComponent(DetailBankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.activeDataList[index], false)
  end
end

function UILWSeasonCityOccupyListS5View:OnRankItemMoveOut2(itemObj, index)
  self.ScrollView2:RemoveComponent(itemObj.name, DetailBankItem)
end

function UILWSeasonCityOccupyListS5View:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(DetailItem)
  self.ScrollView2:ClearCells()
  self.ScrollView2:RemoveComponents(DetailBankItem)
end

function UILWSeasonCityOccupyListS5View:SelectTab(tabIndex)
  self.fightOpenTime = nil
  self.activeTabIndex = tabIndex
  self.tab_item_stronghold_red_point:SetActive(false)
  self.tab_item_city_red_point:SetActive(false)
  self.trade_station_red_point:SetActive(false)
  if tabIndex ~= 1 then
    local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo
    if RewardInfo and 0 < #RewardInfo then
      for _, v in ipairs(RewardInfo) do
        if v.leftNum and v.leftNum ~= 0 then
          self.tab_item_city_red_point:SetActive(true)
          break
        end
      end
    end
  end
  if tabIndex ~= 2 then
    local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
    if RewardInfo and 0 < #RewardInfo then
      for _, v in ipairs(RewardInfo) do
        if v.leftNum and v.leftNum ~= 0 then
          self.tab_item_stronghold_red_point:SetActive(true)
          break
        end
      end
    end
  end
  if self.activeTabIndex == 1 or self.activeTabIndex == 2 then
    self.content:SetActive(true)
    self:TryHideTradeStation()
    self:UpdateUI()
  else
    self.content:SetActive(false)
    self.tipsInfo:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.GetAllAllianceTradeMessage, LuaEntry.Player:GetAllianceUid())
    self:TryShowTradeStation()
  end
end

function UILWSeasonCityOccupyListS5View:UpdateData()
  if self.tab_item_city == nil or self.tab_item_stronghold == nil then
    return
  end
  if self.activeTabIndex > 0 and self.activeTabIndex ~= 1 and self.activeTabIndex ~= 2 then
    return
  end
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList or {}
  local serverCityDataList = {}
  local serverStrongholdDataList = {}
  local cityMgr = DataCenter.AllianceCityTemplateManager
  local cityMeta
  for k, v in pairs(CrossOccupyCityList) do
    cityMeta = cityMgr:GetTemplate(toInt(v.cityId), v.serverId)
    if cityMeta and cityMeta:IsCity() then
      serverCityDataList[cityMeta.id] = cityMeta
    end
  end
  local totalDeposite = 0
  for k, v in pairs(CrossOccupyStrongholdList) do
    cityMeta = cityMgr:GetTemplate(toInt(v.id), v.serverId)
    if cityMeta then
      totalDeposite = totalDeposite + (v.depositAmount or 0)
      serverStrongholdDataList[cityMeta.id] = cityMeta
    end
  end
  self.totalDeposite = totalDeposite
  self.serverCityDataList = serverCityDataList
  self.serverStrongholdDataList = serverStrongholdDataList
  self.fightOpenTime = nil
  if self.activeTabIndex == nil or self.activeTabIndex == 0 or self.activeTabIndex == 1 then
    self.tab_item_city:SetIsOn(true)
    self:SelectTab(1)
  elseif self.activeTabIndex == 2 then
    self.tab_item_stronghold:SetIsOn(true)
    self:SelectTab(2)
  else
    self:UpdateUI()
  end
end

function UILWSeasonCityOccupyListS5View:UpdateUI()
  self:ClearScroll()
  local cityMgr = DataCenter.AllianceCityTemplateManager
  local dailyDeclareNum = DataCenter.SeasonDataManager.dailyDeclareNum or 0
  local dailyOccupyNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyNum or 0
  local dailyOccupyMaxNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum or 0
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self.fightOpenTime = nil
  if self.activeTabIndex == 1 then
    local isDeclareDay = DataCenter.UILWSeasonAllianceWarTimeManager:IsDeclareDay()
    local isCrossDeclareActiveOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossDeclareWarActivity.Type)
    if isDeclareDay and isCrossDeclareActiveOpen then
      self.tipsInfo:SetActive(true)
      self.tipsInfo:SetLocalText("season_s2_city_description_07", k6 - dailyDeclareNum, k6)
    else
      self.tipsInfo:SetActive(true)
      self.fightOpenTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextDeclareTime()
      self:Update1000MS()
    end
  elseif self.activeTabIndex == 2 then
    self.tipsInfo:SetActive(true)
    self.tipsInfo:SetLocalText("season_s2_city_description_06", dailyOccupyMaxNum - dailyOccupyNum, dailyOccupyMaxNum)
  else
    self.tipsInfo:SetActive(false)
  end
  local cityCount = 0
  local product_value = 0
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  self.effect_tip_root:SetActive(false)
  self.activeDataList = {}
  if self.activeTabIndex == 1 then
    local CityList = {}
    for k, v in pairs(self.serverCityDataList) do
      table.insert(self.activeDataList, v)
      product_value = product_value + (v.itemProductCount or 0)
      CityList[v.id] = true
      cityCount = cityCount + 1
    end
    local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo
    if RewardInfo and 0 < #RewardInfo then
      for _, v in ipairs(RewardInfo) do
        if v and 0 < toInt(v.leftNum) then
          if CityList[v.id] then
            v.dummyData = false
          else
            local cityMeta = cityMgr:GetTemplate(toInt(v.id), v.serverId)
            if cityMeta then
              v.dummyData = true
              table.insert(self.activeDataList, cityMeta)
            end
          end
        end
      end
    end
  else
    local StrongholdList = {}
    for k, v in pairs(self.serverStrongholdDataList) do
      table.insert(self.activeDataList, v)
      StrongholdList[v.id] = true
      cityCount = cityCount + 1
    end
    product_value = self.totalDeposite
    local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo
    if RewardInfo and 0 < #RewardInfo then
      for _, v in ipairs(RewardInfo) do
        if v and 0 < toInt(v.leftNum) then
          if StrongholdList[v.id] then
            v.dummyData = false
          else
            local cityMeta = cityMgr:GetTemplate(toInt(v.id), v.serverId)
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
    local meta = cityMgr:GetCityByLevel(1, sourceServerId, WorldAllianceCityType.City)
    if meta then
      local itemProductId = meta.itemProductId
      local itemProductCount = meta.itemProductCount
      if itemProductId and itemProductCount then
        local itemMeta = DataCenter.ItemTemplateManager:TryGetItemTemplate(itemProductId)
        if itemMeta then
          local seasonIndex = SeasonUtil.GetSeason()
          local icon, name, desc, name_value = itemMeta:GetDetailInfo(seasonIndex)
          local iconUrl = string.format(LoadPath.ItemPath, icon)
          self.res_icon:LoadSprite(iconUrl)
        end
      else
        self.res_icon:LoadSprite("Assets/Main/Sprites/ItemIcons/LXY_s5_jinjiejing_icon.png")
      end
    end
    self.tips_speed:SetText(Localization:GetString("season_s2_city_description_05") .. string.GetFormattedStr2(product_value) .. "/h")
  elseif self.activeTabIndex == 2 then
    local strongholdMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s5_stronghold", "k4", 6))
    local CrossOccupyStrongholdMaxNum = DataCenter.SeasonDataManager.CrossOccupyStrongholdMaxNum
    if CrossOccupyStrongholdMaxNum then
      local tmp = toInt(CrossOccupyStrongholdMaxNum[tostring(LuaEntry.Player:GetSourceServerId())])
      if 0 < tmp then
        strongholdMax = tmp
      end
    end
    self.tips_count:SetLocalText("season_s2_city_description_04", cityCount, strongholdMax)
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FLINT))
    local meta = cityMgr:GetCityByLevel(1, sourceServerId, WorldAllianceCityType.Stronghold)
    DataCenter.SeasonBankManager:LoadItemIcon(self.res_icon, meta)
    self.tips_speed:SetText(Localization:GetString("season_s5_bankbook_05", string.GetFormattedStr2(product_value)))
  elseif self.activeTabIndex == 3 then
    local stationMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s5_station", "k4", 6))
    local CrossOccupyStationMaxNum = DataCenter.SeasonDataManager.CrossOccupyStationMaxNum
    if CrossOccupyStationMaxNum then
      local tmp = toInt(CrossOccupyStationMaxNum[tostring(LuaEntry.Player:GetSourceServerId())])
      if 0 < tmp then
        stationMax = tmp
      end
    end
    self.tips_count:SetLocalText("season_s2_city_description_04", cityCount, stationMax)
    self.res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
    self.tips_speed:SetText(Localization:GetString("season_s2_city_description_05") .. string.GetFormattedStr2(product_value) .. "/h")
  end
  if cityCount == 0 then
    self.no_data:SetActive(true)
    self.tips:SetActive(true)
    self.btn_view_bank:SetActive(false)
    if self.activeTabIndex == 1 then
      CS.UIGray.SetGray(self.btn_collect_city_res.transform, true, false)
    end
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
  self.btn_effect:SetActive(self.activeTabIndex == 1)
  self.btn_collect_res:SetActive(self.activeTabIndex == 2)
  self.btn_view_bank:SetActive(self.activeTabIndex == 2)
  self.btn_collect_city_res:SetActive(self.activeTabIndex == 1)
  self.tips:SetActive(false)
  self.no_data:SetActive(false)
  if self.activeTabIndex == 1 then
    self.ScrollView:SetActive(true)
    self.ScrollView2:SetActive(false)
    self.ScrollView:SetTotalCount(#self.activeDataList)
    self.ScrollView:RefillCells()
  else
    self.ScrollView:SetActive(false)
    self.ScrollView2:SetActive(true)
    self.ScrollView2:SetTotalCount(#self.activeDataList)
    self.ScrollView2:RefillCells()
  end
  self:ReCalcCityResourceInfo()
end

function UILWSeasonCityOccupyListS5View:OnCollectCityResourceSuccess(t)
  local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo
  if RewardInfo then
    for _, v in ipairs(RewardInfo) do
      if v.id == t.cityId and v.serverId == t.serverId then
        v.leftNum = 0
        break
      end
    end
  end
  self:ReCalcCityResourceInfo()
end

function UILWSeasonCityOccupyListS5View:OnBatchCollectCityResourceSuccess(serverId)
  DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo = nil
  CS.UIGray.SetGray(self.btn_collect_city_res.transform, true, false)
end

function UILWSeasonCityOccupyListS5View:ReCalcCityResourceInfo()
  local RewardInfo = DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo
  if RewardInfo then
    local hasResource = false
    for k, v in pairs(RewardInfo) do
      if v and toInt(v.leftNum) > 0 then
        hasResource = true
        break
      end
    end
    CS.UIGray.SetGray(self.btn_collect_city_res.transform, not hasResource, hasResource)
  else
    CS.UIGray.SetGray(self.btn_collect_city_res.transform, true, false)
  end
end

function UILWSeasonCityOccupyListS5View:ShowEffectInfo()
  local cityCount = 0
  local effects = {}
  if self.serverCityDataList then
    for k, v in pairs(self.serverCityDataList) do
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
  local product_item_id
  local product_item_value = 0
  local product_stone_value = 0
  for k, v in pairs(self.serverCityDataList) do
    product_stone_value = product_stone_value + (v.season_snow_stone_value or 0)
    product_item_value = product_item_value + (v.itemProductCount or 0)
    product_item_id = v.itemProductId
  end
  local product_coal_value = 0
  for k, v in pairs(self.serverStrongholdDataList) do
    product_coal_value = product_coal_value + (v.season_snow_coal_value or 0)
    product_stone_value = product_stone_value + (v.season_snow_stone_value or 0)
  end
  if 0 < product_coal_value then
    appendData[Localization:GetString("season_s2_city_description_09")] = string.GetFormattedSeparatorNum(product_coal_value) .. "/h"
  end
  if product_item_id ~= nil and 0 < product_item_value then
    local meta = DataCenter.ItemTemplateManager:TryGetItemTemplate(product_item_id)
    if meta then
      local seasonIndex = SeasonUtil.GetSeason()
      local icon, name, desc, name_value = meta:GetDetailInfo(seasonIndex)
      local msg1 = Localization:GetString(name)
      local msg2 = Localization:GetString("season_s2_city_description_05")
      appendData[msg1 .. " " .. msg2] = string.GetFormattedSeparatorNum(product_item_value) .. "/h"
    end
  end
  self.effect_tip_root:ShowEffectInfo(effects, appendData, true)
end

function UILWSeasonCityOccupyListS5View:Update1000MS()
  local mgr = UITimeManager:GetInstance()
  local curTime = mgr:GetServerTime()
  if self.world_time_text then
    if string.IsNullOrEmpty(self.worldText) then
      self.worldText = Localization:GetString("800811") .. ": "
    end
    self.world_time_text:SetText(self.worldText .. mgr:TimeStampToTimeForServer(curTime))
  end
  if self.fightOpenTime ~= nil and self.activeTabIndex == 1 then
    local remainTime = self.fightOpenTime - curTime
    if 0 < remainTime then
      self.tipsInfo:SetLocalText("war_zone_outpost_87", mgr:MilliSecondToFmtString(remainTime))
    else
      self.tipsInfo:SetText("")
    end
  end
end

function UILWSeasonCityOccupyListS5View:CollectCityResource()
  SFSNetwork.SendMessage(MsgDefines.BatchCollectAllianceCityResource)
end

function UILWSeasonCityOccupyListS5View:CollectResource()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.BankHistory, {anim = true})
end

function UILWSeasonCityOccupyListS5View:TryShowTradeStation()
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

function UILWSeasonCityOccupyListS5View:TryHideTradeStation()
  if self.tradeStationCom then
    self.tradeStationCom:Hide()
  end
end

function UILWSeasonCityOccupyListS5View:TradeStationDataUpdate()
  if self.tradeStationCom then
    self.tradeStationCom:RefreshData()
  end
end

function UILWSeasonCityOccupyListS5View:ShowEffectInfoNew()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityEffectTips)
end

return UILWSeasonCityOccupyListS5View
