local UIDesertWelcomeView = BaseClass("UIDesertWelcomeView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIDesertWelcomeItem = require("UI.UIActivityCenterTable.Component.DesertBattle.Welcome.Component.UIDesertWelcomeItem")
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_bg_orange2/TitleText"
local sub_title_text_path = "PopUpTitle/Common_bg_orange2/SubTitleText"
local desc_text_path = "PopUpTitle/Common_bg_orange2/DescText"

function UIDesertWelcomeView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIDesertWelcomeView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertWelcomeView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, panel_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.sub_title_text = self:AddComponent(UIText, sub_title_text_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.title_text:SetLocalText("458007")
  self.sub_title_text:SetLocalText("458045")
  self.desc_text:SetLocalText("458046")
end

function UIDesertWelcomeView:ComponentDestroy()
  self.close_btn = nil
end

return UIDesertWelcomeView
