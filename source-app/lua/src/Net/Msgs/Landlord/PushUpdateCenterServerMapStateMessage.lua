local PushUpdateCenterServerMapStateMessage = BaseClass("PushUpdateCenterServerMapStateMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization
local base = SFSBaseMessage

function PushUpdateCenterServerMapStateMessage:OnCreate()
  base.OnCreate(self)
end

function PushUpdateCenterServerMapStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  elseif t.centerServerId then
    DataCenter.LandlordMgr:SetIsNewCenterMapPeriod(t.centerServerState == 1, t.centerServerId, true)
    local infoList = DataCenter.SeasonDataManager.SpecialServerSeasonInfoList or {}
    for k, v in pairs(infoList) do
      v:InitNinePalacesCenterServer(t.centerServerId, t.centerServerState)
    end
  end
end

return PushUpdateCenterServerMapStateMessage
