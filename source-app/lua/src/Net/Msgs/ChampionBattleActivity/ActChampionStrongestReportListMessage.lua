local ActChampionStrongestReportListMessage = BaseClass("ActChampionStrongestReportListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, phase, location)
  base.OnCreate(self)
  self.sfsObj:PutLong("phase", phase)
  self.sfsObj:PutLong("location", location)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActChampionBattleManager:RefreshChampionBattleReportList(message)
end

ActChampionStrongestReportListMessage.OnCreate = OnCreate
ActChampionStrongestReportListMessage.HandleMessage = HandleMessage
return ActChampionStrongestReportListMessage
