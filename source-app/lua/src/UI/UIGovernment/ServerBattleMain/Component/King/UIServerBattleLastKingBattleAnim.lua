local UIServerBattleLastKingBattleAnim = BaseClass("UIServerBattleLastKingBattleAnim", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local time_bg_path = "TimeBg"
local remain_time_path = "TimeBg/remainTime"
local img1_path = "img1"
local img2_path = "img2"
local title1_path = "title1"
local title2_path = "title2"
local go_btn1_path = "GoBtn1"
local text1_path = "GoBtn1/Text1"
local go_btn2_path = "GoBtn2"
local text2_path = "GoBtn2/Text2"
local effect_path = "effect"

function UIServerBattleLastKingBattleAnim:OnCreate()
  base.OnCreate(self)
  self.time_bg = self:AddComponent(UIImage, time_bg_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.img1 = self:AddComponent(UIBaseContainer, img1_path)
  self.img2 = self:AddComponent(UIBaseContainer, img2_path)
  self.title1 = self:AddComponent(UIText, title1_path)
  self.title2 = self:AddComponent(UIText, title2_path)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.go_btn1 = self:AddComponent(UIButton, go_btn1_path)
  self.text1 = self:AddComponent(UIText, text1_path)
  self.go_btn2 = self:AddComponent(UIButton, go_btn2_path)
  self.text2 = self:AddComponent(UIText, text2_path)
  self.go_btn1:SetOnClick(function()
    if DataCenter.LWZombieRushManager:IsChallenging() then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:GotoCity()
      end, function()
      end)
      return
    end
    self:GotoCity()
  end)
  self.go_btn2:SetOnClick(function()
    if DataCenter.LWZombieRushManager:IsChallenging() then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:GotoCity()
      end, function()
      end)
      return
    end
    self:GotoCity()
  end)
end

function UIServerBattleLastKingBattleAnim:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleLastKingBattleAnim:ReInit(configSchedule, fightInfo, config, serverBattleType)
  local mySeverId, leftInfo, rightInfo = DataCenter.ZoneWarManager:ParseVsRound(fightInfo.curVsRound, true)
  local txt = Localization:GetString("110003")
  local btn_go = self.go_btn1
  self.config = config
  self.serverBattleType = serverBattleType
  if leftInfo.score > rightInfo.score or leftInfo.score == rightInfo.score and leftInfo.serverId > rightInfo.serverId then
    self.img1:SetActive(false)
    self.img2:SetActive(true)
    self.go_btn1:SetActive(false)
    self.go_btn2:SetActive(true)
    self.title1:SetActive(false)
    self.title2:SetActive(true)
    self.gotoServerId = rightInfo.serverId
    self.title2:SetText(string.format("#%d X:499 Y:497", self.gotoServerId))
    self.effect.transform:DORotate(Vector3(0, 0, 0), 0.01)
    btn_go = self.go_btn2
  else
    self.img1:SetActive(true)
    self.img2:SetActive(false)
    self.go_btn1:SetActive(true)
    self.go_btn2:SetActive(false)
    self.title1:SetActive(true)
    self.title2:SetActive(false)
    self.gotoServerId = leftInfo.serverId
    self.title1:SetText(string.format("#%d X:499 Y:497", self.gotoServerId))
    self.effect.transform:DORotate(Vector3(0, 180, 0), 0.01)
    btn_go = self.go_btn1
  end
  self.gotoPointIndex = nil
  if LuaEntry.Player:GetCurServerId() == self.gotoServerId and LuaEntry.Player:GetSourceServerId() ~= self.gotoServerId then
    txt = Localization:GetString("multiply_door_tips_008")
    self.gotoServerId = LuaEntry.Player:GetSourceServerId()
    self.time_bg:SetActive(false)
    CS.UIGray.SetGray(btn_go.transform, false, true)
    local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
    if markInfo then
      self.gotoPointIndex = markInfo:GetPointIndex()
      if self.gotoPointIndex == 0 then
        self.gotoPointIndex = LuaEntry.Player:GetMainWorldPos()
        if self.gotoPointIndex == 0 then
          self.gotoPointIndex = nil
        end
      end
    end
  else
    txt = Localization:GetString("110003")
    if mySeverId ~= self.gotoServerId then
      local now = UITimeManager:GetInstance():GetServerTime()
      local crossMoveCDEnd = DataCenter.LeagueMatchManager:GetCrossMoveCDEnd()
      if crossMoveCDEnd and now < crossMoveCDEnd then
        self.endTime = crossMoveCDEnd
        self.time_bg:SetActive(true)
        self:Update1000MS()
        CS.UIGray.SetGray(btn_go.transform, true, true)
      else
        self.time_bg:SetActive(false)
        CS.UIGray.SetGray(btn_go.transform, false, true)
      end
    else
      self.time_bg:SetActive(false)
      CS.UIGray.SetGray(btn_go.transform, false, true)
    end
  end
  self.text1:SetText(txt)
  self.text2:SetText(txt)
  self.btn_go = btn_go
end

function UIServerBattleLastKingBattleAnim:Update1000MS()
  if self.endTime and self.btn_go then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.time_bg:SetActive(false)
      CS.UIGray.SetGray(self.btn_go.transform, false, true)
    end
  end
end

function UIServerBattleLastKingBattleAnim:GotoCity()
  if self.gotoPointIndex then
    CrossServerUtil.JumpToServerByServerId(self.gotoServerId, MoveCrossServerType.CrossServerKingBattle, self.gotoPointIndex)
  else
    CrossServerUtil.JumpToKingdomAround(self.gotoServerId, MoveCrossServerType.CrossServerKingBattle)
  end
end

return UIServerBattleLastKingBattleAnim
