local LWUIMigrationScoreView = BaseClass("LWUIMigrationScoreView", UIBaseView)
local base = UIBaseView
local ServerContent = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_ServerContent")
local PersonalContent = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_PersonalContent")
local DetailContent = require("UI.LWUIMigration.Score.Component.LWUIMigrationView_ScoreDetail")
local close_btn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local title_path = "Common_bg_orange/Common_img_title/titleText"
local detail_path = "Top"
local base_toggle_path = "Common_bg_orange/Common_bg_orange2/TogView/Content/Tab"
local server_content_path = "Common_bg_orange/Common_bg_orange2/TogView/Content/Tab1/Choose/Content1"
local personal_content_path = "Common_bg_orange/Common_bg_orange2/TogView/Content/Tab2/Choose/Content2"

function LWUIMigrationScoreView:OnCreate()
  base.OnCreate(self)
  self.curIdx = 0
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("migration_activity_interface_10096")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.detail = self:AddComponent(DetailContent, detail_path)
  self.server_content = self:AddComponent(ServerContent, server_content_path)
  self.personal_content = self:AddComponent(PersonalContent, personal_content_path)
  local togList = {}
  for i = 1, 2 do
    local keyStr = base_toggle_path .. i
    local toggle = self:AddComponent(UIToggle, keyStr)
    toggle:SetOnValueChanged(function(tf)
      self:SetOnValueChanged(i, tf)
    end)
    togList[i] = toggle
  end
  local bServer = self:GetUserData()
  local idx = bServer and 1 or 2
  togList[idx]:SetIsOn(true)
  self:SetOnValueChanged(idx, true)
end

function LWUIMigrationScoreView:OnDestroy()
  self.curIdx = 0
  base.OnDestroy(self)
end

function LWUIMigrationScoreView:SetOnValueChanged(idx, tf)
  if not tf or self.curIdx == idx then
    return
  end
  self.curIdx = idx
  if idx == 1 then
    self.server_content:SetData()
  elseif idx == 2 then
    self.personal_content:SetData()
  end
end

function LWUIMigrationScoreView:OnClickDetail(target, type)
  self.detail:SetData(target, type)
end

return LWUIMigrationScoreView
