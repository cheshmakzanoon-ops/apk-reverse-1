local SkyBattleWeaponUpgradeNoticeView = BaseClass("SkyBattleWeaponUpgradeNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function SkyBattleWeaponUpgradeNoticeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.delayClose = TimerManager:GetInstance():DelayInvoke(function()
    self.ctrl:CloseSelf()
    self.delayClose = nil
  end, 1)
end

function SkyBattleWeaponUpgradeNoticeView:OnDestroy()
  if self.delayClose then
    self.delayClose:Stop()
    self.delayClose = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattleWeaponUpgradeNoticeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTip:SetLocalText("plane_weapon_upgrade_01")
end

function SkyBattleWeaponUpgradeNoticeView:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textTip = nil
end

function SkyBattleWeaponUpgradeNoticeView:DataDefine()
end

function SkyBattleWeaponUpgradeNoticeView:DataDestroy()
end

function SkyBattleWeaponUpgradeNoticeView:OnAddListener()
  base.OnAddListener(self)
end

function SkyBattleWeaponUpgradeNoticeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

return SkyBattleWeaponUpgradeNoticeView
