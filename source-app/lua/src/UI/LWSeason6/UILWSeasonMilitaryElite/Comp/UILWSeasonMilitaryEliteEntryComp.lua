local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWSeasonMilitaryEliteEntryComp = BaseClass("UILWSeasonMilitaryEliteEntryComp", UIBaseContainer)

function UILWSeasonMilitaryEliteEntryComp:ComponentDefine()
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

function UILWSeasonMilitaryEliteEntryComp:ComponentDestroy()
  if self.Timer ~= nil then
    self.Timer:Stop()
    self.Timer = nil
  end
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

function UILWSeasonMilitaryEliteEntryComp:DataDefine()
end

function UILWSeasonMilitaryEliteEntryComp:DataDestroy()
end

function UILWSeasonMilitaryEliteEntryComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryEliteEntryComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryEliteEntryComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnRankUpdate)
  self:AddUIListener(EventId.SeasonMilitaryEliteEntrySelect, self.OnEntrySelect)
end

function UILWSeasonMilitaryEliteEntryComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonMilitaryEliteRankUpdate, self.OnRankUpdate)
  self:RemoveUIListener(EventId.SeasonMilitaryEliteEntrySelect, self.OnEntrySelect)
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryEliteEntryComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryEliteEntryComp:InitData(data)
  if data ~= nil then
    self.Data = data
    local curActState = DataCenter.SeasonMilitaryEliteManager:GetCurActState()
    self.Selected = false
    self.IsOpen = self:HandleActIsOpen()
    self.Cell = LocalController:instance():tryGetLine(TableName.LW_SEASON_MILITARY_RANK, checknumber(self.Data.RankType))
    return true
  end
  return false
end

function UILWSeasonMilitaryEliteEntryComp:InitUi()
  self.textBtnEntryGoto:SetLocalText("season_s6_Military_Rank_Source_Btn")
  if self.Cell ~= nil then
    self.textEntryTitle:SetLocalText(self.Cell.name)
    self.imgEntryIcon:LoadSpriteAsync(self.Cell.icon)
  end
  self:ResetState()
  if self.Data.Selected then
    self.Selected = true
    self.Timer = TimerManager:GetInstance():DelayFrameInvoke(function()
      self:AnimUp(0)
    end, 1)
  end
  if not self.IsOpen then
    self.textEntryRank:SetText(CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc21"))
  end
  CS.UIGray.SetGray(self.imgEntryIcon.transform, not self.IsOpen, true)
end

function UILWSeasonMilitaryEliteEntryComp:UpdateData()
  if self.IsOpen then
    self.RankData = DataCenter.SeasonMilitaryEliteManager:GetCacheRankData(self.Data.RankType, self.Data.PeriodType, DataCenter.SeasonMilitaryEliteManager.RankMode.Simple)
    return self.RankData ~= nil
  end
  return false
end

function UILWSeasonMilitaryEliteEntryComp:UpdateUi()
  local myData = self.RankData.self
  if myData ~= nil then
    self.textEntryRank:SetText(self:HandleRankText(myData.rank))
  end
end

function UILWSeasonMilitaryEliteEntryComp:HandleRankText(rank)
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

function UILWSeasonMilitaryEliteEntryComp:OnBtnEntrySelectClick()
  if not self.IsOpen then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_s5_activity_1200046_desc21"))
    return
  end
  if self.Data ~= nil then
    EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryEliteEntryClick, self.Data)
  end
end

function UILWSeasonMilitaryEliteEntryComp:OnBtnEntryGotoClick()
  if self.Data ~= nil then
    self:HandleActGoto()
  end
end

function UILWSeasonMilitaryEliteEntryComp:OnRankUpdate(evtData)
  if self.Data ~= nil and evtData.RankType == self.Data.RankType and evtData.PeriodType == self.Data.PeriodType and self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonMilitaryEliteEntryComp:OnEntrySelect(evtData)
  if self.Data == nil or evtData == nil then
    return
  end
  if self.Data.RankType == evtData.RankType then
    self.Selected = not self.Selected
    if self.Selected then
      self:AnimUp(0.2)
    else
      self:AnimDown(0.2)
    end
    return
  end
  if self.Selected then
    self.Selected = false
    self:AnimDown(0.2)
  end
end

function UILWSeasonMilitaryEliteEntryComp:AnimUp(duration)
  self.imgEntryIcon.transform:DOMove(self.transMoveEnd.transform.position, duration):SetEase(CS.DG.Tweening.Ease.InOutQuart)
  self.compBtnCanvasGroup:FadeIn(duration)
  self.btnEntryGoto:SetEnable(true)
end

function UILWSeasonMilitaryEliteEntryComp:AnimDown(duration)
  self.imgEntryIcon.transform:DOMove(self.transMoveStart.transform.position, duration):SetEase(CS.DG.Tweening.Ease.InOutQuart)
  self.compBtnCanvasGroup:FadeOut(duration)
  self.btnEntryGoto:SetEnable(false)
end

function UILWSeasonMilitaryEliteEntryComp:ResetState()
  self.imgEntryIcon:SetAnchoredPosition(Vector2.zero)
  self.btnEntryGoto:SetActive(true)
  self.compBtnCanvasGroup:SetAlpha(0)
  self.btnEntryGoto:SetEnable(false)
end

function UILWSeasonMilitaryEliteEntryComp:HandleActIsOpen()
  if self.Data == nil then
    return false
  end
  if self.Data.RankType == DataCenter.SeasonMilitaryEliteManager.RankType.Person_Kill then
    return true
  elseif self.Data.RankType == DataCenter.SeasonMilitaryEliteManager.RankType.Person_Destroy then
    return true
  elseif self.Data.RankType == DataCenter.SeasonMilitaryEliteManager.RankType.Person_Assistant then
    return true
  elseif self.Data.RankType == DataCenter.SeasonMilitaryEliteManager.RankType.Person_Donate then
    return true
  elseif self.Data.RankType == DataCenter.SeasonMilitaryEliteManager.RankType.Person_Enhance then
    return true
  elseif self.Data.RankType == DataCenter.SeasonMilitaryEliteManager.RankType.Person_Game then
    return true
  end
  return false
end

function UILWSeasonMilitaryEliteEntryComp:HandleActGoto()
  if self.Data == nil or not self.IsOpen then
    return
  end
  if self.Data.RankType > 0 then
    local param = {}
    param.ConfigId = checknumber(self.Data.RankType)
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryEliteScoreTipsView, {anim = true}, param)
  end
end

return UILWSeasonMilitaryEliteEntryComp
