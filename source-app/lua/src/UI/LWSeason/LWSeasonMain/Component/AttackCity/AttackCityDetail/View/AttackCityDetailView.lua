local SeasonAttackCityDetailView = BaseClass("SeasonAttackCityDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonCityOccupyTip = require("UI.LWSeasonShared.Component.LWSeasonCityOccupyTip")
local DetailItem = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityDetail.Component.AttackCityDetailItem")
local DetailGroup = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityDetail.Component.AttackCityDetailGroup")
local scroll_view_path = "Root/PackList"
local content_path = "Root/PackList/Viewport/Content"
local text_title_path = "Root/TopBar/TextTitle"
local tab_item1_path = "Root/TopBar/Tab/TabItem1"
local condition1_dark_path = "Root/TopBar/Tab/TabItem1/Condition1Dark"
local condition1_path = "Root/TopBar/Tab/TabItem1/Condition1Select/Condition1"
local tab_item2_path = "Root/TopBar/Tab/TabItem2"
local condition2_dark_path = "Root/TopBar/Tab/TabItem2/Condition2Dark"
local condition2_path = "Root/TopBar/Tab/TabItem2/Condition2Select/Condition2"
local btn_back_path = "Root/BottomBar/BtnBack"
local item_path = "Root/PackList/UIAttackCityItem"
local tips_path = "Root/Tips"
local no_al_path = "Root/Tips/NoAL"
local tip_txt_path = "Root/Tips/NoAL/TipTxt"
local btn_go_path = "Root/Tips/NoAL/BtnGo"
local go_text_path = "Root/Tips/NoAL/BtnGo/GoText"
local no_data_path = "Root/Tips/NoData"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local tip_root_path = "Root/BottomBar/TipRoot"
local btn_rank_path = "Root/BottomBar/BtnRank"
local city_count_desc_path = "Root/PackList/GameObject/list1/CityCountDesc"
local city_count_value_path = "Root/PackList/GameObject/list1/CityCountValue"
local city_loot_desc_path = "Root/PackList/GameObject/list2/CityLootDesc"
local city_loot_value_path = "Root/PackList/GameObject/list2/CityLootValue"
local city_group_title_path = "Root/PackList/Viewport/CityGroupTitle"
local city_group_title_txt_path = "Root/PackList/Viewport/CityGroupTitle/Title"
local city_group_title_open_path = "Root/PackList/Viewport/CityGroupTitle/Title/open"

function SeasonAttackCityDetailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  local allianceId = LuaEntry.Player:GetAllianceUid()
  if not string.IsNullOrEmpty(allianceId) then
    local occupied, unmanned = DataCenter.AllianceCityTemplateManager:GetOccupiedCityList(allianceId, true)
    self.cityOccupied = occupied
    self.cityUnmanned = unmanned
  end
  self.param = param
  self:ComponentDefine()
end

function SeasonAttackCityDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAttackCityDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  self:AddUIListener(EventId.CrossOccupyStrongholdListUpdate, self.OnOccupyStrongholdListUpdate)
end

function SeasonAttackCityDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.CrossOccupyStrongholdListUpdate, self.OnOccupyStrongholdListUpdate)
  base.OnRemoveListener(self)
end

function SeasonAttackCityDetailView:ComponentDefine()
  self.city_group_title_root = self:AddComponent(UIImage, city_group_title_path)
  self.city_group_title_txt = self:AddComponent(UIText, city_group_title_txt_path)
  self.city_group_title_open = self:AddComponent(UIText, city_group_title_open_path)
  self.city_group_title_root:SetActive(false)
  self.tip1 = self:AddComponent(UIText, "Root/BottomBar/tips1")
  self.tip2 = self:AddComponent(UIText, "Root/BottomBar/tips2")
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.condition1 = self:AddComponent(UIText, condition1_path)
  self.condition2 = self:AddComponent(UIText, condition2_path)
  self.condition1_dark = self:AddComponent(UIText, condition1_dark_path)
  self.condition2_dark = self:AddComponent(UIText, condition2_dark_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tips = self:AddComponent(UIBaseContainer, tips_path)
  self.no_al = self:AddComponent(UIBaseContainer, no_al_path)
  self.no_data = self:AddComponent(UIText, no_data_path)
  self.no_al_tip_txt = self:AddComponent(UIText, tip_txt_path)
  self.btn_join_al = self:AddComponent(UIButton, btn_go_path)
  self.btn_join_al_text = self:AddComponent(UIText, go_text_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.btn_effect = self:AddComponent(UIButton, btn_effect_path)
  self.effect_tip_root = self:AddComponent(LWSeasonCityOccupyTip, tip_root_path)
  self.text_title:SetLocalText("456505")
  self.condition1:SetLocalText("456507")
  self.condition1_dark:SetLocalText("456507")
  self.condition2:SetLocalText("456508")
  self.condition2_dark:SetLocalText("456508")
  self.effect_tip_root:SetActive(false)
  self.tips:SetActive(false)
  self.no_al:SetActive(false)
  self.no_data:SetActive(false)
  self.no_data:SetLocalText("456513")
  self.no_al_tip_txt:SetLocalText("456516")
  self.btn_join_al_text:SetLocalText("110007")
  self.city_count_desc = self:AddComponent(UIText, city_count_desc_path)
  self.city_count_value = self:AddComponent(UIText, city_count_value_path)
  self.city_loot_desc = self:AddComponent(UIText, city_loot_desc_path)
  self.city_loot_value = self:AddComponent(UIText, city_loot_value_path)
  self.city_count_desc:SetLocalText("season_alliance_city_has")
  self.city_loot_desc:SetLocalText("season_sever_intrusion_015", "")
  self.city_loot_value:SetText("0")
  local seasonType = SeasonUtil.GetSeasonType()
  local showCityLoot = seasonType == SeasonMapType.Desert or seasonType == SeasonMapType.CityStronghold
  self.city_loot_desc:SetActive(showCityLoot)
  self.city_loot_value:SetActive(showCityLoot)
  self.scroll_view:AddValueChangeListener(function(vec)
    self:OnScrollValueChange()
  end)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(function()
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonAttackCityActivity.Type)
    local actInfo = actList and actList[1] or nil
    if actInfo and actInfo.id then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityRank, actInfo.id)
    end
  end)
  self.btn_effect:SetOnClick(function()
    self:ShowEffectInfo()
  end)
  self.btn_join_al:SetOnClick(function()
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
  end)
  local groupList = {}
  for i = 1, 7 do
    groupList[i] = self:AddComponent(DetailGroup, "Root/PackList/Viewport/Content/CityGroup" .. i)
  end
  self.groupList = groupList
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(2)
    end
  end)
  if seasonType ~= SeasonMapType.CityStronghold then
    self.btn_rank:SetActive(false)
    self.btn_effect:SetLocalPositionXYZ(0, 108, 0)
  end
  local showOccupiabe = self:GetUserData()
  if showOccupiabe then
    self.tab_item2:SetIsOn(true)
    self:SelectTab(2)
  else
    self.tab_item1:SetIsOn(true)
    if self.instCursor == nil then
      self:SelectTab(1)
    end
  end
end

function SeasonAttackCityDetailView:ComponentDestroy()
  for i = 1, 7 do
    self.groupList[i]:Clean()
  end
  self.theItem:GameObjectRecycleAll()
  self.scroll_view = nil
  self.content = nil
  self.text_title = nil
  self.tab_item1 = nil
  self.condition1_dark = nil
  self.condition1 = nil
  self.tab_item2 = nil
  self.condition2_dark = nil
  self.condition2 = nil
  self.btn_back = nil
  self.instCursor = nil
end

function SeasonAttackCityDetailView:OnScrollValueChange()
  if self.Updating then
    if self.lastTopNode then
      self.lastTopNode:SetLinkTitle(nil)
      self.lastTopNode = nil
    end
    return
  end
  local topNode
  local top = self.content:GetAnchoredPositionY()
  local lastY = 0
  for i = 1, 7 do
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
  if self.lastTopNode and self.lastTopNode ~= topNode then
    self.lastTopNode:SetLinkTitle(nil)
  end
  if topNode then
    self.city_group_title_root:SetActive(true)
    self.city_group_title_txt:SetText(topNode.title:GetText())
    self.city_group_title_open:SetText(topNode.open:GetText())
    topNode:SetLinkTitle(self.city_group_title_open)
  else
    self.city_group_title_root:SetActive(false)
  end
  self.lastTopNode = topNode
end

function SeasonAttackCityDetailView:SelectTab(tabIndex)
  self.activeTabIndex = tabIndex
  self:UpdateUI()
end

function SeasonAttackCityDetailView:OnSeasonForceValue(data)
  if data and data.type == 1 and data.value then
    self.city_loot_value:SetText(string.GetFormattedStr(data.value))
  end
end

function SeasonAttackCityDetailView:OnOccupyStrongholdListUpdate()
  if self.activeTabIndex == 1 and DataCenter.SeasonDataManager.CrossOccupyStrongholdList then
    self:UpdateUI()
  end
end

function SeasonAttackCityDetailView:UpdateData()
  local allianceId = LuaEntry.Player:GetAllianceUid()
  if not string.IsNullOrEmpty(allianceId) then
    local occupied, unmanned = DataCenter.AllianceCityTemplateManager:GetOccupiedCityList(allianceId, true)
    self.cityOccupied = occupied
    self.cityUnmanned = unmanned
    if self.activeTabIndex ~= nil then
      self:UpdateUI()
    end
  end
end

function SeasonAttackCityDetailView:UpdateUI()
  local dataList
  local seasonType = SeasonUtil.GetSeasonType()
  self.Updating = true
  self.activeDataList = nil
  self.instCursor = 0
  if self.lastTopNode then
    self.lastTopNode:SetLinkTitle(nil)
    self.lastTopNode = nil
  end
  self.city_group_title_root:SetActive(false)
  if self.cityOccupied == nil or self.cityOccupied == nil or not LuaEntry.Player:IsInAlliance() then
    self.tips:SetActive(true)
    self.no_al:SetActive(true)
    self.no_data:SetActive(false)
    self.btn_effect:SetActive(false)
    self.tip1:SetText("")
    self.tip2:SetText("")
    self.btn_rank:SetActive(false)
    return
  end
  local cityMax = SeasonUtil.GetOccupyCityMaxCount()
  local OccupiedText = #self.cityOccupied .. "/" .. cityMax
  self.city_count_value:SetText(OccupiedText)
  self.btn_rank:SetActive(self.activeTabIndex == 1 and seasonType == SeasonMapType.CityStronghold)
  self.btn_effect:SetActive(self.activeTabIndex == 1)
  if self.activeTabIndex == 1 then
    self.tip1:SetLocalText("season_city_count", OccupiedText)
    self.tip2:SetText("")
    dataList = self.cityOccupied
    if dataList == nil or #dataList == 0 then
      self.tips:SetActive(true)
      self.no_al:SetActive(false)
      self.no_data:SetActive(true)
      return
    end
    local loot_value = 0
    if dataList then
      for _, v in ipairs(dataList) do
        loot_value = loot_value + v.force
      end
    end
    self.city_loot_value:SetText(string.GetFormattedStr(loot_value))
  else
    self.tip1:SetText("")
    self.tip2:SetLocalText("season_city_count", OccupiedText)
    dataList = self.cityUnmanned
  end
  local DeclareWarList = {}
  local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
  if DeclareWarDataList ~= nil then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    for _, WarData in ipairs(DeclareWarDataList) do
      if WarData.aId == allianceId then
        DeclareWarList[WarData.content] = WarData
      end
    end
  end
  self.tips:SetActive(false)
  self.activeDataList = dataList
  local dataLevelGroup = {}
  local minLevel = 100
  local maxLevel = 0
  for i, v in ipairs(dataList) do
    if dataLevelGroup[v.level] == nil then
      dataLevelGroup[v.level] = {}
    end
    table.insert(dataLevelGroup[v.level], v)
    minLevel = math.min(minLevel, v.level)
    maxLevel = math.max(maxLevel, v.level)
  end
  local full_height = 0
  local jump_height = 0
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  local theGroupNode
  self.groupList[7]:SetActive(false)
  for i = 6, 1, -1 do
    if dataLevelGroup[i] ~= nil then
      theGroupNode = self.groupList[i]
      theGroupNode:SetActive(true)
      theGroupNode:ReInit(i, dataLevelGroup[i], self.theItem, cityWarInfo, DeclareWarList)
      if theGroupNode.openTime ~= nil then
        jump_height = full_height
      end
      full_height = full_height + theGroupNode.full_height
    else
      self.groupList[i]:SetActive(false)
    end
  end
  self.content:SetSizeDeltaXY(780, full_height)
  self.content:SetAnchoredPositionXY(0, jump_height)
end

function SeasonAttackCityDetailView:Update1000MS()
  if self.tooltip_tick ~= nil and self.tooltip_tick > 0 then
    self.tooltip_tick = self.tooltip_tick - 1
    if self.tooltip_tick <= 0 then
      self.effect_tip_root:SetActive(false)
    end
  end
  if self.Updating then
    self.Updating = false
  end
end

function SeasonAttackCityDetailView:ShowEffectInfo()
  local effects = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffects()
  if effects == nil or table.count(effects) == 0 then
    self.effect_tip_root:ShowEffectInfo(nil)
    return
  end
  self.effect_tip_root:ShowEffectInfo(effects, nil)
end

return SeasonAttackCityDetailView
