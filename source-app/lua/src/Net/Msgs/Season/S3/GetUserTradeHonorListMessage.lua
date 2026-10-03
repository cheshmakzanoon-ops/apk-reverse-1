local GetUserTradeHonorListMessage = BaseClass("GetUserTradeHonorListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetUserTradeHonorListMessage:OnCreate()
  base.OnCreate(self)
end

function GetUserTradeHonorListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local userTradeLevelHonorArr = t.userTradeLevelHonorArr
    table.sort(userTradeLevelHonorArr, self.SortUserTradeLevel)
    for i, v in ipairs(userTradeLevelHonorArr) do
      if not table.IsNullOrEmpty(v.userTradeHonorArr) then
        for j, vv in ipairs(v.userTradeHonorArr) do
          if not table.IsNullOrEmpty(vv.tradeCityLevelArr) then
            table.sort(vv.tradeCityLevelArr, self.SortUserTradeLevel)
          end
        end
        table.sort(v.userTradeHonorArr, self.SortUserTradeHonor)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.GetUserTradeHonorList, userTradeLevelHonorArr)
  end
end

local function SortUserTradeLevel(a, b)
  return a.level > b.level
end

local function SortUserTradeHonor(a, b)
  if a.maxLevel ~= b.maxLevel then
    return a.maxLevel > b.maxLevel
  end
  if a.tradeCityLevelArr and b.tradeCityLevelArr then
    local countA = #a.tradeCityLevelArr
    local countB = #b.tradeCityLevelArr
    local maxCount = countA > countB and countA or countB
    local timeA, timeB = 0, 0
    for i = 1, maxCount do
      local firstA = a.tradeCityLevelArr[i]
      local firstB = b.tradeCityLevelArr[i]
      if firstA and firstB then
        if firstA.level ~= firstB.level then
          return firstA.level > firstB.level
        end
        if firstA.num ~= firstB.num then
          return firstA.num > firstB.num
        end
        if timeA < firstA.time then
          timeA = firstA.time
        end
        if timeB < firstB.time then
          timeB = firstB.time
        end
      else
        return firstA ~= nil
      end
    end
    return timeA < timeB
  end
  if a.tradeCityLevelArr then
    return true
  end
  return false
end

GetUserTradeHonorListMessage.SortUserTradeLevel = SortUserTradeLevel
GetUserTradeHonorListMessage.SortUserTradeHonor = SortUserTradeHonor
return GetUserTradeHonorListMessage
