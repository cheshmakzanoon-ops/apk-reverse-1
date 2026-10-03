local UILWMummyMainItemLockS6 = BaseClass("UILWMummyMainItemLockS6", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local desc_text_path = "Content/DescText"
local cell1_path = "Content/Cell1"
local icon1_path = "Content/Cell1/icon1"
local title1_path = "Content/Cell1/title1"
local desc1_path = "Content/Cell1/desc1"
local cell2_path = "Content/Cell2"
local icon2_path = "Content/Cell2/icon2"
local title2_path = "Content/Cell2/title2"
local desc2_path = "Content/Cell2/desc2"
local btn_build_path = "Content/Cell2/BtnBuild"
local go_text_path = "Content/Cell2/BtnBuild/GoText"
local btn_info_path = "Content/Cell2/BtnInfo"

function UILWMummyMainItemLockS6:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMummyMainItemLockS6:ComponentDefine()
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.cell1 = self:AddComponent(UIImage, cell1_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.desc1 = self:AddComponent(UITextMeshProUGUIEx, desc1_path)
  self.cell2 = self:AddComponent(UIImage, cell2_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.desc2 = self:AddComponent(UITextMeshProUGUIEx, desc2_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_build = self:AddComponent(UIButton, btn_build_path)
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.btn_build:SetOnClick(function()
    if not SeasonUtil.IsInSeason() then
      return
    end
    local v94069 = LuaEntry.Effect:GetGameEffect(94069)
    if v94069 == 0 then
      v94069 = DataCenter.LWSeasonTrendsManager:GetEffectValue(94069)
    end
    if v94069 == 0 then
      GoToUtil.GoToByTypeAndParam(QuestGoType.GoSeasonTrendMain, nil)
    else
      local buildId = SeasonUtil.GetMummyYardBuildingId()
      local data = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(buildId)
      if data and data.uuid then
        self.view.ctrl:CloseSelf()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, data.uuid)
      else
        GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_Upgrade)
      end
    end
  end)
  self.btn_info:SetOnClick(function()
    if self.info_language_id then
      local msg = Localization:GetString(self.info_language_id)
      UIUtil.ShowDetail(msg, nil, nil, false, true)
    end
  end)
end

function UILWMummyMainItemLockS6:OnDestroy()
  self.desc_text = nil
  self.cell1 = nil
  self.icon1 = nil
  self.title1 = nil
  self.desc1 = nil
  self.cell2 = nil
  self.icon2 = nil
  self.title2 = nil
  self.desc2 = nil
  self.btn_build = nil
  self.go_text = nil
  self.btn_info = nil
  base.OnDestroy(self)
end

function UILWMummyMainItemLockS6:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local isInSeason = SeasonUtil.IsInSeason(false)
  local v94069 = LuaEntry.Effect:GetGameEffect(94069)
  if v94069 == 0 then
    v94069 = DataCenter.LWSeasonTrendsManager:GetEffectValue(94069)
  end
  if v94069 == 0 then
    self.go_text:SetLocalText(211251)
  else
    self.go_text:SetLocalText(2000325)
  end
  self.info_language_id = nil
  if isInSeason then
    self.desc_text:SetLocalText("season_s3_Mummy_ui_info04")
    CS.UIGray.SetGray(self.btn_build.transform, false, true)
  else
    self.desc_text:SetLocalText("season_s3_building_tips01")
    CS.UIGray.SetGray(self.btn_build.transform, true, false)
  end
  local soldierLevelMap = DataCenter.SoldierDataManager:GetMummyLevelMap()
  if soldierLevelMap then
    local minLevel
    for k, v in pairs(soldierLevelMap) do
      if minLevel == nil or minLevel.lv > v.lv then
        minLevel = v
      end
    end
    if minLevel and minLevel.resourceItemId then
      local meta = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(minLevel.resourceItemId)
      if meta then
        self.title1:SetLocalText(meta.name)
        self.desc1:SetLocalText(meta.desc)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cell1.transform)
      end
    end
  end
  local effectTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(EffectDefine.SEASON_MUMMY_GROUND_BUILD_EFFECT_ID)
  if effectTemplate then
    self.title2:SetLocalText(effectTemplate.name)
    self.desc2:SetLocalText(effectTemplate.desc)
    self.info_language_id = effectTemplate.info
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.cell2.transform)
  end
  self.btn_info:SetActive(self.info_language_id ~= nil)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

return UILWMummyMainItemLockS6
