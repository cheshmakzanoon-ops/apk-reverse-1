local ScratchOffGameRankInfo = BaseClass("ScratchOffGameRankInfo", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tostring(activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ScratchOffGameManager:OnRecvRankInfo(t)
  end
end

ScratchOffGameRankInfo.OnCreate = OnCreate
ScratchOffGameRankInfo.HandleMessage = HandleMessage
return ScratchOffGameRankInfo
