local AutoStickerSetMessage = BaseClass("AutoStickerSetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AutoStickerSetMessage:OnCreate(param)
  base.OnCreate(self)
  local arr = SFSArray.New()
  for k, v in pairs(param) do
    local obj = SFSObject.New()
    obj:PutInt("type", checknumber(k))
    obj:PutInt("sticker", checknumber(v))
    arr:AddSFSObject(obj)
  end
  self.sfsObj:PutSFSArray("infos", arr)
end

function AutoStickerSetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSticker3DManager:OnSetAutoCallback(t)
  end
end

return AutoStickerSetMessage
