local LWSaveGuideStepMessage = BaseClass("LWSaveGuideStepMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, flowId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", flowId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.lwGuideRecordSteps ~= nil then
    DataCenter.LWGuideFlowManager:OnServerRecords(t.lwGuideRecordSteps)
  end
end

LWSaveGuideStepMessage.OnCreate = OnCreate
LWSaveGuideStepMessage.HandleMessage = HandleMessage
return LWSaveGuideStepMessage
