local UIChampionDuelGroup = BaseClass("UIChampionDuelGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIChampionDuelGroupCell = require("UI.UIChampionDuel.Component.UIChampionDuelGroupCell")
local UIChampionDuelGroupItem = require("UI.UIChampionDuel.Component.UIChampionDuelGroupItem")
local info_group_path = "InfoGroup"
local btn_info_path = "InfoGroup/InfoBtn"
local text_info_path = "InfoGroup/InfoText"
local img_info_path = "InfoGroup/Info"
local text_rank_path = "TitleGroup/RankText"
local text_name_path = "TitleGroup/NameText"
local text_power_path = "TitleGroup/PowerText"
local scrollView_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local self_cell_path = "RankSelf"
local tip_group_path = "TipGroup"
local text_tip_path = "TipGroup/TipText"
local group_arr_path = "Group/GroupArr"
local group_text_path = "Group/GroupText"
local group_btn_path = "Group/GroupBtn"
local group_content_path = "Group/GroupContent"
local group_cell_path = "Group/GroupCell"
local IMG_UP_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png"
local IMG_DOWN_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png"

function UIChampionDuelGroup:OnCreate()
  base.OnCreate(self)
  self.groupShow = false
  self:ComponentDefine()
end

function UIChampionDuelGroup:OnDestroy()
  self.groupShow = false
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelGroup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelGroupRefresh, self.OnGroupRefresh)
end

function UIChampionDuelGroup:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelGroupRefresh, self.OnGroupRefresh)
  base.OnRemoveListener(self)
end

function UIChampionDuelGroup:ComponentDefine()
  self.info_group = self:AddComponent(UIBaseContainer, info_group_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.text_info = self:AddComponent(UIText, text_info_path)
  self.text_info:SetLocalText("champion_duel_tips1024")
  self.img_info = self:AddComponent(UIImage, img_info_path)
  self.text_rank = self:AddComponent(UIText, text_rank_path)
  self.text_rank:SetLocalText("361013")
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_name:SetLocalText("100184")
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.text_power:SetLocalText("361001")
  self.rankCells = {}
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.scrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  if self.transform:Find(self_cell_path) then
    self.rank_self = self:AddComponent(UIChampionDuelGroupCell, self_cell_path)
  end
  self.tip_group = self:AddComponent(UIBaseContainer, tip_group_path)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
  self.group_arr = self:AddComponent(UIImage, group_arr_path)
  self.group_text = self:AddComponent(UIText, group_text_path)
  self.group_btn = self:AddComponent(UIButton, group_btn_path)
  self.group_btn:SetOnClick(BindCallback(self, self.OnBtnGroupClick))
  self.group_content = self:AddComponent(UIBaseContainer, group_content_path)
  self.group_cell = self.transform:Find(group_cell_path).gameObject
  self.group_cell:GameObjectCreatePool()
  self.groupCells = {}
end

function UIChampionDuelGroup:ComponentDestroy()
  self:ClearGroupCell()
  self:ClearGroupItem()
  self.info_group = nil
  self.btn_info = nil
  self.text_info = nil
  self.img_info = nil
  self.text_rank = nil
  self.text_name = nil
  self.text_power = nil
  self.scrollView = nil
  self.content = nil
  self.rank_self = nil
  self.tip_group = nil
  self.text_tip = nil
  self.group_arr = nil
  self.group_text = nil
  self.group_btn = nil
  self.group_content = nil
  self.group_cell = nil
end

function UIChampionDuelGroup:OnBtnInfoClick()
  local curStage = self.signStageId == nil and DataCenter.ChampionDuelManager:GetCurStageId() or self.signStageId
  local keyStr = curStage < ChampionDuelState.PreStageAnnouncement and "champion_duel_rules_detail1004" or "champion_duel_tips1094"
  local strTip = Localization:GetString(keyStr, self.upNum)
  UIUtil.ShowBubbleTips(strTip, self.img_info.transform.position, 0, -30, 0)
end

function UIChampionDuelGroup:ClearGroupCell()
  if self.rank_self then
    self.rank_self:SetActive(false)
  end
  self.content:RemoveComponents(UIChampionDuelGroupCell)
  self.scrollView:ClearAllItems()
  self.scrollView:SetListItemCount(0, false, false)
  self.scrollView:RefreshAllShownItem()
  self.rankCells = {}
end

function UIChampionDuelGroup:ClearGroupItem()
  self.group_content:RemoveComponents(UIChampionDuelGroupItem)
  self.group_cell:GameObjectRecycleAll()
  self.groupCells = {}
end

function UIChampionDuelGroup:TipInit(stageId)
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local langKey
  self.upNum = 0
  if stageId < ChampionDuelState.PreStageAnnouncement then
    self.upNum = actInfo ~= nil and actInfo.auditionUpperNums or 8
    langKey = "champion_duel_tips1025"
  elseif stageId < ChampionDuelState.RematchAnnouncement then
    self.upNum = actInfo ~= nil and actInfo.semiFinalUpperNums or 2
    langKey = "champion_duel_tips1026"
  end
  if self.upNum > 0 then
    self.text_tip:SetLocalText(langKey, self.upNum)
    self.tip_group:SetActive(true)
    self.info_group:SetActive(true)
  else
    self.tip_group:SetActive(false)
    self.info_group:SetActive(false)
  end
end

function UIChampionDuelGroup:ReInit()
  DataCenter.ChampionDuelManager:SaveGroupTime()
  self:ClearGroupCell()
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  self:TipInit(stageId)
  self:ClearGroupItem()
  self.group = 0
  self.myGroup = actInfo ~= nil and actInfo.group or 0
  self.signStageId = nil
  self:OnGroupItemClick(self.myGroup == 0 and 1 or self.myGroup)
end

function UIChampionDuelGroup:InitWithStageId(stageId)
  self:ClearGroupCell()
  self:ClearGroupItem()
  self:TipInit(stageId)
  self.group = 0
  self.myGroup = 0
  self.signStageId = stageId
  self:OnGroupItemClick(1)
end

function UIChampionDuelGroup:OnGroupRefresh()
  local groupList = DataCenter.ChampionDuelManager:GetGroupList()
  local dataList = groupList ~= nil and groupList.ranks or nil
  if table.IsNullOrEmpty(dataList) then
    self:ClearGroupCell()
  else
    self.scrollView:SetListItemCount(#dataList, false, false)
    self.scrollView:RefreshAllShownItem()
  end
  local l, b = self.scrollView:GetOffsetMinXY()
  b = 60
  if self.rank_self then
    local myRank = groupList ~= nil and groupList.myRank or nil
    if myRank and myRank.rank > 0 then
      self.rank_self:ReInit(myRank, true)
      self.rank_self:SetActive(true)
      local _, h = self.rank_self.rectTransform:Get_sizeDelta()
      b = b + h
    else
      self.rank_self:SetActive(false)
    end
  end
  self.scrollView:SetOffsetMinXY(l, b)
end

function UIChampionDuelGroup:TryGetScrollItem(listview, index)
  local groupList = DataCenter.ChampionDuelManager:GetGroupList()
  local dataList = groupList ~= nil and groupList.ranks
  if table.IsNullOrEmpty(dataList) then
    return nil
  end
  local len = #dataList
  local idx = index + 1
  if idx < 1 or len < idx then
    return nil
  end
  local csItem = listview:NewListViewItem("UICD_GroupCell")
  local item = self.rankCells[csItem]
  if item == nil then
    local prefabIndex = self.prefabIndex or 0
    local nameStr = "Cell" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = nameStr
    item = self.content:AddComponent(UIChampionDuelGroupCell, nameStr)
    self.rankCells[csItem] = item
  end
  if item ~= nil then
    local groupItem = groupList:GetRank(idx)
    item:ReInit(groupItem, false, self.signStageId)
  end
  return csItem
end

function UIChampionDuelGroup:OnGroupItemClick(group)
  if self.group ~= group then
    DataCenter.ChampionDuelManager:SendGroupList(group, 1, 100, self.signStageId)
  end
  self.group = group
  self.groupShow = false
  if self.signStageId == nil then
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    if stageId >= ChampionDuelState.RematchAnnouncement then
      self.group_text:SetLocalText("champion_duel_tips1137")
      self.group_arr:SetActive(false)
      return
    end
  end
  local groupChar = DataCenter.ChampionDuelManager:GetGroupLetter(group)
  self.group_text:SetLocalText("champion_duel_tips1022", groupChar)
  self:RefreshGroupSel()
end

function UIChampionDuelGroup:OnBtnGroupClick()
  if self.signStageId == nil then
    local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
    if stageId >= ChampionDuelState.RematchAnnouncement then
      return
    end
  end
  self.groupShow = not self.groupShow
  self:RefreshGroupSel()
end

function UIChampionDuelGroup:RefreshGroupSel()
  if self.signStageId ~= nil then
    self.group_arr:LoadSpriteAuto(self.groupShow and IMG_UP_PATH or IMG_DOWN_PATH)
  else
    self.group_arr:LoadSpriteAuto(self.groupShow and IMG_DOWN_PATH or IMG_UP_PATH)
  end
  self.group_arr:SetActive(true)
  self.group_content:SetActive(self.groupShow)
  if not self.groupShow then
    return
  end
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local groupCount = 0
  if self.signStageId == ChampionDuelState.PreStage then
    groupCount = actInfo ~= nil and actInfo.auditionStageGroupCount or 0
  elseif self.signStageId == ChampionDuelState.Rematch then
    groupCount = actInfo ~= nil and actInfo.semiFinalGroupCount or 0
  else
    groupCount = actInfo ~= nil and actInfo.groupCount or 0
  end
  if groupCount == 0 then
    self:ClearGroupItem()
    return
  end
  local max = math.max(#self.groupCells, groupCount)
  for i = 1, max do
    local obj = self.groupCells[i]
    if i <= groupCount then
      if obj then
        obj:SetActive(true)
      else
        local item = self.group_cell:GameObjectSpawn(self.group_content.transform)
        item.name = "item" .. i
        obj = self.group_content:AddComponent(UIChampionDuelGroupItem, item.name)
        table.insert(self.groupCells, obj)
      end
      obj:ReInit(i, self.group, self.myGroup, BindCallback(self, self.OnGroupItemClick))
    elseif obj then
      obj:SetActive(false)
    end
  end
end

return UIChampionDuelGroup
