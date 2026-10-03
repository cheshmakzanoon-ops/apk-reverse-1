local WorldGetDetailMessage = BaseClass("WorldGetDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, pointId, serverId, worldId, pointType, uid)
  base.OnCreate(self)
  self.sfsObj:PutInt("point", pointId)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", worldId)
  self.sfsObj:PutInt("previewAssistance", 10)
  if pointType then
    self.sfsObj:PutInt("pointType", pointType)
  end
  if uid then
    self.sfsObj:PutUtfString("uid", tostring(uid))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local detail = DataCenter.WorldPointDetailManager:UpdateDetail(t)
    DataCenter.FormationAssistanceDataManager:OnUpdateFocusPointAssistanceInfo(detail.pointId, detail.maxAssistance, detail.currAssistance, detail.assistanceList)
    EventManager:GetInstance():Broadcast(EventId.WorldPointDetail)
  end
end

WorldGetDetailMessage.OnCreate = OnCreate
WorldGetDetailMessage.HandleMessage = HandleMessage
return WorldGetDetailMessage
