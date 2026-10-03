local UIGiftPackageRewardGetCtrl = BaseClass("UIGiftPackageRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackageRewardGet)
  EventManager:GetInstance():Broadcast(EventId.ActGolloesCardFlipAll, 1)
end

local function Close(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetParam(self)
  local param = {}
  local reward = DataCenter.RewardManager:GetParam()
  if reward.isUpChange then
    local count = 0
    if reward.isUpChange == RewardType.GOODS then
      local item = DataCenter.ItemData:GetItemById(reward.rewardList[1].itemId)
      if item then
        count = item.count
      end
    elseif reward.isUpChange == RewardType.ARM then
      local armyInfo = DataCenter.ArmyManager:FindArmy(reward.rewardList[1].itemId)
      if armyInfo then
        count = armyInfo.free
      end
    elseif reward.isUpChange == RewardType.PVE_POINT then
      if DataCenter.ItemTemplateManager:GetItemTemplate(RewardToResType[reward.isUpChange]) ~= nil then
        local item = DataCenter.ItemData:GetItemById(RewardToResType[reward.isUpChange])
        if item ~= nil then
          count = item.count
        end
      else
        count = LuaEntry.Resource:GetCntByResType(RewardToResType[reward.isUpChange])
      end
    end
    param.rewardType = reward.rewardList[1].rewardType
    param.itemId = reward.rewardList[1].itemId
    param.count = count - reward.rewardList[1].count
    if 0 > param.count then
      param.count = 0
    end
    param.heroUuid = reward.rewardList[1].heroUuid
    param.isHeroBox = reward.rewardList[1].isHeroBox
    param.isArmyFly = reward.isArmyFly
    table.insert(reward.rewardList, 1, param)
    reward.rewardList[2].count = count
  end
  return reward
end

local function ClearParam(self)
  DataCenter.RewardManager:ClearParam()
end

local function OnCustomKeyCodeEscape(self)
  EventManager:GetInstance():Broadcast(EventId.OnRewardGetPanelClose)
  self:CloseSelf()
end

UIGiftPackageRewardGetCtrl.CloseSelf = CloseSelf
UIGiftPackageRewardGetCtrl.Close = Close
UIGiftPackageRewardGetCtrl.GetParam = GetParam
UIGiftPackageRewardGetCtrl.ClearParam = ClearParam
UIGiftPackageRewardGetCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIGiftPackageRewardGetCtrl
