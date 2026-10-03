local HeroSkillPerformTemplate = BaseClass("HeroSkillPerformTemplate")

local function __init(self)
  self.id = 0
  self.skillId = 0
  self.monsterId = 0
  self.monster_rect = {0, 0}
  self.duration = 0
  self.monster_center = {0, 0}
  self.teamHeroId = 0
  self.additional_skill = nil
end

local function __delete(self)
  self.id = nil
  self.skillId = nil
  self.monsterId = nil
  self.monster_rect = nil
  self.duration = nil
  self.monster_center = nil
  self.teamHeroId = nil
  self.additional_skill = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.skillId = tonumber(row:getValue("skillid")) or 0
  self.monsterId = tonumber(row:getValue("monsterid")) or 0
  self.monster_rect = row:getValue("monster_rectangle") or {}
  self.duration = tonumber(row:getValue("duration")) or 0
  self.monster_center = row:getValue("monster_center") or {}
  self.teamHeroId = tonumber(row:getValue("teamheroid")) or 0
  local addtionalskill = row:getValue("addtionalskill")
  if not string.IsNullOrEmpty(addtionalskill) then
    self.additional_skill = {}
    local str = string.split(addtionalskill, ";")
    for i, v in pairs(str) do
      table.insert(self.additional_skill, tonumber(v) or 0)
    end
  end
end

function HeroSkillPerformTemplate:GetTeamMemberHeroData()
  if self.teamHeroId and self.teamHeroId > 0 then
    local teamMemberHeroData = HeroInfo.New()
    teamMemberHeroData:UpdateFromTemplate(self.teamHeroId)
    teamMemberHeroData.skillList = {}
    teamMemberHeroData.skillDict = {}
    return teamMemberHeroData
  end
  return nil
end

function HeroSkillPerformTemplate:GetAdditionalSkillInfoList()
  if table.IsNullOrEmpty(self.additional_skill) then
    return nil
  end
  local additionalSkillInfoList = {}
  for i, v in ipairs(self.additional_skill) do
    local skillInfo = SkillInfo.New()
    local skillInfoParam = {}
    skillInfoParam.skillId = v
    skillInfoParam.state = 1
    skillInfo:UpdateSkillInfo(skillInfoParam)
    local heroSkillTemplate = DeepCopy(skillInfo.skillTemplateData)
    skillInfo.skillTemplateData = heroSkillTemplate
    table.insert(additionalSkillInfoList, skillInfo)
  end
  return additionalSkillInfoList
end

HeroSkillPerformTemplate.__init = __init
HeroSkillPerformTemplate.__delete = __delete
HeroSkillPerformTemplate.InitData = InitData
return HeroSkillPerformTemplate
