local ItemExchangeTemplate = BaseClass("ItemExchangeTemplate")

function ItemExchangeTemplate:__init()
  self.id = 0
  self.times = ""
  self.af_goods = ""
  self.times_stamp = ""
  self.times_type = 0
  self.para = 0
  self.text = ""
end

function ItemExchangeTemplate:__delete()
  self.id = nil
  self.times = nil
  self.af_goods = nil
  self.times_stamp = nil
  self.times_type = 0
  self.para = 0
  self.text = ""
end

function ItemExchangeTemplate:InitData(configData)
  if configData == nil then
    return false
  end
  self.id = configData:getIntValue("id")
  self.times = configData:getValue("times")
  self.af_goods = configData:getValue("af_goods")
  self.times_stamp = configData:getValue("times_stamp")
  self.times_type = configData:getIntValue("times_type")
  self.para = configData:getIntValue("para")
  self.text = configData:getValue("text")
  return checknumber(self.id) > 0
end

function ItemExchangeTemplate:GetExchangeTargetItemData()
  local res = {}
  if string.IsNullOrEmpty(self.af_goods) then
    return res
  end
  local splitStr = string.split(self.af_goods, ";")
  if splitStr ~= nil and #splitStr == 2 then
    local itemId = checknumber(splitStr[1])
    local itemNum = checknumber(splitStr[2])
    table.insert(res, {itemId = itemId, itemNum = itemNum})
  end
  return res
end

function ItemExchangeTemplate:GetExpiredTime()
  local time = -1
  if time < 0 and not string.IsNullOrEmpty(self.times_stamp) then
    time = tonumber(self.times_stamp)
  end
  if time < 0 and not string.IsNullOrEmpty(self.times) then
    time = UIUtil.GetAbsoluteTimeByStr(self.times)
  end
  return time
end

function ItemExchangeTemplate:IsExpiredNow()
  local exchangeServerData = DataCenter.ItemExchangeManager:GetItemExchangeServerDataById(self.id)
  if exchangeServerData == nil then
    return false
  end
  local expiredTime = exchangeServerData.expireTime
  if 0 < expiredTime then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if exchangeServerData.timeType == 1 or exchangeServerData.timeType == 3 then
      return expiredTime <= curTime
    elseif exchangeServerData.timeType == 4 then
      local item = DataCenter.ItemData:GetItemById(self.id)
      if item == nil then
        Logger.LogError("\229\189\147\229\137\141id\232\142\183\229\143\150\228\184\141\229\136\176Item\230\149\176\230\141\174\239\188\140\230\163\128\230\159\165\230\152\175\229\144\166\233\156\128\232\166\129\230\150\176\229\162\158\230\142\165\229\143\163")
        return false
      end
      local itemNum = item and item.count or 0
      return expiredTime <= curTime and itemNum < exchangeServerData.para
    end
  end
  return false
end

return ItemExchangeTemplate
