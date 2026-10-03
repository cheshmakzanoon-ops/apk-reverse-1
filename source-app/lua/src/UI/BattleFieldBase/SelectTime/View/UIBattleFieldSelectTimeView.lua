local UIBattleFieldSelectTimeView = BaseClass("UIBattleFieldSelectTimeView", UIBaseView)
local base = UIBaseView
local BattleTimeItem = require("UI.BattleFieldBase.SelectTime.Component.BattleTimeItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local img_corner_path = "PopUpTitle/Common_bg_orange/Corner/TeamIcon"
local title_text_path = "PopUpTitle/Common_bg_orange2/TitleText"
local btn_enroll_path = "PopUpTitle/Common_bg_orange2/BtnEnroll"
local content_path = "PopUpTitle/Content"
local time_tip_text_path = "PopUpTitle/Content/TimeTipText"
local change_show_time_btn_path = "PopUpTitle/Content/TimeTipText/ChangeShowTimeBtn"
local time_item_path = "PopUpTitle/Content/TimeItem"

function UIBattleFieldSelectTimeView:OnCreate()
  base.OnCreate(self)
  self.curTabIdx, self.bfType, self.cb = self:GetUserData()
  self.bfType = self.bfType or BattleFieldType.Desert
  self:ComponentDefine()
  local battlePeriod = self.dragonInfo ~= nil and self.dragonInfo.battlePeriod or 0
  self.battlePeriod = battlePeriod == 0 and 1 or battlePeriod
end

function UIBattleFieldSelectTimeView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleFieldSelectTimeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonBattleTimes, self.UpdateData)
end

function UIBattleFieldSelectTimeView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonBattleTimes, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIBattleFieldSelectTimeView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.img_corner = self:AddComponent(UIImage, img_corner_path)
  local hadTeam2 = 0
  if self.bfType == BattleFieldType.Desert then
    local actInfo = DataCenter.ActDragonManager:GetActInfo()
    hadTeam2 = actInfo ~= nil and actInfo.hadTeam2 or 0
  elseif self.bfType == BattleFieldType.EpidemicZone then
    local actInfo = DataCenter.ActEpidemicZoneManager:GetActInfo()
    hadTeam2 = actInfo ~= nil and actInfo.hadTeam2 or 0
  end
  self.img_corner.transform.parent.gameObject:SetActive(hadTeam2 ~= 0)
  if hadTeam2 ~= 0 then
    DataCenter.ActDragonManager:LoadTeamSprite(self.img_corner, self.curTabIdx)
  end
  self.btn_enroll = self:AddComponent(UIButton, btn_enroll_path)
  self.btn_enroll:SetOnClick(function()
    self:ClickEnroll()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.time_tip_text = self:AddComponent(UITextMeshProUGUIEx, time_tip_text_path)
  self.change_show_time_btn = self:AddComponent(UIButton, change_show_time_btn_path)
  self.change_show_time_btn:SetOnClick(function()
    self:ClickChange()
  end)
  self.theItem = self.transform:Find(time_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.isShowLocalTime = true
  self:UpdateData()
end

function UIBattleFieldSelectTimeView:ComponentDestroy()
  self.content:RemoveComponents(BattleTimeItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
end

function UIBattleFieldSelectTimeView:UpdateData()
  self.lastBattlePeriod = 0
  if self.bfType == BattleFieldType.Desert then
    self.dragonInfo = DataCenter.ActDragonManager:GetGroup(self.curTabIdx)
    self.battleTime = DataCenter.ActDragonManager:GetBattleTimeInfo()
    if self.battleTime == nil then
      DataCenter.ActDragonManager:SendGetBattleTime()
    end
  elseif self.bfType == BattleFieldType.EpidemicZone then
    self.dragonInfo = ActEpidemicUtils.GetGroup(self.curTabIdx)
    local actInfo = ActEpidemicUtils.GetActInfo()
    self.battleTime = actInfo ~= nil and actInfo.battleTimes or nil
  end
  self.time_tip_text:SetLocalText(self.isShowLocalTime and "Desert_strom_tips1001" or "Desert_strom_tips1002")
  if self.battleTime ~= nil then
    self.content:RemoveComponents(BattleTimeItem)
    self.theItem:GameObjectRecycleAll()
    local goItem, itemNode, activeNode
    local battlePeriod = self.dragonInfo ~= nil and self.dragonInfo.battlePeriod or 0
    self.lastBattlePeriod = self.dragonInfo ~= nil and self.dragonInfo.lastBattlePeriod or 0
    for i, v in ipairs(self.battleTime) do
      if v ~= nil then
        local theName = "time_" .. i
        goItem = self.content.transform:Find(theName)
        if goItem == nil then
          goItem = self.theItem:GameObjectSpawn(self.content.transform)
          goItem.name = theName
          goItem:SetActive(true)
          itemNode = self.content:AddComponent(BattleTimeItem, theName)
        else
          itemNode = self.content:GetComponent(theName, BattleTimeItem)
        end
        itemNode:ReInit(v, self.isShowLocalTime)
        if activeNode == nil or v.battlePeriod == battlePeriod then
          activeNode = itemNode
        end
        itemNode.last:SetActive(self.lastBattlePeriod == v.battlePeriod)
      end
    end
    if activeNode and activeNode.checkbox then
      activeNode.checkbox:SetIsOn(true)
    end
  end
end

function UIBattleFieldSelectTimeView:onSelectCell(selected, battlePeriod)
  if selected then
    self.battlePeriod = battlePeriod
  end
end

function UIBattleFieldSelectTimeView:DoSend()
  local battlePeriod, state = 0, 0
  if self.dragonInfo ~= nil then
    battlePeriod = self.dragonInfo.battlePeriod or 0
    if self.bfType == BattleFieldType.Desert then
      state = self.dragonInfo.signUp or 0
    else
      state = self.dragonInfo.state or 0
    end
  end
  if state == 1 and battlePeriod ~= 0 then
    if battlePeriod ~= self.battlePeriod then
      if self.bfType == BattleFieldType.Desert then
        DataCenter.ActDragonManager:SendModifyBattlePeriod(self.battlePeriod, self.curTabIdx)
      elseif self.bfType == BattleFieldType.EpidemicZone then
        DataCenter.ActEpidemicZoneManager:RequestActivityChangeBattleTime(self.curTabIdx, self.battlePeriod)
      end
    end
  elseif self.bfType == BattleFieldType.Desert then
    DataCenter.ActDragonManager:SendSignUp(self.battlePeriod, self.curTabIdx)
  elseif self.bfType == BattleFieldType.EpidemicZone and self.cb then
    self.cb(self.battlePeriod)
  end
  self.ctrl:CloseSelf()
end

function UIBattleFieldSelectTimeView:ClickEnroll()
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    if self.lastBattlePeriod == 0 or self.lastBattlePeriod == self.battlePeriod then
      self:DoSend()
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldSelectTimeSecond, {anim = true}, self.bfType, self.curTabIdx, self.battlePeriod, function()
        self:DoSend()
      end)
    end
  else
    UIUtil.ShowTipsId("458187")
  end
end

function UIBattleFieldSelectTimeView:ClickChange()
  self.isShowLocalTime = not self.isShowLocalTime
  self:UpdateData()
end

return UIBattleFieldSelectTimeView
