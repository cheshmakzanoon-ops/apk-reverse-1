local UILWLightsOnDetailView = BaseClass("UILWLightsOnDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWLightsOnDetailItem = require("UI.LWSeason4.UILWLightsOnDetail.Component.UILWLightsOnDetailItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local line1_path = "ScrollView/Viewport/Content/Content/Line1"
local line2_path = "ScrollView/Viewport/Content/Content/Line2"
local line3_path = "ScrollView/Viewport/Content/Content/Line3"
local line4_path = "ScrollView/Viewport/Content/Content/Line4"
local content_path = "ScrollView/Viewport/Content"
local text_level_path = "ScrollView/Viewport/Content/Content/LineTitleIcon/TextLevel"
local text_speed_path = "ScrollView/Viewport/Content/Content/LineTitleIcon/TextSpeed"
local text_size_path = "ScrollView/Viewport/Content/Content/LineTitleIcon/TextSize"
local text_unlock_path = "ScrollView/Viewport/Content/Content/LineTitleIcon/TextUnlock"
local text_buff_path = "ScrollView/Viewport/Content/Content/LineTitleIcon/TextBuff"

function UILWLightsOnDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWLightsOnDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWLightsOnDetailView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.line1 = self:AddComponent(UILWLightsOnDetailItem, line1_path)
  self.line2 = self:AddComponent(UILWLightsOnDetailItem, line2_path)
  self.line3 = self:AddComponent(UILWLightsOnDetailItem, line3_path)
  self.line4 = self:AddComponent(UILWLightsOnDetailItem, line4_path)
  self.text_level = self:AddComponent(UIButton, text_level_path)
  self.text_speed = self:AddComponent(UIButton, text_speed_path)
  self.text_size = self:AddComponent(UIButton, text_size_path)
  self.text_unlock = self:AddComponent(UIButton, text_unlock_path)
  self.text_buff = self:AddComponent(UIButton, text_buff_path)
  self.text_level:SetOnClick(function()
    self:OnClickTitle(self.text_level, "season_s4_light_on_ui_title01")
  end)
  self.text_speed:SetOnClick(function()
    self:OnClickTitle(self.text_speed, "season_s4_light_on_ui_title02")
  end)
  self.text_size:SetOnClick(function()
    self:OnClickTitle(self.text_size, "season_s4_light_on_ui_title03")
  end)
  self.text_unlock:SetOnClick(function()
    self:OnClickTitle(self.text_unlock, "season_s4_light_on_ui_title04")
  end)
  self.text_buff:SetOnClick(function()
    self:OnClickTitle(self.text_buff, "season_s4_light_on_ui_title05")
  end)
end

function UILWLightsOnDetailView:ComponentDestroy()
  self.btn_back = nil
  self.line1 = nil
  self.line2 = nil
  self.line3 = nil
  self.line4 = nil
  self.content = nil
  self.text_level = nil
  self.text_speed = nil
  self.text_size = nil
  self.text_unlock = nil
  self.text_buff = nil
end

function UILWLightsOnDetailView:OnClickTitle(node, txt)
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = txt
  param.alignObject = node
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UILWLightsOnDetailView:UpdateData()
  self.line1:ReInit(1)
  self.line2:ReInit(2)
  self.line3:ReInit(3)
  self.line4:ReInit(4)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

return UILWLightsOnDetailView
