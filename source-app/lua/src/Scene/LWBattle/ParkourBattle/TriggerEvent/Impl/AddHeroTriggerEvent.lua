local AddHeroTriggerEvent = BaseClass("AddHeroTriggerEvent")
local AddHeroEffect = "VFX_xishou_gaotouchuxian_jiangli"

function AddHeroTriggerEvent:__init()
end

function AddHeroTriggerEvent:__delete()
end

function AddHeroTriggerEvent:Execute(param, extra, sourceId)
  local spl = string.split(param.para, "|")
  local heros = {}
  for _, value in ipairs(spl) do
    table.insert(heros, tonumber(value))
  end
  local level = tonumber(extra) or 1
  if DataCenter.LWBattleManager.logic.AddMember then
    local addCount = 0
    local cheatHeroIds = {}
    local bornEffectPath = param.gain_effect
    for _, heroId in ipairs(heros) do
      DataCenter.LWBattleManager.logic:AddMember(heroId, level, true, bornEffectPath)
      addCount = addCount + 1
      table.insert(cheatHeroIds, heroId + 2)
    end
    if DataCenter.LWBattleManager.logic.detailLog and DataCenter.LWBattleManager.logic.GetMemberCount then
      local memberCount = DataCenter.LWBattleManager.logic:GetMemberCount()
      Logger.LogInfo("parkour AddHeroTriggerEvent metaId : " .. param.id .. ". addCount : " .. addCount .. ". memberCount : " .. memberCount)
    end
    if DataCenter.LWBattleManager.logic.TryCheatTriggerItem then
      DataCenter.LWBattleManager.logic:TryCheatTriggerItem(param.id, cheatHeroIds, sourceId)
    end
  end
end

return AddHeroTriggerEvent
