local GainAllianceShareSkillMsgMessage = BaseClass("GainAllianceShareSkillMsgMessage", SFSBaseMessage)
local base = SFSBaseMessage
local rapidjson = require("rapidjson")

function GainAllianceShareSkillMsgMessage:OnCreate(playerUid, seqId)
  base.OnCreate(self)
  self.sfsObj:PutInt("msgId", seqId)
  self.sfsObj:PutUtfString("tarUid", playerUid)
end

function GainAllianceShareSkillMsgMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if not t.msgId then
    return
  end
  local roomId = ChatInterface.getAllianceRoomId()
  if string.IsNullOrEmpty(roomId) then
    return
  end
  local roomData = ChatInterface.getRoomData(roomId)
  if not roomData then
    return
  end
  local chatData = roomData:getChatDataBySeqId(t.msgId)
  if not (chatData and chatData.extra) or not chatData.extra.customJsonParam then
    return
  end
  local jsonObj = rapidjson.decode(chatData.extra.customJsonParam)
  if t.maxWorkerNum then
    jsonObj.maxWorkerNum = t.maxWorkerNum
  end
  if t.curWorkerNum then
    jsonObj.curWorkerNum = t.curWorkerNum
  end
  if t.brightnessLevel then
    jsonObj.brightnessLevel = t.brightnessLevel
  end
  jsonObj.pointId = t.pointId
  chatData.extra.customJsonParam = rapidjson.encode(jsonObj)
  EventManager:GetInstance():Broadcast(EventId.ElectricianGatherRefresh, chatData.seqId)
end

return GainAllianceShareSkillMsgMessage
