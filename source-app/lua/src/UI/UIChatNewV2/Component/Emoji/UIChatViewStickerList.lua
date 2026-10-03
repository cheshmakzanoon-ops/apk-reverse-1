local base = UIBaseContainer
local UIChatViewStickerList = BaseClass("UIChatViewStickerList", base)
local UIChatViewStickerItem = require("UI.UIChatNewV2.Component.Emoji.UIChatViewStickerItem")
local logger = require("Framework.Logger.Logger")
local goName = "Sticker"

function UIChatViewStickerList:OnCreate()
  base.OnCreate(self)
  self.stickerItem = self.transform:Find("StickerRoot").gameObject
  self.stickerItem:GameObjectCreatePool()
end

function UIChatViewStickerList:OnDestroy()
  self.stickerItem:GameObjectRecycleAll()
  self:RemoveComponents(UIChatViewStickerItem)
  base.OnDestroy(self)
end

function UIChatViewStickerList:ReInit(stickerData)
  if stickerData == nil or stickerData.list == nil then
    return
  end
  self.stickerItem:GameObjectRecycleAll()
  self:RemoveComponents(UIChatViewStickerItem)
  for i = 1, #stickerData.list do
    if 4 < i then
      return
    end
    if stickerData.list[i] == nil then
      logger.LogError("\232\129\138\229\164\169\232\161\168\230\131\133\231\154\132Sticker\232\161\140\231\154\132\230\149\176\230\141\174\228\184\186\231\169\186\239\188\129")
      return
    end
    local item = self.stickerItem:GameObjectSpawn(self.transform)
    item.name = goName .. i
    item:SetActive(true)
    local cellScript = self:GetComponent(item.name, UIChatViewStickerItem)
    if cellScript == nil then
      cellScript = self:AddComponent(UIChatViewStickerItem, item.name)
    end
    cellScript:ReInit(stickerData.list[i])
  end
end

function UIChatViewStickerList:UpdateItems()
end

return UIChatViewStickerList
