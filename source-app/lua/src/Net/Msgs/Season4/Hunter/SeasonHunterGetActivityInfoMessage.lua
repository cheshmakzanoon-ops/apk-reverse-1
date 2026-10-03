local SeasonHunterGetActivityInfoMessage = BaseClass("SeasonHunterGetActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonHunterGetActivityInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonHunterGetActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonHunterManager:OnServerInfoChange(t.serverInfo, t)
end

function SeasonHunterGetActivityInfoMessage:GetTestData()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local isOpen = true
  local data = {
    nightOpen = isOpen and 1 or 0,
    wolfNum = isOpen and math.random(0, 2000) or 0,
    wolfNumOut = isOpen and math.random(0, 2000) or 0,
    endTime = isOpen and curTime * 1000 + math.random(100, 100000) or 0,
    score = isOpen and math.random(0, 100000) or 0,
    matchRank = isOpen and math.random(0, 2000) or 0,
    joinTime = isOpen and curTime * 1000 - math.random(0, 50000) or 0
  }
  local serverInfo = {
    banServerList = {},
    waitBanServerList = {},
    LastServerList = {}
  }
  if isOpen then
    for i = 745, 752 do
      if math.random(1, 10) > 5 then
        local info = {
          sid = i,
          lastWolfNum = math.random(0, 2000)
        }
        table.insert(serverInfo.LastServerList, info)
      elseif math.random(1, 100) > 50 then
        local info = {
          sid = i,
          banTime = curTime + math.random(0, 180),
          lastWolfNum = math.random(0, 2000)
        }
        table.insert(serverInfo.waitBanServerList, info)
      else
        local info = {
          sid = math.random(0, 10) > 3 and i or LuaEntry.Player:GetSelfServerId(),
          banTime = curTime - math.random(0, 300)
        }
        table.insert(serverInfo.banServerList, info)
      end
    end
  end
  data.serverInfo = serverInfo
  return data
end

return SeasonHunterGetActivityInfoMessage
