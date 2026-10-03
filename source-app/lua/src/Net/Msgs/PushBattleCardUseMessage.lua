local PushBattleCardUseMessage = BaseClass("PushBattleCardUseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBattleCardUseMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBattleCardUseMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local cardId, pointId, skillId
    if t.cardId then
      cardId = t.cardId
    end
    if t.point then
      pointId = t.point
    end
    if t.skillId then
      skillId = t.skillId
    end
    local serverId = t.curServerId
    if not serverId then
      Logger.LogError("\230\178\161\230\156\137\230\156\141\229\138\161\229\153\168Id\239\188\129")
    end
    local castUid = t.uid
    if cardId and pointId and skillId then
      DataCenter.TCCardWorldManager:OnHandleCastSkillOnWorld(cardId, pointId, skillId, serverId)
      local param = {}
      param.castUid = castUid
      param.cardId = cardId
      param.cardSkillId = skillId
      EventManager:GetInstance():Broadcast(EventId.UseTacticalCardSkill, param)
    end
  end
end

return PushBattleCardUseMessage
