local CommonRewardItemInfoTemplate = BaseClass("CommonRewardItemInfoTemplate")

local function __init(self)
  self.id = 0
  self.activityId = 0
  self.rate = 0
  self.resItemInfo = {}
end

local function __delete(self)
  self.id = nil
  self.activityId = nil
  self.rate = nil
  self.resItemInfo = nil
end

local function ParseData(self, row, activityId)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.activityId = activityId
  self.rate = row:getValue("rate_show")
  local goods = row:getValue("goods")
  local spl_goods = string.split(goods, "|")
  for i = 1, #spl_goods do
    local spl_goods2 = string.split_ss_array(spl_goods[i], ";")
    self.resItemInfo[i] = {}
    self.resItemInfo[i].rewardType = RewardType.GOODS
    self.resItemInfo[i].itemId = tonumber(spl_goods2[1])
    self.resItemInfo[i].count = tonumber(spl_goods2[2])
  end
end

CommonRewardItemInfoTemplate.__init = __init
CommonRewardItemInfoTemplate.__delete = __delete
CommonRewardItemInfoTemplate.ParseData = ParseData
return CommonRewardItemInfoTemplate
