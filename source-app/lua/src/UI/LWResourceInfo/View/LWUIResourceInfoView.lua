local LWUIResourceInfoView = BaseClass("LWUIResourceInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local titlePath = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local expand_content = "UICommonPopUpTitle/Common_bg_orange"
local resBar_path = "Root/Layout/ResourceInfo/Bar/ResourceBar"
local resBarText_path = "Root/Layout/ResourceInfo/Bar/ResourceBarText"
local resIcon_path = "Root/Layout/ResourceInfo/Bar/ResourceBarIcon"
local content_path = "Root/Layout/Scroll/Viewport/Content"
local black_mask_path = "UICommonPopUpTitle/panel"
local gift_package_item_path = "Root/GiftPackageItem"

function LWUIResourceInfoView:OnCreate()
  base.OnCreate(self)
  self.resType = self:GetUserData()
  self.selectResourceData = {
    resType = self.resType,
    need = 1,
    type = ResLackContextType.Resource
  }
  self:ComponentDefine()
  self:ReInit()
  PostEventLog.Track(PostEventLog.Defines.open_window, {
    windowName = UIWindowNames.UILWResourceInfo,
    resource_id = self.resType
  })
end

function LWUIResourceInfoView:OnDestroy()
  DataCenter.ArrowManager:RemoveArrow()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIResourceInfoView:ComponentDefine()
  self.title = self:AddComponent(UIText, titlePath)
  if self.resType == ResourceType.Wood then
    self.title:SetLocalText(100014)
    self.title:SetActive(true)
  elseif self.resType == ResourceType.Food then
    self.title:SetLocalText("resource_name001")
    self.title:SetActive(true)
  elseif self.resType == ResourceType.Metal then
    self.title:SetLocalText("resource_name002")
    self.title:SetActive(true)
  elseif self.resType == ResourceType.FLINT then
    self.title:SetLocalText(DataCenter.ResourceManager:GetResourceNameByType(self.resType))
    self.title:SetActive(true)
  elseif self.resType == ResourceType.OBSIDIAN then
    self.title:SetLocalText(DataCenter.ResourceManager:GetResourceNameByType(self.resType))
    self.title:SetActive(true)
  else
    local txt = DataCenter.ResourceManager:GetResourceNameByType(self.resType)
    if string.IsNullOrEmpty(txt) then
      self.title:SetActive(false)
    else
      self.title:SetText(txt)
      self.title:SetActive(true)
    end
  end
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, black_mask_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.resource_info = self:AddComponent(UIBaseContainer, "Root/Layout/ResourceInfo")
  self.resBarText = self:AddComponent(UIText, resBarText_path)
  self.resBar = self:AddComponent(UISlider, resBar_path)
  self.resIcon = self:AddComponent(UIImage, resIcon_path)
  self.scroll = self:AddComponent(UILayoutElement, "Root/Layout/Scroll")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.gift_package_item = self:AddComponent(LWResourceLackCell, gift_package_item_path)
  self.gift_package_item:SetActive(false)
  self.textHasTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Layout/ResourceInfo/HasContent/HasTitleText")
  self.textHasValue = self:AddComponent(UITextMeshProUGUIEx, "Root/Layout/ResourceInfo/HasContent/HasValueText")
  self.textConvertTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Layout/ResourceInfo/ConvertContent/ConvertTitleText")
  self.textConvertValue = self:AddComponent(UITextMeshProUGUIEx, "Root/Layout/ResourceInfo/ConvertContent/ConvertValueText")
  self.textSelectConvertTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/Layout/ResourceInfo/SelectConvertContent/SelectConvertTitleText")
  self.textSelectConvertValue = self:AddComponent(UITextMeshProUGUIEx, "Root/Layout/ResourceInfo/SelectConvertContent/SelectConvertValueText")
  self.compSelectConvertContent = self:AddComponent(UIBaseContainer, "Root/Layout/ResourceInfo/SelectConvertContent")
  self.compConvertContent = self:AddComponent(UIBaseContainer, "Root/Layout/ResourceInfo/ConvertContent")
  self.textHasTitle:SetLocalText("resource_list_handle")
  self.textConvertTitle:SetLocalText("resource_list_resource_material")
  self.textSelectConvertTitle:SetLocalText("resource_list_resource_material_select")
end

function LWUIResourceInfoView:ComponentDestroy()
  self:ClearList()
  self.content = nil
  self.gift_package_item = nil
  self.textHasTitle = nil
  self.textHasValue = nil
  self.textConvertTitle = nil
  self.textConvertValue = nil
  self.textSelectConvertTitle = nil
  self.textSelectConvertValue = nil
  self.compSelectConvertContent = nil
  self.compConvertContent = nil
end

function LWUIResourceInfoView:OnEnable()
  base.OnEnable(self)
end

function LWUIResourceInfoView:OnDisable()
  base.OnDisable(self)
end

function LWUIResourceInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResource)
  self:AddUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:AddUIListener(EventId.ProductLineUpdate, self.OnCityCollectionBack)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshCurrentPage)
  self:AddUIListener(EventId.AllianceResourceUpdate, self.OnResUpdate)
end

function LWUIResourceInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResource)
  self:RemoveUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:RemoveUIListener(EventId.ProductLineUpdate, self.OnCityCollectionBack)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshCurrentPage)
  self:RemoveUIListener(EventId.AllianceResourceUpdate, self.OnResUpdate)
end

function LWUIResourceInfoView:OnResUpdate()
  if self.content ~= nil and (self.resType == ResourceType.AllianceStone or self.resType == ResourceType.AllianceCoal or self.resType == ResourceType.AllianceFarmerExp) then
    self:ReInit()
  end
end

function LWUIResourceInfoView:RefreshCurrentPage()
  self:RefreshBar()
  self:RefreshContent()
end

function LWUIResourceInfoView:ReInit()
  self:RefreshBar()
  self:RefreshContent()
  self:RefreshBarContent()
end

function LWUIResourceInfoView:RefreshBar()
  local iconPath = DataCenter.ResourceManager:GetResourceIconByType(self.resType)
  self.title:SetText(DataCenter.ResourceManager:GetResourceNameByType(self.resType))
  if iconPath == nil then
    self.resIcon:SetActive(false)
    self.resBar:SetLocalPositionXYZ(0, 0, 0)
  else
    self.resIcon:SetActive(true)
    self.resIcon:LoadSprite(iconPath)
    self.resBar:SetLocalPositionXYZ(22, 0, 0)
  end
  local have = LuaEntry.Resource:GetCntByResType(self.resType)
  local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(self.resType)
  local need = 0
  if template ~= nil and not string.IsNullOrEmpty(template.protect_effect_number) then
    local num = tonumber(template.protect_effect_number)
    need = toInt(LuaEntry.Effect:GetGameEffect(num))
    local addRate = 1
    if self.resType == ResourceType.Food then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceFoodProductAddRate) + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceExtraProductAddRate)
    elseif self.resType == ResourceType.Metal then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceMetalProductAddRate) + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceExtraProductAddRate)
    elseif self.resType == ResourceType.Wood then
      addRate = addRate + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceWoodProductAddRate) + LuaEntry.Effect:GetGameEffect(ScienceEffectID.ResourceExtraProductAddRate)
    end
    need = math.floor(need * addRate)
  end
  if self.resType == ResourceType.AllianceFarmerExp then
    local allianceBuildInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo
    if allianceBuildInfo then
      local builderExpInfo = allianceBuildInfo.builderExpInfo
      if builderExpInfo then
        local myLevel = toInt(builderExpInfo.level)
        local curExp = toInt(builderExpInfo.curExp)
        local levelCfg = DataCenter.SeasonFarmerTemplateManager:GetExpTemplateByLevel(myLevel)
        if builderExpInfo and levelCfg and levelCfg.exp then
          need = toInt(levelCfg.exp)
        end
        have = curExp
      end
    end
  end
  if need == nil or need == 0 then
    self.resBarText:SetText(string.GetFormattedSeperatorNum(have))
    self.resBar:SetValue(1)
  else
    self.resBarText:SetText(string.format("%s/%s", string.GetFormattedSeperatorNum(have), string.GetFormattedSeperatorNum(need)))
    self.resBar:SetValue(have / need)
  end
  self.textHasValue:SetText(string.GetFormattedStr(have))
end

function LWUIResourceInfoView:RefreshContent()
  self:ClearList()
  local templates1 = DataCenter.LWResourceLackManager:GetResourceWay(self.resType)
  local templates2 = DataCenter.LWResourceLackManager:GetResourceItemWay(self.resType)
  local templates = table.mergeArray(templates1 or {}, templates2 or {})
  local need = 100
  local tempDataList
  if not table.IsNullOrEmpty(templates) then
    tempDataList = LWResourceLackUtil:FilterResourceTemplates(templates, need, {isShowInResourceList = true})
  end
  if not tempDataList or #tempDataList == 0 then
    return
  end
  table.sort(tempDataList, function(a, b)
    return a.order < b.order
  end)
  local scroll_height = 593
  self.gift_package_item:SetActive(false)
  if 0 < table.count(tempDataList) then
    local giftPackageData = tempDataList[1]
    if giftPackageData.tips == LWResourceLackGetWay.GiftPackage or giftPackageData.tips == LWResourceLackGetWay.GiftPackageList then
      self.gift_package_item:SetActive(true)
      self.gift_package_item:Refresh(true, giftPackageData, self.ctrl, self.selectResourceData)
      scroll_height = 520
      self.dataList = {}
      if table.count(tempDataList) > 1 then
        for k = 2, table.count(tempDataList) do
          table.insert(self.dataList, tempDataList[k])
        end
      end
    else
      self.dataList = tempDataList
    end
  end
  self.scroll:SetPreferredHeight(scroll_height)
  for k, v in pairs(self.dataList) do
    self.cellReqs[k] = self:GameObjectInstantiateAsync(UIAssets.LWLackResourceItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(k)
      go.name = nameStr
      self.cells[k] = self.content:AddComponent(LWResourceLackCell, nameStr)
      self.cells[k]:Refresh(false, v, self.ctrl, self.selectResourceData)
      if v and v.tips == LWResourceLackGetWay.HangUp then
        SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0, true)
      end
    end)
  end
end

function LWUIResourceInfoView:RefreshBarContent()
  local totalConvertValue = self.ctrl:GetTotalConvertNum(self.resType, self.dataList)
  self.compConvertContent:SetActive(0 < totalConvertValue)
  if 0 < totalConvertValue then
    self.textConvertValue:SetText(string.GetFormattedStr(totalConvertValue))
  end
  if self.ctrl:IsShowSelectConvert(self.resType) then
    local totalConvertSelectValue = self.ctrl:GetTotalConvertNumSelect(self.resType, self.dataList)
    if totalConvertSelectValue <= 0 then
      self.compSelectConvertContent:SetActive(false)
    else
      self.compSelectConvertContent:SetActive(true)
      self.textSelectConvertValue:SetText(string.GetFormattedStr(totalConvertSelectValue))
    end
  else
    self.compSelectConvertContent:SetActive(false)
  end
end

function LWUIResourceInfoView:ClearList()
  if self.cellReqs then
    self.content:RemoveComponents(LWResourceLackCell)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function LWUIResourceInfoView:UpdateResource()
  self:RefreshBar()
  self:RefreshContent()
  self:RefreshBarContent()
end

function LWUIResourceInfoView:UseItemSuccessHandle()
  self:RefreshBar()
  self:RefreshContent()
  self:RefreshBarContent()
end

function LWUIResourceInfoView:OnGetQueryResult()
  if not self.cells then
    return
  end
  local reward = DataCenter.StageManager.idleReward
  if not reward then
    return
  end
  local value = 0
  for i, rewardRow in ipairs(reward) do
    local resType = rewardRow.type
    local val = rewardRow.value
    if resType == RewardType.METAL and self.selectResourceData.resType == ResourceType.Metal or resType == RewardType.WOOD and self.selectResourceData.resType == ResourceType.Wood or resType == RewardType.FOOD and self.selectResourceData.resType == ResourceType.Food or resType == RewardType.FLINT and self.selectResourceData.resType == ResourceType.FLINT or resType == RewardType.OBSIDIAN and self.selectResourceData.resType == ResourceType.OBSIDIAN or resType == RewardType.AllianceFarmerExp and self.selectResourceData.resType == ResourceType.AllianceFarmerExp then
      value = val
      break
    end
  end
  for k, v in pairs(self.cells) do
    if v.data.tips == LWResourceLackGetWay.HangUp then
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
      if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
        v.title2:SetLocalText(450095)
        v.gotoBtnText:SetLocalText(450096)
      else
        v.title2:SetText(Localization:GetString(v.data.des, value))
        v.gotoBtnText:SetText(Localization:GetString(v.data.btn_name))
      end
    end
  end
end

function LWUIResourceInfoView:OnCityCollectionBack()
  if not self.cells then
    return
  end
  for _, v in pairs(self.cells) do
    if v.data.tips == LWResourceLackGetWay.CityCollection then
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(v.data.para1))
      if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
        break
      end
      local total = 0
      for _, build in pairs(buildList) do
        local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(build.uuid)
        total = total + storage
      end
      v.title2:SetText(Localization:GetString(v.data.des, math.floor(total)))
    end
  end
end

function LWUIResourceInfoView:IsFirst(index)
  for i = 1, index - 1 do
    if self.cells[i] ~= nil then
      return false
    end
  end
  return true
end

function LWUIResourceInfoView:GetFlyTargetPos()
  return self.resIcon.transform.position
end

return LWUIResourceInfoView
