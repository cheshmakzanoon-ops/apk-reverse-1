local UILWDominatorTrainMainUpgradeView = BaseClass("UILWDominatorTrainMainUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWDominatorMainAttributeItemComponent = require("UI/UILWDominator/Main/Component/AdvancePage/UILWDominatorMainAttributeItemComponent")
local UILWDominatorMainSmallAttributeItemComponent = require("UI/UILWDominator/Main/Component/AdvancePage/UILWDominatorMainSmallAttributeItemComponent")
local UILWDominatorTrainMainUpgradeComponent = require("UI/UILWDominator/Train/TrainUpgradeMain/Component/UILWDominatorTrainMainUpgradeComponent")

function UILWDominatorTrainMainUpgradeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorTrainMainUpgradeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainMainUpgradeView:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textTitle:SetLocalText("dominator_train_desc_1")
  self.compCurLevel = self:AddComponent(UIBaseContainer, "Content/TopContent/CurLevel")
  self.compNextIcon = self:AddComponent(UIBaseContainer, "Content/TopContent/NextIcon")
  self.compNextLevel = self:AddComponent(UIBaseContainer, "Content/TopContent/NextLevel")
  self.textInitLevel = self:AddComponent(UIText, "Content/TopContent/CurLevel/InitLevelText")
  self.textInitLevel:SetLocalText("dominator_train_rating_desc_6")
  self.compCurLevelIconRoot = self:AddComponent(UIBaseContainer, "Content/TopContent/CurLevel/CurLevelIconRoot")
  self.imgCurLevelIcon = self:AddComponent(UIImage, "Content/TopContent/CurLevel/CurLevelIconRoot/VFX_glow_left/Ef_ui_glow_quality_color_left/CurLevelIcon")
  self.textCurLevel = self:AddComponent(UIText, "Content/TopContent/CurLevel/CurLevelIconRoot/CurLevelText")
  self.compNextLevelIconRoot = self:AddComponent(UIBaseContainer, "Content/TopContent/NextLevel/NextLevelIconRoot")
  self.imgNextLevelIcon = self:AddComponent(UIImage, "Content/TopContent/NextLevel/NextLevelIconRoot/VFX_glow_right/Ef_ui_glow_quality_color_right/NextLevelIcon")
  self.textNextLevel = self:AddComponent(UIText, "Content/TopContent/NextLevel/NextLevelIconRoot/NextLevelText")
  self.compTmpLevelIconRoot = self:AddComponent(UIBaseContainer, "Content/TopContent/TmpLevel/TmpLevelIconRoot")
  self.imgIconColorTmp = self:AddComponent(UIImage, "Content/TopContent/TmpLevel/TmpLevelIconRoot/VFX_glow_tmp/Ef_ui_glow_quality_color_tmp/icon_color_tmp")
  self.imgBaseTmp = self:AddComponent(UIImage, "Content/TopContent/TmpLevel/TmpLevelIconRoot/VFX_glow_tmp/Ef_ui_glow_quality_color_tmp/base_tmp")
  self.imgTmpLevelIcon = self:AddComponent(UIImage, "Content/TopContent/TmpLevel/TmpLevelIconRoot/VFX_glow_tmp/Ef_ui_glow_quality_color_tmp/TmpLevelIcon")
  self.imgGlowTmp = self:AddComponent(UIImage, "Content/TopContent/TmpLevel/TmpLevelIconRoot/VFX_glow_tmp/Ef_ui_glow_quality_color_tmp/glow_tmp")
  self.textTmpLevel = self:AddComponent(UIText, "Content/TopContent/TmpLevel/TmpLevelIconRoot/TmpLevelText")
  self.compTopContent = self:AddComponent(UIBaseContainer, "Content/TopContent")
  self.compMaxContent = self:AddComponent(UIBaseContainer, "Content/MaxContent")
  self.imgIconColorMax = self:AddComponent(UIImage, "Content/MaxContent/MaxLevelIconRoot/VFX_glow_max/Ef_ui_glow_quality_color_max/icon_color_max")
  self.imgBaseMax = self:AddComponent(UIImage, "Content/MaxContent/MaxLevelIconRoot/VFX_glow_max/Ef_ui_glow_quality_color_max/base_max")
  self.imgMaxLevelIcon = self:AddComponent(UIImage, "Content/MaxContent/MaxLevelIconRoot/VFX_glow_max/Ef_ui_glow_quality_color_max/MaxLevelIcon")
  self.imgGlowMax = self:AddComponent(UIImage, "Content/MaxContent/MaxLevelIconRoot/VFX_glow_max/Ef_ui_glow_quality_color_max/glow_max")
  self.textMaxLevel = self:AddComponent(UIText, "Content/MaxContent/MaxLevelIconRoot/MaxLevelText")
  self.btnMainEffectInfo = self:AddComponent(UIButton, "Content/MainEffectContent/Layout/MainEffectInfoBtn")
  self.btnMainEffectInfo:SetOnClick(function()
    self:OnBtnMainEffectInfoClick()
  end)
  self.compContent = self:AddComponent(UIBaseContainer, "Content")
  self.textMainEffectTitle = self:AddComponent(UIText, "Content/MainEffectContent/Layout/MainEffectTitle")
  self.textMainEffectTitle:SetLocalText("dominator_train_rating_desc_7")
  self.compMainEffectLayout = self:AddComponent(UIBaseContainer, "Content/MainEffectContent/MainEffectLayout")
  self.textEffectTitle = self:AddComponent(UIText, "Content/OtherEffectContent/EffectTitle")
  self.textEffectTitle:SetLocalText("dominator_train_rating_desc_8")
  self.compEffectContent = self:AddComponent(UIBaseContainer, "Content/OtherEffectContent/EffectContent")
  self.textRequireTitle = self:AddComponent(UIText, "Content/RequireContent/RequireTitle")
  self.textRequireTitle:SetLocalText("dominator_train_rating_desc_5")
  self.compRequireContent = self:AddComponent(UIBaseContainer, "Content/RequireContent/RequireContent")
  self.imgIconColorLeft = self:AddComponent(UIImage, "Content/TopContent/CurLevel/CurLevelIconRoot/VFX_glow_left/Ef_ui_glow_quality_color_left/icon_color_left")
  self.imgIconColorRight = self:AddComponent(UIImage, "Content/TopContent/NextLevel/NextLevelIconRoot/VFX_glow_right/Ef_ui_glow_quality_color_right/icon_color_right")
  self.imgBaseLeft = self:AddComponent(UIImage, "Content/TopContent/CurLevel/CurLevelIconRoot/VFX_glow_left/Ef_ui_glow_quality_color_left/base_left")
  self.imgGlowLeft = self:AddComponent(UIImage, "Content/TopContent/CurLevel/CurLevelIconRoot/VFX_glow_left/Ef_ui_glow_quality_color_left/glow_left")
  self.imgBaseRight = self:AddComponent(UIImage, "Content/TopContent/NextLevel/NextLevelIconRoot/VFX_glow_right/Ef_ui_glow_quality_color_right/base_right")
  self.imgGlowRight = self:AddComponent(UIImage, "Content/TopContent/NextLevel/NextLevelIconRoot/VFX_glow_right/Ef_ui_glow_quality_color_right/glow_right")
  self.btnUpgrade = self:AddComponent(UIButton, "UpgradeBtn")
  self.btnUpgrade:SetSafeClickMode(true)
  self.btnUpgrade:SetSafeClickModeTime(1)
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.btnUpgrade:SetSafeClickMode(true)
  self.textMax = self:AddComponent(UIText, "MaxText")
  self.textMax:SetText(Localization:GetString("dominator_star_desc_1"))
  self.textUpgradeBtn = self:AddComponent(UIText, "UpgradeBtn/Btn/UpgradeBtnText")
  self.textUpgradeBtn:SetLocalText("dominator_train_button_1")
  self.compCost1 = self:AddComponent(UIBaseContainer, "CostLayout/Cost1")
  self.imgCostIcon1 = self:AddComponent(UIImage, "CostLayout/Cost1/CostIcon1")
  self.textCostText1 = self:AddComponent(UIText, "CostLayout/Cost1/CostText1")
  self.compCost2 = self:AddComponent(UIBaseContainer, "CostLayout/Cost2")
  self.imgCostIcon2 = self:AddComponent(UIImage, "CostLayout/Cost2/CostIcon2")
  self.textCostText2 = self:AddComponent(UIText, "CostLayout/Cost2/CostText2")
  self.compCost3 = self:AddComponent(UIBaseContainer, "CostLayout/Cost3")
  self.imgCostIcon3 = self:AddComponent(UIImage, "CostLayout/Cost3/CostIcon3")
  self.textCostText3 = self:AddComponent(UIText, "CostLayout/Cost3/CostText3")
  self.btnClose = self:AddComponent(UIButton, "CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compRedPointUpgrade = self:AddComponent(UIBaseContainer, "UpgradeBtn/RedPointUpgrade")
  self.btnPreview = self:AddComponent(UIButton, "PreviewBtn")
  self.btnPreview:SetOnClick(function()
    self:OnBtnPreviewClick()
  end)
end

function UILWDominatorTrainMainUpgradeView:ComponentDestroy()
  self.animator = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.textInitLevel = nil
  self.imgCurLevelIcon = nil
  self.imgNextLevelIcon = nil
  self.compTmpLevelIconRoot = nil
  self.imgIconColorTmp = nil
  self.imgBaseTmp = nil
  self.imgTmpLevelIcon = nil
  self.imgGlowTmp = nil
  self.textTmpLevel = nil
  self.compContent = nil
  self.textMainEffectTitle = nil
  self.btnMainEffectInfo = nil
  self.compMainEffectLayout = nil
  self.textEffectTitle = nil
  self.compEffectContent = nil
  self.textRequireTitle = nil
  self.compRequireContent = nil
  self.imgIconColorLeft = nil
  self.imgIconColorRight = nil
  self.imgBaseLeft = nil
  self.imgGlowLeft = nil
  self.imgBaseRight = nil
  self.imgGlowRight = nil
  self.compTopContent = nil
  self.compMaxContent = nil
  self.imgIconColorMax = nil
  self.imgBaseMax = nil
  self.imgMaxLevelIcon = nil
  self.imgGlowMax = nil
  self.textMaxLevel = nil
  self.btnUpgrade = nil
  self.textUpgradeBtn = nil
  self.compCost1 = nil
  self.imgCostIcon1 = nil
  self.textCostText1 = nil
  self.compCost2 = nil
  self.imgCostIcon2 = nil
  self.textCostText2 = nil
  self.compCost3 = nil
  self.imgCostIcon3 = nil
  self.textCostText3 = nil
  self.btnClose = nil
  self.compRedPointUpgrade = nil
  self.compCurLevelIconRoot = nil
  self.compNextLevelIconRoot = nil
  self.textCurLevel = nil
  self.textNextLevel = nil
  self.textMax = nil
  self.btnPreview = nil
end

function UILWDominatorTrainMainUpgradeView:DataDefine()
  self.isClosing = false
  self.normalEffectItems = {}
  self.normalEffectItemsReqs = {}
  self.mainEffectItems = {}
  self.mainEffectItemsReqs = {}
  self.requireItem = nil
  self.requireItemReq = nil
end

function UILWDominatorTrainMainUpgradeView:DataDestroy()
  self.isClosing = nil
  self.normalEffectItems = nil
  self.normalEffectItemsReqs = nil
  self.mainEffectItems = nil
  self.mainEffectItemsReqs = nil
  self.requireItem = nil
  self.requireItemReq = nil
  if self.closeTimer ~= nil then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  if self.delayOpenSuccessTimer then
    self.delayOpenSuccessTimer:Stop()
    self.delayOpenSuccessTimer = nil
  end
end

function UILWDominatorTrainMainUpgradeView:OnOpen()
  self.groupTemplate = DataCenter.DominatorTemplateManager:GetMainTrainGroupTemplate()
  if self.groupTemplate == nil then
    return
  end
  self.info = DataCenter.DominatorManager:GetTrainInfoByGroupId(self.groupTemplate.id)
  if self.info == nil then
    return
  end
  self:UpdateAll(true, false)
  self.animator:Play("V_ui_UILWDominatorTrainMainUpgrade_in")
end

function UILWDominatorTrainMainUpgradeView:UpdateInfo()
  if self.groupTemplate == nil or self.info == nil then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  local isMax = curLevelTemplate:IsMaxLevel()
  self.compMaxContent:SetActive(isMax)
  self.compTopContent:SetActive(not isMax)
  if isMax then
    self.imgMaxLevelIcon:LoadSprite(curLevelTemplate:GetNumberIconPath())
    self.textMaxLevel:SetText(curLevelTemplate:GetColoredName(false))
    local ret, r, g, b, a = curLevelTemplate:GetQualityImageColorRGBA()
    if ret then
      self.imgBaseMax:SetColorRGBA255(r, g, b, a)
      self.imgIconColorMax:SetColorRGBA255(r, g, b, a)
      self.imgGlowMax:SetColorRGBA255(r, g, b, a)
    end
  else
    local isInit = curLevelTemplate.level_order == 0
    self.textInitLevel:SetActive(isInit)
    self.compCurLevelIconRoot:SetActive(not isInit)
    if not isInit then
      self.imgCurLevelIcon:LoadSprite(curLevelTemplate:GetNumberIconPath())
      self.textCurLevel:SetText(curLevelTemplate:GetColoredName(false))
      local ret, r, g, b, a = curLevelTemplate:GetQualityImageColorRGBA()
      if ret then
        self.imgBaseLeft:SetColorRGBA255(r, g, b, a)
        self.imgIconColorLeft:SetColorRGBA255(r, g, b, a)
        self.imgGlowLeft:SetColorRGBA255(r, g, b, a)
      end
    end
    self.compNextIcon:SetActive(not isMax)
    self.compNextLevel:SetActive(not isMax)
    if not isMax then
      local nextLevelTemplate = curLevelTemplate:GetNextLevelTemplate()
      if nextLevelTemplate then
        self.imgNextLevelIcon:LoadSprite(nextLevelTemplate:GetNumberIconPath())
        self.textNextLevel:SetText(nextLevelTemplate:GetColoredName(false))
        local ret, r, g, b, a = nextLevelTemplate:GetQualityImageColorRGBA()
        if ret then
          self.imgBaseRight:SetColorRGBA255(r, g, b, a)
          self.imgIconColorRight:SetColorRGBA255(r, g, b, a)
          self.imgGlowRight:SetColorRGBA255(r, g, b, a)
        end
      end
    end
    local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
    if isMirror then
      self.compCurLevel.rectTransform:Set_anchoredPosition(170, 0)
      self.compNextLevel.rectTransform:Set_anchoredPosition(-170, 0)
    else
      self.compCurLevel.rectTransform:Set_anchoredPosition(-170, 0)
      self.compNextLevel.rectTransform:Set_anchoredPosition(170, 0)
    end
  end
end

function UILWDominatorTrainMainUpgradeView:UpdateMainEffectContent(isFromInit, isBigLevelChanged)
  local function GetAnimDelayTime()
    if isBigLevelChanged then
      return 1.36
    else
      return 0.33
    end
  end
  
  if self.groupTemplate == nil or self.info == nil then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  local showEffects = self.ctrl:GetMainShowEffects(curLevelTemplate)
  local num = 1
  local delayEffectTime = GetAnimDelayTime()
  for _, v in ipairs(showEffects) do
    local index = num
    if self.mainEffectItems[index] == nil and self.mainEffectItemsReqs[index] == nil then
      local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainAttributeItemSmall.prefab")
      loadRequest:completed("+", function()
        if not IsNull(loadRequest.gameObject) and self.compMainEffectLayout then
          local pageObj = loadRequest.gameObject
          local transform = pageObj.transform
          transform:SetParent(self.compMainEffectLayout.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          pageObj.name = "mainEffectItem" .. index
          local item = self:AddComponent(UILWDominatorMainSmallAttributeItemComponent, pageObj)
          item:SetActive(true)
          item:ReInit(v, isFromInit)
          if not isFromInit then
            item:PlayEffect(delayEffectTime)
          end
          self.mainEffectItems[index] = item
        end
      end)
      self.mainEffectItemsReqs[index] = loadRequest
    elseif self.mainEffectItems[index] ~= nil then
      self.mainEffectItems[index]:SetActive(true)
      self.mainEffectItems[index]:ReInit(v, isFromInit)
      if not isFromInit then
        self.mainEffectItems[index]:PlayEffect(delayEffectTime)
      end
    end
    num = num + 1
  end
  for i, v in pairs(self.mainEffectItems) do
    if i > num then
      v:SetActive(false)
    end
  end
end

function UILWDominatorTrainMainUpgradeView:UpdateNormalEffectContent(isFromInit, isBigLevelChanged)
  local function GetAnimDelayTimeParam()
    if isBigLevelChanged then
      return 1.4, 0.03
    else
      return 0.38, 0.03
    end
  end
  
  if self.groupTemplate == nil or self.info == nil then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  local showEffects = self.ctrl:GetNormalShowEffects(curLevelTemplate)
  if table.IsNullOrEmpty(showEffects) then
    self.textEffectTitle:SetActive(false)
    self.compEffectContent:SetActive(false)
  else
    self.textEffectTitle:SetActive(true)
    self.compEffectContent:SetActive(true)
    local num = 1
    local delayTime, delayTimeDelta = GetAnimDelayTimeParam()
    for i, v in ipairs(showEffects) do
      local index = num
      if self.normalEffectItems[index] == nil and self.normalEffectItemsReqs[index] == nil then
        local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainAttributeItem.prefab")
        loadRequest:completed("+", function()
          if not IsNull(loadRequest.gameObject) and not IsNull(self.compEffectContent) then
            local pageObj = loadRequest.gameObject
            local transform = pageObj.transform
            transform:SetParent(self.compEffectContent.transform)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            pageObj.name = "effectItem" .. index
            local item = self:AddComponent(UILWDominatorMainAttributeItemComponent, pageObj)
            item:SetActive(true)
            item:ReInit(v, isFromInit)
            item:SetBgActive(index % 2 == 0)
            item:SetColorRGBA255(17, 26, 63, 83)
            item:SetSizeDeltaXY(640, 60)
            self.normalEffectItems[index] = item
            if not isFromInit then
              item:PlayEffect(delayTime)
            end
            delayTime = delayTime + delayTimeDelta
          end
        end)
        self.normalEffectItemsReqs[index] = loadRequest
      elseif self.normalEffectItems[index] ~= nil then
        self.normalEffectItems[index]:SetActive(true)
        self.normalEffectItems[index]:ReInit(v, isFromInit)
        self.normalEffectItems[index]:SetBgActive(index % 2 == 0)
        self.normalEffectItems[index]:SetColorRGBA255(17, 26, 63, 83)
        self.normalEffectItems[index]:SetSizeDeltaXY(640, 60)
        if not isFromInit then
          self.normalEffectItems[index]:PlayEffect(delayTime)
        end
        delayTime = delayTime + delayTimeDelta
      end
      num = num + 1
    end
    for i, v in pairs(self.normalEffectItems) do
      if i > num then
        v:SetActive(false)
      end
    end
  end
end

function UILWDominatorTrainMainUpgradeView:UpdateRequireContent()
  if self.groupTemplate == nil or self.info == nil then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  local requires = curLevelTemplate:GetUpgradeRequireIdList()
  local showLevelRequire = not table.IsNullOrEmpty(requires)
  self.textRequireTitle:SetActive(showLevelRequire)
  self.compRequireContent:SetActive(showLevelRequire)
  if showLevelRequire then
    if self.requireItem == nil and self.requireItemReq == nil then
      local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorTrainRequireItem.prefab")
      loadRequest:completed("+", function()
        if not IsNull(loadRequest.gameObject) and not IsNull(self.compRequireContent) then
          local pageObj = loadRequest.gameObject
          local transform = pageObj.transform
          transform:SetParent(self.compRequireContent.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          pageObj.name = "requireItem"
          local item = self:AddComponent(UILWDominatorTrainMainUpgradeComponent, pageObj)
          item:SetActive(true)
          item:ReInit(curLevelTemplate)
          item:SetBgActive(true)
          item:SetColorRGBA255(17, 26, 63, 83)
          self.requireItem = item
        end
      end)
      self.requireItemReq = loadRequest
    elseif self.requireItem ~= nil then
      self.requireItem:SetActive(true)
      self.requireItem:ReInit(curLevelTemplate)
      self.requireItem:SetBgActive(true)
      self.requireItem:SetColorRGBA255(17, 26, 63, 83)
    end
  end
end

function UILWDominatorTrainMainUpgradeView:UpdateCost()
  if self.groupTemplate == nil or self.info == nil then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  local isMax = curLevelTemplate:IsMaxLevel()
  self.btnUpgrade:SetActive(not isMax)
  self.compCost1:SetActive(not isMax)
  self.compCost2:SetActive(not isMax)
  self.compCost3:SetActive(not isMax)
  self.textMax:SetActive(isMax)
  if not isMax then
    local costInfo = curLevelTemplate:GetUpgradeCostInfo()
    self.compCost1:SetActive(costInfo[1] ~= nil)
    if costInfo[1] ~= nil then
      local icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costInfo[1].itemId)
      self.imgCostIcon1:LoadSprite(icon)
      local haveCount = DataCenter.ItemData:GetItemCount(costInfo[1].itemId)
      if haveCount >= costInfo[1].count then
        self.textCostText1:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, costInfo[1].count))
      else
        self.textCostText1:SetText(string.format("<color=#F97077>%d</color>/%d", haveCount, costInfo[1].count))
      end
    end
    self.compCost2:SetActive(costInfo[2] ~= nil)
    if costInfo[2] ~= nil then
      local icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costInfo[2].itemId)
      self.imgCostIcon2:LoadSprite(icon)
      local haveCount = DataCenter.ItemData:GetItemCount(costInfo[2].itemId)
      if haveCount >= costInfo[2].count then
        self.textCostText2:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, costInfo[2].count))
      else
        self.textCostText2:SetText(string.format("<color=#F97077>%d</color>/%d", haveCount, costInfo[2].count))
      end
    end
    self.compCost3:SetActive(costInfo[3] ~= nil)
    if costInfo[3] ~= nil then
      local icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costInfo[3].itemId)
      self.imgCostIcon3:LoadSprite(icon)
      local haveCount = DataCenter.ItemData:GetItemCount(costInfo[3].itemId)
      if haveCount >= costInfo[3].count then
        self.textCostText3:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, costInfo[3].count))
      else
        self.textCostText3:SetText(string.format("<color=#F97077>%d</color>/%d", haveCount, costInfo[3].count))
      end
    end
    self.compRedPointUpgrade:SetActive(self.info:IsCanUpgrade())
  end
end

function UILWDominatorTrainMainUpgradeView:OnRefreshItems()
  self:UpdateCost()
end

function UILWDominatorTrainMainUpgradeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorTrainUpgradeSuccess, self.OnTrainUpgrade)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

function UILWDominatorTrainMainUpgradeView:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorTrainUpgradeSuccess, self.OnTrainUpgrade)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

function UILWDominatorTrainMainUpgradeView:UpdateAll(isFromInit, isBigLevelChanged)
  self:UpdateInfo()
  self:UpdateMainEffectContent(isFromInit, isBigLevelChanged)
  self:UpdateNormalEffectContent(isFromInit, isBigLevelChanged)
  self:UpdateRequireContent()
  self:UpdateCost()
end

function UILWDominatorTrainMainUpgradeView:OnTrainUpgrade(evtData)
  local function UpdateTmpLevelIcon(template)
    self.imgTmpLevelIcon:LoadSprite(template:GetNumberIconPath())
    
    self.textTmpLevel:SetText(template:GetColoredName(false))
    local ret, r, g, b, a = template:GetQualityImageColorRGBA()
    if ret then
      self.imgBaseTmp:SetColorRGBA255(r, g, b, a)
      self.imgIconColorTmp:SetColorRGBA255(r, g, b, a)
      self.imgGlowTmp:SetColorRGBA255(r, g, b, a)
    end
  end
  
  if evtData then
    local preTrainTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(evtData.groupId + evtData.preTrainLevel)
    local curTrainTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(evtData.groupId + evtData.curTrainLevel)
    if not preTrainTemplate or not curTrainTemplate then
      return
    end
    local isBigLevelChanged = preTrainTemplate.grade_order ~= curTrainTemplate.grade_order
    local playVfx = not CommonUtil.IsArabicAutoMirrorOpen()
    if isBigLevelChanged then
      if playVfx then
        local isMax = curTrainTemplate:IsMaxLevel()
        if not isMax then
          local nextLevelTemplate = curTrainTemplate:GetNextLevelTemplate()
          if nextLevelTemplate then
            UpdateTmpLevelIcon(nextLevelTemplate)
          end
        end
        local ret, time = self.animator:PlayAnimationReturnTime("V_ui_UILWDominatorTrainMainUpgrade_upgrade_lvup")
        if ret then
          if self.delayOpenSuccessTimer then
            self.delayOpenSuccessTimer:Stop()
            self.delayOpenSuccessTimer = nil
          end
          local param = {preTrainTemplate = preTrainTemplate, curTrainTemplate = curTrainTemplate}
          self.delayOpenSuccessTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.animator:Play("V_ui_UILWDominatorTrainMainUpgrade_upgrade_lvup_reset")
            self:UpdateAll(false, isBigLevelChanged)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorTrainUpgradeMainSuccess, {anim = true}, param)
          end, time)
        end
      else
        self:UpdateAll(false, isBigLevelChanged)
        local param = {preTrainTemplate = preTrainTemplate, curTrainTemplate = curTrainTemplate}
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorTrainUpgradeMainSuccess, {anim = true}, param)
      end
    else
      if playVfx then
        self.animator:Play("V_ui_UILWDominatorTrainMainUpgrade_upgrade")
      end
      self:UpdateAll(false, isBigLevelChanged)
    end
  end
end

function UILWDominatorTrainMainUpgradeView:OnBtnPanelClick()
  self:Close()
end

function UILWDominatorTrainMainUpgradeView:OnBtnUpgradeClick()
  if not self.info then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  if curLevelTemplate:IsMaxLevel() then
    return
  end
  if not curLevelTemplate:IsRequireOK() then
    UIUtil.ShowTipsId("dominator_toast_1")
    return
  end
  local costInfo = curLevelTemplate:GetUpgradeCostInfo()
  for i, v in pairs(costInfo) do
    local haveCount = DataCenter.ItemData:GetItemCount(v.itemId)
    if haveCount < v.count then
      LWResourceLackUtil:GotoGoodsItemLack(v.itemId, v.count)
      return
    end
  end
  DataCenter.DominatorManager:SendTrainUpgradeMessage(self.info.groupId)
end

function UILWDominatorTrainMainUpgradeView:OnBtnCloseClick()
  self:Close()
end

function UILWDominatorTrainMainUpgradeView:Close()
  if self.isClosing then
    return
  end
  self.isClosing = true
  local ret, time = self.animator:PlayAnimationReturnTime("V_ui_UILWDominatorTrainMainUpgrade_out")
  if ret then
    if self.closeTimer then
      self.closeTimer:Stop()
      self.closeTimer = nil
    end
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, self, true, false, false)
    self.closeTimer:Start()
  elseif self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UILWDominatorTrainMainUpgradeView:OnBtnMainEffectInfoClick()
  UIUtil.ShowTips(Localization:GetString("dominator_train_rating_desc_12"))
end

function UILWDominatorTrainMainUpgradeView:OnBtnPreviewClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorTrainPreview, {anim = true})
end

return UILWDominatorTrainMainUpgradeView
