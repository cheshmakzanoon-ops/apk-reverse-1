local AddSkillTriggerEvent = BaseClass("AddSkillTriggerEvent")
local AddKillEffect = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_animal_grow_big.prefab"

function AddSkillTriggerEvent:__init()
end

function AddSkillTriggerEvent:__delete()
end

function AddSkillTriggerEvent:Execute(param)
  local rand = {}
  local heros = DataCenter.LWBattleManager.logic.team.teamUnits
  local gain_effect = param.gain_effect
  for _, hero in pairs(heros) do
    table.insert(rand, hero)
  end
  if 0 < #rand then
    local tar = rand[math.random(#rand)]
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(param.para)
    if skillMeta == nil then
      Logger.LogError("\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. param.para)
    end
    tar.skillManager:AddSkill(skillMeta)
    if not string.IsNullOrEmpty(gain_effect) then
      DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, tar.transform)
    end
  end
end

return AddSkillTriggerEvent
