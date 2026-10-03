local SetGiftShowMessage = BaseClass("SetGiftShowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetGiftShowMessage:OnCreate(param)
  base.OnCreate(self)
  if param.arr ~= nil then
    local oneArr = SFSArray.New()
    for k, v in ipairs(param.arr) do
      local one = SFSObject.New()
      one:PutInt("index", v.pos)
      one:PutInt("itemId", v.itemId)
      oneArr:AddSFSObject(one)
    end
    self.sfsObj:PutSFSArray("giftShow", oneArr)
  end
end

function SetGiftShowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local info = DataCenter.PlayerInfoDataManager.selfPlayerData
    if info then
      info:SetUnlockShow(t)
      info:InitGiftDic(t)
    end
    EventManager:GetInstance():Broadcast(EventId.GiftSystemShowChanged, info)
  end
end

return SetGiftShowMessage
