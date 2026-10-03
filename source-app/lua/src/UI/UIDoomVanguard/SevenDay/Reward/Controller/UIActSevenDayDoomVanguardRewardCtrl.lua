local UIActSevenDayDoomVanguardRewardCtrl = BaseClass("UIActSevenDayDoomVanguardRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSevenDayDoomVanguardReward, {anim = false})
end

local function SendGetAllReward(self, acId)
  SFSNetwork.SendMessage(MsgDefines.ReceiveSevenDayActAllRewardMessage, acId)
end

UIActSevenDayDoomVanguardRewardCtrl.CloseSelf = CloseSelf
UIActSevenDayDoomVanguardRewardCtrl.SendGetAllReward = SendGetAllReward
return UIActSevenDayDoomVanguardRewardCtrl
