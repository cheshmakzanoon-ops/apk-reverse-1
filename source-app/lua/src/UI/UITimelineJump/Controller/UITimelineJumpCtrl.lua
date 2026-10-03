local UITimelineJumpCtrl = BaseClass("UITimelineJumpCtrl", UIBaseCtrl)

function UITimelineJumpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoInput, {anim = false, playEffect = false})
end

return UITimelineJumpCtrl
