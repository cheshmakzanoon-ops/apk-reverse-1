local UIDesertOperateLogCtrl = BaseClass("UIDesertOperateLogCtrl", UIBaseCtrl)

function UIDesertOperateLogCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertOperateLog, {anim = true})
end

return UIDesertOperateLogCtrl
