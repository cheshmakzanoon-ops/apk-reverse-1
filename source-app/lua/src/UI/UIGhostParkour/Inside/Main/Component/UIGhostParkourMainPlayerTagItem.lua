local base = UIBaseContainer
local UIGhostParkourMainPlayerTagItem = BaseClass("UIGhostParkourMainPlayerTagItem", base)
local player_name_text_path = "PlayerNameText"
local tag_img_path = "TagImg"
local dev_tag_img_path = "DevTagImg"
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
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.tag_img = self:AddComponent(UIImage, tag_img_path)
  self.dev_tag_img = self:AddComponent(UIImage, dev_tag_img_path)
end

local function ComponentDestroy(self)
  self.player_name_text = nil
  self.tag_img = nil
  self.dev_tag_img = nil
end

function UIGhostParkourMainPlayerTagItem:ReInit(data)
  if data == nil then
    self.player_name_text:SetText("")
    self.tag_img:SetActive(false)
    self.dev_tag_img:SetActive(false)
    return
  end
  if data.isNpc then
    local meta = DataCenter.ParkourGhostNpcTemplateManager:GetTemplate(data.uid)
    if meta then
      self.player_name_text:SetLocalText(meta.name)
      if meta.type == 2 then
        self.player_name_text:SetColorHex(DEV_TAG_COLOR)
        self.tag_img:SetActive(false)
        self.dev_tag_img:SetActive(true)
      else
        self.player_name_text:SetColorHex(DEFAULT_TAG_COLOR)
        self.tag_img:SetActive(true)
        self.dev_tag_img:SetActive(false)
      end
    end
  else
    self.player_name_text:SetText(data.name)
    self.player_name_text:SetColorHex(DEFAULT_TAG_COLOR)
    self.tag_img:SetActive(true)
    self.dev_tag_img:SetActive(false)
  end
end

UIGhostParkourMainPlayerTagItem.OnCreate = OnCreate
UIGhostParkourMainPlayerTagItem.OnDestroy = OnDestroy
UIGhostParkourMainPlayerTagItem.ComponentDefine = ComponentDefine
UIGhostParkourMainPlayerTagItem.ComponentDestroy = ComponentDestroy
return UIGhostParkourMainPlayerTagItem
