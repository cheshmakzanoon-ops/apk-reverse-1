local WorldMarchStickerCell = BaseClass("WorldMarchStickerCell")
local bgPtah = "Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_01.png"
local markBgPtah = "Assets/Main/Sprites/UI/LWUIWorldStickers/ljq_daditubiaoqing_qipao_kong_01.png"
local markPath = "Assets/Main/Sprites/UI/LWUIWorldStickers/"

function WorldMarchStickerCell:__init()
  self.marchTileUI = nil
  self.isOnCreate = false
end

function WorldMarchStickerCell:ReInit(stickerItem, data, index)
  if not stickerItem or not data then
    return
  end
  self.gameObject = stickerItem
  self.data = DeepCopy(data)
  self.index = index
  self:ComponentDefine()
  self:RefreshView()
end

function WorldMarchStickerCell:ComponentDefine()
  self.bg = self.gameObject.transform:Find("bg"):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.stickerIcon = self.gameObject.transform:Find("icon"):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.sticker_low = self.gameObject.transform:Find("sticker_low"):GetComponent(typeof(CS.UnityEngine.UI.Image))
  self.btn = self.gameObject:GetComponent(typeof(CS.UnityEngine.UI.Button))
  self.selectCom = self.gameObject.transform:Find("select").gameObject
  self.deletebtn = self.gameObject.transform:Find("deletebtn").gameObject
  
  function self.OnClcik()
    if not self.data or not self.data.template then
      WorldMarchTileUIManager:GetInstance():RemoveTroop()
      return
    end
    local isSend = DataCenter.LWSticker3DManager:SendMapSticker(WorldStickerType.March, self.data.marchUid, tonumber(self.data.template.customVariable))
    if not isSend then
      return
    end
    WorldMarchTileUIManager:GetInstance():RemoveTroop()
  end
  
  self.btn.onClick:AddListener(self.OnClcik)
  self.selectCom:SetActive(false)
  self.deletebtn:SetActive(false)
end

function WorldMarchStickerCell:RefreshView()
  self:UpdateSticker(self.data.decorationId, true)
end

function WorldMarchStickerCell:UpdateSticker(decorationId, isInit)
  if decorationId ~= self.data.decorationId or isInit then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    self.data.decorationId = decorationId
    self.data.template = template
    if template and template.customVariable and tonumber(template.customVariable) > 0 then
      self.bg:LoadSprite(bgPtah)
      self.sticker_low:LoadSprite(markPath .. self.data.markPath)
      local strickerTmp = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
      self.stickerIcon:LoadSprite(string.format(ChatStickerCoverPath, strickerTmp.name))
      self.stickerIcon:SetNativeSize()
      self.stickerIcon.gameObject:SetActive(true)
    else
      self.bg:LoadSprite(markBgPtah)
      self.sticker_low:LoadSprite(markPath .. self.data.emptyMarkPath)
      self.stickerIcon.gameObject:SetActive(false)
    end
  end
end

function WorldMarchStickerCell:__delete()
  self.btn.onClick:Clear()
end

return WorldMarchStickerCell
