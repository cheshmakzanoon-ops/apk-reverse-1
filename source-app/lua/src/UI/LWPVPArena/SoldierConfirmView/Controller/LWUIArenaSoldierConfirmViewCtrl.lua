local LWUIArenaSoldierConfirmViewCtrl = BaseClass("LWUIArenaSoldierConfirmViewCtrl", UIBaseCtrl)

function LWUIArenaSoldierConfirmViewCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWPVPArenaSoldierConfirm, {anim = useAnimation})
end

function LWUIArenaSoldierConfirmViewCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return LWUIArenaSoldierConfirmViewCtrl
