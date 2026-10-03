local DetectEventPveFeatureStartMessage = BaseClass("DetectEventPveFeatureStartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(t.uuid)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    local param = {}
    param.type = PVEType.Parkour
    param.enterType = PVEEnterType.Radar
    param.levelId = template.para
    param.extraData = {
      uuid = t.uuid
    }
    DataCenter.LWBattleManager:Enter(param)
    EventManager:GetInstance():Broadcast(EventId.GF_goto_pve_battle, param)
  end
end

DetectEventPveFeatureStartMessage.OnCreate = OnCreate
DetectEventPveFeatureStartMessage.HandleMessage = HandleMessage
return DetectEventPveFeatureStartMessage
