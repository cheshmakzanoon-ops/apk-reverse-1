local AllianceBossDigGameCreatePushMessage = BaseClass("AllianceBossDigGameCreatePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.AllyDrillDataManager:OnDigGameCreate(t)
end

AllianceBossDigGameCreatePushMessage.OnCreate = OnCreate
AllianceBossDigGameCreatePushMessage.HandleMessage = HandleMessage
return AllianceBossDigGameCreatePushMessage
