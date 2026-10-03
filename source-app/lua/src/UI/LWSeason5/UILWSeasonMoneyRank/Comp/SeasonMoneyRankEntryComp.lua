local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SeasonMoneyRankEntryComp = BaseClass("SeasonMoneyRankEntryComp", UIBaseContainer)

function SeasonMoneyRankEntryComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textEntryTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textEntryRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnEntrySelect = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnEntrySelect:SetOnClick(function()
    self:OnBtnEntrySelectClick()
  end)
  self.compBtnCanvasGroup = self.viewSkin:AddComponent(self, UICanvasGroup, 4)
  self.btnEntryGoto = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnEntryGoto:SetOnClick(function()
    self:OnBtnEntryGotoClick()
  end)
  self.imgEntryIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textBtnEntryGoto = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.transMoveEnd = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.transMoveStart = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
end

function SeasonMoneyRankEntryComp:ComponentDestroy()
  self.viewSkin = nil
  self.textEntryTitle = nil
  self.textEntryRank = nil
  self.btnEntrySelect = nil
  self.compBtnCanvasGroup = nil
  self.btnEntryGoto = nil
  self.imgEntryIcon = nil
  self.textBtnEntryGoto = nil
  self.transMoveEnd = nil
  self.transMoveStart = nil
end

function SeasonMoneyRankEntryComp:DataDefine()
end

function SeasonMoneyRankEntryComp:DataDestroy()
end

function SeasonMoneyRankEntryComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonMoneyRankEntryComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonMoneyRankEntryComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMoneyRankRankUpdate, self.OnRankUpdate)
  self:AddUIListener(EventId.SeasonMoneyRankEntrySelect, self.OnEntrySelect)
end

function SeasonMoneyRankEntryComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMoneyRankRankUpdate, self.OnRankUpdate)
  self:RemoveUIListener(EventId.SeasonMoneyRankEntrySelect, self.OnEntrySelect)
  base.OnRemoveListener(self)
end

function SeasonMoneyRankEntryComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonMoneyRankEntryComp:InitData(data)
  if data ~= nil then
    self.Data = data
    local curActState = DataCenter.SeasonMoneyRankManager:GetCurActState()
    self.PeriodType = self.Data.PeriodType[curActState]
    self.Selected = false
    self.IsOpen = self:HandleActIsOpen()
    return true
  end
  return false
end

function SeasonMoneyRankEntryComp:InitUi()
  self.textBtnEntryGoto:SetLocalText("110003")
  self.btnEntryGoto:SetActive(self.IsOpen)
  self.textEntryTitle:SetLocalText(self.Data.Title)
  self.imgEntryIcon:LoadSpriteAsync(self.Data.Icon)
  self:ResetState()
  if not self.IsOpen then
    self.textEntryRank:SetText(CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc21"))
  end
  CS.UIGray.SetGray(self.imgEntryIcon.transform, not self.IsOpen, true)
end

function SeasonMoneyRankEntryComp:UpdateData()
  if self.IsOpen then
    self.RankData = DataCenter.SeasonMoneyRankManager:GetCacheRankData(self.Data.RankType, self.PeriodType, DataCenter.SeasonMoneyRankManager.RankMode.Simple)
    return self.RankData ~= nil
  end
  return false
end

function SeasonMoneyRankEntryComp:UpdateUi()
  local myData = self.RankData.self
  if myData ~= nil then
    self.textEntryRank:SetText(self:HandleRankText(myData.rank))
  end
end

function SeasonMoneyRankEntryComp:HandleRankText(rank)
  if not self.IsOpen then
    return CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc21")
  end
  rank = checknumber(rank)
  if rank <= 0 then
    return CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc30")
  end
  if 200 < rank then
    return CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc31", "200+")
  end
  return CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc31", rank)
end

function SeasonMoneyRankEntryComp:OnBtnEntrySelectClick()
  if not self.IsOpen then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc21"))
    return
  end
  if self.Data ~= nil then
    EventManager:GetInstance():Broadcast(EventId.SeasonMoneyRankEntryClick, self.Data)
  end
end

function SeasonMoneyRankEntryComp:OnBtnEntryGotoClick()
  if self.Data ~= nil then
    self:HandleActGoto()
  end
end

function SeasonMoneyRankEntryComp:OnRankUpdate(evtData)
  if self.Data ~= nil and evtData.RankType == self.Data.RankType and evtData.PeriodType == self.PeriodType and self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonMoneyRankEntryComp:OnEntrySelect(evtData)
  if self.Data == nil or evtData == nil then
    return
  end
  if self.Data.RankType == evtData.RankType then
    self.Selected = not self.Selected
    if self.Selected then
      self:AnimUp()
    else
      self:AnimDown()
    end
    return
  end
  if self.Selected then
    self.Selected = false
    self:AnimDown()
  end
end

function SeasonMoneyRankEntryComp:AnimUp()
  self.imgEntryIcon.transform:DOMove(self.transMoveEnd.transform.position, 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuart)
  self.compBtnCanvasGroup:FadeIn(0.2)
  self.btnEntryGoto:SetEnable(true)
end

function SeasonMoneyRankEntryComp:AnimDown()
  self.imgEntryIcon.transform:DOMove(self.transMoveStart.transform.position, 0.2):SetEase(CS.DG.Tweening.Ease.InOutQuart)
  self.compBtnCanvasGroup:FadeOut(0.2)
  self.btnEntryGoto:SetEnable(false)
end

function SeasonMoneyRankEntryComp:ResetState()
  self.imgEntryIcon:SetAnchoredPosition(Vector2.zero)
  self.btnEntryGoto:SetActive(true)
  self.compBtnCanvasGroup:SetAlpha(0)
  self.btnEntryGoto:SetEnable(false)
end

function SeasonMoneyRankEntryComp:HandleActIsOpen()
  if self.Data == nil then
    return false
  end
  if self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.BankManage or self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.BankRob then
    local curState = DataCenter.SeasonMoneyRankManager:GetCurActState()
    return curState == DataCenter.SeasonMoneyRankManager.ActState.Normal
  elseif self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.Shoot then
    local isActOpen = DataCenter.ActivityListDataManager:IsActivityOpen(self.Data.ActType)
    local pvpOpen, _ = DataCenter.LWBiuBiuDataManager:IsPvpOpen()
    local isPvpOpen = isActOpen and pvpOpen
    return isPvpOpen
  elseif self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.Train then
    return DataCenter.ActivityListDataManager:IsActivityOpen(self.Data.ActType)
  end
  return false
end

function SeasonMoneyRankEntryComp:HandleActGoto()
  if self.Data == nil or not self.IsOpen then
    return
  end
  if self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.BankManage then
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankCity, {anim = true}, "", 1)
  elseif self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.BankRob then
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankCity, {anim = true}, "", 3)
  elseif self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.Shoot then
    GoToUtil.GotoSeasonBiuBiuActivity()
  elseif self.Data.RankType == DataCenter.SeasonMoneyRankManager.RankType.Train then
    GoToUtil.GotoSeasonActivityView(EnumActivity.HighSpeedRailway.Type)
  end
end

return SeasonMoneyRankEntryComp
