local GetGolloesCardRankMessage = BaseClass("GetGolloesCardRankMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActGolloesCardData:GetCardRankHandle(t)
  end
end

GetGolloesCardRankMessage.OnCreate = OnCreate
GetGolloesCardRankMessage.HandleMessage = HandleMessage
return GetGolloesCardRankMessage
