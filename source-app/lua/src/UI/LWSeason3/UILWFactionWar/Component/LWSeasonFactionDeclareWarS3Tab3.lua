local base = UIAsyncContainer
local LWSeasonFactionDeclareWarS3Tab3 = BaseClass("LWSeasonFactionDeclareWarS3Tab3", base)
local Localization = CS.GameEntry.Localization
local GroupTitle = require("UI.LWSeason2.Activity.Component.SeasonFaction.LWSeasonFactionGroupTitle")
local GroupMember = require("UI.LWSeason2.Activity.Component.SeasonFaction.LWSeasonFactionGroupMember")
local info_btn_path = "InfoBtn"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local title_content_path = "ScrollView/Viewport/TitleContent"
local group_info_btn_path = "ScrollView/GameObject/GroupInfoBtn"
local status_icon_path = "statusIcon"
local status_text_path = "statusIcon/statusText"
local title_path = "title"
local time_text_path = "timeText"
local defence_mode_path = "banner/defenceMode"
local attack_mode_path = "banner/attackMode"
local explain_btn_path = "explainBtn"
local banner_path = "banner"

function LWSeasonFactionDeclareWarS3Tab3:OnCreate()
  base.OnCreate(self)
  self.rectTransform:Set_offsetMin(7, 10)
  self.rectTransform:Set_offsetMax(-7, 0)
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.explain_btn = self:AddComponent(UIButton, explain_btn_path)
  self.explain_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarRule, {anim = true}, "DeclareWarTime")
  end)
  self.defence_mode = self:AddComponent(UIBaseComponent, defence_mode_path)
  self.attack_mode = self:AddComponent(UIBaseComponent, attack_mode_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.items = {}
  self.tansList = {}
  self.dataList = {}
  self.full_data = nil
  self.dict = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.title_content = self:AddComponent(GroupTitle, title_content_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.LoopListView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.title_content:SetActive(false)
  self.status_icon = self:AddComponent(UIImage, status_icon_path)
  self.status_text = self:AddComponent(UITextMeshProUGUIEx, status_text_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarRule, {anim = true}, "DeclareWar")
  end)
  self.group_info_btn = self:AddComponent(UIButton, group_info_btn_path)
  self.group_info_btn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s2_faction_war_tips_05"))
  end)
  self.needRequest = true
end

function LWSeasonFactionDeclareWarS3Tab3:OnDestroy()
  self:RemoveItems()
  self.banner = nil
  self.defence_mode = nil
  self.attack_mode = nil
  self.title = nil
  self.time_text = nil
  self.scroll_view = nil
  self.content = nil
  self.status_icon = nil
  self.status_text = nil
  base.OnDestroy(self)
end

function LWSeasonFactionDeclareWarS3Tab3:OnEnable()
  base.OnEnable(self)
end

function LWSeasonFactionDeclareWarS3Tab3:OnDisable()
  base.OnDisable(self)
end

function LWSeasonFactionDeclareWarS3Tab3:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionGroupInfoUpdate, self.OnGroupInfoUpdate)
  self:AddUIListener(EventId.LWSeasonFactionDoWarDeclare, self.OnDataChanged)
end

function LWSeasonFactionDeclareWarS3Tab3:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionGroupInfoUpdate, self.OnGroupInfoUpdate)
  self:RemoveUIListener(EventId.LWSeasonFactionDoWarDeclare, self.OnDataChanged)
  base.OnRemoveListener(self)
end

function LWSeasonFactionDeclareWarS3Tab3:OnDataChanged()
  SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, 2)
end

function LWSeasonFactionDeclareWarS3Tab3:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if self.full_data == nil then
    self:OnGroupInfoUpdate()
  end
  local mgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = mgr:GetDeclareWarActInfo()
  if actInfo then
    self.currStep = actInfo.currStep
    self.stepEndTime = actInfo.stepEndTime
    self.title:SetText(Localization:GetString(mgr.StepText[self.currStep + 1] or "season_s2_faction_war_01"))
    self:Update1000MS()
  end
end

function LWSeasonFactionDeclareWarS3Tab3:OnGroupInfoUpdate()
  local dataList = DataCenter.SeasonFactionWarDataManager.dataList2
  if dataList then
    local targetAllianceId = DataCenter.SeasonFactionWarDataManager.targetAllianceId
    if self.full_data == nil then
      local defaultGroup = 1
      local myAllianceId = LuaEntry.Player:GetAllianceUid()
      local level_group = DataCenter.SeasonFactionWarDataManager.level_group or {}
      local full_data = {}
      local groupMinRank = 1
      self.myGroupIndex = nil
      self.myEnemyIndex = nil
      for groupIndex, groupMaxRank in ipairs(level_group) do
        table.insert(full_data, {
          title = true,
          group = groupIndex,
          expand = false,
          rankMin = groupMinRank,
          rankMax = groupMaxRank
        })
        for _, rankData in ipairs(dataList) do
          if groupMinRank <= rankData.rank and groupMaxRank >= rankData.rank then
            table.insert(full_data, {
              group = groupIndex,
              rank = rankData.rank,
              data = rankData
            })
            if rankData.allianceId == myAllianceId then
              defaultGroup = groupIndex
              self.myGroupIndex = groupIndex
            end
            if rankData.allianceId == targetAllianceId then
              self.myEnemyIndex = groupIndex
            end
          end
          self.dict[rankData.allianceId] = rankData
        end
        groupMinRank = groupMaxRank + 1
      end
      self.full_data = full_data
      self.LoopListView:InitListView(0, function(listview, index)
        return self:GetScrollItem(listview, index)
      end)
      self.scroll_view:AddValueChangeListener(function(vec)
        self:OnScrollValueChange(vec)
      end)
      self:OnGroupClick(defaultGroup, true)
      self.LoopListView:MovePanelToItemIndex(defaultGroup, 70)
      self.title_content:SetActive(false)
      if 2 == DataCenter.SeasonFactionWarDataManager.attackCampId then
        self.status_text:SetLocalText("season_s2_faction_war_05")
        self.defence_mode:SetActive(false)
        self.attack_mode:SetActive(true)
        self.banner:LoadSprite("Assets/Main/SeasonRes/S3/Textures/FactionDeclareWar/mjc_S3_xlzdz_zhanzheng_bg2.png")
      else
        self.status_text:SetLocalText("season_s2_faction_war_06")
        self.defence_mode:SetActive(true)
        self.attack_mode:SetActive(false)
        self.banner:LoadSprite("Assets/Main/SeasonRes/S3/Textures/FactionDeclareWar/mjc_S3_xlzdz_zhanzheng_bg1.png")
      end
      return
    end
    self.myEnemyIndex = nil
    for _, rankData in ipairs(dataList) do
      self.dict[rankData.allianceId] = rankData
      for _, v in ipairs(self.full_data) do
        if v and v.title and rankData.rank >= v.rankMin and rankData.rank <= v.rankMax and rankData.allianceId == targetAllianceId then
          self.myEnemyIndex = v.group
          break
        end
      end
    end
    self.LoopListView:RefreshAllShownItem()
  end
end

function LWSeasonFactionDeclareWarS3Tab3:RemoveItems()
  self.items = {}
  self.tansList = {}
  self.content:RemoveComponents(GroupTitle)
  self.content:RemoveComponents(GroupMember)
  self.LoopListView:ClearAllItems()
end

function LWSeasonFactionDeclareWarS3Tab3:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local data = dataList[index]
  local cell_name = "FactionWarTitleContent"
  local cell_lua = GroupTitle
  if data.title then
    cell_name = "FactionWarTitleContent"
    cell_lua = GroupTitle
  else
    data.data = self.dict[data.data.allianceId]
    cell_name = "FactionWarMemberItem"
    cell_lua = GroupMember
  end
  local csItem = listview:NewListViewItem(cell_name)
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = cell_name .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(cell_lua, nameStr)
  end
  if self.tansList[csItem] == nil then
    self.tansList[csItem] = csItem.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(2, data, self)
  end
  return csItem
end

function LWSeasonFactionDeclareWarS3Tab3:OnGroupClick(group, expand)
  local group_expand = false
  local item_count = 0
  self.titleIdxList = {}
  self.dataList = {}
  for _, v in ipairs(self.full_data) do
    if v then
      if v.title == true then
        if v.group == group then
          v.expand = expand
        end
        group_expand = v.expand
        table.insert(self.dataList, v)
        table.insert(self.titleIdxList, #self.dataList)
      elseif group_expand then
        item_count = item_count + 1
        table.insert(self.dataList, v)
      end
    end
  end
  if item_count == 0 then
    self.title_content:SetActive(false)
  end
  self.item_count = item_count
  self.LoopListView:SetListItemCount(#self.dataList, item_count == 0, false)
  self.LoopListView:RefreshAllShownItem()
end

function LWSeasonFactionDeclareWarS3Tab3:OnScrollValueChange(vec)
  if self.item_count == 0 then
    self.title_content:SetActive(false)
    return
  end
  local top = self.content:GetAnchoredPositionY()
  if top < 5 then
    self.title_content:SetActive(false)
    return
  end
  local first = true
  local lastIdx = -1
  local lastShownIdx = -1
  for _, idx in ipairs(self.titleIdxList) do
    local csItem = self.LoopListView:GetShownItemByItemIndex(idx)
    if csItem ~= nil then
      local rectTransform = self.tansList[csItem]
      if rectTransform == nil then
        rectTransform = csItem.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
        self.tansList[csItem] = rectTransform
      end
      local _, y = rectTransform:Get_anchoredPosition()
      if -70 <= y + top then
        lastShownIdx = idx
      elseif first and lastShownIdx == -1 then
        lastShownIdx = lastIdx
        first = false
      end
    end
    lastIdx = idx
  end
  if 0 < lastShownIdx then
    self.title_content:SetActive(true)
    self.title_content:ReInit(lastShownIdx, self.dataList[lastShownIdx], self)
  end
end

function LWSeasonFactionDeclareWarS3Tab3:Update1000MS()
  if self.stepEndTime then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    deltaTime = self.stepEndTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_text:SetText(showTime)
    else
      self.time_text:SetText("")
      if self.currStep == SeasonFactionDeclareWarStep.battle then
        self.title:SetLocalText("season_s2_faction_war_12")
      end
      if self.lastRequest == nil or curTime - self.lastRequest > 3456 then
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionDeclareWarDetail, 2)
        self.lastRequest = curTime
      end
    end
  end
end

return LWSeasonFactionDeclareWarS3Tab3
