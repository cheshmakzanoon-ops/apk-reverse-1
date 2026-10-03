local UIAllianceScienceView = BaseClass("UIAllianceScienceView", UIBaseView)
local AllianceScienceRowCell = require("UI.UIAlliance.UIAllianceScience.Component.AllianceScienceRowCell")
local AllianceScienceTabToggle = require("UI.UIAlliance.UIAllianceScience.Component.AllianceScienceTabToggle")
local AllianceScienceAutoDonate = require("UI.UIAlliance.UIAllianceScience.Component.AllianceScienceAutoDonate")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local title_text_path = "safearea/TopBar/TextTitle"
local close_btn_path = "safearea/BtnClose"
local toogle1_path = "mainObj/Tab/Toggle1"
local toogle2_path = "mainObj/Tab/Toggle2"
local toogle3_path = "mainObj/Tab/Toggle3"
local scroll_view_path = "mainObj/MiddleBg/ScrollView"
local rankBtn_path = "mainObj/MiddleBg/donateRankContent/rankBtn"
local donateScore_path = "mainObj/MiddleBg/donateRankContent/DonationContent/donateScore"
local donateScoreNum_path = "mainObj/MiddleBg/donateRankContent/DonationContent/donateScoreNum"
local donateTip_path = "mainObj/MiddleBg/donateRankContent/donateTip"
local bg1_path = "safearea/bg/bg_1"
local autoDonatePanel_path = "mainObj/MiddleBg/autoDonatePanel"
local AutoDonateHeight = 1245
local NormalHeight = 1145
local DelayShowArrowTime = 0.3

function UIAllianceScienceView:OnCreate()
  base.OnCreate(self)
  self.autoOpenRecScience = false
  self.autoOpenScienceId = 0
  self.defaultTabIndex = nil
  self.recommendEffect = false
  local userData, tabIndex = self:GetUserData()
  if tabIndex then
    self.defaultTabIndex = tabIndex
  elseif userData then
    if userData.openScienceId then
      self.autoOpenScienceId = userData.openScienceId
      if userData.recommendEffect then
        self.recommendEffect = userData.recommendEffect
      end
    elseif userData.autoOpenRecScience then
      self.autoOpenRecScience = userData.autoOpenRecScience
    end
  end
  self:ComponentDefine()
end

function UIAllianceScienceView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceScienceView:ComponentDefine()
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.toogle1 = self:AddComponent(AllianceScienceTabToggle, toogle1_path)
  self.toogle1:ReInit(454119)
  self.toogle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(1)
    end
  end)
  self.toogle2 = self:AddComponent(AllianceScienceTabToggle, toogle2_path)
  self.toogle2:ReInit(454120)
  self.toogle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(2)
    end
  end)
  self.toogle3 = self:AddComponent(AllianceScienceTabToggle, toogle3_path)
  self.toogle3:ReInit(100356)
  self.toogle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(3)
    end
  end)
  self.title_text:SetLocalText(390148)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.rankBtn:SetOnClick(function()
    self:OnRankBtnOpen()
  end)
  self.donateScore = self:AddComponent(UIText, donateScore_path)
  self.donateScoreNum = self:AddComponent(UIText, donateScoreNum_path)
  self.donateTip = self:AddComponent(UIText, donateTip_path)
  self.isChangeTab = false
  self.tab = 0
  self.scienceList = {}
  self.cells = {}
  self.toCellIdx = -1
  self.updeatScience = nil
  self.canShowRecommendArrow = true
  self.showRecommendId = 0
  local showTab
  if self.defaultTabIndex then
    showTab = self.defaultTabIndex
  else
    showTab = self.ctrl:GetShowTab(self.autoOpenRecScience, self.autoOpenScienceId)
  end
  local seasonHasAllianceScience = SeasonUtil.HasAllianceScienceData()
  if seasonHasAllianceScience then
    if showTab == 1 then
      self.toogle1:SetIsOn(true)
    elseif showTab == 2 then
      self.toogle2:SetIsOn(true)
    else
      showTab = 3
      self.toogle3:SetIsOn(true)
    end
  else
    self.toogle3:SetActive(false)
    if showTab == 2 then
      self.toogle2:SetIsOn(true)
    else
      showTab = 1
      self.toogle1:SetIsOn(true)
    end
  end
  if self.tab == nil or self.tab == 0 then
    self:ToggleControlBorS(showTab)
  end
  local allianceList = {}
  table.insert(allianceList, ResourceType.AlliancePoint)
  local hideResList = {
    ResourceType.Petroleum,
    ResourceType.FLINT,
    ResourceType.OBSIDIAN,
    ResourceType.GoldBrick
  }
  local param = {}
  param.allianceList = allianceList
  param.hideResList = hideResList
  param.uiName = UIWindowNames.UIAllianceScience
  EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  SFSNetwork.SendMessage(MsgDefines.GetAllianceStorageInfo)
  SFSNetwork.SendMessage(MsgDefines.AllScienceRefresh)
  self.bg1 = self:AddComponent(UIBaseComponent, bg1_path)
  self.autoDonatePanel = self:AddComponent(AllianceScienceAutoDonate, autoDonatePanel_path)
end

function UIAllianceScienceView:ComponentDestroy()
  self:RemoveArrowTimer()
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.toogle1 = nil
  self.toogle2 = nil
  self.toogle3 = nil
  self.scroll_view = nil
  self.scienceList = nil
  self.cells = nil
  self.toCellIdx = nil
  self.updeatScience = nil
  self.canShowRecommendArrow = true
  self.showRecommendId = 0
  self.isChangeTab = nil
  self.rankBtn = nil
  self.donateScore = nil
  self.donateScoreNum = nil
  self.donateTip = nil
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIAllianceScience)
end

function UIAllianceScienceView:OnEnable()
  base.OnEnable(self)
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    self.autoDonatePanel:SetActive(true)
    self.bg1:SetSizeDeltaXY(self.bg1:GetSizeDelta().x, AutoDonateHeight)
  else
    self.autoDonatePanel:SetActive(false)
    self.bg1:SetSizeDeltaXY(self.bg1:GetSizeDelta().x, NormalHeight)
  end
end

function UIAllianceScienceView:OnDisable()
  base.OnDisable(self)
end

function UIAllianceScienceView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GOTO_SCIENCE, self.GotoScience)
  self:AddUIListener(EventId.AllianceTechnology, self.OnAllianceTechnology)
  self:AddUIListener(EventId.AllianceCurrentDonatePointUpdate, self.OnAlliancePointUpdate)
end

function UIAllianceScienceView:OnRemoveListener()
  self:RemoveUIListener(EventId.GOTO_SCIENCE, self.GotoScience)
  self:RemoveUIListener(EventId.AllianceTechnology, self.OnAllianceTechnology)
  self:RemoveUIListener(EventId.AllianceCurrentDonatePointUpdate, self.OnAlliancePointUpdate)
  base.OnRemoveListener(self)
end

function UIAllianceScienceView:OnAllianceTechnology()
  if self.tab and self.tab ~= 0 then
    self:ToggleControlBorS(self.tab)
  end
end

function UIAllianceScienceView:ToggleControlBorS(tabIndex)
  self.isChangeTab = self.tab ~= tabIndex
  self.tab = tabIndex
  DataCenter.ArrowManager:RemoveArrow()
  self:RemoveArrowTimer()
  self.ctrl:GetShowTab(self.autoOpenRecScience, self.autoOpenScienceId)
  self:RefreshView()
  if self.toCellIdx >= 1 and self.isChangeTab then
    if self.canShowRecommendArrow and self.showRecommendId ~= 0 then
      self.canShowRecommendArrow = false
      self:GotoScience(self.showRecommendId)
      self.showRecommendId = 0
    else
      self.scroll_view:StopMovement()
      if self.toCellIdx < #self.scienceList - 1 then
        self.scroll_view:RefillCells(self.toCellIdx)
      else
        self.scroll_view:RefillCellsFromEnd()
      end
    end
  end
  local openScienceId = self.autoOpenScienceId
  if openScienceId == 0 and self.autoOpenRecScience and self.autoOpenRecScienceId ~= 0 then
    openScienceId = self.autoOpenRecScienceId
  end
  if 0 < openScienceId then
    local scienceData = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(openScienceId)
    local showRecommendEffect = self.recommendEffect
    self.recommendEffect = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScienceInfo, {anim = true}, scienceData, tabIndex, showRecommendEffect)
  end
  self.autoOpenScienceId = 0
  self.autoOpenRecScience = false
end

function UIAllianceScienceView:ShowToogleImgWarn(idx)
end

function UIAllianceScienceView:ShowToogleTip(idx, upgradeId, recoId)
  if 0 < upgradeId and DataCenter.AllianceBaseDataManager:IsR4orR5() then
    if idx == 1 then
      self.toogle1.upgrade_img:SetActive(true)
    elseif idx == 2 then
      self.toogle2.upgrade_img:SetActive(true)
    elseif idx == 3 then
      self.toogle3.upgrade_img:SetActive(true)
    end
    return
  end
  if 0 < recoId then
    if idx == 1 then
      self.toogle1.reco_img:SetActive(true)
    elseif idx == 2 then
      self.toogle2.reco_img:SetActive(true)
    elseif idx == 3 then
      self.toogle3.reco_img:SetActive(true)
    end
  end
end

function UIAllianceScienceView:RefreshOtherToogleImgWarn()
  for i = 1, AlScienceMaxTab do
    if i ~= self.tab then
      local scienceList = self.ctrl:GetScienceRowList(i)
      if table.count(scienceList) == 0 then
        return
      end
      self:GetScienceData(scienceList, i)
    end
  end
end

function UIAllianceScienceView:GetScienceData(scienceList, idx)
  for i = 1, table.count(scienceList) do
    local listData = scienceList[i]
    for j = 1, table.count(listData) do
      local data = listData[j]
      local oneSciencedata = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(data.id)
      if oneSciencedata ~= nil and oneSciencedata.curLevel ~= data.max_lv then
        if oneSciencedata.currentPro > 0 and oneSciencedata.currentPro >= oneSciencedata.needPro and not self.view.ctrl:GetHasUpdate() and DataCenter.AllianceBaseDataManager:IsR4orR5() then
          self:ShowToogleTip(idx, oneSciencedata.scienceId, 0)
          return
        end
        if oneSciencedata.state == 1 then
          self:ShowToogleTip(idx, 0, oneSciencedata.scienceId)
          return
        end
      end
    end
  end
end

function UIAllianceScienceView:RefreshView()
  self.toogle1.reco_img:SetActive(false)
  self.toogle1.upgrade_img:SetActive(false)
  self.toogle2.reco_img:SetActive(false)
  self.toogle2.upgrade_img:SetActive(false)
  self.toogle3.reco_img:SetActive(false)
  self.toogle3.upgrade_img:SetActive(false)
  self.updeatScience = self.ctrl:GetCurSearchScience()
  self:RefreshOtherToogleImgWarn()
  self.scienceList = self.ctrl:GetScienceRowList(self.tab)
  if table.count(self.scienceList) == 0 then
    return
  end
  self:GetShowData()
  if self.cells ~= nil and 0 < table.count(self.cells) and self.isChangeTab == false then
    for i = 1, table.count(self.scienceList) do
      if self.cells[i] ~= nil then
        self.cells[i]:SetItemShow(self.scienceList[i])
      end
    end
    return
  end
  self:ClearScroll()
  self.scroll_view:SetTotalCount(#self.scienceList)
  self.scroll_view:RefillCells()
  local selfData = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
  if selfData then
    self.donateScore:SetLocalText(455118, "")
    self.donateScoreNum:SetText(selfData.donateTodayProgress)
  else
    self.donateScore:SetText("")
    self.donateScoreNum:SetText("")
  end
  local num = LuaEntry.DataConfig:TryGetNum("guild_plus_sep", "k5")
  self.donateTip:SetLocalText(311036, num)
end

function UIAllianceScienceView:OnAlliancePointUpdate(donatePoint)
  if not donatePoint then
    return
  end
  local selfData = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself()
  if selfData then
    selfData.donateTodayProgress = donatePoint
    self.donateScoreNum:SetText(selfData.donateTodayProgress)
  end
end

function UIAllianceScienceView:GetShowData()
  local canUpdateCellIdx = -1
  local recommendCellIdx = -1
  local unLockCellIdx = -1
  local hasUpdate = false
  local showRecommendId = 0
  self.showRecommendId = 0
  self.autoOpenRecScienceId = 0
  for i = 1, table.count(self.scienceList) do
    local listData = self.scienceList[i]
    for j = 1, table.count(listData) do
      local data = listData[j]
      local oneSciencedata = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(data.id)
      if oneSciencedata ~= nil then
        if self.updeatScience ~= nil then
          hasUpdate = true
        end
        local isLock = false
        if oneSciencedata.science_condition ~= nil and oneSciencedata.science_condition ~= "" then
          local condition_vec = string.split_ss_array(oneSciencedata.science_condition, ";")
          for k = 1, #condition_vec do
            local condition = condition_vec[k]
            local level = tonumber(string.sub(condition, -2))
            local id = tonumber(condition) - level
            local pSciencedata = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(id)
            if pSciencedata ~= nil then
              if pSciencedata.lineGlays == nil then
                pSciencedata.lineGlays = {}
              end
              local curLevel = pSciencedata.curLevel
              if level <= curLevel then
                pSciencedata.lineGlays[#pSciencedata.lineGlays + 1] = false
              else
                pSciencedata.lineGlays[#pSciencedata.lineGlays + 1] = true
                isLock = true
              end
            end
          end
        end
        oneSciencedata.isLock = isLock
        if oneSciencedata.curLevel ~= data.max_lv then
          if oneSciencedata.state == 1 then
            recommendCellIdx = i - 1
            showRecommendId = oneSciencedata.scienceId
            self.autoOpenRecScienceId = showRecommendId
          elseif not oneSciencedata.isLock and self.autoOpenRecScience == 0 then
            self.autoOpenRecScienceId = oneSciencedata.scienceId
          end
          if 0 < oneSciencedata.currentPro and oneSciencedata.currentPro >= oneSciencedata.needPro and canUpdateCellIdx == -1 then
            canUpdateCellIdx = i - 1
          end
          if not oneSciencedata.isLock and unLockCellIdx == -1 then
            unLockCellIdx = i - 1
          end
          if not hasUpdate then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            if curTime < oneSciencedata.finishTime then
              hasUpdate = true
            end
          end
        end
      end
    end
  end
  if DataCenter.AllianceBaseDataManager:IsR4orR5() and not hasUpdate then
    if canUpdateCellIdx ~= -1 then
      self.toCellIdx = canUpdateCellIdx
    elseif recommendCellIdx ~= -1 then
      self.toCellIdx = recommendCellIdx
      self.showRecommendId = showRecommendId
    elseif unLockCellIdx ~= -1 then
      self.toCellIdx = unLockCellIdx
    else
      self.toCellIdx = 1
    end
  elseif recommendCellIdx ~= -1 then
    self.toCellIdx = recommendCellIdx
    self.showRecommendId = showRecommendId
  elseif unLockCellIdx ~= -1 then
    self.toCellIdx = unLockCellIdx
  else
    self.toCellIdx = 1
  end
  if not hasUpdate and canUpdateCellIdx ~= -1 then
    self:ShowToogleImgWarn(self.tab)
  end
end

function UIAllianceScienceView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(AllianceScienceRowCell, itemObj)
  cellItem:SetItemShow(self.scienceList[index])
  self.cells[index] = cellItem
end

function UIAllianceScienceView:OnDeleteCell(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, AllianceScienceRowCell)
  self.cells[index] = nil
end

function UIAllianceScienceView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(AllianceScienceRowCell)
  self.cells = {}
end

function UIAllianceScienceView:GotoScience(scienceId)
  self:RemoveArrowTimer()
  if scienceId ~= nil then
    self.scroll_view:StopMovement()
    for i = 1, #self.scienceList do
      local listData = self.scienceList[i]
      for j = 1, #listData do
        local data = listData[j]
        if data.id == scienceId then
          local idx = math.max(i - 1, 1)
          if idx < #self.scienceList - 1 then
            self.scroll_view:RefillCells(idx)
          else
            self.scroll_view:RefillCellsFromEnd()
          end
          return
        end
      end
    end
  end
end

function UIAllianceScienceView:RemoveArrowTimer()
  if self.showArrowTimer ~= nil then
    self.showArrowTimer:Stop()
    self.showArrowTimer = nil
  end
end

function UIAllianceScienceView:OnClickInfoBtn()
  UIUtil.ShowIntro(Localization:GetString("390148"), Localization:GetString("302027"), Localization:GetString("391101"))
end

function UIAllianceScienceView:OnRankBtnOpen()
  GoToUtil.GotoOpenView(UIWindowNames.UILWAllianceRank, {anim = true}, AlRankType.Donate)
end

return UIAllianceScienceView
