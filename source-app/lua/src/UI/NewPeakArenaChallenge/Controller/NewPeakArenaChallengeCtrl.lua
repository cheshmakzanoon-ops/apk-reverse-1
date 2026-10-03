local NewPeakArenaChallengeCtrl = BaseClass("NewPeakArenaChallengeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.NewPeakArenaChallenge)
end

NewPeakArenaChallengeCtrl.CloseSelf = CloseSelf
return NewPeakArenaChallengeCtrl
