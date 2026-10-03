local SandWormActivityInfoMessage = BaseClass("SandWormActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  if pageSize then
    self.sfsObj:PutInt("pageSize", pageSize)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
  else
    DataCenter.SandWormHuntDataManager:HandleSandWormHuntActivityInfo(t)
  end
end

SandWormActivityInfoMessage.OnCreate = OnCreate
SandWormActivityInfoMessage.HandleMessage = HandleMessage
return SandWormActivityInfoMessage
