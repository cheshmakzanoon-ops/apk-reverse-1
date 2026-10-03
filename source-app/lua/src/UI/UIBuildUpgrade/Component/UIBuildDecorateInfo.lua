local UIBuildDecorateInfo = BaseClass("UIBuildDecorateInfo", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIDesCell = require("UI.UIBuildUpgrade.Component.UIDesCell")
local UIDecorateItemCell = require("UI.UIBuildUpgrade.Component.UIDecorateCell")
local base = UIBaseContainer

function UIBuildDecorateInfo:OnCreate()
  base.OnCreate(self)
  self.upLevelScarceInfos = nil
  self.desCells = {}
  self:ComponentDefine()
  self:ReInit()
end

function UIBuildDecorateInfo:OnDestroy()
  self:ComponentDestroy()
  self.param = nil
  self.desCells = nil
  self.upEffects = nil
  self.upLevelScarceInfos = nil
  self.isLockLevelUpMsg = nil
  base.OnDestroy(self)
end

function UIBuildDecorateInfo:OnEnable()
  base.OnEnable(self)
end

function UIBuildDecorateInfo:OnDisable()
  base.OnDisable(self)
end

function UIBuildDecorateInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BuildLevelUp, self.OnBuildLevelUp)
  self:AddUIListener(EventId.AddDecorate, self.RefreshDecorate)
  self:AddUIListener(EventId.DecorateReplace, self.RefreshDecorate)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshDecorate)
  self:AddUIListener(EventId.DecoratorLevelUpgradeMessageOnReceive, self.OnDecoratorLevelUpgradeMessageOnReceive)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
end

function UIBuildDecorateInfo:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BuildLevelUp, self.OnBuildLevelUp)
  self:RemoveUIListener(EventId.AddDecorate, self.RefreshDecorate)
  self:RemoveUIListener(EventId.DecorateReplace, self.RefreshDecorate)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshDecorate)
  self:RemoveUIListener(EventId.DecoratorLevelUpgradeMessageOnReceive, self.OnDecoratorLevelUpgradeMessageOnReceive)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
end

function UIBuildDecorateInfo:OnBuildLevelUp(buildData)
  if buildData.uuid == self.param.uuid then
    local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildData.uuid)
    self:ReInit(data)
  end
end

function UIBuildDecorateInfo:ComponentDefine()
  self.bg = self:AddComponent(UIBaseContainer, "BG")
  self.bg2 = self:AddComponent(UIBaseContainer, "Common_bg_orange2")
  self.bg3 = self:AddComponent(UIBaseContainer, "BG (2)")
  self.descText = self:AddComponent(UIText, "DescText")
  self.buildIcon = self:AddComponent(UIImage, "UIBuild_icon")
  self.build_level = self:AddComponent(UIText, "CurLevelText")
  self.placedTitle = self:AddComponent(UIText, "placedTitle")
  self.UpLevelBtn = self:AddComponent(UIButton, "LevelUpBtn")
  self.GlueTipBtn = self:AddComponent(UIButton, "decorateList/GlueTipBtn")
  self.UpLevelBtnText = self:AddComponent(UIText, "LevelUpBtn/Content/Upgrade")
  self.UpLevelBtnItemContent = self:AddComponent(UIBaseContainer, "LevelUpBtn/Content/ItemContent")
  self.UpLevelBtnNeedGlueText = self:AddComponent(UIText, "LevelUpBtn/Content/ItemContent/NeedGlueText")
  self.ToBuildBtnBottom = self:AddComponent(UIButton, "ToBuildBtnBottom")
  self.GetMoreBtn = self:AddComponent(UIButton, "GetMoreBtn")
  self.GetMoreBtnText = self:AddComponent(UIText, "GetMoreBtn/Content/GetMoreBtnText")
  self.GetMoreBtnIcon = self:AddComponent(UIImage, "GetMoreBtn/Content/Icon")
  self.ToBuildBtn = self:AddComponent(UIButton, "ToBuildBtn")
  self.ToUpdateBtn = self:AddComponent(UIButton, "ToUpdateBtn")
  self.GotoBtn = self:AddComponent(UIButton, "GotoBtn")
  self.InfoBtn = self:AddComponent(UIButton, "InfoBtn")
  self.des_content = self:AddComponent(UIBaseContainer, "InfoScrollView/ViewPort/info")
  self.nameText = self:AddComponent(UIText, "titleText")
  self.maxTip = self:AddComponent(UIText, "maxTip")
  self.noHaveText = self:AddComponent(UIText, "NoHaveText")
  self.cantUseGlueText = self:AddComponent(UIText, "CantUseGlueText")
  self.cantUseGlueText:SetActive(false)
  self.upEffects = {}
  for i = 1, 4 do
    table.insert(self.upEffects, self.transform:Find("EffectContent/UpEffect" .. i):GetComponent(typeof(CS.UnityEngine.ParticleSystem)))
  end
  self.decorateList = self:AddComponent(UIScrollView, "decorateList")
  self.decorateList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.decorateList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.compMaxLvRemainingShow = self:AddComponent(UIBaseComponent, "MaxLvRemainingShow")
  self.textRemainingDesc = self:AddComponent(UITextMeshProUGUIEx, "MaxLvRemainingShow/ShowNum/RemainingDesc")
  self.textRemainingNum = self:AddComponent(UITextMeshProUGUIEx, "MaxLvRemainingShow/ShowNum/RemainingNum")
  self.scrollViewMaxLevelDecoration = self:AddComponent(UIScrollView, "MaxLvRemainingShow/MaxLvDecoration")
  self.scrollViewMaxLevelDecoration:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell_MaxDecoration(itemObj, index)
  end)
  self.scrollViewMaxLevelDecoration:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell_MaxDecoration(itemObj, index)
  end)
  self.UpLevelBtn:SetOnClick(function()
    self:UpLevel()
  end)
  self.UpLevelBtn:SetSafeClickMode(true)
  self.GetMoreBtn:SetOnClick(function()
    self:OnGetMore()
  end)
  self.ToBuildBtn:SetOnClick(function()
    self:ToBuild()
  end)
  self.ToUpdateBtn:SetOnClick(function()
    self:ToUpdate()
  end)
  self.InfoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
  self.GlueTipBtn:SetOnClick(function()
    self:OnClickGlueTip()
  end)
  self.GotoBtn:SetOnClick(function()
    self:OnClickGoto()
  end)
  self.ToBuildBtnBottom:SetOnClick(function()
    self:ToBuild()
  end)
end

function UIBuildDecorateInfo:UpLevel()
  if self.isLockLevelUpMsg ~= nil and self.isLockLevelUpMsg == true then
    return
  end
  if not self.upLevelScarceInfos then
    return
  end
  local lastData = self.upLevelScarceInfos[#self.upLevelScarceInfos]
  if not lastData.nextScore then
    if table.count(self.upLevelScarceInfos) > 0 and self.upLevelScarceInfos[1] and 0 < self.upLevelScarceInfos[1].itemId then
      self:OnBuildLevelUp(self.param)
      SFSNetwork.SendMessage(MsgDefines.DecoratorUpgrade, self.param.uuid, self.upLevelScarceInfos)
      self.isLockLevelUpMsg = true
    end
  else
    LWResourceLackUtil:GotoBuildDecorationResLack(self.param.uuid, lastData.nextScore)
  end
end

function UIBuildDecorateInfo:OnGetMore()
  if self.param.uuid == nil then
    local targetItemId
    local oneLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, 1)
    if oneLevelTemplate then
      targetItemId = checknumber(oneLevelTemplate.para4)
    end
    local isShowGetMore = false
    if targetItemId and 0 < targetItemId then
      local lackTemplates = DataCenter.LWResourceLackManager:GetGoodsWay(targetItemId)
      if not table.IsNullOrEmpty(lackTemplates) then
        local tempDataList = LWResourceLackUtil:FilterResourceTemplates(lackTemplates, 1)
        isShowGetMore = not table.IsNullOrEmpty(tempDataList)
      end
    end
    if isShowGetMore then
      LWResourceLackUtil:GotoGoodsItemLack(targetItemId, 1)
    else
      UIUtil.ShowTipsId("rescource_decoration_01")
    end
  elseif not BuildingUtils.IsDecoratorCantBuyDirectly(self.param.itemId) then
    local availableRechargeId = BuildingUtils.GetDecoratorAvailableRechargeId(self.param.itemId)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerLevelPackage, {anim = true}, availableRechargeId, {availableRechargeId})
  else
    local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
    if not table.IsNullOrEmpty(desTemplate.glue_exchange_id) then
      if desTemplate.glue_exchange_id[1] then
        local packs = GiftPackManager.GetPacksByGroupId(desTemplate.glue_exchange_id[1], false)
        if not table.IsNullOrEmpty(packs) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DailyMustBuy)
          return
        end
      end
      if desTemplate.glue_exchange_id[2] then
        local packs = GiftPackManager.GetPacksByGroupId(desTemplate.glue_exchange_id[2], false)
        if not table.IsNullOrEmpty(packs) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.WeeklyPackageNew)
          return
        end
      end
      if desTemplate.glue_exchange_id[3] then
        local packs = GiftPackManager.GetPacksByGroupId(desTemplate.glue_exchange_id[3], false)
        if not table.IsNullOrEmpty(packs) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.PackStore)
          return
        end
      end
    end
  end
end

function UIBuildDecorateInfo:ToBuild()
  local curScene = CS.SceneManager.CurrSceneID
  local cacheParam = self.param
  if curScene == SceneManagerSceneID.City then
    local point = BuildingUtils.GetPointByBuildCanPut(self.param.itemId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
    BuildingUtils.ShowPutBuild(self.param.itemId, PlaceBuildType.Replace, self.param.uuid, point, nil, UIWindowNames.UIBuildUpgrade)
    GoToUtil.CloseAllWindows()
  elseif curScene == SceneManagerSceneID.World then
    SceneUtils.ChangeToCity(function()
      local point = BuildingUtils.GetPointByBuildCanPut(cacheParam.itemId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
      BuildingUtils.ShowPutBuild(cacheParam.itemId, PlaceBuildType.Replace, cacheParam.uuid, point, nil, UIWindowNames.UIBuildUpgrade)
    end)
  end
end

function UIBuildDecorateInfo:ToUpdate()
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.param.itemId, false)
  local oldUUid = buildData.uuid
  SFSNetwork.SendMessage(MsgDefines.DecoratorReplace, oldUUid, self.param.uuid)
end

function UIBuildDecorateInfo:OnClickInfo()
  local param = {}
  param.baseBuildingId = self.param.itemId
  param.alignObject = self.InfoBtn
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
end

function UIBuildDecorateInfo:OnClickGlueTip()
  local param = {}
  param.type = "desc"
  param.desc = "NoKey"
  param.alignObject = self.GlueTipBtn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function UIBuildDecorateInfo:OnClickGoto()
  if self.param ~= nil and self.param.uuid ~= nil then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
    if buildData ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, nil, function()
        if buildData then
          local world = CS.SceneManager.World
          if IsNull(world) then
            return
          end
          local cityObj = world:GetBuildingByPoint(buildData.pointId)
          if IsNull(cityObj) then
            return
          end
          cityObj:ChangeMove()
        end
      end)
    end
  end
end

function UIBuildDecorateInfo:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.decorateList:AddComponent(UIDecorateItemCell, itemObj)
  item:ReInit(self.displayUpLevelScarceInfos[index], true)
end

function UIBuildDecorateInfo:OnDeleteCell(itemObj, index)
  self.decorateList:RemoveComponent(itemObj.name, UIDecorateItemCell)
end

function UIBuildDecorateInfo:ShowScroll()
  self:ClearScroll()
  local count = #self.displayUpLevelScarceInfos
  self.decorateList:SetTotalCount(count)
  if 0 < count then
    self.decorateList:RefillCells()
  end
end

function UIBuildDecorateInfo:ClearScroll()
  self.decorateList:ClearCells()
  self.decorateList:RemoveComponents(UIDecorateItemCell)
end

function UIBuildDecorateInfo:OnCreateCell_MaxDecoration(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scrollViewMaxLevelDecoration:AddComponent(UIDecorateItemCell, itemObj)
  item:ReInit(self.displayUpLevelScarceInfos[index], false)
end

function UIBuildDecorateInfo:OnDeleteCell_MaxDecoration(itemObj, index)
  self.scrollViewMaxLevelDecoration:RemoveComponent(itemObj.name, UIDecorateItemCell)
end

function UIBuildDecorateInfo:ShowScroll_MaxDecoration()
  self:ClearScroll_MaxDecoration()
  local count = #self.displayUpLevelScarceInfos
  self.scrollViewMaxLevelDecoration:SetTotalCount(count)
  if 0 < count then
    self.scrollViewMaxLevelDecoration:RefillCells()
  end
end

function UIBuildDecorateInfo:ClearScroll_MaxDecoration()
  self.scrollViewMaxLevelDecoration:ClearCells()
  self.scrollViewMaxLevelDecoration:RemoveComponents(UIDecorateItemCell)
end

function UIBuildDecorateInfo:ReInit(param)
  if param == nil then
    return
  end
  self.param = param
  self.isLockLevelUpMsg = false
  self.buildIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.itemId, 1), DefaultImage)
  self.build_level:SetText(Localization:GetString(100082) .. ": " .. self.param.level)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
  local maxCount = template.unlockBuildInfo[1].canBuildNun
  local listBuilds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.param.itemId)
  self.placedTitle:SetText(Localization:GetString(310148) .. ": " .. #listBuilds .. "/" .. maxCount)
  self:InitInfoDes(template)
  self.nameText:SetLocalText(template.name)
  self.descText:SetLocalText(template.des)
  self:RefreshDecorate()
end

function UIBuildDecorateInfo:RefreshDecorate()
  local buildingDataNormal = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(self.param.itemId, false)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.itemId)
  local maxCount = template.unlockBuildInfo[1].canBuildNun
  local oneLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, 1)
  if self.param.uuid == nil then
    self.bg3:SetActive(false)
    self.noHaveText:SetActive(true)
    self.maxTip:SetActive(false)
    self.decorateList:SetActive(false)
    self.compMaxLvRemainingShow:SetActive(false)
    self.ToBuildBtn:SetActive(false)
    self.UpLevelBtn:SetActive(false)
    self.ToBuildBtnBottom:SetActive(false)
    self.ToUpdateBtn:SetActive(false)
    self.GotoBtn:SetActive(false)
    self.GetMoreBtn:SetActive(true)
    self.placedTitle:SetActive(false)
    local isShowGetMore = false
    local targetItemId = checknumber(oneLevelTemplate.para4)
    if 0 < targetItemId then
      local lackTemplates = DataCenter.LWResourceLackManager:GetGoodsWay(targetItemId)
      if not table.IsNullOrEmpty(lackTemplates) then
        local tempDataList = LWResourceLackUtil:FilterResourceTemplates(lackTemplates, 1)
        isShowGetMore = not table.IsNullOrEmpty(tempDataList)
      end
    end
    CS.UIGray.SetGray(self.GetMoreBtn.transform, not isShowGetMore, true)
    local originPos = self.GetMoreBtn:GetAnchoredPosition()
    originPos = self.cantUseGlueText:GetAnchoredPosition()
    self.cantUseGlueText:SetAnchoredPositionXY(originPos.x, -185)
    self.GetMoreBtnIcon:SetActive(false)
    self.GetMoreBtnText:SetLocalText("building_center_desc9")
  elseif self.param.level >= template.max_level then
    self.bg3:SetActive(false)
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
    local hasInCity = DataCenter.BuildManager:IsDecorationExistInCity(self.param.itemId)
    local showToBuild = not hasInCity
    local showToUpgrade = hasInCity and buildingData.state == BuildingStateType.FoldUp and (buildingDataNormal == nil or buildingData.level > buildingDataNormal.level)
    self.ToBuildBtn:SetActive(showToBuild)
    self.ToBuildBtnBottom:SetActive(showToBuild)
    self.ToUpdateBtn:SetActive(showToUpgrade)
    self.GotoBtn:SetActive(not showToBuild and not showToUpgrade and hasInCity and maxCount == 1)
    self.noHaveText:SetActive(false)
    self.decorateList:SetActive(false)
    self.compMaxLvRemainingShow:SetActive(true)
    self.maxTip:SetActive(true)
    self.UpLevelBtn:SetActive(false)
    self.GetMoreBtn:SetActive(false)
    self.placedTitle:SetActive(true)
    local originPos = self.cantUseGlueText:GetAnchoredPosition()
    self.cantUseGlueText:SetAnchoredPositionXY(originPos.x, -390)
    self.displayUpLevelScarceInfos = {}
    local param = {}
    param.uuid = self.param.uuid
    param.levelTemplate = oneLevelTemplate
    param.id = oneLevelTemplate.id
    param.itemId = oneLevelTemplate.id
    table.insert(self.displayUpLevelScarceInfos, param)
    self:ShowScroll_MaxDecoration()
    self.textRemainingDesc:SetLocalText(100100)
    local decorationNum = BuildingUtils.GetDecorateCountByLevel(self.param.itemId, 1)
    self.textRemainingNum:SetText(decorationNum)
  else
    self.bg3:SetActive(true)
    self.noHaveText:SetActive(false)
    self.decorateList:SetActive(true)
    self.compMaxLvRemainingShow:SetActive(false)
    self.maxTip:SetActive(false)
    self.placedTitle:SetActive(true)
    self.upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(self.param)
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
    local hasInCity = DataCenter.BuildManager:IsDecorationExistInCity(self.param.itemId)
    local showToBuild = not hasInCity
    local showToUpgrade = hasInCity and buildingData.state == BuildingStateType.FoldUp and (buildingDataNormal == nil or buildingData.level > buildingDataNormal.level)
    self.ToBuildBtn:SetActive(showToBuild)
    self.ToBuildBtnBottom:SetActive(showToBuild)
    self.ToUpdateBtn:SetActive(showToUpgrade)
    self.GotoBtn:SetActive(not showToBuild and not showToUpgrade and hasInCity and maxCount == 1)
    local originPos = self.cantUseGlueText:GetAnchoredPosition()
    self.cantUseGlueText:SetAnchoredPositionXY(originPos.x, -390)
    if self.upLevelScarceInfos and 0 < table.count(self.upLevelScarceInfos) then
      local lastData = self.upLevelScarceInfos[#self.upLevelScarceInfos]
      local isLack = lastData.nextScore
      self.displayUpLevelScarceInfos = {}
      local param = {}
      param.uuid = self.param.uuid
      param.levelTemplate = oneLevelTemplate
      param.id = oneLevelTemplate.id
      param.itemId = oneLevelTemplate.id
      param.count = 0
      if isLack then
        param.nextScore = 0
      end
      if showToBuild then
        param.maxCount = maxCount
      end
      for k, v in pairs(self.upLevelScarceInfos) do
        if isLack then
          if v.nextScore then
            param.count = param.count + v.count
            param.nextScore = param.nextScore + v.nextScore
          else
            param.count = param.count + v.count * v.levelTemplate.para1
            param.nextScore = param.nextScore + v.count * v.levelTemplate.para1
          end
        else
          param.count = param.count + v.count * v.levelTemplate.para1
        end
      end
      table.insert(self.displayUpLevelScarceInfos, param)
      self:ShowScroll()
      self.UpLevelBtn:SetActive(not showToBuild)
      if isLack then
        self.UpLevelBtnText:SetLocalText("100547")
      else
        self.UpLevelBtnText:SetLocalText("100091")
      end
      local canUseGlue = 0 < lastData.levelTemplate.equal_glue_value
      self.GetMoreBtn:SetActive(false)
      if lastData.nextScore and canUseGlue then
        local needOneLevelCount = lastData.nextScore
        self.needGlueCount = lastData.levelTemplate.equal_glue_value * needOneLevelCount
        self.haveGlueCount = DataCenter.ItemData:GetItemCount(GLUE_GOOD_ID)
        self.UpLevelBtnNeedGlueText:SetText(self.haveGlueCount < self.needGlueCount and string.format("<color=#F97077>%d</color>/%d", self.haveGlueCount, self.needGlueCount) or string.format("<color=#5FEF87>%d</color>/%d", self.haveGlueCount, self.needGlueCount))
      else
      end
    end
  end
end

function UIBuildDecorateInfo:InitInfoDes(template)
  for k, v in pairs(self.desCells) do
    if v.inst ~= nil then
      self:GameObjectDestroy(v.inst)
    end
  end
  self.desCells = {}
  local paramList = self:GetValue(template, self.param.level)
  for i = 1, #paramList do
    paramList[i].index = i
    self:AddDesCell(paramList[i])
  end
end

function UIBuildDecorateInfo:AddDesCell(param)
  local cell = {}
  cell.param = param
  table.insert(self.desCells, cell)
  cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell, function(request)
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
    local temp = self.des_content:AddComponent(UIDesCell, nameStr)
    temp:ReInit(cell.param)
    cell.model = temp
  end)
end

function UIBuildDecorateInfo:GetValue(template, level)
  local temp, temp1
  local paramList = {}
  if level < (self.param.max_level or template.max_level) then
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, level)
    local nextLevelTemp
    if level < (self.param.max_level or template.max_level) then
      nextLevelTemp = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, level + 1)
    end
    local param
    for id, value in pairs(nextLevelTemp.building_effect_last) do
      temp, temp1 = WorkerUtil.GetEffectText(id, value, true)
      param = {}
      param.name = temp
      param.addValue = temp1
      if levelTemplate and levelTemplate.building_effect_last[id] then
        temp, temp1 = WorkerUtil.GetEffectText(id, levelTemplate.building_effect_last[id], true)
        param.curValue = temp1
      else
        param.curValue = 0
      end
      table.insert(paramList, param)
    end
  elseif level == (self.param.max_level or template.max_level) then
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.itemId, level)
    local param
    for id, value in pairs(levelTemplate.building_effect_last) do
      temp, temp1 = WorkerUtil.GetEffectText(id, value, true)
      param = {}
      param.name = temp
      param.curValue = temp1
      table.insert(paramList, param)
    end
  end
  return paramList
end

function UIBuildDecorateInfo:OnSelectBtnClick()
end

function UIBuildDecorateInfo:OnDecoratorLevelUpgradeMessageOnReceive()
  self.isLockLevelUpMsg = false
end

function UIBuildDecorateInfo:OnFinishHandleInitMsg()
  self.isLockLevelUpMsg = false
end

function UIBuildDecorateInfo:ComponentDestroy()
  self.bg = nil
  self.buildIcon = nil
  self.build_level = nil
  self.placedTitle = nil
  self.UpLevelBtn = nil
  self.levelDesCall = nil
  self.infoDesCall = nil
  self.nameText = nil
  self.maxTip = nil
  self.decorateList = nil
  self.scrollViewMaxLevelDecoration = nil
  self.noHaveText = nil
  self.ToBuildBtnBottom = nil
end

return UIBuildDecorateInfo
