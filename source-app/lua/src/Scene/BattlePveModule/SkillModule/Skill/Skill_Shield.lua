local base = require("Scene.BattlePveModule.SkillModule.Skill.SkillBase")
local Skill_Shield = BaseClass("Skill_Shield", base)
local Const = require("Scene.BattlePveModule.Const")

function Skill_Shield:DoAttack(actionItem, callback, maxTime)
  base.DoAttack(self, actionItem, callback)
  local _atkIdx = actionItem:GetTriggerIndex()
  local _atkModelObj = PveActorMgr:GetInstance():GetModelMgr():GetModelObjByTriggerIndex(_atkIdx)
  local _atkCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_atkIdx)
  local _defIdx = actionItem:GetTargetIndex()
  local _defModelObj = PveActorMgr:GetInstance():GetModelMgr():GetModelObjByTriggerIndex(_defIdx)
  local _defCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_defIdx)
  if _atkModelObj == nil or _defModelObj == nil then
    self:DoCallback()
    return
  end
  if PveActorMgr:GetInstance():IsStopPlay() then
    self:DoCallback()
    return
  end
  local time = 1
  if actionItem._actionData ~= nil and actionItem._actionData.param ~= nil then
    time = actionItem._actionData.param
  end
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  local _targetModelList = _defCampType == Const.CampType.Player and _modelMgr:GetModelListByCamp(Const.CampType.Player) or _modelMgr:GetModelListByCamp(Const.CampType.Target)
  local heroId = actionItem:GetHeroId()
  local skillId = actionItem._actionData.skillId or 0
  local rarity = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "rarity")
  local effectName = GetTableData(TableName.SkillTab, skillId, "skill_anim")
  local delayFinishTime = 2
  if maxTime ~= nil then
    delayFinishTime = maxTime
  end
  if LuaEntry.DataConfig:CheckSwitch("s_skill") and rarity == 1 then
    if effectName ~= nil and effectName ~= "" then
      PveActorMgr:GetInstance():ShowSHeroLevelSkill(heroId, skillId, _atkCampType == Const.CampType.Target)
      TimerManager:GetInstance():DelayInvoke(function()
        PveActorMgr:GetInstance():HideSHeroLevelSkill()
        for _, modelObj in pairs(_targetModelList) do
          if not modelObj:IsDead() then
            modelObj:ShowShield(time)
          end
        end
        self:DoCallback()
      end, 4 * PveActorMgr:GetInstance():GetSpeed())
    else
      TimerManager:GetInstance():DelayInvoke(function()
        for _, modelObj in pairs(_targetModelList) do
          if not modelObj:IsDead() then
            modelObj:ShowShield(time)
          end
        end
        self:DoCallback()
      end, 2 * PveActorMgr:GetInstance():GetSpeed())
      TimerManager:GetInstance():DelayInvoke(function()
        PveActorMgr:GetInstance():HideSHeroLevelSkill()
      end, delayFinishTime * PveActorMgr:GetInstance():GetSpeed())
    end
  else
    for _, modelObj in pairs(_targetModelList) do
      if not modelObj:IsDead() then
        modelObj:ShowShield(time)
      end
    end
    self:DoCallback()
  end
end

return Skill_Shield
