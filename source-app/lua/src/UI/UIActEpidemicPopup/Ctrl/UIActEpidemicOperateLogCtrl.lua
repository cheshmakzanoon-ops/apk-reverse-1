local UIActEpidemicOperateLogCtrl = BaseClass("UIActEpidemicOperateLogCtrl", UIBaseCtrl)

function UIActEpidemicOperateLogCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicOperateLogView, {anim = true})
end

return UIActEpidemicOperateLogCtrl
