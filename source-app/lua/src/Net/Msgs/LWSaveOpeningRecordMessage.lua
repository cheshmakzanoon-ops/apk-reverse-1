local LWSaveOpeningRecordMessage = BaseClass("LWSaveOpeningRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", stageId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

LWSaveOpeningRecordMessage.OnCreate = OnCreate
LWSaveOpeningRecordMessage.HandleMessage = HandleMessage
return LWSaveOpeningRecordMessage
