local LwSeasonNewWastelandInfoMessage = BaseClass("LwSeasonNewWastelandInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSeasonNewWastelandInfoMessage:OnCreate(activityId, isShort)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("main", isShort and 1 or 0)
end

function LwSeasonNewWastelandInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WestwardExpansionDataManager:HandleRankMessage(t)
  end
end

return LwSeasonNewWastelandInfoMessage
