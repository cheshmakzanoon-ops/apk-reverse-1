local AlCancelApplyMessage = BaseClass("AlCancelApplyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, allianceId)
  base.OnCreate(self)
  self.alUid = allianceId
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.allianceId ~= nil then
    local allianceId = t.allianceId
    DataCenter.AllianceTempListManager:CancelApplyAllianceByUid(allianceId)
    EventManager:GetInstance():Broadcast(EventId.CLICK_ALLIANCE_ITEM, allianceId)
  end
end

AlCancelApplyMessage.OnCreate = OnCreate
AlCancelApplyMessage.HandleMessage = HandleMessage
return AlCancelApplyMessage
