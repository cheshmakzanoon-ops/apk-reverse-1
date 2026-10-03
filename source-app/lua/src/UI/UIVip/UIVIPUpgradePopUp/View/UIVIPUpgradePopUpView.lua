local UIVIPUpgradePopUpView = BaseClass("UIVIPUpgradePopUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIVIPUpgradePopUpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIVIPUpgradePopUpView:ComponentDefine()
  self._close_btn = self:AddComponent(UIButton, "Panel")
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelfOpenVip()
  end)
  self._vip_txt = self:AddComponent(UIText, "Panel/Txt_Vip")
  self._vipDes_txt = self:AddComponent(UIText, "Panel/Txt_VipDes")
  self._btnGo_btn = self:AddComponent(UIButton, "Panel/getAllBtn")
  self._btnGo_btn:SetOnClick(function()
    self.ctrl:CloseSelfOpenVip()
  end)
  self._btnGo_txt = self:AddComponent(UIText, "Panel/getAllBtn/Txt_BtnGo")
end

function UIVIPUpgradePopUpView:DataDefine()
  self.vipInfo = {}
end

function UIVIPUpgradePopUpView:OnDestroy()
  self._close_btn = nil
  self._vip_txt = nil
  self._vipDes_txt = nil
  self._btnGo_txt = nil
  self._btnGo_txt = nil
  self.vipInfo = nil
  base.OnDestroy(self)
end

function UIVIPUpgradePopUpView:OnEnable()
  base.OnEnable(self)
end

function UIVIPUpgradePopUpView:OnDisable()
  base.OnDisable(self)
end

function UIVIPUpgradePopUpView:ReInit()
  self.vipInfo = DataCenter.VIPManager:GetVipData()
  self._btnGo_txt:SetLocalText(GameDialogDefine.GOTO)
  self._vipDes_txt:SetLocalText(320235)
  self._vip_txt:SetText(string.format("VIP %d", self.vipInfo.level))
end

return UIVIPUpgradePopUpView
