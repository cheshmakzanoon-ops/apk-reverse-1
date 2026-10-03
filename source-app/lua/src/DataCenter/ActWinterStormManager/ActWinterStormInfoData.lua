local ActWinterStormInfoData = BaseClass("ActWinterStormInfoData")
local MarchResult = require("DataCenter.ActWinterStormManager.MarchResult")

function ActWinterStormInfoData:__init()
  self.actEndTime = 0
  self.noticeBeginTime = 0
  self.noticeEndTime = 0
  self.battleBeginTime = 0
  self.battleEndTime = 0
  self.battleK4 = {}
  self.battleK5 = 0
  self.score = 0
  self.mvp = {}
  self.state = 0
  self.marchResult = MarchResult.New()
  self.battleScore = {}
  self.matchCDTime = 0
  self.taskRewardParam = 0
  self.fightRewardParam = 0
  self.sCfgId = 0
  self.season = 0
  self.seasonMapInfo = nil
end

function ActWinterStormInfoData:__delete()
  self.actEndTime = 0
  self.noticeBeginTime = 0
  self.noticeEndTime = 0
  self.battleBeginTime = 0
  self.battleEndTime = 0
  self.battleK4 = {}
  self.battleK5 = 0
  self.score = 0
  self.mvp = {}
  self.state = 0
  self.marchResult = nil
  self.battleScore = {}
  self.matchCDTime = 0
  self.taskRewardParam = 0
  self.fightRewardParam = 0
  self.sCfgId = 0
  self.season = 0
  self.seasonMapInfo = nil
end

function ActWinterStormInfoData:ParseData(message)
  if message == nil then
    return
  end
  self.sCfgId = message.battleFieldConfigId or 0
  self.season = message.season or 0
  if message.actEndTime ~= nil then
    self.actEndTime = message.actEndTime
  end
  if message.noticeBeginTime ~= nil then
    self.noticeBeginTime = message.noticeBeginTime
  end
  if message.noticeEndTime ~= nil then
    self.noticeEndTime = message.noticeEndTime
  end
  if message.battleBeginTime ~= nil then
    self.battleBeginTime = message.battleBeginTime
  end
  if message.battleEndTime ~= nil then
    self.battleEndTime = message.battleEndTime
  end
  if message.battleK4 ~= nil then
    local timeList = string.split(message.battleK4, ";")
    local tmpList = {}
    for i, v in ipairs(timeList) do
      local tmpGroup = string.split(v, "-")
      tmpList[i] = tonumber(tmpGroup[1]) or 0
    end
    self.battleK4 = tmpList
  end
  if message.battleK5 ~= nil then
    self.battleK5 = tonumber(message.battleK5) or 0
  end
  if message.score ~= nil then
    self.score = tonumber(message.score) or 0
  end
  if message.mvp ~= nil then
    self.mvp = {}
    local arr = message.mvp
    local tbName = DataCenter.ActWinterStormManager:GetCfgValue(BattleFieldTableKey.STAR)
    for _, v in pairs(arr) do
      local mvpId = v.id
      local line = LocalController:instance():getLine(tbName, mvpId)
      if line ~= nil then
        local oneData = {
          id = mvpId,
          num = v.num,
          icon = line:getValue("icon"),
          name = line:getValue("name"),
          desc = line:getValue("desc"),
          score = line:getValue("score"),
          order = line:getIntValue("alert_tips")
        }
        table.insert(self.mvp, oneData)
      end
    end
    table.sort(self.mvp, function(a, b)
      return a.order < b.order
    end)
  end
  if message.state ~= nil then
    self.state = message.state
  end
  if message.marchResult ~= nil then
    local oneData = MarchResult.New()
    oneData:ParseData(message.marchResult)
    self.marchResult = oneData
  end
  self:HandleBattleScore(message.battleScore)
  if message.matchCDTime ~= nil then
    self.matchCDTime = message.matchCDTime
  end
  if message.taskRewardParam ~= nil then
    self.taskRewardParam = message.taskRewardParam or 0
  end
  if message.fightRewardParam ~= nil then
    self.fightRewardParam = message.fightRewardParam or 0
  end
end

function ActWinterStormInfoData:HandleBattleScore(arr)
  if arr == nil then
    return
  end
  self.battleScore = {}
  local flag = false
  for _, v in pairs(arr) do
    local side = v.side or 0
    local score = v.score or 0
    self.battleScore[side] = score
    flag = true
  end
  return flag
end

function ActWinterStormInfoData:Description()
  local sb = StringBuilder.New()
  local time = UITimeManager:GetInstance()
  sb:AppendLine("---\230\180\187\229\138\168\228\191\161\230\129\175---")
  sb:AppendLine(string.format("\232\181\155\229\173\163:%s", self.season))
  sb:AppendLine(string.format("\233\162\132\229\145\138\229\188\128\229\167\139\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.noticeBeginTime * 1000)))
  sb:AppendLine(string.format("\233\162\132\229\145\138\231\187\147\230\157\159\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.noticeEndTime * 1000)))
  sb:AppendLine(string.format("\230\136\152\230\150\151\229\188\128\229\167\139\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.battleBeginTime * 1000)))
  sb:AppendLine(string.format("\230\136\152\230\150\151\231\187\147\230\157\159\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.battleEndTime * 1000)))
  sb:AppendLine(string.format("\232\161\168\233\133\141\231\189\174k4:%s", table.table2string(self.battleK4)))
  sb:AppendLine(string.format("\232\161\168\233\133\141\231\189\174k5:%s", self.battleK5))
  sb:AppendLine(string.format("\228\184\170\228\186\186\231\167\175\229\136\134:%s", self.score))
  sb:AppendLine(string.format("state:%s", self.state))
  sb:AppendLine(string.format("\229\143\175\229\140\185\233\133\141CD\231\187\147\230\157\159\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(self.matchCDTime * 1000)))
  sb:AppendLine(string.format("\228\187\187\229\138\161\229\174\140\230\136\144\230\149\176\233\135\143:%s", self.taskRewardParam))
  sb:AppendLine(string.format("\230\136\152\230\150\151\229\174\140\230\136\144\230\149\176\233\135\143:%s", self.fightRewardParam))
  sb:AppendLine()
  return sb:ToString()
end

return ActWinterStormInfoData
