local BiuBiuPVEGameStartMessage = BaseClass("BiuBiuPVEGameStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, version)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("version", version)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:VersionDiff()
  else
    DataCenter.LWBiuBiuDataManager:UpdateInfo(t)
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPveStart)
  end
end

BiuBiuPVEGameStartMessage.OnCreate = OnCreate
BiuBiuPVEGameStartMessage.HandleMessage = HandleMessage
return BiuBiuPVEGameStartMessage
