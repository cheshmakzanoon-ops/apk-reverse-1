local UIBuildDecorateCell = BaseClass("UIBuildDecorateCell", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local base = UIBaseContainer

function UIBuildDecorateCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIBuildDecorateCell:OnDestroy()
  self:ComponentDestroy()
  self.param = nil
  self.isBuiltMax = nil
  base.OnDestroy(self)
end

function UIBuildDecorateCell:OnEnable()
  base.OnEnable(self)
end

function UIBuildDecorateCell:OnDisable()
  base.OnDisable(self)
end

function UIBuildDecorateCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.build_bg = self:AddComponent(UIImage, "")
  self.name = self:AddComponent(UIText, "decorateName")
  self.icon = self:AddComponent(UIImage, "decorateIcon")
  self.des = self:AddComponent(UIText, "decorateDes")
  self.level = self:AddComponent(UIText, "BottomContent/infoBg/level")
  self.upBtn = self:AddComponent(UIButton, "up")
  self.buildValue = self:AddComponent(UIText, "BottomContent/infoBg/buildCount")
  self.priceBg = self:AddComponent(UIBaseContainer, "BottomContent/priceBg")
  self.priceCotent = self:AddComponent(UIBaseContainer, "BottomContent/priceBg/PriceContent")
  self.piceImage = self:AddComponent(UIImage, "BottomContent/priceBg/PriceContent/pice/piceIcon")
  self.piceText = self:AddComponent(UIText, "BottomContent/priceBg/PriceContent/pice")
  self.redDot = self:AddComponent(UIBaseContainer, "redDot")
  self.redDotText = self:AddComponent(UIText, "redDot/Bg/Text")
  self.redDotText:SetLocalText(458557)
  self.btn:SetOnClick(function()
    self:OnSelectBtnClick()
  end)
  self.upBtn:SetOnClick(function()
    local uuid = self.param.buildDataList[1].uuid
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, uuid)
  end)
end

function UIBuildDecorateCell:ReInit(param)
  if param == nil then
    return
  end
  self.param = param
  local buildId
  local itemId = self.param.buildId // BuildLevelCap * BuildLevelCap
  self.upBtn:SetActive(false)
  if self.param.isBuy then
    buildId = self.param.buildTemplate.id
    self.needRes = self.param.buildTemplate.needResource[1]
    self.priceBg:SetActive(true)
    self.piceImage:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.needRes.resourceType))
    local haveCount = LuaEntry.Resource:GetCntByResType(self.needRes.resourceType)
    if haveCount < self.needRes.count then
      self.piceText:SetText(string.format("<color=#F97077>%d</color>", self.needRes.notDerateCount))
    else
      self.piceText:SetText(self.needRes.notDerateCount)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.priceCotent.transform)
  else
    buildId = self.param.buildTemplate.id
    self.priceBg:SetActive(false)
    local isCanBuyDecorator = self.param.buildTemplate.needResource and #self.param.buildTemplate.needResource > 0
    if self.param.buildDataList and not isCanBuyDecorator then
      local list = BuildingUtils.GetDecorateUpLevelBuilds(self.param.buildDataList[1])
      if list and not list[#list].nextScore then
        self.upBtn:SetActive(true)
      end
    end
  end
  self.name:SetText(string.format(BuildingUtils.GetDecorateColor(buildId), Localization:GetString(self.param.buildTemplate.name)))
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if template then
    local number = template.unlockBuildInfo[1].canBuildNun
    local listBuilds = self:GetBuildList(itemId, true)
    local totalListBuilds = self:GetBuildList(itemId, false)
    local count = listBuilds and #listBuilds or 0
    local totalHaveCount = totalListBuilds and #totalListBuilds or 0
    local level = buildId % BuildLevelCap
    if self.param.isBuy then
      self.buildValue:SetText(totalHaveCount .. "/" .. number)
    else
      self.buildValue:SetText(count .. "/" .. math.min(number, totalHaveCount))
    end
    local isBuiltMax = false
    if not self.param.isBuy then
      local foldUpCount = BuildingUtils.GetDecorateCountByLevel(itemId, level)
      isBuiltMax = number <= count or foldUpCount <= 0
    else
      isBuiltMax = number <= totalHaveCount
    end
    self.isBuiltMax = isBuiltMax
    self.build_bg:LoadSprite(string.format(LoadPath.UILWBuild, isBuiltMax and "chengjian_lzh_tanchuang_hui_bg" or "chengjian_lzh_tanchuang_lan_bg"))
    local state = DataCenter.BuildManager:GetBuildState(buildId)
    local showRedDot = DataCenter.BuildManager:IsDecorateBuildingShowRedDotByTemplateAndState(template, state)
    self.redDot:SetActive(showRedDot)
    if showRedDot == true then
      DataCenter.BuildManager:SetBuildRedDotOnce(buildId)
    end
  end
  local baseBuildingId = CommonUtil.GetBuildBaseType(buildId)
  local maxLevelBuildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
  if maxLevelBuildData ~= nil then
    self.level:SetText("LV." .. maxLevelBuildData.level)
  else
    self.level:SetText("LV." .. 1)
  end
  self.des:SetText("")
  for id, vlaue in pairs(self.param.buildTemplate.building_effect_last) do
    local des, value = WorkerUtil.GetEffectText(id, vlaue, true)
    local va = string.format("<color=#1D6A0D>%s</color>", value)
    self.des:SetText(des .. va)
  end
  self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId // BuildLevelCap * BuildLevelCap, 1), DefaultImage)
end

function UIBuildDecorateCell:GetBuildList(buildId, isIgnoreFoldUp)
  local list = DataCenter.BuildManager.buildIdBuilding[buildId]
  local tempList = {}
  if list ~= nil then
    for k, v in ipairs(list) do
      if isIgnoreFoldUp then
        if v.state ~= BuildingStateType.FoldUp then
          table.insert(tempList, v)
        end
      else
        table.insert(tempList, v)
      end
    end
  end
  return tempList
end

function UIBuildDecorateCell:OnSelectBtnClick()
  local itemId = self.param.buildId // BuildLevelCap * BuildLevelCap
  if itemId then
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
    local listBuilds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(itemId)
    local level = self.param.buildId % BuildLevelCap
    local foldUpCount = BuildingUtils.GetDecorateCountByLevel(itemId, level)
    if table.count(listBuilds) >= template:GetCurMaxCanBuildNum() then
      UIUtil.ShowTips(Localization:GetString(100555))
      return
    elseif foldUpCount <= 0 and not self.param.isBuy then
      UIUtil.ShowTips(Localization:GetString("building_center_tips4"))
      return
    end
  end
  if self.param.isBuy then
    local totalListBuilds = self:GetBuildList(itemId, false)
    local totalBuildHaveCount = totalListBuilds and #totalListBuilds or 0
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildTemplate.id)
    if template then
      local number = template.unlockBuildInfo[1].canBuildNun
      if totalBuildHaveCount >= number then
        return
      end
    end
    local haveCount = LuaEntry.Resource:GetCntByResType(self.needRes.resourceType)
    if haveCount > self.needRes.count then
      local point = BuildingUtils.GetPointByBuildCanPut(self.param.buildId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
      local uuid = FakeBuildUuid
      local buildId = itemId
      local curPoint = point
      GoToUtil.CloseAllWindows()
      BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Build, uuid, curPoint, nil, UIWindowNames.UIBuildList)
    else
      local data = {
        {
          resType = self.needRes.resourceType,
          need = self.needRes.count
        }
      }
      LWResourceLackUtil:GotoResLack(data)
    end
    return
  end
  self.view:SetCancelRedGreen(false)
  self.isInBuild = true
  local point = BuildingUtils.GetPointByBuildCanPut(self.param.buildId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
  local uuid
  for _, v in pairs(self.param.buildDataList) do
    if v.state == BuildingStateType.FoldUp then
      uuid = v.uuid
    end
  end
  local buildId = itemId
  local curPoint = point
  if uuid ~= 0 then
    GoToUtil.CloseAllWindows()
    BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Replace, uuid, curPoint, nil, UIWindowNames.UIBuildList)
  else
    GoToUtil.CloseAllWindows()
    BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Build, 0, curPoint, nil, UIWindowNames.UIBuildList)
  end
end

function UIBuildDecorateCell:ComponentDestroy()
  self.btn = nil
  self.build_bg = nil
  self.name = nil
  self.icon = nil
  self.des = nil
  self.level = nil
  self.upBtn = nil
  self.haveTitle = nil
  self.buildTitle = nil
  self.buildValue = nil
  self.priceCotent = nil
  self.priceBg = nil
end

function UIBuildDecorateCell:GetState()
  return self.isBuiltMax
end

return UIBuildDecorateCell
