local SeasonFishUseFishMessage = BaseClass("SeasonFishUseFishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonFishUseFishMessage:OnCreate(fishId, type, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("fishId", fishId)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("num", num)
end

function SeasonFishUseFishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t then
    DataCenter.FishingDataManager:HandleUseOneFish(t)
  end
end

return SeasonFishUseFishMessage
