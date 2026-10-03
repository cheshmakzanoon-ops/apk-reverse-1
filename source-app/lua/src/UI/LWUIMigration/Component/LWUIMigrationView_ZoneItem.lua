local LWUIMigrationView_ZoneItem = BaseClass("LWUIMigrationView_ZoneItem", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "House/homeIcon"
local img_server_path = "House/ServerBg"
local txt_server_path = "House/ServerBg/ServerTxt"
local img_state_path = "House/ServerState"
local text_state_path = "House/ServerState/StateTxt"
local head_path = "head"
local player_path = "head/P/Player"
local praise_path = "head/Praise"
local text_num_path = "head/Praise/NumText"
local btn_path = "Btn"
local IMG_STATE_OPEN = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_zhuye_open.png"
local IMG_STATE_OPEN2 = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_zhuye_open2.png"
local IMG_STATE_CLOSE = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_zhuye_close.png"
local IMG_S_BG = "Assets/Main/Sprites/UI/LWUIMigration/lrb_zhanqvduijue_fuwuqibg0%d.png"

function LWUIMigrationView_ZoneItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.img_server = self:AddComponent(UIImage, img_server_path)
  self.text_server = self:AddComponent(UIText, txt_server_path)
  self.img_state = self:AddComponent(UIImage, img_state_path)
  self.text_state = self:AddComponent(UIText, text_state_path)
  self.playerRoot = self:AddComponent(UIBaseComponent, head_path)
  self.playerRoot:SetActive(false)
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.playerUI:SetEnableClickShowInfo(true, true)
  self.praise = self:AddComponent(UIBaseComponent, praise_path)
  self.text_num = self:AddComponent(UIText, text_num_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

function LWUIMigrationView_ZoneItem:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_ZoneItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.clickCb then
    self.clickCb()
  elseif self.serverInfo then
    EventManager:GetInstance():Broadcast(EventId.ActMigrationUITabSel, {
      tab = 2,
      ext = self.serverInfo.serverId
    })
  end
end

function LWUIMigrationView_ZoneItem:SetData(serverInfo, showState)
  self.serverInfo = serverInfo
  self.text_server:SetText("#" .. serverInfo.serverId)
  local idx = serverInfo.serverId == LuaEntry.Player:GetSourceServerId() and 2 or 1
  self.img_server:LoadSpriteAuto(string.format(IMG_S_BG, idx))
  local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(serverInfo.cfgId)
  if itemCfg ~= nil then
    self.icon:LoadSpriteAuto(string.format(LoadPath.ItemPath, itemCfg.icon))
  end
  local sState = serverInfo.serverState or 0
  self.img_state:SetActive(showState and 0 < sState)
  if showState and 0 < sState then
    local img, key, r, g, b
    if sState == 1 then
      img = IMG_STATE_OPEN2
      key = "migration_activity_interface_10039"
      r = 125
      g = 40
      b = 10
    elseif sState == 2 then
      img = IMG_STATE_OPEN
      key = "migration_activity_interface_10040"
      r = 150
      g = 72
      b = 19
    elseif sState == 3 then
      img = IMG_STATE_CLOSE
      key = "migration_activity_interface_10111"
      r = 79
      g = 76
      b = 81
    end
    self.img_state:LoadSpriteAuto(img)
    self.text_state:SetLocalText(key)
    self.text_state:SetColorRGBA255(r, g, b, 255)
  end
end

function LWUIMigrationView_ZoneItem:EnableClick(bEnable)
  self.btn:SetInteractable(bEnable)
end

function LWUIMigrationView_ZoneItem:SetClickCb(cb)
  self.clickCb = cb
end

function LWUIMigrationView_ZoneItem:ShowPlayer(bShowPraise)
  local playerInfo = self.serverInfo ~= nil and self.serverInfo.presidentInfo or nil
  if not playerInfo then
    self.playerRoot:SetActive(false)
    return
  end
  self.playerRoot:SetActive(true)
  self.playerUI:ParseHeadInfo(playerInfo)
  self.playerUI:SetFlag(playerInfo.flag)
  self.praise:SetActive(bShowPraise)
  if bShowPraise then
    self.text_num:SetText(playerInfo.praise)
  end
end

function LWUIMigrationView_ZoneItem:HidePlayer()
  self.playerRoot:SetActive(false)
end

return LWUIMigrationView_ZoneItem
