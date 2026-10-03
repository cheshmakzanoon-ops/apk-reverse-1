local LWAllianceCongratulationPopCtrl = BaseClass("LWAllianceCongratulationPopCtrl", UIBaseCtrl)

function LWAllianceCongratulationPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWAllianceCongratulationPopView)
end

return LWAllianceCongratulationPopCtrl
