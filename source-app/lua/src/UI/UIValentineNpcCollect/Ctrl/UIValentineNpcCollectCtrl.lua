local UIValentineNpcCollectCtrl = BaseClass("UIValentineNpcCollectCtrl", UIBaseCtrl)

function UIValentineNpcCollectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIValentineNpcCollect)
end

return UIValentineNpcCollectCtrl
