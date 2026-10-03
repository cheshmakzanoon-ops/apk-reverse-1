local BattleCardUseSkillMessage = BaseClass("BattleCardUseSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BattleCardUseSkillMessage:OnCreate(cardUuid, skillId, extraParam)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", cardUuid)
  self.sfsObj:PutInt("skillId", skillId)
  if extraParam then
    local extra = SFSObject.New()
    if extraParam.resourcePointId then
      extra:PutInt("resourcePointId", extraParam.resourcePointId)
    end
    if extraParam.marchTargetType then
      extra:PutInt("target", extraParam.marchTargetType)
    end
    if extraParam.uuid then
      extra:PutLong("uuid", extraParam.uuid)
    end
    self.sfsObj:PutSFSObject("extraParam", extra)
  end
end

function BattleCardUseSkillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return BattleCardUseSkillMessage
