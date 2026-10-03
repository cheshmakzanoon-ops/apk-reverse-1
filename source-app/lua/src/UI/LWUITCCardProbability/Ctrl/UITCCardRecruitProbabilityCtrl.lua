local UITCCardRecruitProbabilityCtrl = BaseClass("UITCCardRecruitProbabilityCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TCCardRecruitProbability)
end

UITCCardRecruitProbabilityCtrl.CloseSelf = CloseSelf
return UITCCardRecruitProbabilityCtrl
