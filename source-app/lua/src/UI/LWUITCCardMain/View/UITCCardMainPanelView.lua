local UITCCardMainPanelView = BaseClass("UITCCardMainPanelView", UIBaseContainer)
local NORMAL_CARD_SLOT_SCALE = 0.8
local CORE_CARD_SLOT_SCALE = 1
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local card_slot_root_path = "Root/Content/CardSlotRoot"
local slot_path = "Root/Content/CardSlotRoot/Slot%s"
local bag_btn_path = "Root/BottomBar/BtnLayout/BagBtn"
local gacha_btn_path = "Root/BottomBar/BtnLayout/GachaBtn"
local book_btn_path = "Root/BottomBar/BtnLayout/BookBtn"
local l_w_btn_info_path = "Root/Content/LW_Btn_Info"
local share_btn_path = "Root/Content/ShareBtn"
local gacha_red_dot_path = "Root/BottomBar/BtnLayout/GachaBtn/GachaRedDot"
local quick_equip_btn_path = "Root/BottomBar/QuickEquipBtn"
local book_red_dot_path = "Root/BottomBar/BtnLayout/BookBtn/BookRedDot"
local GUIDE_FLOW_ID = 5101

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if not DataCenter.LWGuideFlowManager:IsRunning() and 0 < GUIDE_FLOW_ID and not DataCenter.LWGuideFlowManager:ReadDone(GUIDE_FLOW_ID) then
    DataCenter.LWGuideFlowManager.Runner:Run(GUIDE_FLOW_ID)
  end
  local needUpdateCard, versionId = DataCenter.TacticalCardDataManager:GetCardVersionStateCache()
  if needUpdateCard == true then
    SFSNetwork.SendMessage(MsgDefines.BattleCardVersion, versionId)
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.curAllSlotDataDic then
    self:UpdateCardState()
    self:RefreshCachaRedState()
    self:RefreshBookRedDotState()
    self:CheckSlotUnlockState()
    self:RefreshBagRedDotState()
  end
  DataCenter.TacticalCardDataManager:TryRequestCardBookData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.allSlotHangUpPoint = {}
  self.allSlotItemDic = {}
  self.allSlotItemReqList = {}
  self.slotRoot = self:AddComponent(UIBaseContainer, card_slot_root_path)
  local slotCount = self.slotRoot.transform.childCount
  for i = 1, slotCount do
    local path = string.format(slot_path, i)
    local hangupPoint = self:AddComponent(UIBaseContainer, path)
    self.allSlotHangUpPoint[i] = hangupPoint
  end
  self.bagBtn = self:AddComponent(UIButton, bag_btn_path)
  self.bagBtn:SetOnClick(function()
    self:OpenBagPanel()
  end)
  self.gachaBtn = self:AddComponent(UIButton, gacha_btn_path)
  self.gachaBtn:SetOnClick(function()
    self:OpenGachaPanel()
  end)
  self.infoBtn = self:AddComponent(UIButton, l_w_btn_info_path)
  self.infoBtn:SetOnClick(function()
    self:OpenMoreInfoPanel()
  end)
  self.bookBtn = self:AddComponent(UIButton, book_btn_path)
  self.bookBtn:SetOnClick(function()
    self:OpenBookPanel()
  end)
  self.shareBtn = self:AddComponent(UIButton, share_btn_path)
  self.shareBtn:SetOnClick(function()
    self:ShareCurEquipSetUp()
  end)
  self.cachaRedDot = self:AddComponent(UIBaseContainer, gacha_red_dot_path)
  self.quickEquipBtn = self:AddComponent(UIButton, quick_equip_btn_path)
  self.quickEquipBtn:SetOnClick(function()
    self:OpenQuickEquipPanel()
  end)
  self.bookRedDot = self:AddComponent(UIBaseContainer, book_red_dot_path)
  self.bagRedDot = self:AddComponent(UIBaseContainer, "Root/BottomBar/BtnLayout/BagBtn/BagRedDot")
  self.animator = self:AddComponent(UISimpleAnimation, "")
end

local function ComponentDestroy(self)
  self.allSlotItemDic = nil
  self:ClearAllSlotItem()
  self.allSlotItemReqList = nil
end

local function DataDefine(self)
  self.curAllSlotDataDic = {}
  self.isRedDotDirty = false
end

local function DataDestroy(self)
  self.curAllSlotDataDic = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TCCardEquipSuccess, self.OnSuccessEquipCard)
  self:AddUIListener(EventId.TCCardUnEquipSuccess, self.UpdateCardState)
  self:AddUIListener(EventId.TCCardSalvageSuccess, self.UpdateCardState)
  self:AddUIListener(EventId.GF_guide_canceled, self.OnGuideDone)
  self:AddUIListener(EventId.GF_guide_done, self.OnGuideDone)
  self:AddUIListener(EventId.TacticalCardDataChanged, self.RefreshRedDot)
  self:AddUIListener(EventId.TacticalCardStageRewardChanged, self.RefreshRedDot)
  self:AddUIListener(EventId.TacticalCardLvUpgrade, self.RefreshCardsState)
  self:AddUIListener(EventId.TacticalCardStarUpgrade, self.RefreshCardsState)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TCCardEquipSuccess, self.OnSuccessEquipCard)
  self:RemoveUIListener(EventId.TCCardUnEquipSuccess, self.UpdateCardState)
  self:RemoveUIListener(EventId.TCCardSalvageSuccess, self.UpdateCardState)
  self:RemoveUIListener(EventId.GF_guide_canceled, self.OnGuideDone)
  self:RemoveUIListener(EventId.GF_guide_done, self.OnGuideDone)
  self:RemoveUIListener(EventId.TacticalCardDataChanged, self.RefreshRedDot)
  self:RemoveUIListener(EventId.TacticalCardStageRewardChanged, self.RefreshRedDot)
  self:RemoveUIListener(EventId.TacticalCardLvUpgrade, self.RefreshCardsState)
  self:RemoveUIListener(EventId.TacticalCardStarUpgrade, self.RefreshCardsState)
  base.OnRemoveListener(self)
end

function UITCCardMainPanelView:ReInit(params)
  self.curAllSlotDataDic = self:GetAllSlotData()
  self:CreateSlotItem()
  self.animator:Rewind("open")
  self.animator:Play("open")
end

function UITCCardMainPanelView:GetAllSlotData()
  local data = DataCenter.MasteryManager:GetData()
  if not data then
    Logger.LogError("mastery data is not exist")
    return
  end
  local masteryId = data.home_id
  local season = SeasonUtil.GetSeason()
  local allSlotDataDic = DataCenter.TacticalCardSlotDataManager:GetAllSlotDataList(masteryId, season)
  return allSlotDataDic
end

function UITCCardMainPanelView:CreateSlotItem()
  self:ClearAllSlotItem()
  self.allSlotItemDic = {}
  for _, v in pairs(self.curAllSlotDataDic) do
    local slotId = v.slotId
    local slotType = v.slotType
    if slotType ~= TacticalCardSlotType.Hide then
      local hangupPoint = self.allSlotHangUpPoint[slotId]
      if hangupPoint then
        local slotReq = TacticalCardUtil.CreateOneSlotItem(self, slotType, hangupPoint, function(slotItem)
          if slotItem.transform then
            local scale = self:GetCardScale(slotType)
            slotItem:SetSlotScale(scale)
          end
          slotItem:SetData(v)
          self:RefreshSlotRedDotState(slotItem)
          slotItem:SetClickFunc(function(slotData)
            self:OnClickSlotItem(slotData)
          end)
          self.allSlotItemDic[slotId] = slotItem
        end)
        table.insert(self.allSlotItemReqList, slotReq)
      end
    end
  end
end

function UITCCardMainPanelView:OnClickSlotItem(slotData)
  if not slotData then
    return
  end
  if slotData:IsLock(true) then
    return
  end
  if slotData:IsEquipCard() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardDetailPanel, {anim = true}, slotData:GetCardData())
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardEquip, {anim = true}, slotData)
  end
end

function UITCCardMainPanelView:GetCardScale(slotType)
  if slotType == TacticalCardSlotType.Core then
    return CORE_CARD_SLOT_SCALE
  elseif slotType == TacticalCardSlotType.Battle or slotType == TacticalCardSlotType.Economy then
    return NORMAL_CARD_SLOT_SCALE
  end
end

function UITCCardMainPanelView:ClearAllSlotItem()
  if self.allSlotItemReqList then
    for _, v in ipairs(self.allSlotItemReqList) do
      v:Destroy()
    end
  end
  self.allSlotItemReqList = {}
end

function UITCCardMainPanelView:OnSuccessEquipCard(updateCardDataList)
  self:UpdateCardState(updateCardDataList, TacticalCardUpdateSource.EquipCard)
end

function UITCCardMainPanelView:RefreshCardsState()
  self:UpdateCardState()
end

function UITCCardMainPanelView:UpdateCardState(updateCardDataList, updateSourceType)
  if not updateCardDataList then
    if self.allSlotItemDic then
      for slotId, v in pairs(self.allSlotItemDic) do
        self:UpdateSlotCard(slotId)
      end
    end
    return
  end
  local allNeedUpdateSlotIdList = {}
  for _, v in ipairs(updateCardDataList) do
    local targetSlotId = v.slot
    if 0 < targetSlotId then
      allNeedUpdateSlotIdList[targetSlotId] = true
    end
    targetSlotId = self:FindSlotIdByUuid(v.uuid)
    if targetSlotId and not allNeedUpdateSlotIdList[targetSlotId] then
      allNeedUpdateSlotIdList[targetSlotId] = true
    end
  end
  for slotId, _ in pairs(allNeedUpdateSlotIdList) do
    self:UpdateSlotCard(slotId, updateSourceType)
  end
end

function UITCCardMainPanelView:UpdateSlotCard(slotId, updateSourceType)
  if not self.allSlotItemDic then
    return
  end
  local slotItem = self.allSlotItemDic[slotId]
  if not slotItem or not slotItem.slotData then
    return
  end
  local equipCard = slotItem.slotData:GetCardData()
  if equipCard then
    slotItem:GenCardItem(equipCard, updateSourceType)
  else
    slotItem:ClearCardItem()
  end
  self:RefreshSlotRedDotState(slotItem)
end

function UITCCardMainPanelView:FindSlotIdByUuid(cardUuid)
  if not self.allSlotItemDic then
    return nil
  end
  for slotId, v in pairs(self.allSlotItemDic) do
    if v.curCacheCardData and v.curCacheCardData.uuid == cardUuid then
      return slotId
    end
  end
  return nil
end

function UITCCardMainPanelView:OpenBagPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardBag, {anim = true})
end

function UITCCardMainPanelView:OpenGachaPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBoxPanel)
end

local GUIDE_TYPE = 99
local GUIDE_IMAGE_PREFIX_PATH = "Assets/Main/TextureEx/UILWTCGuide/%s.png"

function UITCCardMainPanelView:OpenMoreInfoPanel()
  if not self.guideList then
    self.guideList = {}
    LocalController:instance():visitTable(TableName.Desert_Battle_Guide, function(id, lineData)
      local battle_type = lineData:getIntValue("battle_type")
      if battle_type == GUIDE_TYPE then
        local big_pic = lineData:getValue("big_pic")
        local small_pic = lineData:getValue("small_pic_list")
        if not string.IsNullOrEmpty(big_pic) then
          big_pic = string.format(GUIDE_IMAGE_PREFIX_PATH, big_pic)
        end
        if not string.IsNullOrEmpty(small_pic) then
          small_pic = string.format(GUIDE_IMAGE_PREFIX_PATH, small_pic)
        end
        table.insert(self.guideList, {
          num = lineData:getIntValue("id"),
          tittle = lineData:getValue("tittle"),
          battle_type = lineData:getValue("battle_type"),
          big_pic = big_pic,
          small_pic = small_pic,
          desc = lineData:getValue("small_pic_desc_list")
        })
      end
    end)
    table.sort(self.guideList, function(a, b)
      return a.num < b.num
    end)
  end
  if #self.guideList > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleDetail, {anim = true}, self.guideList)
  end
end

function UITCCardMainPanelView:OpenBookPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBook, {anim = true})
end

function UITCCardMainPanelView:ShareCurEquipSetUp()
  local share_param = {}
  share_param.postType = PostType.TacticalCard_Deck
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function UITCCardMainPanelView:OnGuideDone(flowId)
  if flowId == GUIDE_FLOW_ID then
    self:OpenMoreInfoPanel()
  end
end

function UITCCardMainPanelView:RefreshAllSlotRedState()
  if not self.allSlotItemDic then
    return
  end
  for _, v in pairs(self.allSlotItemDic) do
    self:RefreshSlotRedDotState(v)
  end
end

function UITCCardMainPanelView:RefreshCachaRedState()
  self.cachaRedDot:SetActive(TacticalCardUtil.IsExistCardCachaRed())
end

function UITCCardMainPanelView:RefreshBookRedDotState()
  local hasBoxReward = DataCenter.TacticalCardDataManager:HasCanReceiveBox()
  self.bookRedDot:SetActive(hasBoxReward)
end

function UITCCardMainPanelView:RefreshBagRedDotState()
  self.bagRedDot:SetActive(DataCenter.TacticalCardDataManager:CheckAllCoreStarUpgrade())
end

function UITCCardMainPanelView:RefreshSlotRedDotState(slotItem)
  if not slotItem then
    return
  end
  local slotId = slotItem.slotId
  if not slotId then
    return
  end
  local isCanEquipCard = TacticalCardUtil.CheckSlotIsShowRedDot(slotId)
  slotItem:SetRedDotState(isCanEquipCard)
end

function UITCCardMainPanelView:Update1000MS()
  if self.isRedDotDirty then
    self:RefreshAllSlotRedState()
    self:RefreshCachaRedState()
    self.isRedDotDirty = false
  end
end

function UITCCardMainPanelView:RefreshRedDot()
  self.isRedDotDirty = true
end

function UITCCardMainPanelView:OpenQuickEquipPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCQuickEquipPanelV2, {anim = true})
end

function UITCCardMainPanelView:CheckSlotUnlockState()
  if not self.allSlotItemDic then
    return
  end
  for _, v in pairs(self.allSlotItemDic) do
    v:CheckLockState()
  end
end

UITCCardMainPanelView.OnCreate = OnCreate
UITCCardMainPanelView.OnDestroy = OnDestroy
UITCCardMainPanelView.OnEnable = OnEnable
UITCCardMainPanelView.OnDisable = OnDisable
UITCCardMainPanelView.ComponentDefine = ComponentDefine
UITCCardMainPanelView.ComponentDestroy = ComponentDestroy
UITCCardMainPanelView.DataDefine = DataDefine
UITCCardMainPanelView.DataDestroy = DataDestroy
UITCCardMainPanelView.OnAddListener = OnAddListener
UITCCardMainPanelView.OnRemoveListener = OnRemoveListener
return UITCCardMainPanelView
