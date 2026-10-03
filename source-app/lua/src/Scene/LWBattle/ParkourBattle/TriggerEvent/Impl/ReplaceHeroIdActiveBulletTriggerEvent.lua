local ReplaceHeroIdActiveBulletTriggerEvent = BaseClass("ReplaceHeroIdActiveBulletTriggerEvent")

function ReplaceHeroIdActiveBulletTriggerEvent:__init()
end

function ReplaceHeroIdActiveBulletTriggerEvent:__delete()
end

function ReplaceHeroIdActiveBulletTriggerEvent:Execute(param, extra)
  if not extra then
    return
  end
  local bulletId = 0
  local para = param.para
  if not string.IsNullOrEmpty(para) then
    local paraList = string.split(para, "|")
    if #paraList == 2 then
      bulletId = tonumber(paraList[2])
    end
  end
  if DataCenter.LWBattleManager.logic.ReplaceHeroIdActiveBullet then
    DataCenter.LWBattleManager.logic:ReplaceHeroIdActiveBullet(param, extra, bulletId)
  end
end

return ReplaceHeroIdActiveBulletTriggerEvent
