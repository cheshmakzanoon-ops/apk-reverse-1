local UISurfingInteractionCtrl = BaseClass("UISurfingInteractionCtrl", UIBaseCtrl)

function UISurfingInteractionCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISurfingInteraction, {anim = false})
end

return UISurfingInteractionCtrl
