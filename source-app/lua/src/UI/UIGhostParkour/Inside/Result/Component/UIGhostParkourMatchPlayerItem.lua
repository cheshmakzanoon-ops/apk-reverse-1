local base = UIBaseContainer
local UIGhostParkourMatchPlayerItem = BaseClass("UIGhostParkourMatchPlayerItem", base)
local bg_path = "ClickRoot/Bg"
local u_i_player_head_path = "ClickRoot/UIPlayerHead"
local click_root_path = "ClickRoot"
local rank_icon_path = "ClickRoot/RankIcon"
local rank_text_path = "ClickRoot/RankText"
local name_text_path = "ClickRoot/NameText"
local score_text_path = "ClickRoot/ScoreText"
local score_icon_path = "ClickRoot/ScoreIcon"
local DEFAULT_TAG_COLOR = "#AB6100"
local DEV_TAG_COLOR = "#F97077"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(false)
  self.click_root = self:AddComponent(UIButton, click_root_path)
  self.click_root:SetOnClick(function()
    self:OnItemClick()
  end)
  self.rank_icon = self:AddComponent(UIRawImage, rank_icon_path)
  self.rank_text = self:AddComponent(UITextMeshProUGUIEx, rank_text_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
  self.score_icon = self:AddComponent(UIImage, score_icon_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.u_i_player_head = nil
  self.click_root = nil
  self.rank_icon = nil
  self.rank_text = nil
  self.name_text = nil
  self.score_text = nil
  self.score_icon = nil
end

function UIGhostParkourMatchPlayerItem:ReInit(index, data, score, goodsId)
  self.isDev = false
  if data then
    self.rank_text:SetText(index)
    if data.isNpc then
      local meta = DataCenter.ParkourGhostNpcTemplateManager:GetTemplate(data.uid)
      if meta then
        local pic = meta.icon
        self.u_i_player_head:SetHead(nil, pic, nil, nil, nil)
        self.name_text:SetLocalText(meta.name)
        if meta.type == 2 then
          self.isDev = true
          self.name_text:SetColorHex(DEV_TAG_COLOR)
        else
          self.name_text:SetColorHex(DEFAULT_TAG_COLOR)
        end
      else
        self.u_i_player_head:SetHead()
        self.name_text:SetText("")
      end
    else
      local uid = data.uid
      local pic = data.pic
      local picVer = data.picver
      self.u_i_player_head:SetHead(uid, pic, picVer, nil, nil)
      self.name_text:SetText(data.name)
      self.name_text:SetColorHex(DEFAULT_TAG_COLOR)
    end
  else
    self.u_i_player_head:SetHead()
    self.name_text:SetText("")
  end
  if score and 0 < score then
    self.score_text:SetText("+" .. score)
    local itemTemplate = DataCenter.ItemTemplateManager:TryGetItemTemplate(goodsId)
    if itemTemplate then
      local iconUrl = string.format(LoadPath.ItemPath, itemTemplate.icon)
      self.score_icon:SetActive(true)
      self.score_icon:LoadSpriteAuto(iconUrl)
    end
  else
    self.score_text:SetText("")
    self.score_icon:SetActive(false)
  end
end

function UIGhostParkourMatchPlayerItem:OnItemClick()
  if self.isDev then
    DataCenter.LWBattleManager:ShowTipsId("ghost_parkour_dev_tips")
  end
end

UIGhostParkourMatchPlayerItem.OnCreate = OnCreate
UIGhostParkourMatchPlayerItem.OnDestroy = OnDestroy
UIGhostParkourMatchPlayerItem.ComponentDefine = ComponentDefine
UIGhostParkourMatchPlayerItem.ComponentDestroy = ComponentDestroy
return UIGhostParkourMatchPlayerItem
