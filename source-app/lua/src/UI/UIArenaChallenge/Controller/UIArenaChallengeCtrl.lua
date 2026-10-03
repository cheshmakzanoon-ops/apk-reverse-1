local UIArenaChallengeCtrl = BaseClass("UIArenaChallengeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIArenaChallenge, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIArenaChallengeCtrl.CloseSelf = CloseSelf
UIArenaChallengeCtrl.Close = Close
return UIArenaChallengeCtrl
