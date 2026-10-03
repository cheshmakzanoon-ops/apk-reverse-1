local UIVIPRewardPopUpView = BaseClass("UIVIPRewardPopUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIVIPRewardPopUpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIVIPRewardPopUpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVIPRewardPopUpView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self._loginDay_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self._title_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self._tomorrowPoint_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self._todayPoint_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self._todayPointDes_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self._loginDayDes_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self._tomorrowPointDes_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self._des_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
end

function UIVIPRewardPopUpView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self._loginDay_txt = nil
  self._title_txt = nil
  self._tomorrowPoint_txt = nil
  self._todayPoint_txt = nil
  self._todayPointDes_txt = nil
  self._loginDayDes_txt = nil
  self._tomorrowPointDes_txt = nil
  self._des_txt = nil
end

function UIVIPRewardPopUpView:DataDefine()
  local vipInfo = DataCenter.VIPManager:GetVipData()
  self._title_txt:SetLocalText(128027)
  self._todayPointDes_txt:SetLocalText(320223)
  self._todayPoint_txt:SetText(vipInfo.addScore)
  self._loginDayDes_txt:SetLocalText(320224)
  self._loginDay_txt:SetText(vipInfo.loginDays)
  self._tomorrowPointDes_txt:SetLocalText(320233)
  self._tomorrowPoint_txt:SetText(vipInfo.nextDayScore)
  self._des_txt:SetLocalText(320234)
end

function UIVIPRewardPopUpView:DataDestroy()
end

function UIVIPRewardPopUpView:OnAddListener()
  base.OnAddListener(self)
end

function UIVIPRewardPopUpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIVIPRewardPopUpView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIVIPRewardPopUpView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIVIPRewardPopUpView
