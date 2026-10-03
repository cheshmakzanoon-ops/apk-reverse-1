local NewArenaKofSaveMessage = BaseClass("NewArenaKofSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function NewArenaKofSaveMessage:OnCreate(teamInfoArray)
  base.OnCreate(self)
  self.sfsObj:PutSFSArray("teamInfos", teamInfoArray)
end

function NewArenaKofSaveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.NewPeakArenaManager:ParseOpponentData(t)
    UIUtil.ShowTipsId(801154)
  end
end

return NewArenaKofSaveMessage
