local LWUIMigrationGuideView = BaseClass("LWUIMigrationGuideView", UIBaseView)
local base = UIBaseView
local GuideTime = require("UI.LWUIMigration.Guide.Component.LWUIMigrationView_GuideTime")
local GuideProcess = require("UI.LWUIMigration.Guide.Component.LWUIMigrationView_GuideProcess")
local close_btn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local title_path = "Common_bg_orange/Common_img_title/titleText"
local base_toggle_path = "Common_bg_orange/Common_bg_orange2/TogView/Content/Tab"
local time_content_path = "Common_bg_orange/Common_bg_orange2/TogView/Content/Tab1/Choose/Layout"
local process_content_path = "Common_bg_orange/Common_bg_orange2/TogView/Content/Tab2/Choose/ScrollView"

function LWUIMigrationGuideView:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("migration_activity_tips_20025")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.toggles = {}
  for i = 1, 2 do
    local keyStr = base_toggle_path .. i
    local toggle = self:AddComponent(UIToggle, keyStr)
    toggle:SetOnValueChanged(function(tf)
      self:SetOnValueChanged(i, tf)
    end)
    self.toggles[i] = toggle
  end
  self.time_content = self:AddComponent(GuideTime, time_content_path)
  self.process_content = self:AddComponent(GuideProcess, process_content_path)
end

function LWUIMigrationGuideView:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationGuideView:OnEnable()
  base.OnEnable(self)
  self.toggles[1]:SetIsOn(true)
  self:SetOnValueChanged(1, true)
end

function LWUIMigrationGuideView:SetOnValueChanged(idx, tf)
  if not tf then
    return
  end
  if idx == 1 then
    self.time_content:SetData()
  elseif idx == 2 then
    self.process_content:SetData()
  end
end

return LWUIMigrationGuideView
