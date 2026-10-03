local UIBuildDecoratePropPreviewView = BaseClass("UIBuildDecoratePropPreviewView", UIBaseView)
local UIDesCell_New = require("UI.UIBuildUpgrade.Component.UIDesCell_New")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local cur_level_text_path = "Content/TopArea/Content/CurLevelText"
local next_level_text_path = "Content/TopArea/Content/NextLevelText"
local content_path = "Content/Scroll View/Viewport/Content"
local top_area_path = "Content/TopArea"

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
  self.param = self:GetUserData()
  self:ReInit(self.param)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, panel_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.curLvText = self:AddComponent(UIText, cur_level_text_path)
  self.nextLvText = self:AddComponent(UIText, next_level_text_path)
  self.des_content = self:AddComponent(UIBaseContainer, content_path)
  self.topRawImg = self:AddComponent(UIRawImage, top_area_path)
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
end

local function DataDestroy(self)
  self.desCells = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIBuildDecoratePropPreviewView:ReInit(param)
  self.curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, self.param.level)
  if not self.curLevelTemplate then
    self.ctrl:CloseSelf()
    return
  end
  self.progressGroupId = self.curLevelTemplate.decoGroupUpgradeBaseId
  self.curUpgradeProgress = param.prodStatus or 0
  self.curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(self.progressGroupId, self.param.level, self.curUpgradeProgress)
  if not self.curProgressInfo then
    self.ctrl:CloseSelf()
    return
  end
  local curLevel = self.param.level
  self.curLvMaxProgress = DataCenter.DecorationUpgradeTemplateManager:GetMaxProgressInfo(self.progressGroupId, curLevel)
  if not self.curLvMaxProgress then
    self.ctrl:CloseSelf()
    return
  end
  self.curLvText:SetText(curLevel)
  self.nextLvText:SetText(curLevel + 1)
  self:InitInfoDes()
  self:RefreshTopBarImgByQuality()
end

function UIBuildDecoratePropPreviewView:RefreshTopBarImgByQuality()
  if not self.curLevelTemplate then
    return
  end
  if self.curLevelTemplate.tab_type == UIBuildListTabType.Decorate and not string.IsNullOrEmpty(self.curLevelTemplate.para3) then
    local quality = toInt(self.curLevelTemplate.para3)
    local path
    if quality == DecorationQualityNew.SSR then
      path = "Assets/Main/TextureEx/UIDecorationAdvanceUpgrade/zxl_zhuangshiwu_cheng.png"
    elseif quality == DecorationQualityNew.SR then
      path = "Assets/Main/TextureEx/UIDecorationAdvanceUpgrade/zxl_zhuangshiwu_zi.png"
    else
      path = "Assets/Main/TextureEx/UIDecorationAdvanceUpgrade/zxl_zhuangshiwu_lan.png"
    end
    self.topRawImg:LoadSprite(path)
  end
end

function UIBuildDecoratePropPreviewView:InitInfoDes()
  local groupId = self.curProgressInfo.group
  local curProgress = self.curUpgradeProgress
  local toProgress = self.curLvMaxProgress.stage_need
  local buildingId = self.param.itemId
  local level = self.param.level
  for k, v in pairs(self.desCells) do
    if v.inst ~= nil then
      self:GameObjectDestroy(v.inst)
    end
  end
  self.desCells = {}
  local paramList = BuildingUtils.GetDecorationProgressUpValue(buildingId, level, curProgress, level, toProgress)
  for i = 1, #paramList do
    paramList[i].index = i
    self:AddDesCell(paramList[i])
  end
end

function UIBuildDecoratePropPreviewView:AddDesCell(param)
  local cell = {}
  cell.param = param
  table.insert(self.desCells, cell)
  cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell_New, function(request)
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
    if 1 <= cell.param.index and cell.param.index <= table.count(self.upEffects) then
      self.upEffects[cell.param.index]:Play()
    end
    local temp = self.des_content:AddComponent(UIDesCell_New, nameStr)
    temp:ReInit(cell.param)
    cell.model = temp
  end)
end

UIBuildDecoratePropPreviewView.OnCreate = OnCreate
UIBuildDecoratePropPreviewView.OnDestroy = OnDestroy
UIBuildDecoratePropPreviewView.OnEnable = OnEnable
UIBuildDecoratePropPreviewView.OnDisable = OnDisable
UIBuildDecoratePropPreviewView.ComponentDefine = ComponentDefine
UIBuildDecoratePropPreviewView.ComponentDestroy = ComponentDestroy
UIBuildDecoratePropPreviewView.DataDefine = DataDefine
UIBuildDecoratePropPreviewView.DataDestroy = DataDestroy
UIBuildDecoratePropPreviewView.OnAddListener = OnAddListener
UIBuildDecoratePropPreviewView.OnRemoveListener = OnRemoveListener
return UIBuildDecoratePropPreviewView
