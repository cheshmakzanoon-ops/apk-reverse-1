local GetJigsawRankInfoMessage = BaseClass("GetJigsawRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("id", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.JigsawPuzzleManager:UpdateRankInfo(t)
  end
end

GetJigsawRankInfoMessage.OnCreate = OnCreate
GetJigsawRankInfoMessage.HandleMessage = HandleMessage
return GetJigsawRankInfoMessage
