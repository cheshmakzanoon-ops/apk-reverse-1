local AllianceStarTemplate = BaseClass("AllianceStarTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.content = ""
  self.rewardInfoList = {}
  self.scoreTipList = nil
  self.indexId = nil
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.name = nil
  self.content = nil
  self.rewardInfoList = nil
  self.scoreTipList = nil
  self.indexId = nil
end

local function ParseData(self, cfg)
  self.id = cfg:getValue("id")
  self.type = cfg:getValue("type")
  self.name = cfg:getValue("name")
  self.content = cfg:getValue("content")
  local rewardId = cfg:getValue("rewardId")
  if not string.IsNullOrEmpty(rewardId) then
    local split1 = string.split(rewardId, "|")
    for i, v in ipairs(split1) do
      local split2 = string.split(v, ";")
      local rewardInfo = {}
      rewardInfo.type = tonumber(split2[1])
      rewardInfo.maxValue = tonumber(split2[2])
      rewardInfo.rewardId = tonumber(split2[3])
      rewardInfo.boxType = tonumber(split2[4])
      if 1 < i then
        rewardInfo.minValue = self.rewardInfoList[i - 1].maxValue
      else
        rewardInfo.minValue = 0
      end
      table.insert(self.rewardInfoList, rewardInfo)
    end
  end
  local scoreTips = cfg:getValue("scoreTips")
  if not string.IsNullOrEmpty(scoreTips) then
    self.scoreTipList = {}
    local split1 = string.split(scoreTips, "|")
    for i, v in ipairs(split1) do
      local split2 = string.split(v, ";")
      local tipInfo = {}
      tipInfo.dialogId = split2[1]
      tipInfo.score = split2[2]
      table.insert(self.scoreTipList, tipInfo)
    end
  end
  self.indexId = cfg:getValue("indexId")
end

local function GetInteractionType(self)
  local type
  if self.rewardInfoList and self.rewardInfoList[1] then
    type = self.rewardInfoList[1].type
  end
  return type
end

function AllianceStarTemplate:GetLevelByInteractionNum(num)
  local rewardInfo
  local level = #self.rewardInfoList + 1
  for i = #self.rewardInfoList, 1, -1 do
    if num > self.rewardInfoList[i].maxValue then
      break
    end
    rewardInfo = self.rewardInfoList[i]
    level = level - 1
  end
  return level, rewardInfo
end

AllianceStarTemplate.__init = __init
AllianceStarTemplate.__delete = __delete
AllianceStarTemplate.ParseData = ParseData
AllianceStarTemplate.GetInteractionType = GetInteractionType
return AllianceStarTemplate
