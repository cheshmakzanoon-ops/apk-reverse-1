local base = UIBaseContainer
local UILWDominatorMainTrainDetailComponent = BaseClass("UILWDominatorMainTrainDetailComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWDominatorMainAttributeItemComponent = require("UI/UILWDominator/Main/Component/AdvancePage/UILWDominatorMainAttributeItemComponent")
local UIGray = CS.UIGray

function UILWDominatorMainTrainDetailComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainTrainDetailComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainTrainDetailComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textMax = self:AddComponent(UIText, "MaxText")
  self.textMax:SetText(Localization:GetString("dominator_star_desc_1"))
  self.btnUpgrade = self:AddComponent(UIButton, "UpgradeBtn")
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.textUpgradeBtn = self:AddComponent(UIText, "UpgradeBtn/Btn/UpgradeBtnText")
  self.textUpgradeBtn:SetText(Localization:GetString("dominator_train_button_2"))
  self.compRedPointUpgrade = self:AddComponent(UIBaseContainer, "UpgradeBtn/RedPointUpgrade")
  self.compCost1 = self:AddComponent(UIBaseContainer, "CostLayout/Cost1")
  self.compCostLayout = self:AddComponent(UIBaseContainer, "CostLayout")
  self.imgCostIcon1 = self:AddComponent(UIImage, "CostLayout/Cost1/CostIcon1")
  self.textCostText1 = self:AddComponent(UIText, "CostLayout/Cost1/CostText1")
  self.compCost2 = self:AddComponent(UIBaseContainer, "CostLayout/Cost2")
  self.imgCostIcon2 = self:AddComponent(UIImage, "CostLayout/Cost2/CostIcon2")
  self.textCostText2 = self:AddComponent(UIText, "CostLayout/Cost2/CostText2")
  self.compEffectContent = self:AddComponent(UIBaseContainer, "EffectContent")
  self.btnClose = self:AddComponent(UIButton, "CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textLimit = self:AddComponent(UIText, "LimitText")
end

function UILWDominatorMainTrainDetailComponent:ComponentDestroy()
  self.textTitle = nil
  self.textMax = nil
  self.btnUpgrade = nil
  self.textUpgradeBtn = nil
  self.compRedPointUpgrade = nil
  self.compCost1 = nil
  self.compCostLayout = nil
  self.imgCostIcon1 = nil
  self.textCostText1 = nil
  self.compCost2 = nil
  self.imgCostIcon2 = nil
  self.textCostText2 = nil
  self.compEffectContent = nil
  self.btnClose = nil
  self.textLimit = nil
end

function UILWDominatorMainTrainDetailComponent:DataDefine()
  self.effectItems = {}
  self.effectItemsReqs = {}
end

function UILWDominatorMainTrainDetailComponent:DataDestroy()
  self.effectItems = nil
  self.effectItemsReqs = nil
end

function UILWDominatorMainTrainDetailComponent:ReInit(param)
  self.param = param
  self.trainGroupId = self.param.trainGroupId
  self.root = self.param.root
  self.trainGroupTemplate = DataCenter.DominatorTemplateManager:GetTrainGroupTemplateById(self.trainGroupId)
  if self.trainGroupTemplate == nil then
    return
  end
  self.info = DataCenter.DominatorManager:GetTrainInfoByGroupId(self.trainGroupId)
  if self.info == nil then
    return
  end
  self.textTitle:SetText(self.trainGroupTemplate:GetName())
  self:UpdateCost()
  self:UpdateEffect(true)
end

function UILWDominatorMainTrainDetailComponent:UpdateCost()
  if not self.info then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  local isMax = curLevelTemplate:IsMaxLevel()
  self.btnUpgrade:SetActive(not isMax)
  self.compCost1:SetActive(not isMax)
  self.compCost2:SetActive(not isMax)
  self.textLimit:SetActive(not isMax)
  self.textMax:SetActive(isMax)
  if not isMax then
    local isRequireOK = curLevelTemplate:IsRequireOK()
    if not isRequireOK then
      self.textLimit:SetActive(true)
      self.textLimit:SetText(curLevelTemplate:GetRequireText())
      self.compCost1:SetActive(false)
      self.compCost2:SetActive(false)
      self.compRedPointUpgrade:SetActive(false)
      UIGray.SetGray(self.btnUpgrade.transform, true, true)
    else
      self.textLimit:SetActive(false)
      UIGray.SetGray(self.btnUpgrade.transform, false, true)
      local costInfo = curLevelTemplate:GetUpgradeCostInfo()
      self.compCost1:SetActive(costInfo[1] ~= nil)
      if costInfo[1] ~= nil then
        local icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costInfo[1].itemId)
        self.imgCostIcon1:LoadSprite(icon)
        local haveCount = DataCenter.ItemData:GetItemCount(costInfo[1].itemId)
        if haveCount >= costInfo[1].count then
          self.textCostText1:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, costInfo[1].count))
        else
          self.textCostText1:SetText(string.format("<color=#F97077>%d</color>/%d", haveCount, costInfo[1].count))
        end
      end
      self.compCost2:SetActive(costInfo[2] ~= nil)
      if costInfo[2] ~= nil then
        local icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costInfo[2].itemId)
        self.imgCostIcon2:LoadSprite(icon)
        local haveCount = DataCenter.ItemData:GetItemCount(costInfo[2].itemId)
        if haveCount >= costInfo[2].count then
          self.textCostText2:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, costInfo[2].count))
        else
          self.textCostText2:SetText(string.format("<color=#F97077>%d</color>/%d", haveCount, costInfo[2].count))
        end
      end
      self.compRedPointUpgrade:SetActive(self.info:IsCanUpgrade())
    end
  end
end

function UILWDominatorMainTrainDetailComponent:UpdateEffect(isFromInit)
  if not self.info then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  local showEffects = self:GetShowEffects(curLevelTemplate)
  if table.IsNullOrEmpty(showEffects) then
    self.compEffectContent:SetActive(false)
  else
    self.compEffectContent:SetActive(true)
    local num = 1
    for _, v in ipairs(showEffects) do
      local index = num
      if self.effectItems[index] == nil and self.effectItemsReqs[index] == nil then
        local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainAttributeItem.prefab")
        loadRequest:completed("+", function()
          if not IsNull(loadRequest.gameObject) and not IsNull(self.compEffectContent) then
            local pageObj = loadRequest.gameObject
            local transform = pageObj.transform
            transform:SetParent(self.compEffectContent.transform)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            pageObj.name = "effectItem" .. index
            local item = self:AddComponent(UILWDominatorMainAttributeItemComponent, pageObj)
            item:SetActive(true)
            item:ReInit(v, isFromInit)
            item:SetBgActive(index % 2 == 1)
            item:SetColorRGBA255(112, 138, 176, 70)
            item:SetSizeDeltaXY(670, 60)
            if not isFromInit then
              item:PlayEffect(nil)
            end
            self.effectItems[index] = item
          end
        end)
        self.effectItemsReqs[index] = loadRequest
      elseif self.effectItems[index] ~= nil then
        self.effectItems[index]:SetActive(true)
        self.effectItems[index]:ReInit(v, isFromInit)
        self.effectItems[index]:SetBgActive(index % 2 == 1)
        self.effectItems[index]:SetColorRGBA255(112, 138, 176, 70)
        self.effectItems[index]:SetSizeDeltaXY(670, 60)
        if not isFromInit then
          self.effectItems[index]:PlayEffect(nil)
        end
      end
      num = num + 1
    end
    for i, v in pairs(self.effectItems) do
      if i > num then
        v:SetActive(false)
      end
    end
  end
end

function UILWDominatorMainTrainDetailComponent:GetShowEffects(levelTemplate)
  local res = {}
  local showEffectDict = {}
  local curEffects = levelTemplate:GetCombineEffects()
  local effectCount = 1
  if not table.IsNullOrEmpty(curEffects) then
    for i, v in ipairs(curEffects) do
      showEffectDict[v.effectId] = {
        index = effectCount,
        curValue = math.floor(v.effectValue),
        effectId = v.effectId,
        title = Localization:GetString(GetTableData(TableName.LW_Effect_Number, v.effectId, "name", ""))
      }
      effectCount = effectCount + 1
    end
  end
  local nextTemplate = levelTemplate:GetNextLevelTemplate()
  if nextTemplate then
    local nextEffects = nextTemplate:GetCombineEffects()
    if not table.IsNullOrEmpty(nextEffects) then
      for i, v in ipairs(nextEffects) do
        if showEffectDict[v.effectId] then
          showEffectDict[v.effectId].nextValue = v.effectValue
        else
          showEffectDict[v.effectId] = {
            index = effectCount,
            curValue = 0,
            nextValue = math.floor(v.effectValue),
            effectId = v.effectId,
            title = Localization:GetString(GetTableData(TableName.LW_Effect_Number, v.effectId, "name", ""))
          }
          effectCount = effectCount + 1
        end
      end
    end
  end
  for i, v in pairs(showEffectDict) do
    table.insert(res, v)
  end
  table.sort(res, function(a, b)
    return a.index < b.index
  end)
  return res
end

function UILWDominatorMainTrainDetailComponent:OnTrainUpgrade()
  self:UpdateCost()
  self:UpdateEffect(false)
end

function UILWDominatorMainTrainDetailComponent:OnRefreshItems()
  self:UpdateCost()
end

function UILWDominatorMainTrainDetailComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorTrainUpgradeSuccess, self.OnTrainUpgrade)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

function UILWDominatorMainTrainDetailComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorTrainUpgradeSuccess, self.OnTrainUpgrade)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

function UILWDominatorMainTrainDetailComponent:OnBtnUpgradeClick()
  if not self.info then
    return
  end
  local curLevelTemplate = self.info:GetCurLevelTemplate()
  if not curLevelTemplate then
    return
  end
  if curLevelTemplate:IsMaxLevel() then
    return
  end
  if not curLevelTemplate:IsRequireOK() then
    return
  end
  local costInfo = curLevelTemplate:GetUpgradeCostInfo()
  for i, v in pairs(costInfo) do
    local haveCount = DataCenter.ItemData:GetItemCount(v.itemId)
    if haveCount < v.count then
      LWResourceLackUtil:GotoGoodsItemLack(v.itemId, v.count)
      return
    end
  end
  DataCenter.DominatorManager:SendTrainUpgradeMessage(self.info.groupId)
end

function UILWDominatorMainTrainDetailComponent:OnBtnCloseClick()
  if self.root then
    self.root:OnSelectTrainGroupDetail(nil)
  end
end

return UILWDominatorMainTrainDetailComponent
