local UITacticalChipManageView = BaseClass("UITacticalChipManageView", UIBaseView)
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SKILLCHIP_TYPE_TITLE = {
  [1] = "uav_chips_title6",
  [2] = "uav_chips_title7",
  [3] = "uav_chips_title8",
  [4] = "uav_chips_title9"
}

function UITacticalChipManageView:OnCreate()
  base.OnCreate(self)
  self.type, self.planId, self.targetIndexInit = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UITacticalChipManageView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalChipManageView:ComponentDefine()
  self.bgBtn = self:AddComponent(UIButton, "bgBtn")
  self.bgBtn:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Root/title")
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compChipItemNode = self:AddComponent(UIBaseContainer, "Root/chipItemNode")
  self.textName = self:AddComponent(UIText, "Root/nameText")
  self.imgTypeIcon = self:AddComponent(UIImage, "Root/ChipType/TypeIcon")
  self.textType = self:AddComponent(UIText, "Root/ChipType/TypeText")
  self.textPowerNumber = self:AddComponent(UIText, "Root/PowerInfo/PowerNumberText")
  self.textSkillDescTxt = self:AddComponent(UITextMeshProUGUIEx, "Root/textScroll/viewport/content/skillDescTxt")
  self.textSkillDescTxt:OnPointerClick(function(eventData)
    self:OnDescClick(eventData)
  end)
  self.btnInstall = self:AddComponent(UIButton, "Root/installBtn")
  self.btnInstall:SetOnClick(function()
    self:OnBtnInstallClick()
  end)
  self.compInstallBtnRedPoint = self:AddComponent(UIBaseContainer, "Root/installBtn/Btn/installBtnRedPoint")
  self.compChipListNode = self:AddComponent(UIBaseContainer, "Root/chipListNode")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "Root/chipListNode/ItemHolder")
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.compItemContent = self:AddComponent(UIBaseContainer, "Root/chipListNode/ItemHolder/Viewport/ItemContent")
  self.compTabTank = self:AddComponent(UICommonTab, "Root/chipListNode/tabRoot/tabTank")
  self.compTabMissile = self:AddComponent(UICommonTab, "Root/chipListNode/tabRoot/tabMissile")
  self.compTabAir = self:AddComponent(UICommonTab, "Root/chipListNode/tabRoot/tabAir")
  self.textNoChipTip = self:AddComponent(UIText, "Root/chipListNode/noChipTip")
  self.textNoChipTip:SetLocalText("battlesystem_factory_inventory_desc1")
end

function UITacticalChipManageView:ComponentDestroy()
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TacticalChipItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.textTitle = nil
  self.btnClose = nil
  self.compChipItemNode = nil
  self.textName = nil
  self.imgTypeIcon = nil
  self.textType = nil
  self.textPowerNumber = nil
  self.textSkillDescTxt = nil
  self.btnInstall = nil
  self.compInstallBtnRedPoint = nil
  self.compChipListNode = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.compTabTank = nil
  self.compTabMissile = nil
  self.compTabAir = nil
  self.textNoChipTip = nil
end

function UITacticalChipManageView:DataDefine()
  self.cacheChipMap = {}
  self.tabMap = {}
end

function UITacticalChipManageView:DataDestroy()
  self.type = nil
  self.planId = nil
  self.curSelectChip = nil
  self.showChipItem = nil
  self.curShowChipItemReq = nil
  self.tabMap = nil
end

function UITacticalChipManageView:Init()
  self:RefreshBaseData()
  self:InitTab()
  
  local function _searchFirstFreeChip(list)
    local hasFreeChip = false
    if list and 0 < #list then
      self.curSelectChip = list[1]
      if self.curSelectChip:IsFree() then
        hasFreeChip = true
      else
        for _, v in ipairs(list) do
          if v:IsFree() then
            self.curSelectChip = v
            hasFreeChip = true
          end
        end
      end
    end
    return hasFreeChip
  end
  
  if not self.targetIndexInit or self.targetIndexInit < HeroType.Tank then
    for i = 1, 3 do
      self.targetIndexInit = i
      local list = self:GetChipsData(self.type, i, self.planId)
      local hasFreeChip = _searchFirstFreeChip(list)
      if hasFreeChip then
        break
      end
    end
  elseif self.targetIndexInit >= HeroType.Tank and self.targetIndexInit <= HeroType.Aircraft then
    local list = self:GetChipsData(self.type, self.targetIndexInit, self.planId)
    _searchFirstFreeChip(list)
  elseif self.targetIndexInit > HeroType.Aircraft then
    Logger.LogError("\233\128\187\232\190\145\228\184\141\230\148\175\230\140\129\239\188\140\230\163\128\230\159\165\230\152\175\229\144\166\230\150\176\229\162\158\230\158\154\228\184\190\229\144\142\230\178\161\230\156\137\229\174\158\231\142\176\231\155\184\229\186\148\233\128\187\232\190\145")
  end
  self:RefreshChipInfo()
  self:OnTabClick(self.tabMap[self.targetIndexInit])
end

function UITacticalChipManageView:InitTab()
  local tabTankParam = {}
  tabTankParam.tabId = HeroType.Tank
  tabTankParam.clickHandler = self.OnTabClick
  self.compTabTank:ReInit(tabTankParam)
  self.compTabTank:SetSelect(false)
  local tabMissileParam = {}
  tabMissileParam.tabId = HeroType.Missile
  tabMissileParam.clickHandler = self.OnTabClick
  self.compTabMissile:ReInit(tabMissileParam)
  self.compTabMissile:SetSelect(false)
  local tabAirParam = {}
  tabAirParam.tabId = HeroType.Aircraft
  tabAirParam.clickHandler = self.OnTabClick
  self.compTabAir:ReInit(tabAirParam)
  self.compTabAir:SetSelect(false)
  self.tabMap[HeroType.Tank] = self.compTabTank
  self.tabMap[HeroType.Missile] = self.compTabMissile
  self.tabMap[HeroType.Aircraft] = self.compTabAir
end

function UITacticalChipManageView:RefreshBaseData()
  if SKILLCHIP_TYPE_TITLE[self.type] then
    self.textTitle:SetLocalText(SKILLCHIP_TYPE_TITLE[self.type])
  else
    self.textTitle:SetLocalText("uav_chips_title6")
  end
end

function UITacticalChipManageView:RefreshChipInfo()
  if self.curSelectChip == nil then
    return
  end
  local chipInfo = self.curSelectChip
  self.textName:SetText(chipInfo:GetName())
  self.imgTypeIcon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(chipInfo:GetType()))
  self.textType:SetText(TacticalWeaponUtils.GetSkillChipTypeText(chipInfo:GetType()))
  self.textPowerNumber:SetText(chipInfo:GetPowerV2())
  local skillInfo = chipInfo:GetSkillInfo()
  self.textSkillDescTxt:SetText(skillInfo:GetDesc(false, "#5FEF87"))
  if self.curShowChipItemReq == nil then
    self.curShowChipItemReq = self:CreateChipItem()
  elseif self.curShowChipItemReq.isDone then
    self:RefreshShowItemInfo()
  end
end

function UITacticalChipManageView:RefreshShowItemInfo()
  if self.curSelectChip then
    self.showChipItem:SetData(self.curSelectChip)
    self.showChipItem:SetActive(true)
  end
end

function UITacticalChipManageView:RefreshDataList()
  if self.curTab == nil then
    return
  end
  self.chipsDataList = self:GetChipsData(self.type, self.curTab.tabId, self.planId)
  local dataCount = 0
  if self.chipsDataList then
    dataCount = #self.chipsDataList
  end
  self.loopGridViewItemHolder:SetActive(0 < dataCount)
  self.textNoChipTip:SetActive(dataCount <= 0)
  self.loopGridViewItemHolder:SetListItemCount(dataCount)
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function UITacticalChipManageView:CreateChipItem()
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.transform:SetParent(self.compChipItemNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(0, 0, 0)
    local cell = self.compChipItemNode:AddComponent(TacticalChipItem, go.name)
    cell:SetPivotMiddle()
    cell:SetLocalPositionXYZ(0, 0, 0)
    cell:SetCanClick(false)
    self.showChipItem = cell
    self:RefreshShowItemInfo()
  end)
end

function UITacticalChipManageView:OnGetItemByRowColumn(loopScroll, index)
  if self.chipsDataList ~= nil then
    local count = #self.chipsDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalChipItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalChipItem)
    if script == nil then
      local name = "chips_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalChipItem, name)
      script:SetOnClickChipInfo(function(chipInfo)
        self:OnChipItemClick(chipInfo)
      end)
    end
    script:SetActive(true)
    local data = self.chipsDataList[index]
    script:SetCountVisible(true)
    script:SetPlanMasterVisible(true)
    script:SetData(data)
    script:SetChipTypeVisible(true)
    script:SetProductSelectedVisible(self.curSelectChip ~= nil and data:GetUUID() == self.curSelectChip:GetUUID())
    return item
  end
end

function UITacticalChipManageView:GetChipsData(type, heroType, planId)
  local list = self.cacheChipMap[heroType]
  if not list then
    list = self.ctrl:RefreshEquipDataList(type, heroType, planId)
    self.cacheChipMap[heroType] = list
  end
  return list
end

function UITacticalChipManageView:OnChipItemClick(chipInfo)
  self.curSelectChip = chipInfo
  self:RefreshChipInfo()
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function UITacticalChipManageView:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self:RefreshDataList()
end

function UITacticalChipManageView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITacticalChipManageView:OnBtnInstallClick()
  if self.curSelectChip == nil then
    return
  end
  if self.curSelectChip then
    if not self.curSelectChip:IsFree() then
      local chipName = self.curSelectChip:GetName()
      local setId = self.curSelectChip:GetMasterSet()
      UIUtil.ShowMessage(Localization:GetString("drone_skillChip_tips_3", chipName, setId), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.TWSkillChipPutOn, self.planId, {
          [self.curSelectChip.type] = self.curSelectChip.uuid
        })
        self.ctrl:CloseSelf()
      end)
    else
      SFSNetwork.SendMessage(MsgDefines.TWSkillChipPutOn, self.planId, {
        [self.curSelectChip.type] = self.curSelectChip.uuid
      })
      self.ctrl:CloseSelf()
    end
  end
end

function UITacticalChipManageView:OnDescClick(eventData)
  if not eventData then
    return
  end
  local clickPos = eventData.position
  local linkId = self.textSkillDescTxt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = UIUtil.GetString("", linkId)
  param.screenPos = clickPos
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

return UITacticalChipManageView
