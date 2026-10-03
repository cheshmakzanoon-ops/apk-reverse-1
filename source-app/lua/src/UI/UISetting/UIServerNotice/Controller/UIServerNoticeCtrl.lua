local UIServerNoticeCtrl = BaseClass("UIServerNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIServerNotice)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Info)
end

UIServerNoticeCtrl.CloseSelf = CloseSelf
UIServerNoticeCtrl.Close = Close
return UIServerNoticeCtrl
