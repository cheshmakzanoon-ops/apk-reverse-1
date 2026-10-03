local UIWorkerCell = BaseClass("UIWorkerCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.skillData = nil
  self.workerUuid = nil
  self.callback = nil
  self.heroData = nil
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
  self.nameText = self:AddComponent(UIText, "Root/WorkerNameText")
  self.redPoint = self:AddComponent(UIBaseContainer, "Root/NodeRedPoint")
  self.qualityBg = self:AddComponent(UIImage, "Root/Bg/LayerNormal/ImgBg")
  self.icon = self:AddComponent(UIImage, "Root/Bg/LayerNormal/ImgBg/Mask/ImgIcon1")
  self.idleIcon = self:AddComponent(UIImage, "Root/IdleIcon")
  self.workIcon = self:AddComponent(UIImage, "Root/WorkIcon")
  self.clickBtn = self:AddComponent(UIButton, "")
  self.clickBtn:SetOnClick(BindCallback(self, self.OnClickSelf))
  self.selectedFrame = self:AddComponent(UIImage, "Root/SelectedFrame")
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.redPoint = nil
  self.qualityBg = nil
  self.icon = nil
  self.enableRedPoint = nil
  self.idleIcon = nil
  self.workIcon = nil
  self.clickBtn = nil
  self.selectedFrame = nil
end

local function SetData(self, workerUuid, callback)
  if workerUuid == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.callback = callback
  self.uuid = workerUuid
  local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(workerUuid)
  if workerData == nil then
    return
  end
  self.icon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(workerData.modelId, HeroIconType.half_portrait))
  self.nameText:SetText(workerData:GetName())
  self.qualityBg:LoadSprite(WorkerUtil.GetWorkerQualityBg(workerData.quality))
  if workerData.state == WorkerState.RESIDENTA then
    self.idleIcon:SetActive(true)
    self.workIcon:SetActive(false)
  elseif workerData.state == WorkerState.WORKER and workerData.dispatchingBuildUid ~= nil then
    self.idleIcon:SetActive(false)
    self.workIcon:SetActive(true)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(workerData.dispatchingBuildUid)
    if buildData ~= nil then
      if buildData.itemId == BuildingTypes.LW_BUILD_FARMLAND then
        self.workIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIWorker/cfm_gongren_icon_2.png")
      elseif buildData.itemId == BuildingTypes.LW_BUILD_BAKERY then
        self.workIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIWorker/cfm_gongren_icon_1.png")
      elseif buildData.itemId == BuildingTypes.LW_BUILD_QUARRY then
        self.workIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIWorker/cfm_gongren_icon_3.png")
      elseif buildData.itemId == BuildingTypes.LW_BUILD_TRADING_POST then
        self.workIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIWorker/cfm_gongren_icon_4.png")
      elseif buildData.itemId == BuildingTypes.LW_BUILD_IRON_MILL then
        self.workIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIWorker/cfm_gongren_icon_5.png")
      elseif buildData.itemId == BuildingTypes.LW_BUILD_STEEL_MILL then
        self.workIcon:LoadSprite("Assets/Main/Sprites/UI/LWUIWorker/cfm_gongren_icon_6.png")
      elseif buildData.itemId == BuildingTypes.LW_BUILD_MILITARY_CAMP then
        local SoldierDataTemplate = DataCenter.SoldierDataManager:GetSoldierTemplateByLevel(1)
        if SoldierDataTemplate ~= nil then
          self.workIcon:LoadSprite(string.format(LoadPath.ItemPath, SoldierDataTemplate.icon))
        end
      end
    end
  end
end

local function EnableRedPoint(self)
  self.enableRedPoint = true
end

local function DisableRedPoint(self)
  self.enableRedPoint = false
end

local function OnClickSelf(self)
  if self.callback ~= nil then
    self.callback(self.uuid, self)
  end
end

local function SetSelected(self, selected)
  self.selectedFrame:SetActive(selected)
  self.selected = selected
end

UIWorkerCell.OnCreate = OnCreate
UIWorkerCell.OnDestroy = OnDestroy
UIWorkerCell.OnEnable = OnEnable
UIWorkerCell.OnDisable = OnDisable
UIWorkerCell.DataDefine = DataDefine
UIWorkerCell.DataDestroy = DataDestroy
UIWorkerCell.ComponentDefine = ComponentDefine
UIWorkerCell.ComponentDestroy = ComponentDestroy
UIWorkerCell.SetData = SetData
UIWorkerCell.OnClickSelf = OnClickSelf
UIWorkerCell.EnableRedPoint = EnableRedPoint
UIWorkerCell.DisableRedPoint = DisableRedPoint
UIWorkerCell.SetSelected = SetSelected
return UIWorkerCell
