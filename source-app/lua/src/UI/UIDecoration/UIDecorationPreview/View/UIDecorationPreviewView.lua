local base = UIBaseView
local UIDecorationPreviewView = BaseClass("UIDecorationPreviewView", base)
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCityForPreview")
local Localization = CS.GameEntry.Localization
local ShowTypeContentSkinSkillBtn = require("UI.UIDecoration.UIDecorationMain.Component.ShowTypeContentSkinSkillBtn")
local SeasonCallbackInfo = require("UI.LWSeason.LWSeasonMain.Component.SeasonCallback.SeasonCallbackInfo")
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local main_city_path = "Rect_Content/MainCityContent/MainCity"
local world_type_btn_path = "Rect_Content/ShowTypeContent/worldTypeBtn"
local world_type_be_select_path = "Rect_Content/ShowTypeContent/worldTypeBtn/worldTypeBeSelect"
local city_type_btn_path = "Rect_Content/ShowTypeContent/cityTypeBtn"
local city_type_be_select_path = "Rect_Content/ShowTypeContent/cityTypeBtn/cityTypeBeSelect"
local name_text_path = "Rect_Content/EffectLeft/NameText"
local using_effect_path = "Rect_Content/InfoContent/InfoScrollView/Viewport/Content/UsingEffect"
local use_effect_text_path = "Rect_Content/InfoContent/InfoScrollView/Viewport/Content/UsingEffect/UseEffectText"
local own_effect_path = "Rect_Content/InfoContent/InfoScrollView/Viewport/Content/OwnEffect"
local own_effect_text_path = "Rect_Content/InfoContent/InfoScrollView/Viewport/Content/OwnEffect/OwnEffectText"
local use_title_path = "Rect_Content/InfoContent/InfoScrollView/Viewport/Content/UsingEffect/Title/UseTitle"
local own_title_path = "Rect_Content/InfoContent/InfoScrollView/Viewport/Content/OwnEffect/Title/OwnTitle"
local use_skill_content_path = "Rect_Content/InfoContent/UseSkillContent"
local use_skill_content_list_path = "Rect_Content/InfoContent/UseSkillContentList"
local have_tip_text_path = "Rect_Content/EffectLeft/HaveTipText"
local ui_seasonCallbackInfo_path = "Rect_Content/UISeasonCallbackInfo"
local show_season_content_path = "Rect_Content/ShowSeasonContent"
local select_img_path = "Rect_Content/ShowSeasonContent/SelectShowSeasonContent/SelectImg"
local show_season_text_path = "Rect_Content/ShowSeasonContent/ShowSeasonText"
local select_show_season_content_path = "Rect_Content/ShowSeasonContent/SelectShowSeasonContent"
local show_type_content_path = "Rect_Content/ShowTypeContent"

function UIDecorationPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReadUserData()
  self:RefreshSeasonContent()
  self:RefreshView()
end

function UIDecorationPreviewView:OnDestroy()
  self.ctrl:SetSeasonContentShow(self.showSeason)
  self:ClearAllItem()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDecorationPreviewView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.main_city = self:AddComponent(UIDecorationMainCity, main_city_path)
  self.world_type_btn = self:AddComponent(UIButton, world_type_btn_path)
  self.world_type_be_select = self:AddComponent(UIImage, world_type_be_select_path)
  self.city_type_btn = self:AddComponent(UIButton, city_type_btn_path)
  self.city_type_be_select = self:AddComponent(UIImage, city_type_be_select_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.using_effect = self:AddComponent(UIBaseContainer, using_effect_path)
  self.use_effect_text = self:AddComponent(UITextMeshProUGUIEx, use_effect_text_path)
  self.own_effect = self:AddComponent(UIBaseContainer, own_effect_path)
  self.own_effect_text = self:AddComponent(UITextMeshProUGUIEx, own_effect_text_path)
  self.use_title = self:AddComponent(UITextMeshProUGUIEx, use_title_path)
  self.own_title = self:AddComponent(UITextMeshProUGUIEx, own_title_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.world_type_btn:SetOnClick(function()
    self:OnWorldTypeBtnClick()
  end)
  self.city_type_btn:SetOnClick(function()
    self:OnCityTypeBtnClick()
  end)
  self.use_skill_content = self:AddComponent(UIButton, use_skill_content_path)
  self.use_skill_content_list = self:AddComponent(UIBaseContainer, use_skill_content_list_path)
  self.use_skill_content:SetActive(false)
  self.use_skill_content.gameObject:GameObjectCreatePool()
  self.use_skill_content_array = {}
  self.have_tip_text = self:AddComponent(UITextMeshProUGUIEx, have_tip_text_path)
  self.seasonCallbackInfo = self:AddComponent(SeasonCallbackInfo, ui_seasonCallbackInfo_path)
  self.showSeasonContent = self:AddComponent(UIBaseContainer, show_season_content_path)
  self.selectShowSeasonImage = self:AddComponent(UIBaseContainer, select_img_path)
  self.showSeasonText = self:AddComponent(UITextMeshProUGUIEx, show_season_text_path)
  self.selectShowSeasonBtn = self:AddComponent(UIButton, select_show_season_content_path)
  self.selectShowSeasonBtn:SetOnClick(function()
    self:OnClickSelectSeasonContent()
  end)
  self.show_type_content = self:AddComponent(UIImage, show_type_content_path)
  self.showSeasonContent:SetActive(false)
  self.seasonCallbackInfo:SetActive(false)
end

function UIDecorationPreviewView:ComponentDestroy()
  self.panel = nil
  self.close_btn = nil
  self.main_city = nil
  self.world_type_btn = nil
  self.world_type_be_select = nil
  self.city_type_btn = nil
  self.city_type_be_select = nil
  self.name_text = nil
  self.using_effect = nil
  self.use_effect_text = nil
  self.own_effect = nil
  self.own_effect_text = nil
  self.use_title = nil
  self.own_title = nil
  self.use_skill_content = nil
  self.use_skill_content_list = nil
  self.have_tip_text = nil
  self.seasonCallbackInfo = nil
  self.showSeasonContent = nil
  self.selectShowSeasonImage = nil
  self.showSeasonText = nil
  self.selectShowSeasonBtn = nil
  self.show_type_content = nil
end

function UIDecorationPreviewView:DataDefine()
  self.decorationId = nil
  self.zoneType = nil
  self.goodId = nil
  self.showSeason = false
  self.colorDecorationId = nil
end

function UIDecorationPreviewView:DataDestroy()
  self.decorationId = nil
  self.zoneType = nil
  self.goodId = nil
  self.showSeason = nil
  self.colorDecorationId = nil
end

function UIDecorationPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function UIDecorationPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDecorationPreviewView:ReadUserData()
  self.decorationId, self.goodId = self:GetUserData()
  self.zoneType = MainCityPreviewZoneType.World
end

function UIDecorationPreviewView:RefreshView()
  self:RefreshMainCityContent()
  self:RefreshSelectTypeBtnContent()
  self:RefreshInfoContent()
end

function UIDecorationPreviewView:RefreshMainCityContent()
  self.main_city:SetActive(true)
  self.main_city:SetRTLen(876.0)
  self.main_city:SetRtFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.main_city:ReInit({
    decorationId = self.decorationId,
    posIndex = 1,
    zoneType = self.zoneType,
    colourId = self.showSeason and self.colorDecorationId or nil,
    original = not self.showSeason
  })
end

function UIDecorationPreviewView:RefreshSelectTypeBtnContent()
  self.show_type_content:SetActive(true)
  if self.decorationId then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(self.decorationId)
    if template and template.type == DecorationType.DecorationType_TacticalWeapon then
      self.show_type_content:SetActive(false)
    end
  end
  self.world_type_be_select:SetActive(self.zoneType == MainCityPreviewZoneType.World)
  self.city_type_be_select:SetActive(self.zoneType == MainCityPreviewZoneType.City)
  local isSkillBtnShow = false
  local skillList = DataCenter.DecorationDataManager:GetDecorationSkillIdList(self.decorationId, true)
  if 0 < #skillList and self.zoneType == MainCityPreviewZoneType.World then
    isSkillBtnShow = true
  end
  self.use_skill_content_list:SetActive(isSkillBtnShow)
  if isSkillBtnShow then
    self:RefreshSkillsView(skillList)
  end
end

function UIDecorationPreviewView:RefreshSkillsView(skillList)
  if skillList == nil or #skillList <= 0 then
    return
  end
  for i, v in ipairs(skillList) do
    if self.use_skill_content_array[i] == nil then
      local showIndex = "Item" .. i
      local item = self.use_skill_content.gameObject:GameObjectSpawn(self.use_skill_content_list.transform)
      item.name = showIndex
      local obj = self.use_skill_content_list:AddComponent(ShowTypeContentSkinSkillBtn, item.name)
      obj:ReInit(function(skillId)
        self:OnUseSkillContentClick(skillId)
      end)
      self.use_skill_content_array[i] = obj
    end
    self.use_skill_content_array[i]:SetActive(true)
    self.use_skill_content_array[i]:SetData(v)
  end
  for i = #skillList + 1, #self.use_skill_content_array do
    self.use_skill_content_array[i]:SetActive(false)
  end
end

function UIDecorationPreviewView:ClearAllItem()
  self.use_skill_content_list:RemoveComponents(ShowTypeContentSkinSkillBtn)
  for _, v in ipairs(self.use_skill_content_list.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.use_skill_content.gameObject:GameObjectRecycleAll()
  self.use_skill_content_array = {}
end

function UIDecorationPreviewView:RefreshInfoContent()
  local effectData = DecorationUtil.GetEffectDesc(self.decorationId, "#099b4a", "#f53c3d")
  local showName = effectData.name
  if self.goodId then
    local goodId = tonumber(self.goodId) or 0
    local goodData = DataCenter.ItemTemplateManager:GetItemTemplate(goodId)
    if goodData then
      showName = goodData:GetName()
    end
  end
  self.name_text:SetText(showName)
  local isEternal = false
  local eternalType = GoodsType113DecorationEternalType.None
  isEternal, eternalType = DataCenter.ItemTemplateManager:CheckDecorationEternalByGoodsType113ID(self.goodId)
  if isEternal then
    self.have_tip_text:SetActive(true)
    local strKey = "optional_chest_desc01"
    if eternalType == GoodsType113DecorationEternalType.HaveGoods then
      strKey = "worker_hall_desc6"
    end
    self.have_tip_text:SetLocalText(strKey)
  else
    self.have_tip_text:SetActive(false)
  end
  local ownEffectStr = effectData.ownEffect
  self.own_effect_text:SetText(ownEffectStr)
  local useEffectStr = effectData.useEffect
  self.use_effect_text:SetText(useEffectStr)
  self.use_title:SetActive(not string.IsNullOrEmpty(useEffectStr))
  self.own_title:SetActive(not string.IsNullOrEmpty(ownEffectStr))
end

function UIDecorationPreviewView:OnWorldTypeBtnClick()
  if self.zoneType == MainCityPreviewZoneType.World then
    return
  end
  self.zoneType = MainCityPreviewZoneType.World
  self:RefreshView()
end

function UIDecorationPreviewView:OnCityTypeBtnClick()
  if self.zoneType == MainCityPreviewZoneType.City then
    return
  end
  self.zoneType = MainCityPreviewZoneType.City
  self:RefreshView()
end

function UIDecorationPreviewView:RefreshSeasonContent()
  if not self.goodId or not self.decorationId then
    return
  end
  local showSwitch, colorDecorationId, activityOpen, isSpecialPeriod = self.ctrl:IfShowSeasonSwitch(self.goodId, self.decorationId)
  if showSwitch and not string.IsNullOrEmpty(colorDecorationId) then
    self.showSeasonContent:SetActive(true)
    self.colorDecorationId = colorDecorationId
    if isSpecialPeriod then
      local seasonData = self.ctrl:GetCallBackInfoByDecorationId(self.decorationId)
      self.seasonCallbackInfo:TrySetItemByData(seasonData, nil, UISeasonCallBackInfoOpenType.DecorationPreview, activityOpen)
    else
      self.seasonCallbackInfo:TrySetItemById(SeasonCallbackType.Base, self.decorationId, nil, UISeasonCallBackInfoOpenType.DecorationPreview, activityOpen, true)
    end
    local season = SeasonUtil.GetSeason()
    if SeasonUtil.IsInSeasonPrepareMode() or not activityOpen then
      season = season + 1
    end
    self.showSeasonText:SetText(Localization:GetString("skin_preview_desc2", season))
    self.showSeason = self.ctrl:IfShowSeasonContent()
    self:ShowSeasonContent()
  else
    self.showSeasonContent:SetActive(false)
    self.seasonCallbackInfo:SetActive(false)
  end
end

function UIDecorationPreviewView:ShowSeasonContent()
  self.selectShowSeasonImage.gameObject:SetActive(self.showSeason)
  self.seasonCallbackInfo:SetActive(self.showSeason)
end

function UIDecorationPreviewView:OnClickSelectSeasonContent()
  self.showSeason = not self.showSeason
  self:ShowSeasonContent()
  self:RefreshView()
end

function UIDecorationPreviewView:OnUseSkillContentClick(skillId)
  self.main_city:TryPlaySkillShow(skillId)
end

return UIDecorationPreviewView
