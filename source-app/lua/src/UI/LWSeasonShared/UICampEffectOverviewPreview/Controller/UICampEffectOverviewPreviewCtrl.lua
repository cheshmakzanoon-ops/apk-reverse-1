local UICampEffectOverviewPreviewCtrl = BaseClass("UICampEffectOverviewPreviewCtrl", UIBaseCtrl)

function UICampEffectOverviewPreviewCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICampEffectOverviewPreview, {anim = useAnimation})
end

return UICampEffectOverviewPreviewCtrl
