local ValentineRankData = BaseClass("ValentineRankData")

local function __init(self)
  self.owner = {}
  self.activityId = 0
  self.rankArr = {}
  self.channelId = -1
  self.firstReward = {}
end

local function __delete(self)
  self.owner = nil
  self.activityId = nil
  self.rankArr = nil
  self.channelId = nil
  self.firstReward = nil
end

function ValentineRankData:UpdateServerData(channelId, data)
  self.channelId = channelId
  self.activityId = toInt(data.activityId)
  self.owner = data.owner
  self.rankArr = data.rankArr
  self.firstReward = data.firstReward
end

ValentineRankData.__init = __init
ValentineRankData.__delete = __delete
return ValentineRankData
