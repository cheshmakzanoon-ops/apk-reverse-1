local UIBFDsbDuelActScoreTipsView = BaseClass("UIBFDsbDuelActScoreTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActScoreTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIBFDsbDuelActScoreTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActScoreTipsView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTxtName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnJump = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnJump:SetOnClick(function()
    self:OnBtnJumpClick()
  end)
  self.textGo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textGo:SetLocalText("develop_guide_tip1")
end

function UIBFDsbDuelActScoreTipsView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTxtName = nil
  self.btnJump = nil
  self.textGo = nil
  self.compRoot = nil
end

function UIBFDsbDuelActScoreTipsView:DataDefine()
  self._param = self:GetUserData()
end

function UIBFDsbDuelActScoreTipsView:DataDestroy()
  self._param = nil
end

function UIBFDsbDuelActScoreTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActScoreTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActScoreTipsView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActScoreTipsView:OnBtnJumpClick()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActRules, {anim = true}, BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.GroupRules, 3)
end

function UIBFDsbDuelActScoreTipsView:ReInit()
  local alignObject = self._param.alignObject
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local _screenPos = PosConverse.UIWorldToScreenPos(alignObject.transform.position)
  local targetScreenPos = Vector3.New(_screenPos.x + ((self._param.offsetX or 0) - 145) * scaleFactor * CommonUtil.ArabicAutoMirrorFactor(), _screenPos.y + (self._param.offsetY or 0) * scaleFactor, _screenPos.z)
  local targetPos = PosConverse.ScreenToUIWorldPos(targetScreenPos, self.compRoot.rectTransform)
  self.compRoot.transform.position = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
  self.textTxtName:SetLocalText(self._param.title or "")
end

return UIBFDsbDuelActScoreTipsView
