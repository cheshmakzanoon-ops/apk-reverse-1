local CenterThroneActivityInfoMessage = BaseClass("CenterThroneActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CenterThroneActivityInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  if not serverId or serverId <= 0 then
    serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
  end
  self.sfsObj:PutInt("serverId", serverId)
end

function CenterThroneActivityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonNineKingManager:CenterThroneActivityInfo(t)
end

return CenterThroneActivityInfoMessage
