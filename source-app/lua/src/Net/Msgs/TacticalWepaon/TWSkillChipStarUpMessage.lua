local TWSkillChipStarUpMessage = BaseClass("TWSkillChipStarUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipStarUpMessage:OnCreate(uuid, num)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  if num and 0 < num then
    self.sfsObj:PutInt("num", num)
  else
    self.sfsObj:PutInt("num", 0)
  end
end

function TWSkillChipStarUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    local changedChipUuid, addedStarId
    if t and not table.IsNullOrEmpty(t.changes) then
      for i, v in ipairs(t.changes) do
        if v and v.uuid then
          changedChipUuid = v.uuid
          addedStarId = v.star
          break
        end
      end
    end
    local eventData = {
      changedChipUuid = changedChipUuid,
      addedStarId = addedStarId,
      srcStar = t.oldStar
    }
    DataCenter.TWSkillChipManager:UpdateChipsInfo(t, false)
    EventManager:GetInstance():Broadcast(EventId.TWSkillChipStarUp, eventData)
  end
end

return TWSkillChipStarUpMessage
