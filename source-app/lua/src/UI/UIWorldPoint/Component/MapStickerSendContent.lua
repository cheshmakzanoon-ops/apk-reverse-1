local MapStickerSendContent = BaseClass("MapStickerSendContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MapStickerSendItem = require("UI.UIWorldPoint.Component.MapStickerSendItem")
local map_sticker_item_path = "stickerItem/mapStickerItem"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local set_btn_path = "SetBtn"
local p_text_empty_path = "p_text_empty"

function MapStickerSendContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MapStickerSendContent:OnDestroy()
  self:ClearAllItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MapStickerSendContent:ComponentDefine()
  self.map_sticker_item = self:AddComponent(UIButton, map_sticker_item_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.set_btn = self:AddComponent(UIButton, set_btn_path)
  self.p_text_empty = self:AddComponent(UITextMeshProUGUIEx, p_text_empty_path)
  self.set_btn:SetOnClick(function()
    self:OnClickSetBtn()
  end)
  self.map_sticker_item.gameObject:GameObjectCreatePool()
  self.itemList = {}
end

function MapStickerSendContent:ComponentDestroy()
  self.map_sticker_item = nil
  self.scroll_view = nil
  self.content = nil
  self.set_btn = nil
  self.p_text_empty = nil
end

function MapStickerSendContent:OnAddListener()
  base.OnAddListener(self)
end

function MapStickerSendContent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MapStickerSendContent:Refresh()
  self.content:SetAnchoredPositionXY(0, 0)
  self.expiredTime = nil
  self.data = {}
  local prefs = DataCenter.DecorationDataManager:GetStickerData()
  for i = 1, #prefs do
    local decorationId = prefs[i]
    local expireTime
    local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    if template then
      local stickerId = tonumber(template.customVariable)
      local decorationData = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
      if decorationData then
        expireTime = decorationData.expireTime
      else
        expireTime = DataCenter.ChatEmojiTemplateManager:TryGetStickerExpiredTime(stickerId)
        expireTime = expireTime and expireTime * 1000
      end
      if expireTime and (self.expiredTime == nil or expireTime < self.expiredTime) then
        self.expiredTime = expireTime
      end
      table.insert(self.data, {
        id = decorationId,
        expireTime = expireTime,
        stickerId = stickerId,
        index = i
      })
    end
  end
  self:RefreshView()
end

function MapStickerSendContent:ClearAllItem()
  self.content:RemoveComponents(MapStickerSendItem)
  self.map_sticker_item.gameObject:GameObjectRecycleAll()
  self.itemList = {}
end

function MapStickerSendContent:RefreshView()
  for i = 1, #self.data do
    local item = self.itemList[i]
    if item == nil then
      local obj = self.map_sticker_item.gameObject:GameObjectSpawn(self.content.transform)
      obj.name = "stickerItem" .. i
      item = self.content:AddComponent(MapStickerSendItem, obj.name)
      self.itemList[i] = item
    end
    item:SetActive(true)
    item:SetData(self.data[i])
  end
  for i = #self.data + 1, #self.itemList do
    self.itemList[i]:SetActive(false)
  end
  self.p_text_empty:SetActive(#self.data == 0)
end

function MapStickerSendContent:Update1000MS()
  if self.expiredTime == nil or self.expiredTime == 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.expiredTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  if leftTime == 0 then
    self:Refresh()
  end
end

function MapStickerSendContent:OnClickSetBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType.DecorationType_Emoji)
  self.view.ctrl:CloseSelf()
end

return MapStickerSendContent
