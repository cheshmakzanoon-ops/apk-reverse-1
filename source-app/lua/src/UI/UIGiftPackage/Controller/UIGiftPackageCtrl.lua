local UIGiftPackageCtrl = BaseClass("UIGiftPackageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackage)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function BuyGift(self, info, selectedCombineIndex)
  local vec = string.split(info:getItem2Str(), "@", 0, true)
  local combinationData = ""
  if vec ~= nil and selectedCombineIndex ~= nil and selectedCombineIndex < #vec then
    combinationData = vec[self.model.selectedCombineIndex]
  end
  DataCenter.PayManager:CallPayment(info, "GoldExchangeView", combinationData)
end

local function GetTypeButtonList(self)
  return WelfareController.getShowTagInfos()
end

local function GetDiamondList(self)
  local list = {}
  local replaceList = {}
  local result = {}
  local resultDollar = {}
  local all = GiftPackageData:GetInstance().GiftPackageDict
  if all ~= nil then
    for k, v in pairs(all) do
      if v:GetIsShowType() == 0 and v.type == "1" and GiftPackageData:GetInstance():IsSpecialExchange(v.id) then
        table.insert(list, v)
        resultDollar[v.dollar] = v.id
      end
      if v.bought == false and v.popup_image ~= "new_recharge" and GiftPackageData:GetInstance():IsSpecialExchange(v.id) and (v.type == "2" or v.type == "3" and v.popup_image == "close") then
        local temp = replaceList[v.dollar]
        if temp == nil then
          local lis = {}
          table.insert(lis, v)
          replaceList[v.dollar] = lis
        else
          table.insert(replaceList[v.dollar], v)
        end
      end
    end
    for k, v in pairs(list) do
      local temp = replaceList[v.dollar]
      if temp ~= nil then
        local popup = tonumber(v.popup)
        local continue = true
        for k1, v1 in ipairs(temp) do
          if continue and popup < tonumber(v1.popup) then
            table.insert(result, v1)
            continue = false
          end
        end
      else
        table.insert(result, v)
      end
    end
  end
  if 0 < #result then
    table.sort(result, function(a, b)
      return tonumber(a.dollar) < tonumber(b.dollar)
    end)
  end
  return result, resultDollar
end

UIGiftPackageCtrl.CloseSelf = CloseSelf
UIGiftPackageCtrl.Close = Close
UIGiftPackageCtrl.BuyGift = BuyGift
UIGiftPackageCtrl.GetTypeButtonList = GetTypeButtonList
UIGiftPackageCtrl.GetDiamondList = GetDiamondList
return UIGiftPackageCtrl
