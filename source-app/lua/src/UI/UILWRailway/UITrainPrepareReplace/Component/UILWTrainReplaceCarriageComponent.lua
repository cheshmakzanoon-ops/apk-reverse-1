local UILWTrainReplaceCarriageComponent = BaseClass("UILWTrainReplaceCarriageComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWTrainReplaceCarriageItemRender = require("UI.UILWRailway.UITrainPrepareReplace.Component.UILWTrainReplaceCarriageItemRender")
local value_text_path = "ValueGroup/ValueText"

function UILWTrainReplaceCarriageComponent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UILWTrainReplaceCarriageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainReplaceCarriageComponent:DataDefine()
end

function UILWTrainReplaceCarriageComponent:DataDestroy()
end

function UILWTrainReplaceCarriageComponent:ComponentDefine()
  self.value_text = self:AddComponent(UITextMeshProUGUIEx, value_text_path)
  self.carriageList = {}
  for i = 1, 4 do
    self.carriageList[i] = self:AddComponent(UILWTrainReplaceCarriageItemRender, "Goods" .. i)
  end
end

function UILWTrainReplaceCarriageComponent:ComponentDestroy()
  self.value_text = nil
  self.carriageList = nil
end

function UILWTrainReplaceCarriageComponent:ShowView(showBakReward)
  local diamondPrice = 0
  if showBakReward then
    diamondPrice = self.view.trainData:GetBakReward2DiamondPrice()
  else
    diamondPrice = self.view.trainData:GetFullReward2DiamondPrice()
  end
  self.value_text:SetText(string.GetFormattedSeparatorNum(diamondPrice))
  for i = 1, 4 do
    local rewardList
    if showBakReward then
      rewardList = self.view.trainData:GetBakRewardByCarriageId(i + 1)
    else
      rewardList = self.view.trainData:GetFullRewardByCarriageId(i + 1)
    end
    local isUR = self.view.trainData:IsUR()
    self.carriageList[i]:ShowReward(rewardList, isUR)
  end
end

return UILWTrainReplaceCarriageComponent
