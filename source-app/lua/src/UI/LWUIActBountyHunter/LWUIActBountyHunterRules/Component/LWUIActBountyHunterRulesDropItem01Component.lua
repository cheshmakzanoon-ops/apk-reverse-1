local base = UIBaseContainer
local LWUIActBountyHunterRulesDropItem01Component = BaseClass("LWUIActBountyHunterRulesDropItem01Component", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/LWUIActBountyHunterRulesConstant")
local LWUIActBountyHunterRulesDropDetailItemComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/Component/LWUIActBountyHunterRulesDropDetailItemComponent")

function LWUIActBountyHunterRulesDropItem01Component:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterRulesDropItem01Component:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterRulesDropItem01Component:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compDropContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

function LWUIActBountyHunterRulesDropItem01Component:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textSubTitle = nil
  self.textDes = nil
  self.compDropContent = nil
end

function LWUIActBountyHunterRulesDropItem01Component:DataDefine()
end

function LWUIActBountyHunterRulesDropItem01Component:DataDestroy()
end

function LWUIActBountyHunterRulesDropItem01Component:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActBountyHunterRulesDropItem01Component:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterRulesDropItem01Component:ReInit(templates, type)
  self.template = templates[1]
  self.type = type
  self.textTitle:SetText(self.template:GetTitleText())
  local subTitleText = self.template:GetSubTitleText()
  local isShowSubTitle = not string.IsNullOrEmpty(subTitleText)
  self.textSubTitle:SetActive(isShowSubTitle)
  if isShowSubTitle then
    self.textSubTitle:SetText(subTitleText)
  end
  local desText = self.template:GetDesText()
  local isShowDes = not string.IsNullOrEmpty(desText)
  self.textDes:SetActive(isShowDes)
  if isShowDes then
    self.textDes:SetText(desText)
  end
  self.itemReqs = {}
  local itemIdList = self.template:GetPara1Data()
  if not table.IsNullOrEmpty(itemIdList) then
    local probabilityData = self.template:GetPara3ProbabilityData()
    for i, v in ipairs(itemIdList) do
      self.itemReqs[i] = self:GameObjectInstantiateAsync(Const.DetailItemAssetPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.compDropContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(i)
        go.name = nameStr
        local item = self.compDropContent:AddComponent(LWUIActBountyHunterRulesDropDetailItemComponent, nameStr)
        local data = {
          id = v,
          probability = probabilityData[i]
        }
        item:ReInit(self.template, data, type)
      end)
    end
  end
end

return LWUIActBountyHunterRulesDropItem01Component
