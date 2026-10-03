local UIHeroAdvanceSuccessCtrl = BaseClass("UIHeroAdvanceSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroAdvanceSuccess)
  EventManager:GetInstance():Broadcast(EventId.OnAdvanceSuccessClosed)
end

UIHeroAdvanceSuccessCtrl.CloseSelf = CloseSelf
return UIHeroAdvanceSuccessCtrl
