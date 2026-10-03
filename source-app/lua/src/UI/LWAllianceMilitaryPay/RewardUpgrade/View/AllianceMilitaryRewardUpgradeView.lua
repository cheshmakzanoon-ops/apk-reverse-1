local AllianceMilitaryRewardUpgradeView = BaseClass("AllianceMilitaryRewardUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function AllianceMilitaryRewardUpgradeView:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
  self:AddTimer()
  DataCenter.LWSoundManager:PlaySound(90122)
end

function AllianceMilitaryRewardUpgradeView:OnDestroy()
  self:RemoveTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceMilitaryRewardUpgradeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTxtLvBefore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTxtLvNow = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgBox = self.viewSkin:AddComponent(self, UIRawImage, 5)
end

function AllianceMilitaryRewardUpgradeView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBg = nil
  self.textTxtTitle = nil
  self.textTxtLvBefore = nil
  self.textTxtLvNow = nil
  self.imgBox = nil
end

function AllianceMilitaryRewardUpgradeView:DataDefine()
  self.canClose = false
end

function AllianceMilitaryRewardUpgradeView:DataDestroy()
  self.canClose = nil
end

function AllianceMilitaryRewardUpgradeView:OnAddListener()
  base.OnAddListener(self)
end

function AllianceMilitaryRewardUpgradeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceMilitaryRewardUpgradeView:OnBtnBgClick()
  if not self.canClose then
    return
  end
  self.ctrl:CloseSelf()
end

function AllianceMilitaryRewardUpgradeView:InitView()
  self.textTxtTitle:SetLocalText("alliance_pay_title_upgrade")
  self.textTxtLvBefore:SetText(string.format("Lv.%d", self.data.lastLevel))
  self.textTxtLvNow:SetText(string.format("Lv.%d", self.data.curLevel))
end

function AllianceMilitaryRewardUpgradeView:AddTimer()
  self:RemoveTimer()
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.canClose = true
  end, 1.7)
end

function AllianceMilitaryRewardUpgradeView:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return AllianceMilitaryRewardUpgradeView
