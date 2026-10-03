local UIWorldCollectMessageTipCtrl = BaseClass("UIWorldCollectMessageTipCtrl", UIBaseCtrl)

function UIWorldCollectMessageTipCtrl:CloseSelf(isNoDoAnim)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldCollectMessageTip, {anim = true})
end

function UIWorldCollectMessageTipCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UIWorldCollectMessageTipCtrl
