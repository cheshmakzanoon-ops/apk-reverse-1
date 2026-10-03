local DominatorGorillaTreatmentMessage = BaseClass("DominatorGorillaTreatmentMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutUtfString("goodsId", tostring(param.itemId))
  self.sfsObj:PutInt("costNum", 1)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DominatorManager:OnGorillaTreatmentCallback(t)
  end
end

DominatorGorillaTreatmentMessage.OnCreate = OnCreate
DominatorGorillaTreatmentMessage.HandleMessage = HandleMessage
return DominatorGorillaTreatmentMessage
