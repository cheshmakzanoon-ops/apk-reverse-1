local base = UIBaseContainer
local UILuckyBuffFromTipsComponent = BaseClass("UILuckyBuffFromTipsComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function UILuckyBuffFromTipsComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILuckyBuffFromTipsComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILuckyBuffFromTipsComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.compTipsContent = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 4)
  self.textPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function UILuckyBuffFromTipsComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.compTipsContent = nil
  self.textTip = nil
  self.compUIPlayerHead = nil
  self.textPlayerName = nil
end

function UILuckyBuffFromTipsComponent:OnBtnMaskClick()
  self:SetActive(false)
end

function UILuckyBuffFromTipsComponent:SetDataAndPosition(playerInfo, clickPos)
  if not playerInfo or not clickPos then
    return
  end
  self.textTip:SetLocalText("luckyBuff_limit_buffFrom")
  self.compUIPlayerHead:SetHeadAndFrame(playerInfo.uid, playerInfo.pic, playerInfo.picVer, false, playerInfo.headSkinId, playerInfo.headSkinET)
  self.textPlayerName:SetText(playerInfo.name)
  local xPosFix = 20
  self.compTipsContent:SetPositionXYZ(clickPos.x + xPosFix, clickPos.y, 0)
end

return UILuckyBuffFromTipsComponent
