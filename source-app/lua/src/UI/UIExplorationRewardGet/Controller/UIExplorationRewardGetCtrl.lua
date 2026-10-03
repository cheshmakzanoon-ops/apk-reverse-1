local UIExplorationRewardGetCtrl = BaseClass("UIExplorationRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIExplorationRewardGet)
  EventManager:GetInstance():Broadcast(EventId.ActGolloesCardFlipAll, 1)
end

local function Close(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function ClearParam(self)
  DataCenter.RewardManager:ClearParam()
end

UIExplorationRewardGetCtrl.CloseSelf = CloseSelf
UIExplorationRewardGetCtrl.Close = Close
UIExplorationRewardGetCtrl.GetParam = GetParam
UIExplorationRewardGetCtrl.ClearParam = ClearParam
return UIExplorationRewardGetCtrl
