local UIWorkerRecruitRewardCtrl = BaseClass("UIWorkerRecruitRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerRecruitReward)
end

UIWorkerRecruitRewardCtrl.CloseSelf = CloseSelf
return UIWorkerRecruitRewardCtrl
