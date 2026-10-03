local SaveMonopolyRecordMessage = BaseClass("SaveMonopolyRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, unlockIds)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", #unlockIds == 1 and unlockIds[1] or -1)
  self.sfsObj:PutBool("isWin", true)
  local unlockIdSfsArr = SFSArray.New()
  for i, unlockId in ipairs(unlockIds) do
    unlockIdSfsArr:AddInt(unlockId)
  end
  self.sfsObj:PutSFSArray("ids", unlockIdSfsArr)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.MonopolyManager:UpdateCurId(t)
end

SaveMonopolyRecordMessage.OnCreate = OnCreate
SaveMonopolyRecordMessage.HandleMessage = HandleMessage
return SaveMonopolyRecordMessage
