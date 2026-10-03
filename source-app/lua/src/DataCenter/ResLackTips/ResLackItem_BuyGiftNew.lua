local ResLackItemBase = require("DataCenter.ResLackTips.ResLackItemBase")
local ResLackItem_BuyGiftNew = BaseClass("ResLackItem_BuyGiftNew", ResLackItemBase)
local Localization = CS.GameEntry.Localization

function ResLackItem_BuyGiftNew:CheckIsOk(_resType, _needCnt)
  local goods = self._config:getValue("goods")
  local packageTb = GiftPackageData.GetGivenPacks(goods)
  if packageTb and 0 < #packageTb then
    self.packageInfo = packageTb[1]
    return true
  end
  return false
end

function ResLackItem_BuyGiftNew:TodoAction()
  DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIResourceLackNew)
end

function ResLackItem_BuyGiftNew:GetGiftName()
  return Localization:GetString(self.packageInfo:getName())
end

function ResLackItem_BuyGiftNew:GetGiftPrice()
  local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
  return price
end

function ResLackItem_BuyGiftNew:GetCellsList()
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

return ResLackItem_BuyGiftNew
