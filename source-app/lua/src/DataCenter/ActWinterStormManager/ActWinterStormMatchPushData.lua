local ActWinterStormMatchPushData = BaseClass("ActWinterStormMatchPushData")
local TeamArr = require("DataCenter.ActWinterStormManager.TeamArr")

function ActWinterStormMatchPushData:__init()
  self.timeoutEnd = 0
  self.team = {}
  self.readyCnt = 0
end

function ActWinterStormMatchPushData:__delete()
  self.timeoutEnd = 0
  self.team = {}
  self.readyCnt = 0
end

function ActWinterStormMatchPushData:ParseData(message)
  if message == nil then
    return
  end
  if message.timeoutEnd ~= nil then
    self.timeoutEnd = message.timeoutEnd
  end
  if message.team ~= nil then
    local arr = message.team
    for i, v in ipairs(arr) do
      local oneData = TeamArr.New()
      oneData:ParseData(v)
      self.team[i] = oneData
    end
  end
end

function ActWinterStormMatchPushData:UpdateBReady(uid)
  local team = self.team
  if team == nil or table.length(self.team) == 0 then
    return
  end
  for _, v in ipairs(team) do
    if v.uid == uid then
      v.b_ready = true
      return true
    end
  end
  return false
end

function ActWinterStormMatchPushData:UpdateReadyInfo(message)
  if message == nil then
    return
  end
  if message.readyCount ~= nil then
    self.readyCnt = message.readyCount or 0
  end
  if message.team ~= nil then
    local arr = message.team
    for _, v in ipairs(arr) do
      self:UpdateBReady(v)
    end
  end
end

return ActWinterStormMatchPushData
