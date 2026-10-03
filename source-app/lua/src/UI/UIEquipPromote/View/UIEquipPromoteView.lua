local UIEquipPromoteView = BaseClass("UIEquipPromoteView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BaseUIEquipItem = require("UI.UILWHero.UIHeroEquipListPanel.Component.BaseUIEquipItem")
local UIEquipPromoteBasicLineItem = require("UI.UIEquipPromote.Component.UIEquipPromoteBasicLineItem")
local UIEquipPromoteAdditionLineItem = require("UI.UIEquipPromote.Component.UIEquipPromoteAdditionLineItem")
local UIEquipCostItem = require("UI.UIEquipPromote.Component.UIEquipCostItem")
local promoteContainerPath = "Root/CenterInfo/PromoteContainer"
local promotingEquipItemPath = "Root/CenterInfo/PromoteContainer/PromotingEquipItem"
local changeContainerPath = "Root/CenterInfo/ChangeContainer"
local srcEquipItemPath = "Root/CenterInfo/ChangeContainer/SrcEquipItem"
local dstEquipItemPath = "Root/CenterInfo/ChangeContainer/DstEquipItem"
local promoteProgressPath = "Root/CenterInfo/PromoteProgress"
local promoteProgressSldierPath = "Root/CenterInfo/PromoteProgress/ProgressBg/Progress"
local basicAttrContainerPath = "Root/CenterInfo/BasicAttr"
local basicAttrLinePath = "Root/CenterInfo/BasicAttr/BasicAttrLines/BasicAttrLine%d"
local additionAttrContainerPath = "Root/CenterInfo/AdditionAttr"
local additionAttrLineContentPath = "Root/CenterInfo/AdditionAttr/AdditionAttrScroll/Viewport/Content"
local additionAttrLineTempaltePath = "Root/CenterInfo/AdditionAttr/AdditionAttrScroll/EquipPropertyLineItem"
local promoteBtnPath = "Root/CenterInfo/BtnGroup/PromoteBtn"
local promoteBtnTextPath = "Root/CenterInfo/BtnGroup/PromoteBtn/PromoteBtnText"
local promoteBtnRedPointPath = "Root/CenterInfo/BtnGroup/PromoteBtn/RedPoint"
local costGroupPath = "Root/CenterInfo/BtnGroup/CostGroup"
local costItem1Path = "Root/CenterInfo/BtnGroup/CostGroup/CostItem%d"
local backBtnPath = "Root/BottomInfo/BtnBack"
local promotingEquipNameTextPath = "Root/CenterInfo/PromoteContainer/PromotingEquipNameText"
local srcEquipNameTextPath = "Root/CenterInfo/ChangeContainer/SrcEquipItemNameText"
local dstEquipNameTextPath = "Root/CenterInfo/ChangeContainer/DstEquipItemNameText"
local leftArrowPath = "Root/CenterInfo/ChangeHeroArrow/ToPrevHeroArrow"
local rightArrowPath = "Root/CenterInfo/ChangeHeroArrow/ToNextHeroArrow"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local equipUid, equipUids, closeCallback = self:GetUserData()
  self.equipUids = equipUids or {equipUid}
  if not equipUid then
    return
  end
  local index = 1
  for i, v in ipairs(self.equipUids) do
    if v == equipUid then
      index = i
      break
    end
  end
  self:GotoPage(index)
end

local function OnDestroy(self)
  self:ClearAdditionEffects()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, backBtnPath)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.promoteContainer = self:AddComponent(UIBaseContainer, promoteContainerPath)
  self.promotingEquipItem = self:AddComponent(BaseUIEquipItem, promotingEquipItemPath)
  self.changeContainer = self:AddComponent(UIBaseContainer, changeContainerPath)
  self.srcEquipItem = self:AddComponent(BaseUIEquipItem, srcEquipItemPath)
  self.dstEquipItem = self:AddComponent(BaseUIEquipItem, dstEquipItemPath)
  self.promoteProgress = self:AddComponent(UIBaseContainer, promoteProgressPath)
  self.promoteProgressSldier = self:AddComponent(UISlider, promoteProgressSldierPath)
  self.promoteProgressSldier:SetValue(0)
  self.basicAttrContainer = self:AddComponent(UIBaseContainer, basicAttrContainerPath)
  self.basicAttrLines = {}
  for i = 1, 4 do
    self.basicAttrLines[i] = self:AddComponent(UIEquipPromoteBasicLineItem, string.format(basicAttrLinePath, i))
  end
  self.additionAttrContainer = self:AddComponent(UIBaseContainer, additionAttrContainerPath)
  self.additionAttrLineContent = self:AddComponent(UIBaseContainer, additionAttrLineContentPath)
  self.additionAttrLineTempalte = self:AddComponent(UIBaseContainer, additionAttrLineTempaltePath)
  self.additionAttrLineTempalte.gameObject:GameObjectCreatePool()
  self.promoteBtn = self:AddComponent(UIButton, promoteBtnPath)
  self.promoteBtn:SetOnClick(function()
    self:OnPromoteBtnClick()
  end)
  self.promoteBtnText = self:AddComponent(UIText, promoteBtnTextPath)
  self.promoteBtnRedPoint = self:AddComponent(UIImage, promoteBtnRedPointPath)
  self.costGroup = self:AddComponent(UIBaseContainer, costGroupPath)
  self.costItems = {}
  for i = 1, 4 do
    self.costItems[i] = self:AddComponent(UIEquipCostItem, string.format(costItem1Path, i))
  end
  self.promotingEquipNameText = self:AddComponent(UIText, promotingEquipNameTextPath)
  self.srcEquipNameText = self:AddComponent(UIText, srcEquipNameTextPath)
  self.dstEquipNameText = self:AddComponent(UIText, dstEquipNameTextPath)
  self.leftArrow = self:AddComponent(UIButton, leftArrowPath)
  self.leftArrow:SetOnClick(function()
    self:GotoNextPage(true)
  end)
  self.rightArrow = self:AddComponent(UIButton, rightArrowPath)
  self.rightArrow:SetOnClick(function()
    self:GotoNextPage(false)
  end)
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.promoteContainer = nil
  self.promotingEquipItem = nil
  self.changeContainer = nil
  self.srcEquipItem = nil
  self.dstEquipItem = nil
  self.promoteProgress = nil
  self.promoteProgressSldier = nil
  self.basicAttrContainer = nil
  self.basicAttrLines = nil
  self.additionAttrContainer = nil
  self.additionAttrLineContent = nil
  self.additionAttrLineTempalte = nil
  self.promoteBtn = nil
  self.promoteBtnText = nil
  self.promoteBtnRedPoint = nil
  self.costGroup = nil
  self.costItems = nil
  self.promotingEquipName = nil
  self.srcEquipName = nil
  self.dstEquipName = nil
end

local function DataDefine(self)
  self.additionAttrItems = {}
end

local function DataDestroy(self)
end

local function OnResOrResItemUpdate(self)
  for i = 1, 4 do
    self.costItems[i]:RefreshShowData()
  end
  if self.promoteBtn:GetActiveInHierarchy() then
    self.promoteBtnRedPoint:SetActive(self.equipData:CanPromote())
  end
end

local function OnEquipPromote(self, equipUuid)
  if not self.equipData then
    return
  end
  if self.equipData.uuid ~= equipUuid then
    return
  end
  for i = 1, 4 do
    self.basicAttrLines[i]:ShowEffect()
  end
  if self.equipData.promoteLevel > 0 and self.equipData.promoteLevel % 5 == 0 then
    local curLevelAttr = self.equipData:CollectBasicAttr(self.equipData.level, self.equipData.promoteLevel)
    local prevLevelAttr = self.equipData:CollectBasicAttr(self.equipData.level, self.equipData.promoteLevel - 1)
    local attrs = {}
    if not table.IsNullOrEmpty(curLevelAttr.effects) then
      for k, v in pairs(curLevelAttr.effects) do
        local attrData = {}
        attrData.id = k
        attrData.value = v
        if prevLevelAttr and prevLevelAttr.effects and prevLevelAttr.effects[k] then
          attrData.prevValue = prevLevelAttr.effects[k]
        end
        attrData.isAddition = false
        table.insert(attrs, attrData)
      end
    end
    table.sort(attrs, function(a, b)
      local aTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(a.id)
      local bTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(b.id)
      return aTemplate.sequence < bTemplate.sequence
    end)
    local curLevelAddition = self.equipData:CollectAdditionAttr(self.equipData.level, self.equipData.promoteLevel)
    local prevLevelAddition = self.equipData:CollectAdditionAttr(self.equipData.level, self.equipData.promoteLevel - 1)
    local additionData = {}
    if not table.IsNullOrEmpty(curLevelAddition) then
      for index, data in pairs(curLevelAddition) do
        local prevLevelData = prevLevelAddition[index]
        if prevLevelData then
          for k, v in pairs(data.effects) do
            if prevLevelData.effects[k] and prevLevelData.effects[k] ~= v then
              local attrData = {}
              attrData.id = k
              attrData.value = v
              if prevLevelData.effects[k] then
                attrData.prevValue = prevLevelData.effects[k]
              end
              attrData.isAddition = true
              table.insert(additionData, attrData)
            end
          end
        else
          for k, v in pairs(data.effects) do
            local attrData = {}
            attrData.id = k
            attrData.value = v
            attrData.isAddition = true
            table.insert(additionData, attrData)
          end
        end
      end
    end
    table.sort(additionData, function(a, b)
      local aTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(a.id)
      local bTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(b.id)
      return aTemplate.sequence < bTemplate.sequence
    end)
    table.insertto(attrs, additionData)
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIEquipPromoteSuccess) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipPromoteSuccess, {anim = true}, self.equipData.uuid, attrs)
    end
  end
  self:Refresh()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeorEquipPromote, self.OnEquipPromote)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrResItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResOrResItemUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeorEquipPromote, self.OnEquipPromote)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrResItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResOrResItemUpdate)
end

local function RefershShowEquipItem(self)
  if not self.equipData then
    return
  end
  local config = self.equipData.config
  if self.equipData.promoteLevel + 1 == config.target_level then
    self.changeContainer:SetActive(true)
    self.promoteContainer:SetActive(false)
    self.srcEquipItem:SetData(self.equipData)
    self.srcEquipItem:ShowOwnerHero(self.equipData.heroUuid)
    self.srcEquipNameText:SetLocalText(self.equipData.config.name)
    local dstEquipTemplateId = config.target_promote
    if 0 < dstEquipTemplateId then
      local dstEquipTemplate = DataCenter.EquipTemplateManager:GetTemplate(dstEquipTemplateId)
      if dstEquipTemplate then
        self.dstEquipItem:SetTemplateData(dstEquipTemplateId)
        self.dstEquipItem:ShowOwnerHero(self.equipData.heroUuid)
        self.dstEquipItem:SetEquipRank(config.target_level, config.target_level)
        self.dstEquipNameText:SetLocalText(dstEquipTemplate.name)
      end
    end
  elseif self.equipData.promoteLevel > 0 and self.equipData.promoteLevel % 5 / 4 == 1 then
    self.changeContainer:SetActive(true)
    self.promoteContainer:SetActive(false)
    self.srcEquipItem:SetData(self.equipData)
    self.srcEquipItem:ShowOwnerHero(self.equipData.heroUuid)
    self.srcEquipNameText:SetLocalText(self.equipData.config.name)
    self.dstEquipItem:SetTemplateData(config.id)
    self.dstEquipItem:ShowOwnerHero(self.equipData.heroUuid)
    self.dstEquipItem:SetEquipRank(self.equipData.promoteLevel + 1, config.target_level)
    self.dstEquipNameText:SetLocalText(config.name)
  else
    self.changeContainer:SetActive(false)
    self.promoteContainer:SetActive(true)
    self.promotingEquipItem:SetData(self.equipData)
    self.promotingEquipItem:ShowOwnerHero(self.equipData.heroUuid)
    self.promotingEquipNameText:SetLocalText(self.equipData.config.name)
  end
end

local function RefreshPromoteSldier(self)
  if not self.equipData then
    return
  end
  local config = self.equipData.config
  local curProgresss = self.equipData.promoteLevel % 5 / 4
  if self.equipData.promoteLevel >= config.target_level then
    curProgresss = 1
  end
  self.promoteProgressSldier:SetValue(curProgresss)
end

local function RefreshBasicAttri(self)
  if not self.equipData then
    return
  end
  local curLevelBasicAttrData = self.equipData:GetBasicAttr()
  local attrs = {}
  local showNextLevel = self.equipData.promoteLevel < self.equipData.maxPromoteLevel
  local nextLevelAttr
  if showNextLevel then
    nextLevelAttr = self.equipData:CollectBasicAttr(self.equipData.level, self.equipData.promoteLevel + 1)
  end
  if not table.IsNullOrEmpty(curLevelBasicAttrData.effects) then
    for k, v in pairs(curLevelBasicAttrData.effects) do
      local attrData = {}
      attrData.id = k
      attrData.value = v
      if nextLevelAttr and nextLevelAttr.effects and nextLevelAttr.effects[k] then
        attrData.nextValue = nextLevelAttr.effects[k]
      end
      table.insert(attrs, attrData)
    end
  end
  table.sort(attrs, function(a, b)
    local aTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(a.id)
    local bTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(b.id)
    if aTemplate == nil and bTemplate ~= nil then
      return false
    end
    if aTemplate ~= nil and bTemplate == nil then
      return true
    end
    if aTemplate == nil and bTemplate == nil then
      return true
    end
    return aTemplate.sequence < bTemplate.sequence
  end)
  for i = 1, 4 do
    if attrs[i] then
      self.basicAttrLines[i]:SetData(attrs[i])
    else
      self.basicAttrLines[i]:SetData(nil)
    end
  end
end

local function ClearAdditionEffects(self)
  self.additionAttrLineContent:RemoveComponents(UIEquipPromoteAdditionLineItem)
  if self.additionAttrLineTempalte and not IsNull(self.additionAttrLineTempalte) then
    self.additionAttrLineTempalte.gameObject:GameObjectRecycleAll()
  end
  self.additionAttrItems = {}
end

local function RefreshAdditionAttri(self)
  if not self.equipData then
    return
  end
  local config = self.equipData.config
  if not config then
    return
  end
  local addsWord = config:GeRealAddsByLvs(self.equipData.level, self.equipData.promoteLevel, true)
  local addsAttris = {}
  local showNextLevel = self.equipData.promoteLevel < self.equipData.maxPromoteLevel
  local nextLevelAdditions
  if showNextLevel then
    nextLevelAdditions = self.equipData:CollectAdditionAttr(self.equipData.level, self.equipData.promoteLevel + 1)
  end
  for i = 1, #addsWord do
    local word = addsWord[i]
    local wordTemplate = DataCenter.EquipWordTemplateManager:GetTemplate(word.id)
    local toolArray = {}
    local nextWordTemp
    if nextLevelAdditions then
      local nextWord = nextLevelAdditions[i]
      if nextWord then
        nextWordTemp = nextWord
      end
    end
    if wordTemplate ~= nil then
      for id, value in pairs(wordTemplate.effects) do
        local propertyData = {}
        propertyData.id = id
        propertyData.value = value
        if nextWordTemp and nextWordTemp.effects and nextWordTemp.effects[id] then
          propertyData.nextValue = nextWordTemp.effects[id]
        end
        propertyData.unlockLevel = word.unlockLevel
        propertyData.needPromoteLv = word.needPromoteLv
        propertyData.isBaseWord = false
        propertyData.isPromoteAdd = word.isPromoteAdd
        table.insert(toolArray, propertyData)
      end
      table.sort(toolArray, function(a, b)
        local aTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(a.id)
        local bTemplate = DataCenter.EffectNumberTemplateManager:GetTemplate(b.id)
        return aTemplate.sequence < bTemplate.sequence
      end)
      table.insertto(addsAttris, toolArray)
    end
  end
  if table.IsNullOrEmpty(self.additionAttrItems) then
    for i, v in pairs(addsAttris) do
      local item = self.additionAttrLineTempalte.gameObject:GameObjectSpawn(self.additionAttrLineContent.transform)
      item.name = "item" .. i
      local obj = self.additionAttrLineContent:AddComponent(UIEquipPromoteAdditionLineItem, item.name)
      obj:SetData(addsAttris[i], self.equipData.promoteLevel)
      table.insert(self.additionAttrItems, obj)
    end
  else
    for i, v in pairs(self.additionAttrItems) do
      local item = v
      if item then
        item:SetData(addsAttris[i], self.equipData.promoteLevel)
      end
    end
  end
end

local function RefreshPromoteBtn(self)
  if not self.equipData then
    self.promoteBtn:SetActive(false)
    self.costGroup:SetActive(false)
    return
  end
  if self.equipData:IsMaxPromoteLevel() then
    self.promoteBtn:SetActive(false)
    self.costGroup:SetActive(false)
    return
  end
  self.promoteBtn:SetActive(true)
  self.costGroup:SetActive(true)
  self.promoteBtnRedPoint:SetActive(self.equipData:CanPromote())
  self.promoteCostTemplate = DataCenter.EquipPromoteTemplateManager:GetTemplate(self.equipData.promoteLevel + 1)
  if self.promoteCostTemplate then
    local costData = self.promoteCostTemplate:ParseData()
    for i = 1, 4 do
      if costData[i] then
        self.costItems[i]:SetActive(true)
        self.costItems[i]:SetData(costData[i])
      else
        self.costItems[i]:SetActive(false)
      end
    end
  else
    for i = 1, 4 do
      self.costItems[i]:SetActive(false)
    end
  end
end

local function Refresh(self)
  self:RefershShowEquipItem()
  self:RefreshPromoteSldier()
  self:RefreshBasicAttri()
  self:RefreshAdditionAttri()
  self:RefreshPromoteBtn()
end

local function OnPromoteBtnClick(self)
  if not self.equipData then
    return
  end
  if not DataCenter.EquipDataManager:CanShowEquipStar(self.equipData) then
    return
  end
  if self.promoteCostTemplate then
    local costData = self.promoteCostTemplate:ParseData()
    local lackRes = {}
    local lackResItem = {}
    for _, data in pairs(costData) do
      if data.isResource then
        local resourceType = data.id
        local haveCount = LuaEntry.Resource:GetCntByResType(resourceType)
        local needCount = data.value
        if haveCount < needCount then
          local param = {}
          param.resType = resourceType
          param.need = needCount
          table.insert(lackRes, param)
        end
      else
        local haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(data.id)
        local needCount = data.value
        if haveCount < needCount then
          local param = {}
          param.itemId = data.id
          param.need = needCount
          table.insert(lackResItem, param)
        end
      end
    end
    if not table.IsNullOrEmpty(lackRes) then
      if CS.SceneManager:IsInPVE() then
        UIUtil.ShowTipsId("quick_upgrade_tips")
        return
      end
      LWResourceLackUtil:GotoResLack(lackRes)
      return
    end
    if not table.IsNullOrEmpty(lackResItem) then
      if CS.SceneManager:IsInPVE() then
        UIUtil.ShowTipsId("quick_upgrade_tips")
        return
      end
      for _, v in pairs(lackResItem) do
        LWResourceLackUtil:GotoResourceItemLack(v.itemId, v.need)
      end
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.HeroEquipPromote, self.equipData.uuid)
end

local function GotoPage(self, pageId)
  if not pageId then
    return
  end
  local equipUid = self.equipUids[pageId]
  if not equipUid then
    return
  end
  self.equipData = DataCenter.EquipDataManager:GetEquipByUuid(equipUid)
  if not self.equipData then
    return
  end
  self.ctrl:SetCurEquipUuid(equipUid)
  self.pageId = pageId
  self:Refresh()
  self:RefreshArrow()
end

local function RefreshArrow(self)
  self.leftArrow:SetActive(self.pageId > 1)
  self.rightArrow:SetActive(self.pageId < #self.equipUids)
end

local function GotoNextPage(self, isLeft)
  if isLeft and self.pageId <= 1 then
    return
  end
  if not isLeft and self.pageId >= #self.equipUids then
    return
  end
  local stride = isLeft and -1 or 1
  self:GotoPage(self.pageId + stride)
end

UIEquipPromoteView.OnCreate = OnCreate
UIEquipPromoteView.OnDestroy = OnDestroy
UIEquipPromoteView.OnEnable = OnEnable
UIEquipPromoteView.OnDisable = OnDisable
UIEquipPromoteView.ComponentDefine = ComponentDefine
UIEquipPromoteView.ComponentDestroy = ComponentDestroy
UIEquipPromoteView.DataDefine = DataDefine
UIEquipPromoteView.DataDestroy = DataDestroy
UIEquipPromoteView.OnAddListener = OnAddListener
UIEquipPromoteView.OnRemoveListener = OnRemoveListener
UIEquipPromoteView.Refresh = Refresh
UIEquipPromoteView.RefershShowEquipItem = RefershShowEquipItem
UIEquipPromoteView.RefreshPromoteSldier = RefreshPromoteSldier
UIEquipPromoteView.RefreshBasicAttri = RefreshBasicAttri
UIEquipPromoteView.ClearAdditionEffects = ClearAdditionEffects
UIEquipPromoteView.RefreshAdditionAttri = RefreshAdditionAttri
UIEquipPromoteView.RefreshPromoteBtn = RefreshPromoteBtn
UIEquipPromoteView.OnPromoteBtnClick = OnPromoteBtnClick
UIEquipPromoteView.OnResOrResItemUpdate = OnResOrResItemUpdate
UIEquipPromoteView.OnEquipPromote = OnEquipPromote
UIEquipPromoteView.GotoPage = GotoPage
UIEquipPromoteView.RefreshArrow = RefreshArrow
UIEquipPromoteView.GotoNextPage = GotoNextPage
return UIEquipPromoteView
