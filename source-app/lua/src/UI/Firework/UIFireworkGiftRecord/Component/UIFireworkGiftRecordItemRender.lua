local base = UIBaseContainer
local UIFireworkGiftRecordItemRender = BaseClass("UIFireworkGiftRecordItemRender", base)
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local player_level_text_path = "HorLayout/PlayerLevelText"
local player_gender_icon_path = "HorLayout/PlayerLevelText/PlayerGenderIcon"
local player_name_text_path = "PlayerNameText"
local speed_tips_text_path = "SpeedTipsText"
local speed_text_path = "SpeedText"
local double_mark_path = "DoubleMark"
local uiCommonResItem_path = "UICommonResItem"
local player_head_path = "PlayerHead"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.player_level_text = self:AddComponent(UIText, player_level_text_path)
  self.player_gender_icon = self:AddComponent(UIImage, player_gender_icon_path)
  self.player_name_text = self:AddComponent(UIText, player_name_text_path)
  self.speed_tips_text = self:AddComponent(UIText, speed_tips_text_path)
  self.speed_text = self:AddComponent(UIText, speed_text_path)
  self.double_mark = self:AddComponent(UIImage, double_mark_path)
  self.uiCommonResItem = self:AddComponent(UIBaseContainer, uiCommonResItem_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.uiCommonResItem = self:AddComponent(UICommonResItem, uiCommonResItem_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.player_level_text = nil
  self.player_gender_icon = nil
  self.player_name_text = nil
  self.speed_tips_text = nil
  self.speed_text = nil
  self.double_mark = nil
  self.uiCommonResItem = nil
  self.player_head = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIFireworkGiftRecordItemRender:ReInit(data)
  self.data = data
  if self.data.uid == LuaEntry.Player.uid then
    self.bg:SetColorRGBA(0.6862, 1, 0.3725, 0.5019)
  else
    self.bg:SetColorRGBA(1, 1, 1, 0.5)
  end
  self.player_head:SetHeadAndFrame(self.data.uid, self.data.pic, self.data.picVer, nil, self.data.headSkinId, self.data.headSkinET)
  self.player_head:SetEnableClickShowInfo(true, true)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.player_name_text:SetText(showName)
  self.double_mark:SetActive(self.data.isDouble)
  if self.data.gender == 0 or self.data.gender == 3 then
    self.player_gender_icon:SetActive(false)
  else
    self.player_gender_icon:SetActive(true)
    local gender_img_path = "Assets/Main/Sprites/UI/UILWAlliance/"
    self.player_gender_icon:LoadSprite(gender_img_path .. (self.data.gender == 2 and "cfm_lianmeng_tubiao_nv" or "cfm_lianmeng_tubiao_nan"))
  end
  if self.data.rewardInfo then
    local params = string.split(data.rewardInfo, ";")
    local reward = {}
    reward.rewardType = tonumber(params[1])
    reward.itemId = params[2]
    reward.count = tonumber(params[3])
    self.uiCommonResItem:ReInit(reward)
  end
end

UIFireworkGiftRecordItemRender.OnCreate = OnCreate
UIFireworkGiftRecordItemRender.OnDestroy = OnDestroy
UIFireworkGiftRecordItemRender.OnEnable = OnEnable
UIFireworkGiftRecordItemRender.OnDisable = OnDisable
UIFireworkGiftRecordItemRender.ComponentDefine = ComponentDefine
UIFireworkGiftRecordItemRender.ComponentDestroy = ComponentDestroy
UIFireworkGiftRecordItemRender.DataDefine = DataDefine
UIFireworkGiftRecordItemRender.DataDestroy = DataDestroy
return UIFireworkGiftRecordItemRender
