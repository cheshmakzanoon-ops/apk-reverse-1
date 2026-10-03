local TacticalChipDecomposeMessage = BaseClass("TacticalChipDecomposeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, idList)
  base.OnCreate(self)
  self.sfsObj:PutLongArray("ids", idList)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

TacticalChipDecomposeMessage.OnCreate = OnCreate
TacticalChipDecomposeMessage.HandleMessage = HandleMessage
return TacticalChipDecomposeMessage
