local UIBattleFieldChangeTimeView = BaseClass("UIBattleFieldChangeTimeView", UIBaseView)
local SelectTimeItem = require("UI.BattleFieldBase.ChangeTime.Component.SelectTimeItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBattleFieldChangeTimeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIBattleFieldChangeTimeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleFieldChangeTimeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirm = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTimeTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnChangeShowTime = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnChangeShowTime:SetOnClick(function()
    self:OnBtnChangeShowTimeClick()
  end)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compGroupContent = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textTimeA = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.toggleCheckboxA = self.viewSkin:AddComponent(self, UIToggle, 13)
  self.textTimeB = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.toggleCheckboxB = self.viewSkin:AddComponent(self, UIToggle, 15)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.textTips:SetLocalText("Desert_strom_tips1004")
  self.compItem:SetActive(false)
  self.itemObj = self.compItem.gameObject
  self.itemObj:GameObjectCreatePool()
end

function UIBattleFieldChangeTimeView:ComponentDestroy()
  self.compContent:RemoveComponents(SelectTimeItem)
  self.itemObj:GameObjectRecycleAll()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnConfirm = nil
  self.textConfirm = nil
  self.textTips = nil
  self.textTimeTip = nil
  self.btnChangeShowTime = nil
  self.compItem = nil
  self.compGroupContent = nil
  self.text = nil
  self.textTimeA = nil
  self.toggleCheckboxA = nil
  self.textTimeB = nil
  self.toggleCheckboxB = nil
  self.compContent = nil
end

function UIBattleFieldChangeTimeView:DataDefine()
  self.confirmCallBack, self.bfType = self:GetUserData()
  self.bfType = self.bfType or BattleFieldType.Desert
  if self.bfType == BattleFieldType.DsbDuel then
    self.textTitle:SetLocalText("dsb_duel_tips_1034")
  else
    self.textTitle:SetLocalText("Desert_strom_tips1003")
  end
  self.isShowLocalTime = BattleFieldUtil.GetShowLocalTime()
  self.chooseBattlePeriod = {}
end

function UIBattleFieldChangeTimeView:DataDestroy()
  self.confirmCallBack = nil
  self.chooseBattlePeriod = nil
end

function UIBattleFieldChangeTimeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonBattleTimes, self.RefreshSelectTimeData)
end

function UIBattleFieldChangeTimeView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonBattleTimes, self.RefreshSelectTimeData)
  base.OnRemoveListener(self)
end

function UIBattleFieldChangeTimeView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBattleFieldChangeTimeView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBattleFieldChangeTimeView:OnBtnConfirmClick()
  if self.bfType == BattleFieldType.Desert then
    SFSNetwork.SendMessage(MsgDefines.DragonUserApplyBattle, 1, self.chooseBattlePeriod)
  elseif self.bfType == BattleFieldType.EpidemicZone then
    local group = self.toggleCheckboxA:GetIsOn() and 1 or 2
    DataCenter.ActEpidemicZoneManager:RequestActivityApply(group, self.chooseBattlePeriod)
  elseif self.bfType == BattleFieldType.DsbDuel then
    local group = self.toggleCheckboxA:GetIsOn() and 1 or 2
    BattlefieldDsbDuelUtils.ActInfo:SendActApplyMsg(group)
  end
  if self.confirmCallBack ~= nil then
    self.confirmCallBack()
  end
  self.ctrl:CloseSelf()
end

function UIBattleFieldChangeTimeView:OnBtnChangeShowTimeClick()
  self.isShowLocalTime = not self.isShowLocalTime
  BattleFieldUtil.SetShowLocalTime(self.isShowLocalTime)
  self:RefreshBattleTimeTipsShow()
end

function UIBattleFieldChangeTimeView:RefreshUI()
  self:RefreshBattleTimeTipsShow()
  self:RefreshSelectTimeData()
  self:RefreshGroupSel()
  self:RefreshConfirmBtnState()
end

function UIBattleFieldChangeTimeView:RefreshBattleTimeTipsShow()
  self.textTimeTip:SetLocalText(self.isShowLocalTime and "Desert_strom_tips1001" or "Desert_strom_tips1002")
end

function UIBattleFieldChangeTimeView:RefreshSelectTimeData()
  local battleTime
  if self.bfType == BattleFieldType.Desert then
    battleTime = DataCenter.ActDragonManager:GetBattleTimeInfo()
    if battleTime == nil then
      DataCenter.ActDragonManager:SendGetBattleTime()
    end
  elseif self.bfType == BattleFieldType.EpidemicZone then
    local actInfo = ActEpidemicUtils.GetActInfo()
    battleTime = actInfo ~= nil and actInfo.battleTimes or nil
  end
  if battleTime ~= nil then
    self.compContent:SetActive(true)
    self.compContent:RemoveComponents(SelectTimeItem)
    self.itemObj:GameObjectRecycleAll()
    for i, v in ipairs(battleTime) do
      if v ~= nil then
        local objName = "time_" .. i
        local obj = self.itemObj:GameObjectSpawn(self.compContent.transform)
        obj.name = objName
        obj:SetActive(true)
        local itemRender = self.compContent:AddComponent(SelectTimeItem, objName)
        itemRender:ReInit(v, true)
      end
    end
  else
    self.compContent:SetActive(false)
  end
end

function UIBattleFieldChangeTimeView:RefreshGroupSel()
  local groupIdx
  if self.bfType == BattleFieldType.EpidemicZone then
    groupIdx = ActEpidemicUtils.GetMyGroupIndex()
    groupIdx = 0 < groupIdx and groupIdx or 1
  elseif self.bfType == BattleFieldType.DsbDuel then
    local pInfo = BattlefieldDsbDuelUtils.ActInfo:GetPlayerInfoByUID(LuaEntry.Player.uid)
    groupIdx = pInfo ~= nil and pInfo.apply or 0
    if groupIdx == 0 then
      groupIdx = BattlefieldDsbDuelUtils.GetMyTeam()
    end
    groupIdx = 0 < groupIdx and groupIdx or 1
  else
    self.compGroupContent:SetActive(false)
  end
  self.compGroupContent:SetActive(groupIdx ~= nil)
  if groupIdx ~= nil then
    if groupIdx == 1 then
      self.toggleCheckboxA:SetIsOn(true)
    else
      self.toggleCheckboxB:SetIsOn(true)
    end
    self.textTimeA:SetLocalText("YiBianJinQu_sign_up_tips_2")
    self.textTimeB:SetLocalText("YiBianJinQu_sign_up_tips_3")
  end
end

function UIBattleFieldChangeTimeView:RefreshConfirmBtnState()
  local showGray = table.count(self.chooseBattlePeriod) == 0
  if self.bfType == BattleFieldType.DsbDuel then
    showGray = false
  end
  CS.UIGray.SetGray(self.btnConfirm.transform, showGray, not showGray)
end

function UIBattleFieldChangeTimeView:OnSetSelectState(selected, battlePeriod)
  if selected then
    table.insert(self.chooseBattlePeriod, battlePeriod)
  else
    for i, v in pairs(self.chooseBattlePeriod) do
      if v == battlePeriod then
        table.remove(self.chooseBattlePeriod, i)
        break
      end
    end
  end
  self:RefreshConfirmBtnState()
end

return UIBattleFieldChangeTimeView
