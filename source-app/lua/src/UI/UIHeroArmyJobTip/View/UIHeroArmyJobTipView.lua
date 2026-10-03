local UIHeroArmyJobTipView = BaseClass("UIHeroArmyJobTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIHeroArmyJobTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIHeroArmyJobTipView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroArmyJobTipView:ComponentDestroy()
  self.view = nil
  self.text = nil
  self.pos = nil
  self.info = nil
end

function UIHeroArmyJobTipView:ComponentDefine()
  self.view = self:AddComponent(UIBaseContainer, "view")
  self.text = self:AddComponent(UIText, "view/infoText")
  self.closeBtn = self:AddComponent(UIButton, "")
  self.closeBtn:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroArmyJobTip)
  end)
end

function UIHeroArmyJobTipView:ReInit()
  self.pos, self.info = self:GetUserData()
  if not self.pos or not self.info then
    return
  end
  self.text:SetText(self.info)
  self.view.transform.position = self.pos
  local rootRt = self.view.rectTransform
  rootRt.position = self.pos
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(0, 0, 0)
  rootRt:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
    rootRt:DOScale(Vector3.one, 0.1)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

return UIHeroArmyJobTipView
