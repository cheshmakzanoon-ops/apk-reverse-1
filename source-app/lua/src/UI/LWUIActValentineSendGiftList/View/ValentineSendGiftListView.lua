local ValentineSendGiftListView = BaseClass("ValentineSendGiftListView", UIBaseView)
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local SendGiftListItem = require("UI.LWUIActValentineSendGiftList.Component.SendGiftListItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "Root/CloseBtn"
local content_path = "Root/TabArea/Content"
local scroll_rect_path = "Root/ScrollRect"
local item_content_path = "Root/ScrollRect/ItemContent"
local loading_obj_path = "Root/ScrollRect/ItemContent/LoadingObj"
local all_toggle_btn_path = "Root/GenderFilterArea/AllToggle/AllToggleBtn"
local all_select_img_path = "Root/GenderFilterArea/AllToggle/AllToggleBtn/AllSelectImg"
local girls_toggle_btn_path = "Root/GenderFilterArea/GirlsToggle/GirlsToggleBtn"
local girls_select_img_path = "Root/GenderFilterArea/GirlsToggle/GirlsToggleBtn/GirlsSelectImg"
local boys_toggle_btn_path = "Root/GenderFilterArea/BoysToggle/BoysToggleBtn"
local boys_select_img_path = "Root/GenderFilterArea/BoysToggle/BoysToggleBtn/BoysSelectImg"
local find_click_btn_path = "Root/FindArea/FindClickBtn"
local find_input_field_path = "Root/FindArea/FindInputField"
local setting_btn_path = "Root/FindArea/SettingBtn"
local req_server_data_loading_path = "Root/ScrollRect/ReqServerDataLoading"
local match_server_info_text1_path = "Root/TabArea/Content/UICommonTab2/unSelectFlag/MatchServerInfoText1"
local match_server_info_text2_path = "Root/TabArea/Content/UICommonTab2/selectFlag/MatchServerInfoText2"
local follow_effect_node_path = "Root/followEffectNode"
local SINGLE_REQ_DATA_COUNT = 20
local REQ_DATA_INTERVAL = 1
local VFX_MOVE_TIME = 0.8
local NPC_ENTER_HISTORY_TIME = 0.8
local ShowTabType = {
  SelfServer = ValentineSendGiftScope.SelfServer,
  ZoneServer = ValentineSendGiftScope.ZoneServer,
  Alliance = ValentineSendGiftScope.Alliance
}
local ShowTabTextKey = {
  [ValentineSendGiftScope.SelfServer] = "activity_99136_20",
  [ValentineSendGiftScope.ZoneServer] = "activity_99136_21",
  [ValentineSendGiftScope.Alliance] = "activity_99136_22"
}
local LoadPlayDataStat = {Idle = 1, Loading = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData().activityId
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelCloseBtn = self:AddComponent(UIButton, panel_path)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scrollContainer = self:AddComponent(UIBaseContainer, scroll_rect_path)
  self.itemContent = self:AddComponent(GridInfinityScrollView, item_content_path)
  self.scrollRect = self:AddComponent(UIEventTrigger, scroll_rect_path)
  self.scrollRect:OnEndDrag(function(eventData)
    self:CheckPullDataWhenEndDrag()
  end)
  self.scrollRect:OnDrag(function(eventData)
    self:CheckIsShowLoadingObjWhenDrag()
  end)
  self.allToggleBtn = self:AddComponent(UIButton, all_toggle_btn_path)
  self.allToggleSelectImg = self:AddComponent(UIBaseContainer, all_select_img_path)
  self.girlsToggleBtn = self:AddComponent(UIButton, girls_toggle_btn_path)
  self.girlsSelectImg = self:AddComponent(UIBaseContainer, girls_select_img_path)
  self.boysToggleBtn = self:AddComponent(UIButton, boys_toggle_btn_path)
  self.boySelectImg = self:AddComponent(UIBaseContainer, boys_select_img_path)
  self.allSelectImgList = {}
  self.allSelectImgList[GenderFilterType.All] = self.allToggleSelectImg
  self.allSelectImgList[GenderFilterType.Female] = self.girlsSelectImg
  self.allSelectImgList[GenderFilterType.Male] = self.boySelectImg
  self.allToggleBtn:SetOnClick(function()
    self:SelectGenderFilter(GenderFilterType.All)
  end)
  self.girlsToggleBtn:SetOnClick(function()
    self:SelectGenderFilter(GenderFilterType.Female)
  end)
  self.boysToggleBtn:SetOnClick(function()
    self:SelectGenderFilter(GenderFilterType.Male)
  end)
  self.tabList = {}
  for i = 1, table.count(ShowTabType) do
    local tabName = string.format("UICommonTab%s", i)
    self.tabList[i] = self:AddComponent(UICommonTab, content_path .. "/" .. tabName)
    local param = {}
    param.tabId = i
    param.title = Localization:GetString(ShowTabTextKey[i])
    
    function param.clickHandler()
      self:OnTabClick(param.tabId)
    end
    
    self.tabList[i]:ReInit(param)
  end
  self.reqLoadingObj = self:AddComponent(UIBaseContainer, loading_obj_path)
  local rW, rH = self.reqLoadingObj.rectTransform:Get_sizeDelta()
  self.loadingObjHeight = rH
  local sW, sH = self.scrollContainer.rectTransform:Get_sizeDelta()
  self.scrollRectHeight = sH
  self.searchBtn = self:AddComponent(UIButton, find_click_btn_path)
  self.searchBtn:SetOnClick(function()
    self:OnSearchBtnClick()
  end)
  self.find_input_field = self:AddComponent(UIInput, find_input_field_path)
  self.find_input_field:SetCharacterLimit(1000)
  self.find_input_field:SetText("")
  self.find_input_field:SetOnValueChange(function(value)
    self:OnSearchInputFieldChange(value)
  end)
  self.setting_btn = self:AddComponent(UIButton, setting_btn_path)
  self.setting_btn:SetOnClick(function()
    self:OnSettingBtnClick()
  end)
  self.reqServerDataLoadingObj = self:AddComponent(UIBaseContainer, req_server_data_loading_path)
  self.serverMatchInfoText1 = self:AddComponent(UIText, match_server_info_text1_path)
  self.serverMatchInfoText2 = self:AddComponent(UIText, match_server_info_text2_path)
  self.npcHistoryNode = self:AddComponent(UIBaseContainer, "Root/npcHistoryNode")
  self.npcHistoryBtn = self:AddComponent(UIButton, "Root/npcHistoryNode/npcHistoryBtn")
  self.npcHistoryBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIValentineNpcCollect, {anim = true}, self.activityId)
  end)
  self.npcTipsNode = self:AddComponent(UIBaseContainer, "Root/npcTipsNode")
  self.npcTipDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/npcTipsNode/npcTipDesc")
  self.npcTipBtn = self:AddComponent(UIButton, "Root/npcTipsNode/npcTipBtn")
  self.npcTipBtn:SetOnClick(function()
    if self.cacheNpcDataRankIndex then
      local targetRank = self.cacheNpcDataRankIndex
      self.itemContent:MoveItemByIndex(self.cacheNpcDataRankIndex - 1, 0)
      EventManager:GetInstance():Broadcast(EventId.ValentineNpcGetRewardWeekFinger, targetRank)
    end
  end)
  self.npcTipsNode:SetActive(false)
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.npcHistoryNodeAni = self:AddComponent(UISimpleAnimation, "Root/npcHistoryNode")
  self.followEffectNode = self:AddComponent(UIVfx, follow_effect_node_path)
  self.followEffectNode:SetActive(false)
end

local function ComponentDestroy(self)
  self:ClearRewardGetVfx()
  self:ClearItemCell()
  self.cellItems = nil
  self.setting_btn = nil
  self.followEffectNode = nil
  DataCenter.ValentineDataManager:ClearHotAddCache()
end

local function DataDefine(self)
  self.curShowDataList = {}
  self.listGO = {}
  self.reqDataState = LoadPlayDataStat.Idle
  self.curSelectScope = ShowTabType.SelfServer
  self.curSelectGender = GenderFilterType.All
  self.isShowSearchResult = false
  self.searchResultDataList = {}
end

local function DataDestroy(self)
  self.curShowDataList = nil
  self.listGO = nil
  self.reqDataState = nil
  self.curSelectScope = nil
  self.curSelectGender = nil
  self.isShowSearchResult = nil
  self.searchResultDataList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineSendGiftListDataUpdate, self.OnSendGiftListDataUpdate)
  self:AddUIListener(EventId.ValentineSendGiftListDataFail, self.OnSendGiftListDataGetFail)
  self:AddUIListener(EventId.SendContactGiftSearchBack, self.OnReceiveSearchResult)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnLikeSuccess)
  self:AddUIListener(EventId.ValentineNpcHistoryUpdate, self.OnRefreshHistoryNodeStatus)
  self:AddUIListener(EventId.ValentineNpcRewardGet, self.OnRefreshHistoryNodeStatus)
  self:AddUIListener(EventId.ValentinePlayFollowEffect, self.PlayFollowEffect)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineSendGiftListDataUpdate, self.OnSendGiftListDataUpdate)
  self:RemoveUIListener(EventId.ValentineSendGiftListDataFail, self.OnSendGiftListDataGetFail)
  self:RemoveUIListener(EventId.SendContactGiftSearchBack, self.OnReceiveSearchResult)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnLikeSuccess)
  self:RemoveUIListener(EventId.ValentineNpcHistoryUpdate, self.OnRefreshHistoryNodeStatus)
  self:RemoveUIListener(EventId.ValentineNpcRewardGet, self.OnRefreshHistoryNodeStatus)
  self:RemoveUIListener(EventId.ValentinePlayFollowEffect, self.PlayFollowEffect)
  base.OnRemoveListener(self)
end

function ValentineSendGiftListView:ReInit()
  DataCenter.ValentineDataManager:ClearSendGiftListData()
  DataCenter.ValentineDataManager:ClearHotAddCache()
  DataCenter.ValentineDataManager:SetActivityIdCache(self.activityId)
  self.npcHistoryNode:SetActive(false)
  self:ReqNpcHistoryData()
  self:ClearItemCell()
  self:SetLoadingState(LoadPlayDataStat.Idle)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.itemContent:Init(bindFunc1, bindFunc2, bindFunc3)
  self:OnTabClick(ShowTabType.SelfServer)
  self:RefreshServerMatchInfo()
end

function ValentineSendGiftListView:OnRefreshHistoryNodeStatus()
  local list, num = DataCenter.ValentineDataManager:GetCompleteNpc()
  self.npcHistoryNode:SetActive(0 < num)
end

function ValentineSendGiftListView:CheckNeedShowNpcTipsBubble(index)
  if self.curSelectScope ~= ValentineSendGiftScope.SelfServer then
    self.npcTipsNode:SetActive(false)
    return
  end
  if self.isShowSearchResult then
    self.npcTipsNode:SetActive(false)
    return
  end
  if self.curSelectGender ~= GenderFilterType.All then
    self.npcTipsNode:SetActive(false)
    return
  end
  if self.curSelectScope ~= ShowTabType.SelfServer then
    self.npcTipsNode:SetActive(false)
    return
  end
  local rank = index + 1
  local list, num = DataCenter.ValentineDataManager:GetNeedBubbleNpc()
  if num <= 0 then
    self.npcTipsNode:SetActive(false)
    return
  end
  local row = math.floor(index * 0.5)
  if self.lastRow == row then
    return
  end
  local toDown = false
  if not self.lastRow or row > self.lastRow then
    toDown = true
  end
  self.lastRow = row
  self.cacheNpcDataRankIndex = nil
  local showNum = 0
  for i, v in ipairs(list) do
    if toDown then
      if rank < v.rank then
        if not self.cacheNpcDataRankIndex then
          self.cacheNpcDataRankIndex = v.rank
        end
        showNum = showNum + 1
      end
    else
      local npcRow = math.floor(v.rank * 0.5)
      if npcRow > row + 3 then
        if not self.cacheNpcDataRankIndex then
          self.cacheNpcDataRankIndex = v.rank
        end
        showNum = showNum + 1
      end
    end
  end
  self.npcTipsNode:SetActive(0 < showNum)
  self.npcTipDesc:SetLocalText("Valentine_npc_pic_title_04")
end

function ValentineSendGiftListView:RefreshServerMatchInfo()
  self.serverMatchInfoText1:SetActive(false)
  self.serverMatchInfoText2:SetActive(false)
  if self.activityId <= 0 then
    return
  end
  local sendData = DataCenter.ValentineDataManager:GetActSendRankData(self.activityId)
  if not sendData then
    return
  end
  if not string.IsNullOrEmpty(sendData.matchServerInfo) then
    local ret = ""
    local serverInfoStr = string.split(sendData.matchServerInfo, ";")
    local index = 1
    for _, v in ipairs(serverInfoStr) do
      if index ~= 1 then
        ret = ret .. ","
      end
      ret = ret .. v
      index = index + 1
    end
    if not string.IsNullOrEmpty(ret) then
      self.serverMatchInfoText1:SetActive(true)
      self.serverMatchInfoText2:SetActive(true)
      self.serverMatchInfoText1:SetText(ret)
      self.serverMatchInfoText2:SetText(ret)
    end
  end
end

function ValentineSendGiftListView:OnInitScroll(go, index)
  local item = self.scrollContainer:AddComponent(SendGiftListItem, go)
  self.listGO[go] = item
end

function ValentineSendGiftListView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  go.name = "item_" .. index
  local searchDataList
  if self.isShowSearchResult and self.searchResultDataList then
    searchDataList = self.curShowDataList
  end
  local isShowRankBg = true
  if self.curSelectScope == ValentineSendGiftScope.Alliance or self.curSelectGender ~= 0 or self.isShowSearchResult then
    isShowRankBg = false
  end
  local param = {
    index = index + 1,
    activityId = self.activityId,
    curSelectScope = self.curSelectScope,
    curSelectGender = self.curSelectGender,
    customDataList = searchDataList,
    isShowRankBg = isShowRankBg
  }
  cellItem:SetData(param)
  cellItem:SetActive(true)
  self.cellItems[index + 1] = cellItem
  self:CheckNeedShowNpcTipsBubble(index)
end

function ValentineSendGiftListView:OnDestroyScrollItem(go, index)
  if index == self.curSelectCell then
    self.itemSelectFrame:SetActive(false)
  end
  self.cellItems[index + 1] = nil
end

function ValentineSendGiftListView:ClearItemCell()
  self.cellItems = {}
  self.scrollContainer:RemoveComponents(SendGiftListItem)
  self.reqLoadingObj.transform:SetParent(self.transform)
  self.itemContent:DestroyChildNode()
  self.reqLoadingObj.transform:SetParent(self.itemContent.transform)
end

function ValentineSendGiftListView:OnTabClick(tabType)
  if tabType == ShowTabType.Alliance and not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(800935)
    return
  end
  self.itemContent:SetItemCount(0)
  for i = 1, table.count(ShowTabType) do
    self.tabList[i]:SetSelect(i == tabType)
  end
  self.curShowDataList = {}
  self.searchResultDataList = {}
  self.prevSelectScope = self.curSelectScope
  self.curSelectScope = tabType
  self.isShowSearchResult = false
  self:SelectGenderFilter(GenderFilterType.All)
  self.find_input_field:SetText("")
end

function ValentineSendGiftListView:RefreshContent(moveScroll)
  local itemCount = #self.curShowDataList
  if 0 < itemCount then
    self.itemContent:SetItemCount(itemCount)
  end
end

function ValentineSendGiftListView:ReqServerData()
  if self.reqDataIntervalTimer then
    self.reqDataIntervalTimer:Stop()
  end
  self.reqDataIntervalTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.reqDataIntervalTimer = nil
  end, REQ_DATA_INTERVAL)
  local startIndex = self:GetRealStartIndex(self.curShowDataList)
  local endIndex = startIndex + SINGLE_REQ_DATA_COUNT - 1
  if self.curSelectScope == ValentineSendGiftScope.Alliance then
    endIndex = startIndex + 1
  end
  local cacheData = DataCenter.ValentineDataManager:GetSendGiftListData(self.activityId, self.curSelectScope, self.curSelectGender, startIndex, endIndex)
  if cacheData then
    self:OnSendGiftListDataUpdate(cacheData)
  elseif not self.curShowDataList or #self.curShowDataList <= 0 then
    self:ShowReqServerDataLoading()
  end
end

function ValentineSendGiftListView:GetRealStartIndex(dataList)
  local index = 1
  if dataList then
    for i, v in ipairs(dataList) do
      if v and not v.npcId then
        index = index + 1
      end
    end
  end
  return index
end

function ValentineSendGiftListView:CheckPullDataWhenEndDrag()
  if self.isShowSearchResult or self.curSelectScope == ValentineSendGiftScope.Alliance then
    return
  end
  local isInReqCD = self.reqDataIntervalTimer ~= nil
  if self.reqDataState == LoadPlayDataStat.Loading or isInReqCD then
    return
  end
  local x, y = self.itemContent.rectTransform:Get_anchoredPosition()
  local w, h = self.itemContent.rectTransform:Get_sizeDelta()
  local maxY = h - self.scrollRectHeight
  if self.reqLoadingObj.activeSelf then
    maxY = maxY - self.loadingObjHeight
  end
  if y > maxY then
    self:SetLoadingState(LoadPlayDataStat.Loading)
  end
end

function ValentineSendGiftListView:CheckIsShowLoadingObjWhenDrag()
  if self.isShowSearchResult or self.curSelectScope == ValentineSendGiftScope.Alliance then
    return
  end
  local x, y = self.itemContent.rectTransform:Get_anchoredPosition()
  local w, h = self.itemContent.rectTransform:Get_sizeDelta()
  local maxX = h - self.scrollRectHeight
  if y > maxX then
    local isInReqCD = self.reqDataIntervalTimer ~= nil
    if self.reqDataState == LoadPlayDataStat.Loading or isInReqCD then
      return
    end
    if not self.reqLoadingObj.activeSelf then
      self.reqLoadingObj:SetActive(true)
      self.itemContent.rectTransform:Set_sizeDelta(w, h + self.loadingObjHeight)
    end
  end
end

function ValentineSendGiftListView:SetLoadingState(loadingState)
  if loadingState == LoadPlayDataStat.Idle then
    if self.reqLoadingObj.activeSelf then
      self.reqLoadingObj:SetActive(false)
      local w, h = self.itemContent.rectTransform:Get_sizeDelta()
      self.itemContent.rectTransform:Set_sizeDelta(w, h - self.loadingObjHeight)
    end
  elseif loadingState == LoadPlayDataStat.Loading then
    if not self.reqLoadingObj.activeSelf then
      self.reqLoadingObj:SetActive(true)
      local w, h = self.itemContent.rectTransform:Get_sizeDelta()
      self.itemContent.rectTransform:Set_sizeDelta(w, h + self.loadingObjHeight)
    end
    self:ReqServerData()
  end
  self.reqDataState = loadingState
end

function ValentineSendGiftListView:OnSendGiftListDataUpdate(dataList)
  self.curShowDataList = dataList
  self:SetLoadingState(LoadPlayDataStat.Idle)
  self:RefreshContent()
  self:HideReqServerDataLoading()
end

function ValentineSendGiftListView:OnSendGiftListDataGetFail()
  self:SetLoadingState(LoadPlayDataStat.Idle)
  self:HideReqServerDataLoading()
end

function ValentineSendGiftListView:SelectGenderFilter(targetGender)
  self.curSelectGender = targetGender
  self:RefreshToggleState()
  self.itemContent:SetItemCount(0)
  if self.isShowSearchResult then
    local newDataList = {}
    for _, v in ipairs(self.searchResultDataList) do
      if v.shareInfo and (v.shareInfo.gender == targetGender or targetGender == 0) then
        table.insert(newDataList, v)
      end
    end
    self:OnSendGiftListDataUpdate(newDataList)
  else
    self.curShowDataList = {}
    self:ReqServerData()
  end
  self.itemContent:MoveItemByIndex(0)
end

function ValentineSendGiftListView:RefreshToggleState()
  for k, v in pairs(self.allSelectImgList) do
    v:SetActive(k == self.curSelectGender)
  end
end

function ValentineSendGiftListView:StopAllTimer()
  if self.reqDataIntervalTimer then
    self.reqDataIntervalTimer:Stop()
    self.reqDataIntervalTimer = nil
  end
end

function ValentineSendGiftListView:OnSearchBtnClick()
  local str = self.find_input_field:GetText()
  if str ~= "" and 3 <= #str then
    if self.curSelectScope == ValentineSendGiftScope.ZoneServer then
      SFSNetwork.SendMessage(MsgDefines.SendContactGiftSearchNew, SearchPlayerType.ValentineActivitySearch, str)
    else
      SFSNetwork.SendMessage(MsgDefines.SendContactGiftSearch, LuaEntry.Player:GetSourceServerId(), str)
    end
    self.itemContent:SetItemCount(0)
    self:ShowReqServerDataLoading()
  else
    UIUtil.ShowTipsId(390101)
  end
  self.searchResultDataList = {}
end

function ValentineSendGiftListView:OnReceiveSearchResult(message)
  self:HideReqServerDataLoading()
  if message ~= nil then
    local data = message.searchRet
    if data == nil then
      data = {}
    end
    for index, v in ipairs(data) do
      if v.uid == LuaEntry.Player.uid then
        table.remove(data, index)
        break
      end
    end
    table.sort(data, function(a, b)
      return a.thumbsUpCount > b.thumbsUpCount
    end)
    local allianceId = LuaEntry.Player.allianceId
    local dataListFilterByGender = {}
    local dataList = {}
    for k, v in ipairs(data) do
      if self.curSelectScope ~= ShowTabType.Alliance or allianceId == v.allianceId then
        local fakeData = {}
        fakeData.shareInfo = v
        fakeData.playerUid = v.uid
        table.insert(dataList, fakeData)
        if self.curSelectGender ~= GenderFilterType.All then
          if self.curSelectGender == v.gender then
            table.insert(dataListFilterByGender, fakeData)
          end
        else
          table.insert(dataListFilterByGender, fakeData)
        end
      end
    end
    self.isShowSearchResult = true
    self.npcTipsNode:SetActive(false)
    self.searchResultDataList = dataList
    self:OnSendGiftListDataUpdate(dataListFilterByGender)
  end
end

function ValentineSendGiftListView:OnSearchInputFieldChange(value)
  if string.IsNullOrEmpty(self.find_input_field:GetText()) then
    self:OnTabClick(self.curSelectScope)
  end
end

function ValentineSendGiftListView:OnSettingBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineSendGiftSetting, {anim = true}, self.activityId, {
    windowType = GiftSystemConst.WindowType.Send
  })
end

function ValentineSendGiftListView:OnLikeSuccess()
  self.itemContent:ForceUpdate()
end

function ValentineSendGiftListView:ShowReqServerDataLoading()
  if self.reqServerDataLoadingTimer then
    self.reqServerDataLoadingTimer:Stop()
    self.reqServerDataLoadingTimer = nil
    self.reqServerDataLoadingObj:SetActive(false)
  end
  if not self.reqServerDataLoadingObj.activeSelf then
    self.reqServerDataLoadingObj:SetActive(true)
  end
  self.reqServerDataLoadingTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.reqServerDataLoadingTimer = nil
    self.reqServerDataLoadingObj:SetActive(false)
  end, 5)
end

function ValentineSendGiftListView:HideReqServerDataLoading()
  if self.reqServerDataLoadingTimer then
    self.reqServerDataLoadingTimer:Stop()
    self.reqServerDataLoadingTimer = nil
  end
  if self.reqServerDataLoadingObj.activeSelf then
    self.reqServerDataLoadingObj:SetActive(false)
  end
end

function ValentineSendGiftListView:ReqNpcHistoryData()
  local param = {
    activityId = tonumber(self.activityId)
  }
  SFSNetwork.SendMessage(MsgDefines.ValentineSendNpcHistory, param)
end

function ValentineSendGiftListView:PlayHistoryBtnAni()
  if not self.npcHistoryNodeAni then
    return
  end
  self.npcHistoryNodeAni:Play("hit")
end

function ValentineSendGiftListView:PlayIconFlyAni(npcId, rootTrans, callback)
  self:ClearRewardGetVfx()
  if not npcId or not rootTrans then
    return
  end
  if not self.npcHistoryNode:GetActive() then
    self.npcHistoryNode:SetActive(true)
    self.npcHistoryNodeAni:Play("enter")
  end
  self.flyReq = self:GameObjectInstantiateAsync(VfxAssets.ValentineNpcRewardCompleteFly, function(req)
    if req.isError or not rootTrans then
      self:ClearRewardGetVfx()
      return
    end
    local flyCoinObj = req.gameObject
    local trans = flyCoinObj.transform
    trans:SetParent(rootTrans)
    trans:Set_localScale(1, 1, 1)
    trans:Set_localPosition(0, 0, 0)
    trans:SetParent(self.root.transform, true)
    local tarPosX, tarPosY, tarPosZ = self.npcHistoryNode.transform:Get_localPosition()
    local tarPos = Vector3.New(tarPosX, tarPosY, tarPosZ)
    local flyCpt = flyCoinObj.gameObject:GetComponent(typeof(CS.UIGoodsFly))
    flyCpt:DoParabolaAnimLocal(tarPos, trans.localPosition, function()
      req:Destroy()
    end)
    if callback then
      callback()
    end
    self.delayDestroyTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayDestroyTimer then
        self.delayDestroyTimer:Stop()
        self.delayDestroyTimer = nil
      end
      for i = 1, #self.curShowDataList do
        local player = self.curShowDataList[i]
        if player and player.npcId == npcId then
          table.remove(self.curShowDataList, i)
          break
        end
      end
      self:OnSendGiftListDataUpdate(self.curShowDataList)
    end, NPC_ENTER_HISTORY_TIME)
    self.delayFlyTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayFlyTimer then
        self.delayFlyTimer:Stop()
        self.delayFlyTimer = nil
      end
      self:PlayHistoryBtnAni()
    end, VFX_MOVE_TIME)
  end)
end

function ValentineSendGiftListView:ClearRewardGetVfx()
  if self.flyReq then
    self.flyReq:Destroy()
    self.flyReq = nil
  end
  if self.delayDestroyTimer then
    self.delayDestroyTimer:Stop()
    self.delayDestroyTimer = nil
  end
  if self.delayFlyTimer then
    self.delayFlyTimer:Stop()
    self.delayFlyTimer = nil
  end
end

function ValentineSendGiftListView:PlayFollowEffect(pos)
  if self.followEffectNode then
    self.followEffectNode:SetActive(true)
    local likeEffectPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/Eff_ui_Valentine2026_like_Variant.prefab"
    self.followEffectNode:Play(likeEffectPath)
    self.followEffectNode:SetPositionXYZ(pos.x, pos.y, pos.z)
  end
end

ValentineSendGiftListView.OnCreate = OnCreate
ValentineSendGiftListView.OnDestroy = OnDestroy
ValentineSendGiftListView.OnEnable = OnEnable
ValentineSendGiftListView.OnDisable = OnDisable
ValentineSendGiftListView.ComponentDefine = ComponentDefine
ValentineSendGiftListView.ComponentDestroy = ComponentDestroy
ValentineSendGiftListView.DataDefine = DataDefine
ValentineSendGiftListView.DataDestroy = DataDestroy
ValentineSendGiftListView.OnAddListener = OnAddListener
ValentineSendGiftListView.OnRemoveListener = OnRemoveListener
return ValentineSendGiftListView
