local LWSeasonBuildTabItem2 = BaseClass("LWSeasonBuildTabItem2", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonBuildCityItem = require("UI.LWSeason.LWSeasonBuild.Component.LWSeasonBuildCityItem")
local lastActiveTab = 1
local info_btn_path = "InfoBtn"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local build_pos_path = "banner/build_pos"
local build_icon_path = "banner/build_icon"
local lock_path = "banner/build_icon/lock"
local toggle1_path = "TabBar/toggle1"
local toggle_txt_off1_path = "TabBar/toggle1/toggle_txt_off1"
local toggle_txt_on1_path = "TabBar/toggle1/on1/toggle_txt_on1"
local toggle2_path = "TabBar/toggle2"
local toggle_txt_off2_path = "TabBar/toggle2/toggle_txt_off2"
local toggle_txt_on2_path = "TabBar/toggle2/on2/toggle_txt_on2"
local toggle3_path = "TabBar/toggle3"
local toggle_txt_off3_path = "TabBar/toggle3/toggle_txt_off3"
local toggle_txt_on3_path = "TabBar/toggle3/on3/toggle_txt_on3"
local toggle4_path = "TabBar/toggle4"
local toggle_txt_off4_path = "TabBar/toggle4/toggle_txt_off4"
local toggle_txt_on4_path = "TabBar/toggle4/on4/toggle_txt_on4"
local red_point1_path = "TabBar/toggle1/RedPoint1"
local red_num1_path = "TabBar/toggle1/RedPoint1/RedNum1"
local red_point2_path = "TabBar/toggle2/RedPoint2"
local red_num2_path = "TabBar/toggle2/RedPoint2/RedNum2"
local red_point3_path = "TabBar/toggle3/RedPoint3"
local red_num3_path = "TabBar/toggle3/RedPoint3/RedNum3"
local red_point4_path = "TabBar/toggle4/RedPoint4"
local red_num4_path = "TabBar/toggle4/RedPoint4/RedNum4"

function LWSeasonBuildTabItem2:OnCreate()
  base.OnCreate(self)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.build_pos = self:AddComponent(UIText, build_pos_path)
  self.build_icon = self:AddComponent(UIButton, build_icon_path)
  self.lock = self:AddComponent(UIImage, lock_path)
  self.tab_item1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle_txt_off1 = self:AddComponent(UIText, toggle_txt_off1_path)
  self.toggle_txt_on1 = self:AddComponent(UIText, toggle_txt_on1_path)
  self.tab_item2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle_txt_off2 = self:AddComponent(UIText, toggle_txt_off2_path)
  self.toggle_txt_on2 = self:AddComponent(UIText, toggle_txt_on2_path)
  self.tab_item3 = self:AddComponent(UIToggle, toggle3_path)
  self.toggle_txt_off3 = self:AddComponent(UIText, toggle_txt_off3_path)
  self.toggle_txt_on3 = self:AddComponent(UIText, toggle_txt_on3_path)
  self.tab_item4 = self:AddComponent(UIToggle, toggle4_path)
  self.toggle_txt_off4 = self:AddComponent(UIText, toggle_txt_off4_path)
  self.toggle_txt_on4 = self:AddComponent(UIText, toggle_txt_on4_path)
  self.red_point1 = self:AddComponent(UIImage, red_point1_path)
  self.red_num1 = self:AddComponent(UIText, red_num1_path)
  self.red_point2 = self:AddComponent(UIImage, red_point2_path)
  self.red_num2 = self:AddComponent(UIText, red_num2_path)
  self.red_point3 = self:AddComponent(UIImage, red_point3_path)
  self.red_num3 = self:AddComponent(UIText, red_num3_path)
  self.red_point4 = self:AddComponent(UIImage, red_point4_path)
  self.red_num4 = self:AddComponent(UIText, red_num4_path)
  self.build_icon:SetOnClick(function()
    if LuaEntry.Player:IsInAlliance() then
      if self.mineInfo ~= nil and self.mineInfo.pointId ~= nil then
        GoToUtil.CloseAllWindows()
        local pos = SceneUtils.TileIndexToWorld(self.mineInfo.pointId, ForceChangeScene.World)
        GoToUtil.GotoWorldPos(pos, nil, nil, function()
        end, LuaEntry.Player:GetSourceServerId(), 0)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCity, {anim = true, hideTop = true})
      end
    elseif LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
  end)
  self.info_btn:SetOnClick(function()
    local title = "803069"
    local desc = Localization:GetString("803073")
    UIUtil.ShowDetail(desc, title)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(3)
    end
  end)
  self.tab_item4:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(4)
    end
  end)
  self.alCityList = DataCenter.AllianceMineManager:GetAlCenterBuildList()
  for i, v in ipairs(self.alCityList) do
    self["toggle_txt_off" .. i]:SetLocalText(v.name)
    self["toggle_txt_on" .. i]:SetLocalText(v.name)
    local mineInfo = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(v.id)
    if mineInfo then
      local buildingCount = SeasonUtil.CanBuildPlayerBuildingCount(v.id)
      if 0 < buildingCount then
        self["red_point" .. i]:SetActive(true)
        self["red_num" .. i]:SetText(buildingCount)
      else
        self["red_point" .. i]:SetActive(false)
      end
    else
      self["red_point" .. i]:SetActive(false)
    end
  end
  if lastActiveTab == 1 then
    self.tab_item1:SetIsOn(true)
  elseif lastActiveTab == 2 then
    self.tab_item2:SetIsOn(true)
  elseif lastActiveTab == 3 then
    self.tab_item3:SetIsOn(true)
  elseif lastActiveTab == 4 then
    self.tab_item4:SetIsOn(true)
  end
  if self.tabActive == nil then
    self:OnTabChanged(lastActiveTab)
  end
end

function LWSeasonBuildTabItem2:OnDestroy()
  self:ClearScroll()
  base.OnDestroy(self)
end

function LWSeasonBuildTabItem2:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWSeasonBuildCityItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.tabActive, index, self.cityList[index], self.mineInfo, self.allianceCenterBaseId)
  end
end

function LWSeasonBuildTabItem2:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWSeasonBuildCityItem)
end

function LWSeasonBuildTabItem2:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWSeasonBuildCityItem)
end

function LWSeasonBuildTabItem2:UpdateTabStatus()
  local mineInfo = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(self.allianceCenterBaseId)
  if mineInfo and mineInfo.pointId then
    local posV2 = SceneUtils.IndexToTilePos(mineInfo.pointId, ForceChangeScene.World)
    if LuaEntry.Player:AtHomeNow() then
      if mineInfo.status == AllianceMineStatus.Build then
        self.build_pos:SetText(string.format("( X:%s Y:%s ) [%s]", posV2.x, posV2.y, Localization:GetString("390210")))
      else
        self.build_pos:SetText(string.format("( X:%s Y:%s )", posV2.x, posV2.y))
      end
    elseif mineInfo.status == AllianceMineStatus.Build then
      self.build_pos:SetText(string.format("#%s ( X:%s Y:%s ) [%s]", LuaEntry.Player:GetSourceServerId(), posV2.x, posV2.y, Localization:GetString("390210")))
    else
      self.build_pos:SetText(string.format("#%s ( X:%s Y:%s )", LuaEntry.Player:GetSourceServerId(), posV2.x, posV2.y))
    end
    self.build_icon:SetColorRGBA(1, 1, 1, 1)
    self.lock:SetActive(false)
  else
    self.build_pos:SetLocalText("season_tips104")
    self.build_icon:SetColorRGBA(0.5, 0.5, 0.5, 1)
    self.lock:SetActive(true)
  end
  self.mineInfo = mineInfo
end

function LWSeasonBuildTabItem2:UpdateData()
  self:UpdateTabStatus()
  if self.tabActive then
    self:OnTabChanged(self.tabActive)
  end
end

function LWSeasonBuildTabItem2:OnTabChanged(index)
  lastActiveTab = index
  self.tabActive = index
  local allBuildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  local seasonBuildIds = allBuildIds[UIBuildListTabType.SeasonBuild]
  local allianceCenterBaseId = BuildingTypes["ALLIANCE_CENTER_" .. index]
  local cityList = {}
  for k, v in pairs(seasonBuildIds) do
    if v.buildTemplate and v.buildTemplate.allianceCenterBaseId == allianceCenterBaseId then
      table.insert(cityList, v)
    end
  end
  local dataCount = #cityList
  self.cityList = cityList
  self.allianceCenterBaseId = allianceCenterBaseId
  self:UpdateTabStatus()
  self:ClearScroll()
  self.ScrollView:StopMovement()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  if 0 < dataCount then
    table.sort(self.cityList, function(a, b)
      if a.order == b.order then
        return a.id < b.id
      end
      return a.order < b.order
    end)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  end
end

return LWSeasonBuildTabItem2
