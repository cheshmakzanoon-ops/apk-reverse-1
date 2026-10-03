local base = UIBaseContainer
local UIGhostParkourMainPlayerArrowItem = BaseClass("UIGhostParkourMainPlayerArrowItem", base)
local player_arrow_bg_root_path = "PlayerArrowBgRoot"
local arrow_img_path = "PlayerArrowBgRoot/ArrowImg"
local frame_img_path = "PlayerArrowBgRoot/FrameImg"
local dev_arrow_img_path = "PlayerArrowBgRoot/DevArrowImg"
local dev_frame_img_path = "PlayerArrowBgRoot/DevFrameImg"
local u_i_player_head_path = "UIPlayerHead"
local player_dis_text_path = "PlayerDisText"
local DEFAULT_TAG_COLOR = "#FFFFFF"
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
  self.player_arrow_bg_root = self:AddComponent(UIBaseContainer, player_arrow_bg_root_path)
  self.arrow_img = self:AddComponent(UIImage, arrow_img_path)
  self.frame_img = self:AddComponent(UIImage, frame_img_path)
  self.dev_arrow_img = self:AddComponent(UIImage, dev_arrow_img_path)
  self.dev_frame_img = self:AddComponent(UIImage, dev_frame_img_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(false)
  self.player_dis_text = self:AddComponent(UITextMeshProUGUIEx, player_dis_text_path)
end

local function ComponentDestroy(self)
  self.player_arrow_bg_root = nil
  self.arrow_img = nil
  self.frame_img = nil
  self.dev_arrow_img = nil
  self.dev_frame_img = nil
  self.u_i_player_head = nil
  self.player_dis_text = nil
end

function UIGhostParkourMainPlayerArrowItem:ReInit(data)
  if data == nil then
    self.arrow_img:SetActive(false)
    self.frame_img:SetActive(false)
    self.dev_arrow_img:SetActive(false)
    self.dev_frame_img:SetActive(false)
    self.u_i_player_head:SetHead()
    return
  end
  if data.isNpc then
    local meta = DataCenter.ParkourGhostNpcTemplateManager:GetTemplate(data.uid)
    if meta then
      if meta.type == 2 then
        self.arrow_img:SetActive(false)
        self.frame_img:SetActive(false)
        if CommonUtil.IsArabicAutoMirrorOpen() then
          self.dev_arrow_img:SetEulerAnglesXYZ(0, 0, 90)
        end
        self.dev_arrow_img:SetActive(true)
        self.dev_frame_img:SetActive(true)
        self.player_dis_text:SetColorHex(DEV_TAG_COLOR)
      else
        self.arrow_img:SetActive(true)
        if CommonUtil.IsArabicAutoMirrorOpen() then
          self.arrow_img:SetEulerAnglesXYZ(0, 0, 90)
        end
        self.frame_img:SetActive(true)
        self.dev_arrow_img:SetActive(false)
        self.dev_frame_img:SetActive(false)
        self.player_dis_text:SetColorHex(DEFAULT_TAG_COLOR)
      end
      local pic = meta.icon
      self.u_i_player_head:SetHead(nil, pic, nil, nil, nil)
    else
      self.player_dis_text:SetColorHex(DEFAULT_TAG_COLOR)
    end
  else
    self.arrow_img:SetActive(true)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.arrow_img:SetEulerAnglesXYZ(0, 0, 90)
    end
    self.frame_img:SetActive(true)
    self.dev_arrow_img:SetActive(false)
    self.dev_frame_img:SetActive(false)
    local uid = data.uid
    local pic = data.pic
    local picVer = data.picver
    self.u_i_player_head:SetHead(uid, pic, picVer, nil, nil)
    self.player_dis_text:SetColorHex(DEFAULT_TAG_COLOR)
  end
end

function UIGhostParkourMainPlayerArrowItem:SetArrowRotation(z, dis)
  self.player_arrow_bg_root:SetEulerAnglesXYZ(0, 0, z)
  dis = Mathf.Abs(dis)
  dis = Mathf.Floor(dis)
  if self.displayDis ~= dis then
    self.player_dis_text:SetLocalText("ghost_parkour_meter", dis)
    self.displayDis = dis
  end
end

UIGhostParkourMainPlayerArrowItem.OnCreate = OnCreate
UIGhostParkourMainPlayerArrowItem.OnDestroy = OnDestroy
UIGhostParkourMainPlayerArrowItem.ComponentDefine = ComponentDefine
UIGhostParkourMainPlayerArrowItem.ComponentDestroy = ComponentDestroy
return UIGhostParkourMainPlayerArrowItem
