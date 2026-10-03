local UILWTacticalWeaponView = BaseClass("UILWTacticalWeaponView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITacticalWeaponChipPlanView = require("UI.UILWTacticalWeaponChip.Plan.View.UITacticalWeaponChipPlanView")
local TacticalWeaponBasicPage = require("UI.UILWTacticalWeapon.Component.BasicPage.TacticalWeaponBasicPage")
local TacticalWeaponEquipPage = require("UI.UILWTacticalWeapon.Component.EquipPage.TacticalWeaponEquipPage")
local TacticalWeaponSkillChipPage = require("UI.UILWTacticalWeapon.Component.SkillChipPage.TacticalWeaponSkillChipPage")
local TacticalWeaponPageToggle = require("UI.UILWTacticalWeapon.Component.TacticalWeaponPageToggle")
local tacticalWeaponSimpleModelViewer = require("UI.UILWTacticalWeapon.Component.TacticalWeaponSimpleModelViewer")
local UIModelView = require("Framework.UI.Component.UIModelView")
local back_btn_path = "Root/BtnBack"
local basicPage_toggle_path = "Root/BottomToggles/Toggles/BasicPageToggle"
local equipPage_toggle_path = "Root/BottomToggles/Toggles/EquipPageToggle"
local skinPage_toggle_path = "Root/BottomToggles/Toggles/SkinPageToggle"
local weaponImg_path = "Root/WeaponImg"
local info_btn_path = "Root/TopInfos/InfoBtn"
local name_txt_path = "Root/TopInfos/NameText"
local page_container_path = "Root/PageContainer"
local skillChipPage_toggle_path = "Root/BottomToggles/Toggles/SkillChipPageToggle"
local chip_plan_page_toggle_path = "Root/BottomToggles/Toggles/ChipPlanPageToggle"
local bg_path = "Bg"
local bg1_path = "Bg1"
local bg2_path = "Bg2"
local page_prefab_paths = {
  [TacticalWeaponPageType.Basic] = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/BasicPage.prefab",
  [TacticalWeaponPageType.Equip] = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipPage.prefab",
  [TacticalWeaponPageType.SkillChip] = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/SkillChipPage.prefab",
  [TacticalWeaponPageType.ChipPlan] = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalWeaponChipPlan.prefab"
}
local page_class = {
  [TacticalWeaponPageType.Basic] = TacticalWeaponBasicPage,
  [TacticalWeaponPageType.Equip] = TacticalWeaponEquipPage,
  [TacticalWeaponPageType.SkillChip] = TacticalWeaponSkillChipPage,
  [TacticalWeaponPageType.ChipPlan] = UITacticalWeaponChipPlanView
}

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.basicPage_toggle = self:AddComponent(TacticalWeaponPageToggle, basicPage_toggle_path)
  self.basicPage_toggle:SetType(TacticalWeaponPageType.Basic)
  self.equipPage_toggle = self:AddComponent(TacticalWeaponPageToggle, equipPage_toggle_path)
  self.equipPage_toggle:SetType(TacticalWeaponPageType.Equip)
  self.skillChipPage_toggle = self:AddComponent(TacticalWeaponPageToggle, skillChipPage_toggle_path)
  self.skillChipPage_toggle:SetType(TacticalWeaponPageType.SkillChip)
  self.chip_plan_page_toggle = self:AddComponent(TacticalWeaponPageToggle, chip_plan_page_toggle_path)
  self.chip_plan_page_toggle:SetType(TacticalWeaponPageType.ChipPlan)
  self.pages = {}
  self.toggles = {
    [TacticalWeaponPageType.Basic] = self.basicPage_toggle,
    [TacticalWeaponPageType.Equip] = self.equipPage_toggle,
    [TacticalWeaponPageType.SkillChip] = self.skillChipPage_toggle,
    [TacticalWeaponPageType.ChipPlan] = self.chip_plan_page_toggle
  }
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString(170001), nil, Localization:GetString("battlesystem_info1_new"))
  end)
  self.nameTxt = self:AddComponent(UIText, name_txt_path)
  self.page_container = self:AddComponent(UIBaseContainer, page_container_path)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.rawImgRTSceneBg = self:AddComponent(UIModelView, "RTSceneBg", true)
end

local function ComponentDestroy(self)
  self.back_btn = nil
  self.basicPage_toggle = nil
  self.equipPage_toggle = nil
  self.skinPage_toggle = nil
  self.infoBtn = nil
  self.nameTxt = nil
  self.page_container = nil
  self.bg = nil
  self.bg1 = nil
  self.bg2 = nil
  self.j_ui_qiehuan_xia = nil
  self.j_ui_qiehuan_shang = nil
  self.rawImgRTSceneBg = nil
end

local function DataDefine(self)
  self.disPlayingModel = nil
  self.activeToggles = {}
  self.pageRequests = {}
end

local function DataDestroy(self)
  self.levelUpEffectCpts = nil
  self:RemoveOnSceneLoadCallback()
  if self.director then
    self.director:stopped("-", self.bindOnTimelineEnd)
    self.director = nil
  end
  self.equipNeedBuildingLevel = nil
  self.weaponInfo = nil
  self.activeToggles = nil
  self.pageRequests = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  ComponentDefine(self)
  local weapons = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(weapons) then
    for i, v in pairs(weapons) do
      self.weaponInfo = v
      break
    end
  end
  if not self.weaponInfo then
    self.ctrl:CloseSelf()
    return
  end
  self.nameTxt:SetText(self.weaponInfo:GetName())
  local gotoPage, gotoParam1 = self:GetUserData()
  if gotoPage == nil then
    gotoPage = TacticalWeaponPageType.Basic
  end
  self:RefreshActiveToggles()
  self:SelectPage(gotoPage, gotoParam1)
end

local function OnDestroy(self)
  DataDestroy(self)
  ComponentDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnSkillChipFunctionUnlockClose(self, functionIconPos)
  if not functionIconPos then
    return
  end
  local togglePos
  if self.activeToggles and self.activeToggles[TacticalWeaponPageType.SkillChip] then
    togglePos = self.activeToggles[TacticalWeaponPageType.SkillChip]:GetPosition()
  end
  local effectPath = "Assets/_Art/Effect/prefab/ui/VFX_ui_jiesuoSkillChip_trail.prefab"
  local startPos = functionIconPos
  local endPos = togglePos
  UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 1, nil, function()
  end)
end

local function OnTWInit(self)
  self.weaponInfo = nil
  local weapons = DataCenter.TacticalWeaponManager:GetTacticalWeaponInfos()
  if not table.IsNullOrEmpty(weapons) then
    for i, v in pairs(weapons) do
      self.weaponInfo = v
      break
    end
  end
  if not self.weaponInfo then
    self.ctrl:CloseSelf()
  end
  if self.curPageId and self.curPageId == TacticalWeaponPageType.Basic and self.pages[self.curPageId] then
    self.pages[self.curPageId]:SetData(self.weaponInfo)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalWeaponUpdate, self.RefreshActiveToggles)
  self:AddUIListener(EventId.TWSkillUnlockTimeUpdate, self.RefreshActiveToggles)
  self:AddUIListener(EventId.TWSkillChipFunctionUnlockClose, self.OnSkillChipFunctionUnlockClose)
  self:AddUIListener(EventId.TacticalWeaponInit, OnTWInit)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TacticalWeaponUpdate, self.RefreshActiveToggles)
  self:RemoveUIListener(EventId.TWSkillUnlockTimeUpdate, self.RefreshActiveToggles)
  self:RemoveUIListener(EventId.TWSkillChipFunctionUnlockClose, self.OnSkillChipFunctionUnlockClose)
  self:RemoveUIListener(EventId.TacticalWeaponInit, OnTWInit)
end

local function RefreshTogglesSelectedState(self, selectPage)
  for i, v in pairs(self.activeToggles) do
    if i == selectPage then
      self.activeToggles[i]:SetSelected(true)
    else
      self.activeToggles[i]:SetSelected(false)
    end
    local showLeftLine = true
    if i == 1 then
      showLeftLine = false
    elseif i == selectPage or i - 1 == selectPage then
      showLeftLine = false
    end
    self.activeToggles[i]:ShowLeftLine(showLeftLine)
  end
end

local function RefreshActiveToggles(self)
  self.activeToggles[TacticalWeaponPageType.Basic] = self.basicPage_toggle
  self.activeToggles[TacticalWeaponPageType.Equip] = self.equipPage_toggle
  local skillChipFunctionUnlock = DataCenter.TacticalChipManager:IsFunctionTabShow()
  if skillChipFunctionUnlock then
    self.activeToggles[TacticalWeaponPageType.SkillChip] = self.skillChipPage_toggle
  else
    self.activeToggles[TacticalWeaponPageType.SkillChip] = nil
  end
  self.skillChipPage_toggle:SetActive(skillChipFunctionUnlock)
  local chipPlanUnlock = DataCenter.TacticalChipManager:IsFunctionTabShow()
  if chipPlanUnlock then
    self.activeToggles[TacticalWeaponPageType.ChipPlan] = self.chip_plan_page_toggle
  else
    self.activeToggles[TacticalWeaponPageType.ChipPlan] = nil
  end
  self.chip_plan_page_toggle:SetActive(chipPlanUnlock)
  if self.curPageId then
    RefreshTogglesSelectedState(self, self.curPageId)
  end
end

local function SelectPage(self, pageId, param1)
  if not pageId then
    return
  end
  if self.curPageId == pageId then
    return
  end
  RefreshTogglesSelectedState(self, pageId)
  local page = self.pages[pageId]
  
  local function RefreshPages(page, param1)
    if not page then
      return
    end
    for i, v in pairs(self.pages) do
      if i ~= pageId then
        v:SetActive(false)
      end
    end
    page:SetActive(true)
    page:SetData(self.weaponInfo, param1)
  end
  
  self:RefreshRTSceneBg(pageId)
  if not page and not self.pageRequests[pageId] then
    local loadPageRequest = self:GameObjectInstantiateAsync(page_prefab_paths[pageId])
    loadPageRequest:completed("+", function()
      if not IsNull(loadPageRequest.gameObject) then
        local pageObj = loadPageRequest.gameObject
        local transform = pageObj.transform
        transform:SetParent(self.page_container.transform)
        transform:Set_localScale(1, 1, 1)
        transform:Set_localPosition(0, 0, 0)
        page = self:AddComponent(page_class[pageId], pageObj)
        self.pages[pageId] = page
        RefreshPages(page, param1)
      end
    end)
    self.pageRequests[pageId] = loadPageRequest
  elseif page then
    RefreshPages(page, param1)
  end
  self.curPageId = pageId
end

local function OnToggleClick(self, pageId)
  if not pageId then
    return
  end
  if pageId == TacticalWeaponPageType.Equip then
    local unlock, needLevel = DataCenter.TacticalWeaponManager:IsEquipFunctionUnlock()
    if not unlock then
      UIUtil.ShowTips(Localization:GetString(141152, needLevel))
      return
    end
  elseif pageId == TacticalWeaponPageType.ChipPlan then
    local unlock, needLevel = DataCenter.TacticalChipManager:IsFunctionChipPlanTabShow()
    if not unlock then
      UIUtil.ShowTips(Localization:GetString("battlesystem_tips3", needLevel))
      return
    end
  end
  self:SelectPage(pageId)
end

local function ChangeModelAppearance(self, appearance, callback)
  if appearance == nil then
    return
  end
  local modelPath = ""
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearance)
  if appearanceTemplate ~= nil then
    modelPath = appearanceTemplate.heroimg_model
  end
  self:ChangeModel(modelPath, callback)
end

function UILWTacticalWeaponView:ChangeModel(modelPath, callback)
  self.rawImgRTSceneBg:ChangeModel(modelPath, callback)
end

local function ResetToLevelModel(self, skinId)
  local appearance
  if self.weaponInfo then
    appearance = DataCenter.TacticalWeaponManager:GetWeaponAppearanceData(self.weaponInfo, skinId)
  end
  self:ChangeModelAppearance(appearance)
end

local function ResetToDefaultModel(self, callback)
  local appearance = DataCenter.TacticalWeaponManager:GetCurDefaultSkinAppearanceId()
  self:ChangeModelAppearance(appearance, callback)
end

local function HideBg(self)
end

local function ShowBg(self)
end

local function PlayModelReplaceEffect(self, prevAppearance, afterAppearance, callback)
end

function UILWTacticalWeaponView:SetRootVisible(visible)
  self.root:SetActive(visible)
end

function UILWTacticalWeaponView:GetModelViewSceneRoot()
  if self.rawImgRTSceneBg then
    return self.rawImgRTSceneBg:GetSceneRoot()
  end
end

function UILWTacticalWeaponView:GetModelViewSceneNode(path)
  if self.rawImgRTSceneBg then
    return self.rawImgRTSceneBg:GetSceneNode(path)
  end
end

function UILWTacticalWeaponView:IsModelViewSceneLoaded(path)
  if self.rawImgRTSceneBg then
    return self.rawImgRTSceneBg:IsSceneLoaded(path)
  end
end

function UILWTacticalWeaponView:RefreshRTSceneBg(tab)
  self.rawImgRTSceneBg:Clear()
  self.rawImgRTSceneBg:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  if tab == TacticalWeaponPageType.Basic or tab == TacticalWeaponPageType.Equip then
    self.rawImgRTSceneBg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.DefaultHDR)
    self.rawImgRTSceneBg:ReInit(SceneAssets.TacticalWeaponScene)
    self:ResetToDefaultModel()
    self.rawImgRTSceneBg:SetActive(true)
  elseif tab == TacticalWeaponPageType.SkillChip then
    self.rawImgRTSceneBg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.DefaultHDR)
    self.rawImgRTSceneBg:ReInit(SceneAssets.TacticalChipAir)
    self.rawImgRTSceneBg:SetActive(true)
  else
    self.rawImgRTSceneBg:SetActive(false)
  end
end

function UILWTacticalWeaponView:RegisterOnSceneLoadCallback(pageId, callback)
  if not self.onSceneLoadHandlerMap then
    self.onSceneLoadHandlerMap = {}
  end
  self.onSceneLoadHandlerMap[pageId] = callback
  if self.rawImgRTSceneBg then
    self.rawImgRTSceneBg:SetOnLoadSceneHandler(callback)
  end
end

function UILWTacticalWeaponView:RemoveOnSceneLoadCallback()
  if self.onSceneLoadHandlerMap then
    for k, v in pairs(self.onSceneLoadHandlerMap) do
      self.onSceneLoadHandlerMap[k] = nil
    end
    self.onSceneLoadHandlerMap = nil
  end
end

function UILWTacticalWeaponView:GetTimeline()
  if self.rawImgRTSceneBg == nil then
    return
  end
  local node = self.rawImgRTSceneBg:GetSceneNode("timeline")
  if node == nil then
    return
  end
  local director = node:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
  return director
end

UILWTacticalWeaponView.OnCreate = OnCreate
UILWTacticalWeaponView.OnDestroy = OnDestroy
UILWTacticalWeaponView.OnEnable = OnEnable
UILWTacticalWeaponView.OnDisable = OnDisable
UILWTacticalWeaponView.ComponentDefine = ComponentDefine
UILWTacticalWeaponView.ComponentDestroy = ComponentDestroy
UILWTacticalWeaponView.DataDefine = DataDefine
UILWTacticalWeaponView.DataDestroy = DataDestroy
UILWTacticalWeaponView.OnAddListener = OnAddListener
UILWTacticalWeaponView.OnRemoveListener = OnRemoveListener
UILWTacticalWeaponView.SelectPage = SelectPage
UILWTacticalWeaponView.OnToggleClick = OnToggleClick
UILWTacticalWeaponView.ChangeModelAppearance = ChangeModelAppearance
UILWTacticalWeaponView.ResetToLevelModel = ResetToLevelModel
UILWTacticalWeaponView.ResetToDefaultModel = ResetToDefaultModel
UILWTacticalWeaponView.RefreshActiveToggles = RefreshActiveToggles
UILWTacticalWeaponView.OnSkillChipFunctionUnlockClose = OnSkillChipFunctionUnlockClose
UILWTacticalWeaponView.HideBg = HideBg
UILWTacticalWeaponView.ShowBg = ShowBg
UILWTacticalWeaponView.PlayModelReplaceEffect = PlayModelReplaceEffect
return UILWTacticalWeaponView
