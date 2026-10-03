local TWSkillChipLvUpMessage = BaseClass("TWSkillChipLvUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TWSkillChipLvUpMessage:OnCreate(uuid, sources, useGoods)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  local chipArray = SFSArray.New()
  table.walk(sources, function(k, v)
    local obj = SFSObject.New()
    obj:PutLong("uuid", k)
    obj:PutInt("num", v)
    chipArray:AddSFSObject(obj)
  end)
  self.sfsObj:PutSFSArray("chips", chipArray)
  if not table.IsNullOrEmpty(useGoods) then
    local goodsArray = SFSArray.New()
    table.walk(useGoods, function(k, v)
      local obj = SFSObject.New()
      obj:PutUtfString("itemUid", k)
      obj:PutInt("num", v)
      goodsArray:AddSFSObject(obj)
    end)
    self.sfsObj:PutSFSArray("consumeItems", goodsArray)
  end
end

function TWSkillChipLvUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    local changedChipUuid
    if t and not table.IsNullOrEmpty(t.changes) then
      for i, v in ipairs(t.changes) do
        if v and v.uuid then
          changedChipUuid = v.uuid
          break
        end
      end
    end
    local eventData = {
      changedChipUuid = changedChipUuid,
      srcLv = t.oldLv,
      msg = t
    }
    DataCenter.TWSkillChipManager:UpdateChipsInfo(t, false)
    EventManager:GetInstance():Broadcast(EventId.TWSkillChipUpgrade, eventData)
    UIUtil.ShowTipsId("120062")
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
end

return TWSkillChipLvUpMessage
