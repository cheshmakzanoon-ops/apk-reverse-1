local base = require("UI/UILWDominator/Main/Component/UILWDominatorMainPageBaseComponent")
local UILWDominatorMainRankPreviewPageComponent = BaseClass("UILWDominatorMainRankPreviewPageComponent", base)
local Localization = CS.GameEntry.Localization
local UILWDominatorMainRankPreviewSelectItemComponent = require("UI/UILWDominator/Main/Component/RankPreview/UILWDominatorMainRankPreviewSelectItemComponent")
local UILWDominatorMainAttributeItemComponent = require("UI/UILWDominator/Main/Component/AdvancePage/UILWDominatorMainAttributeItemComponent")

function UILWDominatorMainRankPreviewPageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainRankPreviewPageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainRankPreviewPageComponent:ReInit(userData)
  self.userData = userData
  self.info = self.view:GetCurShowInfo()
  if self.info == nil then
    return
  end
  self.mainTemplate = self.info:GetMainTemplate()
  if self.mainTemplate == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.allRankShowTemplates = DataCenter.DominatorTemplateManager:GetAllRankShowTemplatesInOrderByGroup(self.mainTemplate.dominator_star_id)
  if table.IsNullOrEmpty(self.allRankShowTemplates) then
    self.ctrl:CloseSelf()
    return
  end
  self.info = DataCenter.DominatorManager:GetInfoById(self.mainTemplate.id)
  if self.info == nil then
    self.curRankShowTemplate = self.allRankShowTemplates[1]
  else
    self.curRankShowTemplate = self.info:GetCurRankShowTemplate()
  end
  if self.curRankShowTemplate == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.curMinRankTemplate = self.curRankShowTemplate:GetMinLevelRankTemplate()
  if self.curMinRankTemplate == nil then
    self.ctrl:CloseSelf()
    return
  end
  self:UpdateContent()
  self:UpdateDropdown()
  self.view:UpdateModelViewer()
end

function UILWDominatorMainRankPreviewPageComponent:UpdateDropdown()
  self:ClearDropdown()
  if self.allRankShowTemplates == nil then
    return
  end
  for i, v in pairs(self.allRankShowTemplates) do
    local item = self.compLevelItem.gameObject:GameObjectSpawn(self.compDropdownContent.transform)
    item.name = "item" .. i
    local obj = self.compDropdownContent:AddComponent(UILWDominatorMainRankPreviewSelectItemComponent, item.name)
    obj:SetActive(true)
    obj:ReInit(v, self.clickItemCallBack)
    obj:SetBgActive(i % 2 == 1)
  end
end

function UILWDominatorMainRankPreviewPageComponent:UpdateContent()
  if self.curRankShowTemplate == nil or self.curMinRankTemplate == nil then
    return
  end
  self.textUpgradeLocked:SetActive(not DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock())
  self.imgRankIcon:LoadSprite(self.curRankShowTemplate:GetRankIconPathBig())
  self.textName:SetText(self.curRankShowTemplate:GetName())
  self.textCurSelectLevel:SetText(self.curRankShowTemplate:GetPreviewShowLevelText())
  local showEffects = {}
  if self.curMinRankTemplate then
    local effects = self.curMinRankTemplate:GetFakeEffectInfoForPreview()
    local index = 1
    if not table.IsNullOrEmpty(effects) then
      for i, v in ipairs(effects) do
        showEffects[i] = {
          index = index,
          curValue = v.effectValue,
          effectId = v.effectId,
          title = Localization:GetString(GetTableData(TableName.LW_Effect_Number, v.effectId, "name", ""))
        }
        index = index + 1
      end
    end
  end
  if table.IsNullOrEmpty(showEffects) then
    self.compAttributesContent:SetActive(false)
  else
    self.compAttributesContent:SetActive(true)
    local num = 0
    local totalNum = table.count(showEffects)
    local needLoadGameObject = false
    for _, v in ipairs(showEffects) do
      num = num + 1
      local index = num
      if self.effectItems[index] == nil and self.effectItemsReqs[index] == nil then
        needLoadGameObject = true
        local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainAttributeItem.prefab")
        loadRequest:completed("+", function()
          if not IsNull(loadRequest.gameObject) and not IsNull(self.compAttributesContent) then
            local pageObj = loadRequest.gameObject
            local transform = pageObj.transform
            transform:SetParent(self.compAttributesContent.transform)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            pageObj.name = "effectItem" .. index
            local item = self:AddComponent(UILWDominatorMainAttributeItemComponent, pageObj)
            item:SetActive(true)
            item:ReInit(v, true)
            item:SetBgActive(index % 2 == 1)
            item:SetColorRGBA255(112, 138, 176, 22)
            item:SetSizeDeltaXY(580, 60)
            self.effectItems[index] = item
          end
        end)
        self.effectItemsReqs[index] = loadRequest
      elseif self.effectItems[index] ~= nil then
        self.effectItems[index]:SetActive(true)
        self.effectItems[index]:ReInit(v, true)
        self.effectItems[index]:SetBgActive(index % 2 == 1)
        self.effectItems[index]:SetColorRGBA255(112, 138, 176, 22)
        self.effectItems[index]:SetSizeDeltaXY(580, 60)
      end
    end
    for i, v in pairs(self.effectItems) do
      if i > num then
        v:SetActive(false)
      end
    end
  end
end

function UILWDominatorMainRankPreviewPageComponent:ClearDropdown()
  self.compDropdownContent:RemoveComponents(UILWDominatorMainRankPreviewSelectItemComponent)
  self.compLevelItem.gameObject:GameObjectRecycleAll()
end

function UILWDominatorMainRankPreviewPageComponent:OnClickItem(rankShowTemplate)
  if rankShowTemplate == nil then
    return
  end
  if self.curRankShowTemplate ~= nil and self.curRankShowTemplate.id == rankShowTemplate.id then
    return
  end
  self.curRankShowTemplate = rankShowTemplate
  self.curMinRankTemplate = self.curRankShowTemplate:GetMinLevelRankTemplate()
  self:OnBtnCloseDropdownClick()
  self:UpdateContent()
  self.view:UpdateModelViewer()
end

function UILWDominatorMainRankPreviewPageComponent:GetCurRankShowTemplate()
  return self.curRankShowTemplate
end

function UILWDominatorMainRankPreviewPageComponent:ComponentDefine()
  self.btnCloseDropdown = self:AddComponent(UIButton, "Root/CloseDropdownBtn")
  self.btnCloseDropdown:SetOnClick(function()
    self:OnBtnCloseDropdownClick()
  end)
  self.imgRankIcon = self:AddComponent(UIImage, "Root/Middle/BasicInfoContent/RankIcon")
  self.textName = self:AddComponent(UIText, "Root/Middle/BasicInfoContent/NameText")
  self.compAttributesContent = self:AddComponent(UIBaseContainer, "Root/Middle/AttributesContent")
  self.compLevelItem = self:AddComponent(UILWDominatorMainRankPreviewSelectItemComponent, "Root/Middle/SelectContent/LevelItem")
  self.compLevelItem.gameObject:GameObjectCreatePool()
  self.compLevelItem:SetActive(false)
  self.textCurSelectLevel = self:AddComponent(UIText, "Root/Middle/SelectContent/CurSelectedLevel/CurSelectLevelText")
  self.btnDropdown = self:AddComponent(UIButton, "Root/Middle/SelectContent/CurSelectedLevel/DropdownBtn")
  self.btnDropdown:SetOnClick(function()
    self:OnBtnDropdownClick()
  end)
  self.compDropdownContent = self:AddComponent(UIBaseContainer, "Root/Middle/SelectContent/DropdownContent")
  self.compDropdownContent:SetActive(false)
  self.textUpgradeLocked = self:AddComponent(UIText, "Root/Middle/UpgradeLockedText")
  self.textUpgradeLocked:SetText(Localization:GetString("dominator_star_preview_desc_1"))
end

function UILWDominatorMainRankPreviewPageComponent:ComponentDestroy()
  self:ClearDropdown()
  self.btnCloseDropdown = nil
  self.imgRankIcon = nil
  self.textName = nil
  self.compAttributesContent = nil
  self.compLevelItem = nil
  self.textCurSelectLevel = nil
  self.btnDropdown = nil
  self.compDropdownContent = nil
  self.textUpgradeLocked = nil
end

function UILWDominatorMainRankPreviewPageComponent:DataDefine()
  self.curRankShowTemplate = nil
  self.allRankShowTemplates = nil
  self.mainTemplate = nil
  self.info = nil
  self.effectItems = {}
  self.effectItemsReqs = {}
  self.clickItemCallBack = BindCallback(self, self.OnClickItem)
end

function UILWDominatorMainRankPreviewPageComponent:DataDestroy()
  self.curRankShowTemplate = nil
  self.allRankShowTemplates = nil
  self.mainTemplate = nil
  self.info = nil
  self.effectItems = nil
  self.effectItemsReqs = nil
  self.clickItemCallBack = nil
end

function UILWDominatorMainRankPreviewPageComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainRankPreviewPageComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorMainRankPreviewPageComponent:OnBtnCloseDropdownClick()
  self.btnCloseDropdown:SetActive(false)
  self.compDropdownContent:SetActive(false)
end

function UILWDominatorMainRankPreviewPageComponent:OnBtnDropdownClick()
  if self.compDropdownContent.gameObject.activeSelf then
  end
  self.btnCloseDropdown:SetActive(true)
  self.compDropdownContent:SetActive(true)
end

function UILWDominatorMainRankPreviewPageComponent:CustomBtnBackClick()
  if self.userData and self.userData.source then
    self.view:SetCurShowPageTag(self.userData.source)
  end
end

return UILWDominatorMainRankPreviewPageComponent
