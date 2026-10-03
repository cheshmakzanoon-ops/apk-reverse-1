local CoverSkinMessage = BaseClass("CoverSkinMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, skinId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("skinId", skinId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DecorationDataManager:CovertSkinHandler(t)
  end
end

CoverSkinMessage.OnCreate = OnCreate
CoverSkinMessage.HandleMessage = HandleMessage
return CoverSkinMessage
