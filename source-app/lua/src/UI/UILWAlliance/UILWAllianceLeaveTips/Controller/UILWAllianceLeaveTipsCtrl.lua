local UILWAllianceLeaveTipsCtrl = BaseClass("UILWAllianceLeaveTipsCtrl", UIBaseCtrl)

function UILWAllianceLeaveTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceLeaveTips)
end

return UILWAllianceLeaveTipsCtrl
