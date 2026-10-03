local CityTriggerPointTemplate = BaseClass("CityTriggerPointTemplate")
local TriggerPointUnlockRewardType = require("DataCenter.CityTriggerPoint.TriggerPointUnlockRewardType")
local tonumber = _ENV.tonumber
local split = string.split
local ipairs = _ENV.ipairs
local OriginPoint = {x = 49, y = 49}

function CityTriggerPointTemplate:__init()
end

function CityTriggerPointTemplate:__delete()
end

function CityTriggerPointTemplate:InitData(row)
  self.id = tonumber(row:getValue("id"))
  local str = row:getValue("Pos")
  if str ~= nil and str ~= "" then
    local posSplit = split(str, "|")
    self.posArr = {}
    for _, s in ipairs(posSplit) do
      local ss = split(s, ",")
      if #ss == 2 then
        self.posArr[#self.posArr + 1] = Vector2.New(OriginPoint.x + tonumber(ss[1]), OriginPoint.y + tonumber(ss[2]))
      end
    end
  end
  str = row:getValue("UnclockType")
  if type(str) == "number" then
    self.unlockType = {str}
  elseif str ~= nil and str ~= "" then
    local ss = split(str, "|")
    self.unlockType = {}
    for _, v in ipairs(ss) do
      self.unlockType[#self.unlockType + 1] = tonumber(v)
    end
  end
  str = row:getValue("UnclockPara")
  if type(str) == "number" then
    self.unlockPara = {str}
  elseif str ~= nil and str ~= "" then
    local ss = split(str, "|")
    self.unlockPara = {}
    for _, v in ipairs(ss) do
      self.unlockPara[#self.unlockPara + 1] = tonumber(v)
    end
  end
  str = row:getValue("UnclockRewardType")
  if str ~= nil and str ~= "" then
    self.unlockRewardType = tonumber(str)
  end
  str = row:getValue("UnclockRewardPara")
  if str ~= nil and str ~= "" then
    if self.unlockRewardType == TriggerPointUnlockRewardType.Building then
      self.unlockRewardPara = tonumber(str)
    elseif self.unlockRewardType == TriggerPointUnlockRewardType.Fog then
      local ss = split(str, ",")
      self.unlockRewardPara = {}
      for _, v in ipairs(ss) do
        self.unlockRewardPara[#self.unlockRewardPara + 1] = tonumber(v)
      end
    end
  end
  local ss = split(row:getValue("ShowPos"), ",")
  if #ss == 2 then
    self.showPos = Vector2.New(OriginPoint.x + tonumber(ss[1]), OriginPoint.y + tonumber(ss[2]))
  end
  self.tag = row:getValue("TagType")
  self.tagPara = row:getValue("Tagpara")
  self.arrowShow = row:getValue("ArrowShow")
end

return CityTriggerPointTemplate
