local UIBattleFieldAssignedStateView = BaseClass("UIBattleFieldAssignedStateView", UIBaseView)
local base = UIBaseView
local RAW_PATH = "Assets/Main/TextureEx/BattleField/part0/%s"

function UIBattleFieldAssignedStateView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIBattleFieldAssignedStateView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattleFieldAssignedStateView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.rawImgGroup = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.rawImgFire = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.textMain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textCurTimeTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnTime = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnTime:SetOnClick(function()
    self:OnBtnTimeClick()
  end)
  self.textData = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 9)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textAssign = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.imgAssignIcon = self.viewSkin:AddComponent(self, UIImage, 12)
  self.textState = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.rawImgState = self.viewSkin:AddComponent(self, UIRawImage, 14)
  self.animator = self.viewSkin:AddComponent(self, UIAnimator, 15)
  self.simpleAnimationState = self.viewSkin:AddComponent(self, UISimpleAnimation, 16)
end

function UIBattleFieldAssignedStateView:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.viewSkin = nil
  self.btnPanel = nil
  self.rawImgGroup = nil
  self.rawImgFire = nil
  self.textMain = nil
  self.textCurTimeTips = nil
  self.btnTime = nil
  self.textData = nil
  self.textTime = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textAssign = nil
  self.imgAssignIcon = nil
  self.textState = nil
  self.rawImgState = nil
  self.animator = nil
  self.simpleAnimationState = nil
end

function UIBattleFieldAssignedStateView:DataDefine()
  local param = self:GetUserData()
  self.bfType = param.bfType
  self.groupIdx = param.groupIdx
  self.assigned = param.assigned
  self.battlePeriod = param.battlePeriod
  self.editorUid = param.editorUid
  self.inGroup = param.inGroup
  self.closing = false
  self.isShowLocalTime = true
  self.textData:SetLocalText("Desert_strom_tips1017")
end

function UIBattleFieldAssignedStateView:DataDestroy()
end

function UIBattleFieldAssignedStateView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonBattleTimes, self.UpdateTime)
end

function UIBattleFieldAssignedStateView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonBattleTimes, self.UpdateTime)
  base.OnRemoveListener(self)
end

function UIBattleFieldAssignedStateView:OnBtnPanelClick()
  if self.closing or self.timer ~= nil then
    return
  end
  self.closing = true
  local state, time = self.animator:PlayAnimationReturnTime("CommonPopup_moveout")
  if state then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self.timer = nil
      self.ctrl:CloseSelf()
    end, time)
  end
end

function UIBattleFieldAssignedStateView:OnBtnTimeClick()
  self.isShowLocalTime = not self.isShowLocalTime
  self:UpdateTime()
end

function UIBattleFieldAssignedStateView:RefreshUI()
  local battleTimes = DataCenter.ActDragonManager:GetBattleTimeInfo()
  if table.IsNullOrEmpty(battleTimes) then
    DataCenter.ActDragonManager:SendGetBattleTime()
  end
  local state, time = self.animator:PlayAnimationReturnTime("V_ui_desert_assign_in")
  if state then
    self.rawImgState:SetActive(false)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self.timer = nil
      self.rawImgState:SetActive(true)
      state, time = self.simpleAnimationState:PlayAnimationReturnTime("Default")
      if state then
        self.timer = TimerManager:GetInstance():DelayInvoke(function()
          self.timer = nil
        end, time)
      end
    end, time)
  end
  local groupName = self.groupIdx == 1 and "lrb_shamobaoming_canzha_A.png" or "lrb_shamobaoming_canzha_B.png"
  self.rawImgGroup:LoadSpriteAuto(string.format(RAW_PATH, groupName))
  local fireName = self.inGroup and "lrb_shamobaoming_canzha_banner01.png" or "lrb_shamobaoming_canzha_banner02.png"
  self.rawImgFire:LoadSpriteAuto(string.format(RAW_PATH, fireName))
  local abStr = self.groupIdx == 1 and "A" or "B"
  self.textMain:SetLocalText(self.inGroup and "Desert_strom_interface_1010" or "Desert_strom_interface_1011", abStr)
  self:UpdateTime()
  self.compUIPlayerHead:SetAsMyself()
  self.textName:SetText(LuaEntry.Player:GetFullName())
  local assignName = self.inGroup and "zyf_shamofengbao_canzhanrenshu_icon.png" or "zyf_shamofengbao_tiburenshu_icon.png"
  self.imgAssignIcon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, assignName))
  self.textAssign:SetLocalText(self.assigned == 1 and "458002" or "458003")
  local stateName = self.inGroup and "lrb_shamobaoming_canzha_hege.png" or "lrb_shamobaoming_canzha_buhege.png"
  self.rawImgState:LoadSpriteAuto(string.format(RAW_PATH, stateName))
  self.textState:SetLocalText(self.inGroup and "Desert_strom_interface_1012" or "Desert_strom_interface_1013")
  self.textState:SetColorHex(self.inGroup and "#0EB626" or "#D33131")
end

function UIBattleFieldAssignedStateView:UpdateTime()
  self.textCurTimeTips:SetLocalText(self.isShowLocalTime and "Desert_strom_tips1001" or "Desert_strom_tips1002")
  local battleTimes
  if self.bfType == BattleFieldType.Desert then
    battleTimes = DataCenter.ActDragonManager:GetBattleTimeInfo()
  elseif self.bfType == BattleFieldType.EpidemicZone then
    local actInfo = ActEpidemicUtils.GetActInfo()
    battleTimes = actInfo ~= nil and actInfo.battleTimes or nil
  end
  if battleTimes then
    for _, v in ipairs(battleTimes) do
      if v ~= nil and v.battlePeriod == self.battlePeriod then
        self:SetTimeShow(v.startTime, v.endTime)
      end
    end
  end
end

function UIBattleFieldAssignedStateView:SetTimeShow(startTime, endTime)
  local mgr = UITimeManager:GetInstance()
  if self.isShowLocalTime then
    local startTimeStr = mgr:TimeStampToTimeForLocal(startTime)
    local endTimeStr = mgr:TimeStampToTimeForLocalSimple(endTime)
    self.textTime:SetText(startTimeStr .. " ~ " .. endTimeStr)
  else
    local startTimeStr = mgr:TimeStampToTimeForServer(startTime)
    local endTimeStr = mgr:TimeStampToTimeForServer(endTime, true)
    self.textTime:SetText(startTimeStr .. " ~ " .. endTimeStr)
  end
end

return UIBattleFieldAssignedStateView
