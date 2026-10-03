local base = UIBaseContainer
local HeroUniqueWeaponPage = BaseClass("HeroUniqueWeaponPage", base)
local HeroWeaponModelViewer = require("UI.UILWHero.UIHeroDetailPanel.Component.HeroWeaponModelViewer")
local heromodel_container_path = "HeroModelContainer"
local preview_btn_path = "RightTopInfo/previewBtn"
local tipbtn_path = "RightTopInfo/tip_btn"
local rightTopInfo_path = "RightTopInfo"
local heroName_txt_path = "RightTopInfo/HeroNameText"
local heroNickName_txt_path = "RightTopInfo/HeroNickNameText"
local sub_content_path = "HeroModelContainer/sub_content"
local preview_btn_txt_path = "RightTopInfo/previewBtn/btnTxt"
local level_txt_path = "centerInfo/lvInfo/lv_txt"
local lv_effect_path = "centerInfo/lvInfo/Eff_ui_hero_xiangqing_shengji_02"
local power_txt_path = "centerInfo/PowerInfo/power_txt"
local heroLevelInfo_container_path = "centerInfo/lvInfo"
local centerInfo_path = "centerInfo"
local mask_path = "HeroModelContainer/mask"
local switch_btn_path = "centerInfo/switchBtn"
local previewBtn_txt_path = "RightTopInfo/previewBtn/txt"
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local SubContentType = {UniqueWeapon = 1, UWEnhance = 2}
local SubContentInfo = {
  [SubContentType.UniqueWeapon] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/WeaponContent.prefab",
    contentCls = "UI.UILWHero.UIHeroDetailPanel.Component.UniqueWeapon.UniqueWeaponContent",
    name = "unique_weapon",
    contentType = SubContentType.UniqueWeapon
  },
  [SubContentType.UWEnhance] = {
    prefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/EnhanceContent.prefab",
    contentCls = "UI.UILWHero.UIHeroDetailPanel.Component.UniqueWeapon.UWEnhanceContent",
    name = "enhance_weapon",
    contentType = SubContentType.UWEnhance
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.rightTopInfo then
    self.rightTopInfo:SetActive(true)
  end
  if self.centerInfo then
    self.centerInfo:SetActive(true)
  end
  if self.mask then
    self.mask:SetActive(true)
  end
  self.shadowDistance = RenderSetting.GetShadowDistance()
  RenderSetting.SetShadowDistance(70)
  self.lv_effect:SetActive(false)
end

local function OnDisable(self)
  if self.delayUpdateView ~= nil then
    self.delayUpdateView:Stop()
    self.delayUpdateView = nil
  end
  if self.params ~= nil then
    for k, v in pairs(self.params) do
      if v ~= nil and not v.activeSelf then
        v:SetActive(true)
      end
    end
  end
  if self.shadowDistance ~= nil then
    RenderSetting.SetShadowDistance(self.shadowDistance)
  else
    RenderSetting.SetShadowDistance(30)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.heromodel_container = self:AddComponent(UIBaseContainer, heromodel_container_path)
  self.preview_btn = self:AddComponent(UIButton, preview_btn_path)
  self.tipbtn = self:AddComponent(UIButton, tipbtn_path)
  self.rightTopInfo = self:AddComponent(UIBaseContainer, rightTopInfo_path)
  self.heroName_txt = self:AddComponent(UIText, heroName_txt_path)
  self.heroNickName_txt = self:AddComponent(UIText, heroNickName_txt_path)
  self.sub_content = self:AddComponent(UIBaseContainer, sub_content_path)
  self.preview_btn_txt = self:AddComponent(UIText, preview_btn_txt_path)
  self.level_txt = self:AddComponent(UIText, level_txt_path)
  self.lv_effect = self:AddComponent(UIBaseContainer, lv_effect_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.heroLevelInfo_container = self:AddComponent(UIBaseContainer, heroLevelInfo_container_path)
  self.centerInfo = self:AddComponent(UIBaseContainer, centerInfo_path)
  self.mask = self:AddComponent(UIBaseContainer, mask_path)
  self.switch_btn = self:AddComponent(UIButton, switch_btn_path)
  self.previewBtn_txt = self:AddComponent(UIBaseContainer, previewBtn_txt_path)
  self.preview_btn:SetOnClick(function()
    local curSubContentType = self:GetCurShowSubContent()
    if curSubContentType == SubContentType.UniqueWeapon then
      if self.curHeroData then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroUniqueWeaponPreview, {anim = true}, self.curHeroData.heroId)
      end
    elseif curSubContentType == SubContentType.UWEnhance then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroUWEnhanceAttrTip, {anim = true}, self.curHeroData)
    end
  end)
  self.tipbtn:SetOnClick(function()
    local param = {
      activityRulesStr = UIUtil.GetString("", "hero_unique_weapon_tips1")
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.switch_btn:SetOnClick(function()
    if #self.canShowSubContents > 1 then
      local curSubContentType = self:GetCurShowSubContent()
      for i = 1, #self.canShowSubContents do
        if self.canShowSubContents[i] ~= curSubContentType then
          self:SwitchSubContent(self.canShowSubContents[i])
          break
        end
      end
    end
  end)
  self.switch_btn:SetActive(false)
  self.heroWeaponModel = self:AddComponent(HeroWeaponModelViewer, heromodel_container_path, true)
  local curScreenRatio = Screen.width / Screen.height
  local rtWidth = self.heroWeaponModel.rawImage.rectTransform.rect.width
  local rtHeight = self.heroWeaponModel.rawImage.rectTransform.rect.height
  local designScreenRatio = DefaultScreenWidth / DefaultScreenHeight
  if curScreenRatio > designScreenRatio then
    local maxRTRatio = 1215 / DefaultScreenHeight
    local newRatio = math.min(curScreenRatio, maxRTRatio)
    rtWidth = rtHeight * newRatio
  end
  self.heroWeaponModel:SetRTSize(math.ceil(rtWidth), math.ceil(rtHeight))
  self.subPages = {}
  self.subPage_reqs = {}
  self.subPage_states = {}
  for subContentType, subContentInfo in pairs(SubContentInfo) do
    self.subPage_states[subContentType] = false
  end
end

local function ComponentDestroy(self)
  self.heromodel_container = nil
  self.preview_btn = nil
  self.tipbtn = nil
  self.rightTopInfo = nil
  self.heroName_txt = nil
  self.heroNickName_txt = nil
  self.sub_content = nil
  self.preview_btn_txt = nil
  self.level_txt = nil
  self.lv_effect = nil
  self.power_txt = nil
  self.heroLevelInfo_container = nil
  self.centerInfo = nil
  self.mask = nil
  self.switch_btn = nil
  self.previewBtn_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshHeroModel(self)
  if not self.curHeroData then
    return
  end
  if self.curHeroData:IsUniqueWeaponMaxLevel() then
    local modelPath = self.curHeroData:GetHeroModelData(HeroModelType.PBR)
    self.heroWeaponModel:SetModelPath(modelPath)
    return
  end
  self:__RefreshHeroModelInner()
end

function HeroUniqueWeaponPage:__RefreshHeroModelInner()
  local curModelPath = self.curHeroData:GetHeroModelData(HeroModelType.PBR)
  local nextModelPath
  if not self.curHeroData:IsUniqueWeaponMaxLevel() then
    local nextLv = self.curHeroData:GetUniqueWeaponLv() + 1
    local nextLvWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.curHeroData.heroId, nextLv)
    if nextLvWeaponTemplate then
      nextModelPath = HeroUtils.GetHeroModelData(self.curHeroData.heroId, HeroModelType.PBR, nextLv, self.curHeroData:GetSkinId(), self.curHeroData:GetRank())
    end
  end
  if not string.IsNullOrEmpty(nextModelPath) and curModelPath ~= nextModelPath then
    self.heroWeaponModel:ShowModelPreivew(curModelPath, nextModelPath)
  else
    self.heroWeaponModel:SetModelPath(curModelPath)
  end
end

function HeroUniqueWeaponPage:CheckUniqueWeaponPackageExist()
  self.waitHeroGroupDownload = false
  local heroId = self.curHeroData.heroId
  local packConfigId = LocalController:instance():getValue("lw_hero", heroId, "download_packs_id")
  if not packConfigId or packConfigId <= 0 then
    return true
  end
  local isDownloadPackage = ResGroupManager:IsDownload(tonumber(packConfigId))
  if not isDownloadPackage then
    ResGroupManager:StartDownload(packConfigId)
    self.waitHeroGroupDownload = true
    return false
  end
  return true
end

function HeroUniqueWeaponPage:GetCanShowSubContent()
  self.canShowSubContents = {}
  if self.curHeroData:IsUniqueWeaponOpen() and self.curHeroData:IsUnlockedEnhanceUW() and self.curHeroData:CanUnlockEnhanceUW() then
    table.insert(self.canShowSubContents, SubContentType.UWEnhance)
  end
  table.insert(self.canShowSubContents, SubContentType.UniqueWeapon)
  return self.canShowSubContents
end

function HeroUniqueWeaponPage:RefreshSwitchBtn()
  if #self.canShowSubContents > 1 then
    self.switch_btn:SetActive(true)
  else
    self.switch_btn:SetActive(false)
  end
end

local function SetData(self, heroData, params)
  if heroData ~= nil then
    self.curHeroData = heroData
  else
    return
  end
  self.params = params
  self.weaponLv = heroData:GetUniqueWeaponLv()
  self.view.ctrl:SaveHeroProp(heroData.uuid)
  local triggerFlowId = LuaEntry.DataConfig:TryGetNum("hero_unique_weapon", "k5", 0)
  if not DataCenter.LWGuideFlowManager:IsRunning() and 0 < triggerFlowId and not DataCenter.LWGuideFlowManager:ReadDone(triggerFlowId) then
    DataCenter.LWGuideFlowManager.Runner:Run(triggerFlowId)
  end
  local oepnRecordStr = string.format(SettingKeys.HERO_UNIQUE_WEAPON_OPEN, heroData.heroId)
  self.prevOpened = Setting:GetPrivateBool(oepnRecordStr, false)
  Setting:SetPrivateBool(oepnRecordStr, true)
  if not self.prevOpened then
    EventManager:GetInstance():Broadcast(EventId.OpenHeroUniqueWeapon)
  end
  self:RefreshHeroBaseInfo(heroData)
  self:RefreshLvInfo()
  self:RefreshHeroPower()
  RefreshHeroModel(self)
  self:GetCanShowSubContent()
  self:SwitchSubContent(self.canShowSubContents[1])
  self:RefreshSwitchBtn()
end

function HeroUniqueWeaponPage:RefreshHeroBaseInfo(heroData)
  if not heroData then
    return
  end
  local heroTemplate = heroData.meta
  self.heroName_txt:SetLocalText(heroTemplate.name)
  self.heroNickName_txt:SetLocalText(heroTemplate.nickName)
end

local function GetHeroSpineContainer(self)
  return nil
end

local function GetHeroModelContainer(self)
  return self.heromodel_container
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroUWEnhanceUnlocked, self.OnHeroUWEnhanceUnlocked)
  self:AddUIListener(EventId.HeroUniqueWeaponUpgrade, self.OnHeroUWUnitUpgrade)
  self:AddUIListener(EventId.HeroUWEnhanceUnitUpgrade, self.RefreshHeroPower)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroUWEnhanceUnlocked, self.OnHeroUWEnhanceUnlocked)
  self:RemoveUIListener(EventId.HeroUniqueWeaponUpgrade, self.OnHeroUWUnitUpgrade)
  self:RemoveUIListener(EventId.HeroUWEnhanceUnitUpgrade, self.RefreshHeroPower)
end

function HeroUniqueWeaponPage:SetHeroModelEnable(enable)
  self.heroWeaponModel:SetActive(enable)
end

function HeroUniqueWeaponPage:HeroModelPlayUpgradeEffect()
  self.heroWeaponModel:PlayNormalUpgradeEff()
end

function HeroUniqueWeaponPage:SetPlatformUpgradeEffect(prevModelPath, curModelPath, aniStartCallback, aniFinishCallback)
  self.heroWeaponModel:SetPlatformUpgradeData(prevModelPath, curModelPath, aniStartCallback, aniFinishCallback)
end

function HeroUniqueWeaponPage:SetRightTopInfoActive(active)
  self.rightTopInfo:SetActive(active)
end

function HeroUniqueWeaponPage:SetCenterInfoActive(active)
  self.centerInfo:SetActive(active)
end

function HeroUniqueWeaponPage:SetMaskActive(active)
  self.mask:SetActive(active)
end

function HeroUniqueWeaponPage:RefreshLvInfo()
  if self.curHeroData and self.curHeroData:GetUniqueWeaponLv() > 0 then
    self.heroLevelInfo_container:SetActive(true)
    self.level_txt:SetText(string.format("Lv.%d", self.curHeroData:GetUniqueWeaponLv()))
  else
    self.heroLevelInfo_container:SetActive(false)
    self.level_txt:SetText("")
  end
end

function HeroUniqueWeaponPage:FlushLvUpgradeEffect()
  self.lv_effect:SetActive(false)
  self.lv_effect:SetActive(true)
end

function HeroUniqueWeaponPage:RefreshHeroPower()
  if not self.curHeroData then
    return
  end
  self.power_txt:SetText(self.curHeroData.power)
end

function HeroUniqueWeaponPage:PrewarmEnhanceEffects(ids)
  self.heroWeaponModel:PrewarmEnhanceEffects(ids)
end

function HeroUniqueWeaponPage:StopEnhanceEffects()
  self.heroWeaponModel:StopEnhanceEffects()
end

function HeroUniqueWeaponPage:PlayEnhanceEffects(unitType)
  self.heroWeaponModel:PlayEnhanceEffects(unitType)
end

function HeroUniqueWeaponPage:SwitchSubContent(subContentType)
  self.subPage_states[subContentType] = true
  for subType, state in pairs(self.subPage_states) do
    if subType ~= subContentType then
      self.subPage_states[subType] = false
      if self.subPages[subType] then
        self.subPages[subType]:SetActive(false)
      end
    end
  end
  self:OnChangeSubContent(subContentType)
  if self.subPages[subContentType] then
    self.subPages[subContentType]:SetActive(true)
    self.subPages[subContentType]:UpdateView(self.curHeroData)
    return
  end
  self:LoadSubContentAsync(subContentType, function(subContent)
    if self.subPage_states[subContentType] then
      self.subPages[subContentType] = subContent
      self.subPages[subContentType]:SetActive(true)
      self.subPages[subContentType]:UpdateView(self.curHeroData)
    else
      self.subPages[subContentType]:SetActive(false)
    end
  end)
end

function HeroUniqueWeaponPage:OnChangeSubContent(subContentType)
  if subContentType == SubContentType.UniqueWeapon then
    self.preview_btn_txt:SetLocalText("hero_unique_weapon_button4")
  elseif subContentType == SubContentType.UWEnhance then
    self.preview_btn_txt:SetLocalText("hero_unique_unit_attr_title")
  end
end

function HeroUniqueWeaponPage:GetCurShowSubContent()
  for subContentType, state in pairs(self.subPage_states) do
    if state then
      return subContentType
    end
  end
end

function HeroUniqueWeaponPage:LoadSubContentAsync(subContentType, loadCallback)
  if not self.subPage_callbacks then
    self.subPage_callbacks = {}
  end
  self.subPage_callbacks[subContentType] = loadCallback
  if self.subPage_reqs[subContentType] then
    return
  end
  local subContentInfo = SubContentInfo[subContentType]
  local prefabPath = subContentInfo.prefabPath
  local contentClsPath = subContentInfo.contentCls
  local contentCls = require(contentClsPath)
  local request = self.sub_content:GameObjectInstantiateAsync(prefabPath, function(req)
    if IsNull(req) then
      Logger.LogError("LoadSubContentAsync failed, prefabPath: " .. prefabPath)
      return
    end
    local obj = req.gameObject
    local transform = obj.transform
    transform:SetParent(self.sub_content.transform)
    obj.name = subContentInfo.name
    local subContent = self.sub_content:AddComponent(contentCls, subContentInfo.name, self)
    subContent:SetLocalPositionXYZ(0, 0, 0)
    subContent:SetLocalScaleXYZ(1, 1, 1)
    subContent:SetParams(self.params)
    if self.subPage_callbacks[subContentType] then
      self.subPage_callbacks[subContentType](subContent)
    end
  end)
  self.subPage_reqs[subContentType] = request
end

function HeroUniqueWeaponPage:GetSubContent(subContentType)
  return self.subPages[subContentType]
end

function HeroUniqueWeaponPage:DestroySubContent(subContentType)
  if self.subPages[subContentType] then
    self.sub_content:RemoveComponent(self.subPages[subContentType].__cname)
    self.subPages[subContentType] = nil
  end
  if self.subPage_reqs[subContentType] then
    self.subPage_reqs[subContentType]:Destroy()
    self.subPage_reqs[subContentType] = nil
  end
  self.subPage_callbacks[subContentType] = nil
  self.subPage_states[subContentType] = false
end

function HeroUniqueWeaponPage:DestroyAllSubContent()
  self.sub_content:RemoveAllComponentes()
  for _, asyncReq in pairs(self.subPage_reqs) do
    asyncReq:Destroy()
  end
  self.subPage_reqs = {}
  self.subPages = {}
  for subType, state in pairs(self.subPage_states) do
    self.subPage_states[subType] = false
  end
  self.subPage_callbacks = nil
end

function HeroUniqueWeaponPage:OnUniqueWeaponResDownload(configId)
  if self.curHeroData == nil then
    return
  end
  local heroId = self.curHeroData.heroId
  local packConfigId = LocalController:instance():getValue("lw_hero", heroId, "download_packs_id")
  if configId == tonumber(packConfigId) then
    self.waitHeroGroupDownload = true
    self:__RefreshHeroModelInner()
    if self.subPage_states then
      for subType, state in pairs(self.subPage_states) do
        if state and self.subPages[subType] then
          self.subPages[subType]:RefreshDownloadStatus()
        end
      end
    end
  end
end

function HeroUniqueWeaponPage:OnHeroUWEnhanceUnlocked(heroUuid)
  if self.curHeroData and self.curHeroData.uuid == heroUuid then
    self:GetCanShowSubContent()
    self:SwitchSubContent(SubContentType.UWEnhance)
    self:RefreshSwitchBtn()
  end
end

function HeroUniqueWeaponPage:OnHeroUWUnitUpgrade(heroUuid)
  if self.curHeroData and self.curHeroData.uuid == heroUuid then
    self:RefreshHeroPower()
    self:RefreshLvInfo()
  end
end

HeroUniqueWeaponPage.OnCreate = OnCreate
HeroUniqueWeaponPage.OnDestroy = OnDestroy
HeroUniqueWeaponPage.OnEnable = OnEnable
HeroUniqueWeaponPage.OnDisable = OnDisable
HeroUniqueWeaponPage.ComponentDefine = ComponentDefine
HeroUniqueWeaponPage.ComponentDestroy = ComponentDestroy
HeroUniqueWeaponPage.DataDefine = DataDefine
HeroUniqueWeaponPage.DataDestroy = DataDestroy
HeroUniqueWeaponPage.SetData = SetData
HeroUniqueWeaponPage.GetHeroSpineContainer = GetHeroSpineContainer
HeroUniqueWeaponPage.GetHeroModelContainer = GetHeroModelContainer
HeroUniqueWeaponPage.OnAddListener = OnAddListener
HeroUniqueWeaponPage.OnRemoveListener = OnRemoveListener
HeroUniqueWeaponPage.RefreshHeroModel = RefreshHeroModel
return HeroUniqueWeaponPage
