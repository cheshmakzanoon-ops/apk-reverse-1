local UIFireworkGoodsLackView = BaseClass("UIFireworkGoodsLackView", UIBaseView)
local UIFireworkGoodsLackItem = require("UI.Firework.UIFireworkGoodsLack.Component.UIFireworkGoodsLackItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIFireworkGoodsLackView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIFireworkGoodsLackView:OnDestroy()
  self:DataDestroy()
  self:ClearList()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFireworkGoodsLackView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textResourceTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textResourceCurNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textGotoTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.compItem = self.viewSkin:AddComponent(self, UICommonResItem, 10)
  self.textGotoBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textTitle:SetText(Localization:GetString("450012"))
  self.textTips:SetText(Localization:GetString("firework_desc_1001"))
  self.textGotoTips:SetText(Localization:GetString("firework_limit_1001"))
  self.textGotoBtnTxt:SetText(Localization:GetString("110003"))
end

function UIFireworkGoodsLackView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textResourceTitle = nil
  self.compContent = nil
  self.textResourceCurNum = nil
  self.textTips = nil
  self.textGotoTips = nil
  self.btnPanel = nil
  self.btnGoto = nil
  self.compItem = nil
  self.textGotoBtnTxt = nil
end

function UIFireworkGoodsLackView:DataDefine()
end

function UIFireworkGoodsLackView:DataDestroy()
end

function UIFireworkGoodsLackView:OnAddListener()
  base.OnAddListener(self)
end

function UIFireworkGoodsLackView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFireworkGoodsLackView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIFireworkGoodsLackView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIFireworkGoodsLackView:OnBtnGotoClick()
  LWResourceLackUtil:GotoGoodsItemLack(self.fireworkId, 1)
  self.ctrl:CloseSelf()
end

function UIFireworkGoodsLackView:ReInit()
  self.fireworkId = DataCenter.LWFireworkManager:GetDefaultFireworkItemId()
  local iconData = {}
  iconData.rewardType = RewardType.GOODS
  iconData.itemId = self.fireworkId
  local name = DataCenter.RewardManager:GetNameByType(tonumber(iconData.rewardType), tonumber(iconData.itemId))
  self.compItem:ReInit(iconData)
  self.textResourceTitle:SetText(name)
  local have = DataCenter.ItemData:GetItemCount(self.fireworkId)
  if 0 < have then
    self.textResourceCurNum:SetText(Localization:GetString("450019", have))
  else
    self.textResourceCurNum:SetText(string.format("<color=#F53C3D>%s</color>", Localization:GetString("450019", have)))
  end
  self:RefreshList()
end

function UIFireworkGoodsLackView:RefreshList()
  self:ClearList()
  self.dataList = {}
  LocalController:instance():visitTable(TableName.Firework, function(id, lineData)
    local itemId = tostring(id)
    local itemCount = DataCenter.ItemData:GetItemCount(itemId)
    if itemId ~= self.fireworkId and itemCount and 0 < itemCount then
      table.insert(self.dataList, itemId)
    end
  end)
  table.sort(self.dataList, function(a, b)
    local itemTemplate1 = DataCenter.ItemTemplateManager:GetItemTemplate(a)
    local itemTemplate2 = DataCenter.ItemTemplateManager:GetItemTemplate(b)
    return itemTemplate1.color > itemTemplate2.color
  end)
  for k, v in ipairs(self.dataList) do
    self.cellReqs[k] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIFirework/UIFireworkGoodLackItem.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.compContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(k)
      go.name = nameStr
      self.cells[k] = self.compContent:AddComponent(UIFireworkGoodsLackItem, nameStr)
      self.cells[k]:Refresh(v)
    end)
  end
end

function UIFireworkGoodsLackView:ClearList()
  if self.cellReqs then
    self.compContent:RemoveComponents(UIFireworkGoodsLackItem)
    for k, v in pairs(self.cellReqs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellReqs = {}
  self.cells = {}
end

return UIFireworkGoodsLackView
