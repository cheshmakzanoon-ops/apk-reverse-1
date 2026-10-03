local base = require("UI/UILWDominator/Main/Component/UILWDominatorMainPageBaseComponent")
local UILWDominatorMainTrainPageComponent = BaseClass("UILWDominatorMainTrainPageComponent", base)
local Localization = CS.GameEntry.Localization
local UILWDominatorMainTrainGroupItemComponent = require("UI/UILWDominator/Main/Component/TrainPage/UILWDominatorMainTrainGroupItemComponent")
local UILWDominatorMainTrainDetailComponent = require("UI/UILWDominator/Main/Component/TrainPage/UILWDominatorMainTrainDetailComponent")
local Const = require("DataCenter/Dominator/Train/DominatorTrainSceneConstant")

function UILWDominatorMainTrainPageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainTrainPageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainTrainPageComponent:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.textBottomTips = self:AddComponent(UIText, "GroupContent/BottomTipsText")
  self.textBottomTips:SetText(Localization:GetString("dominator_train_desc_4"))
  self.textGroupTitle = self:AddComponent(UIText, "GroupContent/GroupTitleText")
  self.textGroupTitle:SetText(Localization:GetString("dominator_train_desc_2"))
  self.compGroupLayout = self:AddComponent(UIBaseContainer, "GroupContent/GroupLayout")
  self.compUpgradeGuidePos = self:AddComponent(UIBaseContainer, "GroupContent/UpgradeGuidePos")
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textTitle:SetText(Localization:GetString("dominator_train_desc_1"))
  self.compEfUiGlowQualityColor = self:AddComponent(UIBaseContainer, "InfoContent/Ef_ui_glow_quality_color")
  self.imgCurLevelIcon = self:AddComponent(UIImage, "InfoContent/Ef_ui_glow_quality_color/CurLevelIcon")
  self.imgIconColor = self:AddComponent(UIImage, "InfoContent/Ef_ui_glow_quality_color/icon_color")
  self.imgBase = self:AddComponent(UIImage, "InfoContent/Ef_ui_glow_quality_color/base")
  self.imgGlow = self:AddComponent(UIImage, "InfoContent/Ef_ui_glow_quality_color/glow")
  self.textLevel = self:AddComponent(UIText, "InfoContent/LevelText")
  self.textInit = self:AddComponent(UIText, "InfoContent/InitText")
  self.textLevelTips = self:AddComponent(UIText, "InfoContent/LevelTipsText")
  self.textMaxLevel = self:AddComponent(UIText, "InfoContent/LevelMaxText")
  self.textMaxLevel:SetText(Localization:GetString("dominator_star_desc_1"))
  self.textPowerNumber = self:AddComponent(UIText, "InfoContent/PowerLayout/PowerNumberText")
  self.btnUpgrade = self:AddComponent(UIButton, "InfoContent/UpgradeBtn")
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.textUpgrade = self:AddComponent(UIText, "InfoContent/UpgradeBtn/Btn/UpgradeText")
  self.textUpgrade:SetText(Localization:GetString("dominator_train_button_1"))
  self.compRedUpgrade = self:AddComponent(UIBaseContainer, "InfoContent/UpgradeBtn/RedUpgrade")
  self.btnInfo = self:AddComponent(UIButton, "InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compDetail = self:AddComponent(UILWDominatorMainTrainDetailComponent, "GroupItemDetailContent")
  self.imgModelViewer = self:AddComponent(UIRawImage, "BannerMask/Banner")
  self.items = nil
  self.itemReqs = nil
end

function UILWDominatorMainTrainPageComponent:ComponentDestroy()
  self.animator = nil
  self.textBottomTips = nil
  self.textGroupTitle = nil
  self.compGroupLayout = nil
  self.compUpgradeGuidePos = nil
  self.textTitle = nil
  self.compEfUiGlowQualityColor = nil
  self.imgCurLevelIcon = nil
  self.imgIconColor = nil
  self.imgBase = nil
  self.imgGlow = nil
  self.textLevel = nil
  self.textInit = nil
  self.textLevelTips = nil
  self.btnUpgrade = nil
  self.textUpgrade = nil
  self.textMaxLevel = nil
  self.textPowerNumber = nil
  self.compRedUpgrade = nil
  self.compDetail = nil
  self.imgModelViewer = nil
  self.items = nil
  self.itemReqs = nil
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
end

function UILWDominatorMainTrainPageComponent:DataDefine()
  self.curSelectTrainGroupId = nil
  self.isShowingDetail = false
end

function UILWDominatorMainTrainPageComponent:DataDestroy()
  self.curSelectTrainGroupId = nil
  self.isShowingDetail = nil
  if self.delayShowFingerTimer then
    self.delayShowFingerTimer:Stop()
    self.delayShowFingerTimer = nil
  end
  if self.delayDestroyFingerTimer then
    self.delayDestroyFingerTimer:Stop()
    self.delayDestroyFingerTimer = nil
  end
end

function UILWDominatorMainTrainPageComponent:OnEnable()
  base.OnEnable(self)
end

function UILWDominatorMainTrainPageComponent:OnDisable()
  base.OnDisable(self)
end

function UILWDominatorMainTrainPageComponent:OnClosePage()
  base.OnClosePage(self)
  self:DestroyScene()
end

function UILWDominatorMainTrainPageComponent:ReInit()
  self.mainGroupTemplate = DataCenter.DominatorTemplateManager:GetMainTrainGroupTemplate()
  if self.mainGroupTemplate == nil then
    return
  end
  self.mainInfo = DataCenter.DominatorManager:GetTrainInfoByGroupId(self.mainGroupTemplate.id)
  if self.mainInfo == nil then
    return
  end
  self.curSelectTrainGroupId = nil
  self.isShowingDetail = false
  self:UpdateMain()
  self:UpdateNormalGroup(true)
  self:UpdatePower()
  self:HideDetail()
  if self.delayShowFingerTimer then
    self.delayShowFingerTimer:Stop()
    self.delayShowFingerTimer = nil
  end
  self.delayShowFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:TryShowUpgradeGuide()
  end, 0.5)
  self:InitScene()
end

function UILWDominatorMainTrainPageComponent:InitScene()
  local param = {}
  param.uuidList = {}
  local allInfo = DataCenter.DominatorManager:GetAllInfo()
  if allInfo then
    for i, v in pairs(allInfo) do
      if v:IsShowInTrainScene() then
        table.insert(param.uuidList, v.uuid)
      end
    end
  end
  table.sort(param.uuidList, function(a, b)
    local infoA = DataCenter.DominatorManager:GetInfoByUuid(a)
    local infoB = DataCenter.DominatorManager:GetInfoByUuid(b)
    if infoA and infoB then
      return infoA.dominatorId < infoB.dominatorId
    end
    return false
  end)
  param.renderTexture = self.imgModelViewer
  local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
  local parentWidth = uiContainerRect.sizeDelta.x
  local parentHeight = uiContainerRect.sizeDelta.y
  if Config.IsPC() then
    parentWidth = DefaultScreenWidth
    parentHeight = DefaultScreenHeight
  end
  param.rtWidth = math.floor(parentWidth - 56)
  param.rtHeight = math.floor(parentHeight - 224)
  DataCenter.DominatorTrainSceneManager:Enter(param)
end

function UILWDominatorMainTrainPageComponent:DestroyScene()
  DataCenter.DominatorTrainSceneManager:Destroy()
end

function UILWDominatorMainTrainPageComponent:UpdatePower()
  local info = self.view:GetCurShowInfo()
  if info then
    self.textPowerNumber:SetText(tostring(info:GetPower()))
  end
end

function UILWDominatorMainTrainPageComponent:TryShowUpgradeGuide()
  if not DataCenter.DominatorGuideManager:IsHasShownTrainUpgradeGuide() then
    self.clickFingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    self.clickFingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Normal.Name).transform, false)
      if self.compUpgradeGuidePos then
        transform.position = self.compUpgradeGuidePos.transform.position
      end
      self.delayDestroyFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.clickFingerHandle then
          self.clickFingerHandle:Destroy()
          self.clickFingerHandle = nil
        end
      end, 2)
    end)
    DataCenter.DominatorGuideManager:SetHasShownTrainUpgradeGuide()
  end
end

function UILWDominatorMainTrainPageComponent:UpdateMain()
  if self.mainGroupTemplate == nil or self.mainInfo == nil then
    return
  end
  local levelTemplate = self.mainInfo:GetCurLevelTemplate()
  if not levelTemplate then
    return
  end
  local isMax = levelTemplate:IsMaxLevel()
  local isInit = levelTemplate.level_order == 0
  self.textLevelTips:SetActive(not isMax and not self.isShowingDetail)
  self.textMaxLevel:SetActive(isMax and not self.isShowingDetail)
  self.compEfUiGlowQualityColor:SetActive(not isInit)
  self.textLevel:SetActive(not isInit)
  self.btnUpgrade:SetActive(not self.isShowingDetail)
  if not isInit then
    self.imgCurLevelIcon:LoadSprite(levelTemplate:GetNumberIconPath())
    local name = levelTemplate:GetColoredName(false)
    self.textLevel:SetText(name)
    local ret, r, g, b, a = levelTemplate:GetQualityImageColorRGBA()
    if ret then
      self.imgIconColor:SetColorRGBA255(r, g, b, a)
      self.imgBase:SetColorRGBA255(r, g, b, a)
      self.imgGlow:SetColorRGBA255(r, g, b, a)
    end
  end
  self.textInit:SetText(levelTemplate:GetName())
  self.textInit:SetActive(isInit)
  self.textLevelTips:SetText(levelTemplate:GetRequireText())
  if levelTemplate:IsRequireOK() then
    self.textLevelTips:SetColorRGBA255(0, 255, 0, 255)
  else
    self.textLevelTips:SetColorRGBA255(195, 205, 255, 255)
  end
  local isCanUpgrade = false
  if not isMax then
    local isOK = true
    local requireLevel = levelTemplate:GetRequireLevelMain()
    local allNormalGroup = DataCenter.DominatorTemplateManager:GetAllNormalTrainGroupTemplates()
    for i, v in pairs(allNormalGroup) do
      local level = DataCenter.DominatorManager:GetTrainLevelByGroupId(v.id)
      if requireLevel > level then
        isOK = false
        break
      end
    end
    if isOK then
      local isCostItemEnough = true
      local costInfo = levelTemplate:GetUpgradeCostInfo()
      for i, v in pairs(costInfo) do
        local haveCount = DataCenter.ItemData:GetItemCount(v.itemId)
        if haveCount < v.count then
          isCostItemEnough = false
          break
        end
      end
      if isCostItemEnough then
        isCanUpgrade = true
      end
    end
  end
  self.compRedUpgrade:SetActive(isCanUpgrade)
end

function UILWDominatorMainTrainPageComponent:UpdateNormalGroup(isFromInit)
  local groupTemplates = DataCenter.DominatorTemplateManager:GetAllNormalTrainGroupTemplates()
  if not table.IsNullOrEmpty(groupTemplates) then
    if self.items == nil then
      self.items = {}
      self.itemReqs = {}
      local delay = 0.2
      for i, v in ipairs(groupTemplates) do
        local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainTrainGroupItem.prefab")
        loadRequest:completed("+", function()
          if not IsNull(loadRequest.gameObject) and not IsNull(self.compGroupLayout) then
            local pageObj = loadRequest.gameObject
            local transform = pageObj.transform
            transform:SetParent(self.compGroupLayout.transform)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            transform:Set_localRotation(0, 0, 0, 1)
            pageObj.name = "groupItem" .. i
            local item = self:AddComponent(UILWDominatorMainTrainGroupItemComponent, pageObj)
            item:SetActive(true)
            self.items[i] = item
            self.items[i]:ReInit(v, self)
            self.items[i]:UpdateSelect()
            if isFromInit then
              self.items[i]:PlayInAnim(delay)
            end
          end
        end)
        self.itemReqs[i] = loadRequest
        delay = delay + 0.05
      end
    else
      local delay = 0.2
      for i, v in ipairs(groupTemplates) do
        if self.items[i] then
          self.items[i]:ReInit(v, self)
          self.items[i]:UpdateSelect()
          if isFromInit then
            self.items[i]:PlayInAnim(delay)
          end
          delay = delay + 0.05
        end
      end
    end
  end
end

function UILWDominatorMainTrainPageComponent:UpdateItemsSelect()
  if self.items then
    for i, v in pairs(self.items) do
      v:UpdateSelect()
    end
  end
end

function UILWDominatorMainTrainPageComponent:OnSelectTrainGroupDetail(groupId)
  if self.curSelectTrainGroupId ~= nil and self.curSelectTrainGroupId == groupId then
    return
  end
  self.curSelectTrainGroupId = groupId
  self:UpdateItemsSelect()
  self:ShowDetail()
  self:UpdateMain()
end

function UILWDominatorMainTrainPageComponent:GetCurSelectTrainGroupId()
  return self.curSelectTrainGroupId
end

function UILWDominatorMainTrainPageComponent:HideDetail()
  if self.compDetail then
    self.compDetail:SetActive(false)
  end
  self.isShowingDetail = false
end

function UILWDominatorMainTrainPageComponent:ShowDetail()
  if self.curSelectTrainGroupId == nil then
    self:HideDetail()
    DataCenter.DominatorTrainSceneManager:SwitchToBattle()
    return
  end
  self.isShowingDetail = true
  self.compDetail:SetActive(true)
  self.compDetail:ReInit({
    trainGroupId = self.curSelectTrainGroupId,
    root = self
  })
  self.animator:Play("V_ui_UILWDominatorMainTrainPage_group_in")
  DataCenter.DominatorTrainSceneManager:SwitchToIdle(self:GetIdleDefaultAnim(self.curSelectTrainGroupId))
end

function UILWDominatorMainTrainPageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorTrainUpgradeSuccess, self.OnTrainUpgrade)
end

function UILWDominatorMainTrainPageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorTrainUpgradeSuccess, self.OnTrainUpgrade)
  base.OnRemoveListener(self)
end

function UILWDominatorMainTrainPageComponent:OnTrainUpgrade()
  self:UpdateMain()
  self:UpdateNormalGroup(false)
  self:UpdatePower()
  self:PlayUpgradeModelAnim()
end

function UILWDominatorMainTrainPageComponent:PlayUpgradeModelAnim()
  if self.curSelectTrainGroupId then
    if self.curSelectTrainGroupId == DominatorTrainGroupId.Attack then
      DataCenter.DominatorTrainSceneManager:PlayModelAnimQueueIfNotPlaying("gongji1", "gongji2")
    elseif self.curSelectTrainGroupId == DominatorTrainGroupId.Defence then
      DataCenter.DominatorTrainSceneManager:PlayModelAnimQueueIfNotPlaying("fangyu1", "fangyu2")
    elseif self.curSelectTrainGroupId == DominatorTrainGroupId.Hp then
      DataCenter.DominatorTrainSceneManager:PlayModelAnimQueueIfNotPlaying("xue1", "xue2")
    end
    DataCenter.DominatorTrainSceneManager:PlayUpgradeEffect(self.curSelectTrainGroupId)
  end
end

function UILWDominatorMainTrainPageComponent:OnBtnUpgradeClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorTrainUpgradeMain, {anim = false})
end

function UILWDominatorMainTrainPageComponent:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("dominator_train_desc_5")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWDominatorMainTrainPageComponent:GetIdleDefaultAnim(groupId)
  if groupId == DominatorTrainGroupId.Attack then
    return "gongji2"
  elseif groupId == DominatorTrainGroupId.Defence then
    return "fangyu2"
  elseif groupId == DominatorTrainGroupId.Hp then
    return "xue2"
  end
end

return UILWDominatorMainTrainPageComponent
