local LuckyRewardItemInfoTemplate = BaseClass("LuckyRewardItemInfoTemplate")

local function __init(self)
  self.id = 0
  self.activityId = 0
  self.iconPath = ""
  self.diamondProportion = 0
  self.ifLottery = false
  self.levelTxtNum = 0
  self.level = 0
end

local function __delete(self)
  self.id = nil
  self.activityId = nil
  self.iconPath = nil
  self.diamondProportion = nil
  self.ifLottery = nil
  self.levelTxtNum = nil
  self.level = nil
end

local function ParseData(self, row, activityId)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.activityId = activityId
  self.iconPath = string.format(LoadPath.UIScratchOffLuckyIcon, row:getValue("icon"))
  self.diamondProportion = tonumber(row:getValue("diamond_proportion"))
  self.ifLottery = self.diamondProportion ~= 0
  local level = tonumber(row:getValue("title"))
  local levelTitleName = row:getValue("titleName")
  self.level = level
  self.levelTxtNum = levelTitleName
end

LuckyRewardItemInfoTemplate.__init = __init
LuckyRewardItemInfoTemplate.__delete = __delete
LuckyRewardItemInfoTemplate.ParseData = ParseData
return LuckyRewardItemInfoTemplate
