local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_StorageShopShare = BaseClass("StorageShopShare", IChatItemPost)
local base = IChatItemPost
local chatShareNode_path = ""
local shareTitle_path = "Image/ShareTitle"
local slots_path = "slots/slot_"

function ChatItemPost_StorageShopShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_StorageShopShare:ComponentDefine()
  self.chatShareNodeN = self:AddComponent(UIBaseContainer, chatShareNode_path)
  self.shareTitleN = self:AddComponent(UIText, shareTitle_path)
  self.shareBtnN = self:AddComponent(UIButton, chatShareNode_path)
  self.shareBtnN:SetOnClick(function()
    self:OnClickBg()
  end)
  self.slotItemsTb = {}
  for i = 1, 4 do
    local tempPath = slots_path .. i
    local newSlot = {}
    local slot = self:AddComponent(UIBaseContainer, tempPath)
    local goodsIcon = slot:AddComponent(UIImage, "goods/iconImage")
    local goodsCount = slot:AddComponent(UIText, "goods/NumText")
    newSlot.rootN = slot
    newSlot.goodsIconN = goodsIcon
    newSlot.goodsCountN = goodsCount
    table.insert(self.slotItemsTb, newSlot)
  end
end

function ChatItemPost_StorageShopShare:OnClickBg()
  if not DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.FUN_BUILD_KONBINI, 1) then
    return UIUtil.ShowTipsId(121375)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
  local pointId = self.attachInfo.tradePoint
  local playerUid = self.attachInfo.uid
  if playerUid and tonumber(playerUid) > 0 then
    DataCenter.StorageShopManager:SetOtherShopBase(playerUid, self.attachInfo.tradeName, self.attachInfo.sid)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, playerUid)
  else
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(pointId), CS.SceneManager.World.InitZoom)
  end
end

function ChatItemPost_StorageShopShare:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self.attachInfo = chatdata:getMessageParam(false)
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self.chatNameLayoutN then
    self.chatNameLayoutN:UpdateName(_userInfo, chatdata)
  end
  self.shareTitleN:SetLocalText(141046, _userInfo.userName)
  for i, v in ipairs(self.slotItemsTb) do
    if i <= #self.attachInfo.slots then
      v.rootN:SetActive(true)
      local itemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.attachInfo.slots[i].itemId)
      v.goodsIconN:LoadSprite(string.format(LoadPath.ItemPath, itemTemplate.pic))
      v.goodsCountN:SetText(self.attachInfo.slots[i].count .. "x")
    else
      v.rootN:SetActive(false)
    end
  end
  if #self.attachInfo.slots == 4 then
    self.chatShareNodeN:SetSizeDelta(Vector2(392, self.chatShareNodeN:GetSizeDelta().y))
  else
    self.chatShareNodeN:SetSizeDelta(Vector2(322, self.chatShareNodeN:GetSizeDelta().y))
  end
  self:UpdateTopOffset()
end

function ChatItemPost_StorageShopShare:GetTopOffset()
  if self.chatNameLayoutN then
    return self.chatNameLayoutN:GetTopOffset()
  else
    return 0
  end
end

function ChatItemPost_StorageShopShare:UpdateTopOffset()
  local initOffset = 40
  local topOffset = self:GetTopOffset()
  local sizeX, sizeY = self.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(sizeX, sizeY + topOffset)
  self:SetTransPosY(self.chatShareNodeN.rectTransform, -(initOffset + topOffset))
end

function ChatItemPost_StorageShopShare:OnRecycle()
end

return ChatItemPost_StorageShopShare
