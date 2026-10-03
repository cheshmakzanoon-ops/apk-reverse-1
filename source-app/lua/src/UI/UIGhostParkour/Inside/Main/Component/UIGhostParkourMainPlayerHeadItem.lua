local base = UIBaseContainer
local UIGhostParkourMainPlayerHeadItem = BaseClass("UIGhostParkourMainPlayerHeadItem", base)
local arrow_path = "Arrow"
local dev_arrow_path = "DevArrow"
local u_i_player_head_path = "UIPlayerHead"
local frame_path = "Frame"
local dev_frame_path = "DevFrame"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.dev_arrow = self:AddComponent(UIImage, dev_arrow_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(false)
  self.frame = self:AddComponent(UIImage, frame_path)
  self.dev_frame = self:AddComponent(UIImage, dev_frame_path)
end

local function ComponentDestroy(self)
  self.arrow = nil
  self.dev_arrow = nil
  self.u_i_player_head = nil
  self.frame = nil
  self.dev_frame = nil
end

function UIGhostParkourMainPlayerHeadItem:ReInit(data)
  if data == nil then
    self.u_i_player_head:SetHead()
    self.arrow:SetActive(false)
    self.frame:SetActive(false)
    self.dev_arrow:SetActive(false)
    self.dev_frame:SetActive(false)
    return
  end
  if data.isNpc then
    local meta = DataCenter.ParkourGhostNpcTemplateManager:GetTemplate(data.uid)
    if meta then
      if meta.type == 2 then
        self.arrow:SetActive(false)
        self.frame:SetActive(false)
        self.dev_arrow:SetActive(true)
        self.dev_frame:SetActive(true)
      else
        self.arrow:SetActive(true)
        self.frame:SetActive(true)
        self.dev_arrow:SetActive(false)
        self.dev_frame:SetActive(false)
      end
      local pic = meta.icon
      self.u_i_player_head:SetHead(nil, pic, nil, nil, nil)
    else
      self.u_i_player_head:SetHead()
      self.arrow:SetActive(false)
      self.frame:SetActive(false)
      self.dev_arrow:SetActive(false)
      self.dev_frame:SetActive(false)
    end
  else
    self.arrow:SetActive(true)
    self.frame:SetActive(true)
    self.dev_arrow:SetActive(false)
    self.dev_frame:SetActive(false)
    local uid = data.uid
    local pic = data.pic
    local picVer = data.picver
    self.u_i_player_head:SetHead(uid, pic, picVer, nil, nil)
  end
end

UIGhostParkourMainPlayerHeadItem.OnCreate = OnCreate
UIGhostParkourMainPlayerHeadItem.OnDestroy = OnDestroy
UIGhostParkourMainPlayerHeadItem.ComponentDefine = ComponentDefine
UIGhostParkourMainPlayerHeadItem.ComponentDestroy = ComponentDestroy
return UIGhostParkourMainPlayerHeadItem
