local AllianceNoticeOperateNotesMessage = BaseClass("AllianceNoticeOperateNotesMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, aid, opType, lastTime, lastUuid)
  base.OnCreate(self)
  if aid then
    self.sfsObj:PutUtfString("allianceId", aid)
  end
  if opType then
    self.sfsObj:PutInt("opType", opType)
  end
  if lastTime then
    self.sfsObj:PutLong("lastTime", lastTime)
  end
  if lastUuid then
    self.sfsObj:PutLong("uuid", lastUuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceNoticeRecordManager:GetRecordDataListMsg(t)
    EventManager:GetInstance():Broadcast(EventId.AlNoticeRecordMsgGet, t)
  end
end

AllianceNoticeOperateNotesMessage.OnCreate = OnCreate
AllianceNoticeOperateNotesMessage.HandleMessage = HandleMessage
return AllianceNoticeOperateNotesMessage
