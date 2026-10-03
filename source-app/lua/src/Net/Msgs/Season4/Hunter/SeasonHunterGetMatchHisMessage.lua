local SeasonHunterGetMatchHisMessage = BaseClass("SeasonHunterGetMatchHisMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonHunterGetMatchHisMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonHunterGetMatchHisMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local hunterMatchHis = t.hunterMatchHis
  local dataDic = {}
  for i, v in ipairs(hunterMatchHis) do
    if v.recordType == 2 then
      dataDic[v.matchId] = v
      v.list = {}
    end
  end
  for i, v in ipairs(hunterMatchHis) do
    if v.recordType ~= 2 then
      local data = dataDic[v.matchId]
      if data then
        table.insert(data.list, v)
      end
    end
  end
  local dataList = {}
  for i, v in pairs(dataDic) do
    table.insert(dataList, v)
  end
  table.sort(dataList, function(a, b)
    return a.time > b.time
  end)
  for i, v in ipairs(dataList) do
    table.sort(v.list, function(a, b)
      return a.time > b.time
    end)
  end
  DataCenter.SeasonHunterManager.historyList = dataList
  EventManager:GetInstance():Broadcast(EventId.SeasonHunterGetMatchHistory, dataList)
end

function SeasonHunterGetMatchHisMessage:GetTestData()
  local data = {}
  local hunterMatchHis = {}
  local type2Count = math.random(1, 10)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for i = 1, type2Count do
    local matchId = math.random(0, 9999999999)
    local item2 = {}
    item2.recordType = 2
    item2.lifeTime = math.random(0, 1000000)
    item2.killNum = math.random(0, 100)
    item2.score = math.random(0, 1000000)
    item2.rank = math.random(1, 100)
    item2.state = math.random(0, 1)
    item2.matchId = matchId
    item2.time = curTime - i * math.random(0, 1000000)
    table.insert(hunterMatchHis, item2)
    local type1Count = math.random(1, 10)
    for j = 1, type1Count do
      local item = {}
      item.recordType = 1
      item.killName = tostring(math.random(0, 10000000))
      item.killPoint = math.random(0, 1000000)
      item.defSrcSid = math.random(745, 752)
      item.eventSid = math.random(745, 752)
      item.gainScore = math.random(0, 1000)
      item.matchId = matchId
      item.time = item2.time - math.random(0, 1000000)
      table.insert(hunterMatchHis, item)
    end
  end
  data.hunterMatchHis = hunterMatchHis
  return data
end

return SeasonHunterGetMatchHisMessage
