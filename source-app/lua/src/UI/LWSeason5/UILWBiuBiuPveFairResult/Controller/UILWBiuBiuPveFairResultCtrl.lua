local UILWBiuBiuPveFairResultCtrl = BaseClass("UILWBiuBiuPveFairResultCtrl", UIBaseCtrl)

function UILWBiuBiuPveFairResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuPveFairResult)
end

return UILWBiuBiuPveFairResultCtrl
