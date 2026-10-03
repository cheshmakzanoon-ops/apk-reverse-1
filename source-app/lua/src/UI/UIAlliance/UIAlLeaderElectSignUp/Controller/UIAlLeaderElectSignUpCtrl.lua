local UIAlLeaderElectSignUpCtrl = BaseClass("UIAlLeaderElectSignUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlLeaderElectSignUp)
end

UIAlLeaderElectSignUpCtrl.CloseSelf = CloseSelf
return UIAlLeaderElectSignUpCtrl
