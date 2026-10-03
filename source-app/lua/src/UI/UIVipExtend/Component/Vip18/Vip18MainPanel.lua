local Vip18MainPanel = BaseClass("Vip18MainPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Vip18DisplayPanel = require("UI.UIVipExtend.Component.Vip18.Vip18DisplayPanel")
local Vip18CityListPanel = require("UI.UIVipExtend.Component.Vip18.Vip18CityListPanel")
local display_panel_path = "fullMask/displayPanel"
local city_list_panel_path = "fullMask/displayPanel/cityListPanel"
local bottom_arrow_path = "bottomArrow"

function Vip18MainPanel:OnCreate()
  base.OnCreate(self)
  self.display_panel = self:AddComponent(Vip18DisplayPanel, display_panel_path)
  self.city_list_panel = self:AddComponent(Vip18CityListPanel, city_list_panel_path)
  self.bottom_arrow = self:AddComponent(UIImage, bottom_arrow_path)
end

function Vip18MainPanel:OnDestroy()
  self.lastDragPosY = nil
  self.display_panel = nil
  self.city_list_panel = nil
  self.bottom_arrow = nil
  base.OnDestroy(self)
end

function Vip18MainPanel:OnEnable()
  base.OnEnable(self)
end

function Vip18MainPanel:OnDisable()
  base.OnDisable(self)
end

function Vip18MainPanel:InitPanel()
  local displayListParam = {}
  displayListParam.onNextPageClickHandler = self.OnChangeToCityListPanel
  self.display_panel:InitPanel(displayListParam)
  local cityListParam = {}
  cityListParam.onNextPageClickHandler = self.OnChangeToDisplayPanel
  self.city_list_panel:InitPanel(cityListParam)
end

function Vip18MainPanel:ShowPanel()
end

function Vip18MainPanel:HidePanel()
  self.display_panel:HidePanel()
end

function Vip18MainPanel:OnChangeToCityListPanel()
  self.bottom_arrow:SetActive(false)
end

function Vip18MainPanel:OnChangeToDisplayPanel()
  self.bottom_arrow:SetActive(true)
  self.display_panel:BackToGiftBox()
end

return Vip18MainPanel
