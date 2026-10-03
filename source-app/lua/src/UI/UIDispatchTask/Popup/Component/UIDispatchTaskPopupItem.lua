local UIDispatchTaskPopupItem = BaseClass("UIDispatchTaskPopupItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local toggle_path = "toggle"
local icon_bg_path = "IconBg"
local icon_path = "IconBg/Icon"
local task_level_path = "IconBg/taskLevel"
local txt_title_path = "txtTitle"
local time_title_path = "timeTitle"
local cd_text_path = "time/cdText"
local lack_tip_path = "lackTip"
local hero_content_path = "heroContent"
local u_i_hero_cell_small1_path = "heroContent/dispatchHero1/UIHeroCellSmall1"
local u_i_hero_cell_small2_path = "heroContent/dispatchHero2/UIHeroCellSmall2"
local u_i_hero_cell_small3_path = "heroContent/dispatchHero3/UIHeroCellSmall3"

function UIDispatchTaskPopupItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDispatchTaskPopupItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskPopupItem:ComponentDefine()
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.task_level = self:AddComponent(UITextMeshProUGUIEx, task_level_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.time_title = self:AddComponent(UITextMeshProUGUIEx, time_title_path)
  self.cd_text = self:AddComponent(UITextMeshProUGUIEx, cd_text_path)
  self.lack_tip = self:AddComponent(UITextMeshProUGUIEx, lack_tip_path)
  self.time_title:SetText(Localization:GetString("dispatch_des010"))
  self.hero_content = self:AddComponent(UIBaseContainer, hero_content_path)
  self.u_i_hero_cell_small1 = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small1_path)
  self.u_i_hero_cell_small2 = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small2_path)
  self.u_i_hero_cell_small3 = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small3_path)
  self.toggle:SetIsOnWithoutNotify(false)
  self.toggle:SetOnValueChanged(function(tf)
    self:OnSelectStateChange(tf)
  end)
end

function UIDispatchTaskPopupItem:ComponentDestroy()
  self.toggle = nil
  self.icon_bg = nil
  self.icon = nil
  self.task_level = nil
  self.txt_title = nil
  self.time_title = nil
  self.cd_text = nil
  self.lack_tip = nil
  self.hero_content = nil
  self.u_i_hero_cell_small1 = nil
  self.u_i_hero_cell_small2 = nil
  self.u_i_hero_cell_small3 = nil
end

function UIDispatchTaskPopupItem:Refresh(data)
  self.data = data
  self.toggle:SetIsOn(data.selected)
  local info = data.taskInfo
  self.info = info
  if info and info.cfg then
    if not string.IsNullOrEmpty(self.info.cfg.icon) then
      self.icon:LoadSprite(self.info.cfg.icon)
    end
    self.icon_bg:LoadSprite(UIUtil.GetItemQualityBg(self.info.cfg.color))
    self.task_level:SetLocalText(2010379, self.info.cfg.level or 1)
    self.txt_title:SetLocalText(self.info.cfg.name)
    self.cd_text:SetText(UITimeManager:GetInstance():SecondToFmtString(self.info.cfg.times))
    if data.lackArmy then
      self.lack_tip:SetText(Localization:GetString("dispatch_des012"))
      self.lack_tip:SetActive(true)
      self.hero_content:SetActive(false)
      self.toggle:SetInteractable(false)
    elseif data.lackHero then
      self.lack_tip:SetText(Localization:GetString("dispatch_des011"))
      self.lack_tip:SetActive(true)
      self.hero_content:SetActive(false)
      self.toggle:SetInteractable(false)
    else
      self.lack_tip:SetActive(false)
      self.hero_content:SetActive(true)
      self.toggle:SetInteractable(true)
      self.u_i_hero_cell_small1:SetActive(false)
      self.u_i_hero_cell_small2:SetActive(false)
      self.u_i_hero_cell_small3:SetActive(false)
      local selectedUUID = data.heroList
      for i, v in pairs(selectedUUID) do
        if v ~= nil then
          local heroCell = self["u_i_hero_cell_small" .. i]
          heroCell:SetActive(true)
          heroCell:SetData(v)
        end
      end
    end
  end
end

function UIDispatchTaskPopupItem:OnSelectStateChange(isOn)
  if self.data then
    self.data.selected = isOn
  end
end

return UIDispatchTaskPopupItem
