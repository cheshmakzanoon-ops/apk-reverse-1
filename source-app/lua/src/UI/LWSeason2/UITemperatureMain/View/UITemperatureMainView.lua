local UITemperatureMainView = BaseClass("UITemperatureMainView", UIBaseView)
local base = UIBaseView
local HeatSourcePage = require("UI.LWSeason2.UITemperatureMain.Component.HeatSourcePage")
local TemperaturePage = require("UI.LWSeason2.UITemperatureMain.Component.TemperaturePage")
local TempGuidePage = require("UI.LWSeason2.UITemperatureMain.Component.TempGuidePage")
local TempAchievePage = require("UI.LWSeason2.UITemperatureMain.Component.TempAchievePage")
local TempBanner2 = require("UI.LWSeason2.UITemperatureMain.Component.TempBanner2")
local TempBanner3 = require("UI.LWSeason2.UITemperatureMain.Component.TempBanner3")
local panel_path = "UICommonPopUpTitle/panel"
local banner1_path = "safeArea/Banner1"
local banner2_path = "safeArea/Banner2"
local banner3_path = "safeArea/Banner3"
local close_btn_path = "safeArea/CloseBtn"
local heat_source_page_path = "safeArea/HeatSourcePage"
local temperature_page_path = "safeArea/TemperaturePage"
local guide_page_path = "safeArea/GuidePage"
local achieve_page_path = "safeArea/AchievePage"
local PageType = {
  HeatSource = 1,
  Temperature = 2,
  Guide = 3,
  Achieve = 4
}
local PageType2Banner = {
  [PageType.HeatSource] = 3,
  [PageType.Temperature] = 2,
  [PageType.Guide] = 2,
  [PageType.Achieve] = 2
}

function UITemperatureMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UITemperatureMainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITemperatureMainView:OnAddListener()
  base.OnAddListener(self)
end

function UITemperatureMainView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITemperatureMainView:ComponentDefine()
  self.curIndex = PageType.HeatSource
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.banner = {}
  self.banner[2] = self:AddComponent(TempBanner2, banner2_path)
  self.banner[3] = self:AddComponent(TempBanner3, banner3_path)
  self.banner[2]:SetActive(false)
  self.banner[3]:SetActive(false)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.page = {}
  self.page[PageType.HeatSource] = self:AddComponent(HeatSourcePage, heat_source_page_path)
  self.page[PageType.Temperature] = self:AddComponent(TemperaturePage, temperature_page_path)
  self.page[PageType.Guide] = self:AddComponent(TempGuidePage, guide_page_path)
  self.page[PageType.Achieve] = self:AddComponent(TempAchievePage, achieve_page_path)
  self.toggle = {}
  self.checkText = {}
  local toggleText = {}
  for i = 1, 4 do
    self.toggle[i] = self:AddComponent(UIToggle, "safeArea/tabSv/Viewport/Content/Toggle" .. i)
    self.checkText[i] = self:AddComponent(UITextMeshProUGUIEx, string.format("safeArea/tabSv/Viewport/Content/Toggle%s/Checkmark%s/CheckText%s", i, i, i))
    toggleText[i] = self:AddComponent(UITextMeshProUGUIEx, string.format("safeArea/tabSv/Viewport/Content/Toggle%s/OffText%s", i, i))
    self.toggle[i]:SetIsOn(self.curIndex == i)
    self.toggle[i]:SetOnValueChanged(function(bool)
      if bool then
        self:ToggleOn(i)
      end
    end)
    self.checkText[i]:SetLocalText("season_s2_temperature_ui_tab" .. i)
    toggleText[i]:SetLocalText("season_s2_temperature_ui_tab" .. i)
    self.page[i]:SetActive(false)
    self.checkText[i]:SetActive(false)
  end
end

function UITemperatureMainView:ComponentDestroy()
  self.curIndex = nil
end

function UITemperatureMainView:ToggleOn(index)
  if self.curIndex == index then
    return
  end
  self.checkText[self.curIndex]:SetActive(false)
  self.page[self.curIndex]:SetActive(false)
  self.banner[PageType2Banner[self.curIndex]]:SetActive(false)
  self.checkText[index]:SetActive(true)
  self.page[index]:SetActive(true)
  self.page[index]:Refresh()
  self.banner[PageType2Banner[index]]:SetActive(true)
  self.banner[PageType2Banner[index]]:Refresh()
  self.curIndex = index
end

function UITemperatureMainView:Init()
  self.checkText[self.curIndex]:SetActive(true)
  self.page[self.curIndex]:SetActive(true)
  self.page[self.curIndex]:Refresh()
  self.banner[PageType2Banner[self.curIndex]]:SetActive(true)
  self.banner[PageType2Banner[self.curIndex]]:Refresh()
  local jumpIndex = self:GetUserData() or PageType.HeatSource
  self.toggle[jumpIndex]:SetIsOn(true)
end

return UITemperatureMainView
