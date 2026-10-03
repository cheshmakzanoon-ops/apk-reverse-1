local UIGuideCommunicationTalkCtrl = BaseClass("UIGuideCommunicationTalkCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideCommunicationTalk, {
    anim = true,
    UIMainAnim = UIMainAnimType.ChangeAllShow,
    playEffect = false
  })
end

UIGuideCommunicationTalkCtrl.CloseSelf = CloseSelf
return UIGuideCommunicationTalkCtrl
