local UITacticalWeaponSkinPage = BaseClass("UITacticalWeaponSkinPage", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TacticalDecorationIcons = require("UI.UILWTacticalWeapon.Component.TacticalDecorationIcons")
local EffectDesc = require("UI.UIDecoration.UIDecorationMain.Component.EffectDesc")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local tacticalWeaponSimpleModelViewer = require("UI.UILWTacticalWeapon.Component.TacticalWeaponSimpleModelViewer")
local UIModelView = require("Framework.UI.Component.UIModelView")
local all_type_decoration_path = "Root/ImgBg/TypeDecorations"
local effect_left_path = "Root/ImgBg/EffectLeft"
local effect_right_path = "Root/ImgBg/EffectRight"
local effect_btn_path = "Root/ImgBg/EffectRight/EffectBtn"
local introBtn_path = "Root/ImgBg/EffectRight/Button"
local UISeasonCallbackInfoPath = "Root/ImgBg/TypeDecorations/UISeasonCallbackInfo"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param1 = self:GetUserData()
  self.customParam = param1
  self.currentSelectDecoration, self.allDecorations = self:GetDecorations(param1 or self.currentSelectDecoration)
  self:RefreshTypeDecorations()
  self:RefreshEffect()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.effect_right = self:AddComponent(UIBaseContainer, effect_right_path)
  self.effect_desc = self:AddComponent(EffectDesc, effect_left_path)
  self.effect_bth = self:AddComponent(UIButton, effect_btn_path)
  self.effect_bth:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationEffect)
  end)
  self.introBtn = self:AddComponent(UIButton, introBtn_path)
  self.introBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local str = Localization:GetString("2000467")
    UIUtil.ShowIntro(Localization:GetString("2000466"), "", str)
  end)
  self.seasonCallbackInfo = self:AddComponent(SeasonCallbackInfo, UISeasonCallbackInfoPath)
  self.btnInfo = self:AddComponent(UIButton, "Root/TopInfos/InfoBtn")
  self.btnInfo:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString(170001), nil, Localization:GetString(141150))
  end)
  self.textTitle = self:AddComponent(UIText, "Root/TopInfos/title")
  self.textTitle:SetLocalText(141146)
  self.btnBack = self:AddComponent(UIButton, "Root/BtnBack")
  self.btnBack:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.weaponImg = self:AddComponent(UIModelView, "WeaponImg", true)
  self.weaponImg:SetEnable(false)
  self.weaponImg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.DefaultHDR)
  self.weaponImg:SetDefaultSceneTrans(Vector3.New(2000, 2000, 2000))
  self.weaponImg:ReInit(SceneAssets.TacticalWeaponScene)
  self.textWeaponName = self:AddComponent(UIText, "Root/ImgBg/TypeDecorations/Middle/nameNode/weaponName")
  self.textWeaponNameGold = self:AddComponent(UIText, "Root/ImgBg/TypeDecorations/Middle/nameNode/weaponNameGold")
  self.weaponNameGoldBottom = self:AddComponent(UIText, "Root/ImgBg/TypeDecorations/Middle/nameNode/weaponNameGoldBottom")
  self.animator = self:AddComponent(UIAnimator, "")
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.textWeaponName = nil
  self.textWeaponNameGold = nil
  self.weaponNameGoldBottom = nil
  self.compVFXQualitySwitch = nil
  self.animator = nil
  if self.weaponImg then
    self.weaponImg:SetEnable(false)
  end
  self.btnInfo = nil
  self.textTitle = nil
  self.btnBack = nil
end

local function DataDestroy(self)
  self.lastSpinePath = nil
  self.curHeroData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self.animator:Play("Open")
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function IsShowRedPointOrNew(self, skinTemplate)
  if skinTemplate == nil then
    return false, false, false
  end
  local showRedPoint = false
  local hasGainItem = false
  local hasNew = false
  local showNew = false
  local showAddRedPoint = false
  local methods = skinTemplate.gainMethod
  local data = DataCenter.DecorationDataManager:GetSkinDataById(skinTemplate.id)
  local isUnlock = skinTemplate:IsDefault() or data ~= nil and data:IsInExpireTime()
  for _, v in pairs(methods) do
    local itemCount = DataCenter.ItemData:GetItemCount(v.id)
    if 0 < itemCount then
      hasGainItem = true
      hasNew = hasNew or DataCenter.DecorationDataManager:IsNewDecorationItem(v.id)
    end
  end
  if not isUnlock then
    showRedPoint = hasGainItem
    showNew = hasNew
    if not showNew and skinTemplate:IsHot() then
      showNew = true
    end
  else
    showAddRedPoint = hasGainItem
  end
  return showRedPoint, showNew, showAddRedPoint
end

function UITacticalWeaponSkinPage:GetDecorations(currentSelectDecoration)
  local tacticalWeaponTypeDecoraitons = DataCenter.DecorationTemplateManager:GetTypeDecorations(DecorationType.DecorationType_TacticalWeapon)
  local decorationDatas = {}
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  for _, v in ipairs(tacticalWeaponTypeDecoraitons) do
    local tmp = {}
    tmp.id = v
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    local data = DataCenter.DecorationDataManager:GetSkinDataById(tmp.id)
    tmp.isUnlock = template:IsDefault() or data ~= nil and data:IsInExpireTime()
    local currentSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
    tmp.inUse = currentSkinId == tmp.id
    if template:CheckTemplateCanShow() or tmp.isUnlock then
      if currentSelectDecoration == nil and tmp.inUse then
        currentSelectDecoration = v
      end
      tmp.colorBg = DataCenter.ItemTemplateManager:GetToolBgByColor(template.quality)
      local appearanceId = template.appearance
      if weaponInfo and template:IsDefault() then
        appearanceId = weaponInfo:GetAppearance()
      end
      local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
      if appearanceTemplate then
        tmp.icon = LoadPath.HeroIconsSmallPath .. appearanceTemplate.queue_icon_path
      else
        tmp.icon = template.icon
      end
      tmp.img = template.img
      tmp.order = template.order
      local showRedPoint, showNew, showAddRedPoint = IsShowRedPointOrNew(self, template)
      tmp.showRedPoint = showRedPoint
      tmp.showNew = showNew
      tmp.showAddRedPoint = showAddRedPoint
      tmp.name = template.name
      tmp.type = template.type
      table.insert(decorationDatas, tmp)
    end
  end
  table.sort(decorationDatas, function(k, v)
    if k.isUnlock ~= v.isUnlock then
      return k.isUnlock
    end
    return k.order < v.order
  end)
  currentSelectDecoration = currentSelectDecoration or tacticalWeaponTypeDecoraitons[1]
  return currentSelectDecoration, decorationDatas
end

local function RefreshTypeDecorations(self)
  if self.iconDecorations == nil then
    self.iconDecorations = self:AddComponent(TacticalDecorationIcons, all_type_decoration_path)
  end
  self.iconDecorations:SetData(self.allDecorations, self.currentSelectDecoration, DecorationType.DecorationType_TacticalWeapon)
end

local function RefreshEffect(self)
  local effectData = DecorationUtil.GetEffectDesc(self.currentSelectDecoration)
  self.effect_desc:ReInit(effectData)
end

local function ShowCurrentDecoration(self)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.currentSelectDecoration)
  if template then
    local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
    local appearanceId = DataCenter.TacticalWeaponManager:GetDefaultSkinRealAppearanceId(weaponInfo, self.currentSelectDecoration)
    local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    if appearanceTemplate ~= nil then
      self:ChangeModelAppearance(appearanceId)
      self:PlaySwitchSound(appearanceTemplate.sound_switch_skin)
    end
    self.textWeaponNameGold:SetActive(false)
    self.weaponNameGoldBottom:SetActive(false)
    self.textWeaponName:SetActive(false)
    if template.quality == 5 then
      self.textWeaponNameGold:SetLocalText(template.name)
      self.weaponNameGoldBottom:SetLocalText(template.name)
      self.textWeaponNameGold:SetActive(true)
      self.weaponNameGoldBottom:SetActive(true)
    elseif template.quality == 4 then
      self.textWeaponName:SetLocalText(template.name)
      self.textWeaponName:SetColorRGBA255(235, 134, 255, 255)
      self.textWeaponName:SetActive(true)
    else
      self.textWeaponName:SetLocalText(template.name)
      self.textWeaponName:SetColorRGBA255(112, 230, 241, 255)
      self.textWeaponName:SetActive(true)
    end
  end
  RefreshEffect(self)
  if self.seasonCallbackInfo then
    self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Drone, self.currentSelectDecoration)
  end
end

function UITacticalWeaponSkinPage:PlaySwitchSound(soundId)
  DataCenter.LWSoundManager:PlaySound(soundId, false)
end

function UITacticalWeaponSkinPage:ResetToLevelModel(skinId)
  local appearance
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo then
    appearance = DataCenter.TacticalWeaponManager:GetWeaponAppearanceData(weaponInfo, skinId)
  end
  self:ChangeModelAppearance(appearance)
end

function UITacticalWeaponSkinPage:ChangeModelAppearance(appearance)
  if appearance == nil then
    return
  end
  local modelPath = ""
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearance)
  if appearanceTemplate ~= nil then
    modelPath = appearanceTemplate.heroimg_model
  end
  self.weaponImg:ChangeModel(modelPath, BindCallback(self, self.onModelChange))
end

function UITacticalWeaponSkinPage:onModelChange(status, model)
  if status == false then
    return
  end
  self.weaponImg:ResetRotation()
  self.weaponImg:PlayAni("uiChange")
  self.weaponImg:PlayAniQueued("uiIdle")
end

local function SetData(self, weaponInfo, param1)
end

local function OnUserSkinUpdate(self)
  self.currentSelectDecoration, self.allDecorations = self:GetDecorations(self.customParam or self.currentSelectDecoration)
  self:RefreshTypeDecorations()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  self:AddUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
  self:AddUIListener(EventId.RefreshItems, self.OnUserSkinUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
  self:RemoveUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
  self:RemoveUIListener(EventId.RefreshItems, self.OnUserSkinUpdate)
end

local function SetCurrentDecoration(self, decorationId)
  self.currentSelectDecoration = decorationId
  ShowCurrentDecoration(self)
end

local function OnSelectEvent(self, decorationId)
  self.animator:Play("Switch")
  SetCurrentDecoration(self, decorationId)
end

UITacticalWeaponSkinPage.OnCreate = OnCreate
UITacticalWeaponSkinPage.OnDestroy = OnDestroy
UITacticalWeaponSkinPage.OnEnable = OnEnable
UITacticalWeaponSkinPage.OnDisable = OnDisable
UITacticalWeaponSkinPage.ComponentDefine = ComponentDefine
UITacticalWeaponSkinPage.DataDefine = DataDefine
UITacticalWeaponSkinPage.ComponentDestroy = ComponentDestroy
UITacticalWeaponSkinPage.DataDestroy = DataDestroy
UITacticalWeaponSkinPage.SetData = SetData
UITacticalWeaponSkinPage.OnAddListener = OnAddListener
UITacticalWeaponSkinPage.OnRemoveListener = OnRemoveListener
UITacticalWeaponSkinPage.OnUserSkinUpdate = OnUserSkinUpdate
UITacticalWeaponSkinPage.OnSelectEvent = OnSelectEvent
UITacticalWeaponSkinPage.RefreshTypeDecorations = RefreshTypeDecorations
UITacticalWeaponSkinPage.ShowCurrentDecoration = ShowCurrentDecoration
UITacticalWeaponSkinPage.RefreshEffect = RefreshEffect
return UITacticalWeaponSkinPage
