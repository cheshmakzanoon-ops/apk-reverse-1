local PutOutpostAtCityMessage = BaseClass("PutOutpostAtCityMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PutOutpostAtCityMessage:OnCreate(cityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("index", index)
end

function PutOutpostAtCityMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonOutpostManager:SetOutpostPos(t.index, t.cityId)
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostPosList)
  if SceneUtils.GetIsInWorld() then
    local theWorld = CS.SceneManager.World
    if theWorld then
      theWorld:SetFirstViewRequestFlag(true)
      theWorld:UpdateViewRequest(true)
    end
  end
end

return PutOutpostAtCityMessage
