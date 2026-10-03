local UILWSeasonServerDetailCtrl = BaseClass("UILWSeasonServerDetailCtrl", UIBaseCtrl)

function UILWSeasonServerDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonServerDetail)
end

return UILWSeasonServerDetailCtrl
