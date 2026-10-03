local ReplaceHeroIdNormalBulletTriggerEvent = BaseClass("ReplaceHeroIdNormalBulletTriggerEvent")

function ReplaceHeroIdNormalBulletTriggerEvent:__init()
end

function ReplaceHeroIdNormalBulletTriggerEvent:__delete()
end

function ReplaceHeroIdNormalBulletTriggerEvent:Execute(param, extra)
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
  if DataCenter.LWBattleManager.logic.ReplaceHeroIdNormalBullet then
    DataCenter.LWBattleManager.logic:ReplaceHeroIdNormalBullet(param, extra, bulletId)
  end
end

return ReplaceHeroIdNormalBulletTriggerEvent
