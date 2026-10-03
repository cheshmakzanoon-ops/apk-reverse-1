local base = UIBaseContainer
local UIAccountIdBindCardActiveComponent = BaseClass("UIAccountIdBindCardActiveComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAccountIdBindCardActiveComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountIdBindCardActiveComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountIdBindCardActiveComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnActive = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnActive:SetOnClick(function()
    self:OnBtnActiveClick()
  end)
  self.textActiveBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPoint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textPointNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textCardId = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
end

function UIAccountIdBindCardActiveComponent:ComponentDestroy()
  self.textTitle = nil
  self.btnActive = nil
  self.textActiveBtn = nil
  self.textPoint = nil
  self.textPointNum = nil
  self.textCardId = nil
end

function UIAccountIdBindCardActiveComponent:DataDefine()
end

function UIAccountIdBindCardActiveComponent:DataDestroy()
end

function UIAccountIdBindCardActiveComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountIdBindCardActiveComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountIdBindCardActiveComponent:OnBtnActiveClick()
  if self.curState then
    self.curState:OnClickRight()
  end
  DataCenter.AccountScoreManager:GoToLogInAccountScoreWeb(AccountScoreLogInWebType.AfterBind)
end

function UIAccountIdBindCardActiveComponent:Init(state)
  self.curState = state
  self:SetLocalizeText()
end

function UIAccountIdBindCardActiveComponent:SetLocalizeText()
  if self.curState then
    local stateLocalization = self.curState.GetStateLocalization and self.curState:GetStateLocalization() or {}
    self.textTitle:SetLocalText(stateLocalization.titleStr)
    self.textCardId:SetActive(false)
    self.textActiveBtn:SetLocalText(stateLocalization.activeBtnStr)
    self.textPointNum:SetText(1000)
  end
end

return UIAccountIdBindCardActiveComponent
