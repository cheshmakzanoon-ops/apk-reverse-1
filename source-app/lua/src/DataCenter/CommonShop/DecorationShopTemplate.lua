local DecorationShopTemplate = BaseClass("DecorationShopTemplate")

function DecorationShopTemplate:__init()
  self.id = 0
  self.freeCount = 0
  self.lastRefreshTime = 0
  self.seasonRefreshKey = 0
  self.seasonRefreshValue = 0
  self.group = 0
  self.exchangeGroupId = 0
  self.cost_item = 0
  self.freeRewardId = 0
  self.cd = 0
  self.infoId = 0
  self.pic = ""
  self.shopName = ""
  self.refreshGiftInfoList = {}
  self.itemSubTypeKeyList = {}
  self.maxFreeTime = 0
  self.refreshFreeTime = 0
  self.giftRefreshType = 0
  self.giftRefreshInfo = {}
  self.rechargeConditionInfo = {
    raw = "",
    functionSeasonId = 0,
    giftId = 0
  }
end

function DecorationShopTemplate:__delete()
  self.id = nil
  self.freeCount = nil
  self.lastRefreshTime = nil
  self.seasonRefreshKey = nil
  self.seasonRefreshValue = nil
  self.group = nil
  self.exchangeGroupId = nil
  self.cost_item = nil
  self.freeRewardId = nil
  self.cd = nil
  self.infoId = nil
  self.pic = nil
  self.shopName = nil
  self.refreshGiftInfoList = nil
  self.itemSubTypeKeyList = nil
  self.maxFreeTime = nil
  self.refreshFreeTime = nil
  self.giftRefreshType = nil
  self.giftRefreshInfo = nil
  self.rechargeConditionInfo = nil
end

function DecorationShopTemplate:UpdateData(info)
  if info == nil then
    return
  end
  self.id = info.id or 0
  self.freeCount = info.freeCount or 0
  self.lastRefreshTime = info.lastRefreshTime or 0
  self.seasonRefreshKey = info.key or 0
  self.seasonRefreshValue = info.value or 0
  local line = LocalController:instance():getLine(TableName.LW_DECORATION_SHOP, self.id)
  self.group = line:getValue("group") or 0
  self.cost_item = line:getValue("cost_item")
  self.exchangeGroupId = line:getValue("exchangeid") or 0
  self.freeRewardId = line:getValue("free_reward") ~= nil and tonumber(line:getValue("free_reward")) or 0
  self.cd = line:getValue("gift_cd") or 0
  self.infoId = line:getValue("info_id") or 0
  self.shopItemPic = line:getValue("pic") or ""
  self.shopName = line:getValue("shop_name") or ""
  local refreshGiftInfo = line:getValue("refresh_gift_list")
  local refreshGiftList = refreshGiftInfo ~= nil and string.split(tostring(refreshGiftInfo), "|") or {}
  local refreshGiftNumInfo = line:getValue("refresh_giftnum_list")
  local refreshGiftNumList = refreshGiftNumInfo ~= nil and string.split(tostring(refreshGiftNumInfo), "|") or {}
  local refreshGiftNumMaxInfo = line:getValue("refresh_maxnum_list")
  local refreshGiftMaxNumList = refreshGiftNumMaxInfo ~= nil and string.split(tostring(refreshGiftNumMaxInfo), "|") or {}
  if type(refreshGiftList) == "table" or type(refreshGiftNumList) == "table" or type(refreshGiftMaxNumList) == "table" then
    for i = 1, #refreshGiftList do
      local giftInfo = {}
      giftInfo.id = refreshGiftList[i]
      giftInfo.buyCount = refreshGiftNumList[i]
      giftInfo.maxBuyCount = refreshGiftMaxNumList[i]
      table.insert(self.refreshGiftInfoList, giftInfo)
    end
  end
  local shopSubPara = line:getValue("shop_sub_para")
  if not string.IsNullOrEmpty(shopSubPara) then
    local shopSubParaArr = string.split(shopSubPara, ";")
    for k, v in pairs(shopSubParaArr) do
      local shopSubParaStr = string.split(v, "|")
      local paraTable = {}
      local type = tonumber(shopSubParaStr[1])
      local key = shopSubParaStr[2]
      paraTable.type = type
      paraTable.key = key
      table.insert(self.itemSubTypeKeyList, paraTable)
    end
  end
  self.maxFreeTime = line:getValue("max_freetime")
  self.refreshFreeTime = line:getValue("refresh_freetime")
  local refreshType = line:getValue("gift_refresh_type")
  self.giftRefreshType = refreshType and tonumber(refreshType) or 0
  local rcInfo = self.rechargeConditionInfo
  rcInfo.raw = line:getValue("recharge_condition") or ""
  rcInfo.functionSeasonId = 0
  rcInfo.giftId = 0
  if not string.IsNullOrEmpty(rcInfo.raw) then
    local rechargePipeParts = string.split(tostring(rcInfo.raw), "|")
    if type(rechargePipeParts) == "table" and 2 <= #rechargePipeParts then
      rcInfo.functionSeasonId = tonumber(string.trim(rechargePipeParts[1])) or 0
      rcInfo.giftId = tonumber(string.trim(rechargePipeParts[2])) or 0
    end
  end
  local refreshTypePara = line:getValue("gift_refresh_type_para")
  if not string.IsNullOrEmpty(refreshTypePara) then
    local refreshTypeParaArr = string.split(refreshTypePara, ";")
    for k, v in pairs(refreshTypeParaArr) do
      if string.IsNullOrEmpty(v) then
        Logger.LogError("DecorationShopTemplate refreshTypePara is wrong")
        return
      end
      local refreshTypeInfoArr = string.split(v, "|")
      if not refreshTypeInfoArr or #refreshTypeInfoArr ~= 2 then
        Logger.LogError("DecorationShopTemplate refreshTypeInfoArr is wrong")
        return
      end
      self.giftRefreshInfo[tonumber(refreshTypeInfoArr[1])] = refreshTypeInfoArr[2]
    end
  end
end

function DecorationShopTemplate:GetItemSubTypeKey(type)
  local result = ""
  if self.itemSubTypeKeyList then
    for k, v in pairs(self.itemSubTypeKeyList) do
      if v and v.type == type then
        result = v.key
        break
      end
    end
  end
  return result
end

function DecorationShopTemplate:GetRefreshInfo(giftId)
  if not giftId then
    Logger.LogError("giftId is nil")
    return {}
  end
  local result = {}
  for k, v in pairs(self.refreshGiftInfoList) do
    if v and v.id and v.id == giftId then
      result = v
      break
    end
  end
  return result
end

function DecorationShopTemplate:GetFreeRefreshInfo()
  local result = {}
  result.maxTime = self.maxFreeTime
  result.refreshFreeTime = self.refreshFreeTime
  return result
end

function DecorationShopTemplate:GetTitleAndDesc()
  if string.IsNullOrEmpty(self.infoId) then
    return nil
  end
  local str = string.split(self.infoId, "|")
  if not str or type(str) ~= "table" or table.length(str) ~= 2 then
    return nil
  end
  local result = {}
  result.title = str[1]
  result.content = str[2]
  return result
end

return DecorationShopTemplate
