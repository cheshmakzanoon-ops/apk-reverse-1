local UILWSeasonOutpostColorDetailView = BaseClass("UILWSeasonOutpostColorDetailView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"

function UILWSeasonOutpostColorDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWSeasonOutpostColorDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostColorDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s6_outpost_title_5")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UILWSeasonOutpostColorDetailView:ComponentDestroy()
  self.btn_back = nil
end

return UILWSeasonOutpostColorDetailView
