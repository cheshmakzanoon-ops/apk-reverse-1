local GetLongDistanceMemberNumMessage = BaseClass("GetLongDistanceMemberNumMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("markType", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.num then
    DataCenter.AllianceRallyPointDataManager:SetFarAwayMemberCount(t.num, t.markType)
  end
end

GetLongDistanceMemberNumMessage.OnCreate = OnCreate
GetLongDistanceMemberNumMessage.HandleMessage = HandleMessage
return GetLongDistanceMemberNumMessage
