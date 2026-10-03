local PowerWorkerCreatedTipsCtrl = BaseClass("PowerWorkerCreatedTipsCtrl", UIBaseCtrl)

function PowerWorkerCreatedTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPowerWorkerCreatedTips)
  UIUtil.CheckEventTrigger(OpMode.ClickBtnGotPowerWorker)
end

return PowerWorkerCreatedTipsCtrl
