local UIDecoUnlockStarView = BaseClass("UIDecoUnlockStarView", UIBaseView)
local DescCell = require("UI.UIBuildDecoUnlockStar.Component.DecoStarUnlockDesc")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "Content/Panel"
local info_path = "Content/InfoScrollView/ViewPort/info"
local star_1_path = "Content/VFX_star/Star_1"
local star_2_path = "Content/VFX_star/Star_2"
local star_3_path = "Content/VFX_star/Star_3"
local star_path = "Content/Star"
local block_click_area_path = "Content/BlockClickArea"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.data = self:GetUserData()
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  local closeBtn = self:AddComponent(UIButton, panel_path)
  closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.des_content = self:AddComponent(UIBaseContainer, info_path)
  self.starObj1 = self:AddComponent(UIBaseContainer, star_1_path)
  self.starObj2 = self:AddComponent(UIBaseContainer, star_2_path)
  self.starObj3 = self:AddComponent(UIBaseContainer, star_3_path)
  self.starImg = self:AddComponent(UIImage, star_path)
  self.clockAreaObj = self:AddComponent(UIBaseContainer, block_click_area_path)
end

local function ComponentDestroy(self)
  if self.desCells then
    for _, v in ipairs(self.desCells) do
      v.inst:Destroy()
    end
  end
  self.desCells = nil
end

local function DataDefine(self)
  self.desCells = {}
  self.allStarObjList = {}
  table.insert(self.allStarObjList, self.starObj1)
  table.insert(self.allStarObjList, self.starObj2)
  table.insert(self.allStarObjList, self.starObj3)
end

local function DataDestroy(self)
  self.desCells = nil
  self.allStarObjList = nil
  if self.hideBlockAreaTimer then
    self.hideBlockAreaTimer:Stop()
    self.hideBlockAreaTimer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIDecoUnlockStarView:ReInit()
  for k, v in pairs(self.desCells) do
    if v.inst ~= nil then
      self:GameObjectDestroy(v.inst)
    end
  end
  local buildingId = self.data.buildingId
  local level = self.data.level
  local oldProgress = self.data.fromProgress
  local newProgress = self.data.toProgress
  self.desCells = {}
  self.paramList = BuildingUtils.GetDecorationProgressUpValue(buildingId, level, oldProgress, level, newProgress)
  for i = 1, #self.paramList do
    self.paramList[i].index = i
    self:AddDesCell(i, self.paramList[i])
  end
  local curProgressIndex = 0
  local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingId, level)
  if curLevelTemplate then
    local groupId = curLevelTemplate.decoGroupUpgradeBaseId
    local newProgressData = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, level, newProgress)
    if newProgressData then
      curProgressIndex = newProgressData.progressIndex
      if not string.IsNullOrEmpty(newProgressData.stage_icon) then
        self.starImg:LoadSprite(newProgressData.stage_icon)
      end
    end
  end
  for _, v in ipairs(self.allStarObjList) do
    v:SetActive(false)
  end
  if self.allStarObjList[curProgressIndex] then
    self.allStarObjList[curProgressIndex]:SetActive(true)
  else
    self.allStarObjList[#self.allStarObjList]:SetActive(true)
  end
  if self.hideBlockAreaTimer then
    self.hideBlockAreaTimer:Stop()
    self.hideBlockAreaTimer = nil
  end
  self.clockAreaObj:SetActive(true)
  self.hideBlockAreaTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.clockAreaObj:SetActive(false)
  end, 1)
end

function UIDecoUnlockStarView:AddDesCell(index, param)
  local cell = {}
  cell.param = param
  table.insert(self.desCells, cell)
  cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell4DecoStarPanel, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.des_content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:SetAsLastSibling()
    local nameStr = tostring(NameCount)
    go.name = nameStr
    NameCount = NameCount + 1
    local temp = self.des_content:AddComponent(DescCell, nameStr)
    temp:ReInit(index, cell.param)
    cell.model = temp
  end)
end

UIDecoUnlockStarView.OnCreate = OnCreate
UIDecoUnlockStarView.OnDestroy = OnDestroy
UIDecoUnlockStarView.OnEnable = OnEnable
UIDecoUnlockStarView.OnDisable = OnDisable
UIDecoUnlockStarView.ComponentDefine = ComponentDefine
UIDecoUnlockStarView.ComponentDestroy = ComponentDestroy
UIDecoUnlockStarView.DataDefine = DataDefine
UIDecoUnlockStarView.DataDestroy = DataDestroy
UIDecoUnlockStarView.OnAddListener = OnAddListener
UIDecoUnlockStarView.OnRemoveListener = OnRemoveListener
return UIDecoUnlockStarView
