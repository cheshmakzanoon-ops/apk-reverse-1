local base = UIBaseContainer
local LWUIActBountyHunterRulesDropMonsterItemComponent = BaseClass("LWUIActBountyHunterRulesDropMonsterItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/LWUIActBountyHunterRulesConstant")
local LWUIActBountyHunterRulesDropDetailItemComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/Component/LWUIActBountyHunterRulesDropDetailItemComponent")

function LWUIActBountyHunterRulesDropMonsterItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgTitleBase = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgIconBase = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textMustDropTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compMustDropContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.textProbabilityDropTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compProbabilityDropContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compSeperateLine = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textAttackDropTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compAttackDropContent = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.textMustDropTitle:SetLocalText("activity_hunter_droptype1")
  self.textProbabilityDropTitle:SetLocalText("activity_hunter_droptype2")
  self.textAttackDropTitle:SetLocalText("activity_hunter_droptype3")
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgTitleBase = nil
  self.textTitle = nil
  self.imgIconBase = nil
  self.imgIcon = nil
  self.textMustDropTitle = nil
  self.compMustDropContent = nil
  self.textProbabilityDropTitle = nil
  self.compProbabilityDropContent = nil
  self.compSeperateLine = nil
  self.textDes = nil
  self.textAttackDropTitle = nil
  self.compAttackDropContent = nil
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:DataDefine()
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:DataDestroy()
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:ReInit(template, showLine)
  self.template = template
  self:RefreshTitle()
  local desText = self.template:GetDesText()
  local isShowDes = not string.IsNullOrEmpty(desText)
  self.textDes:SetActive(isShowDes)
  if isShowDes then
    self.textDes:SetText(desText)
  end
  local para2Data = self.template:GetPara2Data()
  local isShowPara2 = not table.IsNullOrEmpty(para2Data)
  self.textMustDropTitle:SetActive(isShowPara2)
  self.compMustDropContent:SetActive(isShowPara2)
  if isShowPara2 then
    self.mustDropItems = {}
    for i, v in ipairs(para2Data) do
      local request = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if not IsNull(request.gameObject) then
          local go = request.gameObject
          go.transform:SetParent(self.compMustDropContent.transform)
          go.transform:Set_localScale(0.8, 0.8, ResetScale.z)
          local name = "item" .. i
          go.name = name
          local resItem = self.compMustDropContent:AddComponent(UICommonResItem, name)
          resItem:ReInit(v)
        end
      end)
      self.mustDropItems[i] = request
    end
  end
  local para3Data = self.template:GetPara3Data()
  local isShowPara3 = not table.IsNullOrEmpty(para3Data)
  local isShowProTitle = isShowPara3
  if isShowProTitle and not self.template:IsShowProbabilityTitle() then
    isShowProTitle = false
  end
  self.textProbabilityDropTitle:SetActive(isShowProTitle)
  self.compProbabilityDropContent:SetActive(isShowPara3)
  if isShowPara3 then
    self.probabilityDropItems = {}
    local para3ProbabilityDropData = self.template:GetPara3ProbabilityData()
    for i, v in ipairs(para3Data) do
      local request = self:GameObjectInstantiateAsync(Const.DetailItemAssetPath, function(request)
        if not IsNull(request.gameObject) then
          local go = request.gameObject
          go.transform:SetParent(self.compProbabilityDropContent.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local name = "item" .. i
          go.name = name
          local resItem = self.compProbabilityDropContent:AddComponent(LWUIActBountyHunterRulesDropDetailItemComponent, name)
          local data = {
            reward = v,
            probability = para3ProbabilityDropData[i]
          }
          resItem:ReInit(self.template, data, self.template.type)
        end
      end)
      self.probabilityDropItems[i] = request
    end
  end
  local para4Data = self.template:GetPara4Data()
  local isShowPara4 = not table.IsNullOrEmpty(para4Data)
  self.textAttackDropTitle:SetActive(isShowPara4)
  self.compAttackDropContent:SetActive(isShowPara4)
  if isShowPara4 then
    self.attackDropItems = {}
    local para4ProbabilityDropData = self.template:GetPara4ProbabilityData()
    for i, v in ipairs(para4Data) do
      local request = self:GameObjectInstantiateAsync(Const.DetailItemAssetPath, function(request)
        if not IsNull(request.gameObject) then
          local go = request.gameObject
          go.transform:SetParent(self.compAttackDropContent.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local name = "item" .. i
          go.name = name
          local resItem = self.compAttackDropContent:AddComponent(LWUIActBountyHunterRulesDropDetailItemComponent, name)
          local data = {
            reward = v,
            probability = para4ProbabilityDropData[i]
          }
          resItem:ReInit(self.template, data, self.template.type)
        end
      end)
      self.attackDropItems[i] = request
    end
  end
  self.compSeperateLine:SetActive(showLine)
end

function LWUIActBountyHunterRulesDropMonsterItemComponent:RefreshTitle()
  if self.template == nil then
    return
  end
  local idList = self.template:GetPara1Data()
  local id = idList[1]
  if id == nil then
    return
  end
  local bg = self.template:GetIconBgPath(id)
  if not string.IsNullOrEmpty(bg) then
    self.imgIconBase:LoadSprite(bg)
  end
  local banner = self.template:GetBannerPath(id)
  if not string.IsNullOrEmpty(banner) then
    self.imgTitleBase:LoadSprite(banner)
  end
  local icon = self.template:GetIconPath(id)
  if not string.IsNullOrEmpty(icon) then
    self.imgIcon:LoadSprite(icon)
  end
  self.textTitle:SetText(self.template:GetMonsterNameText())
end

return LWUIActBountyHunterRulesDropMonsterItemComponent
