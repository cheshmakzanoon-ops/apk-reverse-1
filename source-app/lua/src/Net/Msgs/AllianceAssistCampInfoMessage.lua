local AllianceAssistCampInfoMessage = BaseClass("AllianceAssistCampInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid)
  base.OnCreate(self)
  if bUuid then
    self.sfsObj:PutLong("bUuid", bUuid)
  end
  self.sfsObj:PutInt("targetServer", LuaEntry.Player:GetCurServerId())
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FormationAssistanceDataManager:UpdateAssistanceData(t)
  end
end

AllianceAssistCampInfoMessage.OnCreate = OnCreate
AllianceAssistCampInfoMessage.HandleMessage = HandleMessage
return AllianceAssistCampInfoMessage
