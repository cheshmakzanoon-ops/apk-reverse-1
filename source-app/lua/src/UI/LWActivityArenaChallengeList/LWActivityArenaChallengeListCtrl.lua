local LWActivityArenaChallengeListCtrl = BaseClass("LWActivityArenaChallengeList", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaChallengeList)
end

LWActivityArenaChallengeListCtrl.CloseSelf = CloseSelf
return LWActivityArenaChallengeListCtrl
