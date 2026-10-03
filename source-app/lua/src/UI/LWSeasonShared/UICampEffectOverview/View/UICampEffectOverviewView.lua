local base = UIBaseView
local UICampEffectOverviewView = BaseClass("UICampEffectOverviewView", base)
local Localization = CS.GameEntry.Localization
local UICampEffectOverviewCanFoldItem = require("UI.LWSeasonShared.UICampEffectOverview.Component.UICampEffectOverviewCanFoldItem")
local UILoopListViewSimple = require("Framework.UI.Component.UILoopListViewSimple")
local UICampBuffEffectItem = require("UI.LWSeasonShared.UICampEffectOverview.Component.UICampBuffEffectItem")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local txt_titleText_path = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local btn_panel_path = "UICommonPopUpTitle/panel"
local btn_CloseBtn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local go_Content_path = "Root/Science/Scroll/Viewport/Content"
local btn_InfoBtn_path = "Root/InfoBtn"
local go_Science_path = "Root/Science"
local go_Buff_path = "Root/Buff"
local sr_UICommonLoopListViewVertical_path = "Root/Buff/UICommonLoopListViewVertical"
local go_Empty_path = "Root/Buff/Empty"
local sli_SliderB_path = "Root/Buff/CampInfo/campB/SliderB"
local img_IconB_path = "Root/Buff/CampInfo/campB/img_IconB"
local txt_progressA_path = "Root/Buff/CampInfo/campA/SliderA/txt_progressA"
local img_IconA_path = "Root/Buff/CampInfo/campA/img_IconA"
local sli_SliderA_path = "Root/Buff/CampInfo/campA/SliderA"
local txt_progressB_path = "Root/Buff/CampInfo/campB/SliderB/txt_progressB"
local txt_UnLock_path = "Root/Buff/Empty/txt_UnLock"
local sr_UICommonToggleList_path = "Root/UICommonToggleList"
local img_signA_path = "Root/Buff/CampInfo/campA/signA"
local img_signB_path = "Root/Buff/CampInfo/campB/signB"
local txt_tip_path = "Root/Science/txt_tip"
local go_CampInfo_path = "Root/Buff/CampInfo"
local btn_campA_path = "Root/Buff/CampInfo/campA"
local btn_campB_path = "Root/Buff/CampInfo/campB"
local TabType = {Science = 1, Buff = 2}
local TabConfig = {
  [TabType.Science] = {
    nameId = "season_camp_science_ui_3"
  },
  [TabType.Buff] = {
    nameId = "season_camp_science_ui_7"
  }
}

function UICampEffectOverviewView:OnCreate()
  base.OnCreate(self)
  self.selectIndex = 1
  self.showData = {
    [TabType.Science] = DataCenter.CampScienceDataManager:GetAllLockScienceInfoToDes(),
    [TabType.Buff] = DataCenter.CampScienceDataManager:GetAllCampScienceBuff()
  }
  self:ComponentDefine()
  self:ReInit()
  DataCenter.LWSoundManager:PlaySound(62261, false)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, 12, 0)
end

function UICampEffectOverviewView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampEffectOverviewView:ComponentDefine()
  self.txt_titleText = self:AddComponent(UIText, txt_titleText_path)
  self.btn_panel = self:AddComponent(UIButton, btn_panel_path)
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.go_Content = self:AddComponent(UIBaseContainer, go_Content_path)
  self.btn_InfoBtn = self:AddComponent(UIButton, btn_InfoBtn_path)
  self.go_Science = self:AddComponent(UIBaseContainer, go_Science_path)
  self.go_Buff = self:AddComponent(UIBaseContainer, go_Buff_path)
  self.go_Empty = self:AddComponent(UIBaseContainer, go_Empty_path)
  self.sli_SliderB = self:AddComponent(UISlider, sli_SliderB_path)
  self.img_IconB = self:AddComponent(UIImage, img_IconB_path)
  self.txt_progressA = self:AddComponent(UIText, txt_progressA_path)
  self.img_IconA = self:AddComponent(UIImage, img_IconA_path)
  self.sli_SliderA = self:AddComponent(UISlider, sli_SliderA_path)
  self.txt_progressB = self:AddComponent(UIText, txt_progressB_path)
  self.img_signA = self:AddComponent(UIImage, img_signA_path)
  self.img_signB = self:AddComponent(UIImage, img_signB_path)
  self.txt_tip = self:AddComponent(UIText, txt_tip_path)
  self.go_CampInfo = self:AddComponent(UIBaseContainer, go_CampInfo_path)
  self.btn_campA = self:AddComponent(UIButton, btn_campA_path)
  self.btn_campB = self:AddComponent(UIButton, btn_campB_path)
  self.txt_UnLock = self:AddComponent(UITextMeshProUGUIEx, txt_UnLock_path)
  self.sr_UICommonLoopListViewVertical = self:AddComponent(UILoopListViewSimple, sr_UICommonLoopListViewVertical_path)
  self.sr_UICommonToggleList = self:AddComponent(UICommonToggleListComponent, sr_UICommonToggleList_path)
  self.txt_titleText:SetLocalText(110288)
  self.btn_CloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local tabs = {
    itemsDataList = {}
  }
  for i = 1, #TabConfig do
    local tab = TabConfig[i]
    tab.name = CS.GameEntry.Localization:GetString(tab.nameId)
    table.insert(tabs.itemsDataList, tab)
  end
  
  function tabs.onItemSelect(index, itemData)
    self:DoSelectTabIndex(index)
  end
  
  tabs.defaultSelectIndex = 1
  self.sr_UICommonToggleList:ReInit(tabs)
  self.btn_InfoBtn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("season_camp_science_ui_42")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  
  function self.txt_UnLock.unity_tmpro.onPointerClick(eventData)
    self:OnPointerClick(eventData)
  end
  
  self.campInfoView = {
    [1] = {
      btn = self.btn_campA,
      slider = self.sli_SliderA,
      icon = self.img_IconA,
      progress = self.txt_progressA,
      sign = self.img_signA
    },
    [2] = {
      btn = self.btn_campB,
      slider = self.sli_SliderB,
      icon = self.img_IconB,
      progress = self.txt_progressB,
      sign = self.img_signB
    }
  }
  self.btn_campA:SetOnClick(BindCallback(self, self.OnClickCampA))
  self.btn_campB:SetOnClick(BindCallback(self, self.OnClickCampB))
  self.sr_UICommonLoopListViewVertical:Init(UICampBuffEffectItem)
end

function UICampEffectOverviewView:ComponentDestroy()
  self:ClearList()
  self.campScoreSync = nil
  self.txt_titleText = nil
  self.btn_panel = nil
  self.btn_CloseBtn = nil
  self.go_Content = nil
  self.btn_InfoBtn = nil
  self.go_Science = nil
  self.go_Buff = nil
  self.sr_UICommonLoopListViewVertical = nil
  self.go_Empty = nil
  self.sli_SliderB = nil
  self.img_IconB = nil
  self.txt_progressA = nil
  self.img_IconA = nil
  self.sli_SliderA = nil
  self.txt_progressB = nil
  self.txt_UnLock = nil
  self.sr_UICommonToggleList = nil
  self.img_signA = nil
  self.img_signB = nil
  self.txt_tip = nil
  self.go_CampInfo = nil
  self.btn_campA = nil
  self.btn_campB = nil
end

function UICampEffectOverviewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonRankUpdate, self.SeasonRankUpdateHandle)
end

function UICampEffectOverviewView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonRankUpdate, self.SeasonRankUpdateHandle)
  base.OnRemoveListener(self)
end

function UICampEffectOverviewView:SeasonRankUpdateHandle(message)
  self:RefreshCampInfo(message)
end

function UICampEffectOverviewView:OnClickCampA()
  if not self.campScoreSync then
    return
  end
  local campScoreInfo = self.campScoreSync.campScore1
  local campScore = campScoreInfo and (campScoreInfo.campScore or 0) or 0
  local destroyForce = campScoreInfo and (campScoreInfo.destroyForce or 0) or 0
  self:RefreshBuffList(nil, 1, campScore - destroyForce, destroyForce)
  for i = 1, #self.campInfoView do
    local info = self.campInfoView[i]
    info.sign:SetActive(i == 1)
  end
end

function UICampEffectOverviewView:OnClickCampB()
  if not self.campScoreSync then
    return
  end
  if not self.campScoreSync then
    return
  end
  local campScoreInfo = self.campScoreSync.campScore2
  local campScore = campScoreInfo and (campScoreInfo.campScore or 0) or 0
  local destroyForce = campScoreInfo and (campScoreInfo.destroyForce or 0) or 0
  self:RefreshBuffList(nil, 2, campScore - destroyForce, destroyForce)
  for i = 1, #self.campInfoView do
    local info = self.campInfoView[i]
    info.sign:SetActive(i == 2)
  end
end

function UICampEffectOverviewView:OnPointerClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkScienceIds = self.txt_UnLock:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkScienceIds) then
    return
  end
  local link = string.split(linkScienceIds, "|")
  local campId = DataCenter.SeasonFactionWarDataManager.myCampId
  if link[campId] then
    GoToUtil.GoToCampScience(link[campId])
    self.ctrl:CloseSelf()
  end
end

function UICampEffectOverviewView:ReInit()
  self:RefreshContent()
end

function UICampEffectOverviewView:RefreshContent()
  local showData = self.showData[self.selectIndex]
  if self.selectIndex == TabType.Science then
    self.go_Buff:SetActive(false)
    self.go_Science:SetActive(true)
    self.go_Content:SetAnchoredPositionXY(0, 0)
    self:ClearList()
    local showList = false
    for k = 0, table.count(showData) - 1 do
      local v = showData[k]
      if 0 < #v and self.cellReqs[k] == nil then
        showList = true
        local data = v
        local index = k
        self.cellReqs[k] = self:GameObjectInstantiateAsync(UIAssets.UICampPropertyCanFoldItem, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.go_Content.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local nameStr = tostring(k)
          go.name = nameStr
          local cell = self.go_Content:AddComponent(UICampEffectOverviewCanFoldItem, nameStr)
          data.isShowDetail = true
          cell:Refresh(data, index)
        end)
      end
    end
    self.txt_tip:SetActive(not showList)
  elseif self.selectIndex == TabType.Buff then
    self.go_Buff:SetActive(true)
    self.go_Science:SetActive(false)
    local isOpen = DataCenter.CampScienceDataManager:IsOpenCampBuff()
    self.go_Empty:SetActive(not isOpen)
    self.go_CampInfo:SetActive(isOpen)
    if not isOpen then
      self.sr_UICommonLoopListViewVertical:SetActive(false)
      local lockScienceName = "season_camp_science_name_4"
      self.txt_UnLock:SetLocalText("season_camp_science_ui_31", CS.GameEntry.Localization:GetString(lockScienceName))
      return
    end
    self:RefreshBuffList(showData)
    self:RefreshCampInfo()
  end
end

function UICampEffectOverviewView:RefreshBuffList(showData, campId, occScore, destroyScore)
  if showData == nil then
    showData = DataCenter.CampScienceDataManager:GetCampScienceBuffByCampId(campId, occScore, destroyScore)
  end
  local empty = true
  for _, v in ipairs(showData) do
    if v.buffId > 0 then
      empty = false
    end
  end
  self.sr_UICommonLoopListViewVertical:Clear()
  self.sr_UICommonLoopListViewVertical:SetActive(not empty)
  if not empty then
    for _, v in ipairs(showData) do
      if v.buffId > 0 then
        self.sr_UICommonLoopListViewVertical:AddData(v)
      end
    end
    self.sr_UICommonLoopListViewVertical:Show()
  end
end

function UICampEffectOverviewView:RefreshCampInfo(message)
  for i = 1, #self.campInfoView do
    local info = self.campInfoView[i]
    local campIcon = DataCenter.SeasonFactionWarDataManager:GetCampIcon(i)
    info.icon:LoadSprite(campIcon)
    info.sign:SetActive(DataCenter.SeasonFactionWarDataManager.myCampId == i)
  end
  if message ~= nil then
    self.campScoreSync = message
    local campScore1Info = message.campScore1
    local campScore2Info = message.campScore2
    local campScore1 = campScore1Info and (campScore1Info.campScore or 0) or 0
    local campScore2 = campScore2Info and (campScore2Info.campScore or 0) or 0
    for i = 1, #self.campInfoView do
      local info = self.campInfoView[i]
      if campScore1 + campScore2 == 0 then
        info.slider:SetValue(0)
      else
        local progress = i == 1 and campScore1 / (campScore1 + campScore2) or campScore2 / (campScore1 + campScore2)
        info.slider:SetValue(progress)
      end
      local core = i == 1 and campScore1 or campScore2
      info.progress:SetText(string.GetFormattedSeparatorNum(core))
    end
  end
end

function UICampEffectOverviewView:ClearList()
  if self.cellReqs then
    self.go_Content:RemoveComponents(UICampEffectOverviewCanFoldItem)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function UICampEffectOverviewView:DoSelectTabIndex(index)
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self:RefreshContent()
end

function UICampEffectOverviewView:RefreshView()
  self:RefreshContent()
end

return UICampEffectOverviewView
