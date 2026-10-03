local ResLackItem_BuyGiftResNew = BaseClass("ResLackItem_BuyGiftResNew")
local Localization = CS.GameEntry.Localization

function ResLackItem_BuyGiftResNew:CheckIsOk(_resType, isResItem)
  if _resType == ResourceType.PVE_STAMINA then
    _resType = ResourceType.FORMATION_STAMINA
  end
  if isResItem then
    local packageTb = GiftPackageData.GetResourceItemPacks(_resType)
    if packageTb and 0 < #packageTb then
      self.packageInfo = packageTb[1]
      return packageTb[1]
    end
  else
    local packageTb = GiftPackageData.GetResourcePacks(_resType)
    if packageTb and 0 < #packageTb then
      self.packageInfo = packageTb[1]
      return packageTb[1]
    end
  end
  return nil
end

function ResLackItem_BuyGiftResNew:TodoAction()
  DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIResourceLackNew)
end

function ResLackItem_BuyGiftResNew:GetGiftName()
  return Localization:GetString(self.packageInfo:getName())
end

function ResLackItem_BuyGiftResNew:GetTips()
  return 1001
end

function ResLackItem_BuyGiftResNew:GetGiftPrice()
  local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
  return price
end

function ResLackItem_BuyGiftResNew:GetCellsList()
  local listParam = {}
  local info = self.packageInfo
  local heroStr = info:getHeroesStr()
  if not string.IsNullOrEmpty(heroStr) then
    local arr = string.split(heroStr, ";")
    if #arr == 2 then
      local param = {}
      param.rewardType = RewardType.HERO
      param.itemId = arr[1]
      param.count = arr[2]
      table.insert(listParam, param)
    end
  end
  local str = info:getItemsStr()
  local _item_use = info:getItemUse()
  if _item_use ~= nil and _item_use ~= "" then
    str = _item_use .. "|" .. str
  end
  local arrMiddle = string.split(str, "|")
  if arrMiddle ~= nil and 0 < #arrMiddle then
    for k, v in ipairs(arrMiddle) do
      local arr = string.split(v, ";")
      if arr[1] ~= "" then
        local param = {}
        param.rewardType = RewardType.GOODS
        param.itemId = arr[1]
        local numCount = tonumber(arr[2])
        param.count = string.GetFormattedSeperatorNum(numCount)
        table.insert(listParam, param)
      end
    end
  end
  local goldParam = {}
  local goldNum = tonumber(info:getDiamond())
  if 0 < goldNum then
    goldParam.rewardType = RewardType.GOLD
    goldParam.count = string.GetFormattedSeperatorNum(goldNum)
    goldParam.itemId = ResourceType.Gold
    table.insert(listParam, 2, goldParam)
  end
  local temp = info:GetDiscountTips()
  if temp and temp[4] then
    local replace = temp[4]
    for i, v in pairs(replace) do
      listParam[i] = v
    end
  end
  return listParam
end

function ResLackItem_BuyGiftResNew:GetId()
  return self.packageInfo:getID()
end

return ResLackItem_BuyGiftResNew
