local ActivityScoreInfo = BaseClass("ActivityScoreInfo", ActivityInfoData)
local base = ActivityInfoData

local function __init(self)
  base.__init(self)
  self.siegeST = nil
  self.siegeET = nil
  self.exchange = nil
  self.vsAllianceInfo = nil
  self.winReward = nil
end

local function __delete(self)
  self.siegeST = nil
  self.siegeET = nil
  self.exchange = nil
  self.vsInfos = nil
  self.vsAllianceList = nil
  self.winReward = nil
  base.__delete(self)
end

local function parseServerData(self, activity)
  base.ParseActivityData(self, activity)
  if activity == nil then
    return
  end
  if activity.siegeST ~= nil then
    self.siegeST = activity.siegeST
  end
  if activity.siegeET ~= nil then
    self.siegeET = activity.siegeET
  end
  if activity.exchange ~= nil then
    self.exchange = activity.exchange
  end
  if activity.activityid ~= nil then
    self.activityid = activity.activityid
  end
  if activity.finish ~= nil then
    self.finish = activity.finish
  end
end

ActivityScoreInfo.__init = __init
ActivityScoreInfo.__delete = __delete
ActivityScoreInfo.parseServerData = parseServerData
return ActivityScoreInfo
