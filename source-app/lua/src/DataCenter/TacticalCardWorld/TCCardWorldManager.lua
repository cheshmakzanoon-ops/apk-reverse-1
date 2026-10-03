local Squad = require("Scene.LWWorldMarch.Squad")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local TCEffectObjManager = require("DataCenter.TacticalCardWorld.TCEffectObjManager")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local Localization = CS.GameEntry.Localization
local Cast_Skill_Tip_Effect_Path = "Assets/_Art_LastWar/Effect/Prefab/RiChang/TacticalCard/Eff_s_TacticalCardTip.prefab"
local TCCardWorldManager = BaseClass("TCCardWorldManager", CEventable)

function TCCardWorldManager:__init()
  self:RegisterEvent(EventId.OnEnterWorld, self.OnEnterWorld)
  self:RegisterEvent(EventId.OnEnterCity, self.OnExitWorld)
end

function TCCardWorldManager:__delete()
  self:UnregisterEvent(EventId.OnEnterWorld, self.OnEnterWorld)
  self:UnregisterEvent(EventId.OnEnterCity, self.OnExitWorld)
  self:Destroy()
end

function TCCardWorldManager:Destroy()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
    self.effectObjMgr = nil
  end
  self.isInWorld = false
end

function TCCardWorldManager:Startup()
end

function TCCardWorldManager.OnEnterWorld()
  local self = DataCenter.TCCardWorldManager
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self.effectObjMgr = TCEffectObjManager.New(self)
  self.isInWorld = true
end

function TCCardWorldManager.OnExitWorld()
  local self = DataCenter.TCCardWorldManager
  self:Destroy()
  self.isInWorld = false
end

function TCCardWorldManager:OnUpdate()
  if self.effectObjMgr then
    self.effectObjMgr:OnUpdate()
  end
end

function TCCardWorldManager:ShowEffectObj(path, pos, rot, time, parent, callback)
  if self.effectObjMgr then
    return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, nil, callback)
  end
end

function TCCardWorldManager:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function TCCardWorldManager:OnHandleCastSkillOnWorld(cardId, pointId, skillId, serverId)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if not self:IsNeedShowCastSkillOnWorld() then
    return
  end
  self:ShowCastSkillTip(cardId, pointId, serverId)
  self:ShowSkillCastEffect(skillId, pointId, serverId)
end

function TCCardWorldManager:IsNeedShowCastSkillOnWorld()
  local lod = DisplaySettings.currentLod
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  local lodLimit = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k18", 2)
  return lod <= lodLimit and 0 <= displayLv
end

function TCCardWorldManager:ShowCastSkillTip(cardId, pointId, serverId)
  local cardTmp = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTmp then
    return
  end
  local cardName = Localization:GetString(cardTmp.name)
  if not cardName then
    return
  end
  local genEffWorldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
  local genParent = CS.SceneManager.World.DynamicObjNode
  self:ShowEffectObj(Cast_Skill_Tip_Effect_Path, genEffWorldPos, nil, 1, genParent, function(effectObj)
    local unity_txt_ex = effectObj.transform:Find("bg/Root/Text"):GetComponent(typeof(CS.TextMeshProEx))
    if unity_txt_ex then
      unity_txt_ex.text = cardName
    end
  end)
end

function TCCardWorldManager:ShowSkillCastEffect(skillId, pointId, serverId)
  local skillCfg = DataCenter.TacticalCardDataManager:GetSkillTemplateData(skillId)
  if not skillCfg then
    return
  end
  local castEffPath = skillCfg.active_special_effect
  if not castEffPath then
    return
  end
  local genEffWorldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
  local genParent = CS.SceneManager.World.DynamicObjNode
  self:ShowEffectObj(castEffPath, genEffWorldPos, nil, 3, genParent)
end

return TCCardWorldManager
