local PushMapStickerMessage = BaseClass("PushMapStickerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local isSimpleMode = not DisplaySettings.ShowDynamicWorldSticker()
    if checknumber(t.type) > 0 then
      local stickerType = checknumber(t.type)
      if 0 < checknumber(t.stickerId) then
        DataCenter.LWSticker3DManager:ShowSticker(stickerType, t.stickerId, t.uuid, t.numPara, isSimpleMode, true)
      end
      if 0 < table.count(t.infoArray) then
        for _, v in pairs(t.infoArray) do
          DataCenter.LWSticker3DManager:ShowSticker(stickerType, v.stickerId, v.uuid, v.numPara, isSimpleMode, true)
        end
      end
    end
  end
end

PushMapStickerMessage.OnCreate = OnCreate
PushMapStickerMessage.HandleMessage = HandleMessage
return PushMapStickerMessage
