local UICampEffectOverviewCtrl = BaseClass("UICampEffectOverviewCtrl", UIBaseCtrl)

function UICampEffectOverviewCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICampEffectOverview, {anim = useAnimation})
end

return UICampEffectOverviewCtrl
