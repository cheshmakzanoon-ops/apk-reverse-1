local UITacticalAttributeInfoView = BaseClass("UITacticalAttributeInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local TacticalAttributeCalculateDisplayPanel = require("UI.UILWTacticalWeapon.UITacticalAttributeInfo.Component.TacticalAttributeCalculateDisplayPanel")
local TacticalPropertyGroupPanel = require("UI.UILWTacticalWeapon.UITacticalAttributeInfo.Component.TacticalPropertyGroupPanel")
local att_calculate_panel_path = "PopUpTitle/attCalculatePanel"
local att_display_panel_path = "PopUpTitle/attDisplayPanel"
local AttributeType = {CalculateTab = 1, ShowTab = 2}

function UITacticalAttributeInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UITacticalAttributeInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalAttributeInfoView:ComponentDefine()
  self.attCalculateTab = self:AddComponent(UICommonTab, "PopUpTitle/attCalculateTab")
  self.attShowTab = self:AddComponent(UICommonTab, "PopUpTitle/attShowTab")
  self.attCalculateDisplayPanel = self:AddComponent(TacticalAttributeCalculateDisplayPanel, att_calculate_panel_path)
  self.attPropertyGroupPanel = self:AddComponent(TacticalPropertyGroupPanel, att_display_panel_path)
  self.mainTitle = self:AddComponent(UIText, "PopUpTitle/Common_img_title/titleText")
  self.mainTitle:SetText(Localization:GetString("new_uav_level_title2"))
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

function UITacticalAttributeInfoView:ComponentDestroy()
  self.curTab = nil
  self.attCalculateTab = nil
  self.attShowTab = nil
  self.mainTitle = nil
  self.btnClose = nil
  self.btnPanel = nil
end

function UITacticalAttributeInfoView:DataDefine()
  self.tabMap = {}
  self.tabMap[AttributeType.CalculateTab] = self.attCalculateTab
  self.tabMap[AttributeType.ShowTab] = self.attShowTab
end

function UITacticalAttributeInfoView:DataDestroy()
  self.tabMap = nil
end

function UITacticalAttributeInfoView:OnAddListener()
  base.OnAddListener(self)
end

function UITacticalAttributeInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITacticalAttributeInfoView:OnReInit()
  local defaultTabTagId = self:GetUserData()
  local attCalculateParam = {}
  attCalculateParam.tabId = AttributeType.CalculateTab
  attCalculateParam.title = Localization:GetString("new_uav_level_title3")
  attCalculateParam.clickHandler = self.OnTabClick
  attCalculateParam.containPanel = self.attCalculateDisplayPanel
  self.attCalculateTab:ReInit(attCalculateParam)
  self.attCalculateTab:SetSelect(false)
  local attShowTabParam = {}
  attShowTabParam.tabId = AttributeType.ShowTab
  attShowTabParam.title = Localization:GetString("new_uav_level_title4")
  attShowTabParam.clickHandler = self.OnTabClick
  attShowTabParam.containPanel = self.attPropertyGroupPanel
  self.attShowTab:ReInit(attShowTabParam)
  self.attShowTab:SetSelect(false)
  if defaultTabTagId == nil then
    defaultTabTagId = AttributeType.CalculateTab
  end
  self:OnTabClick(self.tabMap[defaultTabTagId])
end

function UITacticalAttributeInfoView:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self.curTab.containPanel:ReInit()
end

function UITacticalAttributeInfoView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UITacticalAttributeInfoView
