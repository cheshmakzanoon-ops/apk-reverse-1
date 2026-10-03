local UIGetVirusCtrl = BaseClass("UIGetVirusCtrl", UIBaseCtrl)

function UIGetVirusCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGetVirus)
end

return UIGetVirusCtrl
