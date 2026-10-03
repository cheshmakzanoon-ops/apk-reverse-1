local base = UIBaseContainer
local LWUIActBountyHunterRulesDropItem02Component = BaseClass("LWUIActBountyHunterRulesDropItem02Component", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/LWUIActBountyHunterRulesConstant")
local LWUIActBountyHunterRulesDropMonsterItemComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/Component/LWUIActBountyHunterRulesDropMonsterItemComponent")

function LWUIActBountyHunterRulesDropItem02Component:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterRulesDropItem02Component:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterRulesDropItem02Component:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compDropContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
end

function LWUIActBountyHunterRulesDropItem02Component:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textDes = nil
  self.compDropContent = nil
end

function LWUIActBountyHunterRulesDropItem02Component:DataDefine()
end

function LWUIActBountyHunterRulesDropItem02Component:DataDestroy()
end

function LWUIActBountyHunterRulesDropItem02Component:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActBountyHunterRulesDropItem02Component:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterRulesDropItem02Component:ReInit(templates)
  self.templates = templates
  if table.IsNullOrEmpty(self.templates) then
    return
  end
  local showDefaultTemplate = self.templates[1]
  self.textTitle:SetText(showDefaultTemplate:GetTitleText())
  self.textDes:SetActive(false)
  self.itemReqs = {}
  local totalCount = #self.templates
  for i, v in ipairs(self.templates) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(Const.MonsterItemAssetPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compDropContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local item = self.compDropContent:AddComponent(LWUIActBountyHunterRulesDropMonsterItemComponent, nameStr)
      item:ReInit(v, i ~= totalCount)
    end)
  end
end

return LWUIActBountyHunterRulesDropItem02Component
