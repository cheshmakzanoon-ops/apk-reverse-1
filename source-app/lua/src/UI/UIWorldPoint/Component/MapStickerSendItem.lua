local MapStickerSendItem = BaseClass("MapStickerSendItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local img_path = "img"

function MapStickerSendItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MapStickerSendItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MapStickerSendItem:ComponentDefine()
  self.img = self:AddComponent(UIImage, img_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function MapStickerSendItem:ComponentDestroy()
  self.img = nil
end

function MapStickerSendItem:OnAddListener()
  base.OnAddListener(self)
end

function MapStickerSendItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MapStickerSendItem:SetData(data)
  self.data = data
  local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(data.stickerId)
  if strickerTmp then
    self.img:LoadSprite(string.format(ChatStickerCoverPath, strickerTmp.name))
  end
end

function MapStickerSendItem:OnBtnClick()
  if self.data == nil then
    return
  end
  DataCenter.LWSticker3DManager:SendMapSticker(WorldStickerType.Build, nil, self.data.stickerId)
  self.view.ctrl:CloseSelf()
end

return MapStickerSendItem
