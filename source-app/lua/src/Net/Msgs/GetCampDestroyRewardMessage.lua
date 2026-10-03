local GetCampDestroyRewardMessage = BaseClass("GetCampDestroyRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCampDestroyRewardMessage:OnCreate(serverCityList)
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

function GetCampDestroyRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CampProduceDataManager:ReqCampDestroyRewardMessage(t)
  end
end

return GetCampDestroyRewardMessage
