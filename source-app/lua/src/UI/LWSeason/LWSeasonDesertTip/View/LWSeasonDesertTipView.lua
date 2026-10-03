local LWSeasonDesertTipView = BaseClass("LWSeasonDesertTipView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local btn_ok_path = "PopUpTitle/Common_bg_orange2/BtnOK"
local back_toggle_path = "PopUpTitle/Common_bg_orange2/backToggle"
local close_btn_path = "PopUpTitle/CloseBtn"

function LWSeasonDesertTipView:OnCreate()
  base.OnCreate(self)
  self.callback = self:GetUserData()
  self:ComponentDefine()
end

function LWSeasonDesertTipView:OnDestroy()
  if self.callback and type(self.callback) == "function" then
    pcall(self.callback)
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonDesertTipView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnOk = self:AddComponent(UIButton, btn_ok_path)
  self.btnToggle = self:AddComponent(UIToggle, back_toggle_path)
  self.btnOk:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnToggle:SetIsOn(false)
  self.btnToggle:SetOnValueChanged(function(tf)
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.UserDesertLinkTip, not tf)
  end)
end

function LWSeasonDesertTipView:ComponentDestroy()
end

return LWSeasonDesertTipView
