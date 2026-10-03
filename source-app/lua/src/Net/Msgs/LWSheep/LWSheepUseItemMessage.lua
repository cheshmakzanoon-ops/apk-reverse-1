local LWSheepUseItemMessage = BaseClass("LWSheepUseItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120089)
    DataCenter.LWSheepDataManager:UpdateUseItem(t)
  end
end

LWSheepUseItemMessage.OnCreate = OnCreate
LWSheepUseItemMessage.HandleMessage = HandleMessage
return LWSheepUseItemMessage
