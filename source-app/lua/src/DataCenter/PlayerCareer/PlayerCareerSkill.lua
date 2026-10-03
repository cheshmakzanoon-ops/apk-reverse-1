local PlayerCareerSkill = BaseClass("PlayerCareerSkill")

local function __init(self, id, time, cdTime, type)
  self.id = id or 0
  self.time = time or 0
  self.cdTime = cdTime or 0
  self.type = type or CareerSkillType.Unknown
end

local function __delete(self)
  self.id = nil
  self.time = nil
  self.cdTime = nil
  self.type = nil
end

local function ParseData(self, data)
  self.id = data.skillId
  self.time = data.time
  self.cdTime = data.cdTime
  for type, idList in pairs(CareerSkillTypeToIdList) do
    for _, id in ipairs(idList) do
      if self.id == id then
        self.type = type
        goto lbl_24
      end
    end
  end
  ::lbl_24::
end

PlayerCareerSkill.__init = __init
PlayerCareerSkill.__delete = __delete
PlayerCareerSkill.ParseData = ParseData
return PlayerCareerSkill
