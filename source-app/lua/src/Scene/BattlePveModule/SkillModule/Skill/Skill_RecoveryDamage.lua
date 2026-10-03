local base = require("Scene.BattlePveModule.SkillModule.Skill.SkillBase")
local Skill_RecoveryDamage = BaseClass("Skill_RecoveryDamage", base)
local Const = require("Scene.BattlePveModule.Const")

function Skill_RecoveryDamage:DoAttack(actionItem, callback, maxTime)
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
  local atkValue = actionItem:GetValue().value
  local ratio = PveActorMgr:GetInstance():GetHp2PowerRatio(_defCampType)
  atkValue = atkValue * ratio
  atkValue = Mathf.Floor(atkValue)
  local _hitInfo = self:_CalculateTargetHit(_defCampType, atkValue)
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  local _targetModelList = _defCampType == Const.CampType.Player and _modelMgr:GetModelListByCamp(Const.CampType.Player) or _modelMgr:GetModelListByCamp(Const.CampType.Target)
  if PveActorMgr:GetInstance():IsStopPlay() then
    for index, value in pairs(_hitInfo) do
      local modelObj = _targetModelList[tonumber(index)]
      if modelObj ~= nil then
        modelObj:RecvHit(value)
      end
    end
    self:DoCallback()
    return
  end
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
        for index, value in pairs(_hitInfo) do
          local modelObj = _targetModelList[tonumber(index)]
          if modelObj ~= nil then
            modelObj:RecvHit(value)
            modelObj:PlayEffectAddHp()
          end
        end
        self:DoCallback()
      end, 4 * PveActorMgr:GetInstance():GetSpeed())
    else
      TimerManager:GetInstance():DelayInvoke(function()
        for index, value in pairs(_hitInfo) do
          local modelObj = _targetModelList[tonumber(index)]
          if modelObj ~= nil then
            modelObj:RecvHit(value)
            modelObj:PlayEffectAddHp()
          end
        end
        self:DoCallback()
      end, 2 * PveActorMgr:GetInstance():GetSpeed())
      TimerManager:GetInstance():DelayInvoke(function()
        PveActorMgr:GetInstance():HideSHeroLevelSkill()
      end, delayFinishTime * PveActorMgr:GetInstance():GetSpeed())
    end
  else
    for index, value in pairs(_hitInfo) do
      local modelObj = _targetModelList[tonumber(index)]
      if modelObj ~= nil then
        modelObj:RecvHit(value)
        modelObj:PlayEffectAddHp()
      end
    end
    self:DoCallback()
  end
end

local tabRank = {-1, 1}

function Skill_RecoveryDamage:_CalculateTargetHit(defSide, addValue)
  addValue = Mathf.Abs(addValue)
  local _tabHit = {}
  local _aliveCnt = 0
  local _totalAddHp = 0
  local _tmpTabAddHp = {}
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  local _targetModelList = defSide == Const.CampType.Player and _modelMgr:GetModelListByCamp(Const.CampType.Player) or _modelMgr:GetModelListByCamp(Const.CampType.Target)
  _aliveCnt = table.count(_targetModelList)
  local _index_tmp1 = 1
  local ratio = 1 / _aliveCnt
  ratio = Mathf.DecimalFormat(ratio)
  for index, modelObj in pairs(_targetModelList) do
    if _index_tmp1 == _aliveCnt then
      _tmpTabAddHp[tostring(index)] = addValue - _totalAddHp
    else
      local _addHp = Mathf.Floor(addValue * ratio)
      _tmpTabAddHp[tostring(index)] = _addHp
      _totalAddHp = _totalAddHp + _addHp
      _index_tmp1 = _index_tmp1 + 1
    end
  end
  local _targetHp = {}
  local _targetMaxHp = {}
  for index, model in pairs(_targetModelList) do
    _targetHp[tostring(index)] = model:GetCurHp()
    _targetMaxHp[tostring(index)] = model:GetMaxHp()
  end
  local _targetHp_clone = DeepCopy(_targetHp)
  for index, value in pairs(_tmpTabAddHp) do
    local leftvalue = value
    for i = 0, 4 do
      if i == 0 then
        local modelLeftHp = _targetMaxHp[index] - _targetHp_clone[index]
        if leftvalue <= modelLeftHp then
          _targetHp_clone[index] = _targetHp_clone[index] + leftvalue
          leftvalue = 0
          break
        else
          leftvalue = leftvalue - (_targetMaxHp[index] - _targetHp_clone[index])
          _targetHp_clone[index] = _targetMaxHp[index]
        end
      else
        local tabRankCnt = table.count(tabRank)
        for j = 1, tabRankCnt do
          local newIndex = tostring(tonumber(index) + tabRank[j] * i)
          local modelHp = _targetHp_clone[newIndex]
          if modelHp ~= nil and 0 < modelHp then
            if leftvalue <= modelHp then
              _targetHp_clone[newIndex] = _targetHp_clone[newIndex] + leftvalue
              leftvalue = 0
              goto lbl_154
            else
              leftvalue = leftvalue - (_targetMaxHp[newIndex] - _targetHp_clone[newIndex])
              _targetHp_clone[newIndex] = _targetMaxHp[newIndex]
            end
          end
        end
      end
    end
    ::lbl_154::
  end
  for k, v in pairs(_targetHp) do
    _tabHit[k] = _targetHp_clone[k] - v
  end
  return _tabHit
end

return Skill_RecoveryDamage
