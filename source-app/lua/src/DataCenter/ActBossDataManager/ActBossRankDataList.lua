local ActBossRankDataList = BaseClass("ActBossRankDataList")
local ActBossRankData = require("DataCenter.ActBossDataManager.ActBossRankData")

local function __init(self)
  self.uuid = 0
  self.selfRankData = {}
  self.rankList = {}
end

local function __delete(self)
  self.uuid = nil
  self.selfRankData = nil
  self.rankList = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  self.selfRankData = ActBossRankData.New()
  self.selfRankData:ParseData(message.selfRank, message.selfScore, message.selfUnit, LuaEntry.Player.Uid)
  self.rankList = {}
  local list = message.rankList
  if list ~= nil then
    for k, v in pairs(list) do
      local oneData = ActBossRankData.New()
      oneData:ParseData(v.rank, v.score, v.armyUnit, v.uid)
      if oneData.rank >= 0 then
        self.rankList[oneData.rank] = oneData
      end
    end
  end
end

ActBossRankDataList.__init = __init
ActBossRankDataList.__delete = __delete
ActBossRankDataList.ParseData = ParseData
return ActBossRankDataList
