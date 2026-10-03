local DispatchTreasureALExchangeMessage = BaseClass("DispatchTreasureALExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.type then
      local param = {}
      param.type = t.type
      SFSNetwork.SendMessage(MsgDefines.DispatchTreasureGetALInfo, param)
      EventManager:GetInstance():Broadcast(EventId.DispatchTreasureALExchangeSuccess, t.type)
    end
    if t.errorCode == nil then
      if t.exchangeOwner then
        local playerHead = {}
        playerHead.uid = t.exchangeOwner.uid
        playerHead.pic = t.exchangeOwner.headPic
        playerHead.picVer = t.exchangeOwner.headPicVer
        local framePath = DataCenter.DecorationDataManager:GetHeadFrame(t.exchangeOwner.headSkinId, t.exchangeOwner.headSkinET, false)
        playerHead.headBg = framePath
        UIUtil.ShowTips(Localization:GetString("Treasure_map_39", t.exchangeOwner.name), 3, playerHead)
      else
        UIUtil.ShowTipsId("Treasure_map_26")
      end
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

DispatchTreasureALExchangeMessage.OnCreate = OnCreate
DispatchTreasureALExchangeMessage.HandleMessage = HandleMessage
return DispatchTreasureALExchangeMessage
