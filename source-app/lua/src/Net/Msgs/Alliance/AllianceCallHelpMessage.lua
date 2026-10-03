local AllianceCallHelpMessage = BaseClass("AllianceCallHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, type, qType, itemId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("qType", qType)
  self.sfsObj:PutUtfString("itemId", itemId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    local uuid = tonumber(t.content)
    local helpType = t.helpType
    local queueType = t.queueType
    if helpType == AllianceHelpType.Building then
      DataCenter.BuildManager:OnAllianceCallHelp(uuid)
      EventManager:GetInstance():Broadcast(EventId.AllianceBuildHelpNew, uuid)
    elseif helpType == AllianceHelpType.FIX_BUILDING then
      DataCenter.BuildManager:OnAllianceCallFixHelp(uuid)
      EventManager:GetInstance():Broadcast(EventId.AllianceBuildHelpNew, uuid)
    elseif helpType == AllianceHelpType.Queue then
      DataCenter.QueueDataManager:OnAllianceCallHelp(uuid)
      EventManager:GetInstance():Broadcast(EventId.AllianceQueueHelpNew, queueType)
    end
    UIUtil.ShowTipsId(390123)
  end
end

AllianceCallHelpMessage.OnCreate = OnCreate
AllianceCallHelpMessage.HandleMessage = HandleMessage
return AllianceCallHelpMessage
