local UITCCardBoxPanelView = BaseClass("UITCCardBoxPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Settings = CS.GameEntry.Setting
local UIGray = CS.UIGray
local CardBoxItem = require("UI.LWUITC.UITCCardBoxPanel.Component.CardBoxItem")
local CardBoxRewardEntrance = require("UI.LWUITC.UITCCardBoxPanel.Component.CardBoxRewardEntrance")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.gotoId = self:GetUserData()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCBoxPointReward)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshAllView()
  DataCenter.TacticalCardDataManager:TryReqDailyLimit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.info_btn = self:AddComponent(UIButton, "Root/Content/LW_Btn_Info")
  self.info_btn:SetOnClick(function()
    self:OnInfo_btnClick()
  end)
  self.curBox_icon = self:AddComponent(UIRawImage, "Root/Content/curBox_icon")
  self.curBoxName_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/curBoxName_txt")
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/desc_txt")
  self.cnt_slider = self:AddComponent(UISlider, "Root/Content/InfoInput/Slider")
  self.cntDec_btn = self:AddComponent(UIButton, "Root/Content/InfoInput/DecBtn")
  self.cntDec_btn:SetOnClick(function()
    self:OnCntDec_btnClick()
  end)
  self.cntAdd_btn = self:AddComponent(UIButton, "Root/Content/InfoInput/AddBtn")
  self.cntAdd_btn:SetOnClick(function()
    self:OnCntAdd_btnClick()
  end)
  self.cnt_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/InfoInput/TextBg/CountText")
  self.skipAnimation_btn = self:AddComponent(UIButton, "Root/BottomBar/skipAnimation")
  self.skipAnimation_btn:SetOnClick(function()
    self:OnSkipAnimation_btnClick()
  end)
  self.open_btn = self:AddComponent(UIButton, "Root/BottomBar/open_btn")
  self.open_btn:SetOnClick(function()
    self:OnOpen_btnClick()
  end)
  self.back_btn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.back_btn:SetOnClick(function()
    self:OnBack_btnClick()
  end)
  self.boxes = self:AddComponent(UIBaseContainer, "Root/Content/boxesBg/boxes")
  self.boxItem = self:AddComponent(UIBaseContainer, "boxItem")
  self.toggleFill = self:AddComponent(UIImage, "Root/BottomBar/skipAnimation/toggle/fill")
  self.getMore_btn = self:AddComponent(UIButton, "Root/BottomBar/getmore_btn")
  self.getMore_btn:SetOnClick(function()
    self:OnGetMore_btnClick()
  end)
  self.boxItem.gameObject:GameObjectCreatePool()
  self.cnt_slider:SetOnValueChanged(function(value)
    self:OnSliderValueChanged(value)
  end)
  self.compVXCardbagQuality = self:AddComponent(UIVfx, "Root/Content/VX_cardbag_quality")
  self.compVXTittle = self:AddComponent(UIVfx, "Root/Content/VX_tittle")
  self.boxPointEntrance = self:AddComponent(CardBoxRewardEntrance, "Root/Content/boxPoint_btn")
end

local function ComponentDestroy(self)
  self:RemoveBoxes()
  self.info_btn = nil
  self.curBox_icon = nil
  self.curBoxName_txt = nil
  self.desc_txt = nil
  self.cnt_slider = nil
  self.cntDec_btn = nil
  self.cntAdd_btn = nil
  self.cnt_txt = nil
  self.skipAnimation_btn = nil
  self.open_btn = nil
  self.back_btn = nil
  self.boxes = nil
  self.boxItem = nil
  self.toggleFill = nil
  self.getMore_btn = nil
  self.compVXCardbagQuality = nil
  self.compVXTittle = nil
  self.boxPointEntrance = nil
end

local function DataDefine(self)
  self.boxDataList = {}
  self.selectedBoxId = nil
  self.skipAnimation = false
  self.currentCount = 1
  self.maxCount = 1
end

local function DataDestroy(self)
  self.boxDataList = {}
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.TacticalCardOpenBox, self.OnTacticalCardOpenBox)
  self:AddUIListener(EventId.OnPassDay, self.OnOnPassDay)
  self:AddUIListener(EventId.TacticalCardBoxPointUpdate, self.OnScoreInfoChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.TacticalCardOpenBox, self.OnTacticalCardOpenBox)
  self:RemoveUIListener(EventId.OnPassDay, self.OnOnPassDay)
  self:RemoveUIListener(EventId.TacticalCardBoxPointUpdate, self.OnScoreInfoChanged)
  base.OnRemoveListener(self)
end

function UITCCardBoxPanelView:RefreshAllView()
  self:InitBoxList()
  self:InitSkipAnimationState()
  self:UpdateBoxInfo()
  self.boxPointEntrance:RefreshData()
end

function UITCCardBoxPanelView:InitBoxList()
  self:RemoveBoxes()
  local currentSeason = DataCenter.SeasonDataManager:GetSeason()
  self.boxDataList = DataCenter.TacticalCardDataManager:GetAllBoxGoodsIdBySeason(currentSeason)
  local gotoId = self.gotoId
  if self.gotoId then
    local numGotoId = tonumber(gotoId)
    if numGotoId then
      for i, boxData in ipairs(self.boxDataList) do
        if boxData.id == numGotoId then
          self.selectedBoxId = boxData.id
          break
        end
      end
    end
    self.gotoId = nil
  end
  if not self.selectedBoxId then
    local maxCount = 0
    local maxCountBoxId
    for i, boxData in ipairs(self.boxDataList) do
      local count = DataCenter.ItemData:GetItemCount(boxData.goods_id)
      boxData.count = count
      if maxCount < count then
        maxCount = count
        maxCountBoxId = boxData.id
      end
    end
    self.selectedBoxId = maxCountBoxId
    if not self.selectedBoxId and #self.boxDataList > 0 then
      self.selectedBoxId = self.boxDataList[1].id
    end
  end
  for i, boxData in ipairs(self.boxDataList) do
    local boxItem = self:CreateBoxItem(boxData, i)
    if not self.boxItems then
      self.boxItems = {}
    end
    table.insert(self.boxItems, boxItem)
  end
  self:UpdateBoxSelectState()
end

function UITCCardBoxPanelView:CreateBoxItem(boxData, index)
  local boxItemObj = self.boxItem.gameObject:GameObjectSpawn()
  local boxItemTransform = boxItemObj.transform
  boxItemTransform:SetParent(self.boxes.transform)
  boxItemTransform:Set_localScale(Vector3.one)
  boxItemTransform:Set_localPosition(Vector3.zero)
  local name = string.format("boxItem_%d", index)
  boxItemObj.name = name
  local boxItem = self.boxes:AddComponent(CardBoxItem, boxItemObj)
  boxItem:Init(boxData)
  boxItem:SetOnClick(function()
    self:OnBoxItemClick(boxData.id)
  end)
  local isSelected = self.selectedBoxId == boxData.id
  boxItem:SetSelected(isSelected)
  return boxItem
end

function UITCCardBoxPanelView:RemoveBoxes()
  if self.boxItems then
    self.boxes:RemoveComponents(CardBoxItem)
    self.boxItem.gameObject:GameObjectRecycleAll()
    self.boxItems = {}
  end
end

function UITCCardBoxPanelView:OnBoxItemClick(boxId)
  if self.selectedBoxId == boxId then
    return
  end
  self.selectedBoxId = boxId
  self:UpdateBoxSelectState()
  self:UpdateBoxInfo()
end

function UITCCardBoxPanelView:UpdateBoxSelectState()
  if not self.boxItems then
    return
  end
  for _, item in pairs(self.boxItems) do
    local isSelected = item:GetBoxId() == self.selectedBoxId
    item:SetSelected(isSelected)
  end
end

function UITCCardBoxPanelView:UpdateBoxInfo()
  if not self.selectedBoxId then
    return
  end
  local selectedBox
  for _, boxData in ipairs(self.boxDataList) do
    if boxData.id == self.selectedBoxId then
      selectedBox = boxData
      break
    end
  end
  if not selectedBox then
    return
  end
  self:UpdateBoxVisual(selectedBox)
  self:UpdateBoxUIByCount()
end

function UITCCardBoxPanelView:UpdateBoxVisual(selectedBox)
  local boxConfig = DataCenter.TacticalCardDataManager:GetBoxTemplate(selectedBox.id)
  if boxConfig then
    local iconPath = boxConfig:GetLargeImage()
    self.curBox_icon:LoadSprite(iconPath)
    self.curBoxName_txt:SetText(boxConfig:GetName())
    self.desc_txt:SetText(boxConfig:GetDesc())
    local quality = boxConfig:GetQuality()
    self.curBoxName_txt:SetColor(UIUtil.GetColorByQuality(quality))
    local iconVfxPath = TacticalCardUtil.CARD_BOX_PANEL_ICON_VFX[quality]
    self.compVXCardbagQuality:PlayByStay(iconVfxPath)
    local titelVfxPath = TacticalCardUtil.CARD_BOX_PANEL_TITLE_VFX[quality]
    if titelVfxPath then
      self.compVXTittle:PlayByOnce(titelVfxPath)
    else
      self.compVXTittle:Remove()
    end
  end
end

function UITCCardBoxPanelView:UpdateBoxUIByCount()
  if not self.selectedBoxId then
    return
  end
  local selectedBox
  for _, boxData in ipairs(self.boxDataList) do
    if boxData.id == self.selectedBoxId then
      selectedBox = boxData
      break
    end
  end
  if not selectedBox then
    return
  end
  self.maxCount = selectedBox.count or 0
  local boxTemplate = DataCenter.TacticalCardDataManager:GetBoxTemplate(selectedBox.id)
  local selectMax = boxTemplate.select_max
  if selectMax < self.maxCount then
    self.maxCount = selectMax
  end
  if self.maxCount <= 0 then
    self.currentCount = 0
    UIGray.SetGray(self.cntDec_btn.transform, true, false)
    UIGray.SetGray(self.cntAdd_btn.transform, true, false)
    self.cnt_slider:SetValueWithoutNotify(0)
    self.cnt_slider:SetInteractable(false)
    self.cnt_txt:SetText("0")
    self.open_btn:SetActive(false)
    self.getMore_btn:SetActive(true)
  else
    self.currentCount = math.min(self.currentCount, self.maxCount)
    self.currentCount = math.max(self.currentCount, 1)
    self.cnt_slider:SetInteractable(true)
    self.cnt_slider:SetValueWithoutNotify(self.currentCount / self.maxCount)
    self.cnt_txt:SetText(self.currentCount)
    UIGray.SetGray(self.cntDec_btn.transform, self.currentCount <= 1, true)
    UIGray.SetGray(self.cntAdd_btn.transform, self.currentCount >= self.maxCount, true)
    self.open_btn:SetActive(true)
    self.getMore_btn:SetActive(false)
  end
end

function UITCCardBoxPanelView:InitSkipAnimationState()
  self.skipAnimation = Settings:GetBool("TCCardBox_SkipAnimation", false)
  self.toggleFill:SetActive(self.skipAnimation)
end

function UITCCardBoxPanelView:OnInfo_btnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardRecruitProbability, {anim = true}, self.selectedBoxId)
end

function UITCCardBoxPanelView:OnCntDec_btnClick()
  if self.currentCount > 1 then
    self.currentCount = self.currentCount - 1
    self.cnt_slider:SetValueWithoutNotify(self.currentCount / self.maxCount)
    self:UpdateCountUI()
  end
end

function UITCCardBoxPanelView:OnCntAdd_btnClick()
  if self.currentCount < self.maxCount then
    self.currentCount = self.currentCount + 1
    self.cnt_slider:SetValueWithoutNotify(self.currentCount / self.maxCount)
    self:UpdateCountUI()
  end
end

function UITCCardBoxPanelView:OnSkipAnimation_btnClick()
  self.skipAnimation = not self.skipAnimation
  self.toggleFill:SetActive(self.skipAnimation)
  Settings:SetBool("TCCardBox_SkipAnimation", self.skipAnimation)
end

function UITCCardBoxPanelView:OnOpen_btnClick()
  if not self.selectedBoxId or self.maxCount <= 0 then
    return
  end
  self.ctrl:OpenBox(self.selectedBoxId, self.currentCount)
end

function UITCCardBoxPanelView:OnBack_btnClick()
  self.ctrl:CloseSelf()
end

function UITCCardBoxPanelView:OnRefreshItems(eventId, data)
  if self.selectedBoxId then
    for index, boxData in ipairs(self.boxDataList) do
      if boxData.id == self.selectedBoxId then
        local oldCount = boxData.count
        local newCount = DataCenter.ItemData:GetItemCount(boxData.goods_id)
        if oldCount ~= newCount then
          boxData.count = newCount
          self:UpdateBoxUIByCount()
        end
      end
      if self.boxItems[index] then
        self.boxItems[index]:OnRefreshItems()
      end
    end
  end
end

function UITCCardBoxPanelView:OnSliderValueChanged(value)
  if not self.selectedBoxId or self.maxCount <= 0 then
    return
  end
  local newCount = math.floor(value * self.maxCount + 0.5)
  newCount = math.max(1, newCount)
  newCount = math.min(self.maxCount, newCount)
  if self.currentCount ~= newCount then
    self.currentCount = newCount
    self:UpdateCountUI()
  end
end

function UITCCardBoxPanelView:UpdateCountUI()
  self.cnt_txt:SetText(self.currentCount)
  UIGray.SetGray(self.cntDec_btn.transform, self.currentCount <= 1, true)
  UIGray.SetGray(self.cntAdd_btn.transform, self.currentCount >= self.maxCount, true)
end

function UITCCardBoxPanelView:OnTacticalCardOpenBox(retData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBoxResultPanel, {anim = true}, retData)
end

function UITCCardBoxPanelView:OnGetMore_btnClick()
  if self.selectedBoxId then
    local boxTemplate = DataCenter.TacticalCardDataManager:GetBoxTemplate(self.selectedBoxId)
    if boxTemplate then
      local itemId = boxTemplate:GetGoodsId()
      if itemId then
        LWResourceLackUtil:GotoGoodsItemLack(itemId, 1)
      end
    end
  end
end

function UITCCardBoxPanelView:GetTabGroupList()
  self.tabList = {}
  table.insert(self.tabList, MasteryTabType.MasterSkillTab)
  if TacticalCardUtil.IsFunctionOpen() then
    table.insert(self.tabList, MasteryTabType.TacticalCard)
  end
  local groupList = {}
  for index, value in ipairs(self.tabList) do
    local temp = CommonTabGoupItemTemplate.New()
    local keyStr = TAB_KEY_CONFIG[value]
    temp.title = Localization:GetString(keyStr)
    groupList[index] = temp
  end
  return groupList
end

function UITCCardBoxPanelView:OnOnPassDay(eventId, data)
  DataCenter.TacticalCardDataManager:TryReqDailyLimit()
end

function UITCCardBoxPanelView:OnScoreInfoChanged()
  if self.boxPointEntrance then
    self.boxPointEntrance:OnScoreInfoChanged()
  end
end

UITCCardBoxPanelView.OnCreate = OnCreate
UITCCardBoxPanelView.OnDestroy = OnDestroy
UITCCardBoxPanelView.OnEnable = OnEnable
UITCCardBoxPanelView.OnDisable = OnDisable
UITCCardBoxPanelView.ComponentDefine = ComponentDefine
UITCCardBoxPanelView.ComponentDestroy = ComponentDestroy
UITCCardBoxPanelView.DataDefine = DataDefine
UITCCardBoxPanelView.DataDestroy = DataDestroy
UITCCardBoxPanelView.OnAddListener = OnAddListener
UITCCardBoxPanelView.OnRemoveListener = OnRemoveListener
return UITCCardBoxPanelView
