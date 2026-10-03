local UIALChallengeRankCtrl = BaseClass("UIALChallengeRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIALChallengeRank)
end

function UIALChallengeRankCtrl:GetRankList()
  local showList = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_CUR_DIFFICULT_RANK) or {}
  return showList
end

UIALChallengeRankCtrl.CloseSelf = CloseSelf
return UIALChallengeRankCtrl
