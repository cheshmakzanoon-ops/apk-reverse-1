local UITWSkillChipDescriptionContainer = BaseClass("UITWSkillChipDescriptionContainer", UIBaseContainer)
local base = UIBaseContainer
local UITWSkillChipDescriptionPage = require("UI.UILWTWSkillChip.UILWTWSkillChipBook.Component.UITWSkillChipDescriptionPage")
local left_arrow_path = "leftArrow"
local right_arrow_path = "rightArrow"
local page_point_path = "pagePoint"
local page_points_path = "pagePoints"
local page_cell_path = "pageCell"
local page_scroll_path = "pageScroll"
local content_path = "pageScroll/viewport/content"
local DESCRPTION_DATA = {
  [1] = {
    txt = "uav_chips_desc2",
    img = "Assets/Main/TextureEx/LWUITacticalWeapon/SkillChipDescription/FX_WRJ_chatu01.png"
  },
  [2] = {
    txt = "uav_chips_desc3",
    img = "Assets/Main/TextureEx/LWUITacticalWeapon/SkillChipDescription/FX_WRJ_chatu02.png"
  },
  [3] = {
    txt = "uav_chips_desc4",
    img = "Assets/Main/TextureEx/LWUITacticalWeapon/SkillChipDescription/FX_WRJ_chatu03.png"
  },
  [4] = {
    txt = "uav_chips_desc5",
    img = "Assets/Main/TextureEx/LWUITacticalWeapon/SkillChipDescription/FX_WRJ_chatu04.png"
  },
  [5] = {
    txt = "uav_chips_desc6",
    img = "Assets/Main/TextureEx/LWUITacticalWeapon/SkillChipDescription/FX_WRJ_chatu05.png"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.page_points:RemoveComponents(UIToggle)
  self.content:RemoveComponents(UITWSkillChipDescriptionPage)
  if self.page_point_obj then
    self.page_point_obj:GameObjectRecycleAll()
  end
  if self.page_cell_obj then
    self.page_cell_obj:GameObjectRecycleAll()
  end
  self.pageCells = nil
  self.pagePoints = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.pageCells = {}
  self.pagePoints = {}
end

local function DataDestroy(self)
  self.hasInit = nil
end

local function Init(self)
  if self.hasInit then
    return
  end
  self.hasInit = true
  self.curPage = 1
  for i = 1, #DESCRPTION_DATA do
    local page = self.page_cell_obj:GameObjectSpawn(self.content.transform)
    local pageName = string.format("page_%s", i)
    page.name = pageName
    page:SetActive(true)
    local pageScript = self.content:AddComponent(UITWSkillChipDescriptionPage, pageName)
    pageScript:SetData(DESCRPTION_DATA[i].txt, DESCRPTION_DATA[i].img)
    self.pageCells[i] = pageScript
    local point = self.page_point_obj:GameObjectSpawn(self.page_points.transform)
    local pointName = string.format("point_%s", i)
    point.name = pointName
    local pointScript = self.page_points:AddComponent(UIToggle, pointName)
    local index = i
    pointScript:SetOnValueChanged(function(tf)
      if tf then
        self.page_scroll:PageTo(index)
        self:OnPageChanged(index)
      end
    end)
    self.pagePoints[i] = pointScript
  end
  self.page_scroll:SetPageCount(#DESCRPTION_DATA)
  self.page_scroll:PageTo(1)
  self.pagePoints[1]:SetIsOn(true)
  self.left_arrow:SetActive(false)
  self.right_arrow:SetActive(1 < #DESCRPTION_DATA)
end

local function OnPageChanged(self, index)
  self.curPage = index
  self.pagePoints[index]:SetIsOn(true)
  self.left_arrow:SetActive(self.curPage > 1)
  self.right_arrow:SetActive(self.curPage < #DESCRPTION_DATA)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.left_arrow = self:AddComponent(UIButton, left_arrow_path)
  self.right_arrow = self:AddComponent(UIButton, right_arrow_path)
  self.page_point = self:AddComponent(UIBaseContainer, page_point_path)
  self.page_point_obj = self.page_point.transform.gameObject
  self.page_point_obj:GameObjectCreatePool()
  self.page_points = self:AddComponent(UIBaseContainer, page_points_path)
  self.page_cell = self:AddComponent(UIBaseContainer, page_cell_path)
  self.page_cell_obj = self.page_cell.transform.gameObject
  self.page_cell_obj:GameObjectCreatePool()
  self.page_scroll = self:AddComponent(UIScrollPage, page_scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.page_scroll:SetPageChangedCallback(BindCallback(self, OnPageChanged))
  self.left_arrow:SetOnClick(function()
    self.page_scroll:ToPrevPage()
    OnPageChanged(self, self.page_scroll.currentPageIndex)
  end)
  self.right_arrow:SetOnClick(function()
    self.page_scroll:ToNextPage()
    OnPageChanged(self, self.page_scroll.currentPageIndex)
  end)
  self.left_arrow:SetActive(false)
  self.right_arrow:SetActive(false)
end

local function ComponentDestroy(self)
end

UITWSkillChipDescriptionContainer.OnCreate = OnCreate
UITWSkillChipDescriptionContainer.OnDestroy = OnDestroy
UITWSkillChipDescriptionContainer.OnEnable = OnEnable
UITWSkillChipDescriptionContainer.OnDisable = OnDisable
UITWSkillChipDescriptionContainer.DataDefine = DataDefine
UITWSkillChipDescriptionContainer.DataDestroy = DataDestroy
UITWSkillChipDescriptionContainer.ComponentDefine = ComponentDefine
UITWSkillChipDescriptionContainer.ComponentDestroy = ComponentDestroy
UITWSkillChipDescriptionContainer.Init = Init
UITWSkillChipDescriptionContainer.OnPageChanged = OnPageChanged
return UITWSkillChipDescriptionContainer
