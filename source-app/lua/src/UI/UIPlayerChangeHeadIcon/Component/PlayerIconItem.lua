local PlayerIconItem = BaseClass("PlayerIconItem", UIBaseContainer)
local base = UIBaseContainer
local img_path = "PhotoBtn/PhotoBg"
local img_bg_path = "PhotoBtn/headBg"
local head_red_pot_path = "PhotoBtn/ModifyHeadRedPot"
local img_btn_path = ""
local img_select_path = "Select"
local use_select_txt = "Bg/Desc"
local use_select_bg = "Bg"
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self, data)
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, img_path)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.btn = self:AddComponent(UIButton, img_btn_path)
  self.selectImg = self:AddComponent(UIImage, img_select_path)
  self.useTxt = self:AddComponent(UIText, use_select_txt)
  self.useBg = self:AddComponent(UIImage, use_select_bg)
  self.head_red_pot = self:AddComponent(UIBaseContainer, head_red_pot_path)
  self.useBg:SetActive(false)
end

local function SetItemShow(self, data)
  self.itemData = data
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local itemID = self.itemData.id
    if itemID == CustomizeAvatarId then
      Setting:SetInt(LuaEntry.Player.uid .. LuaEntry.Player.pushMark .. SettingKeys.FIRST_PAY_BUY_CLICK, 0)
      EventManager:GetInstance():Broadcast(EventId.PlayerChangeHeadRedPot)
      self.head_red_pot:SetActive(LuaEntry.Player:ShowPlayerChangeHeadRedPot() == true)
      self.view.ctrl:OnGotoClick(self.itemData.id)
    end
    EventManager:GetInstance():Broadcast(EventId.ChangeNameIcon_Select, itemID ~= CustomizeAvatarId and self.itemData.picName or nil)
  end)
  local useIcon = "Assets/Main/Sprites/UI/UIHeadIcon/" .. self.itemData.picName .. ".png"
  if self.itemData.id == CustomizeAvatarId then
    UIGray.SetGray(self.img_bg.transform, true, true)
    self.img:LoadSprite("Assets/Main/Sprites/UI/UISet/New/zyf_touxiang_shaungchuantouxiang.png")
    self.head_red_pot:SetActive(LuaEntry.Player:ShowPlayerChangeHeadRedPot() == true)
    self.img:SetSizeDelta(Vector2.New(134, 139))
  else
    UIGray.SetGray(self.img_bg.transform, false, true)
    self.img:LoadSprite(useIcon)
    self.head_red_pot:SetActive(false)
    self.img:SetSizeDelta(Vector2.New(112, 112))
  end
  local pic = LuaEntry.Player:GetFullPic()
  if pic == useIcon then
    self.selectImg:SetActive(true)
    self.useBg:SetActive(true)
    self.useTxt:SetLocalText(128133)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnCancelSelect(self, picName)
  if self.itemData.id == CustomizeAvatarId then
    self.selectImg:SetActive(picName == nil or picName == "")
    return
  end
  self.selectImg:SetActive(picName == self.itemData.picName)
end

local function OnDisable(self)
  if self.selectImg ~= nil then
    self.selectImg:SetActive(false)
  end
  base.OnDisable(self)
end

local function OnDestroy(self)
  self.img = nil
  self.img_bg = nil
  self.btn = nil
  self.selectImg = nil
  self.useTxt = nil
  self.useBg = nil
  self.head_red_pot = nil
  self.itemData = nil
  base.OnDestroy(self)
end

local function OnRefreshPlayerIcon(self, pic)
  self.useBg:SetActive(self.itemData.picName == pic)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.ChangeNameIcon_Select, self.OnCancelSelect)
  self:AddUIListener(EventId.UpdatePlayerHeadIcon, self.OnRefreshPlayerIcon)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChangeNameIcon_Select, self.OnCancelSelect)
  self:RemoveUIListener(EventId.UpdatePlayerHeadIcon, self.OnRefreshPlayerIcon)
  base.OnRemoveListener(self)
end

PlayerIconItem.OnCreate = OnCreate
PlayerIconItem.OnDestroy = OnDestroy
PlayerIconItem.OnEnable = OnEnable
PlayerIconItem.OnDisable = OnDisable
PlayerIconItem.SetItemShow = SetItemShow
PlayerIconItem.OnAddListener = OnAddListener
PlayerIconItem.OnRemoveListener = OnRemoveListener
PlayerIconItem.OnCancelSelect = OnCancelSelect
PlayerIconItem.OnRefreshPlayerIcon = OnRefreshPlayerIcon
return PlayerIconItem
