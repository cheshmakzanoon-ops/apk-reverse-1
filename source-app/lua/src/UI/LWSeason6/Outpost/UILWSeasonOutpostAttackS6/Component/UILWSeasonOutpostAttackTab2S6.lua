local UILWSeasonOutpostAttackTab2S6 = BaseClass("UILWSeasonOutpostAttackTab2S6", UIAsyncContainer)
local base = UIAsyncContainer
local LWSeasonMainBanner = require("UI.LWSeasonShared.Component.LWSeasonMainBanner")

function UILWSeasonOutpostAttackTab2S6:OnCreate()
  base.OnCreate(self)
  local offsetMin = self.rectTransform.offsetMin
  local offsetMax = self.rectTransform.offsetMax
  self.rectTransform:Set_offsetMin(offsetMin.x, 0)
  self.rectTransform:Set_offsetMax(offsetMax.x, 0)
  self:ComponentDefine()
end

function UILWSeasonOutpostAttackTab2S6:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackTab2S6:ComponentDefine()
  self.scroll_view = self:AddComponent(UIScrollRect, "ScrollView")
  self.viewport = self:AddComponent(UIButton, "ScrollView/Viewport")
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.toggleGroup = self.content.transform:GetComponent(typeof(CS.UnityEngine.UI.ToggleGroup))
  self.banner = self:AddComponent(LWSeasonMainBanner, "banner")
  self.banner:SetActive(true)
  self.banner:SetParams({
    showJustIcon = true,
    showBg = false,
    ignoreClick = true
  })
  self.banner:RefreshData()
  self.scroll_view:AddValueChangeListener(function(_)
    self:HidePopUp()
    self:CleanSelect()
  end)
  self.btn_help = self:AddComponent(UIButton, "p_btn_help")
  self.btn_help:SetOnClick(function()
    self:HidePopUp()
    self:CleanSelect()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonOutpostColorDetail)
  end)
  self.viewport:SetOnClick(function()
    self:HidePopUp()
    self:CleanSelect()
  end)
end

function UILWSeasonOutpostAttackTab2S6:ComponentDestroy()
  self.banner = nil
  self.content = nil
  self.scroll_view = nil
  self.p_btn_help = nil
  self.viewport = nil
end

function UILWSeasonOutpostAttackTab2S6:ReInit(debugMode, attackActData, battleInfo, battleStartTime, battleEndTime)
  self.debugMode = debugMode
  self.attackActData = attackActData
  self.battleInfo = battleInfo
  self.battleStartTime = battleStartTime
  self.battleEndTime = battleEndTime
end

function UILWSeasonOutpostAttackTab2S6:ShowPopUp(x, y, z, serverId, cityId)
  if self.pop_up_root then
    self.pop_up_root:ShowIt(x, y, z, serverId, cityId)
  end
end

function UILWSeasonOutpostAttackTab2S6:HidePopUp()
  if self.pop_up_root then
    self.pop_up_root:SetActive(false)
  end
end

function UILWSeasonOutpostAttackTab2S6:SetPopUpNode(pop_up_root)
  self.pop_up_root = pop_up_root
end

function UILWSeasonOutpostAttackTab2S6:CleanSelect()
  if not self:AsyncLoadDone() then
    return
  end
  local mapRootDict = self.mapRootDict or {}
  for serverId, mapNode in pairs(mapRootDict) do
    if mapNode then
      mapNode:CleanSelect()
    end
  end
end

function UILWSeasonOutpostAttackTab2S6:UpdateData()
  if not self:AsyncLoadDone() then
    return
  end
  local camp1List = {}
  local camp2List = {}
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
  if seasonInfo and seasonInfo.campInfo and #seasonInfo.campInfo > 0 then
    for _, v in ipairs(seasonInfo.campInfo) do
      if v.campId == SeasonFactionType.Rebels then
        table.insert(camp1List, v.serverId)
      elseif v.campId == SeasonFactionType.Gendarmerie then
        table.insert(camp2List, v.serverId)
      end
    end
  else
    local seasonFactionInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
    if seasonFactionInfo then
      for _, v in pairs(seasonFactionInfo) do
        if v.campId == SeasonFactionType.Rebels then
          table.insert(camp1List, v.serverId)
        elseif v.campId == SeasonFactionType.Gendarmerie then
          table.insert(camp2List, v.serverId)
        end
      end
    end
  end
  if 0 < #camp1List and 0 < #camp2List then
    local mapRootDict = self.mapRootDict or {}
    table.sort(camp1List, function(a, b)
      return a < b
    end)
    table.sort(camp2List, function(a, b)
      return a < b
    end)
    local lua = require("UI.LWSeason6.Outpost.UILWSeasonOutpostAttackS6.Component.UILWSeasonOutpostMapRootS6")
    local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/LWSeason6/Outpost/Component/OutpostAttackMapSmallS6.prefab"
    for index, serverId1 in ipairs(camp1List) do
      if mapRootDict[serverId1] == nil then
        mapRootDict[serverId1] = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
      end
      mapRootDict[serverId1]:SetActive(true)
      mapRootDict[serverId1]:ReInit(serverId1, self, self.toggleGroup)
      mapRootDict[serverId1]:SetSiblingIndex(index * 2)
      local serverId2 = camp2List[index]
      if mapRootDict[serverId2] == nil then
        mapRootDict[serverId2] = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
      end
      mapRootDict[serverId2]:SetActive(true)
      mapRootDict[serverId2]:ReInit(serverId2, self, self.toggleGroup)
      mapRootDict[serverId2]:SetSiblingIndex(index * 2 + 1)
    end
    self.mapRootDict = mapRootDict
  end
end

return UILWSeasonOutpostAttackTab2S6
