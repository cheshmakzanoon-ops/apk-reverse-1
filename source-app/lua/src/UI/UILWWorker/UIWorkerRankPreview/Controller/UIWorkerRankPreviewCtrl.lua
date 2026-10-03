local UIWorkerRankPreviewCtrl = BaseClass("UIWorkerRankPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerRankPreview)
end

UIWorkerRankPreviewCtrl.CloseSelf = CloseSelf
return UIWorkerRankPreviewCtrl
