local UIIOSVersionUpdateTipView = BaseClass("UIIOSVersionUpdateTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIIOSVersionUpdateTipView:OnCreate()
  base.OnCreate(self)
  PostEventLog.Track(PostEventLog.Defines.IOSVersionUpdateTip)
  self:ComponentDefine()
  self:DataDefine()
end

function UIIOSVersionUpdateTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIIOSVersionUpdateTipView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.textBtnNameLeft = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.textBtnNameRight = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textBtnNameLeft:SetLocalText(GameDialogDefine.CONFIRM)
  self.textBtnNameRight:SetLocalText(GameDialogDefine.CANCEL)
  self.textTitleTxt:SetText(Localization:GetString("IOS_version_tips_01"))
  self.textDes:SetText(Localization:GetString("IOS_version_tips_02"))
end

function UIIOSVersionUpdateTipView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitleTxt = nil
  self.textDes = nil
  self.btnLeft = nil
  self.textBtnNameLeft = nil
  self.btnRight = nil
  self.textBtnNameRight = nil
end

function UIIOSVersionUpdateTipView:DataDefine()
end

function UIIOSVersionUpdateTipView:DataDestroy()
end

function UIIOSVersionUpdateTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIIOSVersionUpdateTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIIOSVersionUpdateTipView:OnBtnLeftClick()
  self.ctrl:CloseSelf()
  CS.SDKManager.OpenURL("https://support.apple.com/en-us/118575")
end

function UIIOSVersionUpdateTipView:OnBtnRightClick()
  if self:CheckBindState() then
    Logger.Log("IOSVersionUpdateTip Bind")
    self.ctrl:CloseSelf()
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWAccountBindTip, {anim = false})
  self.ctrl:CloseSelf()
end

function UIIOSVersionUpdateTipView:CheckBindState()
  if DataCenter.AccountManager.firstBindAccountRewardFlag then
    return true
  end
  if DataCenter.AccountManager.MailAccount:IsBound() then
    return true
  end
  return false
end

return UIIOSVersionUpdateTipView
