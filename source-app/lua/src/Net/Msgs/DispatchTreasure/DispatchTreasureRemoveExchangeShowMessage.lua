local DispatchTreasureRemoveExchangeShowMessage = BaseClass("DispatchTreasureRemoveExchangeShowMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("type", param.type)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      SFSNetwork.SendMessage(MsgDefines.DispatchTreasureGetSelfInfo, {
        type = t.type
      })
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureRemoveExchangeShowMessage.OnCreate = OnCreate
DispatchTreasureRemoveExchangeShowMessage.HandleMessage = HandleMessage
return DispatchTreasureRemoveExchangeShowMessage
