local UIGuideTalkCtrl = BaseClass("UIGuideTalkCtrl", UIBaseCtrl)

function UIGuideTalkCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideTalk, {
    anim = true,
    UIMainAnim = UIMainAnimType.ChangeAllShow,
    playEffect = false
  })
end

return UIGuideTalkCtrl
