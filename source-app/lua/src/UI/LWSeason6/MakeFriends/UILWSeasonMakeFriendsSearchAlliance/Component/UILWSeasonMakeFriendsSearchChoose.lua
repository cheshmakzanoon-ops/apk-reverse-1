local UILWSeasonMakeFriendsSearchChoose = BaseClass("UILWSeasonMakeFriendsSearchChoose", UIBaseContainer)
local base = UIBaseContainer
local ChooseItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsSearchAlliance.Component.UIMFSearchChooseItem")
local select_mode_txt_path = "SelectModeTxt"
local select_mode_btn1_path = "SelectModeBtn1"
local item_list_path = "ItemList"
local select_mode_btn2_path = "ItemList/SelectModeBtn2"

function UILWSeasonMakeFriendsSearchChoose:OnCreate()
  base.OnCreate(self)
  self.select_mode_txt = self:AddComponent(UITextMeshProUGUIEx, select_mode_txt_path)
  self.select_mode_btn1 = self:AddComponent(UIButton, select_mode_btn1_path)
  self.item_list = self:AddComponent(UIBaseContainer, item_list_path)
  self.item_list:SetLocalScaleXYZ(1, 0, 1)
  self.item_list_shown = false
  self.select_mode_btn2 = self:AddComponent(UIButton, select_mode_btn2_path)
  self.theItemPool = self.transform:Find("ItemList/Item").gameObject
  self.theItemPool:GameObjectCreatePool()
  self.theLinePool = self.transform:Find("ItemList/Line").gameObject
  self.theLinePool:GameObjectCreatePool()
  self:InitData()
  self:InitEvent()
  self:RefreshUI(false)
end

function UILWSeasonMakeFriendsSearchChoose:InitData()
  local serverList = DataCenter.SeasonDataManager:GetServerListInt()
  local goItem, theItem
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
  if seasonInfo and seasonInfo.campInfo and #seasonInfo.campInfo > 0 then
    local myCampId = seasonInfo:GetCampIdByServerId(mySourceServerId)
    if myCampId ~= nil and myCampId ~= 0 then
      serverList = {}
      for _, v in ipairs(seasonInfo.campInfo) do
        if v.campId == myCampId then
          table.insert(serverList, v.serverId)
        end
      end
    end
  elseif seasonType == SeasonMapType.NineNationRainforest or SeasonUtil.SeasonHasFactionWar(seasonType) then
    serverList = DataCenter.SeasonFactionWarDataManager:GetMyGroupingServer()
  end
  self.ToggleList = {}
  for _, serverId in ipairs(serverList) do
    goItem = self.theItemPool:GameObjectSpawn(self.item_list.transform)
    goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
    goItem:SetActive(true)
    theItem = self.item_list:AddComponent(ChooseItem, goItem.name)
    theItem:ReInit(serverId)
    self:RegEvent(theItem)
    goItem = self.theLinePool:GameObjectSpawn(self.item_list.transform)
    goItem.name = "line_" .. UIUtil.GetLoopListItemIndex()
    goItem:SetActive(true)
  end
  goItem = self.theItemPool:GameObjectSpawn(self.item_list.transform)
  goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
  goItem:SetActive(true)
  theItem = self.item_list:AddComponent(ChooseItem, goItem.name)
  theItem:ReInit(nil, nil)
  self:RegEvent(theItem)
end

function UILWSeasonMakeFriendsSearchChoose:RegEvent(theToggle)
  table.insert(self.ToggleList, theToggle)
  theToggle:SetOnValueChanged(function(isOn)
    if isOn then
      self.select_mode_txt:SetText(theToggle:GetTxt())
      self:RefreshUI(true, theToggle.serverId, theToggle.factionType)
    end
  end)
end

function UILWSeasonMakeFriendsSearchChoose:InitEvent()
  self.select_mode_btn1:SetOnClick(function()
    if not self.item_list_shown then
      DOTween.To(function()
        return 0
      end, function(scale)
        if self.item_list then
          self.item_list:SetLocalScaleXYZ(1, scale, 1)
        end
      end, 1, 0.2)
      self.item_list_shown = true
    end
  end)
  self.select_mode_btn2:SetOnClick(function()
    if self.item_list_shown then
      DOTween.To(function()
        return 1
      end, function(scale)
        if self.item_list then
          self.item_list:SetLocalScaleXYZ(1, scale, 1)
        end
      end, 0, 0.2):SetEase(CS.DG.Tweening.Ease.InExpo)
      self.item_list_shown = false
    end
  end)
  self.item_list:SetLocalScaleXYZ(1, 0, 1)
  self.item_list_shown = false
end

function UILWSeasonMakeFriendsSearchChoose:OnDestroy()
  self.item_list:RemoveComponents(ChooseItem)
  self.theItemPool:GameObjectRecycleAll()
  self.theLinePool:GameObjectRecycleAll()
  self.item_list:SetLocalScaleXYZ(1, 0, 1)
  self.item_list_shown = false
  self.select_mode_txt = nil
  self.select_mode_btn1 = nil
  self.item_list = nil
  self.ToggleList = nil
  self.select_mode_btn2 = nil
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsSearchChoose:SetSelectIndex(serverId, factionType)
  if self.ToggleList ~= nil then
    for k, v in pairs(self.ToggleList) do
      if v.serverId == serverId and v.factionType == factionType then
        v:SetIsOn(true)
        self.select_mode_txt:SetText(v:GetTxt())
        self:RefreshUI(false, v.serverId, v.factionType)
        break
      end
    end
  end
end

function UILWSeasonMakeFriendsSearchChoose:RefreshUI(switch_data, serverId, factionType)
  if switch_data then
    if self.item_list_shown then
      DOTween.To(function()
        return 1
      end, function(scale)
        if self.item_list then
          self.item_list:SetLocalScaleXYZ(1, scale, 1)
        end
      end, 0, 0.2):SetEase(CS.DG.Tweening.Ease.InExpo)
      self.item_list_shown = false
    end
    if self.view then
      self.view:RefreshUI(serverId, factionType)
    end
  else
    self.item_list:SetLocalScaleXYZ(1, 0, 1)
    self.item_list_shown = false
  end
end

return UILWSeasonMakeFriendsSearchChoose
