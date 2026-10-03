local TrainBatchSendMessage = BaseClass("TrainBatchSendMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TrainBatchSendMessage:OnCreate(truckUuid2FormationMap)
  base.OnCreate(self)
  local sendArray = SFSArray.New()
  for truckUuid, formation in pairs(truckUuid2FormationMap) do
    local heroArray = formation:GenerateServerHeroArray()
    local curChipSetId = formation:GetLocalTWSkillChipSetId()
    local teamBuffIndex = formation.localSquadNo
    local sendObj = SFSObject.New()
    sendObj:PutLong("uuid", truckUuid)
    sendObj:PutInt("squadNo", teamBuffIndex)
    sendObj:PutInt("squadNoClient", formation.index)
    sendObj:PutSFSArray("heroInfo", heroArray)
    if curChipSetId and 0 < curChipSetId and curChipSetId <= 4 then
      sendObj:PutInt("chipEquipGroup", curChipSetId)
    end
    sendArray:AddSFSObject(sendObj)
  end
  self.sfsObj:PutSFSArray("list", sendArray)
end

function TrainBatchSendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return TrainBatchSendMessage
