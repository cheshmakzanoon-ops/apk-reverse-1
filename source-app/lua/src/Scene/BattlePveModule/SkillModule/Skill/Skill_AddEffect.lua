local base = require("Scene.BattlePveModule.SkillModule.Skill.SkillBase")
local Skill_AddEffect = BaseClass("Skill_AddEffect", base)
local Localization = CS.GameEntry.Localization
local Const = require("Scene.BattlePveModule.Const")
local Resource = CS.GameEntry.Resource
local UnityImage = typeof(CS.UnityEngine.UI.Image)

function Skill_AddEffect:DoAttack(actionItem, callback, maxTime)
  base.DoAttack(self, actionItem, callback)
  local _atkIdx = actionItem:GetTriggerIndex()
  local _atkModelObj = PveActorMgr:GetInstance():GetModelMgr():GetModelObjByTriggerIndex(_atkIdx)
  local _atkCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_atkIdx)
  local _defIdx = actionItem:GetTargetIndex()
  local _defModelObj = PveActorMgr:GetInstance():GetModelMgr():GetModelObjByTriggerIndex(_defIdx)
  local _defCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_defIdx)
  if _atkModelObj == nil and _defModelObj == nil then
    self:DoCallback()
    return
  end
  if PveActorMgr:GetInstance():IsStopPlay() then
    self:DoCallback()
    return
  end
  self.m_atkModelObj = _atkModelObj
  if PveActorMgr:GetInstance():IsStopPlay() then
    self:DoCallback()
    return
  end
  local _modelMgr = PveActorMgr:GetInstance():GetModelMgr()
  local isAdd = _atkIdx == _defIdx
  local status = actionItem._actionData.value or 0
  local buffLevel = actionItem._actionData.skillLevel or 1
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
        if isAdd == true then
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_buff, false)
        else
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_debuff, false)
        end
        for _, modelObj in pairs(_targetModelList) do
          if not modelObj:IsDead() then
            if isAdd == true then
              modelObj:PlayEffectUpgrade()
            else
              modelObj:PlayEffectDeBuff()
            end
          end
        end
        if status ~= 0 then
          local statusStr = tostring(status) .. "|" .. tostring(buffLevel)
          if _defCampType == Const.CampType.Player then
            EventManager:GetInstance():Broadcast(EventId.PVEBattleShowLeftBuff, statusStr)
          else
            EventManager:GetInstance():Broadcast(EventId.PVEBattleShowRightBuff, statusStr)
          end
        end
        self:DoNext()
      end, 4 * PveActorMgr:GetInstance():GetSpeed())
    else
      TimerManager:GetInstance():DelayInvoke(function()
        PveActorMgr:GetInstance():HideSHeroLevelSkill()
        if isAdd == true then
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_buff, false)
        else
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_debuff, false)
        end
        for _, modelObj in pairs(_targetModelList) do
          if not modelObj:IsDead() then
            if isAdd == true then
              modelObj:PlayEffectUpgrade()
            else
              modelObj:PlayEffectDeBuff()
            end
          end
        end
        if status ~= 0 then
          local statusStr = tostring(status) .. "|" .. tostring(buffLevel)
          if _defCampType == Const.CampType.Player then
            EventManager:GetInstance():Broadcast(EventId.PVEBattleShowLeftBuff, statusStr)
          else
            EventManager:GetInstance():Broadcast(EventId.PVEBattleShowRightBuff, statusStr)
          end
        end
        self:DoCallback()
      end, delayFinishTime * PveActorMgr:GetInstance():GetSpeed())
    end
  else
    if isAdd == true then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_buff, false)
    else
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_debuff, false)
    end
    for _, modelObj in pairs(_targetModelList) do
      if not modelObj:IsDead() then
        if isAdd == true then
          modelObj:PlayEffectUpgrade()
        else
          modelObj:PlayEffectDeBuff()
        end
      end
    end
    if status ~= 0 then
      local statusStr = tostring(status) .. "|" .. tostring(buffLevel)
      if _defCampType == Const.CampType.Player then
        EventManager:GetInstance():Broadcast(EventId.PVEBattleShowLeftBuff, statusStr)
      else
        EventManager:GetInstance():Broadcast(EventId.PVEBattleShowRightBuff, statusStr)
      end
    end
    self:DoNext()
  end
end

function Skill_AddEffect:GetDesc_AddEffect()
  local skillId = self.m_actionItem._actionData.skillId or 0
  local skillIdName = GetTableData(TableName.SkillTab, skillId, "name")
  local skillName = Localization:GetString(skillIdName)
  if skillIdName == "" then
    skillName = skillName .. "-skillId:" .. tostring(skillId)
  end
  local status = self.m_actionItem._actionData.value or 0
  local effectArr = GetTableData(TableName.StatusTab, status, "effect") or ""
  effectArr = string.split(effectArr, "|") or {}
  local effectNumArr = GetTableData(TableName.StatusTab, status, "effect_num") or ""
  effectNumArr = string.split(effectNumArr, "|") or {}
  local skillLevel = self.m_actionItem._actionData.skillLevel or 1
  local effectName = ""
  local effectValue = ""
  local effectArrCnt = table.count(effectArr)
  local effectNumArrCnt = table.count(effectNumArr)
  if effectArrCnt == effectNumArrCnt and skillLevel <= effectArrCnt then
    local effectId = effectArr[skillLevel]
    effectName = GetTableData(TableName.EffectNumDesc, effectId, "des")
    effectName = Localization:GetString(effectName)
    local effectType = GetTableData(TableName.EffectNumDesc, effectId, "type")
    if effectType == "1" then
      effectValue = effectNumArr[skillLevel] .. "%"
    else
      effectValue = effectNumArr[skillLevel]
    end
  end
  local str = effectName .. effectValue
  return str
end

function Skill_AddEffect:AddSkillIcon(modelObj)
  local status = self.m_actionItem._actionData.value or 0
  local e_path = "Assets/Main/Prefabs/PVE/UI/VFX_pve_zengyitubiao.prefab"
  local _skillIcon = Resource:InstantiateAsync(e_path)
  _skillIcon:completed("+", function(req)
    TimerManager:GetInstance():DelayInvoke(function()
      if _skillIcon ~= nil then
        _skillIcon:Destroy()
      end
    end, 1.5 * PveActorMgr:GetInstance():GetSpeed())
    local _go = req.gameObject
    if _go == nil then
      return
    end
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Normal.Name).gameObject
    _go.transform:SetParent(CanvasNormal.transform)
    local _modelPos = modelObj:GetTransform().position + Vector3.New(0, 0.55, 0)
    local mainCamera = CS.UnityEngine.Camera.main
    local _screenPos = mainCamera:WorldToScreenPoint(_modelPos)
    _go.transform.position = Vector3.New(_screenPos.x, _screenPos.y, 0)
    _go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local _skillIconObj = _go.transform:Find("roto_anim/career"):GetComponent(UnityImage)
    if _skillIconObj == nil then
      return
    end
    local skill_icon_str = GetTableData(TableName.StatusTab, status, "icon") or ""
    local skill_icon = ""
    if skill_icon_str ~= nil and skill_icon_str ~= "" then
      local arr = string.split(skill_icon_str, "|")
      if 1 <= #arr then
        skill_icon = arr[1]
      end
    end
    if skill_icon == nil or skill_icon == "" then
      skill_icon = "skill_icon_add_atk"
    end
    _skillIconObj:LoadSprite(LoadPath.SkillIconsPath .. skill_icon)
  end)
end

return Skill_AddEffect
