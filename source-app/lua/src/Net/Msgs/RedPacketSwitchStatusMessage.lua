local RedPacketSwitchStatusMessage = BaseClass("RedPacketSwitchStatusMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, isOpen)
  base.OnCreate(self)
  self.sfsObj:PutInt("redPacketSwitch", isOpen and 1 or 0)
end

local function HandleMessage(self, t)
end

RedPacketSwitchStatusMessage.OnCreate = OnCreate
RedPacketSwitchStatusMessage.HandleMessage = HandleMessage
return RedPacketSwitchStatusMessage
