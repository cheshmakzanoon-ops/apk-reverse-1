local UILWTrainDepartureScienceTipsCtrl = BaseClass("UILWTrainDepartureScienceTipsCtrl", UIBaseCtrl)

function UILWTrainDepartureScienceTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainDepartureScienceTips)
end

return UILWTrainDepartureScienceTipsCtrl
