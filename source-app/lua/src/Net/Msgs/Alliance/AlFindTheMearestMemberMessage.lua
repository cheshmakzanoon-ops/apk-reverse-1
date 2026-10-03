local AlFindTheMearestMemberMessage = BaseClass("AlFindTheMearestMemberMessage", SFSBaseMessage)
local base = SFSBaseMessage
local lang

local function OnCreate(self, type, langKey)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type or AlFindTheNearestMemberType.Normal)
  lang = langKey
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    GoToUtil.GoToAllianceMemberBase(t, lang)
    lang = nil
  end
end

AlFindTheMearestMemberMessage.OnCreate = OnCreate
AlFindTheMearestMemberMessage.HandleMessage = HandleMessage
return AlFindTheMearestMemberMessage
