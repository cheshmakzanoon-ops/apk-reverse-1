local AllianceNoticeBatchDeleteMessage = BaseClass("AllianceNoticeBatchDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uids, roomIdsJson)
  base.OnCreate(self)
  if uids then
    self.sfsObj:PutUtfStringArray("uuidArray", uids)
  end
  if roomIdsJson then
    self.sfsObj:PutUtfString("roomIds", roomIdsJson)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil and t.errorCode ~= "" then
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  else
    UIUtil.ShowTipsId(2900059)
  end
end

AllianceNoticeBatchDeleteMessage.OnCreate = OnCreate
AllianceNoticeBatchDeleteMessage.HandleMessage = HandleMessage
return AllianceNoticeBatchDeleteMessage
