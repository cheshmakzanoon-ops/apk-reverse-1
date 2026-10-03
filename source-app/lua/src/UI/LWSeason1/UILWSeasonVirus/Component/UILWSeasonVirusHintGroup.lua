local UILWSeasonVirusHintGroup = BaseClass("UILWSeasonVirusHintGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWSeasonVirusItem = require("UI.LWSeason1.UILWSeasonVirus.Component.UILWSeasonVirusItem")
local content_path = "ScrollView/Viewport/Content"
local detail1_path = "ScrollView/Viewport/Content/detail1"
local detail2_path = "ScrollView/Viewport/Content/detail2"
local tab_path = "Tab"
local toggle1_path = "Tab/toggle1"
local toggle2_path = "Tab/toggle2"

function UILWSeasonVirusHintGroup:OnCreate()
  base.OnCreate(self)
  self.init = false
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.theItem1 = self.transform:Find(detail1_path).gameObject
  self.theItem1:GameObjectCreatePool()
  self.theItem2 = self.transform:Find(detail2_path).gameObject
  self.theItem2:GameObjectCreatePool()
  self.tabRoot = self:AddComponent(UIImage, tab_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:InitFromPPT(self.virus_hint_tab1)
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:InitFromPPT(self.virus_hint_tab2)
    end
  end)
end

function UILWSeasonVirusHintGroup:OnDestroy()
  self.content:RemoveComponents(UILWSeasonVirusItem)
  self.theItem1:GameObjectRecycleAll()
  self.theItem2:GameObjectRecycleAll()
  self.init = false
  self.tabRoot = nil
  self.toggle1 = nil
  self.toggle2 = nil
  base.OnDestroy(self)
end

function UILWSeasonVirusHintGroup:InitFromPPT(virus_hint_group)
  if self.virus_hint_group == virus_hint_group then
    return
  end
  self.content:RemoveComponents(UILWSeasonVirusItem)
  self.theItem1:GameObjectRecycleAll()
  self.theItem2:GameObjectRecycleAll()
  LocalController:instance():visitTable(TableName.LW_PPT_Show, function(id, lineData)
    local group = lineData:getIntValue("group", 0) or 0
    if group == virus_hint_group then
      local goItem, theItem
      local banner = lineData:getValue("banner")
      local icon = lineData:getValue("icon")
      if not string.IsNullOrEmpty(banner) then
        icon = nil
        goItem = self.theItem1:GameObjectSpawn(self.content.transform)
      elseif not string.IsNullOrEmpty(icon) then
        banner = nil
        goItem = self.theItem2:GameObjectSpawn(self.content.transform)
      end
      if goItem ~= nil then
        goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWSeasonVirusItem, goItem.name)
        if banner then
          theItem:ReInit(id, 1, banner, lineData:getValue("title_key", ""), lineData:getValue("long_key", ""))
        else
          theItem:ReInit(id, 2, icon, lineData:getValue("icon_name", ""), lineData:getValue("icon_des", ""))
        end
      end
    end
  end)
end

function UILWSeasonVirusHintGroup:DoRefresh()
  if self.init == true then
    return
  end
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config == nil then
    return
  end
  local ver = config:getIntValue("version")
  if config and 0 < ver then
    local virus_ppt_show = tostring(config.virus_ppt_show)
    local virus_ppt_show_int = string.split_ii_array(virus_ppt_show or "", ";")
    if virus_ppt_show_int and 1 < #virus_ppt_show_int then
      self.virus_hint_tab1 = virus_ppt_show_int[2]
      self.virus_hint_tab2 = virus_ppt_show_int[3]
    end
    if self.virus_hint_tab1 == nil or self.virus_hint_tab2 == nil then
      self.tabRoot:SetActive(false)
      if self.virus_hint_tab1 then
        self:InitFromPPT(self.virus_hint_tab1)
      elseif self.virus_hint_tab2 then
        self:InitFromPPT(self.virus_hint_tab2)
      end
    else
      self.tabRoot:SetActive(true)
      self.toggle1:SetIsOn(true)
      self:InitFromPPT(self.virus_hint_tab1)
    end
  else
    local goItem, theItem
    for item in string.gmatch(config.virus_hint, "([^|]+)|?") do
      local index, theType, img, title, desc = string.match(item, "([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
      if index and theType and img and title and desc and (theType == "1" or theType == "2") then
        goItem = self["theItem" .. theType]:GameObjectSpawn(self.content.transform)
        goItem.name = "item_" .. index .. "_" .. theType
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UILWSeasonVirusItem, goItem.name)
        theItem:ReInit(index, theType, img, title, desc)
      end
    end
    self.tabRoot:SetActive(false)
  end
  self.init = true
end

return UILWSeasonVirusHintGroup
