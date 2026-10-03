local PveSkillMgr = BaseClass("PveSkillMgr")
local Const = require("Scene.BattlePveModule.Const")
local DefaultSkill = require("Scene.BattlePveModule.SkillModule.Skill.SkillBase")
local Skill_NormalAttack = require("Scene.BattlePveModule.SkillModule.Skill.Skill_NormalAttack")
local Skill_CounterAttack = require("Scene.BattlePveModule.SkillModule.Skill.Skill_CounterAttack")
local Skill_ShieldAttack = require("Scene.BattlePveModule.SkillModule.Skill.Skill_ShieldAttack")
local Skill_Shield = require("Scene.BattlePveModule.SkillModule.Skill.Skill_Shield")
local Skill_RecoveryDamage = require("Scene.BattlePveModule.SkillModule.Skill.Skill_RecoveryDamage")
local Skill_AddEffect = require("Scene.BattlePveModule.SkillModule.Skill.Skill_AddEffect")
local Skill_UseSkill = require("Scene.BattlePveModule.SkillModule.Skill.Skill_UseSkill")
local Skill_AddAnger = require("Scene.BattlePveModule.SkillModule.Skill.Skill_AddAnger")

function PveSkillMgr:__init()
end

function PveSkillMgr:DoAttack(actionItem, callback, maxTime)
  local _defIdx = actionItem:GetTargetIndex()
  local _targetModelList = _defIdx == Const.CampType.Player and PveActorMgr:GetInstance():GetModelListByCamp(Const.CampType.Player) or PveActorMgr:GetInstance():GetModelListByCamp(Const.CampType.Target)
  if _targetModelList == nil then
    if callback ~= nil then
      callback()
    end
    return
  else
    local isNotDead = false
    for _, modelObj in pairs(_targetModelList) do
      if not modelObj:IsDead() then
        isNotDead = true
      end
    end
    if isNotDead == false then
      if callback ~= nil then
        callback()
      end
      return
    end
  end
  local actionType = actionItem:GetActionItemType()
  local _skill
  if actionType == eMailDetailActionType.USE_SKILL then
    _skill = Skill_UseSkill.New()
  else
    self:DoBuff(actionItem, callback, maxTime)
    return
  end
  _skill:DoAttack(actionItem, callback, maxTime)
end

function PveSkillMgr:DoBuff(actionItem, callback, maxTime)
  local actionType = actionItem:GetActionItemType()
  local _skill
  if actionType == eMailDetailActionType.SHIELD_ATTACK then
    _skill = Skill_ShieldAttack.New()
  elseif actionType == eMailDetailActionType.SHIELD then
    _skill = Skill_Shield.New()
  elseif actionType == eMailDetailActionType.RECOVER_DAMAGE then
    _skill = Skill_RecoveryDamage.New()
  elseif actionType == eMailDetailActionType.ADD_EFFECT then
    _skill = Skill_AddEffect.New()
  elseif actionType == eMailDetailActionType.ADD_ANGER then
    _skill = Skill_AddAnger.New()
  elseif actionType == eMailDetailActionType.ATTACK then
    _skill = Skill_NormalAttack.New()
  else
    print("\230\178\161\230\156\137\232\175\165\231\177\187\229\158\139")
    return
  end
  _skill:DoAttack(actionItem, callback, maxTime)
end

return PveSkillMgr
