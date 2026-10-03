local AllianceShareMissionThumbsUpMessage = BaseClass("AllianceShareMissionThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceShareMissionThumbsUpMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("missionUuid", param.missionUuid)
  self.sfsObj:PutUtfString("content", param.content)
  self.sfsObj:PutUtfString("extParam", param.extParam)
end

function AllianceShareMissionThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDispatchTaskDataManager:OnThumbsUpCallback(t)
  end
end

return AllianceShareMissionThumbsUpMessage
