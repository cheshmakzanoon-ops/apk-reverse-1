local UIDecorationStickerCellNew = BaseClass("UIDecorationStickerCellNew", UIBaseContainer)
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
    path = "bgLow",
    name = "bgLow",
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

function UIDecorationStickerCellNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDecorationStickerCellNew:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickerCellNew:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDecorationStickerCellNew:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDecorationStickerCellNew:OnClick()
  if self.callback and self.index then
    self.callback(self.index)
    self.selectCom:SetActive(true)
  end
end

function UIDecorationStickerCellNew:OnDeleteBtnClick()
  self.initDecorationId = -1
  self:UpdateSticker(-1)
  self.stickersCom:SaveSticker()
  self.view:RefreshIconDecorations(DecorationType.DecorationType_Emoji)
end

function UIDecorationStickerCellNew:SetData(data, index, stickersCom, callback)
  self.data = data
  self.index = index
  self.stickersCom = stickersCom
  self.callback = callback
  self.initDecorationId = self.data.decorationId
  self:RefreshView()
end

function UIDecorationStickerCellNew:UpdateSticker(decorationId, isInit)
  if decorationId ~= self.data.decorationId or isInit then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    self.data.decorationId = decorationId
    self.data.template = template
    if template and template.customVariable and tonumber(template.customVariable) > 0 then
      local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
      self.bg:LoadSprite(bgPtah)
      self.bgLow:LoadSprite(markPath .. "ljq_daditubiaoqing_qipao_02")
      self.stickerIcon:LoadSprite(string.format(ChatStickerCoverPath, strickerTmp.name))
      self.stickerIcon:SetActive(true)
      self.stickerIcon:SetNativeSize()
      self.deleteBtn:SetActive(self.openType ~= MapStickerOpenType.Wrold)
    else
      self.bg:LoadSprite(markBgPtah)
      self.bgLow:LoadSprite(markPath .. "ljq_daditubiaoqing_qipao_kong_02")
      self.stickerIcon:SetActive(false)
      self.deleteBtn:SetActive(false)
    end
  end
end

function UIDecorationStickerCellNew:SaveStricker()
  self.initDecorationId = self.data.decorationId
end

function UIDecorationStickerCellNew:Restore()
  if self.initDecorationId ~= self.data.decorationId then
    self:UpdateSticker(self.initDecorationId)
  end
end

function UIDecorationStickerCellNew:SetOpenType(openType)
  self.openType = openType
  self:UpdateSticker(self.initDecorationId, true)
end

function UIDecorationStickerCellNew:UnSelect(isOn)
  self.selectCom:SetActive(isOn)
end

function UIDecorationStickerCellNew:RefreshView()
  self:UpdateSticker(self.data.decorationId, true)
end

return UIDecorationStickerCellNew
