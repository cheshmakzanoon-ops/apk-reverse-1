local UILWGGGoPveFairResultCtrl = BaseClass("UILWGGGoPveFairResultCtrl", UIBaseCtrl)

function UILWGGGoPveFairResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoPveFairResult)
end

return UILWGGGoPveFairResultCtrl
