local UIBFBaseSelectUserView = BaseClass("UIBFBaseSelectUserView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local img_corner_path = "PopUpTitle/Common_bg_orange/Corner/TeamIcon"
local base_node_path = "PopUpTitle/Common_bg_orange2"
local btn_ok_path = "PopUpTitle/Common_bg_orange2/BtnOK"
local scroll_view_path = "PopUpTitle/Common_bg_orange2/ScrollView"
local view_port_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local find_path = "PopUpTitle/Common_bg_orange2/Find"
local find_input_field_path = "PopUpTitle/Common_bg_orange2/Find/FindInputField"
local find_clear_btn_path = "PopUpTitle/Common_bg_orange2/Find/FindClearBtn"
local battle_time_path = "PopUpTitle/Common_bg_orange2/BattleTime"
local battle_time_tips_text_path = "PopUpTitle/Common_bg_orange2/BattleTime/BattleTimeTitleContent/BattleTimeTipsText"
local change_show_time_btn_path = "PopUpTitle/Common_bg_orange2/BattleTime/BattleTimeTitleContent/ChangeShowTimeBtn"
local battle_time_data_text_path = "PopUpTitle/Common_bg_orange2/BattleTime/BattleTimeContent/BattleTimeDataText"
local battle_time_text_path = "PopUpTitle/Common_bg_orange2/BattleTime/BattleTimeContent/BattleTimeText"
local TIME_INTERVAL_TIME = 3
local PREFAB_TOPBAR_PATH = "Assets/Main/Prefabs/UI/BattleField/BattleFieldCommonSelectUser/SelectUserTopbar.prefab"
local PREFAB_TITLECONTENT_PATH = "Assets/Main/Prefabs/UI/BattleField/BattleFieldCommonSelectUser/SelectUserTitleContent.prefab"
local PREFAB_MEMBERLIST_PATH = "Assets/Main/Prefabs/UI/BattleField/BattleFieldCommonSelectUser/SelectUserMemberList.prefab"
local PREFAB_MEMBERITEM_PATH = "Assets/Main/Prefabs/UI/BattleField/BattleFieldCommonSelectUser/SelectUserMemberItem.prefab"

function UIBFBaseSelectUserView:OnCreate()
  self.isCommanderModuleEnable = self.ctrl:IsCommanderModuleEnable()
  self.isShowBattleTimeModuleEnable = self.ctrl:IsShowBattleTimeModuleEnable()
  self.IsTeamSelectBattleTimeModuleEnable = self.ctrl:IsTeamSelectBattleTimeModuleEnable()
  self.UIBFBaseSelectUserInfo = self.ctrl:GetSelectUserInfoClass()
  self.UIBFBaseSelectUserItem = self.ctrl:GetSelectUserItemClass()
  self.UIBFBaseSelectUserTitle = self.ctrl:GetSelectUserTitleClass()
  self.UIBFBaseSelectUserTopBar = self.ctrl:GetSelectUserTopBarClass()
  base.OnCreate(self)
  local args = self:GetUserData()
  self.curTabIdx = args.group or self.group
  self.role = args.role or self.roles
  self.isPrepTime = self.ctrl:IsInPrepTime()
  self:GetTeamBattlePeriod()
  self.isShowLocalBattleTime = BattleFieldUtil.GetShowLocalTime()
  self.curBattleTimeInfo = nil
  self.powerArmyMode = false
  self.searchInputValue = nil
  self.fromSearch = false
  self.rankGroupShowMember = {}
  for i = 1, 5 do
    self.rankGroupShowMember[i] = false
  end
  local myself = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
  self.needOpenRank = myself and myself.rank or 0
  self:ComponentDefineBase()
  self:UpdateData()
  self.battleTime = self.ctrl:GetBattleTimeInfo()
  self.isRefreshMemberShowBattleTime = true
  self.refreshMemberShowBattleTimeInterval = TIME_INTERVAL_TIME
end

function UIBFBaseSelectUserView:GetTeamBattlePeriod()
  self.teamBattlePeriod = self.ctrl:GetTeamBattlePeriod(self.curTabIdx)
  if not self.IsTeamSelectBattleTimeModuleEnable then
    local timeInfo = self.ctrl:GetBattleTimeInfo()
    self.ctrl:SetFilterBattleTimeData(timeInfo[1])
  else
    self.ctrl:SetFilterBattleTimeData(nil)
  end
end

function UIBFBaseSelectUserView:OnDestroy()
  self.isRefreshMemberShowBattleTime = false
  self.refreshMemberShowBattleTimeInterval = 0
  self:ComponentDestroyBase()
  base.OnDestroy(self)
end

function UIBFBaseSelectUserView:OnDragonBattleTimes()
  if not self.isPrepTime then
    self:ShowBattleTime()
  end
  self:CreateFilterBattleTimeItem()
end

function UIBFBaseSelectUserView:OnBattleFilterSelectBattleTime(filterBattleTimeData)
  self.isRefreshMemberShowBattleTime = filterBattleTimeData == nil
  if self.isPrepTime and filterBattleTimeData ~= nil and filterBattleTimeData.curTabIdx ~= nil then
    self.curTabIdx = filterBattleTimeData.curTabIdx
  end
  self:ShowFilterResult()
end

function UIBFBaseSelectUserView:OnBattleChangeShowLocalTime()
  self.isShowLocalBattleTime = BattleFieldUtil.GetShowLocalTime()
  self:RefreshBattleTimeShow()
  self:RefreshFilterBattleTimeShow()
end

function UIBFBaseSelectUserView:OnTeamSelfApplySuccess()
end

function UIBFBaseSelectUserView:ComponentDefineBase()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.img_corner = self:AddComponent(UIImage, img_corner_path)
  self:RefreshTeamSprite()
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.loop_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.loop_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.find = self:AddComponent(UIInput, find_path)
  self.find_input_field = self:AddComponent(UIInput, find_input_field_path)
  self.find_input_field:SetText("")
  self.find_input_field:SetOnValueChange(function(value)
    self:SearchIptOnValueChange(value)
  end)
  self.find_clear_btn = self:AddComponent(UIButton, find_clear_btn_path)
  self.find_clear_btn:SetOnClick(function()
    self.find_input_field:SetText("")
  end)
  self.find_clear_btn:SetActive(false)
  self:TopTitleComponentDefine()
  self:TopBarComponentDefine()
  self:ShowBattleTimeComponentDefine()
  self:OKBtnComponentDefine()
  self:SetScrollViewPosAndSize(self.isPrepTime)
  if not self.isPrepTime then
    self:ShowBattleTime()
  end
  self:RefreshMemberList()
  self.Updating = true
  self.scroll_view:AddValueChangeListener(function(_)
    self:OnScrollValueChange()
  end)
end

function UIBFBaseSelectUserView:ShowBattleTimeComponentDefine()
  if self.isShowBattleTimeModuleEnable then
    self.battle_time_root = self:AddComponent(UIBaseContainer, battle_time_path)
    self.battle_time_tips_text = self:AddComponent(UIText, battle_time_tips_text_path)
    self.change_show_time_btn = self:AddComponent(UIButton, change_show_time_btn_path)
    self.change_show_time_btn:SetOnClick(function()
      self:ChangeShowTimeBtnClick()
    end)
    self.battle_time_data_text = self:AddComponent(UIText, battle_time_data_text_path)
    self.battle_time_text = self:AddComponent(UIText, battle_time_text_path)
    self.battle_time_root:SetActive(false)
  end
end

function UIBFBaseSelectUserView:OKBtnComponentDefine()
  self.btn_ok = self:AddComponent(UIButton, btn_ok_path)
  self.btn_ok:SetActive(not self.isPrepTime)
  if not self.isPrepTime then
    self.btn_ok:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldChangeTime, {anim = true}, nil, self.ctrl:GetBattlefieldType())
    end)
  end
end

function UIBFBaseSelectUserView:TopBarComponentDefine()
  local prefabTopBarPath = self.ctrl:GetTopBarPrefabPath() or PREFAB_TOPBAR_PATH
  self.topBar = self:LoadComponentAsync(self.UIBFBaseSelectUserTopBar, prefabTopBarPath, self.transform:Find(base_node_path), function()
    self.topBar:SetAnchoredPositionXY(0, -20)
    self:UpdateData()
  end)
end

function UIBFBaseSelectUserView:TopTitleComponentDefine()
  local prefabTitleContentPath = self.ctrl:GetTitleContentPrefabPath() or PREFAB_TITLECONTENT_PATH
  self.content_title = self:LoadComponentAsync(self.UIBFBaseSelectUserTitle, prefabTitleContentPath, self.transform:Find(view_port_path), function()
    self.content_title:SetAnchoredPositionXY(0, 1)
    self:OnScrollValueChange(true)
  end)
end

function UIBFBaseSelectUserView:OnScrollValueChange(bForce)
  if self.content_title == nil or not self.content_title:AsyncLoadDone() then
    return
  end
  if self.Updating and not bForce then
    self.content_title:SetActive(false)
    return
  end
  local showListItemData
  if self.showDatalist ~= nil then
    for i, v in ipairs(self.showDatalist) do
      local item = self.loop_view:GetShownItemByItemIndex(i - 1)
      if item and self.loop_view:GetItemCornerPosInViewPort(item).y < -58 then
        break
      end
      if v.type == "RankTitle" and self:GetRankGroupShowMember(v.rankId) then
        showListItemData = v
      end
    end
  end
  if showListItemData then
    self.content_title:SetData(showListItemData, true)
    self.content_title:SetActive(true)
  else
    self.content_title:SetActive(false)
  end
end

function UIBFBaseSelectUserView:Update1000MS()
  if self.Updating then
    self.Updating = false
  end
  if not self.isRefreshMemberShowBattleTime then
    self.refreshMemberShowBattleTimeInterval = TIME_INTERVAL_TIME
    return
  end
  self.refreshMemberShowBattleTimeInterval = self.refreshMemberShowBattleTimeInterval - 1
  if self.refreshMemberShowBattleTimeInterval == 0 then
    self.refreshMemberShowBattleTimeInterval = TIME_INTERVAL_TIME
    EventManager:GetInstance():Broadcast(EventId.BattlefieldRefreshMemberBattleTimeShow)
  end
end

function UIBFBaseSelectUserView:ShowBattleTime()
  if self.isShowBattleTimeModuleEnable then
    if self.ctrl:IsInPrepTime() then
      self.battle_time_root:SetActive(false)
      return
    end
    if not self.ctrl:IsTeamSignUp(self.curTabIdx) then
      self.battle_time_root:SetActive(false)
      return
    end
    self.battleTime = self.ctrl:GetBattleTimeInfo()
    if self.battleTime == nil then
      self.battle_time_root:SetActive(false)
      return
    end
    local battlePeriod = self.teamBattlePeriod or 0
    for _, v in ipairs(self.battleTime) do
      if v ~= nil and v.battlePeriod == battlePeriod then
        self.battle_time_root:SetActive(true)
        self.curBattleTimeInfo = v
        self:RefreshBattleTimeShow()
        break
      end
    end
  end
end

function UIBFBaseSelectUserView:RefreshBattleTimeShow()
  if self.isShowBattleTimeModuleEnable and self.curBattleTimeInfo then
    if self.isShowLocalBattleTime then
      self.battle_time_tips_text:SetLocalText("Desert_strom_tips1001")
      local dataStr = UITimeManager:GetInstance():GetTimeToLocalYMD(math.modf(self.curBattleTimeInfo.startTime))
      self.battle_time_data_text:SetText(Localization:GetString("Desert_strom_tips1017") .. ": " .. dataStr)
      local startTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.curBattleTimeInfo.startTime, true, true)
      local endTimeLocalStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.curBattleTimeInfo.endTime, true, true)
      self.battle_time_text:SetText(startTimeLocalStr .. " ~ " .. endTimeLocalStr)
    else
      self.battle_time_tips_text:SetLocalText("Desert_strom_tips1002")
      local dataStr = UITimeManager:GetInstance():GetTimeToMD(math.modf(self.curBattleTimeInfo.startTime / 1000))
      self.battle_time_data_text:SetText(Localization:GetString("Desert_strom_tips1017") .. ": " .. dataStr)
      local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.curBattleTimeInfo.startTime, true)
      local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServerSimple(self.curBattleTimeInfo.endTime, true)
      self.battle_time_text:SetText(startTimeStr .. " ~ " .. endTimeStr)
    end
  end
end

function UIBFBaseSelectUserView:DoComboxCollapse(sort)
  if sort then
    self:RefreshMemberList()
    self:UpdateData()
  end
end

function UIBFBaseSelectUserView:ClearTheListReqs()
  self.content:RemoveComponents(self.UIBFBaseSelectUserItem)
  self.content:RemoveComponents(self.UIBFBaseSelectUserInfo)
  if self.loop_view then
    self.loop_view:ClearAllItems()
  end
  self.showDatalist = {}
end

function UIBFBaseSelectUserView:ComponentDestroyBase()
  self:ClearTheListReqs()
  self.btn_back = nil
  self.topBar = nil
  self.battle_time_tips_text = nil
  self.change_show_time_btn = nil
  self.battle_time_data_text = nil
  self.battle_time_text = nil
  self.find = nil
  self.find_input_field = nil
  self.find_clear_btn = nil
  self.loop_view = nil
  self.showDatalist = nil
  self.rankGroupShowMember = nil
  self.searchInputValue = nil
  self.fromSearch = nil
end

function UIBFBaseSelectUserView:UpdateData()
  local mainCount = 0
  local subCount = 0
  local comCount = 0
  local playerList = self.ctrl:GetPlayerList()
  local playerState = {}
  local playerGroups = {}
  for uid, v in pairs(playerList) do
    if self.curTabIdx == 0 or v.team == self.curTabIdx or v.group == self.curTabIdx then
      if v.state == DragonPlayerState.Main then
        mainCount = mainCount + 1
      elseif v.state == DragonPlayerState.Sub then
        subCount = subCount + 1
      end
    end
    playerState[uid] = v.state
    playerGroups[uid] = v.team or v.group
  end
  self.playerState = playerState
  self.playerGroups = playerGroups
  if self.isCommanderModuleEnable then
    local playerCommander = {}
    for uid, v in pairs(playerList) do
      if (self.curTabIdx == 0 or v.team == self.curTabIdx or v.group == self.curTabIdx) and self.ctrl:IsCommander(v) then
        comCount = comCount + 1
      end
      playerCommander[uid] = v.commander
    end
    self.playerCommander = playerCommander
  end
  self:UpdateNum(mainCount, subCount, comCount)
  if self.showDatalist ~= nil then
    self:RefreshContent()
  end
end

function UIBFBaseSelectUserView:CheckCommanderFull(group)
  if self.isCommanderModuleEnable then
    local comCount = 0
    for k, v in pairs(self.playerState) do
      if self.playerGroups[k] == group and self.playerCommander[k] then
        comCount = comCount + 1
      end
    end
    return 3 <= comCount
  end
end

function UIBFBaseSelectUserView:SetPlayerState(uid, state, bCommander)
  local mainCount = 0
  local subCount = 0
  local comCount = 0
  if state ~= nil then
    self.playerState[uid] = state
    self.playerGroups[uid] = state == 0 and 0 or self.curTabIdx
  end
  for k, v in pairs(self.playerState) do
    if self.curTabIdx == 0 or self.playerGroups[k] == self.curTabIdx then
      if v == DragonPlayerState.Main then
        mainCount = mainCount + 1
      elseif v == DragonPlayerState.Sub then
        subCount = subCount + 1
      end
    end
  end
  self:UpdateNum(mainCount, subCount, comCount)
  if state ~= nil then
    if state == DragonPlayerState.None then
      self.ctrl:CancelPlayer(uid, self.curTabIdx)
    else
      self.ctrl:SelectPlayer(uid, state, self.curTabIdx)
    end
  end
  if self.isCommanderModuleEnable then
    if bCommander ~= nil then
      self.playerCommander[uid] = bCommander
    end
    if state == 0 then
      self.playerCommander[uid] = false
    end
    for k, v in pairs(self.playerState) do
      if (self.curTabIdx == 0 or self.playerGroups[k] == self.curTabIdx) and self.playerCommander[k] then
        comCount = comCount + 1
      end
    end
    if bCommander ~= nil then
      self.ctrl:SendCommanderModify(uid, self.playerGroups[uid], bCommander and 1 or 2)
    end
  end
end

function UIBFBaseSelectUserView:SetPlayerCommander(uid, bCommander)
  if self.isCommanderModuleEnable and bCommander then
    local cGroup = self.playerGroups and self.playerGroups[uid] or 0
    if self:CheckCommanderFull(cGroup) then
      return false
    end
  end
  self:SetPlayerState(uid, nil, bCommander)
  return true
end

function UIBFBaseSelectUserView:FocusTo(uid)
  local member = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
  if member and member.rank then
    for i = 1, 5 do
      self.rankGroupShowMember[i] = i == member.rank
    end
    self:RefreshMemberList()
    if self.loop_view and self.showDatalist then
      for idx, v in ipairs(self.showDatalist) do
        if v.type == "MemberItem" and v.uid == uid then
          self.loop_view:MovePanelToItemIndex(idx - 1, 86)
          break
        end
      end
    end
  end
end

function UIBFBaseSelectUserView:UpdateNum(curNumMain, curNumSub, curNumCom)
  if self.topBar and self.topBar:AsyncLoadDone() then
    self.topBar:UpdateNum(curNumMain, curNumSub, curNumCom)
  end
end

function UIBFBaseSelectUserView:ScrollTo(rank, index)
  if not self.loop_view or not self.showDatalist then
    return
  end
  local curRank = 0
  local curIndex = 0
  for idx, v in ipairs(self.showDatalist) do
    if v.type == "RankTitle" then
      curRank = v.rankId
      curIndex = 0
    elseif v.type == "MemberItem" and curRank == rank then
      curIndex = curIndex + 1
      if curIndex == index then
        self.loop_view:MovePanelToItemIndex(idx - 1, 0)
        break
      end
    end
  end
end

function UIBFBaseSelectUserView:ChangeShowTimeBtnClick()
  self.isShowLocalBattleTime = not self.isShowLocalBattleTime
  BattleFieldUtil.SetShowLocalTime(self.isShowLocalBattleTime)
end

function UIBFBaseSelectUserView:SetScrollViewPosAndSize(changeBig)
  if changeBig then
    self.scroll_view:SetAnchoredPositionXY(375, -165)
    self.scroll_view:SetSizeDelta(Vector2.New(750, 844))
  else
    self.scroll_view:SetAnchoredPositionXY(375, -165)
    self.scroll_view:SetSizeDelta(Vector2.New(750, 720))
  end
end

function UIBFBaseSelectUserView:CreateFilterBattleTimeItem()
  if self.topBar and self.topBar:AsyncLoadDone() then
    self.topBar:CreateFilterBattleTimeItem()
  end
end

function UIBFBaseSelectUserView:ShowFilterResult()
  if self.topBar and self.topBar:AsyncLoadDone() then
    self.topBar:ShowFilterResult()
  end
end

function UIBFBaseSelectUserView:RefreshFilterBattleTimeShow()
  if self.topBar and self.topBar:AsyncLoadDone() then
    self.topBar:RefreshFilterBattleTimeShow()
  end
end

function UIBFBaseSelectUserView:RefreshFilterRankingMember()
  local targetExpandRankData = self:GetTargetExpandRank()
  local targetRank = 0
  if targetExpandRankData and targetExpandRankData.targetExpandRank then
    targetRank = targetExpandRankData.targetExpandRank
  else
    local myself = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
    targetRank = myself and myself.rank or 0
  end
  for i = 1, 5 do
    self.rankGroupShowMember[i] = i == targetRank
  end
  self:RefreshMemberList()
  self:UpdateData()
end

function UIBFBaseSelectUserView:GetTargetExpandRank()
  local param = {}
  param.targetExpandRank = 0
  param.targetPlayerUuid = 0
  local filterBattleTimeData = self.ctrl:GetFilterBattleTimeData()
  if filterBattleTimeData then
    local selfInfo = self.ctrl:GetPlayerInfoByUID(LuaEntry.Player:GetUid())
    if selfInfo and selfInfo:IsContainerBattleTime(filterBattleTimeData.battlePeriod) then
      local myself = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
      if myself then
        param.targetExpandRank = myself.rank or 0
        param.targetPlayerUuid = LuaEntry.Player:GetUid()
      end
    end
    if param.targetExpandRank == 0 then
      local playerList = self.ctrl:GetPlayerList()
      for i = 5, 1, -1 do
        local list = DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(i)
        for _, v in ipairs(list) do
          local info = playerList[v.uid]
          if info and info:IsContainerBattleTime(filterBattleTimeData.battlePeriod) then
            param.targetExpandRank = i
            param.targetPlayerUuid = ""
            break
          end
        end
        if param.targetExpandRank ~= 0 then
          break
        end
      end
    end
    return param
  end
end

function UIBFBaseSelectUserView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BattlefieldPlayerListUpdate, self.UpdateData)
  self:AddUIListener(EventId.BattlefieldFilterSelectBattleTime, self.OnBattleFilterSelectBattleTime)
  self:AddUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnBattleChangeShowLocalTime)
  self:AddUIListener(EventId.BattlefieldTeamSelfApplySuccess, self.OnTeamSelfApplySuccess)
end

function UIBFBaseSelectUserView:OnRemoveListener()
  self:RemoveUIListener(EventId.BattlefieldPlayerListUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.BattlefieldFilterSelectBattleTime, self.OnBattleFilterSelectBattleTime)
  self:RemoveUIListener(EventId.BattleFieldChangeShowLocalTime, self.OnBattleChangeShowLocalTime)
  self:RemoveUIListener(EventId.BattlefieldTeamSelfApplySuccess, self.OnTeamSelfApplySuccess)
  base.OnRemoveListener(self)
end

function UIBFBaseSelectUserView:RefreshMemberList()
  if self.needOpenRank and self.needOpenRank > 0 then
    self.rankGroupShowMember[self.needOpenRank] = true
    self.needOpenRank = 0
  end
  self:RefreshContent()
end

function UIBFBaseSelectUserView:SearchIptOnValueChange(value)
  self.find_clear_btn:SetActive(not string.IsNullOrEmpty(value))
  self.searchInputValue = value
  self.fromSearch = true
  self:RefreshMemberList()
  self.fromSearch = false
end

function UIBFBaseSelectUserView:SetSortType(list, powerArmyMode)
  if list ~= nil then
    table.sort(list, function(a, b)
      if powerArmyMode then
        return (a.armyPower or 0) > (b.armyPower or 0)
      end
      return (a.power or 0) > (b.power or 0)
    end)
  end
end

function UIBFBaseSelectUserView:GetRankGroupShowMember(rank)
  return self.rankGroupShowMember and self.rankGroupShowMember[rank]
end

function UIBFBaseSelectUserView:SetRankGroupShowMember(rank, showMember)
  if self.rankGroupShowMember == nil then
    self.rankGroupShowMember = {}
  end
  self.rankGroupShowMember[rank] = showMember
  self:RefreshMemberList()
end

function UIBFBaseSelectUserView:GetRankTitleData(rank)
  local list = self.ctrl:GetMemberListByRank(rank)
  self:SetSortType(list, self.powerArmyMode)
  list = self:FilterMemberListByKeyword(list, rank)
  list = self:FilterMemberListByPrepTime(list)
  list = self:FilterMemberListByBattleTime(list)
  local onlineNum = 0
  local mainCount = 0
  local subCount = 0
  local comCount = 0
  local playerList = self.ctrl:GetPlayerList()
  for _, v in ipairs(list) do
    if v.isOnline then
      onlineNum = onlineNum + 1
    end
    local info = playerList[v.uid]
    if info and (self.curTabIdx == 0 or self.curTabIdx == info.team or self.curTabIdx == info.group) then
      if info.state == DragonPlayerState.Main then
        mainCount = mainCount + 1
      elseif info.state == DragonPlayerState.Sub then
        subCount = subCount + 1
      end
      if self.isCommanderModuleEnable and self.ctrl:IsCommander(info) then
        comCount = comCount + 1
      end
    end
  end
  return {
    type = "RankTitle",
    rankId = rank,
    rank = rank,
    showMember = self:GetRankGroupShowMember(rank) == true,
    onlineNum = onlineNum,
    allNum = #list,
    mainCount = mainCount,
    subCount = subCount,
    comCount = comCount
  }, list
end

function UIBFBaseSelectUserView:FilterMemberListByPrepTime(list)
  if list == nil then
    return {}
  end
  if not self.isPrepTime or self.curTabIdx == 0 then
    return list
  end
  local ret = {}
  local playerList = self.ctrl:GetPlayerList()
  for _, memberData in ipairs(list) do
    local info = playerList and playerList[memberData.uid] or nil
    if info and (self.curTabIdx == info.team or self.curTabIdx == info.group) then
      table.insert(ret, memberData)
    end
  end
  return ret
end

function UIBFBaseSelectUserView:FilterMemberListByKeyword(list, rank)
  if list == nil then
    return {}
  end
  if string.IsNullOrEmpty(self.searchInputValue) then
    return list
  end
  local keyword = string.lower(self.searchInputValue)
  local ret = {}
  for _, memberData in ipairs(list) do
    local isFind = false
    local lowerName = string.lower(memberData.name or "")
    if string.find(lowerName, keyword, 1, true) then
      isFind = true
    else
      local remarkName, haveRemark = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(memberData.uid, memberData.name)
      if haveRemark and not string.IsNullOrEmpty(remarkName) then
        remarkName = string.lower(remarkName)
        isFind = string.find(remarkName, keyword, 1, true) ~= nil
      end
    end
    if isFind then
      table.insert(ret, memberData)
    end
  end
  if self.fromSearch and 0 < #ret then
    self.rankGroupShowMember[rank] = true
  end
  return ret
end

function UIBFBaseSelectUserView:FilterMemberListByBattleTime(list)
  if list == nil then
    return {}
  end
  local filterBattleTimeData = self.ctrl:GetFilterBattleTimeData()
  if self.isPrepTime or filterBattleTimeData == nil then
    return list
  end
  local ret = {}
  local playerList = self.ctrl:GetPlayerList()
  for _, memberData in ipairs(list) do
    local info = playerList and playerList[memberData.uid] or nil
    if info and type(info.IsContainerBattleTime) == "function" and info:IsContainerBattleTime(filterBattleTimeData.battlePeriod) then
      table.insert(ret, memberData)
    end
  end
  return ret
end

function UIBFBaseSelectUserView:BuildShowDataList()
  local ret = {}
  local hasKeyword = not string.IsNullOrEmpty(self.searchInputValue)
  for rank = 5, 1, -1 do
    local titleData, list = self:GetRankTitleData(rank)
    if not hasKeyword or 0 < #list then
      table.insert(ret, titleData)
      if titleData.showMember then
        for _, memberData in ipairs(list) do
          memberData.type = "MemberItem"
          memberData.rankId = rank
          table.insert(ret, memberData)
        end
      end
    end
  end
  return ret
end

function UIBFBaseSelectUserView:RefreshContent()
  self.Updating = true
  self.showDatalist = self:BuildShowDataList()
  if self.loop_view then
    self.loop_view:SetListItemCount(#self.showDatalist, false, false)
    self.loop_view:RefreshAllShownItem()
  end
  self.Updating = false
  self:OnScrollValueChange(true)
end

function UIBFBaseSelectUserView:GetMemberListPrefabName()
  local path = self.ctrl.GetMemberListPrefabPath and self.ctrl:GetMemberListPrefabPath() or PREFAB_MEMBERLIST_PATH
  return string.match(path, "([^/]+)%.prefab$") or "SelectUserMemberList"
end

function UIBFBaseSelectUserView:GetMemberItemPrefabName()
  local path = self.ctrl.GetMemberItemPrefabPath and self.ctrl:GetMemberItemPrefabPath() or PREFAB_MEMBERITEM_PATH
  return string.match(path, "([^/]+)%.prefab$") or "SelectUserMemberItem"
end

function UIBFBaseSelectUserView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDatalist then
    return nil
  end
  local data = self.showDatalist[index]
  local prefabName = data.type == "RankTitle" and self:GetMemberListPrefabName() or self:GetMemberItemPrefabName()
  local itemScript = data.type == "RankTitle" and self.UIBFBaseSelectUserItem or self.UIBFBaseSelectUserInfo
  local item = loopScroll:NewListViewItem(prefabName)
  local script = self.content:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.content:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  script:SetData(data)
  return item
end

function UIBFBaseSelectUserView:RefreshTeamSprite()
  local hadTeam2 = self.ctrl:IsHadTeam2()
  local showFlag = hadTeam2 and not self.isPrepTime
  self.img_corner.transform.parent.gameObject:SetActive(showFlag)
  if showFlag then
    self.ctrl:LoadTeamSprite(self.img_corner, self.curTabIdx)
  end
end

return UIBFBaseSelectUserView
