local MailPropertyPage = BaseClass("MailPropertyPage", UIBaseContainer)
local base = UIBaseContainer
local MailPropertyCell = require("UI.UILWMail.UILWMailMain.Component.MailPropertyCell")
local Localization = CS.GameEntry.Localization

function MailPropertyPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailPropertyPage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailPropertyPage:DataDefine()
end

function MailPropertyPage:DataDestroy()
end

function MailPropertyPage:OnEnable()
  base.OnEnable(self)
end

function MailPropertyPage:OnDisable()
  base.OnDisable(self)
end

function MailPropertyPage:OnAddListener()
  base.OnAddListener(self)
end

function MailPropertyPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailPropertyPage:ComponentDefine()
  self.propertyCell = self.transform:Find("ScrollView/Viewport/PropertyContent/PropertyCell").gameObject
  self.propertyCell:GameObjectCreatePool()
  self.propertyCell:SetActive(false)
  self.propertyContent = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/PropertyContent")
end

function MailPropertyPage:ComponentDestroy()
  self.propertyContent:RemoveComponents(MailPropertyCell)
  self.propertyCell.gameObject:GameObjectRecycleAll()
end

function MailPropertyPage:Refresh(extData)
  self.extData = extData
  self:RefreshView()
end

function MailPropertyPage:RefreshView()
  self.propertyContent:RemoveComponents(MailPropertyCell)
  self.propertyCell.gameObject:GameObjectRecycleAll()
  local properties = {}
  for i = 1, 2 do
    for k, v in pairs(self.extData.player[i].effects) do
      if not properties[v.id] then
        properties[v.id] = {}
      end
      properties[v.id][i] = v.value
    end
  end
  local propertyCount = 0
  for k, v in pairs(properties) do
    propertyCount = propertyCount + 1
    local item = self.propertyCell:GameObjectSpawn(self.propertyContent.transform)
    item.name = "PropertyCell" .. propertyCount
    local obj = self.propertyContent:AddComponent(MailPropertyCell, item.name)
    obj:SetData(v)
  end
end

return MailPropertyPage
