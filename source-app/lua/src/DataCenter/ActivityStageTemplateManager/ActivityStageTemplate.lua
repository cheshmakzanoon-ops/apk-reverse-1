local ActivityStageTemplate = BaseClass("ActivityStageTemplate")

local function __init(self)
  self.id = 0
  self.stage = 0
  self.stage_day = 0
  self.stage_quest = {}
  self.stage_get_score = {}
  self.stage_des = ""
  self.stage_gift_group = 0
end

local function __delete(self)
  self.id = 0
  self.stage = 0
  self.stage_day = 0
  self.stage_quest = {}
  self.stage_get_score = {}
  self.stage_des = ""
  self.stage_gift_group = 0
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.stage = tonumber(row:getValue("stage")) or 0
  self.stage_day = tonumber(row:getValue("day")) or 0
  self.stage_quest = row:getValue("stage_quest") or {}
  self.stage_get_score = row:getValue("stage_get_score") or {}
  self.stage_des = row:getValue("stage_des") or ""
  self.stage_gift_group = row:getValue("stage_gift_group") or {}
end

local function GetQuests(self)
  return DeepCopy(self.stage_quest)
end

local function GetScoreMethods(self)
  return DeepCopy(self.stage_get_score)
end

local function GetStageGiftPackGroupId(self)
  return DeepCopy(self.stage_gift_group)
end

ActivityStageTemplate.__init = __init
ActivityStageTemplate.__delete = __delete
ActivityStageTemplate.InitData = InitData
ActivityStageTemplate.GetQuests = GetQuests
ActivityStageTemplate.GetScoreMethods = GetScoreMethods
ActivityStageTemplate.GetStageGiftPackGroupId = GetStageGiftPackGroupId
return ActivityStageTemplate
