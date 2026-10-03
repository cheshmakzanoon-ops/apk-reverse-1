local base = UIBaseContainer
local PlayerTitleDetailItem = BaseClass("PlayerTitleDetailItem", base)
local Localization = CS.GameEntry.Localization
local Bg_path = "Bg"
local BgBig_path = "BgBig"
local UIPlayerHead_path = "UIPlayerHead"
local TitleFrame_path = "TitleFrame"
local TitleItem_path = "TitleItem"
local BgDefault_path = "TitleItem/BgDefault"
local BgSmall_path = "TitleItem/BgSmall"
local titleIcon_path = "TitleItem/titleIcon"
local condition_path = "TitleItem/condition"
local name_path = "name"
local desc_path = "desc"
local achievement_path = "achievement"
local timeBg_path = "ert"
local timeText_path = "ert/timeText"
local btnMore_path = "btnMore"
local btnShare_path = "btnShare"
local DefaultDescHeight = 123
local DefaultInfoHeight = 684

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
  self.Bg = self:AddComponent(UIImage, Bg_path)
  self.BgBig = self:AddComponent(UIImage, BgBig_path)
  self.UIPlayerHead = self:AddComponent(UIBaseContainer, UIPlayerHead_path)
  self.TitleFrame = self:AddComponent(UIImage, TitleFrame_path)
  self.TitleItem = self:AddComponent(UIBaseContainer, TitleItem_path)
  self.BgDefault = self:AddComponent(UIImage, BgDefault_path)
  self.BgSmall = self:AddComponent(UIRawImage, BgSmall_path)
  self.titleIcon = self:AddComponent(UIImage, titleIcon_path)
  self.condition = self:AddComponent(UIText, condition_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.achievement = self:AddComponent(UIText, achievement_path)
  self.timeBg = self:AddComponent(UIBaseContainer, timeBg_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.btnMore = self:AddComponent(UIButton, btnMore_path)
  self.btnShare = self:AddComponent(UIButton, btnShare_path)
  self.info = self:AddComponent(UIBaseContainer, "")
  self.head = self:AddComponent(UICommonHead, UIPlayerHead_path)
  self.btnMore:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITitleMain, {anim = true})
  end)
  self.btnShare:SetOnClick(function()
    if self.cfg then
      DataCenter.PlayerInfoDataManager:ShareTitle(self.cfg.id, self.uid)
    end
  end)
end

local function ComponentDestroy(self)
  self.Bg = nil
  self.BgBig = nil
  self.UIPlayerHead = nil
  self.TitleFrame = nil
  self.TitleItem = nil
  self.BgDefault = nil
  self.BgSmall = nil
  self.titleIcon = nil
  self.condition = nil
  self.name = nil
  self.desc = nil
  self.achievement = nil
  self.timeBg = nil
  self.timeText = nil
  self.btnMore = nil
  self.btnShare = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function PlayerTitleDetailItem:ReInit(cfg, uid, detailData)
  if cfg == nil then
    return
  end
  self.uid = uid or 0
  self.cfg = cfg
  self.isSelf = self.uid == LuaEntry.Player.uid
  if string.IsNullOrEmpty(cfg.show_background) then
    self.BgBig:SetActive(false)
    self.Bg:SetActive(true)
  else
    self.BgBig:LoadSpriteAsyncEx(cfg.show_background)
    self.BgBig:SetActive(true)
    self.Bg:SetActive(false)
  end
  if string.IsNullOrEmpty(cfg.show_background_small) then
    self.BgSmall:SetActive(false)
    self.BgDefault:SetActive(true)
  else
    self.BgSmall:LoadSpriteAsync(cfg.show_background_small)
    self.BgSmall:SetActive(true)
    self.BgDefault:SetActive(false)
  end
  if string.IsNullOrEmpty(cfg.title_show_icon) then
    self.titleIcon:SetActive(false)
  else
    self.titleIcon:LoadSpriteAsyncEx(cfg.title_show_icon)
    self.titleIcon:SetActive(true)
  end
  self.name:SetLocalText(cfg.name)
  self.desc:SetLocalText(cfg.description)
  self.condition:SetLocalText(cfg.source)
  local preferredValues = self.condition.unity_tmpro:GetPreferredValues()
  if preferredValues.y > DefaultDescHeight then
    self.info.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y - DefaultDescHeight + DefaultInfoHeight)
  else
    self.info.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, DefaultInfoHeight)
  end
  local player = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.uid, true)
  if player ~= nil then
    self.head:SetActive(true)
    self.head:SetEnableClickShowInfo(true)
    self.head:ParseHeadInfo(player)
  else
    self.head:SetActive(false)
  end
  if string.IsNullOrEmpty(cfg.show_frame) then
    self.TitleFrame:SetActive(false)
  else
    self.TitleFrame:LoadSpriteAsyncEx(cfg.show_frame)
    self.TitleFrame:SetActive(true)
  end
  self.btnMore:SetActive(self.isSelf)
  self.btnShare:SetActive(self.isSelf)
  self:RefreshDetail(detailData)
end

function PlayerTitleDetailItem:RefreshDetail(detailData)
  if detailData then
    if detailData.cfgId ~= self.cfg.id then
      return
    end
    self.detailData = detailData
  end
  if self.detailData then
    self.endTime = self.detailData.endTime
    self.achievement:SetText(Localization:GetString("season_s3_title_desc_01", self.detailData.globalNum or 0, self.detailData.rank))
    self.achievement:SetColorHex(not string.IsNullOrEmpty(self.cfg.keyColor) and self.cfg.keyColor or "2A2830")
  else
    self.endTime = nil
    self.achievement:SetText("")
  end
  if self.isSelf and self.endTime and self.endTime > 0 then
    self.timeBg:SetActive(true)
    self:RefreshTime()
  else
    self.timeBg:SetActive(false)
  end
end

function PlayerTitleDetailItem:RefreshTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local time = math.max(self.endTime - now, 0)
  self.timeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
end

function PlayerTitleDetailItem:Update1000MS()
  if self.endTime then
    self:RefreshTime()
  end
end

PlayerTitleDetailItem.OnCreate = OnCreate
PlayerTitleDetailItem.OnDestroy = OnDestroy
PlayerTitleDetailItem.OnEnable = OnEnable
PlayerTitleDetailItem.OnDisable = OnDisable
PlayerTitleDetailItem.ComponentDefine = ComponentDefine
PlayerTitleDetailItem.ComponentDestroy = ComponentDestroy
PlayerTitleDetailItem.DataDefine = DataDefine
PlayerTitleDetailItem.DataDestroy = DataDestroy
return PlayerTitleDetailItem
