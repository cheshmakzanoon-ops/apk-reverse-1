local GetRechargeInfoMessage = BaseClass("GetRechargeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, rechargeId)
  base.OnCreate(self)
  self.sfsObj:PutInt("rechargeId", rechargeId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.CumulativeRechargeManager:UpdateRechargeStageInfo(t)
end

GetRechargeInfoMessage.OnCreate = OnCreate
GetRechargeInfoMessage.HandleMessage = HandleMessage
return GetRechargeInfoMessage
