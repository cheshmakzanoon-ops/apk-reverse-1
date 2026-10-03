local MasteryUseSkillMessage = BaseClass("MasteryUseSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, skill, param)
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
      self.sfsObj:PutInt("targetServerId", param.serverId)
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

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.MasteryManager:HandleUseSkill(t)
  EventManager:GetInstance():Broadcast(EventId.MasteryUseSkill, t)
end

MasteryUseSkillMessage.OnCreate = OnCreate
MasteryUseSkillMessage.HandleMessage = HandleMessage
return MasteryUseSkillMessage
