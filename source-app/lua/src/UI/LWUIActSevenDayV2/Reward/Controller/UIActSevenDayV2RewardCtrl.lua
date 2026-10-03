local UIActSevenDayV2RewardCtrl = BaseClass("UIActSevenDayV2RewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSevenDayV2Reward, {anim = false})
end

local function SendGetAllReward(self, acId)
  SFSNetwork.SendMessage(MsgDefines.ReceiveSevenDayV2ActAllRewardMessage, acId)
end

UIActSevenDayV2RewardCtrl.CloseSelf = CloseSelf
UIActSevenDayV2RewardCtrl.SendGetAllReward = SendGetAllReward
return UIActSevenDayV2RewardCtrl
