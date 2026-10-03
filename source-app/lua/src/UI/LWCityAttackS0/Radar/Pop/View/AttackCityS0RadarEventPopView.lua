local AttackCityS0RadarEventPopView = BaseClass("AttackCityS0RadarEventPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function AttackCityS0RadarEventPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

function AttackCityS0RadarEventPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AttackCityS0RadarEventPopView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.rawImgCityIcon = self.viewSkin:AddComponent(self, UIRawImage, 4)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnCollect = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnCollect:SetOnClick(function()
    self:OnBtnCollectClick()
  end)
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "Common_img_title/timeText")
end

function AttackCityS0RadarEventPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.rawImgCityIcon = nil
  self.textSubTitle = nil
  self.textDesc = nil
  self.btnCollect = nil
  self.textTime = nil
end

function AttackCityS0RadarEventPopView:DataDefine()
end

function AttackCityS0RadarEventPopView:DataDestroy()
  self.nextStateTime = nil
  self.cityLevel = nil
end

function AttackCityS0RadarEventPopView:OnAddListener()
  base.OnAddListener(self)
end

function AttackCityS0RadarEventPopView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AttackCityS0RadarEventPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function AttackCityS0RadarEventPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function AttackCityS0RadarEventPopView:InitData()
  self.cityLevel, self.nextStateTime = DataCenter.AttackCityS0DataManager:GetActCityLevelAndStateTime()
  self.textTitle:SetLocalText("city_war_detect_city_02", self.cityLevel + 1)
end

function AttackCityS0RadarEventPopView:OnBtnCollectClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("city_war_tips_02")
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    return
  end
  if not DataCenter.AttackCityS0DataManager:GetCityClueAndRadarOpenState() then
    UIUtil.ShowTipsId("city_war_tips_01")
    self.ctrl:CloseSelf()
    return
  end
  local cityRadar = DataCenter.AttackCityS0DataManager:GetDetectEventInfoByType(DetectEventType.AttackCityS0_City_Scout)
  if not table.IsNullOrEmpty(cityRadar) then
    EventManager:GetInstance():Broadcast(EventId.AttackCityS0RadarEvent, DetectEventType.AttackCityS0_City_Scout)
    self.ctrl:CloseSelf()
  else
    local monsterRadar = DataCenter.AttackCityS0DataManager:GetDetectEventInfoByType(DetectEventType.AttackCityS0_City_Monster)
    if not table.IsNullOrEmpty(monsterRadar) then
      for i = 1, #monsterRadar do
        if monsterRadar[i].state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED and monsterRadar[i].state ~= DetectEventState.DETECT_EVENT_STATE_REWARDED and monsterRadar[i] and monsterRadar[i].cityId then
          local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(tonumber(monsterRadar[i].cityId))
          local worldPos = SceneUtils.TileToWorld(cityMeta.pos)
          GoToUtil.CloseAllWindows()
          GoToUtil.GotoWorldPos(worldPos)
          return
        end
      end
    end
    UIUtil.ShowTipsId("city_war_tips_04")
  end
end

function AttackCityS0RadarEventPopView:Update1000MS()
  if self.nextStateTime and self.nextStateTime > 0 and self.textTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.nextStateTime - curTime
    if 0 < deltaTime then
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.textTime:SetText("00:00:00")
      self.ctrl:CloseSelf()
    end
  end
end

return AttackCityS0RadarEventPopView
