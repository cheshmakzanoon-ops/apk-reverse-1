local AttackCityDetailView = BaseClass("AttackCityDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWSeasonCityOccupyTip = require("UI.LWSeasonShared.Component.LWSeasonCityOccupyTip")
local DetailItem = require("UI.UIActivityAttackCity.AttackCityDetail.Component.AttackCityDetailItem")
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
local condition1_reward_path = "Root/TopBar/Tab/TabItem1/Condition1Select/Condition1/reward"

function AttackCityDetailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  local allianceId = LuaEntry.Player:GetAllianceUid()
  if not string.IsNullOrEmpty(allianceId) then
    local occupied, unmanned = DataCenter.AllianceCityTemplateManager:GetOccupiedCityList(allianceId, false)
    self.cityOccupied = occupied
    self.cityUnmanned = unmanned
  end
  self.param = param
  self:ComponentDefine()
end

function AttackCityDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AttackCityDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
end

function AttackCityDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  base.OnRemoveListener(self)
end

function AttackCityDetailView:ComponentDefine()
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
  self.reward = self:AddComponent(UIImage, condition1_reward_path)
  self.reward:SetActive(false)
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
  self.btn_effect:SetOnClick(function()
    self:ShowEffectInfo()
  end)
  self.btn_join_al:SetOnClick(function()
    SceneUtils.TryFastJoinAlliance(nil)
  end)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      if not self.tab_item1.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:SelectTab(1)
    end
    self.tab_item1.selecting = false
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      if not self.tab_item2.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:SelectTab(2)
    end
    self.tab_item2.selecting = false
  end)
  self.tab_item1:SetIsOn(true)
  if self.instCursor == nil then
    self:SelectTab(1)
  end
end

function AttackCityDetailView:ComponentDestroy()
  self.content:RemoveComponents(DetailItem)
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
  self.reward = nil
end

function AttackCityDetailView:SelectTab(tabIndex)
  self.activeTabIndex = tabIndex
  self:UpdateUI()
end

function AttackCityDetailView:UpdateData()
  if self.cityOccupied == nil or self.cityOccupied == nil then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    if not string.IsNullOrEmpty(allianceId) then
      local occupied, unmanned = DataCenter.AllianceCityTemplateManager:GetOccupiedCityList(allianceId, false)
      self.cityOccupied = occupied
      self.cityUnmanned = unmanned
      if self.activeTabIndex ~= nil then
        self:UpdateUI()
      end
    end
  end
end

function AttackCityDetailView:UpdateUI()
  local dataList
  self.activeDataList = nil
  self.instCursor = 0
  self.scroll_view:SetVerticalNormalizedPosition(1.0)
  if self.cityOccupied == nil or self.cityOccupied == nil then
    self.tips:SetActive(true)
    self.no_al:SetActive(true)
    self.no_data:SetActive(false)
    self.btn_effect:SetActive(false)
    self.tip1:SetText("")
    self.tip2:SetText("")
    return
  end
  self.btn_effect:SetActive(self.activeTabIndex == 1)
  if self.activeTabIndex == 1 then
    self.tip1:SetLocalText(458645, #self.cityOccupied)
    self.tip2:SetText("")
    dataList = self.cityOccupied
    if #dataList == 0 then
      self.tips:SetActive(true)
      self.no_al:SetActive(false)
      self.no_data:SetActive(true)
      return
    end
  else
    self.tip1:SetText("")
    self.tip2:SetLocalText(458646, #self.cityOccupied)
    dataList = self.cityUnmanned
  end
  local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
  if DeclareWarDataList ~= nil then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    local all_war = {}
    local all_war_count = 0
    for _, WarData in ipairs(DeclareWarDataList) do
      if WarData.aId == allianceId then
        local cityId = WarData.content
        all_war[cityId] = WarData
        all_war_count = all_war_count + 1
      end
    end
    if 0 < all_war_count then
      local theDataList = {}
      for i, v in ipairs(dataList) do
        if all_war[tostring(v.id)] ~= nil then
          table.insert(theDataList, 1, v)
        else
          table.insert(theDataList, v)
        end
      end
      dataList = theDataList
    end
  end
  self.tips:SetActive(false)
  self.activeDataList = dataList
  if self.theItemList ~= nil then
    for k, v in pairs(self.theItemList) do
      if v ~= nil then
        v:SetActive(false)
      end
    end
  end
  self:Update100MS()
end

function AttackCityDetailView:Update100MS()
  local dataList = self.activeDataList
  if dataList == nil or self.instCursor == nil or self.instCursor >= #dataList then
    return
  end
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  local cityInfoList, goItem, theItem
  local theItemList = self.theItemList or {}
  if cityWarInfo ~= nil then
    cityInfoList = cityWarInfo.cityInfoList
  else
    cityInfoList = {}
  end
  for i, v in ipairs(dataList) do
    if i > self.instCursor and i < self.instCursor + 4 then
      NameCount = NameCount + 1
      local NodeName = "item_" .. NameCount
      theItem = theItemList[NodeName]
      if theItem == nil then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = NodeName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(DetailItem, NodeName)
        theItemList[NodeName] = theItem
      end
      theItem:ReInit(i, v, cityInfoList[v.id])
      theItem:SetActive(true)
    end
  end
  self.instCursor = self.instCursor + 3
  self.theItemList = theItemList
  local rewardCount = DataCenter.WorldAllianceCityDataManager:OccupyRewardCount()
  self.reward:SetActive(0 < rewardCount)
end

function AttackCityDetailView:ShowEffectInfo()
  local effects = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffects()
  if effects == nil or table.count(effects) == 0 then
    self.effect_tip_root:ShowEffectInfo(nil)
    return
  end
  self.effect_tip_root:ShowEffectInfo(effects, nil)
end

return AttackCityDetailView
