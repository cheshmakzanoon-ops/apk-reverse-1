local UICapacityBoxSelectNewView = BaseClass("UICapacityBoxSelectNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local string_GetFormattedStr2 = string.GetFormattedStr2
local UICapacityBoxSelectNewHeroComponent = require("UI.UICapacityBoxSelectNew.Component.UICapacityBoxSelectNewHeroComponent")
local UICapacityBoxSelectNewDecorationComponent = require("UI.UICapacityBoxSelectNew.Component.UICapacityBoxSelectNewDecorationComponent")
local UICapacityBoxSelectNewDominatorComponent = require("UI.UICapacityBoxSelectNew.Component.UICapacityBoxSelectNewDominatorComponent")
local UICapacityBoxSelectNewTitleComponent = require("UI/UICapacityBoxSelectNew/Component/UICapacityBoxSelectNewTitleComponent")
local UICapacityBoxItem = require("UI.UICapacityBoxSelectNew.Component.UICapacityBoxNewItem")
local normal_content_path = "ContentArea/Rect_ScrollView/Viewport/Content/normalContent"
local decoration_title_content_path = "ContentArea/Rect_ScrollView/Viewport/Content/decorationTitleContent"
local decoration_content_path = "ContentArea/Rect_ScrollView/Viewport/Content/decorationContent"
local hero_title_content_path = "ContentArea/Rect_ScrollView/Viewport/Content/heroTitleContent"
local hero_content_path = "ContentArea/Rect_ScrollView/Viewport/Content/heroContent"
local cellSizeX = 107
local cellSizeY = 109
local cellSpacingX = 31.3
local cellSpacingY = 19.7
local rowCount = 5
local cellAreaMinSizeY = 266

function UICapacityBoxSelectNewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UICapacityBoxSelectNewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectNewView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compMainContent = self:AddComponent(UIBaseContainer, "ContentArea")
  self.compContent = self:AddComponent(UIBaseContainer, "ContentArea/Rect_ScrollView/Viewport/Content")
  self.compContent:SetAnchoredPositionXY(0, 0)
  self.compBottomContent = self:AddComponent(UIBaseContainer, "ContentArea/BottomContent")
  self.compHeroInfoContent = self:AddComponent(UICapacityBoxSelectNewHeroComponent, "ContentArea/BottomContent/contentContainer/HeroInfoContent")
  self.compDecorationInfoContent = self:AddComponent(UICapacityBoxSelectNewDecorationComponent, "ContentArea/BottomContent/contentContainer/DecorationInfoContent")
  self.compSelectedUseArea = self:AddComponent(UIBaseContainer, "ContentArea/BottomContent/BtnArea/SelectedUseArea")
  self.compSelectedUseArea:SetActive(false)
  self.btnDec = self:AddComponent(UIButton, "ContentArea/BottomContent/BtnArea/SelectedUseArea/InfoInput/DecBtn")
  self.btnDec:SetOnClick(function()
    self:OnBtnDecClick()
  end)
  self.slider = self:AddComponent(UISlider, "ContentArea/BottomContent/BtnArea/SelectedUseArea/InfoInput/Slider")
  self.slider:SetOnValueChanged(function(value)
    if self.notChangeData then
      return
    end
    local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
    self:SetSelectCount(math.floor(value * haveCount), true)
  end)
  self.btnAdd = self:AddComponent(UIButton, "ContentArea/BottomContent/BtnArea/SelectedUseArea/InfoInput/AddBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.textCount = self:AddComponent(UIText, "ContentArea/BottomContent/BtnArea/SelectedUseArea/InfoInput/TextBg/CountText")
  self.compResTotalNumGroup = self:AddComponent(UIBaseContainer, "ContentArea/BottomContent/BtnArea/SelectedUseArea/InfoInput/TextBg/ResTotalNumGroup")
  self.textGotTotalNum = self:AddComponent(UIText, "ContentArea/BottomContent/BtnArea/SelectedUseArea/InfoInput/TextBg/ResTotalNumGroup/GotTotalNum")
  self.btnUse = self:AddComponent(UIButton, "ContentArea/BottomContent/BtnArea/Btn_Use")
  self.btnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  self.textTxtUse = self:AddComponent(UIText, "ContentArea/BottomContent/BtnArea/Btn_Use/Txt_Use")
  self.compSelectGo = self:AddComponent(UIBaseContainer, "SelectGo")
  self.compSelectGo:SetActive(false)
  self.compBg = self:AddComponent(UIBaseContainer, "ContentArea/BottomContent/bg")
  self.compBg:SetActive(false)
  self.btnQuickUse = self:AddComponent(UIButton, "ContentArea/BottomContent/BtnArea/Btn_Quick_Use")
  self.btnQuickUse:SetOnClick(function()
    self:OnBtnQuickUseClick()
  end)
  self.textTxtQuickUse = self:AddComponent(UIText, "ContentArea/BottomContent/BtnArea/Btn_Quick_Use/Txt_Quick_Use")
  self.textTxtQuickUse:SetText(Localization:GetString("optional_box_desc19"))
  self.compEmpty = self:AddComponent(UIBaseContainer, "ContentArea/BottomContent/BtnArea/Empty")
  self.compEmpty:SetActive(true)
  self.normal_content = self:AddComponent(UIBaseContainer, normal_content_path)
  self.decoration_title_content = self:AddComponent(UICapacityBoxSelectNewTitleComponent, decoration_title_content_path)
  self.decoration_content = self:AddComponent(UIBaseContainer, decoration_content_path)
  self.hero_title_content = self:AddComponent(UICapacityBoxSelectNewTitleComponent, hero_title_content_path)
  self.hero_content = self:AddComponent(UIBaseContainer, hero_content_path)
  self.awaken_title_content = self:AddComponent(UICapacityBoxSelectNewTitleComponent, "ContentArea/Rect_ScrollView/Viewport/Content/awakenTitleContent")
  self.awaken_content = self:AddComponent(UIBaseContainer, "ContentArea/Rect_ScrollView/Viewport/Content/awakenContent")
  self.bottom_content_container = self:AddComponent(UIBaseContainer, "ContentArea/BottomContent/contentContainer")
end

function UICapacityBoxSelectNewView:ComponentDestroy()
  self.compSelectGo.transform:SetParent(self.transform)
  self.compSelectGo:SetActive(false)
  self.compSelectGo = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compContent = nil
  self.compBottomContent = nil
  self.compHeroInfoContent = nil
  self.compDecorationInfoContent = nil
  self.btnDec = nil
  self.slider = nil
  self.btnAdd = nil
  self.textCount = nil
  self.compResTotalNumGroup = nil
  self.textGotTotalNum = nil
  self.btnUse = nil
  self.textTxtUse = nil
  self.compSelectedUseArea = nil
  self.compBg = nil
  self.compMainContent = nil
  self.btnQuickUse = nil
  self.textTxtQuickUse = nil
  self.compEmpty = nil
  self.normal_content = nil
  self.decoration_title_content = nil
  self.decoration_content = nil
  self.hero_title_content = nil
  self.hero_content = nil
  self.awaken_title_content = nil
  self.awaken_content = nil
  self.curShowComp = nil
end

function UICapacityBoxSelectNewView:DataDefine()
  local itemUuid, count, template, isNoCapacity, viewMode = self:GetUserData()
  self.itemUuid = itemUuid
  self.count = count
  self.template = template
  self.selectHeroId = 0
  self.selectIndex = 0
  self.selectOriginalIndex = nil
  self.selectItemId = 0
  self.isNoCapacity = isNoCapacity
  self.viewMode = viewMode
end

function UICapacityBoxSelectNewView:DataDestroy()
end

function UICapacityBoxSelectNewView:OnEnable()
  base.OnEnable(self)
  self:UpdateQuickUse()
  if self.curShowComp and self.selectItemId then
    self.curShowComp:ReInit(self.selectItemId)
  end
end

function UICapacityBoxSelectNewView:InitItems()
  self:ClearScroll()
  self.reqList = {}
  self.compList = {}
  local List = {}
  local decoartionTagNum = 0
  local heroTagNum = 0
  local awakenTagNum = 0
  if self.template.type == GOODS_TYPE.GOODS_TYPE_59 then
    List = string.split(self.template.para1, "|")
    if self.template.tipsType == 2 and self.template.popupType == GOODS_POPUP_TYPE.Decoration then
      List = self:SortDecoration(List)
    end
  end
  for i = 1, #List do
    local rawStr = type(List[i]) == "table" and List[i].str or List[i]
    local originalIndex = type(List[i]) == "table" and List[i].originalIndex or i
    local itemList = string.split(rawStr, ",")
    local tagType = CapacityBoxTagType.default
    local itemId = 0
    local itemNum = 0
    if #itemList == 2 then
      itemId = tonumber(itemList[1]) or 0
      itemNum = tonumber(itemList[2]) or 0
    elseif #itemList == 3 then
      tagType = tonumber(itemList[1]) or 0
      itemId = tonumber(itemList[2]) or 0
      itemNum = tonumber(itemList[3]) or 0
    end
    if tagType == CapacityBoxTagType.decoration then
      decoartionTagNum = decoartionTagNum + 1
    elseif tagType == CapacityBoxTagType.hero then
      heroTagNum = heroTagNum + 1
    elseif tagType == CapacityBoxTagType.HeroAwaken then
      awakenTagNum = awakenTagNum + 1
    end
    self.reqList[itemId] = self:GameObjectInstantiateAsync(UIAssets.UICapacityBoxNewItem, function(request)
      if request.isError then
        request:Destroy()
        return
      end
      local targetParent = self.normal_content
      if tagType == CapacityBoxTagType.decoration then
        targetParent = self.decoration_content
      elseif tagType == CapacityBoxTagType.hero then
        targetParent = self.hero_content
      elseif tagType == CapacityBoxTagType.HeroAwaken then
        targetParent = self.awaken_content
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(targetParent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = itemId
      local cell = targetParent:AddComponent(UICapacityBoxItem, go.name)
      local param = {}
      
      function param.callback(trans, index, itemId)
        self:OnSelectItem(trans, index, itemId)
      end
      
      param.count = self.selectCount * tonumber(itemNum)
      param.perCount = tonumber(itemNum)
      param.index = i
      param.originalIndex = originalIndex
      param.itemId = tonumber(itemId)
      param.rewardType = RewardType.GOODS
      cell:RefreshData(param, self.template)
      self.compList[i] = cell
    end)
  end
  self.decoration_title_content:SetActive(0 < decoartionTagNum)
  self.hero_title_content:SetActive(0 < heroTagNum)
  self.awaken_title_content:SetActive(0 < awakenTagNum)
  self.decoration_title_content:SetArrowClickCallback(function()
    if self.decoration_content then
      self.decoration_content:SetActive(not self.decoration_content:GetActive())
    end
  end)
  self.hero_title_content:SetArrowClickCallback(function()
    if self.hero_content then
      self.hero_content:SetActive(not self.hero_content:GetActive())
    end
  end)
  self.awaken_title_content:SetArrowClickCallback(function()
    if self.awaken_content then
      self.awaken_content:SetActive(not self.awaken_content:GetActive())
    end
  end)
end

function UICapacityBoxSelectNewView:OnOpen()
  self:InitItems()
  UIGray.SetGray(self.btnUse.transform, true, true)
  self.textTxtUse:SetLocalText(110046)
  self.textTitle:SetLocalText(self.template.name)
  local selectCount = self.count or 1
  local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
  if selectCount > haveCount then
    selectCount = haveCount
  end
  if selectCount <= 0 then
    selectCount = 1
  end
  self:SetSelectCount(selectCount)
  self.unitNum = nil
  self.compDecorationInfoContent:SetActive(false)
  self.compHeroInfoContent:SetActive(false)
  if self.compDominatorInfoContent then
    self.compDominatorInfoContent:SetActive(false)
  end
  self.btnQuickUse:SetActive(false)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBottomContent.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compMainContent.transform)
end

function UICapacityBoxSelectNewView:OnSelectItem(trans, index, itemId)
  self.compSelectGo.transform:SetParent(trans)
  self.compSelectGo.transform:Set_localPosition(0, 0, 0)
  self.compSelectGo.transform:Set_localScale(1, 1, 1)
  self.compSelectGo:SetActive(true)
  self.selectIndex = index
  self.selectItemId = itemId
  local cell = self.compList[index]
  self.selectOriginalIndex = cell and cell.param and cell.param.originalIndex and cell.param.originalIndex or index
  self.compSelectedUseArea:SetActive(true)
  self.compBg:SetActive(true)
  self.compEmpty:SetActive(false)
  local minSizeShowRow = math.ceil(cellAreaMinSizeY / (cellSizeY + cellSpacingY))
  local rowId = math.floor(index / rowCount)
  if minSizeShowRow > rowId then
    rowId = 0
  end
  UIGray.SetGray(self.btnUse.transform, false, true)
  self.unitNum = DataCenter.ItemTemplateManager:GetResGoodsUnitNum(itemId, index)
  if self.unitNum and 0 < self.unitNum then
    self.compResTotalNumGroup:SetActive(true)
    self.textGotTotalNum:SetText(string_GetFormattedStr2(self.unitNum * self.selectCount))
  else
    self.compResTotalNumGroup:SetActive(false)
  end
  self.curShowComp = nil
  if self.template.popupType == GOODS_POPUP_TYPE.Decoration then
    self.compHeroInfoContent:SetActive(false)
    self.compDecorationInfoContent:SetActive(true)
    if self.compDominatorInfoContent then
      self.compDominatorInfoContent:SetActive(false)
    end
    self.compDecorationInfoContent:ReInit(itemId)
    self.curShowComp = self.compDecorationInfoContent
  elseif self.template.popupType == GOODS_POPUP_TYPE.Hero then
    self.compDecorationInfoContent:SetActive(false)
    self.compHeroInfoContent:SetActive(true)
    if self.compDominatorInfoContent then
      self.compDominatorInfoContent:SetActive(false)
    end
    self.compHeroInfoContent:ReInit(itemId)
    self.curShowComp = self.compHeroInfoContent
  elseif self.template.popupType == GOODS_POPUP_TYPE.Dominator then
    self.compDecorationInfoContent:SetActive(false)
    self.compHeroInfoContent:SetActive(false)
    if not self.compDominatorInfoContent then
      self.compDominatorInfoContent = self:LoadComponentAsync(UICapacityBoxSelectNewDominatorComponent, UICapacityBoxSelectNewDominatorComponent.PrefabPath, self.bottom_content_container)
    end
    self.compDominatorInfoContent:SetActive(true)
    self.compDominatorInfoContent:ReInit(itemId)
    self.curShowComp = self.compDominatorInfoContent
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBottomContent.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compMainContent.transform)
  self:UpdateQuickUse()
end

function UICapacityBoxSelectNewView:GetDecorationSortKey(itemId)
  local baseBuildingId = self.ctrl:ItemIdToBuildingBaseId(itemId)
  if not baseBuildingId then
    return 2
  end
  local hasBuilding = DataCenter.BuildManager:HasBuilding(baseBuildingId, true)
  if not hasBuilding then
    local curCount = BuildingUtils.GetDecorateCountByLevel(baseBuildingId, 1)
    if curCount <= 0 then
      return 0
    end
  end
  if self.ctrl:IsDecorationUpgradeItemMax(baseBuildingId, itemId) then
    return 2
  end
  return 1
end

function UICapacityBoxSelectNewView:SortDecoration(list)
  if not list or #list == 0 then
    return list
  end
  
  local function parseItemId(str)
    local parts = string.split(str, ",")
    if #parts == 2 then
      return tonumber(parts[1]) or 0
    elseif #parts == 3 then
      return tonumber(parts[2]) or 0
    end
    return 0
  end
  
  local entries = {}
  for i = 1, #list do
    table.insert(entries, {
      str = list[i],
      originalIndex = i
    })
  end
  table.sort(entries, function(a, b)
    local keyA = self:GetDecorationSortKey(parseItemId(a.str))
    local keyB = self:GetDecorationSortKey(parseItemId(b.str))
    return keyA < keyB
  end)
  return entries
end

function UICapacityBoxSelectNewView:UpdateQuickUse()
  if self.selectItemId == nil or self.template == nil then
    return
  end
  local upgradeTotalCount = self.ctrl:GetQuickUseItemCount(self.template.id, self.selectItemId)
  local boxHaveCount = DataCenter.ItemData:GetItemCount(self.template.id)
  local upgradeCurCount = DataCenter.ItemData:GetItemCount(self.selectItemId)
  local needCount = upgradeTotalCount - upgradeCurCount
  self.btnQuickUse:SetActive(0 < upgradeTotalCount and 0 < needCount and boxHaveCount >= needCount)
end

function UICapacityBoxSelectNewView:ClearScroll()
  self.normal_content:RemoveComponents(UICapacityBoxItem)
  self.decoration_content:RemoveComponents(UICapacityBoxItem)
  self.hero_content:RemoveComponents(UICapacityBoxItem)
  if self.reqList then
    for k, v in pairs(self.reqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.compList = {}
end

function UICapacityBoxSelectNewView:OnUseItem()
  if self.template and self.itemUuid and self.selectCount and self.ctrl then
    local paramIndex = self.selectOriginalIndex ~= nil and self.selectOriginalIndex or self.selectIndex
    if paramIndex == 0 then
      return
    end
    self.ctrl:UseItem(self.template.type, self.itemUuid, self.selectCount, paramIndex)
  end
end

function UICapacityBoxSelectNewView:RefreshCellsCount()
  if self.compList and self.selectCount then
    for k, v in pairs(self.compList) do
      if v ~= nil then
        v:RefreshCount(self.selectCount)
      end
    end
  end
end

function UICapacityBoxSelectNewView:SetSelectCount(selectCount, exceptSlider)
  local haveCount = DataCenter.ItemData:GetItemCount(self.template.id)
  if selectCount > haveCount then
    selectCount = haveCount
  end
  if selectCount <= 0 then
    selectCount = 1
  end
  if selectCount == self.selectCount then
    return
  end
  self.selectCount = selectCount
  self.notChangeData = true
  self.textCount:SetText(self.selectCount)
  if self.unitNum then
    self.textGotTotalNum:SetText(string_GetFormattedStr2(self.unitNum * self.selectCount))
  else
    self.textGotTotalNum:SetText("")
  end
  if not exceptSlider then
    self.slider:SetValue(self.selectCount / haveCount)
  end
  self.notChangeData = false
  UIGray.SetGray(self.btnDec.transform, selectCount <= 1, true)
  UIGray.SetGray(self.btnAdd.transform, haveCount <= selectCount, true)
  self:RefreshCellsCount()
end

function UICapacityBoxSelectNewView:OnAddListener()
  base.OnAddListener(self)
end

function UICapacityBoxSelectNewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICapacityBoxSelectNewView:OnBtnPanelClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UICapacityBoxSelectNewView:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UICapacityBoxSelectNewView:OnBtnDecClick()
  if self.notChangeData then
    return
  end
  self:SetSelectCount(self.selectCount - 1)
end

function UICapacityBoxSelectNewView:OnBtnAddClick()
  if self.notChangeData then
    return
  end
  self:SetSelectCount(self.selectCount + 1)
end

function UICapacityBoxSelectNewView:OnBtnUseClick()
  local function ConfirmUseItem()
    self:OnUseItem()
  end
  
  local function DoUseItem(checkUpgradeCount)
    if self.ctrl then
      local haveCount = DataCenter.ItemData:GetItemCount(self.selectItemId)
      local quickUseCount = self.ctrl:GetQuickUseItemCount(self.template.id, self.selectItemId)
      if checkUpgradeCount and 0 < quickUseCount and quickUseCount < haveCount + self.selectCount then
        UIUtil.TryShowConfirm(TodayNoSecondConfirmType.CapacityBoxSelectNewOverQuickCount, Localization:GetString("optional_box_use_alert8", tostring(haveCount + self.selectCount), tostring(quickUseCount)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          ConfirmUseItem()
        end, function()
        end, nil, nil, false, nil, nil)
      else
        ConfirmUseItem()
      end
    end
  end
  
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.template == nil or self.selectItemId == nil or self.selectItemId <= 0 then
    local str = Localization:GetString("optional_box_use_alert7")
    UIUtil.ShowTips(str)
    return
  end
  if self.template.popupType == GOODS_POPUP_TYPE.Decoration then
    local baseBuildingId = self.view.ctrl:ItemIdToBuildingBaseId(self.selectItemId)
    if baseBuildingId then
      local baseBuildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
      if baseBuildTemplate then
        local showMaxConfirm = false
        local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
        if buildData and buildData.level >= baseBuildTemplate.max_level then
          showMaxConfirm = true
        end
        local isItemMax = self.ctrl:IsDecorationUpgradeItemMax(baseBuildingId, self.selectItemId)
        if isItemMax then
          showMaxConfirm = true
        end
        if showMaxConfirm then
          UIUtil.ShowMessage(Localization:GetString("optional_box_use_alert1", Localization:GetString(baseBuildTemplate.name), tostring(baseBuildTemplate.max_level)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            DoUseItem(true)
          end)
        else
          DoUseItem(true)
        end
      end
    else
      DoUseItem(true)
    end
  elseif self.template.popupType == GOODS_POPUP_TYPE.Hero then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.selectItemId)
    if itemTemplate then
      local heroId = self.view.ctrl:ItemIdToHeroId(self.selectItemId)
      if heroId then
        if itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 then
          local isWeaponUnlocked = false
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData and heroData:IsUniqueWeaponOpen() then
            isWeaponUnlocked = true
          end
          if not isWeaponUnlocked then
            UIUtil.ShowMessage(Localization:GetString("optional_box_use_alert6"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              DoUseItem(false)
            end)
          else
            local showSecondConfirm = false
            local tipText = ""
            if heroData:IsUniqueWeaponMaxLevel() then
              if heroData:IsUnlockedEnhanceUW() or heroData:CanUnlockEnhanceUW() then
                if self.view.ctrl:IsUWEnhanceItemMax(heroId, self.selectItemId, self.selectCount) then
                  showSecondConfirm = true
                  tipText = Localization:GetString("optional_box_use_alert2", heroData:GetName(), heroData:GetUniqueWeaponLv())
                end
              else
                showSecondConfirm = true
                tipText = Localization:GetString("optional_box_use_alert2", heroData:GetName(), heroData:GetUniqueWeaponLv())
              end
            elseif self.ctrl:IsUniqueWeaponUpgradeItemMax(heroId, self.selectItemId) then
              local maxWeaponLevelTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevelTemplate(heroId)
              if maxWeaponLevelTemplate and heroData then
                showSecondConfirm = true
                tipText = Localization:GetString("optional_box_use_alert2", heroData:GetName(), tostring(maxWeaponLevelTemplate.lv))
              end
            end
            if showSecondConfirm then
              UIUtil.ShowMessage(tipText, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                DoUseItem(true)
              end)
            else
              DoUseItem(true)
            end
          end
        elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
          local isRankMax = false
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            local curRank = heroData:GetRank()
            local maxRank = heroData.meta.maxRank
            isRankMax = curRank >= maxRank
          end
          if self.ctrl:IsHeroRankUpgradeItemMax(heroId, self.selectItemId, self.selectCount) then
            if heroData then
              UIUtil.ShowMessage(Localization:GetString("optional_box_use_alert3", heroData:GetName(), tostring(heroData.maxHonorLevel)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                DoUseItem(false)
              end)
            end
          elseif isRankMax then
            DoUseItem(false)
          else
            DoUseItem(true)
          end
        elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191 then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            local isAwakenMax = heroData:IsHeroAwakenReachMaxLevel()
            if isAwakenMax then
              UIUtil.ShowMessage(Localization:GetString("optional_box_open_tips", heroData:GetName()), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                DoUseItem(false)
              end)
            else
              DoUseItem(true)
            end
          else
            DoUseItem(false)
          end
        end
      else
        DoUseItem(true)
      end
    end
  elseif self.template.popupType == GOODS_POPUP_TYPE.Dominator then
    local dominatorId = self.view.ctrl:ItemIdToDominatorId(self.selectItemId)
    if dominatorId then
      local dominatorData = DataCenter.DominatorManager:GetInfoById(dominatorId)
      if dominatorData then
        local curRankTemplate = dominatorData:GetCurRankTemplate()
        if curRankTemplate then
          local isMaxRank = curRankTemplate:IsMaxRank()
          if isMaxRank then
            local itemName = DataCenter.ItemTemplateManager:GetName(self.selectItemId)
            UIUtil.ShowMessage(Localization:GetString("optional_box_use_alert_dominator", itemName, tostring(curRankTemplate:GetShowLevelText())), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              DoUseItem(true)
            end)
            return
          end
        end
      end
    end
    DoUseItem(true)
  else
    DoUseItem(true)
  end
end

function UICapacityBoxSelectNewView:OnBtnQuickUseClick()
  if self.selectItemId == nil or self.template == nil then
    return
  end
  local upgradeTotalCount = self.ctrl:GetQuickUseItemCount(self.template.id, self.selectItemId)
  local boxHaveCount = DataCenter.ItemData:GetItemCount(self.template.id)
  local upgradeCurCount = DataCenter.ItemData:GetItemCount(self.selectItemId)
  if boxHaveCount >= upgradeTotalCount - upgradeCurCount and 0 < upgradeTotalCount - upgradeCurCount then
    self:SetSelectCount(upgradeTotalCount - upgradeCurCount)
    local str = Localization:GetString("optional_box_use_alert4", upgradeTotalCount - upgradeCurCount)
    UIUtil.ShowTips(str)
  end
end

return UICapacityBoxSelectNewView
