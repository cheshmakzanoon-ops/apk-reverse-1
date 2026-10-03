local UseAllianceOfficialSkillMessage = BaseClass("UseAllianceOfficialSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage
local lastSkillId

function UseAllianceOfficialSkillMessage:OnCreate(skillId, targetPointId, worldId, targetUuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("skillId", skillId)
  self.sfsObj:PutInt("targetPointId", targetPointId)
  self.sfsObj:PutInt("worldId", worldId or 0)
  if targetUuid ~= nil and targetUuid ~= 0 then
    self.sfsObj:PutLong("targetUuid", targetUuid)
  end
  lastSkillId = skillId
end

function UseAllianceOfficialSkillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    lastSkillId = nil
    UIUtil.ShowTipsId(errCode)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetAllianceOfficialSkillList)
  local skillId = t.skillId
  if skillId and (skillId == 60000 or skillId == 60008) then
    UIUtil.ShowTipsId("season_mastery_UI_tips_12")
  end
  if skillId then
    local commonSkill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillById(t.skillId)
    if commonSkill then
      SFSNetwork.SendMessage(MsgDefines.AllianceGovernmentSkillGetList)
      SFSNetwork.SendMessage(MsgDefines.AllianceSkillEnergyGetInfo)
      EventManager:GetInstance():Broadcast(EventId.AllianceSkillReleaseSuccess, skillId)
    end
  end
  if lastSkillId then
    local cfg = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(lastSkillId)
    if cfg ~= nil and cfg.skill_flag == AlOfficialSkillType.AresMissile and CS.SceneManager.World then
      local MainWorldPos = LuaEntry.Player:GetMainWorldPos()
      local worldPos = SceneUtils.TileIndexToWorld(MainWorldPos, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime)
      DataCenter.AllianceSkillManager:SetNeedPlayBornAnim(true)
    end
  end
  lastSkillId = nil
end

return UseAllianceOfficialSkillMessage
