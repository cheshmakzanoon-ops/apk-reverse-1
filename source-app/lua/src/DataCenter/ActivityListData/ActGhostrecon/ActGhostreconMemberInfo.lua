local ActGhostreconMemberInfo = BaseClass("ActGhostreconMemberInfo")
local ActGhostreconMemberHeroInfo = require("DataCenter.ActivityListData.ActGhostrecon.ActGhostreconMemberHeroInfo")

local function __init(self)
  self.uid = 0
  self.memberInfo = {}
  self.rewarded = 0
  self.helpRewarded = 0
  self.canReward = 0
  self.heroList = nil
end

local function __delete(self)
  self.uid = nil
  self.memberInfo = nil
  self.rewarded = nil
  self.helpRewarded = nil
  self.canReward = nil
  self.heroList = nil
end

local function ParseData(self, msg)
  if msg == nil then
    return
  end
  self.uid = msg.uid
  self.memberInfo = msg.memberInfo
  self.rewarded = msg.rewarded
  self.helpRewarded = msg.helpRewarded
  self.canReward = msg.canReward
  if msg.heroList then
    self.heroList = {}
    for index, value in ipairs(msg.heroList) do
      local heroInfo = ActGhostreconMemberHeroInfo.New()
      heroInfo:ParseData(value)
      table.insert(self.heroList, value)
    end
  else
    self.heroList = nil
  end
end

ActGhostreconMemberInfo.__init = __init
ActGhostreconMemberInfo.__delete = __delete
ActGhostreconMemberInfo.ParseData = ParseData
return ActGhostreconMemberInfo
