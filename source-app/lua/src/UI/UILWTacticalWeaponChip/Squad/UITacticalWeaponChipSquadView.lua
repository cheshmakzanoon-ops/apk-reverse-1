local UITacticalWeaponChipSquadView = BaseClass("UITacticalWeaponChipSquadView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TacticalChipSquadItem = require("UI.UILWTacticalWeaponChip.Squad.TacticalChipSquadItem")
local title_path = "Root/title"
local SQUAD_NUM = 4

function UITacticalWeaponChipSquadView:OnCreate()
  base.OnCreate(self)
  self.chipPlanId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UITacticalWeaponChipSquadView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalWeaponChipSquadView:ComponentDefine()
  self.btnBg = self:AddComponent(UIButton, "BgBtn")
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compLayout = self:AddComponent(UIBaseContainer, "Root/layout")
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("battlesystem_chip_squad_desc2")
end

function UITacticalWeaponChipSquadView:ComponentDestroy()
  self.btnBg = nil
  self.btnClose = nil
  self.compLayout = nil
end

function UITacticalWeaponChipSquadView:DataDefine()
  self.reqList = {}
  self.cellMap = {}
  self.squadDataDic = {}
end

function UITacticalWeaponChipSquadView:DataDestroy()
  self.compLayout:RemoveComponents(TacticalChipSquadItem)
  self.reqList = nil
  self.cellMap = nil
  self.squadDataDic = nil
end

function UITacticalWeaponChipSquadView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArmyFormatUpdate, self.OnSquadChange)
end

function UITacticalWeaponChipSquadView:OnRemoveListener()
  self:RemoveUIListener(EventId.ArmyFormatUpdate, self.OnSquadChange)
  base.OnRemoveListener(self)
end

function UITacticalWeaponChipSquadView:OnReInit()
  self:RefreshData()
  for index, data in pairs(self.squadDataDic) do
    self.reqList[index] = self:CreateItem(index, data)
  end
end

function UITacticalWeaponChipSquadView:OnSquadChange()
  self:RefreshData()
  self:RefreshList()
end

function UITacticalWeaponChipSquadView:RefreshData()
  local dataDic = DataCenter.ArmyFormationDataManager:GetCurFormationList()
  for _, v in pairs(dataDic) do
    if v then
      self.squadDataDic[v.index] = v
    end
  end
end

function UITacticalWeaponChipSquadView:RefreshList()
  for i, v in pairs(self.cellMap) do
    if v then
      v:ReInit(self.squadDataDic[i], self.chipPlanId)
    end
  end
end

function UITacticalWeaponChipSquadView:CreateItem(index, data)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipSquadItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.compLayout.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "squad" .. index
    local cell = self.compLayout:AddComponent(TacticalChipSquadItem, go.name)
    cell:ReInit(data, self.chipPlanId)
    cell:SetActive(true)
    cell:SetOnSquadUseClickHandler(function()
      self:OnSquadChange()
    end)
    self.cellMap[index] = cell
  end)
end

function UITacticalWeaponChipSquadView:OnBtnBgClick()
  self.ctrl:CloseSelf()
end

function UITacticalWeaponChipSquadView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UITacticalWeaponChipSquadView
