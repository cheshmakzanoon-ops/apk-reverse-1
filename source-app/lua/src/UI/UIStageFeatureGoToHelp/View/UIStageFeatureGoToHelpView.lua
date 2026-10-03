local UIStageFeatureGoToHelpView = BaseClass("UIStageFeatureGoToHelpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIStageFeatureGoToHelpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIStageFeatureGoToHelpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStageFeatureGoToHelpView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function UIStageFeatureGoToHelpView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnGo = nil
  self.textTitle = nil
  self.textDesc = nil
end

function UIStageFeatureGoToHelpView:DataDefine()
  self.param = self:GetUserData()
end

function UIStageFeatureGoToHelpView:DataDestroy()
end

function UIStageFeatureGoToHelpView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  self.param = self:GetUserData()
  self:RefreshUI()
end

function UIStageFeatureGoToHelpView:OnAddListener()
  base.OnAddListener(self)
end

function UIStageFeatureGoToHelpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIStageFeatureGoToHelpView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIStageFeatureGoToHelpView:OnBtnGoClick()
  self.ctrl:CloseSelf()
  local uuid = self.param.uuid
  local stageId = self.param.stageId
  DataCenter.LWStageFeatureChapterManager:GoToHelp(uuid, stageId)
end

function UIStageFeatureGoToHelpView:RefreshUI()
  local name = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(self.param.stageId)
  local content = Localization:GetString("frontline_help_immediately_02", name)
  self.textTitle:SetText(name)
  self.textDesc:SetText(content)
end

return UIStageFeatureGoToHelpView
