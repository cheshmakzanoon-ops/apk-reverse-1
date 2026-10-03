local UIAllianceCompeteRankCtrl = BaseClass("UIAllianceCompeteRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCompeteRank)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceCompeteRankCtrl.CloseSelf = CloseSelf
UIAllianceCompeteRankCtrl.Close = Close
return UIAllianceCompeteRankCtrl
