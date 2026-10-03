local base = require("Scene.BattlePveModule.SkillModule.Skill.SkillBase")
local Skill_NormalAttack = BaseClass("Skill_NormalAttack", base)
local Resource = CS.GameEntry.Resource
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local Const = require("Scene.BattlePveModule.Const")

function Skill_NormalAttack:DoAttack(actionItem, callback, maxTime)
  base.DoAttack(self, actionItem, callback)
  local _atkIdx = actionItem:GetTriggerIndex()
  local _atkCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_atkIdx)
  local _atkModelObj = PveActorMgr:GetInstance():GetModelMgr():GetModelObjByHeroId(_atkCampType, actionItem:GetHeroId())
  local _defIdx = actionItem:GetTargetIndex()
  local _defCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_defIdx)
  if _atkModelObj == nil then
    self:DoCallback()
    return
  end
  self.m_atkModelObj = _atkModelObj
  local atkValue = self.m_actionItem:GetValue().value
  local ratio = PveActorMgr:GetInstance():GetHp2PowerRatio(_defCampType)
  atkValue = atkValue * ratio
  atkValue = Mathf.Floor(atkValue)
  local _hitInfo = self:_CalculateTargetHit(_defCampType, atkValue)
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  local _targetModelList = _defCampType == Const.CampType.Player and _modelMgr:GetModelListByCamp(Const.CampType.Player) or _modelMgr:GetModelListByCamp(Const.CampType.Target)
  if PveActorMgr:GetInstance():IsStopPlay() then
    for index, value in pairs(_hitInfo) do
      local modelObj = _targetModelList[tonumber(index)]
      modelObj:RecvHit(value)
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
        for index, value in pairs(_hitInfo) do
          local modelObj = _targetModelList[tonumber(index)]
          modelObj:RecvHit(value)
        end
      end, 3.5 * PveActorMgr:GetInstance():GetSpeed())
      TimerManager:GetInstance():DelayInvoke(function()
        PveActorMgr:GetInstance():HideSHeroLevelSkill()
        self:DoCallback()
      end, 4 * PveActorMgr:GetInstance():GetSpeed())
    else
      TimerManager:GetInstance():DelayInvoke(function()
        PveActorMgr:GetInstance():HideSHeroLevelSkill()
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_gunAttack, false)
        for index, value in pairs(_hitInfo) do
          local modelObj = _targetModelList[tonumber(index)]
          self:ShowZhunxing(modelObj)
          TimerManager:GetInstance():DelayInvoke(function()
            self:ShowBaozha(modelObj, function()
              self:ShowHitEffect(modelObj, function()
                modelObj:RecvHit(value)
              end)
            end)
          end, 0.25 * PveActorMgr:GetInstance():GetSpeed())
        end
        self:DoCallback()
      end, delayFinishTime * PveActorMgr:GetInstance():GetSpeed())
    end
  else
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_gunAttack, false)
    for index, value in pairs(_hitInfo) do
      local modelObj = _targetModelList[tonumber(index)]
      self:ShowZhunxing(modelObj)
      TimerManager:GetInstance():DelayInvoke(function()
        self:ShowBaozha(modelObj, function()
          self:ShowHitEffect(modelObj, function()
            modelObj:RecvHit(value)
          end)
        end)
      end, 0.25 * PveActorMgr:GetInstance():GetSpeed())
    end
    self:DoCallback()
  end
end

function Skill_NormalAttack:ShowZhunxing(modelObj)
  local e_path = "Assets/Main/Prefabs/PVE/UI/VFX_gongji_miaozhun.prefab"
  local _zhunxing = Resource:InstantiateAsync(e_path)
  _zhunxing:completed("+", function(req)
    TimerManager:GetInstance():DelayInvoke(function()
      if _zhunxing ~= nil then
        _zhunxing:Destroy()
      end
      if callback ~= nil then
        callback()
      end
    end, 0.25 * PveActorMgr:GetInstance():GetSpeed())
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Normal.Name).gameObject
    _go.transform:SetParent(CanvasNormal.transform)
    local _modelPos = modelObj:GetTransform().position + Vector3.New(0, 0.45, 0)
    local mainCamera = CS.UnityEngine.Camera.main
    local _screenPos = mainCamera:WorldToScreenPoint(_modelPos)
    _go.transform.position = Vector3.New(_screenPos.x, _screenPos.y, 0)
    _go.transform:Set_localScale(ResetScale.x * 0.7, ResetScale.y * 0.7, ResetScale.z * 0.7)
  end)
end

function Skill_NormalAttack:ShowBaozha(modelObj, callback)
  local e_path = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_gongji_glow_ui.prefab"
  local _baozha = Resource:InstantiateAsync(e_path)
  _baozha:completed("+", function(req)
    TimerManager:GetInstance():DelayInvoke(function()
      if _baozha ~= nil then
        _baozha:Destroy()
      end
      if callback ~= nil then
        callback()
      end
    end, 0.7 * PveActorMgr:GetInstance():GetSpeed())
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Normal.Name).gameObject
    _go.transform:SetParent(CanvasNormal.transform)
    local _modelPos = modelObj:GetTransform().position + Vector3.New(0, 0.45, 0)
    local mainCamera = CS.UnityEngine.Camera.main
    local _screenPos = mainCamera:WorldToScreenPoint(_modelPos)
    _go.transform.position = Vector3.New(_screenPos.x, _screenPos.y, 0)
    _go.transform:Set_localScale(ResetScale.x * 0.5, ResetScale.y * 0.5, ResetScale.z * 0.5)
  end)
end

function Skill_NormalAttack:ShowHitEffect(modelObj, callback)
  local e_path = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_pve_q_jiaohu_guai_ui.prefab"
  local _req = Resource:InstantiateAsync(e_path)
  _req:completed("+", function(req)
    TimerManager:GetInstance():DelayInvoke(function()
      if _req ~= nil then
        _req:Destroy()
      end
    end, 1.0 * PveActorMgr:GetInstance():GetSpeed())
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Normal.Name).gameObject
    _go.transform:SetParent(CanvasNormal.transform)
    local _modelPos = modelObj:GetTransform().position + Vector3.New(0, 0.35, 0)
    local mainCamera = CS.UnityEngine.Camera.main
    local _screenPos = mainCamera:WorldToScreenPoint(_modelPos)
    _go.transform.position = Vector3.New(_screenPos.x, _screenPos.y, 0)
    _go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end)
  if callback ~= nil then
    callback()
  end
end

local tabRank = {-1, 1}

function Skill_NormalAttack:_CalculateTargetHit(defSide, damage)
  damage = Mathf.Abs(damage)
  local _tabHit = {}
  local _aliveCnt = 0
  local _totalDamage = 0
  local _atkHit = {}
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  local _targetModelList = defSide == Const.CampType.Player and _modelMgr:GetModelListByCamp(Const.CampType.Player) or _modelMgr:GetModelListByCamp(Const.CampType.Target)
  for _, modelObj in pairs(_targetModelList) do
    if not modelObj:IsDead() then
      _aliveCnt = _aliveCnt + 1
    end
  end
  local _index_tmp1 = 1
  local ratio = 1 / _aliveCnt
  Mathf.DecimalFormat(ratio)
  for index, modelObj in pairs(_targetModelList) do
    if not modelObj:IsDead() then
      if _index_tmp1 == _aliveCnt then
        _atkHit[tostring(index)] = damage - _totalDamage
      else
        local _damage = Mathf.Floor(damage * ratio)
        _atkHit[tostring(index)] = _damage
        _totalDamage = _totalDamage + _damage
        _index_tmp1 = _index_tmp1 + 1
      end
    end
  end
  local _targetHp = {}
  for index, model in pairs(_targetModelList) do
    if not model:IsDead() then
      _targetHp[tostring(index)] = model:GetCurHp()
    end
  end
  local _targetHp_clone = DeepCopy(_targetHp)
  for index, value in pairs(_atkHit) do
    local leftvalue = value
    for i = 0, 4 do
      if i == 0 then
        local modelHp = _targetHp_clone[index]
        if modelHp ~= nil and 0 < modelHp then
          if leftvalue <= modelHp then
            _targetHp_clone[index] = _targetHp_clone[index] - leftvalue
            leftvalue = 0
            break
          else
            leftvalue = leftvalue - _targetHp_clone[index]
            _targetHp_clone[index] = 0
          end
        end
      else
        local tabRankCnt = table.count(tabRank)
        for j = 1, tabRankCnt do
          local newIndex = tostring(tonumber(index) + tabRank[j] * i)
          local modelHp = _targetHp_clone[newIndex]
          if modelHp ~= nil and 0 < modelHp then
            if leftvalue <= modelHp then
              _targetHp_clone[newIndex] = _targetHp_clone[newIndex] - leftvalue
              leftvalue = 0
              goto lbl_156
            else
              leftvalue = leftvalue - _targetHp_clone[newIndex]
              _targetHp_clone[newIndex] = 0
            end
          end
        end
      end
    end
    ::lbl_156::
  end
  for k, v in pairs(_targetHp) do
    _tabHit[k] = _targetHp_clone[k] - v
  end
  return _tabHit
end

return Skill_NormalAttack
