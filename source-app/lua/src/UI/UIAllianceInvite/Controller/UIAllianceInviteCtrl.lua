local UIAllianceInviteCtrl = BaseClass("UIAllianceInviteCtrl", UIBaseCtrl)

local function CloseSelf(self)
  DataCenter.CityRebuildDataManager:ReleaseAllianceInfoInfo()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceInvite)
end

UIAllianceInviteCtrl.CloseSelf = CloseSelf
return UIAllianceInviteCtrl
