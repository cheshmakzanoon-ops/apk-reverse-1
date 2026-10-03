local UILWSeasonCrossServerAttackDetailCtrl = BaseClass("UILWSeasonCrossServerAttackDetailCtrl", UIBaseCtrl)

function UILWSeasonCrossServerAttackDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonCrossServerAttackDetail)
end

return UILWSeasonCrossServerAttackDetailCtrl
