local SetCampMasterServerValueMessage = BaseClass("SetCampMasterServerValueMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetCampMasterServerValueMessage:OnCreate(value)
  base.OnCreate(self)
  self.sfsObj:PutInt("value", value)
end

function SetCampMasterServerValueMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.list then
    DataCenter.SeasonDataManager.seasonFactionMasterServerValue = t.list
    UIUtil.ShowTipsId(120094)
  end
  SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionInfo)
end

return SetCampMasterServerValueMessage
