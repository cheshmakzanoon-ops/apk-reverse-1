local base = require("UI/UILWDominator/Main/Component/UILWDominatorMainPageBaseComponent")
local UILWDominatorMainAdvancePageComponent = BaseClass("UILWDominatorMainAdvancePageComponent", base)
local Localization = CS.GameEntry.Localization
local UILWDominatorMainAttributeItemComponent = require("UI/UILWDominator/Main/Component/AdvancePage/UILWDominatorMainAttributeItemComponent")
local UILWDominatorMainSkillItemComponent = require("UI/UILWDominator/Main/Component/AdvancePage/UILWDominatorMainSkillItemComponent")
local UILWDominatorMainRankItemComponent = require("UI/UILWDominator/Main/Component/BasicPage/UILWDominatorMainRankItemComponent")
local SkillItemPosXDelta = 55.5
local SkillItemPosXOffset = 2
local SkillItemAnchoredPosY = 7.2

function UILWDominatorMainAdvancePageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainAdvancePageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainAdvancePageComponent:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.textUserName = self:AddComponent(UIText, "NameContent/UserNameText")
  self.btnInfo = self:AddComponent(UIButton, "Top/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compBottomContent = self:AddComponent(UIBaseContainer, "BottomContent")
  self.compNotMaxContent = self:AddComponent(UIBaseContainer, "BottomContent/BasicInfoContent/NotMaxContent")
  self.compMaxContent = self:AddComponent(UIBaseContainer, "BottomContent/BasicInfoContent/MaxContent")
  self.textMaxName = self:AddComponent(UIText, "BottomContent/BasicInfoContent/MaxContent/MaxNameText")
  self.imgRankIcon = self:AddComponent(UIImage, "BottomContent/BasicInfoContent/RankIcon")
  self.textRankProgressValue = self:AddComponent(UIText, "BottomContent/BasicInfoContent/NotMaxContent/RankProgressValueText")
  self.textName = self:AddComponent(UIText, "BottomContent/BasicInfoContent/NotMaxContent/NameText")
  self.compRankLayout = self:AddComponent(UIBaseContainer, "BottomContent/BasicInfoContent/NotMaxContent/RankLayout")
  self.compSkillContent = self:AddComponent(UIBaseContainer, "BottomContent/SkillContent")
  self.compSkillRoot = self:AddComponent(UIBaseContainer, "BottomContent/SkillContent/SkillRoot")
  self.compAttributesContent = self:AddComponent(UIBaseContainer, "BottomContent/AttributesContent")
  self.textMaxLevel = self:AddComponent(UIText, "BottomContent/UpgradeContent/MaxLevelTipsText")
  self.textMaxLevel:SetText(Localization:GetString("dominator_star_desc_1"))
  self.textPower = self:AddComponent(UIText, "BottomContent/PowerContent/PowerText")
  self.compPowerEffect = self:AddComponent(UIBaseContainer, "BottomContent/PowerContent/PowerText/PowerEffect")
  self.compPowerEffect:SetActive(false)
  self.compUpgradeBtnLayout = self:AddComponent(UIBaseContainer, "BottomContent/UpgradeContent/UpgradeBtnLayout")
  self.compUseCommon = self:AddComponent(UIBaseContainer, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon")
  self.compNotUseCommon = self:AddComponent(UIBaseContainer, "BottomContent/UpgradeContent/UpgradeBtnLayout/NotUseCommon")
  self.btnUseCommonUpgrade = self:AddComponent(UIButton, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonUpgradeBtn")
  self.btnUseCommonUpgrade:SetOnClick(function()
    self:OnBtnUseCommonUpgradeClick()
  end)
  self.textExchangeBtn = self:AddComponent(UIText, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonUpgradeBtn/UseCommonUpgradeBtnText")
  self.textExchangeBtn:SetText(Localization:GetString("dominator_star_button_2"))
  self.compUseCommonCostLayout = self:AddComponent(UIBaseContainer, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonCostLayout")
  self.compUseCommonCostGroup2 = self:AddComponent(UIBaseContainer, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonCostLayout/UseCommonCostGroup2")
  self.compUseCommonCostGroup1 = self:AddComponent(UIBaseContainer, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonCostLayout/UseCommonCostGroup1")
  self.imgCostIcon2 = self:AddComponent(UIImage, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonCostLayout/UseCommonCostGroup2/CostIcon2")
  self.textCostText2 = self:AddComponent(UIText, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonCostLayout/UseCommonCostGroup2/CostText2")
  self.imgCostIcon1 = self:AddComponent(UIImage, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonCostLayout/UseCommonCostGroup1/CostIcon1")
  self.textCostText1 = self:AddComponent(UIText, "BottomContent/UpgradeContent/UpgradeBtnLayout/UseCommon/UseCommonCostLayout/UseCommonCostGroup1/CostText1")
  self.btnUpgrade = self:AddComponent(UIButton, "BottomContent/UpgradeContent/UpgradeBtnLayout/NotUseCommon/UpgradeBtn")
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.textUpgrade = self:AddComponent(UIText, "BottomContent/UpgradeContent/UpgradeBtnLayout/NotUseCommon/UpgradeBtn/UpgradeText")
  self.textUpgrade:SetText(Localization:GetString("dominator_star_button_2"))
  self.imgNotUseCommonCostIcon = self:AddComponent(UIImage, "BottomContent/UpgradeContent/UpgradeBtnLayout/NotUseCommon/NotUseCommonCostGroup/NotUseCommonCostIcon")
  self.textNotUseCommonCost = self:AddComponent(UIText, "BottomContent/UpgradeContent/UpgradeBtnLayout/NotUseCommon/NotUseCommonCostGroup/NotUseCommonCostText")
  self.btnRankPreview = self:AddComponent(UIButton, "Top/RankPreviewBtn")
  self.btnRankPreview:SetOnClick(function()
    self:OnBtnRankPreviewClick()
  end)
  self.textRankPreviewBtn = self:AddComponent(UIText, "Top/RankPreviewBtn/RankPreviewBtnText")
  self.textRankPreviewBtn:SetLocalText("dominator_star_button_1")
  self.btnLeftSwitch = self:AddComponent(UIButton, "BottomContent/PowerContent/LeftSwitchBtn")
  self.btnLeftSwitch:SetOnClick(function()
    self:OnBtnLeftSwitchClick()
  end)
  self.btnRightSwitch = self:AddComponent(UIButton, "BottomContent/PowerContent/RightSwitchBtn")
  self.btnRightSwitch:SetOnClick(function()
    self:OnBtnRightSwitchClick()
  end)
end

function UILWDominatorMainAdvancePageComponent:ComponentDestroy()
  self.animator = nil
  self.compBottomContent = nil
  self.textUserName = nil
  self.btnInfo = nil
  self.compBottomContent = nil
  self.compNotMaxContent = nil
  self.compMaxContent = nil
  self.textMaxName = nil
  self.imgRankIcon = nil
  self.textRankProgressValue = nil
  self.textName = nil
  self.compRankLayout = nil
  self.compSkillContent = nil
  self.compSkillRoot = nil
  self.compAttributesContent = nil
  self.textPower = nil
  self.compPowerEffect = nil
  self.compUpgradeBtnLayout = nil
  self.compUseCommon = nil
  self.compNotUseCommon = nil
  self.btnUseCommonUpgrade = nil
  self.textExchangeBtn = nil
  self.compUseCommonCostLayout = nil
  self.compUseCommonCostGroup2 = nil
  self.compUseCommonCostGroup1 = nil
  self.imgCostIcon2 = nil
  self.textCostText2 = nil
  self.imgCostIcon1 = nil
  self.textCostText1 = nil
  self.btnUpgrade = nil
  self.textUpgrade = nil
  self.imgNotUseCommonCostIcon = nil
  self.textNotUseCommonCost = nil
  self.btnRankPreview = nil
  self.textRankPreviewBtn = nil
  self.btnLeftSwitch = nil
  self.btnRightSwitch = nil
end

function UILWDominatorMainAdvancePageComponent:DataDefine()
  self.rankItems = {}
  self.rankItemReqs = {}
  self.skillItems = {}
  self.skillItemReqs = {}
  self.effectItems = {}
  self.effectItemsReqs = {}
  self.clickSkillCallBack = BindCallback(self, self.OnClickSkillItem)
end

function UILWDominatorMainAdvancePageComponent:DataDestroy()
  self.rankItems = nil
  self.rankItemReqs = nil
  self.skillItems = nil
  self.skillItemReqs = nil
  self.effectItems = nil
  self.effectItemsReqs = nil
  self.clickSkillCallBack = nil
end

function UILWDominatorMainAdvancePageComponent:ReInit()
  self.info = self.view:GetCurShowInfo()
  if self.info == nil then
    return
  end
  self.mainTemplate = self.info:GetMainTemplate()
  if self.mainTemplate == nil then
    return
  end
  self.compPowerEffect:SetActive(false)
  self.btnRankPreview:SetActive(self.mainTemplate:IsShowRankPreview())
  self:UpdateUserName()
  self:UpdateInfo()
  self:UpdateCost()
  self:UpdateEffect(true)
  self:UpdateSkill()
  self:UpdatePower()
end

function UILWDominatorMainAdvancePageComponent:UpdateUserName()
  if not self.info then
    return
  end
  self.textUserName:SetText(self.info:GetUserName())
end

function UILWDominatorMainAdvancePageComponent:UpdateInfo()
  local function UpdateRankItem(onCount)
    if self.rankItems then
      for i, v in pairs(self.rankItems) do
        if i <= onCount then
          v:SetOn()
        else
          v:SetOff()
        end
      end
    end
  end
  
  if not self.info or not self.mainTemplate then
    return
  end
  local rankTemplate = self.info:GetCurRankTemplate()
  if rankTemplate then
    local rankShowTemplate = rankTemplate:GetRankShowTemplate()
    if rankShowTemplate then
      local name = rankShowTemplate:GetName()
      self.textName:SetText(name)
      self.textMaxName:SetText(name)
      self.imgRankIcon:LoadSprite(rankShowTemplate:GetRankIconPathBig())
    end
    local isMax = rankTemplate:IsMaxRank()
    self.compMaxContent:SetActive(isMax)
    self.compNotMaxContent:SetActive(not isMax)
    if not isMax then
      local rankInBigRank = rankTemplate:GetLevelOrderInBigRank()
      local totalRankInBigRank = rankTemplate:GetLevelCountInBigRank()
      self:ReloadRankItem(totalRankInBigRank, function()
        UpdateRankItem(rankInBigRank)
      end)
      self.textRankProgressValue:SetText(rankTemplate:GetShowLevelText())
    end
  end
end

function UILWDominatorMainAdvancePageComponent:UpdateSkill()
  local function UpdateSkillItems(showData)
    local index = 1
    
    if showData and self.mainTemplate then
      for i, v in pairs(showData) do
        if self.skillItems and self.skillItems[index] then
          local skillRealIndex = i
          local param = {
            skillId = v.skillId,
            isCenter = v.isCenter,
            clickCallback = self.clickSkillCallBack,
            skillGroupId = v.skillGroupId
          }
          self.skillItems[index]:ReInit(param)
          self.skillItems[index]:SetAnchoredPositionXY(SkillItemPosXDelta * skillRealIndex + SkillItemPosXOffset * (skillRealIndex - 1), SkillItemAnchoredPosY)
        end
        index = index + 1
      end
    end
  end
  
  if not self.info or not self.mainTemplate then
    return
  end
  local rankTemplate = self.info:GetCurRankTemplate()
  if not rankTemplate then
    return
  end
  local rankShowTemplate = rankTemplate:GetRankShowTemplate()
  if not rankShowTemplate then
    return
  end
  local skillItemsShowData = {}
  local skillCount = 0
  local firstRankIdInBigRank = rankTemplate.id - rankTemplate.level_order + 1
  local totalRankInBigRank = rankTemplate:GetLevelCountInBigRank()
  if 0 < totalRankInBigRank then
    local rankIdTemp = firstRankIdInBigRank
    for i = 1, totalRankInBigRank do
      local skillUnlockInfo = self.mainTemplate:GetSkillUnlockInfoByRankId(rankIdTemp)
      if skillUnlockInfo ~= nil and skillUnlockInfo[1] ~= nil then
        skillItemsShowData[i] = skillUnlockInfo[1]
        skillCount = skillCount + 1
      end
      rankIdTemp = rankIdTemp + 1
    end
  end
  local showSkill = not rankTemplate:IsMaxRank() and not table.IsNullOrEmpty(skillItemsShowData)
  self.compSkillContent:SetActive(showSkill)
  if showSkill then
    self:ReloadSkillItem(skillCount, function()
      UpdateSkillItems(skillItemsShowData)
    end)
  end
end

function UILWDominatorMainAdvancePageComponent:ReloadSkillItem(totalCount, finishCallback)
  local curCount = 0
  if self.skillItems then
    curCount = table.count(self.skillItems)
  end
  if totalCount > curCount then
    if self.skillItems then
      for _, v in pairs(self.skillItems) do
        v:SetActive(true)
      end
    end
    for i = curCount + 1, totalCount do
      local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainUnlockSkillItem.prefab")
      loadRequest:completed("+", function()
        if not IsNull(loadRequest.gameObject) and not IsNull(self.compSkillRoot) and self.skillItems then
          local pageObj = loadRequest.gameObject
          local transform = pageObj.transform
          transform:SetParent(self.compSkillRoot.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          pageObj.name = "skillItem" .. i
          local item = self:AddComponent(UILWDominatorMainSkillItemComponent, pageObj)
          item:SetActive(true)
          self.skillItems[i] = item
          if i == totalCount and finishCallback then
            finishCallback()
          end
        end
      end)
      self.skillItemReqs[i] = loadRequest
    end
  else
    if self.skillItems then
      for i = 1, curCount do
        local item = self.skillItems[i]
        if item then
          item:SetActive(i <= totalCount)
        end
      end
    end
    if finishCallback then
      finishCallback()
    end
  end
end

function UILWDominatorMainAdvancePageComponent:ReloadRankItem(totalCount, finishCallback)
  local curCount = 0
  if self.rankItems then
    curCount = table.count(self.rankItems)
  end
  if totalCount > curCount then
    if self.rankItems then
      for _, v in pairs(self.rankItems) do
        v:SetActive(true)
      end
    end
    for i = curCount + 1, totalCount do
      local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWDominator/Main/UILWDominatorMainRankItem.prefab")
      loadRequest:completed("+", function()
        if not IsNull(loadRequest.gameObject) and not IsNull(self.compRankLayout) then
          local pageObj = loadRequest.gameObject
          local transform = pageObj.transform
          transform:SetParent(self.compRankLayout.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          pageObj.name = "rankItem" .. i
          local item = self:AddComponent(UILWDominatorMainRankItemComponent, pageObj)
          item:SetActive(true)
          self.rankItems[i] = item
          if i == totalCount and finishCallback then
            finishCallback()
          end
        end
      end)
      self.rankItemReqs[i] = loadRequest
    end
  else
    if self.rankItems then
      for i = 1, curCount do
        local item = self.rankItems[i]
        if item then
          item:SetActive(i <= totalCount)
        end
      end
    end
    if finishCallback then
      finishCallback()
    end
  end
end

function UILWDominatorMainAdvancePageComponent:UpdateCost()
  if not self.info or not self.mainTemplate then
    return
  end
  local isMaxed = self.info:IsMaxRank()
  self.textMaxLevel:SetActive(isMaxed)
  self.compUpgradeBtnLayout:SetActive(not isMaxed)
  if not isMaxed then
    local itemId = self.mainTemplate:GetUpgradeRankCostItemId()
    if itemId then
      local haveCount = DataCenter.ItemData:GetItemCount(itemId)
      local costCount = self.info:GetUpgradeRankCostItemNum()
      local isItemEnough = haveCount >= costCount
      local commonItemId = DataCenter.DominatorManager:GetCommonRankUpgradeItemId()
      local icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
      local commonHaveCount = 0
      if commonItemId and 0 < commonItemId then
        commonHaveCount = DataCenter.ItemData:GetItemCount(commonItemId)
      end
      local showCommon = not isItemEnough and commonItemId and 0 < commonItemId and 0 < commonHaveCount
      self.compUseCommon:SetActive(showCommon)
      if showCommon then
        local commonIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, commonItemId)
        self.imgCostIcon2:LoadSprite(commonIcon)
        local commonCostCount = costCount - haveCount
        if commonHaveCount >= commonCostCount then
          self.textCostText2:SetText(string.format("<color=#5FEF87>%d</color>/%d", commonHaveCount, commonCostCount))
        else
          self.textCostText2:SetText(string.format("<color=#F97077>%d</color>/%d", commonHaveCount, commonCostCount))
        end
        self.textCostText1:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, haveCount))
        self.imgCostIcon1:LoadSprite(icon)
      end
      self.imgNotUseCommonCostIcon:LoadSprite(icon)
      if haveCount >= costCount then
        self.textNotUseCommonCost:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, costCount))
      else
        self.textNotUseCommonCost:SetText(string.format("<color=#F97077>%d</color>/%d", haveCount, costCount))
      end
    end
  end
end

function UILWDominatorMainAdvancePageComponent:UpdateEffect(isFromInit)
  local showEffects = self.view.ctrl:GetAdvancePageShowEffects(self.info)
  if table.IsNullOrEmpty(showEffects) then
    self.compAttributesContent:SetActive(false)
  else
    self.compAttributesContent:SetActive(true)
    local num = 1
    local totalNum = table.count(showEffects)
    local needLoadGameObject = false
    for _, v in ipairs(showEffects) do
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
            item:ReInit(v, isFromInit)
            item:SetBgActive(index % 2 == 0)
            item:SetColorRGBA255(112, 138, 176, 22)
            item:SetSizeDeltaXY(700, 60)
            if not isFromInit then
              item:PlayEffect(nil)
            end
            self.effectItems[index] = item
            if totalNum == index and self.compBottomContent then
              CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBottomContent.transform)
            end
          end
        end)
        self.effectItemsReqs[index] = loadRequest
      elseif self.effectItems[index] ~= nil then
        self.effectItems[index]:SetActive(true)
        self.effectItems[index]:ReInit(v, isFromInit)
        self.effectItems[index]:SetBgActive(index % 2 == 0)
        self.effectItems[index]:SetColorRGBA255(112, 138, 176, 22)
        self.effectItems[index]:SetSizeDeltaXY(700, 60)
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
    if not needLoadGameObject then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compBottomContent.transform)
    end
  end
end

function UILWDominatorMainAdvancePageComponent:OnRankUpgrade(evt)
  self:UpdateInfo()
  self:UpdateEffect(false)
  self:UpdateCost()
  self:UpdateSkill()
  self:UpdatePower()
  self.animator:Play("V_ui_UILWDominatorMainAdvancePage_upgrade")
  self:PlayPowerEffect()
end

function UILWDominatorMainAdvancePageComponent:UpdatePower()
  if self.view and self.textPower then
    local info = self.view:GetCurShowInfo()
    if info then
      self.textPower:SetText(tostring(info:GetPower()))
    end
  end
  if self.view then
    local allMainIdList = self.view:GetAllMainIdList()
    if allMainIdList then
      local allCount = table.count(allMainIdList)
      local curIndex = self.view:GetCurShowMainIdIndex()
      self.btnLeftSwitch:SetActive(1 < curIndex)
      self.btnRightSwitch:SetActive(allCount > curIndex)
    end
  end
end

function UILWDominatorMainAdvancePageComponent:PlayPowerEffect()
  if self.compPowerEffect then
    self.compPowerEffect:SetActive(false)
    self.compPowerEffect:SetActive(true)
  end
end

function UILWDominatorMainAdvancePageComponent:OnRefreshItems()
  self:UpdateCost()
end

function UILWDominatorMainAdvancePageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorRankUpgradeSuccess, self.OnRankUpgrade)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

function UILWDominatorMainAdvancePageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorRankUpgradeSuccess, self.OnRankUpgrade)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

function UILWDominatorMainAdvancePageComponent:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("dominator_star_desc_2")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWDominatorMainAdvancePageComponent:OnBtnRuleClick()
end

function UILWDominatorMainAdvancePageComponent:OnBtnUseCommonUpgradeClick()
  if not self.info or not self.mainTemplate then
    return
  end
  if self.info:IsMaxRank() then
    return
  end
  local commonItemId = DataCenter.DominatorManager:GetCommonRankUpgradeItemId()
  if commonItemId then
    local itemId = self.mainTemplate:GetUpgradeRankCostItemId()
    if itemId then
      local commonHaveCount = DataCenter.ItemData:GetItemCount(commonItemId)
      local haveCount = DataCenter.ItemData:GetItemCount(itemId)
      local costCount = self.info:GetUpgradeRankCostItemNum()
      local commonCostCount = costCount - haveCount
      if commonHaveCount >= commonCostCount then
        DataCenter.DominatorManager:SendRankUpgradeMessage(self.info.uuid, true)
      else
        LWResourceLackUtil:GotoGoodsItemLack(commonItemId, commonCostCount)
      end
    end
  end
end

function UILWDominatorMainAdvancePageComponent:OnBtnUpgradeClick()
  if not self.info or not self.mainTemplate then
    return
  end
  if self.info:IsMaxRank() then
    return
  end
  local itemId = self.mainTemplate:GetUpgradeRankCostItemId()
  if itemId then
    local haveCount = DataCenter.ItemData:GetItemCount(itemId)
    local costCount = self.info:GetUpgradeRankCostItemNum()
    if haveCount >= costCount then
      DataCenter.DominatorManager:SendRankUpgradeMessage(self.info.uuid, false)
    else
      LWResourceLackUtil:GotoGoodsItemLack(itemId, costCount)
    end
  end
end

function UILWDominatorMainAdvancePageComponent:OnClickSkillItem(param, skillItem)
  if not self.info or not self.mainTemplate then
    return
  end
  local skillData = self.info:GetSkillInfoBySkillGroupId(param.skillGroupId)
  if not skillData then
    return
  end
  local userData = {
    skillData = skillData,
    skillItem = skillItem,
    skillId = param.skillId
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorUnlockSkillPreview, {anim = true}, userData)
end

function UILWDominatorMainAdvancePageComponent:OnBtnRankPreviewClick()
  self.view:SetCurShowPageTag(UILWDominatorMainPageTag.RankPreview, {
    source = UILWDominatorMainPageTag.Rank
  })
end

function UILWDominatorMainAdvancePageComponent:OnBtnLeftSwitchClick()
  local curIndex = self.view:GetCurShowMainIdIndex()
  if 1 < curIndex then
    local newIndex = curIndex - 1
    local allMainIdList = self.view:GetAllMainIdList()
    self.view:SetCurShowMainId(allMainIdList[newIndex])
  end
end

function UILWDominatorMainAdvancePageComponent:OnBtnRightSwitchClick()
  local curIndex = self.view:GetCurShowMainIdIndex()
  local allMainIdList = self.view:GetAllMainIdList()
  local allCount = 0
  if allMainIdList then
    allCount = table.count(allMainIdList)
  end
  if curIndex < allCount then
    local newIndex = curIndex + 1
    self.view:SetCurShowMainId(allMainIdList[newIndex])
  end
end

return UILWDominatorMainAdvancePageComponent
