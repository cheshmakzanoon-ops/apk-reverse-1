local UILWRewardPreviewCtrl = BaseClass("UILWRewardPreviewCtrl", UIBaseCtrl)

function UILWRewardPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWRewardPreviewView)
end

return UILWRewardPreviewCtrl
