local LWUICivilizationSparkBuffTipBannerView = BaseClass("LWUICivilizationSparkBuffTipBannerView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWUICivilizationSparkBuffTipBannerView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUICivilizationSparkBuffTipBannerView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUICivilizationSparkBuffTipBannerView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtBuffTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
end

function LWUICivilizationSparkBuffTipBannerView:ComponentDestroy()
  self.viewSkin = nil
  self.textTxtBuffTip = nil
  self.btnMask = nil
end

function LWUICivilizationSparkBuffTipBannerView:DataDefine()
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, 4)
  local id, callback = self:GetUserData()
  self.id = id
  self.callback = callback
  self:Refresh()
end

function LWUICivilizationSparkBuffTipBannerView:DataDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.callback then
    self.callback()
    self.callback = nil
  end
  self.id = nil
end

function LWUICivilizationSparkBuffTipBannerView:OnAddListener()
  base.OnAddListener(self)
end

function LWUICivilizationSparkBuffTipBannerView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUICivilizationSparkBuffTipBannerView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function LWUICivilizationSparkBuffTipBannerView:Refresh()
  if self.id then
    local template = DataCenter.LWCivilizationSparkManager:GetTemplate(self.id)
    if template then
      self.textTxtBuffTip:SetLocalText(template.buffDesc)
    end
  end
end

return LWUICivilizationSparkBuffTipBannerView
