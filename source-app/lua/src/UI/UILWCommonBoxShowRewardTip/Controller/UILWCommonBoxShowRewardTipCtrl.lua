local UILWCommonBoxRewardShowTipCtrl = BaseClass("UILWCommonBoxRewardShowTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCommonBoxShowRewardTip, {anim = true})
end

local function GetRewardParam(self, reward)
  local param = {}
  param.rewardType = reward.rewardType
  param.itemId = reward.itemId
  param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
  param.rank = ItemColor.WHITE
  param.name = DataCenter.RewardManager:GetNameByType(param.rewardType, param.itemId)
  param.iconName = DataCenter.RewardManager:GetPicByType(param.rewardType, param.itemId)
  if param.rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
    if goods ~= nil then
      param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
      param.type = goods.type
      param.para2 = goods.para2
      param.rank = goods.color
    end
  elseif RewardToResType[param.rewardType] ~= nil then
    param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
  end
  param.count = reward.count
  return param
end

UILWCommonBoxRewardShowTipCtrl.CloseSelf = CloseSelf
UILWCommonBoxRewardShowTipCtrl.GetRewardParam = GetRewardParam
return UILWCommonBoxRewardShowTipCtrl
