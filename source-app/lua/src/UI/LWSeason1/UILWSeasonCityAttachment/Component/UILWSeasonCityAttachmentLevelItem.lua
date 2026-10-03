local UILWSeasonCityAttachmentLevelItem = BaseClass("UILWSeasonCityAttachmentLevelItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local build_cell_path = "bg"
local icon_path = "icon"
local lock_icon_path = "icon/lockIcon"
local title_path = "title"
local info_btn_path = "InfoBtn"
local line_bg_top_path = "LineBgTop"
local line_bg_bottom_path = "LineBgBottom"
local line_bg_path = "LineBg"
local line_icon_path = "LineIcon"
local level_path = "LineIcon/level"

function UILWSeasonCityAttachmentLevelItem:OnCreate()
  base.OnCreate(self)
  self.bg_dark = self:AddComponent(UIImage, "bgDark")
  self.bg = self:AddComponent(UIImage, build_cell_path)
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.line_bg_top = self:AddComponent(UIImage, line_bg_top_path)
  self.line_bg_bottom = self:AddComponent(UIImage, line_bg_bottom_path)
  self.line_bg = self:AddComponent(UIImage, line_bg_path)
  self.line_icon = self:AddComponent(UIImage, line_icon_path)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.info_btn:SetOnClick(function()
    if self.buildData then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityAttachmentDetail, {anim = true}, self.buildData.cfgId)
    end
  end)
end

function UILWSeasonCityAttachmentLevelItem:OnDestroy()
  self.bg = nil
  self.icon = nil
  self.lock_icon = nil
  self.title = nil
  self.info_btn = nil
  self.line_bg_top = nil
  self.line_bg_bottom = nil
  self.line_bg = nil
  self.line_icon = nil
  self.level = nil
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentLevelItem:ReInit(index, expData, lock, dataCount, myLevel, dataPre)
  local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(expData.unlockBuildId)
  if buildData then
    self.buildData = buildData
    self.title:SetText(Localization:GetString(buildData.name) .. " \195\151 " .. expData.unlockCount)
    self.icon:LoadSprite(buildData.icon)
    self.level:SetText(expData.level)
    self.lock_icon:SetActive(lock)
    if lock then
      self.icon:SetColorRGBA255(128, 128, 128, 255)
      self.line_icon:SetColorRGBA255(128, 128, 128, 255)
    else
      self.icon:SetColorRGBA255(255, 255, 255, 255)
      self.line_icon:SetColorRGBA255(255, 255, 255, 255)
    end
  end
  self.bg_dark:SetActive(lock)
  self.bg:SetActive(index % 2 == 1)
  self.line_bg:SetActive(index ~= 1 and index ~= dataCount)
  self.line_bg_top:SetActive(index == 1)
  self.line_bg_bottom:SetActive(index == dataCount)
  self.expData = expData
  self.theLevel = expData.level
  if lock then
    if dataPre == nil or myLevel >= dataPre.level and myLevel < expData.level then
      self.bg_dark:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/farmer/zxl_jianshe_weijiesuo1.png")
    elseif dataPre ~= nil and myLevel < dataPre.level then
      if index == dataCount then
        self.bg_dark:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/farmer/zxl_jianshe_weijiesuo3.png")
      else
        self.bg_dark:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/farmer/zxl_jianshe_weijiesuo2.png")
      end
    end
  end
end

return UILWSeasonCityAttachmentLevelItem
