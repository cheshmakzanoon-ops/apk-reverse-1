local UIAlLeaderElectResultCtrl = BaseClass("UIAlLeaderElectResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlLeaderElectResult)
end

UIAlLeaderElectResultCtrl.CloseSelf = CloseSelf
return UIAlLeaderElectResultCtrl
