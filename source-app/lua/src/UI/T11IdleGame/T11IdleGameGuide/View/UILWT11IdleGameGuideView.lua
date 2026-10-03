local UILWT11IdleGameGuideView = BaseClass("UILWT11IdleGameGuideView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWT11IdleGameGuideView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameGuideView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameGuideView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textLeft = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRight = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnLWConfirm = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnLWConfirm:SetOnClick(function()
    self:OnBtnLWConfirmClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnLWClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.textTitle:SetLocalText("t11_idle_game_title_75")
  self.textLeft:SetLocalText("trialtower_name")
  self.textRight:SetLocalText("t11_idle_game_name_1")
  self.textBtn:SetLocalText("110006")
end

function UILWT11IdleGameGuideView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.textLeft = nil
  self.textRight = nil
  self.btnLWConfirm = nil
  self.textBtn = nil
  self.btnLWClose = nil
end

function UILWT11IdleGameGuideView:DataDefine()
end

function UILWT11IdleGameGuideView:DataDestroy()
end

function UILWT11IdleGameGuideView:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameGuideView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameGuideView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWT11IdleGameGuideView:OnBtnLWConfirmClick()
  self.ctrl:CloseSelf()
end

function UILWT11IdleGameGuideView:OnBtnLWCloseClick()
  self.ctrl:CloseSelf()
end

return UILWT11IdleGameGuideView
