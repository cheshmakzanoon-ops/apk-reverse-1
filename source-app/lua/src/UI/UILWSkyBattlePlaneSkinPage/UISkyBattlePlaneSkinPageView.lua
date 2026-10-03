local UISkyBattlePlaneSkinPageView = BaseClass("UISkyBattlePlaneSkinPageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIModelView = require("Framework.UI.Component.UIModelView")
local SkyBattlePlaneSkinItemComponent = require("UI.UILWSkyBattlePlaneSkinPage.Components.SkyBattlePlaneSkinItemComponent")
local UIVfx = require("Framework.UI.Component.UIVfx")

function UISkyBattlePlaneSkinPageView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitRTScene()
  self:Refresh()
end

function UISkyBattlePlaneSkinPageView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISkyBattlePlaneSkinPageView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compEffectLeft = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.compPlaneImg = self.viewSkin:AddComponent(self, UIModelView, 5)
  self.textWeaponName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textWeaponNameGold = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textWeaponNameGoldBottom = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compTypeDecorations = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textOwnTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textOwnEffect = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.eventTriggerWeaponScrollView = self.viewSkin:AddComponent(self, UIEventTrigger, 12)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.btnRightChange = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnRightChange:SetOnClick(function()
    self:OnBtnRightChangeClick()
  end)
  self.btnLeftChange = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnLeftChange:SetOnClick(function()
    self:OnBtnLeftChangeClick()
  end)
  self.btnUnlock = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnUnlock:SetOnClick(function()
  end)
  self.textUnlockBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.btnUse = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  self.textUseBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.btnInUse = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnInUse:SetOnClick(function()
    self:OnBtnInUseClick()
  end)
  self.textInUseBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compVFXQualitySwitch = self.viewSkin:AddComponent(self, UIVfx, 22)
  CS.UIGray.SetGray(self.btnInUse.transform, true, false)
  self.textOwnTitle:SetLocalText(2000472)
  self.eventTriggerWeaponScrollView:OnBeginDrag(function(eventData)
    self.isInDrag = true
    self.lastDragPosition = eventData.position
  end)
  self.eventTriggerWeaponScrollView:OnEndDrag(function(eventData)
    self.isInDrag = false
    if math.abs(eventData.position.x - self.lastDragPosition.x) < 100 then
      self.isInDrag = false
      return
    end
    if eventData.position.x > self.lastDragPosition.x then
      self:OnBtnLeftChangeClick()
    elseif eventData.position.x < self.lastDragPosition.x then
      self:OnBtnRightChangeClick()
    end
  end)
  self.btnUnlock:SetActive(false)
  self.textUseBtn:SetLocalText(2000463)
  self.textInUseBtn:SetLocalText(2000468)
end

function UISkyBattlePlaneSkinPageView:ComponentDestroy()
  if self.compPlaneImg then
    self.compPlaneImg:SetEnable(false)
  end
  self.viewSkin = nil
  self.compEffectLeft = nil
  self.btnInfo = nil
  self.textTitle = nil
  self.btnBack = nil
  self.compPlaneImg = nil
  self.textWeaponName = nil
  self.textWeaponNameGold = nil
  self.textWeaponNameGoldBottom = nil
  self.compTypeDecorations = nil
  self.textOwnTitle = nil
  self.textOwnEffect = nil
  self.eventTriggerWeaponScrollView = nil
  self.compContent = nil
  self.btnRightChange = nil
  self.btnLeftChange = nil
  self.btnUnlock = nil
  self.textUnlockBtn = nil
  self.btnUse = nil
  self.textUseBtn = nil
  self.btnInUse = nil
  self.textInUseBtn = nil
  self.compVFXQualitySwitch = nil
end

function UISkyBattlePlaneSkinPageView:DataDefine()
  self.autoShowPlaneIdWhenOpen = 0
  self.curSelectedPlaneId = 0
  self.showedPlaneId = 0
  self.itemList = {}
end

function UISkyBattlePlaneSkinPageView:DataDestroy()
  self.autoShowPlaneIdWhenOpen = 0
  self.showedPlaneId = 0
  self.curSelectedPlaneId = 0
  self.isItemLoadComplete = nil
  self.itemList = nil
end

local planeShowSceneAssets = "Assets/Main/Prefabs/LWBattle/Plane/Skin/SkyBattlePlaneScene.prefab"

function UISkyBattlePlaneSkinPageView:InitRTScene()
  self.compPlaneImg:SetActive(true)
  self.compPlaneImg:SetEnable(false)
  self.compPlaneImg:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGB32)
  self.compPlaneImg:SetDefaultSceneTrans(Vector3.New(2000, 2000, 2000))
  self.compPlaneImg:ReInit(planeShowSceneAssets)
end

function UISkyBattlePlaneSkinPageView:Refresh()
  self:RefreshDefaultShowedPlane()
  self:RefreshPlaneList()
end

function UISkyBattlePlaneSkinPageView:RefreshDefaultShowedPlane()
  local battlePlaneInfos = DataCenter.LWSkyBattleGrowthChapterManager.battlePlaneInfo
  if not battlePlaneInfos or #battlePlaneInfos == 0 then
    self.compPlaneImg:SetEnable(false)
    self.textWeaponNameGold:SetActive(false)
    self.textWeaponNameGoldBottom:SetActive(false)
    self.textWeaponName:SetActive(false)
    self.textOwnTitle:SetActive(false)
    self.textOwnEffect:SetActive(false)
    self.compTypeDecorations:SetActive(false)
    return
  end
  local curSelectedPlane = DataCenter.LWSkyBattleGrowthChapterManager:GetCurSelectedPlaneData()
  if not curSelectedPlane or curSelectedPlane.planeId == 0 then
    local toShowPlaneId = battlePlaneInfos[1].id
    for i, planeData in ipairs(battlePlaneInfos) do
      if planeData.owned then
        toShowPlaneId = planeData.id
        break
      end
    end
    self.autoShowPlaneIdWhenOpen = toShowPlaneId
  else
    self.autoShowPlaneIdWhenOpen = curSelectedPlane.planeId
    self.curSelectedPlaneId = curSelectedPlane.planeId
  end
end

function UISkyBattlePlaneSkinPageView:ChangePlaneAppearance(planeId)
  if not planeId or planeId == 0 then
    return
  end
  if not self.showedPlaneId or self.showedPlaneId ~= planeId then
    self.showedPlaneId = planeId
    local planePrefabPath = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, planeId, "prefab")
    self.compPlaneImg:ChangeModel(planePrefabPath, BindCallback(self, self.onModelChange))
    local planeQuality = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, planeId, "color") or 0
    local planeName = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, planeId, "name")
    self.textWeaponNameGold:SetActive(false)
    self.textWeaponNameGoldBottom:SetActive(false)
    self.textWeaponName:SetActive(false)
    if planeQuality == 5 then
      self.textWeaponNameGold:SetLocalText(planeName)
      self.textWeaponNameGoldBottom:SetLocalText(planeName)
      self.textWeaponNameGold:SetActive(true)
      self.textWeaponNameGoldBottom:SetActive(true)
    elseif planeQuality == 4 then
      self.textWeaponName:SetLocalText(planeName)
      self.textWeaponName:SetColorRGBA255(235, 134, 255, 255)
      self.textWeaponName:SetActive(true)
    else
      self.textWeaponName:SetLocalText(planeName)
      self.textWeaponName:SetColorRGBA255(112, 230, 241, 255)
      self.textWeaponName:SetActive(true)
    end
    self:RefreshEffectNode()
  end
end

function UISkyBattlePlaneSkinPageView:onModelChange(status, model)
  if status == false then
    return
  end
  self.compPlaneImg:ResetRotation()
end

function UISkyBattlePlaneSkinPageView:RefreshEffectNode()
  self.textOwnTitle:SetActive(false)
  self.textOwnEffect:SetActive(false)
  if not self.showedPlaneId or self.showedPlaneId == 0 then
    return
  end
  local planeProperty = DataCenter.LWSkyBattleGrowthChapterManager:GetPlaneCfgProperties(self.showedPlaneId)
  if not planeProperty then
    self.textOwnTitle:SetActive(false)
    self.textOwnEffect:SetActive(false)
  else
    self.textOwnTitle:SetActive(true)
    self.textOwnEffect:SetActive(true)
    self.textOwnEffect:SetText(self:GetEffectDesc(planeProperty))
  end
end

function UISkyBattlePlaneSkinPageView:GetEffectDesc(planeProperties, addColor, subColor)
  if not planeProperties then
    return ""
  end
  if addColor == nil then
    addColor = "#94e138"
  end
  if subColor == nil then
    subColor = "#f26a67"
  end
  local addColorTag = "<color=" .. addColor .. ">"
  local subColorTag = "<color=" .. subColor .. ">"
  local count = 0
  local propertyCount = #planeProperties
  local ownEffect = ""
  for _, v in pairs(planeProperties) do
    local type = v.type
    local value = v.value
    local nameStr = DataCenter.LWSkyBattleGrowthChapterManager:GetPlanePropertyNameKey(type)
    local name = Localization:GetString(nameStr)
    local addValue = ""
    if v.type == SkyBattlePlanePropertiesType.MemberPropPercent then
      addValue = string.format("%d%%", math.ceil(value / 100))
    else
      addValue = string.GetFormattedStr(value)
    end
    if value < 0 then
      ownEffect = ownEffect .. name .. "   " .. subColorTag .. addValue .. "</color>"
    else
      ownEffect = ownEffect .. name .. "   " .. addColorTag .. "+" .. addValue .. "</color>"
    end
    count = count + 1
    if propertyCount > count then
      ownEffect = ownEffect .. "\n"
    end
  end
  return ownEffect
end

function UISkyBattlePlaneSkinPageView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleChapterGrowthBattlePlaneInfoRefresh, self.Refresh)
end

function UISkyBattlePlaneSkinPageView:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleChapterGrowthBattlePlaneInfoRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function UISkyBattlePlaneSkinPageView:OnBtnInfoClick()
end

function UISkyBattlePlaneSkinPageView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UISkyBattlePlaneSkinPageView:RefreshPlaneList()
  local battlePlaneInfos = DataCenter.LWSkyBattleGrowthChapterManager.battlePlaneInfo
  if not battlePlaneInfos then
    return
  end
  local autoShowPlaneIndex = 1
  if self.autoShowPlaneIdWhenOpen ~= 0 then
    autoShowPlaneIndex = self:GetPlaneIndex(self.autoShowPlaneIdWhenOpen)
  end
  self.contentPos = 280 - (autoShowPlaneIndex - 1) * 255
  self.compContent:SetLocalPositionXYZ(self.contentPos, 0, 0)
  if self.itemList and 0 < #self.itemList then
    for i, v in ipairs(battlePlaneInfos) do
      if v then
        local index = i
        local item = self.itemList[index]
        if item then
          item:ReInit(v, self.curSelectedPlaneId == v.id, function()
            self:MoveToItem(index, true)
          end)
        end
      end
    end
  else
    for i, v in ipairs(battlePlaneInfos) do
      if v then
        self:CreateItem(i, v)
      end
    end
  end
end

local SPACING = 40
local SKIN_ITEM_WIDTH = 215

function UISkyBattlePlaneSkinPageView:CreateItem(index, data)
  self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIStageSkyBattleChapter/SkyBattlePlaneSkinItem.prefab", function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go:SetActive(true)
    go.transform:SetParent(self.compContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    local pos = 20 + (index - 1) * (SKIN_ITEM_WIDTH + SPACING)
    go.transform:Set_localPosition(pos, -131, 0)
    go.transform:SetSiblingIndex(index)
    go.name = "plane_" .. data.id
    local cell = self.compContent:AddComponent(SkyBattlePlaneSkinItemComponent, go.name)
    table.insert(self.itemList, cell)
    local realIndex = #self.itemList
    cell:ReInit(data, self.curSelectedPlaneId == data.id, function()
      self:MoveToItem(realIndex, true)
    end)
    local battlePlaneInfos = DataCenter.LWSkyBattleGrowthChapterManager.battlePlaneInfo
    if self.itemList and battlePlaneInfos and #self.itemList == #battlePlaneInfos then
      self.isItemLoadComplete = true
      if self.autoShowPlaneIdWhenOpen ~= 0 then
        local autoShowPlaneIndex = self:GetPlaneIndex(self.autoShowPlaneIdWhenOpen)
        self:MoveToItem(autoShowPlaneIndex, false)
      end
    end
  end)
end

function UISkyBattlePlaneSkinPageView:MoveToItem(itemIndex, noPlayAni)
  if not self.isItemLoadComplete or not self.itemList then
    return
  end
  if not itemIndex or itemIndex == 0 then
    return
  end
  local curShowIndex = 0
  if self.showedPlaneId and self.showedPlaneId ~= 0 then
    curShowIndex = self:GetPlaneIndex(self.showedPlaneId)
  end
  if curShowIndex == itemIndex then
    return
  end
  local preItem = self.itemList[curShowIndex]
  if preItem then
    preItem:Move({alpha = 0, scale = 1})
    preItem:SetShow(false)
  end
  self:PlayMoveContent(itemIndex)
  self.itemList[itemIndex].transform:SetAsLastSibling()
  self.itemList[itemIndex]:Move({alpha = 1, scale = 1.25}, noPlayAni)
  local itemId = self.itemList[itemIndex].data.id
  self:ChangePlaneAppearance(itemId)
  self.showedPlaneId = itemId
  if self.curSelectedPlaneId and self.curSelectedPlaneId == itemId then
    self.btnInUse:SetActive(true)
    self.btnUse:SetActive(false)
  else
    local owned = self.itemList[itemIndex].data.owned
    self.btnUse:SetActive(owned)
    self.btnInUse:SetActive(false)
  end
  self.itemList[itemIndex]:SetShow(true)
end

function UISkyBattlePlaneSkinPageView:PlayMoveContent(itemIndex)
  local nexPos = Vector3.New(280 - (itemIndex - 1) * 255, 0, 0)
  self.compContent.transform:DOLocalMove(nexPos, 0.3)
end

function UISkyBattlePlaneSkinPageView:GetPlaneIndex(planeId)
  local battlePlaneInfos = DataCenter.LWSkyBattleGrowthChapterManager.battlePlaneInfo
  if not battlePlaneInfos then
    return 0
  end
  for i, v in ipairs(battlePlaneInfos) do
    if v.id == planeId then
      return i
    end
  end
  return 0
end

function UISkyBattlePlaneSkinPageView:OnBtnRightChangeClick()
  if not self.showedPlaneId or self.showedPlaneId == 0 then
    return
  end
  if not self.isItemLoadComplete or not self.itemList then
    return
  end
  local curShowIndex = self:GetPlaneIndex(self.showedPlaneId)
  local nextIndex = curShowIndex + 1
  if nextIndex > #self.itemList then
    return
  end
  self:MoveToItem(nextIndex, true)
end

function UISkyBattlePlaneSkinPageView:OnBtnLeftChangeClick()
  if not self.showedPlaneId or self.showedPlaneId == 0 then
    return
  end
  if not self.isItemLoadComplete or not self.itemList then
    return
  end
  local curShowIndex = self:GetPlaneIndex(self.showedPlaneId)
  local nextIndex = curShowIndex - 1
  if nextIndex <= 0 then
    return
  end
  self:MoveToItem(nextIndex, true)
end

function UISkyBattlePlaneSkinPageView:OnBtnInUseClick()
end

function UISkyBattlePlaneSkinPageView:OnBtnUseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
end

return UISkyBattlePlaneSkinPageView
