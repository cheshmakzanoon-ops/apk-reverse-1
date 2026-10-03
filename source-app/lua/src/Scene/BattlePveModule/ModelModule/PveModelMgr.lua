local Const = require("Scene.BattlePveModule.Const")
local PveHeroModelMgr = BaseClass("PveHeroModelMgr")
local ModelObject = require("Scene.BattlePveModule.ModelModule.ModelObject")

function PveHeroModelMgr:__init()
  self.m_modelList = {}
  self.soundNum = 0
end

function PveHeroModelMgr:AddToModelList(modelType, model)
  if self.m_modelList[modelType] == nil then
    self.m_modelList[modelType] = {}
  end
  self.m_modelList[modelType][#self.m_modelList[modelType] + 1] = model
end

function PveHeroModelMgr:PlayUpgradeEffect()
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:PlayEffectUpgrade()
    end
  end
end

function PveHeroModelMgr:CreateModel(modelType, standIndex, heroId, power, heroLv, quality, rarity, targetLv)
  local obj = ModelObject.New(modelType, standIndex, heroId, power, heroLv, quality, rarity, targetLv)
  if obj == nil then
    print("PVE\229\136\155\229\187\186\232\139\177\233\155\132\230\168\161\229\158\139\229\164\177\232\180\165")
    return
  end
  self:AddToModelList(modelType, obj)
end

function PveHeroModelMgr:GetCreateModelOK()
  local isOk = false
  local _p_list = self.m_modelList[Const.CampType.Player]
  local _t_list = self.m_modelList[Const.CampType.Target]
  if _p_list ~= nil and _t_list ~= nil then
    for k, v in pairs(_p_list) do
      if v == nil or v:IsCreateFinish() == false then
        return false
      end
    end
    for k, v in pairs(_t_list) do
      if v == nil or v:IsCreateFinish() == false then
        return false
      end
    end
    isOk = true
  end
  return isOk
end

function PveHeroModelMgr:Destroy()
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:Destroy()
    end
  end
  self.soundNum = 0
  self.m_modelList = {}
end

function PveHeroModelMgr:HeroesBattleInit()
  for ctype, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:BattleInit()
    end
  end
end

function PveHeroModelMgr:SetBarForGuide()
  for ctype, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      if ctype == Const.CampType.Target and _ == 1 then
        v1:SetBarForGuide(true)
      else
        v1:SetBarForGuide()
      end
    end
  end
end

function PveHeroModelMgr:HideBarForGuide()
  for ctype, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:HideBarForGuide()
    end
  end
end

function PveHeroModelMgr:GetModelObjByTriggerIndex(index)
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      if v1:GetTriggerIndex() == index then
        return v1
      end
    end
  end
  return nil
end

function PveHeroModelMgr:RemoveModelObj(modelType, index)
  local hero_list = self.m_modelList[modelType] or {}
  local newList = {}
  for i = 1, #hero_list do
    local modelObj = hero_list[i]
    if index == i then
      if modelObj ~= nil then
        modelObj:Destroy()
      end
    else
      local idx = #newList + 1
      modelObj:UpdatePos(idx)
      newList[idx] = modelObj
    end
  end
  self.m_modelList[modelType] = newList
end

function PveHeroModelMgr:SetModelDetailReportPlayerInfo(s_list, t_list)
  if s_list == nil or t_list == nil then
    return
  end
  local _p_list = self.m_modelList[Const.CampType.Player] or {}
  for _, model in pairs(_p_list) do
    model:SetDetailReportPlayerInfo(s_list)
  end
  local _t_list = self.m_modelList[Const.CampType.Target] or {}
  for _, model in pairs(_t_list) do
    model:SetDetailReportPlayerInfo(t_list)
  end
end

function PveHeroModelMgr:SetModelArmyCombatUnit(s_list, t_list)
  if s_list == nil or t_list == nil then
    return
  end
  if table.count(s_list) ~= table.count(self.m_modelList[Const.CampType.Player]) or table.count(t_list) ~= table.count(self.m_modelList[Const.CampType.Target]) then
    Logger.LogError("[PVE] \232\175\166\231\187\134\230\136\152\230\138\165\228\184\173\228\186\186\231\137\169\229\175\185\229\186\148\228\184\141\228\184\138")
    return
  end
  for k, v in pairs(s_list) do
    self.m_modelList[Const.CampType.Player][k]:SetArmyCombatUnit(v)
  end
  for k, v in pairs(t_list) do
    self.m_modelList[Const.CampType.Target][k]:SetArmyCombatUnit(v)
  end
end

function PveHeroModelMgr:GetModelListByCamp(value)
  return self.m_modelList[value]
end

function PveHeroModelMgr:GetModelObjByHeroId(campType, heroId)
  local _modelList = self.m_modelList[campType] or {}
  for _, v in pairs(_modelList) do
    if v:GetHeroId() == heroId then
      return v
    end
  end
  return nil
end

function PveHeroModelMgr:DoAllBuff()
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:DoActionBuff()
    end
  end
end

function PveHeroModelMgr:PlayAllHeroesFireEffect()
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:PlayAttack()
    end
  end
  if PveActorMgr:GetInstance():GetSpeedOffset() == 4 then
    local num = self.soundNum % 2
    if num <= 0 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_self_attack_low, false)
    end
  else
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_self_attack_low, false)
  end
  self.soundNum = self.soundNum + 1
end

function PveHeroModelMgr:StopAllHeroesFireEffect()
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:PlayStopFire()
    end
  end
end

function PveHeroModelMgr:SetHeroHp(sTotalHp, tTotalHp)
  local function SetData(modelType, totalHp)
    local _pModel = self.m_modelList[modelType] or {}
    
    local _pTotalPower = 0
    for _, v in pairs(_pModel) do
      _pTotalPower = _pTotalPower + v:GetHeroPower()
    end
    local _totalHp = 0
    local _modelCnt = table.count(_pModel)
    for k, v in pairs(_pModel) do
      local hp = 0
      if k == _modelCnt then
        hp = totalHp - _totalHp
      else
        local ratio = v:GetHeroPower() / math.max(_pTotalPower, 1)
        ratio = Mathf.DecimalFormat(ratio)
        hp = Mathf.Floor(totalHp * ratio)
        _totalHp = _totalHp + hp
      end
      v:SetHeroHp(hp)
    end
  end
  
  SetData(Const.CampType.Player, sTotalHp)
  SetData(Const.CampType.Target, tTotalHp)
end

function PveHeroModelMgr:SetHeroHpFactor(modelType, maxHpPercent)
  local _pModel = self.m_modelList[modelType] or {}
  for _, v in pairs(_pModel) do
    v:SetHpFactor(maxHpPercent)
  end
end

function PveHeroModelMgr:SetHeroLv(heroId, heroLv)
  for _, v in pairs(self.m_modelList[Const.CampType.Player] or {}) do
    if v:GetHeroId() == heroId then
      v:SetHeroLv(heroLv)
    end
  end
end

return PveHeroModelMgr
