local base = require("Scene.BattlePveModule.SkillModule.Skill.SkillBase")
local Skill_UseSkill = BaseClass("Skill_UseSkill", base)
local Const = require("Scene.BattlePveModule.Const")
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local Resource = CS.GameEntry.Resource

function Skill_UseSkill:DoAttack(actionItem, callback)
  base.DoAttack(self, actionItem, callback)
  local _skillTarget = actionItem:GetSkillTarget()
  if table.count(_skillTarget) == 0 then
    self:DoCallback()
    return
  end
  local _atkIdx = actionItem:GetTriggerIndex()
  local _atkCampType = PveActorMgr:GetInstance():GetCampTypeByTriggerIndex(_atkIdx)
  local _atkModelObj = PveActorMgr:GetInstance():GetModelMgr():GetModelObjByHeroId(_atkCampType, actionItem:GetHeroId())
  if _atkModelObj == nil then
    self:DoCallback()
    return
  end
  self.m_atkModelObj = _atkModelObj
  if PveActorMgr:GetInstance():IsStopPlay() then
    self:DoAttackToTarget()
    self:DoCallback()
    return
  end
  if PveActorMgr:GetInstance():IsFinalRound() and _atkModelObj:IsDead() then
    self:DoAttackToTarget()
    self:DoCallback()
    return
  end
  local heroId = actionItem:GetHeroId()
  local skillId = actionItem:GetSkillId()
  local rarity = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "rarity")
  local skill_pic = GetTableData(HeroUtils.GetHeroXmlName(), tonumber(heroId), "pve_skill_pic")
  local effectName = GetTableData(TableName.SkillTab, skillId, "skill_anim")
  local isSOpen = LuaEntry.DataConfig:CheckSwitch("s_skill")
  if isSOpen and rarity == 1 and skill_pic ~= nil and skill_pic ~= "" then
    self:AddSpecialSkill(_atkModelObj, function()
      if PveActorMgr:GetInstance():ShowUIPVEHeroAppear(heroId, skillId, _atkCampType == Const.CampType.Target) == true then
        local time = 2
        if effectName ~= nil and effectName ~= "" then
          time = 4
        end
        TimerManager:GetInstance():DelayInvoke(function()
          self:DoNext(true)
        end, time * PveActorMgr:GetInstance():GetSpeed())
        self:DoAttackToTarget()
        return
      else
        self:DoNext()
      end
    end)
  elseif isSOpen and rarity == 1 then
    self:AddSkillIcon(_atkModelObj, skillId, heroId)
    if effectName ~= nil and effectName ~= "" then
      TimerManager:GetInstance():DelayInvoke(function()
        self:DoNext(true)
      end, 5 * PveActorMgr:GetInstance():GetSpeed())
    else
      self:DoNext()
    end
  else
    self:AddSkillIcon(_atkModelObj, skillId, heroId)
    self:DoNext()
  end
end

function Skill_UseSkill:DoAttackToTarget()
  local _skillTarget = self.m_actionItem:GetSkillTarget()
  local maxTime = 0
  if LuaEntry.DataConfig:CheckSwitch("s_skill") then
    for _, v in pairs(_skillTarget) do
      if maxTime < 4 and v._actionData ~= nil then
        local skillId = v._actionData.skillId or 0
        local effectName = GetTableData(TableName.SkillTab, skillId, "skill_anim")
        if effectName ~= nil and effectName ~= "" then
          maxTime = 4
        end
      end
    end
  end
  for _, v in pairs(_skillTarget) do
    if 0 < maxTime then
      PveActorMgr:GetInstance():PlaySkillWithActionItem(v, maxTime)
    else
      PveActorMgr:GetInstance():PlaySkillWithActionItem(v)
    end
  end
end

function Skill_UseSkill:AddSkillIcon(modelObj, skillId, heroId)
  local e_path = "Assets/Main/Prefabs/PVE/UI/VFX_pve_zengyitubiao.prefab"
  local _skillIcon = Resource:InstantiateAsync(e_path)
  _skillIcon:completed("+", function(req)
    TimerManager:GetInstance():DelayInvoke(function()
      if _skillIcon ~= nil then
        _skillIcon:Destroy()
      end
      self:DoAttackToTarget()
    end, 1 * PveActorMgr:GetInstance():GetSpeed())
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
    local skill_icon = GetTableData(TableName.SkillTab, skillId, "icon")
    _skillIconObj:LoadSprite(LoadPath.SkillIconsPath .. skill_icon)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_skill, false)
  end)
end

function Skill_UseSkill:AddSpecialSkill(modelObj, func)
  if modelObj ~= nil then
    modelObj:PlayEffectUpgrade()
  end
  if func ~= nil then
    TimerManager:GetInstance():DelayInvoke(function()
      func()
    end, 0.5 * PveActorMgr:GetInstance():GetSpeed())
  end
end

return Skill_UseSkill
