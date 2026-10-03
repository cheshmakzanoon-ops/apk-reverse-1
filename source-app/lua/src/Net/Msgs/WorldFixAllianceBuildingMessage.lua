local WorldFixAllianceBuildingMessage = BaseClass("WorldFixAllianceBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.isFix then
    if SeasonUtil.GetSeason() == 1 then
      UIUtil.ShowTipsId("season_rebuild_tips002")
    else
      UIUtil.ShowTipsId("801149")
    end
  elseif t.cdTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = t.cdTime - now
    if 0 < remainTime then
      UIUtil.ShowTips(Localization:GetString("season_rebuild_tips001", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
    end
  end
end

WorldFixAllianceBuildingMessage.OnCreate = OnCreate
WorldFixAllianceBuildingMessage.HandleMessage = HandleMessage
return WorldFixAllianceBuildingMessage
