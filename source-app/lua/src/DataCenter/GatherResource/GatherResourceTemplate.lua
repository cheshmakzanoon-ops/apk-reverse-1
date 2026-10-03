local GatherResourceTemplate = BaseClass("GatherResourceTemplate")

local function __init(self)
  self.id = 0
  self.resource_type = 0
  self.level = 0
  self.reserve = 0
  self.gathering = 0
  self.size = 0
  self.expire = 0
  self.name = 0
  self.pic = ""
  self.desc = 0
  self.model = ""
  self.type = 0
  self.detect_show = ""
  self.quality = 0
end

local function __delete(self)
  self.id = nil
  self.resource_type = nil
  self.level = nil
  self.reserve = nil
  self.gathering = nil
  self.size = nil
  self.expire = nil
  self.name = nil
  self.pic = nil
  self.desc = nil
  self.model = nil
  self.type = nil
  self.detect_show = nil
  self.quality = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.resource_type = row:getValue("resource_type")
  self.level = row:getValue("level")
  self.reserve = row:getValue("reserve")
  self.gathering = row:getValue("gathering")
  self.size = row:getValue("size", 1)
  self.expire = row:getValue("expire")
  self.name = row:getValue("name")
  self.pic = row:getValue("pic")
  self.desc = row:getValue("desc")
  self.model = row:getValue("model")
  self.type = tonumber(row:getValue("special"))
  self.detect_show = row:getValue("detect_show")
  self.quality = tonumber(row:getValue("quality")) or 0
end

local function GetProcessedShowReward(self)
  return {
    {
      rewardType = ResTypeToReward[self.resource_type],
      count = self.reserve
    }
  }
end

GatherResourceTemplate.__init = __init
GatherResourceTemplate.__delete = __delete
GatherResourceTemplate.InitData = InitData
GatherResourceTemplate.GetProcessedShowReward = GetProcessedShowReward
return GatherResourceTemplate
