local GetLandlordCityDetailMessage = BaseClass("GetLandlordCityDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function GetLandlordCityDetailMessage:OnCreate(serverId, cityId, previewAssistance)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("previewAssistance", previewAssistance or 10)
end

function GetLandlordCityDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    local detail = DataCenter.WorldPointDetailManager:UpdateAllianceCity(t, false)
    DataCenter.FormationAssistanceDataManager:OnUpdateFocusCityAssistanceInfo(detail.cityId, detail.maxAssistance, detail.currAssistance, detail.assistanceList)
    EventManager:GetInstance():Broadcast(EventId.WorldAllianceCityDetail)
    DataCenter.LandlordMgr:OnHandleDetailMessage(t)
  end
end

return GetLandlordCityDetailMessage
