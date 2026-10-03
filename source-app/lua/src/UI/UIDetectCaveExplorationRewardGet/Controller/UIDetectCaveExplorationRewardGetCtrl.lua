local UIDetectCaveExplorationRewardGetCtrl = BaseClass("UIDetectCaveExplorationRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDetectCaveExplorationRewardGet)
  EventManager:GetInstance():Broadcast(EventId.ActGolloesCardFlipAll, 1)
end

local function Close(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function ClearParam(self)
  DataCenter.RewardManager:ClearParam()
end

UIDetectCaveExplorationRewardGetCtrl.CloseSelf = CloseSelf
UIDetectCaveExplorationRewardGetCtrl.Close = Close
UIDetectCaveExplorationRewardGetCtrl.GetParam = GetParam
UIDetectCaveExplorationRewardGetCtrl.ClearParam = ClearParam
return UIDetectCaveExplorationRewardGetCtrl
