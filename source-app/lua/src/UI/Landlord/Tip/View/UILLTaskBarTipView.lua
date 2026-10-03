local UILLTaskBarTipView = BaseClass("UILLTaskBarTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILLTaskBarTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLTaskBarTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLTaskBarTipView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.compBtn = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.btnS = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnS:SetOnClick(function()
    self:OnBtnSClick()
  end)
  self.compArrowDown = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compArrowUp = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compTips = self.viewSkin:AddComponent(self, UIHorizontalOrVerticalLayoutGroup, 6)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
end

function UILLTaskBarTipView:ComponentDestroy()
  self.viewSkin = nil
  self.panel = nil
  self.compBtn = nil
  self.btnS = nil
  self.compArrowDown = nil
  self.compArrowUp = nil
  self.compTips = nil
  self.text = nil
end

function UILLTaskBarTipView:DataDefine()
  local target, showBtn
  target, showBtn = self:GetUserData()
  self.compBtn:SetActive(showBtn)
  self.compTips:SetPaddingBottom(showBtn and 90 or 10)
  self.text:SetLocalText("zonewar_landlord_desc_1052")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.text.rectTransform)
  local worldPos = target:GetPosition()
  local bUp = worldPos.y > 500
  self.compArrowUp:SetActive(bUp)
  self.compArrowDown:SetActive(not bUp)
  self.compTips:SetActive(false)
  self.delay = TimerManager:GetInstance():DelayFrameInvoke(function()
    self.compTips:SetActive(true)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compTips.rectTransform)
    local targetP = self.transform:InverseTransformPoint(worldPos)
    local x = targetP.x
    local y = targetP.y
    local z = targetP.z
    local _, h = self.compTips:GetSizeDeltaXY()
    local th = target.rectTransform.rect.height
    y = y + (bUp and -1 or 1) * (h + th + 20) * 0.5
    self.compTips:SetLocalPositionXYZ(x, y, z)
  end, 3)
end

function UILLTaskBarTipView:DataDestroy()
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
end

function UILLTaskBarTipView:OnAddListener()
  base.OnAddListener(self)
end

function UILLTaskBarTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILLTaskBarTipView:OnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLTaskBarTipView:OnBtnSClick()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward, {anim = true}, {
    tab = LLConst.RewardTabType.Week
  })
end

return UILLTaskBarTipView
