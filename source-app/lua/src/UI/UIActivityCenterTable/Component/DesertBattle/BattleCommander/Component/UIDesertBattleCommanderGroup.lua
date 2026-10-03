local UIDesertBattleCommanderGroup = BaseClass("UIDesertBattleCommanderGroup", UIBaseContainer)
local base = UIBaseContainer
local UIDesertBattleCommanderItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleCommander.Component.UIDesertBattleCommanderItem")

function UIDesertBattleCommanderGroup:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "BtnEdit")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(393018)
      return
    end
    if BattleFieldUtil.isObserve then
      UIUtil.ShowTipsId("Desert_strom_commander_1035")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleCommanderSet)
  end)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "Content")
  self.theItem = self.transform:Find("Item").gameObject
  self.theItem:GameObjectCreatePool()
end

function UIDesertBattleCommanderGroup:OnDestroy()
  self.content:RemoveComponents(UIDesertBattleCommanderItem)
  if self.theItem ~= nil then
    self.theItem:GameObjectRecycleAll()
  end
  self.items = {}
  base.OnDestroy(self)
end

function UIDesertBattleCommanderGroup:UpdateData()
  local list = DataCenter.ActDragonManager:GetCommanderList()
  for i = 1, 3 do
    local item = self.items[i]
    if item == nil then
      local goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = "Item" .. i
      item = self.content:AddComponent(UIDesertBattleCommanderItem, goItem.name)
      item:SetActive(true)
      self.items[i] = item
    end
    item:ReInit(list[i])
  end
end

return UIDesertBattleCommanderGroup
