local UILWScienceDetailView = BaseClass("UILWScienceDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RewardType = _ENV.RewardType
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local tonumber = _ENV.tonumber
local pairs = _ENV.pairs
local table_insert = table.insert
local string_IsNullOrEmpty = string.IsNullOrEmpty
local string_split = string.split
local math_floor = math.floor
local Item = require("UI.UILWScience.UILWScienceDetail.Component.UILWScienceDetailItem")
local NewQueueState = _ENV.NewQueueState
local title_text_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local back_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local science_icon_path = "Root/Content/Up/Science/ScienceIcon"
local science_lv_text_path = "Root/Content/Up/Science/LevelText"
local science_max_lv_text_path = "Root/Content/Up/Science/maxText"
local science_desc_text_path = "Root/Content/Up/DescText"
local science_cur_upgrade_title_path = "Root/Content/Up/CurContent/CurUpgrade"
local science_cur_upgrade_text_path = "Root/Content/Up/CurContent/CurUpgradeText"
local science_next_upgrade_title_path = "Root/Content/Up/NextContent/NextUpgrade"
local science_next_upgrade_text_path = "Root/Content/Up/NextContent/NextUpgradeText"
local info_btn_path = "Root/Content/Up/InfoBtn"
local reward_icon_btn_path = "Root/Content/Up/RewardIconBtn"
local comsume_res_go_path = "Root/Content/Mid/ConsumeRes"
local comsume_res_title_text_path = "Root/Content/Mid/ConsumeRes/ConsumeResText"
local content_path = "Root/Content/Mid/ConsumeRes/Scroll/Viewport/Content"
local item_path = "Root/Content/Mid/ConsumeRes/Scroll/Viewport/Item"
local max_lv_text_path = "Root/Content/Mid/MaxLvTxt"
local slider_path = "Root/Content/Mid/Slider"
local slider_text_path = "Root/Content/Mid/Slider/ProgressText"
local study_now_btn_path = "Root/Content/Bottom/StudyNowBtn"
local study_now_title_path = "Root/Content/Bottom/StudyNowBtn/StudyNowTitle"
local study_now_icon_path = "Root/Content/Bottom/StudyNowBtn/StudyNowText/StudyNowIcon"
local study_now_text_path = "Root/Content/Bottom/StudyNowBtn/StudyNowText"
local research_btn_path = "Root/Content/Bottom/ResearchBtn"
local research_title_path = "Root/Content/Bottom/ResearchBtn/ResearchTitle"
local research_text_path = "Root/Content/Bottom/ResearchBtn/ResearchText"
local original_time_text_path = "Root/Content/Bottom/ResearchBtn/OriginalTimeText"
local speed_up_btn_path = "Root/Content/Bottom/SpeedUpBtn"
local speed_up_title_path = "Root/Content/Bottom/SpeedUpBtn/SpeedUpTitle"
local bg1_go_path = "Root/Content/UICommonPopBg/bg_1"
local bg2_go_path = "Root/Content/UICommonPopBg/bg_2"
local bg3_go_path = "Root/Content/UICommonPopBg/bg_3"
local up_go_path = "Root/Content/Up"
local bottom_go_path = "Root/Content/Bottom"
local useQueue_bg_path = "Root/Content/Bottom/ResearchBtn/UseQueueBg"
local useQueue_text_path = "Root/Content/Bottom/ResearchBtn/UseQueueBg/QueueText"
local MAX_LV_TXT = 110000
local CUR_UPGRADE_TITLE = 200189
local NEXT_UPGRADE_TITLE = 200190
local MAX_LV_TITLE = GameDialogDefine.REACH_MAX_LEVEL
local CONSUME_RES_TITLE = 100040
local STUDY_NOW_TITLE = GameDialogDefine.IMMEDIATELY_RESEARCHING
local RESEARCH_TITLE = GameDialogDefine.RESEARCHING
local SPEED_UP_TITLE = GameDialogDefine.ADD_SPEED
local ALLIANCE_HELP_TITLE = GameDialogDefine.ALLIANCE_HELP
local DiamondCanNotBuyResourceType = {
  ResourceType.Petroleum
}
local SliderLength = 590
local rewardTipOffsetY = 0

function UILWScienceDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Tech_Lvl3_UI, false)
  self:InitReindeerTrainList()
end

function UILWScienceDetailView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWScienceDetailView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, return_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scienceIcon = self:AddComponent(UIImage, science_icon_path)
  self.scienceLvText = self:AddComponent(UIText, science_lv_text_path)
  self.scienceMaxLvText = self:AddComponent(UIText, science_max_lv_text_path)
  self.scienceDescText = self:AddComponent(UILWScienceDetailDesc, science_desc_text_path)
  self.scienceCurUpgradeTitle = self:AddComponent(UIText, science_cur_upgrade_title_path)
  self.scienceCurUpgradeText = self:AddComponent(UIText, science_cur_upgrade_text_path)
  self.scienceNextUpgradeTitle = self:AddComponent(UIText, science_next_upgrade_title_path)
  self.scienceNextUpgradeText = self:AddComponent(UIText, science_next_upgrade_text_path)
  self.scienceInfoBtn = self:AddComponent(UIButton, info_btn_path)
  self.scienceInfoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.reward_icon_btn = self:AddComponent(UIButton, reward_icon_btn_path)
  self.reward_icon_btn:SetOnClick(BindCallback(self, self.OnRewardIconBtnClick))
  local sizeDelta = self.reward_icon_btn:GetSizeDelta()
  rewardTipOffsetY = sizeDelta and sizeDelta.y or 0
  self.consumeResGo = self:AddComponent(UIBaseContainer, comsume_res_go_path)
  self.consumeResTitle = self:AddComponent(UIText, comsume_res_title_text_path)
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
  self.maxLvText = self:AddComponent(UIText, max_lv_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sliderText = self:AddComponent(UIText, slider_text_path)
  self.studyNowBtn = self:AddComponent(UIButton, study_now_btn_path)
  self.studyNowTitle = self:AddComponent(UIText, study_now_title_path)
  self.studyNowIcon = self:AddComponent(UIImage, study_now_icon_path)
  self.studyNowText = self:AddComponent(UIText, study_now_text_path)
  self.studyNowBtn:SetSafeClickMode(true)
  self.studyNowBtn:SetOnClick(function()
    self:OnStudyNowBtnClick()
  end)
  self.researchBtn = self:AddComponent(UIButton, research_btn_path)
  self.researchTitle = self:AddComponent(UIText, research_title_path)
  self.researchText = self:AddComponent(UIText, research_text_path)
  self.researchBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.ResearchBtn, false)
    self:OnResearchBtnClick()
  end)
  self.original_time_text = self:AddComponent(UITextMeshProUGUIEx, original_time_text_path)
  self.speedUpBtn = self:AddComponent(UIButton, speed_up_btn_path)
  self.speedUpTitle = self:AddComponent(UIText, speed_up_title_path)
  self.speedUpBtn:SetOnClick(function()
    self:OnSpeedUpBtnClick()
  end)
  self.bg1Go = self:AddComponent(UIBaseContainer, bg1_go_path)
  self.bg2Go = self:AddComponent(UIBaseContainer, bg2_go_path)
  self.bg3Go = self:AddComponent(UIBaseContainer, bg3_go_path)
  self.upGo = self:AddComponent(UIBaseContainer, up_go_path)
  self.bottomGo = self:AddComponent(UIBaseContainer, bottom_go_path)
  self.scienceMaxLvText:SetLocalText(MAX_LV_TXT)
  self.scienceCurUpgradeTitle:SetLocalText(CUR_UPGRADE_TITLE)
  self.scienceNextUpgradeTitle:SetLocalText(NEXT_UPGRADE_TITLE)
  self.maxLvText:SetLocalText(MAX_LV_TITLE)
  self.consumeResTitle:SetLocalText(CONSUME_RES_TITLE)
  self.studyNowTitle:SetLocalText(STUDY_NOW_TITLE)
  self.researchTitle:SetLocalText(RESEARCH_TITLE)
  self.speedUpTitle:SetLocalText(SPEED_UP_TITLE)
  self.studyNowIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self.useQueueBg = self:AddComponent(UIBaseContainer, useQueue_bg_path)
  self.useQueueText = self:AddComponent(UIText, useQueue_text_path)
end

function UILWScienceDetailView:ComponentDestroy()
  self.titleText = nil
  self.backBtn = nil
  self.closeBtn = nil
  self.scienceIcon = nil
  self.scienceLvText = nil
  self.scienceMaxLvText = nil
  self.scienceDescText = nil
  self.scienceCurUpgradeTitle = nil
  self.scienceCurUpgradeText = nil
  self.scienceNextUpgradeTitle = nil
  self.scienceNextUpgradeText = nil
  self.scienceInfoBtn = nil
  self.reward_icon_btn = nil
  self.consumeResGo = nil
  self.consumeResTitle = nil
  self.listContent = nil
  self.listItemPrefab = nil
  self.maxLvText = nil
  self.slider = nil
  self.sliderText = nil
  self.studyNowBtn = nil
  self.studyNowTitle = nil
  self.studyNowIcon = nil
  self.studyNowText = nil
  self.researchBtn = nil
  self.researchTitle = nil
  self.researchText = nil
  self.original_time_text = nil
  self.speedUpBtn = nil
  self.speedUpTitle = nil
  self.bg1Go = nil
  self.bg2Go = nil
  self.bg3Go = nil
  self.upGo = nil
  self.bottomGo = nil
end

function UILWScienceDetailView:DataDefine()
  self.ctrl:SetView(self)
  self.btnCells = {}
  self.lastCurTime = 0
  self.bUuid = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.buildNextLevelTemplate = nil
  self.preBuildCells = {}
  self.freePreBuildCells = {}
  self.needResourceCells = {}
  self.freeNeedResourceCells = {}
  self.lackResource = {}
  self.lackItem = {}
  self.btnGoActive = nil
  self.immediatelyBtnSpendColor = nil
  self.needText = nil
  self.desCells = {}
  self.freeDesCells = {}
  self.spendGold = 0
  self.hasItem = nil
  self.noBuyItem = {}
  self.lackResourceItem = {}
  self.isResearchFinished = nil
  self.PreConditionList = {}
  self.ResourceModels = {}
  self.modelCount = 0
  self.scienceResearchNewMsgLock = false
  self.trainList = nil
  self.rewardList = nil
end

function UILWScienceDetailView:DataDestroy()
  self.ctrl:ClearView()
  self.btnCells = nil
  self.allNeed = nil
  self.bUuid = nil
  self.buildUuid = nil
  self.buildData = nil
  self.buildTemplate = nil
  self.buildCurLevelTemplate = nil
  self.buildNextLevelTemplate = nil
  self.preBuildCells = nil
  self.freePreBuildCells = nil
  self.needResourceCells = nil
  self.freeNeedResourceCells = nil
  self.lackResource = nil
  self.lackItem = nil
  self.btnGoActive = nil
  self.immediatelyBtnSpendColor = nil
  self.needText = nil
  self.desCells = nil
  self.freeDesCells = nil
  self.spendGold = nil
  self.hasItem = nil
  self.lastCurTime = nil
  self.noBuyItem = nil
  self.lackResourceItem = nil
  self.isResearchFinished = nil
  self.PreConditionList = nil
  self.ResourceModels = nil
  self.modelCount = nil
  self.showBtnTime = nil
  self.scienceResearchNewMsgLock = nil
  if self.trainList then
    table.clear(self.trainList)
  end
  self.trainList = nil
  if self.rewardList then
    table.clear(self.rewardList)
  end
  self.rewardList = nil
end

function UILWScienceDetailView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UILWScienceDetailView:OnDisable()
  base.OnDisable(self)
end

function UILWScienceDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:AddUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:AddUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
  self:AddUIListener(EventId.SoldResourceItem, self.UpdateResourceItemSignal)
  self:AddUIListener(EventId.UnLockScienceResearchNewMsg, self.UnLockScienceResearchNewMsg)
  self:AddUIListener(EventId.MainLvUp, self.OnMainLvUp)
  self:AddUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinish)
end

function UILWScienceDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
  self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
  self:RemoveUIListener(EventId.SoldResourceItem, self.UpdateResourceItemSignal)
  self:RemoveUIListener(EventId.UnLockScienceResearchNewMsg, self.UnLockScienceResearchNewMsg)
  self:RemoveUIListener(EventId.MainLvUp, self.OnMainLvUp)
  self:RemoveUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinish)
end

function UILWScienceDetailView:RefreshSize(is_big)
  local bg1PosY = {-36.5, 1.5}
  local bg1Height = {1043.5, 756.5}
  self.bg1Go:SetLocalPosition(Vector3.New(self.bg1Go:GetLocalPosition().x, bg1PosY[is_big and 1 or 2], self.bg1Go:GetLocalPosition().z))
  self.bg1Go:SetSizeDelta(Vector2.New(self.bg1Go:GetSizeDelta().x, bg1Height[is_big and 1 or 2]))
  local bg2PosY = {41, 32}
  local bg2Height = {744.5, 466.5}
  self.bg2Go:SetLocalPosition(Vector3.New(self.bg2Go:GetLocalPosition().x, bg2PosY[is_big and 1 or 2], self.bg2Go:GetLocalPosition().z))
  self.bg2Go:SetSizeDelta(Vector2.New(self.bg2Go:GetSizeDelta().x, bg2Height[is_big and 1 or 2]))
  local bg3PosY = {447, 299}
  self.bg3Go:SetLocalPosition(Vector3.New(self.bg3Go:GetLocalPosition().x, bg3PosY[is_big and 1 or 2], self.bg3Go:GetLocalPosition().z))
  local upPosY = {278, 128}
  self.upGo:SetLocalPosition(Vector3.New(self.upGo:GetLocalPosition().x, upPosY[is_big and 1 or 2], self.upGo:GetLocalPosition().z))
  local bottomPosY = {-450, -269}
  self.bottomGo:SetLocalPosition(Vector3.New(self.bottomGo:GetLocalPosition().x, bottomPosY[is_big and 1 or 2], self.bottomGo:GetLocalPosition().z))
end

function UILWScienceDetailView:ClearContent()
  self.listContent:RemoveComponents(Item)
end

function UILWScienceDetailView:RefreshMid(needRefresh)
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  local list = self:GetAllNeed(needRefresh)
  local redList = {}
  local notRedList = {}
  for _, item in ipairs(list) do
    if item.isRed then
      table.insert(redList, item)
    else
      table.insert(notRedList, item)
    end
  end
  for _, item in ipairs(notRedList) do
    table.insert(redList, item)
  end
  for k, v in ipairs(redList) do
    local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
    item.name = "item" .. k
    local cell = self.listContent:AddComponent(Item, item.name)
    cell:SetData(v)
    self.btnCells[v] = cell
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
end

function UILWScienceDetailView:GetAllNeed(needRefresh)
  if not self.allNeed or needRefresh then
    self.allNeed = {}
    local preBuild = self.buildNextLevelTemplate.needBuild
    if preBuild ~= nil then
      for _, v1 in ipairs(preBuild) do
        local buildId = v1.buildId
        local hasBuild = true
        if DataCenter.ScienceManager:IsScienceBuild(v1.buildId) then
          local highestLevel = DataCenter.ScienceManager:GetHighestScienceBuildingLevel()
          if highestLevel < v1.level then
            hasBuild = false
          end
        else
          hasBuild = DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, v1.level)
        end
        local param = {}
        param.condType = ScienceUnlockConditionType.Building
        param.itemId = buildId
        param.level = v1.level
        if not hasBuild then
          param.isRed = true
        else
          param.isRed = false
        end
        table.insert(self.allNeed, param)
      end
    end
    local effect = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SCIENCE_CUTDOWN)
    effect = effect or 0
    effect = LuaEntry.Effect:GetFixDoubleNumber(effect)
    local needScience = self.buildNextLevelTemplate.needScience
    if needScience ~= nil then
      for _, v in ipairs(needScience) do
        local param = {}
        param.condType = ScienceUnlockConditionType.Science
        param.itemId = v.scienceId
        param.level = v.level
        if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
          param.isRed = true
        else
          param.isRed = false
        end
        table.insert(self.allNeed, param)
      end
    end
    local lackList = {}
    self.hasItem = false
    local items = self.buildNextLevelTemplate.needItem
    if items ~= nil then
      for _, v1 in ipairs(items) do
        local param = {}
        param.condType = ScienceUnlockConditionType.Item
        param.itemId = v1.itemId
        param.count = math.ceil(v1.count * (1 - effect))
        local own = 0
        local item = DataCenter.ItemData:GetItemById(param.itemId)
        if item ~= nil then
          own = item.count
        end
        param.own = own
        if own >= param.count then
          table.insert(self.allNeed, param)
        else
          table.insert(lackList, param)
        end
        self.hasItem = true
      end
    end
    local addResList = {}
    local resources = self.buildNextLevelTemplate.needResource
    if resources ~= nil then
      for _, v1 in ipairs(resources) do
        local param = {}
        param.condType = ScienceUnlockConditionType.Resource
        param.resourceType = v1.resourceType
        param.count = math.ceil(v1.count * (1 - effect))
        local own = LuaEntry.Resource:GetCntByResType(v1.resourceType)
        param.own = own
        table.insert(addResList, param)
      end
      table.sort(addResList, function(a, b)
        return a.resourceType < b.resourceType
      end)
      for _, v in ipairs(addResList) do
        if v.own >= v.count then
          table.insert(self.allNeed, v)
        else
          table.insert(lackList, v)
        end
      end
    end
    if self.buildNextLevelTemplate:IsShowTabConditionInDetail() then
      local tabCondition = self.buildNextLevelTemplate:GetTabCondition()
      local param = {}
      param.condType = ScienceUnlockConditionType.ScienceGroupPercent
      param.needPercent = tabCondition.needPercent
      param.descKey = tabCondition.descKey
      param.tabIdList = tabCondition.tabIdList
      param.bUuid = self.bUuid
      local minPercent, minPercentId
      local totalPercent = 0
      for i, tabId in ipairs(param.tabIdList) do
        if tabId and 0 < tabId then
          local percent = DataCenter.ScienceTemplateManager:GetScienceTabProIntValue(tabId)
          totalPercent = totalPercent + percent
          if not minPercent or minPercent > percent then
            minPercent = percent
            minPercentId = tabId
          end
        end
      end
      param.curPercent = math_floor(totalPercent)
      param.isRed = totalPercent < param.needPercent
      param.minPercentId = minPercentId
      if totalPercent >= param.needPercent then
        table.insert(self.allNeed, param)
      else
        table.insert(lackList, param)
      end
    end
    table.insertto(lackList, self.allNeed)
    self.allNeed = lackList
  end
  
  local function GetParam(conditionType, id)
    for _, v in ipairs(self.allNeed) do
      if v.condType == conditionType then
        if conditionType == 5 then
          if v.itemId == id then
            return v
          end
        elseif conditionType == 3 then
          if v.resourceType == id then
            return v
          end
        elseif conditionType == 4 then
          if v.resourceItemId == id then
            return v
          end
        else
          return v
        end
      end
    end
    return nil
  end
  
  self.noBuyItem = {}
  self.lackItem = {}
  local items = self.buildNextLevelTemplate.needItem
  if items ~= nil then
    for _, v1 in ipairs(items) do
      local param = GetParam(5, v1.itemId) or {}
      local own = 0
      local item = DataCenter.ItemData:GetItemById(param.itemId)
      if item ~= nil then
        own = item.count
      end
      param.own = own
      if own < param.count then
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
        if template ~= nil then
          if 0 < template.price then
            local par = {}
            par.itemId = param.itemId
            par.allCount = param.count
            par.needCount = par.allCount - own
            par.needGold = template.price * par.needCount
            table.insert(self.lackItem, par)
          else
            local par = {}
            par.itemId = param.itemId
            par.allCount = param.count
            par.needCount = par.allCount - own
            table.insert(self.noBuyItem, par)
          end
        end
        param.isRed = true
      else
        param.isRed = false
      end
    end
  end
  local effect = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SCIENCE_CUTDOWN)
  effect = effect or 0
  self.lackResource = {}
  local resources = self.buildNextLevelTemplate.needResource
  if resources ~= nil then
    for _, v1 in ipairs(resources) do
      local param = GetParam(3, v1.resourceType) or {}
      local own = LuaEntry.Resource:GetCntByResType(v1.resourceType)
      param.own = own
      if own < param.count then
        local res = {}
        res.resourceType = v1.resourceType
        res.allCount = param.count
        res.needCount = res.allCount - own
        table.insert(self.lackResource, res)
        param.isRed = true
      else
        param.isRed = false
      end
    end
  end
  self.lackResourceItem = {}
  local resItems = self.buildNextLevelTemplate.needResourceItem
  if resItems ~= nil then
    for _, v1 in ipairs(resItems) do
      local param = GetParam(4, v1.resourceItemId) or {}
      local own = 0
      local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(param.resourceItemId)
      if item ~= nil then
        own = item.number
      end
      param.own = own
      if own < param.count then
        local res = {}
        res.resourceItemId = param.resourceItemId
        res.allCount = param.count
        res.needCount = res.allCount - own
        table.insert(self.lackResourceItem, res)
        param.isRed = true
      else
        param.isRed = false
      end
    end
  end
  return self.allNeed
end

function UILWScienceDetailView:ReInit()
  local scienceId, bUuid = self:GetUserData()
  self.scienceId = scienceId
  self.reward_icon_btn:SetActive(scienceId == 130006300)
  local data = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_SCIENE)
  self.scienceUid = data.uuid
  local allScienceQueue = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
  self.hasUnlockSecondQueue = DataCenter.ScienceManager:HasUnlockSecondQueue()
  self.hasExtraQueue = DataCenter.ScienceManager:HasExtraQueue()
  if self.hasExtraQueue then
    local firstQueue, secondQueue, thirdQueue
    for _, v in ipairs(allScienceQueue) do
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v.funcUuid)
      if buildData then
        if buildData.itemId == BuildingTypes.FUN_BUILD_SCIENE then
          firstQueue = v
        elseif buildData.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO then
          secondQueue = v
        elseif buildData.itemId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
          thirdQueue = v
        end
      end
    end
    if not firstQueue and not secondQueue and not thirdQueue then
      self.bUuid = self.scienceUid
    else
      local firstQueueState = firstQueue:GetQueueState()
      local secondQueueState = secondQueue and secondQueue:GetQueueState() or nil
      local thirdQueueState = thirdQueue and thirdQueue:GetQueueState() or nil
      if firstQueueState == NewQueueState.Free then
        self.bUuid = firstQueue.funcUuid
        self.queueIndex = 1
      elseif secondQueueState == NewQueueState.Free then
        self.bUuid = secondQueue.funcUuid
        self.queueIndex = 2
      elseif thirdQueueState == NewQueueState.Free then
        self.bUuid = thirdQueue.funcUuid
        self.queueIndex = 3
      else
        self.bUuid = firstQueue.funcUuid
        self.queueIndex = 1
      end
    end
  else
    self.bUuid = self.scienceUid
  end
  self.isResearchFinished = false
  self:RefreshContent()
end

function UILWScienceDetailView:RefreshContent()
  self.maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.scienceId)
  self.queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(self.scienceId))
  self.curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
  local name = ""
  local des = ""
  local icon = ""
  local isTacticalWeaponSkillStarUp = false
  if self.curLevel > 0 then
    self.buildCurLevelTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, self.curLevel)
    name = self.buildCurLevelTemplate.name
    des = self.buildCurLevelTemplate:GetDesc()
    isTacticalWeaponSkillStarUp = self.buildCurLevelTemplate:IsTacticalWeaponSkillStarUp()
    icon = string.format(LoadPath.UILWScience, self.buildCurLevelTemplate.icon)
  else
    self.buildCurLevelTemplate = nil
  end
  if self.curLevel < self.maxLevel then
    self.buildNextLevelTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, self.curLevel + 1)
    if name == "" then
      name = self.buildNextLevelTemplate.name
    end
    if des == "" then
      des = self.buildNextLevelTemplate:GetDesc()
    end
    if icon == "" then
      icon = string.format(LoadPath.UILWScience, self.buildNextLevelTemplate.icon)
    end
    isTacticalWeaponSkillStarUp = self.buildNextLevelTemplate:IsTacticalWeaponSkillStarUp()
  else
    self.buildNextLevelTemplate = nil
  end
  local showName = UIUtil.GetLocalizationString(name)
  if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
    if not self.buildNextLevelTemplate then
      showName = string.format("%s[nil]", showName)
    else
      showName = string.format("%s[%s]", showName, self.buildNextLevelTemplate.id)
    end
  end
  self.titleText:SetText(showName)
  self.scienceIcon:LoadSprite(icon)
  if self.curLevel >= self.maxLevel then
    self.scienceMaxLvText:SetActive(true)
    self.scienceLvText:SetActive(false)
  else
    self.scienceMaxLvText:SetActive(false)
    self.scienceLvText:SetActive(true)
    self.scienceLvText:SetText(self.curLevel .. "/" .. self.maxLevel)
  end
  
  local function ProcessDesc(desc)
    local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#EF6B00"))
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
    return modifiedText
  end
  
  des = ProcessDesc(des)
  if not isTacticalWeaponSkillStarUp then
    self.scienceDescText:SetText(des)
  else
    self.scienceDescText:SetTextAndParam(des, {
      descType = ScienceDetailDescType.TacticalWeaponSkillStarUp,
      level = self.curLevel
    })
  end
  self:RefreshEffects()
  self.researchingActive = false
  if self.curLevel >= self.maxLevel then
    self:RefreshSize(false)
    self.consumeResGo:SetActive(false)
    self.maxLvText:SetActive(true)
    self.slider:SetActive(false)
    self.studyNowBtn:SetActive(false)
    self.researchBtn:SetActive(false)
    self.speedUpBtn:SetActive(false)
  elseif self.queue ~= nil and (self.queue:GetQueueState() == NewQueueState.Work or self.queue:GetQueueState() == NewQueueState.Finish) and tostring(self.scienceId) == self.queue.itemId then
    local state = self.queue:GetQueueState()
    self:RefreshSize(false)
    self.consumeResGo:SetActive(false)
    self.maxLvText:SetActive(false)
    self.slider:SetActive(true)
    self.studyNowBtn:SetActive(false)
    self.researchBtn:SetActive(false)
    self.speedUpBtn:SetActive(true)
    if LuaEntry.Player:IsInAlliance() and state == NewQueueState.Work and self.queue.isHelped == 0 then
      self.speedUpTitle:SetLocalText(ALLIANCE_HELP_TITLE)
    elseif state == NewQueueState.Finish then
      self.speedUpTitle:SetLocalText("research_finish_button")
      self:SetSliderValue(1)
      self:SetCurTimeValue("")
    else
      self.speedUpTitle:SetLocalText(SPEED_UP_TITLE)
    end
    self.researchingActive = true
  else
    self:RefreshSize(true)
    self.consumeResGo:SetActive(true)
    self.maxLvText:SetActive(false)
    self.slider:SetActive(false)
    self.speedUpBtn:SetActive(false)
    self:RefreshMid(true)
    self.studyNowBtn:SetActive(DataCenter.BuildManager:IsShowDiamond())
    self.researchBtn:SetActive(true)
    self:ShowBtn()
    local unreachedPreConditions = self:GetUnreachedPreConditions()
    if 0 < #unreachedPreConditions then
      UIGray.SetGray(self.studyNowBtn.transform, true, false)
      UIGray.SetGray(self.researchBtn.transform, true, false)
    else
      UIGray.SetGray(self.studyNowBtn.transform, false, true)
      UIGray.SetGray(self.researchBtn.transform, false, true)
    end
    self:CheckStudyNowBtnGrayState()
  end
end

function UILWScienceDetailView:RefreshEffects()
  self.scienceCurUpgradeTitle:SetActive(true)
  self.scienceNextUpgradeTitle:SetActive(false)
  self.scienceNextUpgradeText:SetActive(false)
  if self.buildCurLevelTemplate == nil and self.buildNextLevelTemplate ~= nil then
    local nextEffect = self.buildNextLevelTemplate and self.buildNextLevelTemplate.effect
    if nextEffect and 0 < #nextEffect then
      nextEffect = nextEffect[1]
      self.scienceNextUpgradeTitle:SetActive(true)
      self.scienceNextUpgradeText:SetActive(true)
      self.scienceNextUpgradeText:SetText(self.buildNextLevelTemplate:GetEffectDesText())
    end
    self.scienceCurUpgradeText:SetText(self.buildNextLevelTemplate:GetEffectDesTextLv0())
  elseif self.buildCurLevelTemplate ~= nil and self.buildNextLevelTemplate == nil then
    local curEffect = self.buildCurLevelTemplate and self.buildCurLevelTemplate.effect
    if curEffect and 0 < #curEffect then
      curEffect = curEffect[1]
      self.scienceCurUpgradeText:SetText(self.buildCurLevelTemplate:GetEffectDesText())
    end
  elseif self.buildCurLevelTemplate ~= nil and self.buildNextLevelTemplate ~= nil then
    local curEffect = self.buildCurLevelTemplate and self.buildCurLevelTemplate.effect
    if curEffect and 0 < #curEffect then
      curEffect = curEffect[1]
      self.scienceCurUpgradeText:SetText(self.buildCurLevelTemplate:GetEffectDesText())
    end
    local nextEffect = self.buildNextLevelTemplate and self.buildNextLevelTemplate.effect
    if nextEffect and 0 < #nextEffect then
      nextEffect = nextEffect[1]
      self.scienceNextUpgradeTitle:SetActive(true)
      self.scienceNextUpgradeText:SetActive(true)
      self.scienceNextUpgradeText:SetText(self.buildNextLevelTemplate:GetEffectDesText())
    end
  end
end

function UILWScienceDetailView:Update()
  if self.researchingActive and self.queue ~= nil then
    if self.queue:GetQueueState() == NewQueueState.Work then
      self:UpdateLeftTime()
    elseif self.queue:GetQueueState() == NewQueueState.Finish and not self.isResearchFinished then
      self.isResearchFinished = true
      self:RefreshContent()
    end
  end
end

function UILWScienceDetailView:UpdateLeftTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local changeTime = self.queue.endTime - curTime
  local maxTime = self.queue.endTime - self.queue.startTime
  if changeTime < maxTime and 0 < changeTime then
    local tempTimeSec = math.ceil(changeTime / 1000)
    if tempTimeSec ~= self.laseTime then
      self.laseTime = tempTimeSec
      local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
      self:SetCurTimeValue(tempTimeValue)
    end
    if 0 < maxTime then
      local tempValue = 1 - changeTime / maxTime
      if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.queue.endTime - self.lastCurTime, maxTime, SliderLength) then
        self.lastCurTime = curTime
        self:SetSliderValue(tempValue)
      end
    end
  else
    self.laseTime = 0
    self:SetSliderValue(0)
    self:SetCurTimeValue("")
  end
end

function UILWScienceDetailView:SetSliderValue(value)
  if self.curSliderValue ~= value then
    self.curSliderValue = value
    self.slider:SetValue(value)
  end
end

function UILWScienceDetailView:SetCurTimeValue(value)
  if self.curTimeValue ~= value then
    self.curTimeValue = value
    self.sliderText:SetText(value)
  end
end

function UILWScienceDetailView:GetUnreachedPreConditions()
  local retTb = {}
  local preBuild = self.buildNextLevelTemplate.needBuild
  if preBuild ~= nil then
    for k1, v1 in ipairs(preBuild) do
      local buildId = v1.buildId
      local hasBuild = true
      if DataCenter.ScienceManager:IsScienceBuild(v1.buildId) then
        local highestLevel = DataCenter.ScienceManager:GetHighestScienceBuildingLevel()
        if highestLevel < v1.level then
          hasBuild = false
        end
      else
        hasBuild = DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, v1.level)
      end
      if not hasBuild then
        local cond = {}
        cond.condType = 1
        cond.itemId = buildId
        cond.level = v1.level
        table.insert(retTb, cond)
      end
    end
  end
  local needScience = self.buildNextLevelTemplate.needScience
  if needScience ~= nil then
    for k, v in ipairs(needScience) do
      if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
        local cond = {}
        cond.condType = 2
        cond.itemId = v.scienceId
        cond.level = v.level
        table.insert(retTb, cond)
      end
    end
  end
  if self.buildNextLevelTemplate:IsShowTabConditionInDetail() then
    local tabCondition = self.buildNextLevelTemplate:GetTabCondition()
    local totalPercent = 0
    for i, tabId in ipairs(tabCondition.tabIdList) do
      if tabId and 0 < tabId then
        local percent = DataCenter.ScienceTemplateManager:GetScienceTabPro(tabId)
        totalPercent = totalPercent + percent * 100
      end
    end
    if totalPercent < tabCondition.needPercent then
      local cond = {}
      cond.condType = ScienceUnlockConditionType.ScienceGroupPercent
      cond.itemId = 0
      cond.level = 0
      table.insert(retTb, cond)
    end
  end
  return retTb
end

function UILWScienceDetailView:ShowBtn()
  self:RefreshImmediatelyGold()
  local nTime = self.buildNextLevelTemplate:GetScienceTime(self.bUuid)
  self.showBtnTime = nTime
  self.researchText:SetText(UITimeManager:GetInstance():SecondToFmtString(nTime))
  if self.hasExtraQueue then
    self.useQueueBg:SetActive(true)
    self.useQueueText:SetText(self.queueIndex and tostring(self.queueIndex) or "1")
  else
    self.useQueueBg:SetActive(false)
  end
  self.original_time_text:SetLocalText("original_time_title", UITimeManager:GetInstance():MilliSecondToFmtString(self.buildNextLevelTemplate.time * 1000))
end

function UILWScienceDetailView:CheckStudyNowBtnGrayState()
  local unreachedPreConditions = self:GetUnreachedPreConditions()
  if unreachedPreConditions and 0 < #unreachedPreConditions then
    return
  end
  local isNeedGraystudyNowBtn = self:IsExistLackResNotGetWithDiamond()
  UIGray.SetGray(self.studyNowBtn.transform, isNeedGraystudyNowBtn, not isNeedGraystudyNowBtn)
end

local timeIconPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/guaji_cfm_tubiao_2.png"

function UILWScienceDetailView:RefreshImmediatelyGold()
  local nTime = self.buildNextLevelTemplate:GetScienceTime(self.bUuid)
  local speedUpTime = 0
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
  if buildData ~= nil then
    speedUpTime = BuildingUtils.GetPropertyValueByType(buildData, 4, EffectDefine.LW_SCIENCE_RESEARCH_SPEEDUP)
  end
  if speedUpTime < 0 then
    speedUpTime = 0
  end
  nTime = nTime - speedUpTime
  self.spendGold = CommonUtil.GetTimeDiamondCost(nTime)
  if 0 < table.count(self.lackResource) then
    for k, v in ipairs(self.lackResource) do
      self.spendGold = self.spendGold + CommonUtil.GetResGoldByType(v.resourceType, v.needCount)
    end
  end
  if 0 < table.count(self.lackItem) then
    for k, v in ipairs(self.lackItem) do
      self.spendGold = self.spendGold + v.needGold
    end
  end
  local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
  if 0 < freeTime and nTime <= freeTime then
    if self:IsLack() then
      self.isFree = false
      self.studyNowTitle:SetAnchoredPositionXY(self.studyNowTitle:GetAnchoredPositionX(), 24)
      self.studyNowText:SetActive(true)
    else
      self.isFree = true
      self.studyNowTitle:SetAnchoredPositionXY(self.studyNowTitle:GetAnchoredPositionX(), 10)
      self.studyNowText:SetActive(false)
    end
  else
    self.isFree = nTime <= 0
    self.studyNowTitle:SetAnchoredPositionXY(self.studyNowTitle:GetAnchoredPositionX(), 24)
    self.studyNowText:SetActive(true)
  end
  local isNonResLack = self:IsCantBuyLack()
  if isNonResLack then
    local lackIcon
    local lackCount = 0
    if not lackIcon then
      for k, v in pairs(self.noBuyItem) do
        if 0 < v.needCount then
          lackIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, v.itemId)
          local curHave = DataCenter.ItemData:GetItemCount(v.itemId) or 0
          lackCount = v.allCount - curHave
          break
        end
      end
    end
    if not lackIcon then
      for k, v in pairs(self.lackResourceItem) do
        if 0 < v.needCount then
          lackIcon = DataCenter.RewardManager:GetPicByType(RewardType.RESOURCE_ITEM, v.itemId)
          local curHave = DataCenter.ResourceItemDataManager:GetCountByItemId(v.itemId)
          lackCount = v.allCount - curHave
          break
        end
      end
    end
    if lackIcon then
      self.studyNowIcon:LoadSprite(lackIcon)
      self.studyNowText:SetText(lackCount)
      self:SetImmediatelyBtnSpendColor(RedColor)
      self.studyNowTitle:SetLocalText(STUDY_NOW_TITLE)
      return
    end
  end
  local lackList
  if self:IsLack() then
    lackList = {true}
  else
    lackList = {}
  end
  local stateInfo = LWResourceLackUtil:GetResState(nTime, lackList, ItemSpdMenu.ItemSpdMenu_Science)
  if not self.isFree and stateInfo.miaCompleteState == MiaCompleteState.ItemAmpleResAmple then
    self.studyNowIcon:LoadSprite(timeIconPath)
    self.studyNowText:SetText(UITimeManager:GetInstance():SecondToFmtString(nTime))
    self:SetImmediatelyBtnSpendColor(WhiteColor)
    self.studyNowTitle:SetLocalText(STUDY_NOW_TITLE)
  else
    self.studyNowIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    self.studyNowText:SetText(string.GetFormattedSeperatorNum(self.spendGold))
    self:RefreshGoldColor()
    self.studyNowTitle:SetLocalText(STUDY_NOW_TITLE)
  end
end

function UILWScienceDetailView:RefreshGoldColor()
  local gold = LuaEntry.Player.gold
  if gold < self.spendGold then
    self:SetImmediatelyBtnSpendColor(RedColor)
  else
    self:SetImmediatelyBtnSpendColor(WhiteColor)
  end
end

function UILWScienceDetailView:SetImmediatelyBtnSpendColor(value)
  if self.immediatelyBtnSpendColor ~= value then
    self.immediatelyBtnSpendColor = value
    self.studyNowText:SetColor(value)
  end
end

function UILWScienceDetailView:OnInfoBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceInfo, {anim = true}, self.scienceId, self.curLevel, self.maxLevel)
end

function UILWScienceDetailView:InitReindeerTrainList()
  local quality, hqLevel = 0, 0
  self.trainList = {}
  LocalController:instance():visitTable(TableName.LW_Train_Property, function(id, lineData)
    if lineData ~= nil then
      quality = tonumber(lineData:getValue("quality")) or 0
      if quality == 10 and id ~= nil and id ~= "" then
        hqLevel = tonumber(lineData:getValue("HQLevel")) or 0
        self.trainList[hqLevel] = id
      end
    end
  end)
end

function UILWScienceDetailView:OnRewardIconBtnClick()
  self:GetReindeerRewardData()
  if self.rewardList and #self.rewardList > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, self.reward_icon_btn, self.rewardList, 0, -rewardTipOffsetY)
  end
end

function UILWScienceDetailView:GetReindeerRewardData(refresh)
  if self.rewardList == nil then
    self.rewardList = {}
  end
  if #self.rewardList == 0 or refresh then
    table.clear(self.rewardList)
    self.rewardList = self:GetReindeerRewardDataNew()
  end
end

function UILWScienceDetailView:GetReindeerRewardDataNew()
  local mainLv = DataCenter.BuildManager.MainLv
  if self.trainList == nil then
    return
  end
  local id = self.trainList[mainLv]
  if string.IsNullOrEmpty(id) then
    return
  end
  local line = LocalController:instance():getLine(TableName.LW_Train_Property, id)
  if line then
    local rewardList = {}
    local baseRewardId = tonumber(line:getValue("reward1")) or 0
    self:GetRewardDataRow(rewardList, baseRewardId, RewardType.RESOURCE)
    local specRewardIds = line:getValue("slot_specially_reward")
    if not string_IsNullOrEmpty(specRewardIds) then
      local ids = string_split(specRewardIds, ";")
      if ids and 0 < #ids then
        for i, id in pairs(ids) do
          self:GetRewardDataRow(rewardList, id, RewardType.GOODS)
        end
      end
    end
    return rewardList
  end
end

function UILWScienceDetailView:GetRewardDataRow(list, id, type)
  if id ~= 0 then
    local line = LocalController:instance():getLine(TableName.RewardConfig, id)
    if type == RewardType.RESOURCE then
      local itemIdRes = line:getValue("resource_randomtype") or ""
      local itemNumRes = line:getValue("resource_rate") or ""
      if not string_IsNullOrEmpty(itemIdRes) and not string_IsNullOrEmpty(itemNumRes) then
        local itemNumsS = string_split(itemNumRes, "|")
        local itemIds = string_split(itemIdRes, "|")
        if itemIds ~= nil and 0 < #itemNumsS then
          list = list or {}
          local data = {}
          local rewardType = 0
          local id = 0
          local count = 0
          for i, v in pairs(itemIds) do
            data = {}
            local idsNumsD = string_split(itemNumsS[i], ";")
            id = tonumber(v) or 0
            data.itemId = id
            local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BASIC_RESOURCE_PRODUCT_PROMOTION)
            count = tonumber(idsNumsD[1]) or 0
            count = math_floor(count * (1 + effectValue))
            data.count = count
            if id == 1 then
              rewardType = RewardType.METAL
            elseif id == 14 then
              rewardType = RewardType.FOOD
            elseif id == 2 then
              rewardType = RewardType.Wood
            end
            data.rewardType = rewardType
            table_insert(list, data)
          end
          return list
        end
      end
    elseif type == RewardType.GOODS then
      local itemId = tonumber(line:getValue("item")) or 0
      local itemCount = tonumber(line:getValue("num")) or 0
      if itemId ~= 0 and itemCount ~= 0 then
        table_insert(list, {
          itemId = itemId,
          count = itemCount,
          rewardType = type
        })
      end
    end
  end
  return list
end

function UILWScienceDetailView:IsLack()
  return not table.IsNullOrEmpty(self.lackResource) or not table.IsNullOrEmpty(self.lackResourceItem) or not table.IsNullOrEmpty(self.lackItem) or not table.IsNullOrEmpty(self.noBuyItem)
end

function UILWScienceDetailView:IsLackResourceDiamondCanBuy()
  if not table.IsNullOrEmpty(self.lackResource) then
    for _, lack in pairs(self.lackResource) do
      if lack then
        for _, v in pairs(DiamondCanNotBuyResourceType) do
          if lack.resourceType == v then
            return false
          end
        end
      end
    end
  end
  return true
end

function UILWScienceDetailView:IsCantBuyLack()
  return not table.IsNullOrEmpty(self.lackResourceItem) or not table.IsNullOrEmpty(self.noBuyItem)
end

function UILWScienceDetailView:OnStudyNowBtnClick()
  if self.scienceResearchNewMsgLock then
    UIUtil.ShowTipsId(120289)
    return
  end
  local lackList
  if self:IsLack() then
    lackList = {true}
  else
    lackList = {}
  end
  local time = self.buildNextLevelTemplate:GetScienceTime(self.bUuid)
  local speedUpTime = 0
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
  if buildData ~= nil then
    speedUpTime = math.max(0, BuildingUtils.GetPropertyValueByType(buildData, 4, EffectDefine.LW_SCIENCE_RESEARCH_SPEEDUP))
  end
  time = time - speedUpTime
  local stateInfo = LWResourceLackUtil:GetResState(time, lackList, ItemSpdMenu.ItemSpdMenu_Science)
  if stateInfo.miaCompleteState == MiaCompleteState.ItemAmpleResDeficiency then
    local isDiamondCanBuyLackResource = self:IsLackResourceDiamondCanBuy()
    local careCanBuy = not isDiamondCanBuyLackResource
    if self:ShowLack(careCanBuy) then
      return
    end
  elseif stateInfo.miaCompleteState == MiaCompleteState.ItemAmpleResAmple then
    if not self.isFree then
      local info = {}
      info.itemList = stateInfo.speedUpitems
      local scienceId = self.scienceId
      local bUuid = self.bUuid
      
      function info.callBack()
        SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, {
          itemId = scienceId,
          useGold = ScienceResearchUseGold.NoUseGold,
          robotUuid = 0,
          bUuid = bUuid,
          items = stateInfo.speedUpitems
        })
        self.scienceResearchNewMsgLock = true
      end
      
      info.remainingTime = time * 1000
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWPropUsePanel, {anim = true}, info)
      return
    end
  elseif stateInfo.miaCompleteState == MiaCompleteState.ItemDeficiencyResDeficiency then
    local isDiamondCanBuyLackResource = self:IsLackResourceDiamondCanBuy()
    local careCanBuy = not isDiamondCanBuyLackResource
    if self:ShowLack(careCanBuy) then
      return
    end
  end
  if self:IsCantBuyLack() then
    return
  end
  if LuaEntry.Player.gold < self.spendGold then
    GoToUtil.GotoPayTips(self.spendGold)
  elseif self.isFree then
    SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, {
      itemId = self.scienceId,
      useGold = ScienceResearchUseGold.Free,
      robotUuid = 0,
      bUuid = self.bUuid
    })
    self.scienceResearchNewMsgLock = true
  else
    local function ConfirmUseDiamond()
      local param = {
        contentText = Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
        
        btnNum = 2,
        confirmBtnParam = {
          action = function()
            SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, {
              itemId = self.scienceId,
              useGold = ScienceResearchUseGold.UseGold,
              robotUuid = 0,
              bUuid = self.bUuid
            })
            self.scienceResearchNewMsgLock = true
          end
        }
      }
      UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
    end
    
    local lackResourceTmp = {}
    if self.lackResource then
      for i, v in pairs(self.lackResource) do
        lackResourceTmp[v.resourceType] = v.allCount
      end
    end
    if DataCenter.LWResourceLackManager:IsShowGoldSecondConfirmByLackResource(lackResourceTmp) then
      UIUtil.ShowMessage(Localization:GetString("diamond_lack_tips"), 2, GameDialogDefine.RESOURCE_LACK_FILL, GameDialogDefine.STILL_CONTINUE, function()
        if self.lackResource and table.count(self.lackResource) > 0 then
          local lackTab = {}
          for i, v in pairs(self.lackResource) do
            local param = {
              resType = v.resourceType,
              need = v.allCount
            }
            table.insert(lackTab, param)
          end
          LWResourceLackUtil:GotoResLack(lackTab)
        end
      end, function()
        ConfirmUseDiamond()
      end, nil, "diamond_lack_title")
      DataCenter.LWResourceLackManager:SetHasShownGoldSecondConfirmToday()
    else
      ConfirmUseDiamond()
    end
  end
end

function UILWScienceDetailView:ShowLack(careCanBuy)
  if table.count(self.lackResourceItem) > 0 then
    for _, v in ipairs(self.lackResourceItem) do
      LWResourceLackUtil:GotoResourceItemLack(v.resourceItemId, v.allCount)
      return true
    end
  elseif 0 < table.count(self.noBuyItem) then
    for _, v in ipairs(self.noBuyItem) do
      LWResourceLackUtil:GotoGoodsItemLack(v.itemId, v.allCount)
      return true
    end
  elseif careCanBuy then
    if 0 < table.count(self.lackResource) then
      local data = {}
      for _, v in ipairs(self.lackResource) do
        local param = {}
        param.resType = v.resourceType
        param.need = v.allCount
        table.insert(data, param)
      end
      LWResourceLackUtil:GotoResLack(data)
      return true
    end
    if 0 < table.count(self.lackItem) then
      for _, v in ipairs(self.lackItem) do
        LWResourceLackUtil:GotoGoodsItemLack(v.itemId, v.allCount)
        return true
      end
    end
  end
  return false
end

function UILWScienceDetailView:OnResearchBtnClick()
  if self.scienceResearchNewMsgLock then
    UIUtil.ShowTipsId(120289)
    return
  end
  local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.bUuid)
  if queue ~= nil then
    if self:ShowLack(true) then
      return
    end
    if queue:GetQueueState() == NewQueueState.Free then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.StartResearch, false)
      SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, {
        itemId = self.scienceId,
        useGold = ScienceResearchUseGold.NoUseGold,
        bUuid = queue.funcUuid
      })
      self.scienceResearchNewMsgLock = true
    else
      UIUtil.ShowTipsId(129107)
      self.ctrl:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWScienceDetail, {anim = true}, queue.itemId, self.bUuid)
    end
  end
end

function UILWScienceDetailView:OnSpeedUpBtnClick()
  if self.queue.itemId ~= nil then
    if self.queue:GetQueueState() == NewQueueState.Finish then
      DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(self.queue.funcUuid))
    elseif LuaEntry.Player:IsInAlliance() and self.queue.isHelped == 0 then
      SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp, self.queue.uuid, AllianceHelpType.Queue, NewQueueType.Science, self.queue.itemId)
      self.speedUpTitle:SetLocalText(SPEED_UP_TITLE)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
    end
  else
    UIUtil.ShowTipsId(129107)
  end
end

function UILWScienceDetailView:UpdateScienceSignal()
  self:RefreshContent()
end

function UILWScienceDetailView:UpdateItemSignal()
  if self.consumeResGo:GetActive() and self.hasItem then
    self:RefreshMid()
    self:ShowBtn()
  end
  if not (self.curLevel < self.maxLevel) or self.queue ~= nil and (self.queue:GetQueueState() == NewQueueState.Work or self.queue:GetQueueState() == NewQueueState.Finish) and tostring(self.scienceId) == self.queue.itemId then
  else
    self:CheckStudyNowBtnGrayState()
  end
end

function UILWScienceDetailView:UpdateGoldSignal()
  self:RefreshImmediatelyGold()
end

function UILWScienceDetailView:UpdateBuildDataSignal(uuid)
  self:RefreshContent()
end

function UILWScienceDetailView:UpdateResourceSignal()
  if self.consumeResGo:GetActive() then
    self:RefreshMid()
    self:ShowBtn()
    self:CheckStudyNowBtnGrayState()
  end
end

function UILWScienceDetailView:UpdateResourceItemSignal()
  if self.consumeResGo:GetActive() then
    self:RefreshMid()
    self:ShowBtn()
    self:CheckStudyNowBtnGrayState()
  end
end

function UILWScienceDetailView:OnScienceSearchingSignal()
  self:RefreshContent()
end

function UILWScienceDetailView:AllianceQueueHelpNewSignal()
  self:RefreshContent()
end

function UILWScienceDetailView:UnLockScienceResearchNewMsg()
  self.scienceResearchNewMsgLock = false
end

function UILWScienceDetailView:OnMainLvUp()
  self:GetReindeerRewardData(true)
end

local function OnScienceQueueFinish(self)
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UILWScienceDetailView:IsExistLackResNotGetWithDiamond()
  if not self.lackResource or #self.lackResource <= 0 then
    return false
  end
  for _, k in ipairs(self.lackResource) do
    local resType = k.resourceType
    local isHaveItemInBag = LWResourceLackUtil:IsExistLackResourceIteminBag(resType)
    if not LWResourceLackUtil:IsResourcePurchasableWithDiamonds(resType) and not isHaveItemInBag then
      return true
    end
  end
  return false
end

UILWScienceDetailView.OnScienceQueueFinish = OnScienceQueueFinish
return UILWScienceDetailView
