local UILWTrainPrepareReplacePanelCtrl = BaseClass("UILWTrainPrepareReplacePanelCtrl", UIBaseCtrl)

function UILWTrainPrepareReplacePanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainPrepareReplace)
end

return UILWTrainPrepareReplacePanelCtrl
