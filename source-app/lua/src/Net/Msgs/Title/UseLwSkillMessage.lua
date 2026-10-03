local UseLwSkillMessage = BaseClass("UseLwSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UseLwSkillMessage:OnCreate(skill, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("skillId", tostring(skill))
  if param then
    if param.bUuid then
      self.sfsObj:PutLong("bUuid", param.bUuid)
    end
    if param.fUuid then
      self.sfsObj:PutLong("fUuid", param.fUuid)
    end
    if param.dUuid then
      self.sfsObj:PutLong("dUuid", param.dUuid)
    end
    if param.pointId then
      self.sfsObj:PutInt("pointId", param.pointId)
    end
    if param.otherUid then
      self.sfsObj:PutUtfString("otherUid", param.otherUid)
    end
    if param.serverId then
      self.sfsObj:PutInt("serverId", param.serverId)
    end
    if param.selectId then
      self.sfsObj:PutInt("selectId", param.selectId)
    end
    if param.targetUuid then
      self.sfsObj:PutLong("targetUuid", param.targetUuid)
    end
    if param.formationUuid then
      self.sfsObj:PutLong("formationUuid", param.formationUuid)
    end
  end
end

function UseLwSkillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.MasteryManager:HandleUseSkill(t)
  EventManager:GetInstance():Broadcast(EventId.LWUseSkill, t)
end

return UseLwSkillMessage
