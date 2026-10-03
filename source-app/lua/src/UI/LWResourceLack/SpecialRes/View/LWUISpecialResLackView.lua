local LWUISpecialResLackView = BaseClass("LWUISpecialResLackView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local LWResourceLackCellChipFactory = require("UI.LWResourceLack.Res.Component.LWLackResourceItemChipFactoryComponent")
local titlePath = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local bgPath = "UICommonPopUpTitle/Common_bg_orange"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local black_mask_path = "UICommonPopUpTitle/panel"
local res_go_path = "Root/ResourceInfo"
local resTitle_path = "Root/ResourceInfo/ResourceTitle"
local resBar_path = "Root/ResourceInfo/ResourceBar"
local resBarText_path = "Root/ResourceInfo/ResourceBarText"
local resIcon_path = "Root/ResourceInfo/ResourceBarIcon"
local euqip_go_path = "Root/EquipInfo"
local equip_icon_path = "Root/EquipInfo/EquipIcon"
local equip_title_path = "Root/EquipInfo/EquipTitle"
local equip_desc_path = "Root/EquipInfo/EquipDes"
local scroll_path = "Root/Scroll"
local content_path = "Root/Scroll/Viewport/Content"
local gift_package_item_path = "Root/GiftPackageItem"
local decoration_info_path = "Root/DecorationInfo"
local deco_title_path = "Root/DecorationInfo/DecoTitle"
local deco_bar_path = "Root/DecorationInfo/DecoBar"
local deco_text_path = "Root/DecorationInfo/DecoText"
local deco_icon_path = "Root/DecorationInfo/DecoIcon"
local no_way_text_path = "Root/NoWayText"

function LWUISpecialResLackView:OnCreate()
  base.OnCreate(self)
  self.data = self:GetUserData()
  if self.data and self.data.type == ResLackContextType.Energy then
    SFSNetwork.SendMessage(MsgDefines.UserGetDailyStaminaInfo)
  end
  self.hasInitWindow = false
  self:ComponentDefine()
  self:ReInit()
end

function LWUISpecialResLackView:OnDestroy()
  DataCenter.ArrowManager:RemoveArrow()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISpecialResLackView:ComponentDefine()
  self.bg = self:AddComponent(UIBaseContainer, bgPath)
  self.title = self:AddComponent(UIText, titlePath)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    if self.data.closeCallBack and type(self.data.closeCallBack) == "function" then
      self.data.closeCallBack()
    end
  end)
  self.maskBtnN = self:AddComponent(UIButton, black_mask_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
    if self.data.closeCallBack and type(self.data.closeCallBack) == "function" then
      self.data.closeCallBack()
    end
  end)
  self.resGo = self:AddComponent(UIBaseContainer, res_go_path)
  self.resTitle = self:AddComponent(UIText, resTitle_path)
  self.resBarText = self:AddComponent(UIText, resBarText_path)
  self.resBar = self:AddComponent(UISlider, resBar_path)
  self.resIcon = self:AddComponent(UIImage, resIcon_path)
  self.SpecialInfoNode = self:AddComponent(UIBaseContainer, "Root/SpecialInfo")
  self.SpecialTips = self:AddComponent(UITextMeshProUGUIEx, "Root/SpecialInfo/SpecialTips")
  self.equipGo = self:AddComponent(UIBaseContainer, euqip_go_path)
  self.equipIcon = self:AddComponent(UIImage, equip_icon_path)
  self.equipTitle = self:AddComponent(UIText, equip_title_path)
  self.equipDesc = self:AddComponent(UIText, equip_desc_path)
  self.scroll = self:AddComponent(UIScrollRect, scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.gift_package_item = self:AddComponent(LWResourceLackCell, gift_package_item_path)
  self.gift_package_item:SetActive(false)
  self.decoGo = self:AddComponent(UIBaseContainer, decoration_info_path)
  self.decoTitle = self:AddComponent(UIText, deco_title_path)
  self.decoIcon = self:AddComponent(UIImage, deco_icon_path)
  self.decoBar = self:AddComponent(UISlider, deco_bar_path)
  self.decoBarText = self:AddComponent(UIText, deco_text_path)
  self.nowayText = self:AddComponent(UIText, no_way_text_path)
end

function LWUISpecialResLackView:ComponentDestroy()
  self.content:SetAnchoredPositionXY(0, 0)
  self:ClearList()
  self.scroll = nil
  self.content = nil
  self.gift_package_item = nil
  self.firstBuyBtn = nil
  self.hasInitWindow = nil
end

function LWUISpecialResLackView:OnEnable()
  base.OnEnable(self)
  if self.hasInitWindow then
    self:ReInit()
  else
    self.hasInitWindow = true
  end
end

function LWUISpecialResLackView:OnDisable()
  base.OnDisable(self)
end

function LWUISpecialResLackView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResource)
  self:AddUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:AddUIListener(EventId.ProductLineUpdate, self.OnCityCollectionBack)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.FormationStaminaUpdate, self.RefreshBar)
  self:AddUIListener(EventId.UserGoldCoverStamina, self.OnUseGoldCallBack)
  self:AddUIListener(EventId.UpdateGiftPackData, self.ReInit)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.RefreshClaimFreeStamina, self.RefreshClaimFreeStamina)
  self:AddUIListener(EventId.BuildDecoNumChange, self.RefreshBar)
  self:AddUIListener(EventId.TacticalChipProductComplete, self.OnTacticalChipProductComplete)
  self:AddUIListener(EventId.RefreshLackViewList, self.RefreshContent)
end

function LWUISpecialResLackView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResource)
  self:RemoveUIListener(EventId.OnGetQueryHangUpRewardResult, self.OnGetQueryResult)
  self:RemoveUIListener(EventId.ProductLineUpdate, self.OnCityCollectionBack)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.FormationStaminaUpdate, self.RefreshBar)
  self:RemoveUIListener(EventId.UserGoldCoverStamina, self.OnUseGoldCallBack)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.ReInit)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.RefreshClaimFreeStamina, self.RefreshClaimFreeStamina)
  self:RemoveUIListener(EventId.BuildDecoNumChange, self.RefreshBar)
  self:RemoveUIListener(EventId.TacticalChipProductComplete, self.OnTacticalChipProductComplete)
  self:RemoveUIListener(EventId.RefreshLackViewList, self.RefreshContent)
end

function LWUISpecialResLackView:OnRefreshItems()
  if not self:CheckAutoCloseUI() then
    self:ReInit()
  end
end

function LWUISpecialResLackView:OnTacticalChipProductComplete()
  if not self:CheckAutoCloseUI() then
    self:ReInit()
  end
end

function LWUISpecialResLackView:ReInit()
  self:RefreshBar()
  self:RefreshContent()
end

function LWUISpecialResLackView:RefreshBar()
  local type = self.data.type
  self.SpecialInfoNode:SetActive(false)
  self.resGo:SetActive(false)
  self.equipGo:SetActive(false)
  self.decoGo:SetActive(false)
  self.scroll.rectTransform:Set_sizeDelta(705, 800)
  self.title:SetText(Localization:GetString("450012"))
  if type == ResLackContextType.Energy then
    self.resGo:SetActive(true)
    self.title:SetText(Localization:GetString("104217"))
    self.resIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/Common_icon_stamina.png")
    self.scroll.rectTransform:Set_sizeDelta(705, 660)
    self:RefreshStamina()
  elseif type == ResLackContextType.TWSkillChip then
    if self.data and self.data.chipId then
      local ownNum = DataCenter.TacticalChipManager:GetChipFreeCount(self.data.chipId)
      local realNeed = self.data.need - ownNum
      realNeed = math.max(0, realNeed)
      if 0 < realNeed then
        self.SpecialInfoNode:SetActive(true)
        self.SpecialTips:SetLocalText("drone_skillchip_getmore_6_limit_18", realNeed)
        self.scroll.rectTransform:Set_sizeDelta(705, 680)
      end
    end
  elseif type == ResLackContextType.Equip then
    self.equipGo:SetActive(true)
    self.title:SetText(Localization:GetString("450012"))
    self.equipIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/icon_210100.png")
    self.equipTitle:SetText(Localization:GetString("430762"))
    self.equipDesc:SetText(Localization:GetString("430763"))
    self.scroll.rectTransform:Set_sizeDelta(705, 640)
  elseif type == ResLackContextType.CommonEquip then
    self.title:SetText(Localization:GetString("2000631"))
  elseif type == ResLackContextType.TWSkillChipExp or type == ResLackContextType.TWSkillChip then
    self.title:SetLocalText(450012)
  elseif type == ResLackContextType.BuildingDecoration then
    self.title:SetText(Localization:GetString("decoration_building_desc5"))
    if self.data.decoBuildingUuid then
      self.decoGo:SetActive(true)
      self.scroll.rectTransform:Set_sizeDelta(705, 660)
      local ret = self:RefreshDecoBuildingInfo()
      if not ret then
        self.decoGo:SetActive(false)
        self.scroll.rectTransform:Set_sizeDelta(705, 800)
      end
    end
  elseif type == ResLackContextType.TacticalCard then
    self.title:SetLocalText("battle_card_lack")
  end
end

function LWUISpecialResLackView:RefreshContent()
  self:RecordLastContentPos()
  self:ClearList()
  local templates = DataCenter.LWResourceLackManager:GetSpecialResWay(self.data.type)
  local need = self.data.need
  local tempDataList
  if not table.IsNullOrEmpty(templates) then
    self.data.skipFilterTypeList = {}
    table.merge(self.data.skipFilterTypeList, LWResourceLackShow_SoldOutTypes)
    table.merge(self.data.skipFilterTypeList, LWResourceLackShow_NotOpenTypes)
    tempDataList = LWResourceLackUtil:FilterResourceTemplates(templates, need, self.data)
  end
  self.gift_package_item:SetActive(false)
  self.bg.rectTransform:Set_sizeDelta(820, 1060)
  if not tempDataList or #tempDataList == 0 then
    self.nowayText:SetActive(true)
    return
  else
    self.nowayText:SetActive(false)
  end
  table.sort(tempDataList, function(a, b)
    return a.order < b.order
  end)
  if 0 < table.count(tempDataList) then
    local giftPackageData = tempDataList[1]
    if giftPackageData.tips == LWResourceLackGetWay.GiftPackage or giftPackageData.tips == LWResourceLackGetWay.GiftPackageList then
      self.gift_package_item:SetActive(true)
      self.bg.rectTransform:Set_sizeDelta(820, 1175)
      self.gift_package_item:Refresh(true, giftPackageData, self.ctrl, self.data)
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
  LWResourceLackUtil:SortShowDataList(self.dataList)
  self.firstBuyBtn = nil
  self:CreateLackCell(self.dataList, 1)
end

function LWUISpecialResLackView:CreateLackCell(dataList, index)
  if dataList == nil or index > #dataList then
    self:JumpToLastContentPos()
    return
  end
  local data = dataList[index]
  local path, Cpt = self:GetTemplateAndComponent(data)
  self.cellReqs[index] = self:GameObjectInstantiateAsync(path, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(self.content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local nameStr = tostring(index)
    go.name = nameStr
    self.cells[index] = self.content:AddComponent(Cpt, nameStr)
    if self.cells[index].SetIsShowSpendLessFeature then
      self.cells[index]:SetIsShowSpendLessFeature(true)
    end
    self.cells[index]:Refresh(false, data, self.ctrl, self.data)
    if data.tips == LWResourceLackGetWay.HangUp then
      SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0)
    end
    if not self.firstBuyBtn then
      self.firstBuyBtn = self.cells[index].buyBtn
      if self.firstBuyBtn and #self.dataList == 1 and not self.data.fromClickMainUI and CommonUtil.PlayerPrefsGetInt("FIRST_TIME_LACK_ENERGY_BTN_GUIDE", 0) == 0 then
        CommonUtil.PlayerPrefsSetInt("FIRST_TIME_LACK_ENERGY_BTN_GUIDE", 1)
        local fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
        fingerHandle:completed("+", function(handle)
          if handle.isError then
            return
          end
          CommonUtil.CallAutoArabicMirrorManually(handle)
          local gameObject = handle.gameObject
          local transform = gameObject.transform
          transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
          transform.position = self.firstBuyBtn.gameObject.transform.position
          TimerManager:GetInstance():DelayInvoke(function()
            fingerHandle:Destroy()
          end, 2)
        end)
      end
    end
    self:CreateLackCell(dataList, index + 1)
  end)
end

function LWUISpecialResLackView:RecordLastContentPos()
  self.lastContentPos = self.content:GetAnchoredPositionY()
end

function LWUISpecialResLackView:JumpToLastContentPos()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  local x = self.content:GetAnchoredPositionX()
  local posY = self.lastContentPos or 0
  local scrollHeight = self.scroll:GetSizeDelta().y
  local contentHeight = self.content:GetSizeDelta().y
  if posY > contentHeight - scrollHeight then
    posY = math.max(0, contentHeight - scrollHeight)
  end
  self.content:SetAnchoredPositionXY(x, posY)
  self.scroll:StopMovement()
end

function LWUISpecialResLackView:GetTemplateAndComponent(data)
  if data.tips == LWResourceLackGetWay.TacticalChipFactory then
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
    if buildList and buildList[1] ~= nil then
      local curBuildingLv = buildList[1].level
      if self.data and self.data.chipId then
        local chipTemplate = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.data.chipId)
        if chipTemplate and curBuildingLv >= chipTemplate.craft_factory_level then
          return UIAssets.LWLackResourceItemChipFactory, LWResourceLackCellChipFactory
        end
      end
    end
  end
  return UIAssets.LWLackResourceItem, LWResourceLackCell
end

function LWUISpecialResLackView:RefreshClaimFreeStamina()
  for i, v in pairs(self.cells) do
    if v and v.data and v.data.tips == LWResourceLackGetWay.ClaimFreeStamina then
      v:RefreshStamina()
    end
  end
end

function LWUISpecialResLackView:ClearList()
  if self.cellReqs then
    if self.content then
      self.content:RemoveComponents(LWResourceLackCell)
      self.content:RemoveComponents(LWResourceLackCellChipFactory)
    end
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

function LWUISpecialResLackView:UseItemSuccessHandle()
  if not self.cells then
    return
  end
  local waitDel = {}
  for k, v in pairs(self.cells) do
    if v.data.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(v.data.para1)
      local itemCount = items and items.count or 0
      if itemCount == 0 then
        waitDel[k] = v
      else
        v.title2:SetText(Localization:GetString(v.data.des, itemCount))
      end
    end
  end
  for k, v in pairs(waitDel) do
    self.content:RemoveComponent(v.gameObject.name, LWResourceLackCell)
    local req = self.cellReqs[k]
    if req then
      self:GameObjectDestroy(req)
      self.cellReqs[k] = nil
    end
    self.cells[k] = nil
  end
  for k, v in pairs(self.cells) do
    v:RefreshLightBg(self:IsFirst(k))
  end
end

function LWUISpecialResLackView:UpdateResource()
  if self.data.type == 1 then
    self:RefreshBar()
    local allClear = true
    local have = LuaEntry.Resource:GetCntByResType(self.data.resType)
    local need = self.data.need
    if have < need then
      allClear = false
    end
    if allClear then
      self.ctrl:CloseSelf()
    end
  end
end

function LWUISpecialResLackView:OnGetQueryResult()
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
    if resType == RewardType.METAL and self.selectResourceData.resType == ResourceType.Metal or resType == RewardType.WOOD and self.selectResourceData.resType == ResourceType.Wood or resType == RewardType.FOOD and self.selectResourceData.resType == ResourceType.Food or resType == RewardType.FLINT and self.selectResourceData.resType == ResourceType.FLINT or resType == RewardType.OBSIDIAN and self.selectResourceData.resType == ResourceType.OBSIDIAN then
      value = val
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

function LWUISpecialResLackView:OnCityCollectionBack()
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

function LWUISpecialResLackView:UpdateGoldSignal()
  local gold = LuaEntry.Player.gold
  for k, v in pairs(self.cells) do
    v:RefreshColor(gold)
  end
end

function LWUISpecialResLackView:OnUseGoldCallBack()
  self:RefreshBar()
  for k, v in pairs(self.cells) do
    v:RefreshButton()
  end
end

function LWUISpecialResLackView:IsFirst(index)
  for i = 1, index - 1 do
    if self.cells[i] ~= nil then
      return false
    end
  end
  return true
end

function LWUISpecialResLackView:GetFlyTargetPos()
  return self.resIcon.transform.position
end

function LWUISpecialResLackView:RefreshStamina()
  local have = LuaEntry.Player:GetCurStamina()
  local full = 100
  local resumeSpeed = 0
  local config = DataCenter.ArmyFormationDataManager:GetConfigData()
  if config ~= nil then
    full = config.FormationStaminaMax
    resumeSpeed = config.FormationStaminaUpdateTime
  end
  self.resBarText:SetText(string.GetFormattedSeperatorNum(math.floor(have)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(full)))
  self.resBar:SetValue(math.min(1, have / full))
  local diffTime = LuaEntry.Player:GetStaminaFullTime() - UITimeManager:GetInstance():GetServerTime()
  if have >= full or diffTime <= 0 then
    self.resTitle:SetText(string.format(Localization:GetString("104198", resumeSpeed)))
  else
    self.resTitle:SetText((string.format(Localization:GetString("stamina_recover_cd", resumeSpeed, UITimeManager:GetInstance():MilliSecondToFmtString(diffTime)))))
  end
  self.data.need = full - have
end

function LWUISpecialResLackView:RefreshDecoBuildingInfo()
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.data.decoBuildingUuid)
  if not buildingData then
    return false
  end
  local iconPath = DataCenter.BuildManager:GetBuildIconPath(buildingData.itemId, 1)
  self.decoIcon:LoadSpriteAuto(iconPath)
  local upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(buildingData)
  local have = 0
  if upLevelScarceInfos and 0 < table.count(upLevelScarceInfos) then
    local lastData = upLevelScarceInfos[#upLevelScarceInfos]
    have = lastData.count
  end
  local upgradeNeed = self.data.need - have
  self.decoBarText:SetText(string.GetFormattedSeperatorNum(math.floor(have)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.data.need)))
  self.decoBar:SetValue(math.min(1, have / self.data.need))
  self.decoTitle:SetText(string.format(Localization:GetString("450011", string.GetFormattedSeperatorNum(upgradeNeed), Localization:GetString("decoration_recruit_desc8"))))
  if have >= self.data.need then
    self.ctrl:CloseSelf()
  end
  return true
end

function LWUISpecialResLackView:CheckAutoCloseUI()
  local type = self.data.type
  if type == ResLackContextType.TWSkillChip then
    local needNum = self.data.need or 0
    local ownNum = DataCenter.TacticalChipManager:GetChipFreeCount(self.data.chipId)
    if 0 < needNum and needNum <= ownNum then
      self.ctrl:CloseSelf()
      return true
    end
  end
  return false
end

function LWUISpecialResLackView:Update1000MS()
  if self.data and self.data.type == ResLackContextType.Energy and self.data.need and self.data.need > 0 then
    self:RefreshStamina()
  end
end

return LWUISpecialResLackView
