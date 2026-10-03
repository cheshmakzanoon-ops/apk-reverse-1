local LLNineBoxCtrl = BaseClass("LLNineBoxCtrl", UIBaseCtrl)

function LLNineBoxCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLNineBox, {anim = false})
end

return LLNineBoxCtrl
