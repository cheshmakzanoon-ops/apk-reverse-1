local GetCampProductRewardMessage = BaseClass("GetCampProductRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCampProductRewardMessage:OnCreate(serverCityList)
  base.OnCreate(self)
  local serverCityArr = SFSArray.New()
  for _, v in pairs(serverCityList) do
    local sfsObj = SFSObject.New()
    sfsObj:PutInt("serverId", v.serverId)
    sfsObj:PutInt("cityId", v.cityId)
    serverCityArr:AddSFSObject(sfsObj)
  end
  self.sfsObj:PutSFSArray("serverCityArr", serverCityArr)
end

function GetCampProductRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampProduceDataManager:ReqProductReward(t)
  end
end

return GetCampProductRewardMessage
