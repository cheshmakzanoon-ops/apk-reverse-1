local UILLWorldMapTransportCtrl = BaseClass("UILLWorldMapTransportCtrl", UIBaseCtrl)

function UILLWorldMapTransportCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLWorldMapTransport)
end

return UILLWorldMapTransportCtrl
