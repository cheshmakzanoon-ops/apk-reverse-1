local AllianceMemberPointMessage = BaseClass("AllianceMemberPointMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid)
  base.OnCreate(self)
  if uid ~= nil then
    self.sfsObj:PutUtfString("uid", uid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceMemberDataManager:UpdateMemberPoint(t)
  end
end

AllianceMemberPointMessage.OnCreate = OnCreate
AllianceMemberPointMessage.HandleMessage = HandleMessage
return AllianceMemberPointMessage
