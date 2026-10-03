local DetectLevelTemplate = BaseClass("DetectLevelTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = ""
end

local function __delete(self)
  self.id = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id"))
end

DetectLevelTemplate.__init = __init
DetectLevelTemplate.__delete = __delete
DetectLevelTemplate.InitData = InitData
return DetectLevelTemplate
