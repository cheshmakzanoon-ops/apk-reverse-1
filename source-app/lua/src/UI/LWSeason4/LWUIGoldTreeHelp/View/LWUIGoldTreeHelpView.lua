local LWUIGoldTreeHelpView = BaseClass("LWUIGoldTreeHelpView", UIBaseView)
local base = UIBaseView
local LWUIGoldTreeHelpAuto = require("UI.LWSeason4.LWUIGoldTreeHelp.Auto.LWUIGoldTreeHelpAuto")

function LWUIGoldTreeHelpView:OnCreate()
  base.OnCreate(self)
  self.binder = LWUIGoldTreeHelpAuto.New()
  self.binder:bind(self)
  self.btn_lwuigoldtreehelp:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self:InitUI()
end

function LWUIGoldTreeHelpView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  base.OnDestroy(self)
end

function LWUIGoldTreeHelpView:InitUI()
  self.pos, self.info = self:GetUserData()
  if not self.pos or not self.info then
    return
  end
  self.txt_infotext:SetLocalText(self.info)
  self.root.transform.position = self.pos
  local rootRt = self.root.rectTransform
  rootRt.position = self.pos
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(0, 0, 0)
  rootRt:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
    rootRt:DOScale(Vector3.one, 0.1)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

return LWUIGoldTreeHelpView
