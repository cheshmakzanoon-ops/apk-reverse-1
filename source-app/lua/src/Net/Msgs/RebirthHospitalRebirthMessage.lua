local RebirthHospitalRebirthMessage = BaseClass("RebirthHospitalRebirthMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    local arr = SFSArray.New()
    for _, v in pairs(param) do
      local one = SFSObject.New()
      one:PutUtfString("armyId", tostring(v.armyId))
      one:PutInt("rebirthNum", v.rebirthNum)
      arr:AddSFSObject(one)
    end
    self.sfsObj:PutSFSArray("armyArray", arr)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.RebirthHospitalManager:OnRebirthMessageCallback(t)
end

RebirthHospitalRebirthMessage.OnCreate = OnCreate
RebirthHospitalRebirthMessage.HandleMessage = HandleMessage
return RebirthHospitalRebirthMessage
