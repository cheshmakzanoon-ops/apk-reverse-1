local SkillInfo = require("DataCenter/HeroData/SkillInfo")
local base = SkillInfo
local DominatorSkillInfo = BaseClass("DominatorSkillInfo", base)
local Localization = CS.GameEntry.Localization

function DominatorSkillInfo:__init()
  base.__init(self)
  self.dominatorUuid = 0
end

function DominatorSkillInfo:__delete()
  self.dominatorUuid = nil
  base.__delete(self)
end

function DominatorSkillInfo:UpdateSkillInfo(message)
  base.UpdateSkillInfo(self, message)
  if message.dominatorUuid ~= nil then
    self.dominatorUuid = message.dominatorUuid
  end
end

function DominatorSkillInfo:GetEffectsDesc()
  if not self.skillTemplateData then
    return {}
  end
  if self.cachedEffectsDesc == nil then
    local enhanceEffects = self.skillTemplateData:GetSortedEnhanceDescKeys()
    local effects = {}
    for __, v in pairs(enhanceEffects) do
      local param = {}
      param.desc = v.effect
      param.unlockStar = v.star
      table.insert(effects, param)
    end
    self.cachedEffectsDesc = effects
  end
  local rankGroup = 0
  local info = DataCenter.DominatorManager:GetInfoByUuid(self.dominatorUuid)
  if info then
    local rankTemplate = info:GetCurRankTemplate()
    if rankTemplate then
      rankGroup = rankTemplate.group
    end
  end
  for __, effect in pairs(self.cachedEffectsDesc) do
    if effect.unlockStar <= self:GetStar() then
      effect.isUnlock = true
      effect.outDesc = effect.desc
    else
      effect.isUnlock = false
      local star = effect.unlockStar
      local rank = DataCenter.HeroSkillTemplateManager:GetNeedRankByStar(self:GetGroupId(), star)
      effect.outDesc = Localization:GetString("dominator_skill_lock_desc_1", rank)
      effect.outDesc = string.format("%s <color=#F97077>%s</color>", effect.desc, effect.outDesc)
    end
  end
  return self.cachedEffectsDesc
end

return DominatorSkillInfo
