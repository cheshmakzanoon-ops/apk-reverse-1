local UIAlLeaderCandidatesCtrl = BaseClass("UIAlLeaderCandidatesCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlLeaderCandidates)
end

UIAlLeaderCandidatesCtrl.CloseSelf = CloseSelf
return UIAlLeaderCandidatesCtrl
