local UILWPowerHouseView = BaseClass("UILWPowerHouseView", UIBaseView)
local base = UIBaseView
local lastActiveTab = 1
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local tab_bottom_path = "PopUpTitle/TabBottom"
local tab_top_path = "PopUpTitle/TabTop"
local tab_item1_path = "PopUpTitle/TabBottom/TabItem1"
local tab_item2_path = "PopUpTitle/TabBottom/TabItem2"
local tab_item3_path = "PopUpTitle/TabBottom/TabItem3"
local content_path = "PopUpTitle/Content"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_path = "PopUpTitle/ContentTop/title"
local icon_info_path = "PopUpTitle/ContentTop/title/iconInfo"

function UILWPowerHouseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.defaultTab = self:GetUserData()
  if self.defaultTab then
    local index = toInt(self.defaultTab)
    if index == 1 or index == 2 or index == 3 then
      lastActiveTab = index
    end
  end
  local mgr = DataCenter.SeasonPowerWorkerManager
  local lightHouseStatus = mgr.lightHouseStatus
  if lightHouseStatus == nil or not lightHouseStatus.active then
    lastActiveTab = 1
  end
  self.tab_bottom:SetActive(true)
  self.tab_top:SetActive(true)
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  elseif lastActiveTab == 2 then
    self.tab_item2:SetIsOn(true)
  elseif lastActiveTab == 3 then
    self.tab_item3:SetIsOn(true)
  end
  if self.activeTab == nil then
    self:OnTabChanged(lastActiveTab)
  end
  if LuaEntry.Player:IsInAlliance() and DataCenter.AllianceMemberDataManager:GetAllianceMembersHomePosCount() == 0 then
    SFSNetwork.SendMessage(MsgDefines.AlRank, LuaEntry.Player.allianceId)
  end
  SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
  if lightHouseStatus == nil or not lightHouseStatus.active then
    self.tab_bottom:SetActive(false)
    self.tab_top:SetActive(false)
  end
end

function UILWPowerHouseView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPowerHouseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
end

function UILWPowerHouseView:OnRemoveListener()
  self:RemoveUIListener(EventId.PowerWorkerUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWPowerHouseView:ComponentDefine()
  self.tab_bottom = self:AddComponent(UIBaseContainer, tab_bottom_path)
  self.tab_top = self:AddComponent(UIBaseContainer, tab_top_path)
  self.close_panel = self:AddComponent(UIButton, panel_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.infoBtn = self:AddComponent(UIButton, icon_info_path)
  self.close_panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(3)
    end
  end)
end

function UILWPowerHouseView:ComponentDestroy()
  self.btn_back = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.content = nil
  self.close_btn = nil
  self.title = nil
  self.icon_info = nil
end

function UILWPowerHouseView:OnTabChanged(tabIndex)
  lastActiveTab = tabIndex
  self.activeTab = tabIndex
  self.close_btn:SetActive(tabIndex == 1)
  if tabIndex == 1 then
    self.title:SetActive(true)
    self.title:SetLocalText("season_s4_building_ui_btn01")
    if self.tab1Root == nil then
      local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.UILWPowerHouseTab1"
      local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/PowerHouseTab1.prefab"
      self.tab1Root = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.content)
    else
      self.tab1Root:UpdateData()
    end
  elseif tabIndex == 2 then
    self.title:SetActive(true)
    self.title:SetLocalText("season_s4_building_ui_btn02")
    if self.tab2Root == nil then
      local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.UILWPowerHouseTab2"
      local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/PowerHouseTab2.prefab"
      self.tab2Root = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.content)
    else
      self.tab2Root:UpdateData()
    end
    UIUtil.CheckEventTrigger(OpMode.ClickBtnLightHouseTab2)
  elseif tabIndex == 3 then
    self.title:SetActive(true)
    self.title:SetLocalText("season_s4_building_ui_btn03")
    if self.tab3Root == nil then
      local luaPath = "UI.LWSeason4.UILWPowerHouse.Component.UILWPowerHouseTab3"
      local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/PowerHouse/PowerHouseTab3.prefab"
      self.tab3Root = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.content)
    else
      self.tab3Root:UpdateData()
    end
  end
  if self.tab1Root ~= nil then
    self.tab1Root:SetActive(tabIndex == 1)
  end
  if self.tab2Root ~= nil then
    self.tab2Root:SetActive(tabIndex == 2)
  end
  if self.tab3Root ~= nil then
    self.tab3Root:SetActive(tabIndex == 3)
  end
end

function UILWPowerHouseView:UpdateData()
  local mgr = DataCenter.SeasonPowerWorkerManager
  local lightHouseStatus = mgr.lightHouseStatus
  if lightHouseStatus and lightHouseStatus.active then
    self.tab_bottom:SetActive(true)
    self.tab_top:SetActive(true)
  else
    self.tab_bottom:SetActive(false)
    self.tab_top:SetActive(false)
  end
end

return UILWPowerHouseView
