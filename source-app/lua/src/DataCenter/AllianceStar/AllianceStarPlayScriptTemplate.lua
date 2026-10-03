local AllianceStarPlayScriptTemplate = BaseClass("AllianceStarPlayScriptTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.dialog = nil
  self.animation = nil
  self.bubbleStay = nil
  self.bubbleType = 1
  self.bubbleDelay = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.dialog = nil
  self.animation = nil
  self.bubbleStay = nil
  self.bubbleType = nil
  self.bubbleDelay = nil
end

local function ParseData(self, cfg)
  self.id = cfg:getValue("id")
  self.type = cfg:getValue("type")
  self.dialog = cfg:getValue("dialog")
  self.animation = cfg:getValue("animation")
  self.bubbleStay = cfg:getValue("bubble_stay")
  self.bubbleType = cfg:getValue("bubble_type")
  self.bubbleDelay = cfg:getValue("bubble_delay")
end

AllianceStarPlayScriptTemplate.__init = __init
AllianceStarPlayScriptTemplate.__delete = __delete
AllianceStarPlayScriptTemplate.ParseData = ParseData
return AllianceStarPlayScriptTemplate
