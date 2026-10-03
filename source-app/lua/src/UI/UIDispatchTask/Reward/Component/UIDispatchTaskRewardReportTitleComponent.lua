local UIDispatchTaskRewardReportTitleComponent = BaseClass("local UIDispatchTaskRewardReportTitleComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIDispatchTaskRewardReportTitleComponent:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "")
  self.title:SetText(Localization:GetString("dispatch_des025"))
end

function UIDispatchTaskRewardReportTitleComponent:OnDestroy()
  self.title = nil
  base.OnDestroy(self)
end

return UIDispatchTaskRewardReportTitleComponent
