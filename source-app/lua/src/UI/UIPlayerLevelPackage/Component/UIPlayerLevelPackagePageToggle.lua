local UIPlayerLevelPackagePageToggle = BaseClass("UIPlayerLevelPackagePageToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local backGround_img_path = "Root/Preview/BackGround"
local heroSpineContainer_path = "Root/Preview/HeroSpineContainer"
local foreGround_img_path = "Root/Preview/ForeGround"
local name_txt_path = "Root/NameBg/NameMask/NameText"
local frame_img_path = "Root/FrameBg"
local selected_img_path = "Root/SelectedFrameBg"
local new_dot_path = "Root/NewDot"
local QUEST_ENTRY_WIDTH_LIMIT = 220
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 3

local function OnCreate(self)
  base.OnCreate(self)
  self.backGround_img = self:AddComponent(UIRawImage, backGround_img_path)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainer_path)
  self.foreGround_img = self:AddComponent(UIRawImage, foreGround_img_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.name_rectTransform = self.transform:Find(name_txt_path):GetComponent(UnityRectTransform)
  self.frame_img = self:AddComponent(UIImage, frame_img_path)
  self.selected_img = self:AddComponent(UIImage, selected_img_path)
  self:SetSelected(false)
  self.button = self:AddComponent(UIButton, "Root")
  self.button:SetOnClick(function()
    self:OnClick()
  end)
  self.newDot = self:AddComponent(UIBaseComponent, new_dot_path)
end

local function OnDestroy(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.backGround_img = nil
  self.heroSpineContainer = nil
  self.foreGround_img = nil
  self.name_txt = nil
  self.frame_img = nil
  self.selected_img = nil
  self.name_rectTransform = nil
  base.OnDestroy(self)
end

local defaultForeGroundSize = Vector2.New(230, 141)

local function SetData(self, rechargeId, listIndex, sourceType)
  self.rechargeId = rechargeId
  self.listIndex = listIndex
  self.sourceType = sourceType
  local showData = DataCenter.RechargeManager:GetGiftShowDataById(self.rechargeId)
  local rechargeTemplate = DataCenter.RechargeManager:GetLine(self.rechargeId)
  if showData == nil or rechargeTemplate == nil then
    self.backGround_img:SetActive(false)
    self.foreGround_img:SetActive(false)
    self.name_txt:SetText("")
    return
  end
  self.name_txt:SetLocalText(rechargeTemplate.name)
  local bgPath = showData.banner_bg_new
  if not string.IsNullOrEmpty(bgPath) then
    self.backGround_img:SetActive(true)
    self.backGround_img:LoadSpriteAsync(string.format(LoadPath.UIPopPackBackGround, bgPath))
  else
    self.backGround_img:SetActive(false)
  end
  local foreGroundPath = showData.banner or ""
  if not string.IsNullOrEmpty(foreGroundPath) then
    self.foreGround_img:SetActive(true)
    self.foreGround_img:LoadSpriteAsync(string.format(LoadPath.UIPopPackForeGround, foreGroundPath))
    self.foreGround_img:SetSizeDelta(defaultForeGroundSize)
  else
    local foreGroundPath = showData.banner_pic_new[2] or ""
    if not string.IsNullOrEmpty(foreGroundPath) then
      self.foreGround_img:SetActive(true)
      self.foreGround_img:LoadSpriteAsync(string.format(LoadPath.UIPopPackForeGround, foreGroundPath))
      local sizeX = 420
      if showData.banner_pic_init_size[1] then
        sizeX = tonumber(showData.banner_pic_init_size[1]) * 0.6
      end
      local sizeY = 189.6
      if showData.banner_pic_init_size[2] then
        sizeY = tonumber(showData.banner_pic_init_size[2]) * 0.6
      end
      self.foreGround_img.rectTransform:Set_sizeDelta(sizeX, sizeY)
    else
      self.foreGround_img:SetActive(false)
    end
  end
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = UIUtil.SetTMPHorseRaceLamp(self.name_txt, QUEST_ENTRY_WIDTH_LIMIT, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.name_rectTransform)
  self:RefreshNewTag()
end

local function SetSelected(self, selected)
  self.selected_img:SetActive(selected)
end

local function OnClick(self)
  if self.rechargeId and self.onClickToggle then
    self.onClickToggle(self.listIndex, self)
    local rechargeTemplate = DataCenter.RechargeManager:GetLine(self.rechargeId)
    if rechargeTemplate ~= nil then
      local packageInfo
      local packages = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeTemplate.id)
      if not table.IsNullOrEmpty(packages) then
        packageInfo = packages[1]
      end
      if packageInfo ~= nil then
        Logger.LogCustom("UIPlayerLevelPackagePageToggle Click, recharge: " .. self.rechargeId .. ", exchange: " .. packageInfo:getID())
      end
    end
  end
end

function UIPlayerLevelPackagePageToggle:InitCallback(onClickToggle)
  self.onClickToggle = onClickToggle
end

function UIPlayerLevelPackagePageToggle:RefreshNewTag()
  self.newDot:SetActive(false)
end

UIPlayerLevelPackagePageToggle.OnCreate = OnCreate
UIPlayerLevelPackagePageToggle.OnDestroy = OnDestroy
UIPlayerLevelPackagePageToggle.SetData = SetData
UIPlayerLevelPackagePageToggle.SetSelected = SetSelected
UIPlayerLevelPackagePageToggle.OnClick = OnClick
return UIPlayerLevelPackagePageToggle
