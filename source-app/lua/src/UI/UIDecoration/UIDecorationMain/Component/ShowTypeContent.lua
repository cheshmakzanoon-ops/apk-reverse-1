local ShowTypeContent = BaseClass("ShowTypeContent", UIBaseContainer)
local base = UIBaseContainer
local ShowTypeContentSkinSkillBtn = require("UI.UIDecoration.UIDecorationMain.Component.ShowTypeContentSkinSkillBtn")
local world_type_btn_path = "worldTypeBtn"
local world_type_be_select_path = "worldTypeBtn/worldTypeBeSelect"
local city_type_btn_path = "cityTypeBtn"
local city_type_be_select_path = "cityTypeBtn/cityTypeBeSelect"
local use_skill_content_path = "UseSkillContent"
local use_skill_content_list_path = "UseSkillContentList"
local dazzle_btn_path = "dazzleBtn"
local dazzle_icon_path = "dazzleBtn/Icon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAllItem()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.world_type_btn = self:AddComponent(UIButton, world_type_btn_path)
  self.world_type_be_select = self:AddComponent(UIImage, world_type_be_select_path)
  self.city_type_btn = self:AddComponent(UIButton, city_type_btn_path)
  self.city_type_be_select = self:AddComponent(UIImage, city_type_be_select_path)
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
  self.dazzle_btn = self:AddComponent(UIButton, dazzle_btn_path)
  self.dazzle_btn:SetOnClick(function()
    self:OnDazzleBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.root = nil
  self.world_type_btn = nil
  self.world_type_be_select = nil
  self.city_type_btn = nil
  self.city_type_be_select = nil
  self.use_skill_content = nil
  self.use_skill_content_list = nil
end

local function DataDefine(self)
  self.zoneType = MainCityPreviewZoneType.World
  self.changeTypeFunc = nil
  self.playSkillFunc = nil
  self.currentSelectType = nil
  self.currentSelectDecoration = nil
end

local function DataDestroy(self)
  self.zoneType = nil
  self.changeTypeFunc = nil
  self.playSkillFunc = nil
  self.currentSelectType = nil
  self.currentSelectDecoration = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, changeTypeFunc, playSkillFunc)
  self.changeTypeFunc = changeTypeFunc
  self.playSkillFunc = playSkillFunc
end

local function SetData(self, currentSelectType, currentSelectDecoration)
  self.zoneType = MainCityPreviewZoneType.World
  self.currentSelectType = currentSelectType
  self.currentSelectDecoration = currentSelectDecoration
  self:RefreshView()
end

local function RefreshView(self)
  if self.currentSelectType == DecorationType.DecorationType_Main_City then
    self.root:SetActive(true)
    self.world_type_be_select:SetActive(self.zoneType == MainCityPreviewZoneType.World)
    self.city_type_be_select:SetActive(self.zoneType == MainCityPreviewZoneType.City)
    local isSkillBtnShow = false
    local skillList = DataCenter.DecorationDataManager:GetDecorationSkillIdList(self.currentSelectDecoration)
    if 0 < #skillList and self.zoneType == MainCityPreviewZoneType.World then
      isSkillBtnShow = true
    end
    self.use_skill_content_list:SetActive(isSkillBtnShow)
    if isSkillBtnShow then
      self:RefreshSkillsView(skillList)
    end
    if DataCenter.DecorationDazzleManager:HasDazzleSkin(self.currentSelectDecoration, true) then
      self.dazzle_btn:SetActive(true)
      if not self.dazzle_icon then
        self.dazzle_icon = self:AddComponent(UIVfx, dazzle_icon_path, VfxAssets.DecorationDazzleBtn, {
          lifeType = UIVfxLifeType.Stay
        })
      end
      self.dazzle_icon:Replay()
    else
      self.dazzle_btn:SetActive(false)
    end
  else
    self.root:SetActive(false)
  end
end

local function RefreshSkillsView(self, skillList)
  if skillList == nil or #skillList <= 0 then
    return
  end
  for i, v in ipairs(skillList) do
    if self.use_skill_content_array[i] == nil then
      local showIndex = "Item" .. i
      local item = self.use_skill_content.gameObject:GameObjectSpawn(self.use_skill_content_list.transform)
      item.name = showIndex
      local obj = self.use_skill_content_list:AddComponent(ShowTypeContentSkinSkillBtn, item.name)
      obj:ReInit(self.playSkillFunc)
      self.use_skill_content_array[i] = obj
    end
    self.use_skill_content_array[i]:SetActive(true)
    self.use_skill_content_array[i]:SetData(v)
  end
  for i = #skillList + 1, #self.use_skill_content_array do
    self.use_skill_content_array[i]:SetActive(false)
  end
end

local function ClearAllItem(self)
  self.use_skill_content_list:RemoveComponents(ShowTypeContentSkinSkillBtn)
  for _, v in ipairs(self.use_skill_content_list.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.use_skill_content.gameObject:GameObjectRecycleAll()
  self.use_skill_content_array = {}
end

local function OnWorldTypeBtnClick(self)
  if self.zoneType == MainCityPreviewZoneType.World then
    return
  end
  self.zoneType = MainCityPreviewZoneType.World
  self:RefreshView()
  if self.changeTypeFunc then
    self.changeTypeFunc()
  end
end

local function OnCityTypeBtnClick(self)
  if self.zoneType == MainCityPreviewZoneType.City then
    return
  end
  self.zoneType = MainCityPreviewZoneType.City
  self:RefreshView()
  if self.changeTypeFunc then
    self.changeTypeFunc()
  end
end

local function OnDazzleBtnClick(self)
  local dazzleList = DataCenter.DecorationDazzleManager:GetDazzleSkinListShow(self.currentSelectDecoration, true)
  if table.IsNullOrEmpty(dazzleList) then
    return
  end
  local param = {}
  param.width = 576
  param.alignObject = self.dazzle_btn.transform
  param.showArrow = true
  param.addPosX = -70
  param.showList = dazzleList
  param.decorationId = self.currentSelectDecoration
  param.tipsText = CS.GameEntry.Localization:GetString("decoration_colorful_skin_UI_2")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationDazzleTips, {anim = true}, param)
end

ShowTypeContent.OnCreate = OnCreate
ShowTypeContent.OnDestroy = OnDestroy
ShowTypeContent.OnEnable = OnEnable
ShowTypeContent.OnDisable = OnDisable
ShowTypeContent.ComponentDefine = ComponentDefine
ShowTypeContent.ComponentDestroy = ComponentDestroy
ShowTypeContent.DataDefine = DataDefine
ShowTypeContent.DataDestroy = DataDestroy
ShowTypeContent.ReInit = ReInit
ShowTypeContent.SetData = SetData
ShowTypeContent.RefreshView = RefreshView
ShowTypeContent.OnWorldTypeBtnClick = OnWorldTypeBtnClick
ShowTypeContent.OnCityTypeBtnClick = OnCityTypeBtnClick
ShowTypeContent.OnDazzleBtnClick = OnDazzleBtnClick
ShowTypeContent.RefreshSkillsView = RefreshSkillsView
ShowTypeContent.ClearAllItem = ClearAllItem
return ShowTypeContent
