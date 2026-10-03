local UIDecorationStickerCell = BaseClass("UIDecorationStickerCell", UIBaseContainer)
local base = UIBaseContainer
local bgPtah = "Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_01.png"
local markBgPtah = "Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_kong_01.png"
local markPath = "Assets/Main/Sprites/UI/LWUIWorldStickers/"
local compBook = {
  {
    path = "bg",
    name = "bg",
    type = UIImage
  },
  {
    path = "icon",
    name = "stickerIcon",
    type = UIImage
  },
  {
    path = "deletebtn",
    name = "deleteBtn",
    type = UIButton,
    onClick = function(self)
      self:OnDeleteBtnClick()
    end
  },
  {
    path = "sticker_low",
    name = "sticker_low",
    type = UIImage
  },
  {
    path = "select",
    name = "selectCom",
    type = UIBaseContainer
  },
  {
    path = "",
    name = "btn",
    type = UIButton,
    onClick = function(self)
      self:OnClick()
    end
  }
}

function UIDecorationStickerCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDecorationStickerCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickerCell:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDecorationStickerCell:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDecorationStickerCell:OnClick()
  if self.callback and self.index then
    self.callback(self.index)
    self.selectCom:SetActive(true)
  end
end

function UIDecorationStickerCell:OnDeleteBtnClick()
  self.initDecorationId = -1
  self:UpdateSticker(-1)
  self.stickersCom:SaveSticker()
  self.view:RefreshIconDecorations(DecorationType.DecorationType_Emoji)
end

function UIDecorationStickerCell:SetData(data, index, stickersCom, callback)
  self.data = data
  self.index = index
  self.callback = callback
  self.stickersCom = stickersCom
  self.initDecorationId = self.data.decorationId
  self:RefreshView()
end

function UIDecorationStickerCell:UpdateSticker(decorationId, isInit)
  if decorationId ~= self.data.decorationId or isInit then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    self.data.decorationId = decorationId
    self.data.template = template
    if template and template.customVariable and tonumber(template.customVariable) > 0 then
      local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
      self.bg:LoadSprite(bgPtah)
      self.sticker_low:LoadSprite(markPath .. self.data.markPath)
      self.stickerIcon:LoadSprite(string.format(ChatStickerCoverPath, strickerTmp.name))
      self.stickerIcon:SetActive(true)
      self.stickerIcon:SetNativeSize()
      self.deleteBtn:SetActive(self.openType ~= MapStickerOpenType.Wrold)
    else
      self.bg:LoadSprite(markBgPtah)
      self.sticker_low:LoadSprite(markPath .. self.data.emptyMarkPath)
      self.stickerIcon:SetActive(false)
      self.deleteBtn:SetActive(false)
      self.sticker_low:SetActive(true)
    end
  end
end

function UIDecorationStickerCell:SaveStricker()
  self.initDecorationId = self.data.decorationId
end

function UIDecorationStickerCell:Restore()
  if self.initDecorationId ~= self.data.decorationId then
    self:UpdateSticker(self.initDecorationId)
  end
end

function UIDecorationStickerCell:SetOpenType(openType)
  self.openType = openType
  self:UpdateSticker(self.initDecorationId, true)
end

function UIDecorationStickerCell:UnSelect(isOn)
  self.selectCom:SetActive(isOn)
end

function UIDecorationStickerCell:RefreshView()
  self:UpdateSticker(self.data.decorationId, true)
  if self.openType == MapStickerOpenType.Wrold then
    self.seleteBtn:SetActive(false)
  end
end

return UIDecorationStickerCell
