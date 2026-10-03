local UIRevivalPlanArchivePanelCtrl = BaseClass("UIRevivalPlanArchivePanelCtrl", UIBaseCtrl)

function UIRevivalPlanArchivePanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRevivalPlanArchive)
end

return UIRevivalPlanArchivePanelCtrl
