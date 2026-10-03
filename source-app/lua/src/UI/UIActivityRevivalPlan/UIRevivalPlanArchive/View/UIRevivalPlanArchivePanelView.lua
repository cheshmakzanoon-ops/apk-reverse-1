local UIRevivalPlanArchivePanelView = BaseClass("UIRevivalPlanArchivePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIRevivalPlanArchivePanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRevivalPlanArchivePanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanArchivePanelView:ComponentDefine()
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.textTxtTitle = self:AddComponent(UITextMeshProUGUIEx, "bg/txtTitle")
  self.textDateTitle = self:AddComponent(UITextMeshProUGUIEx, "bg/dateTitle")
  self.textContent = self:AddComponent(UITextMeshProUGUIEx, "bg/content")
  self.btnConfirm = self:AddComponent(UIButton, "bg/confirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirmBtnTitle = self:AddComponent(UITextMeshProUGUIEx, "bg/confirmBtn/confirmBtnTitle")
end

function UIRevivalPlanArchivePanelView:ComponentDestroy()
  self.btnBlack = nil
  self.textTxtTitle = nil
  self.textDateTitle = nil
  self.textContent = nil
  self.btnConfirm = nil
  self.textConfirmBtnTitle = nil
end

function UIRevivalPlanArchivePanelView:DataDefine()
end

function UIRevivalPlanArchivePanelView:DataDestroy()
end

function UIRevivalPlanArchivePanelView:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlanArchivePanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlanArchivePanelView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function UIRevivalPlanArchivePanelView:OnBtnConfirmClick()
  self.ctrl:CloseSelf()
end

return UIRevivalPlanArchivePanelView
