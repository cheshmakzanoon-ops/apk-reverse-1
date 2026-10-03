local base = UIBaseContainer
local UICampScienceMain = BaseClass("UICampScienceMain", base)
local CampScienceRowCell = require("UI.LWSeasonShared.UICampScience.Component.CampScienceRowCell")
local Localization = CS.GameEntry.Localization
local sv_ScrollView_path = "MiddleBg/ScrollView"
local btn_btnAddBuff_path = "Down/btnAddBuff"
local btn_btnProduce_path = "Down/btnProduce"
local btn_InfoBtn_path = "TopBar/InfoBtn"
local img_res_icon2_path = "Down/btnProduce/popup/res_icon2"
local txt_res_count_path = "Down/btnProduce/popup/res_count"
local btn_popup_path = "Down/btnProduce/popup"
local btn_btnRank_path = "TopBar/btnRank"
local btn_btnFish_path = "Down/btnFish"

function UICampScienceMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.cells = {}
  self.scienceList = {}
end

function UICampScienceMain:OnDestroy()
  self.cells = nil
  self.scienceList = nil
  self:ClearScrollTween()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampScienceMain:ComponentDefine()
  self.sv_ScrollView = self:AddComponent(UIScrollView, sv_ScrollView_path)
  self.btn_btnAddBuff = self:AddComponent(UIButton, btn_btnAddBuff_path)
  self.btn_btnProduce = self:AddComponent(UIButton, btn_btnProduce_path)
  self.btn_InfoBtn = self:AddComponent(UIButton, btn_InfoBtn_path)
  self.img_res_icon2 = self:AddComponent(UIImage, img_res_icon2_path)
  self.txt_res_count = self:AddComponent(UIText, txt_res_count_path)
  self.btn_popup = self:AddComponent(UIButton, btn_popup_path)
  self.btn_btnRank = self:AddComponent(UIButton, btn_btnRank_path)
  self.btn_btnFish = self:AddComponent(UIButton, btn_btnFish_path)
  self.btn_InfoBtn:SetOnClick(BindCallback(self, self.ClickInfoBtn))
  self.btn_btnRank:SetOnClick(BindCallback(self, self.ClickRankBtn))
  self.btn_btnFish:SetOnClick(BindCallback(self, self.ClickFish))
  self.sv_ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.sv_ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn_btnAddBuff:SetOnClick(BindCallback(self, self.ClickAddBuff))
  self.btn_btnProduce:SetOnClick(BindCallback(self, self.ClickProduce))
  self.btn_popup:SetOnClick(BindCallback(self, self.ClickProduce))
  DataCenter.CampScienceDataManager:ClearRed()
end

function UICampScienceMain:ComponentDestroy()
  self.sv_ScrollView = nil
  self.btn_btnAddBuff = nil
  self.btn_btnProduce = nil
  self.btn_InfoBtn = nil
  self.img_res_icon2 = nil
  self.txt_res_count = nil
  self.btn_popup = nil
  self.btn_btnRank = nil
  self.btn_btnFish = nil
end

function UICampScienceMain:OnAddListener()
  self:AddUIListener(EventId.UpdateCampScienceList, self.UpdateView)
  self:AddUIListener(EventId.GoToCampScienceView, self.GoToCampScienceViewHandle)
  self:AddUIListener(EventId.UpdateCampProduceRewardList, self.RefreshPopup)
  self:AddUIListener(EventId.UpdateCampProduceDesRecordList, self.RefreshPopup)
  self:AddUIListener(EventId.CampScienceDonateSuccess, self.CampScienceDonateSuccessHandle)
end

function UICampScienceMain:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateCampScienceList, self.UpdateView)
  self:RemoveUIListener(EventId.GoToCampScienceView, self.GoToCampScienceViewHandle)
  self:RemoveUIListener(EventId.UpdateCampProduceRewardList, self.RefreshPopup)
  self:RemoveUIListener(EventId.UpdateCampProduceDesRecordList, self.RefreshPopup)
  self:RemoveUIListener(EventId.CampScienceDonateSuccess, self.CampScienceDonateSuccessHandle)
end

function UICampScienceMain:OnEnable()
  base.OnEnable(self)
  self:RefreshPopup()
end

function UICampScienceMain:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.sv_ScrollView:AddComponent(CampScienceRowCell, itemObj)
  cellItem:SetItemShow(self.scienceList[index])
  self.cells[index] = cellItem
end

function UICampScienceMain:OnDeleteCell(itemObj, index)
  self.sv_ScrollView:RemoveComponent(itemObj.name, CampScienceRowCell)
  self.cells[index] = nil
end

function UICampScienceMain:ClearScroll()
  self.sv_ScrollView:ClearCells()
  self.sv_ScrollView:RemoveComponents(CampScienceRowCell)
  self.cells = {}
end

function UICampScienceMain:SetData()
  local a, b
  self.activity, a, b, self.gotoId = self.view:GetUserData()
  SFSNetwork.SendMessage(MsgDefines.CampScienceView)
  self:ClearScroll()
  self:GoToScience()
end

function UICampScienceMain:GoToCampScienceViewHandle(scienceId)
  self.gotoId = scienceId
  self:GoToScience()
end

function UICampScienceMain:UpdateView()
  self:RefreshView()
  self:GoToScience()
end

local ScreenCell = 4

function UICampScienceMain:RefreshView()
  self:RefreshLockBtn()
  self:GetShowData()
  self.sv_ScrollView:SetTotalCount(#self.scienceList)
  self.sv_ScrollView:RefillCells()
  self:RefreshPopup()
end

function UICampScienceMain:GetShowData()
  self.showRecommendId = 0
  self.autoOpenRecScienceId = 0
  self.scienceList = DataCenter.CampScienceDataManager:GetCampScienceRowList()
  for _, listData in ipairs(self.scienceList) do
    for _, data in ipairs(listData) do
      local oneData = DataCenter.CampScienceDataManager:GetOneCampScienceById(data.id)
      if oneData then
        oneData.lineGlays = nil
      end
    end
  end
  for _, listData in ipairs(self.scienceList) do
    for _, data in ipairs(listData) do
      local oneData = DataCenter.CampScienceDataManager:GetOneCampScienceById(data.id)
      if oneData ~= nil then
        local isLock = false
        if oneData.science_condition ~= nil and 0 < #oneData.science_condition then
          local condition_vec = oneData.science_condition
          for k = 1, #condition_vec do
            local condition = condition_vec[k]
            local id = condition.scienceId
            local level = condition.level
            local pScienceData = DataCenter.CampScienceDataManager:GetOneCampScienceById(id)
            if pScienceData ~= nil then
              if pScienceData.lineGlays == nil then
                pScienceData.lineGlays = {}
              end
              local curLevel = pScienceData.curLevel
              if level <= curLevel then
                pScienceData.lineGlays[#pScienceData.lineGlays + 1] = false
              else
                pScienceData.lineGlays[#pScienceData.lineGlays + 1] = true
                isLock = true
              end
            end
          end
        end
        oneData.isLock = isLock
        oneData.isTimeLock = data:IsTimeLock()
        if oneData.isTimeLock then
          oneData.isLock = true
        end
      end
    end
  end
  self.gotoId = self:GetGotoScienceRow()
end

function UICampScienceMain:GetGotoScienceRow()
  if self.gotoId ~= nil and self.gotoId ~= 0 then
    return self.gotoId
  end
  local recommendId = DataCenter.CampScienceDataManager:GetRecommendScienceId()
  if recommendId ~= nil then
    for _, scienceLine in ipairs(self.scienceList) do
      for _, science in ipairs(scienceLine) do
        local data = DataCenter.CampScienceDataManager:GetOneCampScienceById(science.id)
        if data and recommendId == data.scienceId then
          return data.scienceId
        end
      end
    end
  end
  for _, scienceLine in ipairs(self.scienceList) do
    for _, science in ipairs(scienceLine) do
      local data = DataCenter.CampScienceDataManager:GetOneCampScienceById(science.id)
      if data and not data:IsMax() then
        return data.scienceId
      end
    end
  end
end

function UICampScienceMain:CampScienceDonateSuccessHandle()
  self:GetShowData()
  self.sv_ScrollView:RefillCells()
end

function UICampScienceMain:RefreshLockBtn()
  local isOpen = DataCenter.CampScienceDataManager:IsOpenCampProduce()
  CS.UIGray.SetGray(self.btn_btnProduce.transform, not isOpen, true)
end

function UICampScienceMain:ClickAddBuff()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICampEffectOverview)
end

function UICampScienceMain:ClickProduce()
  local isLock = DataCenter.CampScienceDataManager:IsOpenCampProduce()
  if not isLock then
    UIUtil.ShowTipsId("season_camp_science_tips_21")
    return
  end
  local produceCount, desCount = DataCenter.CampProduceDataManager:GetCanReceiveProduceReward()
  if 0 < produceCount then
    GoToUtil.GoToSeasonCityList(4)
  elseif 0 < desCount then
    GoToUtil.GoToSeasonCityList(5)
  else
    GoToUtil.GoToSeasonCityList(4)
  end
end

function UICampScienceMain:ClickInfoBtn()
  local param = {
    activityRulesStr = Localization:GetString("season_s6_activity_1200104_desc01")
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UICampScienceMain:ClickRankBtn()
  local param = {}
  param.DefaultTab = 2
  param.DefaultSubTab = 5
  param.DefaultDropDownIndex = 2
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonMilitaryEliteRank, {anim = true}, param)
end

function UICampScienceMain:ClickFish()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPond, {anim = true})
end

function UICampScienceMain:RefreshPopup()
  local isLock = DataCenter.CampScienceDataManager:IsOpenCampProduce()
  if not isLock then
    self.btn_popup:SetActive(false)
    return
  end
  local produceCount, desCount = DataCenter.CampProduceDataManager:GetCanReceiveProduceReward()
  local showPopup = 0 < produceCount or 0 < desCount
  self.btn_popup:SetActive(0 < produceCount or 0 < desCount)
  if showPopup then
    local groupTemplate = DataCenter.CampScienceDataManager:GetCampScienceGroupTemplate()
    if 0 < produceCount then
      self.txt_res_count:SetText(string.GetFormattedStr(produceCount))
      self.img_res_icon2:LoadSprite(groupTemplate.camp_reward_icon)
    elseif 0 < desCount then
      self.txt_res_count:SetText(string.GetFormattedStr(desCount))
      self.img_res_icon2:LoadSprite(groupTemplate.camp_destroy_reward_icon)
    end
  end
end

function UICampScienceMain:ClearScrollTween()
  if self.scrollTween then
    self.scrollTween:Kill()
    self.scrollTween = nil
  end
end

function UICampScienceMain:ScrollToCell(targetIndex, beginIndex)
  self:ClearScrollTween()
  local totalCount = #self.scienceList
  if totalCount <= ScreenCell then
    return
  end
  local singlePart = 1 / (totalCount - ScreenCell)
  local targetNormalizedPos = singlePart * math.max(0, targetIndex - ScreenCell)
  if beginIndex then
    local beginNormalizedPos = singlePart * math.max(0, beginIndex - ScreenCell)
    self.sv_ScrollView:SetVerticalNormalizedPosition(beginNormalizedPos)
  end
  self.scrollTween = DOTween.To(function()
    return self.sv_ScrollView:GetVerticalNormalizedPosition()
  end, function(pos)
    self.sv_ScrollView:SetVerticalNormalizedPosition(pos)
  end, targetNormalizedPos, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuad)
end

function UICampScienceMain:GoToScience()
  local gotoScience = self.gotoId
  if not gotoScience then
    return
  end
  local goToIndex = 0
  for index, lineData in ipairs(self.scienceList) do
    for _, scienceData in ipairs(lineData) do
      if scienceData.id == gotoScience then
        goToIndex = index
      end
    end
  end
  local startRow = 0
  goToIndex = math.min(#self.scienceList, goToIndex + 1)
  if goToIndex > ScreenCell then
    startRow = goToIndex - ScreenCell
  end
  self:ScrollToCell(goToIndex, startRow)
  self.gotoId = nil
end

return UICampScienceMain
