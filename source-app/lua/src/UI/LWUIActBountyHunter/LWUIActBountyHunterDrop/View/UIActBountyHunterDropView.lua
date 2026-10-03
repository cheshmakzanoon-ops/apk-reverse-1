local UIActBountyHunterDropView = BaseClass("UIActBountyHunterDropView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIActBountyHunterRulesDropPanelComponent = require("UI.LWUIActBountyHunter.LWUIActBountyHunterRules.Component.LWUIActBountyHunterRulesDropPanelComponent")

function UIActBountyHunterDropView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:OnOpen()
end

function UIActBountyHunterDropView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActBountyHunterDropView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compLWUIActBountyHunterRulesDropPanel = self.viewSkin:AddComponent(self, LWUIActBountyHunterRulesDropPanelComponent, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle:SetLocalText("activity_hunter_info_tab2")
end

function UIActBountyHunterDropView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.compLWUIActBountyHunterRulesDropPanel = nil
  self.btnClose = nil
end

function UIActBountyHunterDropView:DataDefine()
end

function UIActBountyHunterDropView:DataDestroy()
end

function UIActBountyHunterDropView:OnOpen()
  if self.activityId == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.compLWUIActBountyHunterRulesDropPanel:ReInit(self.activityId)
end

function UIActBountyHunterDropView:OnAddListener()
  base.OnAddListener(self)
end

function UIActBountyHunterDropView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActBountyHunterDropView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UIActBountyHunterDropView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIActBountyHunterDropView
