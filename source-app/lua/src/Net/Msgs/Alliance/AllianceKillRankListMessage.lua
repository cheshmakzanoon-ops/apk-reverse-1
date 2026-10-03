local AllianceKillRankListMessage = BaseClass("AllianceKillRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.sfsObj:PutInt("ismerge", 0)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RankDataManager:ParseAllianceRankData(0, RankType.AllianceKill, t)
    EventManager:GetInstance():Broadcast(EventId.AllianceRank)
  end
end

AllianceKillRankListMessage.OnCreate = OnCreate
AllianceKillRankListMessage.HandleMessage = HandleMessage
return AllianceKillRankListMessage
