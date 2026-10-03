local DragonBattleInfo = BaseClass("DragonBattleInfo")
local VsInfoArr = require("DataCenter.ActDragonManager.VsInfoArr")

function DragonBattleInfo:__init()
  self.vsInfoArr = {}
  self.battleEndTime = 0
  self.selfSide = 0
  self.selfSideScore = 0
  self.otherSideScore = 0
  self.group = 0
end

function DragonBattleInfo:__delete()
  self.vsInfoArr = {}
  self.battleEndTime = 0
  self.selfSide = 0
  self.selfSideScore = 0
  self.otherSideScore = 0
  self.group = 0
end

function DragonBattleInfo:ParseData(message)
  if message == nil then
    return
  end
  if message.group ~= nil then
    self.group = message.group
  end
  local scoreInfo = message.battleInfo
  if scoreInfo ~= nil then
    self.vsInfoArr = {}
    for _, v in pairs(scoreInfo) do
      local oneData = VsInfoArr.New()
      oneData:ParseData(v)
      if oneData.allianceId ~= nil and oneData.allianceId ~= "" then
        self.vsInfoArr[oneData.allianceId] = oneData
        if oneData.allianceId == LuaEntry.Player.allianceId then
          self.selfSide = oneData.side
          self.selfSideScore = oneData.score
        else
          self.otherSideScore = oneData.score
        end
      end
    end
  end
  if message.endTime ~= nil then
    self.battleEndTime = message.endTime
  end
end

function DragonBattleInfo:ParseScoreData(message)
  if message == nil then
    return
  end
  local scoreInfo = message.battleInfo
  if scoreInfo ~= nil then
    for _, v in pairs(scoreInfo) do
      if self.vsInfoArr[v.allianceId] then
        local oneData = self.vsInfoArr[v.allianceId]
        if v.score then
          oneData.score = v.score
        end
        if v.changeType then
          oneData.changeType = v.changeType
        else
          oneData.changeType = -1
        end
        if oneData.allianceId == LuaEntry.Player.allianceId then
          self.selfSideScore = oneData.score
        else
          self.otherSideScore = oneData.score
        end
      end
    end
  end
end

return DragonBattleInfo
