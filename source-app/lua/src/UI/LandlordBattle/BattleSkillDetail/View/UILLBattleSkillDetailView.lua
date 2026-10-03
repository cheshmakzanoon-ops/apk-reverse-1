local UILLBattleSkillDetailView = BaseClass("UILLBattleSkillDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LLBattleSkillCur = require("UI.LandlordBattle.BattleSkillDetail.Component.LLBattleSkillCur")

function UILLBattleSkillDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UILLBattleSkillDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLBattleSkillDetailView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compLLBattleSkillCur = self.viewSkin:AddComponent(self, LLBattleSkillCur, 4)
  self.textTitle:SetLocalText("458536")
end

function UILLBattleSkillDetailView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compLLBattleSkillCur = nil
end

function UILLBattleSkillDetailView:DataDefine()
  self.curSkillId = self:GetUserData()
end

function UILLBattleSkillDetailView:DataDestroy()
end

function UILLBattleSkillDetailView:OnAddListener()
  base.OnAddListener(self)
end

function UILLBattleSkillDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILLBattleSkillDetailView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLBattleSkillDetailView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILLBattleSkillDetailView:RefreshView()
  self.compLLBattleSkillCur:ReInit(self.curSkillId)
end

return UILLBattleSkillDetailView
