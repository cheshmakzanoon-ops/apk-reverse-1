local ScratchOffGameLotteryMessage = BaseClass("ScratchOffGameLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, tenLottery)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tostring(activityId))
  self.sfsObj:PutInt("tenLottery", tonumber(tenLottery))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ScratchOffGameManager:OnRecvLotteryRes(t)
  end
end

ScratchOffGameLotteryMessage.OnCreate = OnCreate
ScratchOffGameLotteryMessage.HandleMessage = HandleMessage
return ScratchOffGameLotteryMessage
