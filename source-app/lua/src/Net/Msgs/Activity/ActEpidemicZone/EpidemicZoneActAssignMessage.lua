local EpidemicZoneActAssignMessage = BaseClass("EpidemicZoneActAssignMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, group, targetUid, state)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("state", state)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == 458258 or errCode == "458258" then
      local time = LuaEntry.DataConfig:TryGetNum("YiBianJinQu", "k5", 24)
      UIUtil.ShowTips(Localization:GetString(errCode, time * 24))
    else
      DataCenter.ActEpidemicZoneManager:OnAssignError(errCode, t.errorPara2)
    end
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivityAssignMessage(t)
end

EpidemicZoneActAssignMessage.OnCreate = OnCreate
EpidemicZoneActAssignMessage.HandleMessage = HandleMessage
return EpidemicZoneActAssignMessage
