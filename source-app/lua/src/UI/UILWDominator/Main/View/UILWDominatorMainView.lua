local UILWDominatorMainView = BaseClass("UILWDominatorMainView", UIBaseView)
local UILWDominatorMainToggleComponent = require("UI/UILWDominator/Main/Component/UILWDominatorMainToggleComponent")
local UILWDominatorMainSelectItemComponent = require("UI/UILWDominator/Main/Component/UILWDominatorMainSelectItemComponent")
local UILWDominatorMainModelSceneViewer = require("UI/UILWDominator/Main/Scene/UILWDominatorMainModelSceneViewer")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWDominatorMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorMainView:OnDestroy()
  local curPage = self:GetCurShowPageTag()
  if self.pages and self.pages[curPage] then
    self.pages[curPage]:OnClosePage()
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainView:ComponentDefine()
  self.compPageContainer = self:AddComponent(UIBaseContainer, "Root/PageContainer")
  self.btnBack = self:AddComponent(UIButton, "Root/Bottom/BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.compToggles = self:AddComponent(UIBaseContainer, "Root/Bottom/Toggles")
  self.compBasicPageToggle = self:AddComponent(UILWDominatorMainToggleComponent, "Root/Bottom/Toggles/BasicPageToggle")
  self.compPromotionPageToggle = self:AddComponent(UILWDominatorMainToggleComponent, "Root/Bottom/Toggles/PromotionPageToggle")
  self.compTrainPageToggle = self:AddComponent(UILWDominatorMainToggleComponent, "Root/Bottom/Toggles/TrainPageToggle")
  self.compSkillPageToggle = self:AddComponent(UILWDominatorMainToggleComponent, "Root/Bottom/Toggles/SkillPageToggle")
  self.compModelViewer = self:AddComponent(UILWDominatorMainModelSceneViewer, "WeaponImg", true)
  if Config.IsPC() then
    self.rtWidth = DefaultScreenWidth
    self.rtHeight = DefaultScreenHeight
  else
    local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
    local parentWidth = uiContainerRect.sizeDelta.x
    local parentHeight = uiContainerRect.sizeDelta.y
    self.rtWidth = math.floor(parentWidth)
    self.rtHeight = math.floor(parentHeight)
    self.compModelViewer:SetRTSize(self.rtWidth, self.rtHeight)
  end
  self.compRedPointBasic = self:AddComponent(UIBaseContainer, "Root/Bottom/Toggles/BasicPageToggle/RedPointBasic")
  self.compRedPointPromotion = self:AddComponent(UIBaseContainer, "Root/Bottom/Toggles/PromotionPageToggle/RedPointPromotion")
  self.compRedPointSkill = self:AddComponent(UIBaseContainer, "Root/Bottom/Toggles/SkillPageToggle/RedPointSkill")
  self.compRedPointTrain = self:AddComponent(UIBaseContainer, "Root/Bottom/Toggles/TrainPageToggle/RedPointTrain")
end

function UILWDominatorMainView:ComponentDestroy()
  self.compPageContainer = nil
  self.btnBack = nil
  self.compToggles = nil
  self.btnLeftSwitch = nil
  self.compBasicPageToggle = nil
  self.compPromotionPageToggle = nil
  self.compTrainPageToggle = nil
  self.compSkillPageToggle = nil
  self.compModelViewer = nil
  self.compRedPointBasic = nil
  self.compRedPointPromotion = nil
  self.compRedPointSkill = nil
  self.compRedPointTrain = nil
end

function UILWDominatorMainView:InitData(param)
  if param ~= nil and param.DefaultDominatorId ~= nil then
    self.curShowMainId = param.DefaultDominatorId
  else
    self.curShowMainId = DataCenter.DominatorManager:GetDefaultShowMainId()
  end
  if param ~= nil and param.DefaultPageTag ~= nil and self.ctrl:IsShowPageTag(param.DefaultPageTag, self.curShowMainId) then
    self.curShowPageTag = param.DefaultPageTag
  else
    self.curShowPageTag = UILWDominatorMainPageTag.Basic
  end
  local allMainTemplates = DataCenter.DominatorTemplateManager:GetAllShowMainTemplates()
  self.allMainIdList = {}
  for i, v in ipairs(allMainTemplates) do
    table.insert(self.allMainIdList, v.id)
  end
end

function UILWDominatorMainView:DataDefine()
  self.param = self:GetUserData()
  self:InitData(self.param)
  self.pageReqs = {}
  self.pages = {}
  self.delayStartRandomModelAnimTimer = nil
  self.triggerNextRandomModelAnimTimer = nil
  self.delayPlayIdleModelAnimTimer = nil
  self.randomModelAnimNameCache = nil
end

function UILWDominatorMainView:DataDestroy()
  self.pageReqs = nil
  self.pages = nil
  self.curShowPageTag = nil
  self:StopRandomModelAnimTimer()
  self.randomModelAnimNameCache = nil
end

function UILWDominatorMainView:OnDisable()
  base.OnDisable(self)
end

function UILWDominatorMainView:OnOpen()
  self:UpdateToggle()
  self:UpdateToggleRedPoint()
  self:UpdatePageContent()
  self:UpdateModelViewer()
  if self.param and self.param.OpenCallback then
    self.param.OpenCallback()
  end
end

function UILWDominatorMainView:GetCurShowPageTag()
  return self.curShowPageTag
end

function UILWDominatorMainView:SetCurShowPageTag(tag, userData)
  if self.curShowPageTag ~= tag then
    local prePageTag = self.curShowPageTag
    self.curShowPageTag = tag
    EventManager:GetInstance():Broadcast(EventId.DominatorMainPageTagChanged, {
      userData = userData,
      prePageTag = prePageTag,
      newPageTag = tag
    })
  end
end

function UILWDominatorMainView:GetCurShowInfo()
  if self.curShowMainId then
    return DataCenter.DominatorManager:GetInfoById(self.curShowMainId)
  end
end

function UILWDominatorMainView:GetCurShowMainId()
  return self.curShowMainId
end

function UILWDominatorMainView:SetCurShowMainId(id)
  if self.curShowMainId ~= id then
    self.curShowMainId = id
    EventManager:GetInstance():Broadcast(EventId.DominatorMainShowMainIdChanged)
  end
end

function UILWDominatorMainView:GetAllMainIdList()
  return self.allMainIdList
end

function UILWDominatorMainView:GetCurShowMainIdIndex()
  if self.allMainIdList and self.curShowMainId then
    for i, v in ipairs(self.allMainIdList) do
      if v == self.curShowMainId then
        return i
      end
    end
  end
  return 0
end

function UILWDominatorMainView:UpdateToggle()
  if not self.ctrl or not self.compToggles then
    return
  end
  local curTag = self:GetCurShowPageTag()
  local showToggle = self.ctrl:ShowPageToggles(curTag)
  self.compToggles:SetActive(showToggle)
  if showToggle then
    local mainId = self:GetCurShowMainId()
    self.compBasicPageToggle:ReInit(UILWDominatorMainPageTag.Basic, mainId)
    self.compPromotionPageToggle:ReInit(UILWDominatorMainPageTag.Rank, mainId)
    self.compTrainPageToggle:ReInit(UILWDominatorMainPageTag.Train, mainId)
    self.compSkillPageToggle:ReInit(UILWDominatorMainPageTag.Skill, mainId)
  end
end

function UILWDominatorMainView:UpdatePageContent(evtData)
  local prePageTag, userData
  if evtData ~= nil then
    prePageTag = evtData.prePageTag
    userData = evtData.userData
  end
  local curTag = self:GetCurShowPageTag()
  if prePageTag then
    if self.pages[prePageTag] then
      self.pages[prePageTag]:SetActive(false)
      self.pages[prePageTag]:OnClosePage()
    end
  else
    for i, v in pairs(self.pages) do
      if i ~= curTag then
        v:SetActive(false)
        v:OnClosePage()
      end
    end
  end
  if not self.pages[curTag] and not self.pageReqs[curTag] then
    local prefabPath = self.ctrl:GetPagePrefabPath(curTag)
    if not string.IsNullOrEmpty(prefabPath) then
      local loadPageRequest = self:GameObjectInstantiateAsync(prefabPath)
      loadPageRequest:completed("+", function()
        if not IsNull(loadPageRequest.gameObject) and not IsNull(self.compPageContainer) and self.ctrl then
          local pageObj = loadPageRequest.gameObject
          local transform = pageObj.transform
          transform:SetParent(self.compPageContainer.transform)
          transform:Set_localScale(1, 1, 1)
          transform:Set_localPosition(0, 0, 0)
          transform:Set_sizeDelta(0, 0)
          local pageClass = self.ctrl:GetPageClass(curTag)
          if pageClass then
            local page = self:AddComponent(pageClass, pageObj)
            page:OnOpenPage()
            page:ReInit(userData)
            page:SetActive(true)
            self.pages[curTag] = page
          end
        end
      end)
      self.pageReqs[curTag] = loadPageRequest
    end
  elseif self.pages[curTag] then
    self.pages[curTag]:SetActive(true)
    self.pages[curTag]:ReInit(userData)
    self.pages[curTag]:OnOpenPage()
  end
end

function UILWDominatorMainView:UpdateModelViewer()
  local tag = self:GetCurShowPageTag()
  local mainId = self:GetCurShowMainId()
  local showModel = self.ctrl:ShowModel(mainId, tag)
  if self.compModelViewer then
    self.compModelViewer:SetActive(showModel)
    if showModel then
      local appearanceId
      if tag == UILWDominatorMainPageTag.RankPreview then
        if self.pages and self.pages[UILWDominatorMainPageTag.RankPreview] then
          local pageComp = self.pages[UILWDominatorMainPageTag.RankPreview]
          local curRankShowTemplate = pageComp:GetCurRankShowTemplate()
          if curRankShowTemplate then
            appearanceId = curRankShowTemplate:GetShowAppearanceId()
          end
        end
      else
        local info = self:GetCurShowInfo()
        if info then
          appearanceId = info:GetAppearanceId()
        end
      end
      if appearanceId then
        self.compModelViewer:SetModel(appearanceId, function(isLoadSuccess, isModelChanged)
          self:OnModelLoadFinish(isLoadSuccess, isModelChanged)
        end, mainId)
      end
    else
      self:StopRandomModelAnimTimer()
    end
  end
end

function UILWDominatorMainView:UpdateToggleRedPoint()
  self.compRedPointBasic:SetActive(false)
  local mainId = self:GetCurShowMainId()
  local info = DataCenter.DominatorManager:GetInfoById(mainId)
  local isUpgradeRankAndSkillUnlock = DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock()
  local showRankRed = isUpgradeRankAndSkillUnlock and info ~= nil and info:IsCanUpgradeRank()
  self.compRedPointPromotion:SetActive(showRankRed)
  local showSkillRed = isUpgradeRankAndSkillUnlock and info ~= nil and info:GetCanUpgradeSkillCount() > 0
  self.compRedPointSkill:SetActive(showSkillRed)
  self.compRedPointTrain:SetActive(0 < DataCenter.DominatorManager:GetCanUpgradeTrainGroupRedCount())
end

function UILWDominatorMainView:ReopenView(param)
  self:InitData(param)
  self:OnOpen()
end

function UILWDominatorMainView:StopRandomModelAnimTimer()
  if self.delayStartRandomModelAnimTimer ~= nil then
    self.delayStartRandomModelAnimTimer:Stop()
    self.delayStartRandomModelAnimTimer = nil
  end
  if self.triggerNextRandomModelAnimTimer ~= nil then
    self.triggerNextRandomModelAnimTimer:Stop()
    self.triggerNextRandomModelAnimTimer = nil
  end
  if self.delayPlayIdleModelAnimTimer ~= nil then
    self.delayPlayIdleModelAnimTimer:Stop()
    self.delayPlayIdleModelAnimTimer = nil
  end
end

function UILWDominatorMainView:OnModelLoadFinish(isSuccess, isModelChanged)
  if not isSuccess or self.compModelViewer == nil then
    return
  end
  if isModelChanged then
    self:StopRandomModelAnimTimer()
    self.delayStartRandomModelAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:TriggerRandomModelAnim()
    end, 5)
  end
end

function UILWDominatorMainView:TriggerRandomModelAnim()
  local function GetRandomAnimData(animInfo)
    local tmp = {}
    
    for i, v in pairs(animInfo) do
      if self.randomModelAnimNameCache == nil or self.randomModelAnimNameCache ~= v.name then
        table.insert(tmp, v)
      end
    end
    math.randomseed(SafeLocalOsTime())
    if 1 <= #tmp then
      local nextAnimData = tmp[math.random(1, #tmp)]
      return nextAnimData
    end
  end
  
  self:StopRandomModelAnimTimer()
  if not self.compModelViewer then
    return
  end
  local animInfo = self.compModelViewer:GetEmoModelAnimClipData()
  if not table.IsNullOrEmpty(animInfo) then
    local nextAnimData = GetRandomAnimData(animInfo)
    if not nextAnimData then
      return
    end
    self.randomModelAnimNameCache = nextAnimData.name
    self.compModelViewer:PlayModelAnim(nextAnimData.name, 0.2)
    if nextAnimData.length > 0 then
      self.delayPlayIdleModelAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.compModelViewer then
          self.compModelViewer:PlayModelAnim("idle", 0.2)
        end
      end, nextAnimData.length)
    end
    local timeDelay = nextAnimData.length + 5
    self.triggerNextRandomModelAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:TriggerRandomModelAnim()
    end, timeDelay)
  end
end

function UILWDominatorMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorMainPageTagChanged, self.OnPageTagChanged)
  self:AddUIListener(EventId.DominatorMainShowMainIdChanged, self.OnShowMainIdChanged)
  self:AddUIListener(EventId.DominatorMainViewRedPointChanged, self.OnRedPointChanged)
  self:AddUIListener(EventId.DominatorAppearanceUpdate, self.OnAppearanceChanged)
  self:AddUIListener(EventId.DominatorRankUpgradeSuccess, self.OnRankLevelChanged)
  self:AddUIListener(EventId.DominatorSkillUpgradeSuccess, self.OnSkillLevelChanged)
end

function UILWDominatorMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorMainPageTagChanged, self.OnPageTagChanged)
  self:RemoveUIListener(EventId.DominatorMainShowMainIdChanged, self.OnShowMainIdChanged)
  self:RemoveUIListener(EventId.DominatorMainViewRedPointChanged, self.OnRedPointChanged)
  self:RemoveUIListener(EventId.DominatorAppearanceUpdate, self.OnAppearanceChanged)
  self:RemoveUIListener(EventId.DominatorRankUpgradeSuccess, self.OnRankLevelChanged)
  self:RemoveUIListener(EventId.DominatorSkillUpgradeSuccess, self.OnSkillLevelChanged)
  base.OnRemoveListener(self)
end

function UILWDominatorMainView:OnPageTagChanged(evtData)
  self:UpdateToggle()
  self:UpdatePageContent(evtData)
  self:UpdateModelViewer()
end

function UILWDominatorMainView:OnShowMainIdChanged()
  self:UpdatePageContent()
  self:UpdateModelViewer()
  self:UpdateToggleRedPoint()
end

function UILWDominatorMainView:OnRedPointChanged()
  self:UpdateToggleRedPoint()
end

function UILWDominatorMainView:OnBtnBackClick()
  local curTag = self:GetCurShowPageTag()
  if self.pages and self.pages[curTag] and self.pages[curTag].CustomBtnBackClick then
    self.pages[curTag]:CustomBtnBackClick()
  else
    self.ctrl:CloseSelf()
  end
end

function UILWDominatorMainView:OnAppearanceChanged()
  self:UpdateModelViewer()
end

function UILWDominatorMainView:OnRankLevelChanged()
end

function UILWDominatorMainView:OnSkillLevelChanged()
end

return UILWDominatorMainView
