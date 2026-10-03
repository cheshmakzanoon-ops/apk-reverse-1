local UILWAlJoin = BaseClass("UILWAlJoin", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWAlJoinItem = require("UI.UILWAlliance.UILWAlCreateJoin.Component.UILWAlJoinItem")
local search_input_path = "InnerPanel/FindArea/FindInputField"
local search_btn_path = "InnerPanel/FindArea/FindClickBtn"
local al_content = "InnerPanel/Scroll/Viewport/Content"
local al_item = "InnerPanel/Scroll/Viewport/UILWAlItem"
local fast_join_btn_path = "JoinBtnPanel/FastJoinBtn"
local ranking_btn_path = "JoinBtnPanel/RankingBtn"
local join_alliance_cd_time_text_path = "JoinBtnPanel/JoinAllianceCdTimeText"
local scroll_path = "InnerPanel/Scroll"
local create_alliance_btn_path = "JoinBtnPanel/CreateAllianceBtn"
local empty_panel_path = "InnerPanel/EmptyPanel"
local tip_text_path = "TipText"
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")

function UILWAlJoin:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlJoin:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlJoin:ComponentDefine()
  self.searchInput = self:AddComponent(UIInput, search_input_path)
  self.searchInput:SetOnValueChange(function(value)
    self:SearchIptOnValueChange(value)
  end)
  self.searchBtn = self:AddComponent(UIButton, search_btn_path)
  self.searchBtn:SetOnClick(function()
    self:OnSearchClick()
  end)
  self.alContent = self:AddComponent(UIBaseContainer, al_content)
  self.fast_join_btn = self:AddComponent(UIButton, fast_join_btn_path)
  self.fast_join_btn:SetOnClick(function()
    local alliance_cross_join = LuaEntry.DataConfig:CheckSwitch("alliance_cross_join")
    if alliance_cross_join or LuaEntry.Player:IsLoginSourceServer() then
      self:OnFastJoinClick()
      AlPostEventLog.PostEventLog_ListJoin_Action(AlPostEventLog.JoinAction.QuickJoin)
    else
      UIUtil.ShowTipsId("season_tips166")
    end
  end)
  self.ranking_btn = self:AddComponent(UIButton, ranking_btn_path)
  self.ranking_btn:SetOnClick(function()
    self:OnRankingClick()
  end)
  self.join_alliance_cd_time_text = self:AddComponent(UITextMeshProUGUIEx, join_alliance_cd_time_text_path)
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.create_alliance_btn = self:AddComponent(UIButton, create_alliance_btn_path)
  self.create_alliance_btn:SetOnClick(BindCallback(self, self.OnCreateAllianceBtnClick))
  self.empty_panel = self:AddComponent(UIScrollRect, empty_panel_path)
  self.tipText = self:AddComponent(UIText, tip_text_path)
  self.tipText:SetActive(false)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UILWAlJoin:ComponentDestroy()
  self.searchInput = nil
  self.searchBtn = nil
  self.alContent = nil
  self.fast_join_btn = nil
  self.join_alliance_cd_time_text = nil
  self.scroll = nil
  self.create_alliance_btn = nil
  self.empty_panel = nil
  self.tipText = nil
end

function UILWAlJoin:DataDefine()
  self.allSearchAlUidList = nil
  self.alExtendDataList = nil
  self.canJoin = nil
  self.showJoinBtn = false
  self.showCreateBtn = false
  self.searchInputValue = ""
  self.searchInput:SetText("")
  self.allSearchAlUidList = {}
  self.alSearchAlList = {}
  self.joinAllianceCdTime = 0
end

function UILWAlJoin:DataDestroy()
  self:ClearScroll()
  self.searchInputValue = nil
  self.allSearchAlUidList = nil
  self.alSearchAlList = nil
  self.joinAllianceCdTime = nil
end

function UILWAlJoin:OnEnable()
  base.OnEnable(self)
end

function UILWAlJoin:OnDisable()
  base.OnDisable(self)
end

function UILWAlJoin:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.RefreshSearchAlList)
  self:AddUIListener(EventId.AllianceApplySuccess, self.OnJoinAlSuccessBack)
  self:AddUIListener(EventId.UpdateJoinAllianceCdTime, self.RefreshJoinAllianceCdTimeState)
end

function UILWAlJoin:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.RefreshSearchAlList)
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.OnJoinAlSuccessBack)
  self:RemoveUIListener(EventId.UpdateJoinAllianceCdTime, self.RefreshJoinAllianceCdTimeState)
end

function UILWAlJoin:SearchIptOnValueChange(value)
  self.searchInputValue = value
  self:OnSearchClick()
end

function UILWAlJoin:OnSearchClick()
  self.view.showJoin = true
  if self.searchInputValue == nil or self.searchInputValue == "" then
    self.view.ctrl:SendAlSearchMessageToServer(1, 1, "", 0, true)
  else
    self.view.ctrl:SendAlSearchMessageToServer(1, 1, self.searchInputValue, 0)
  end
end

function UILWAlJoin:RefreshSearchAlList()
  self.alSearchAlList, self.alExtendDataList, self.canJoin = self.view.ctrl:GetAllSearchAlIdList(self.searchInputValue)
  local curSeasonIndex = DataCenter.SeasonDataManager:GetSeason() or 0
  local isInSeason0 = curSeasonIndex == 0
  if self.alSearchAlList == nil or self.alSearchAlList[1] == nil then
    self.showJoinBtn = false
    self.showCreateBtn = true
    self.fast_join_btn:SetActive(self.showJoinBtn)
    self.create_alliance_btn:SetActive(self.showCreateBtn)
    self.empty_panel:SetActive(true)
    self.scroll:SetActive(false)
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  self.showJoinBtn = self.canJoin and isInSeason0
  self.fast_join_btn:SetActive(self.showJoinBtn)
  self.showCreateBtn = not self.canJoin
  self.create_alliance_btn:SetActive(self.showCreateBtn)
  if self.joinAllianceCdTime ~= nil and 0 < self.joinAllianceCdTime then
    self.fast_join_btn:SetActive(false)
    self.join_alliance_cd_time_text:SetActive(not self.showCreateBtn)
  end
  self.empty_panel:SetActive(false)
  self.scroll:SetActive(true)
  self.scroll:SetTotalCount(#self.alSearchAlList)
  self.scroll:RefillCells()
end

function UILWAlJoin:OnJoinAlSuccessBack()
  if self.view.al_success_callback then
    self.view.al_success_callback()
  else
    self.view.ctrl:CloseSelf()
  end
end

function UILWAlJoin:OnFastJoinClick()
  if DataCenter.AllianceBaseDataManager:IsInJoinAllianceCdTime(true) then
    return
  end
  local isFreeCreate = UIUtil.IsFreeCreateAllianceInOpenServerTime()
  if isFreeCreate then
    local param = {}
    param.chooseLeader = 1
    param.status = 2
    SFSNetwork.SendMessage(MsgDefines.FirstJoinAlliance, param)
  else
    local alId = DataCenter.AllianceTempListManager:GetFastJoinAllianceId()
    if alId == nil then
      UIUtil.ShowTipsId(455100)
    else
      local alData = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(alId)
      if alData then
        SFSNetwork.SendMessage(MsgDefines.AlApply, alId, alData.recruitTotal, alData.language)
      end
    end
  end
end

function UILWAlJoin:OnRankingClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankDetailList, {anim = true, hideTop = false}, 0, RankType.AlliancePower)
end

function UILWAlJoin:Update1000MS()
  if self.joinAllianceCdTime > 0 then
    self:CutDownJoinAllianceCdTime()
  end
end

function UILWAlJoin:RefreshJoinAllianceCdTimeState()
  self.joinAllianceCdTime = DataCenter.AllianceBaseDataManager.joinAllianceCdTime
  if self.joinAllianceCdTime and self.joinAllianceCdTime > 0 and not self.showCreateBtn then
    self.join_alliance_cd_time_text:SetActive(true)
    self.fast_join_btn:SetActive(false)
    self.create_alliance_btn:SetActive(false)
  else
    self.join_alliance_cd_time_text:SetActive(false)
    self.fast_join_btn:SetActive(self.showJoinBtn)
    self.create_alliance_btn:SetActive(self.showCreateBtn)
  end
end

function UILWAlJoin:CutDownJoinAllianceCdTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = DataCenter.AllianceBaseDataManager.joinAllianceCdTime
  local surplusTime = endTime - curTime
  if surplusTime <= 0 then
    self.joinAllianceCdTime = 0
    self.join_alliance_cd_time_text:SetActive(false)
    self.fast_join_btn:SetActive(self.showJoinBtn)
    self.create_alliance_btn:SetActive(self.showCreateBtn)
  elseif not self.showCreateBtn then
    self.join_alliance_cd_time_text:SetActive(true)
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime)
    self.join_alliance_cd_time_text:SetLocalText("alliance_tips_rejoin_cd", timeStr)
  else
    self.join_alliance_cd_time_text:SetActive(false)
  end
end

local function OnCreateAllianceBtnClick(self)
  if self.view then
    self.view:ContentTrans(false)
  end
end

function UILWAlJoin:RefreshTipText(tipStr)
  if string.IsNullOrEmpty(tipStr) then
    self.tipText:SetActive(false)
  else
    self.tipText:SetActive(true)
    self.tipText:SetText(tipStr)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scroll:AddComponent(UILWAlJoinItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.alSearchAlList[index], self.alExtendDataList[index])
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scroll:ClearCells()
  self.scroll:RemoveComponents(UILWAlJoinItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.alSearchAlList = {}
  self.alExtendDataList = {}
end

UILWAlJoin.OnItemMoveIn = OnItemMoveIn
UILWAlJoin.OnItemMoveOut = OnItemMoveOut
UILWAlJoin.ClearScroll = ClearScroll
UILWAlJoin.OnCreateAllianceBtnClick = OnCreateAllianceBtnClick
return UILWAlJoin
