local LWUITrailTowerDifficultyGroupItemRender = BaseClass("LWUITrailTowerDifficultyGroupItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = "Btn"
local finishImage_path = "Btn/RectMask/FinishState"
local finishGroupText_path = "Btn/RectMask/FinishState/FinishGroupText"
local curImage_path = "Btn/RectMask/CurState"
local curGroupText_path = "Btn/RectMask/CurState/CurGroupText"
local noFinishImage_path = "Btn/RectMask/NoFinishState"
local noFinishGroupText_path = "Btn/RectMask/NoFinishState/NoFinishGroupText"
local curGroupFinishMark_path = "Btn/RectMask/CurState/CurGroupFinishMark"
local curGroupNewMark_path = "Btn/RectMask/CurState/CurGroupNewMark"
local ani_path = "Btn/RectMask/CurState/CurGroupNewMark/Go"
local lockImage_path = "Btn/RectMask/NoFinishState/LockImage"
local rect_mask_path = "Btn/RectMask"

function LWUITrailTowerDifficultyGroupItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUITrailTowerDifficultyGroupItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerDifficultyGroupItemRender:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
  self.finishImage = self:AddComponent(UIImage, finishImage_path)
  self.finishGroupText = self:AddComponent(UIText, finishGroupText_path)
  self.curImage = self:AddComponent(UIImage, curImage_path)
  self.curGroupText = self:AddComponent(UIText, curGroupText_path)
  self.noFinishImage = self:AddComponent(UIImage, noFinishImage_path)
  self.noFinishGroupText = self:AddComponent(UIText, noFinishGroupText_path)
  self.curGroupFinishMark = self:AddComponent(UIImage, curGroupFinishMark_path)
  self.curGroupNewMark = self:AddComponent(UIBaseContainer, curGroupNewMark_path)
  self.ani = self.transform:Find(ani_path):GetComponent(typeof(CS.SimpleAnimation))
  self.lockImage = self:AddComponent(UIImage, lockImage_path)
  self.rect_mask = self:AddComponent(UIBaseContainer, rect_mask_path)
end

function LWUITrailTowerDifficultyGroupItemRender:ComponentDestroy()
  self.btn = nil
  self.finishImage = nil
  self.finishGroupText = nil
  self.curImage = nil
  self.curGroupText = nil
  self.noFinishImage = nil
  self.noFinishGroupText = nil
  self.curGroupFinishMark = nil
  self.curGroupNewMark = nil
  self.ani = nil
  self.lockImage = nil
  self.rect_mask = nil
end

function LWUITrailTowerDifficultyGroupItemRender:OnAddListener()
  self:AddUIListener(EventId.ChangeTrailTowerDiffGroupSelect, self.ChangeTrailTowerDiffGroupSelect)
  self:AddUIListener(EventId.RefreshTrailTowerDifficultyGroupNewMark, self.RefreshNewState)
  base.OnAddListener(self)
end

function LWUITrailTowerDifficultyGroupItemRender:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeTrailTowerDiffGroupSelect, self.ChangeTrailTowerDiffGroupSelect)
  self:RemoveUIListener(EventId.RefreshTrailTowerDifficultyGroupNewMark, self.RefreshNewState)
  base.OnRemoveListener(self)
end

function LWUITrailTowerDifficultyGroupItemRender:SetData(trailTowerId, groupId, passGroupId, curSelectGroupId)
  self.trailTowerId = trailTowerId
  self.groupId = groupId
  self.passGroupId = passGroupId
  self.finishGroupText:SetText(groupId)
  self.curGroupText:SetText(groupId)
  self.noFinishGroupText:SetText(groupId)
  self.targetShowImage = nil
  local finish = self.passGroupId >= self.groupId
  local trailTowerInfo = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(self.trailTowerId)
  local cur = self.groupId == trailTowerInfo:GetCurCanDoDifficultyGroup()
  self.lock = not finish and not cur
  if cur then
    self.curImage:SetActive(true)
    self.finishImage:SetActive(false)
    self.noFinishImage:SetActive(false)
    self.targetShowImage = self.curImage
    self.curGroupFinishMark:SetActive(self.passGroupId >= self.groupId)
    self:RefreshNewState()
  else
    self.curImage:SetActive(false)
    self.finishImage:SetActive(finish)
    self.noFinishImage:SetActive(self.lock)
    if finish then
      self.targetShowImage = self.finishImage
    else
      self.targetShowImage = self.noFinishImage
      if not trailTowerInfo.isFinish or trailTowerInfo:IsAchieveChallengesTimesLimit() then
        self.lockImage:SetActive(true)
      else
        self.lockImage:SetActive(self.groupId ~= self.passGroupId + 1)
      end
    end
  end
  self:RefreshSelectState(curSelectGroupId)
end

function LWUITrailTowerDifficultyGroupItemRender:ChangeTrailTowerDiffGroupSelect(param)
  self:RefreshSelectState(param.groupId)
end

function LWUITrailTowerDifficultyGroupItemRender:RefreshSelectState(selectGroupId)
  local selected = self.groupId == selectGroupId
  if selected then
    self.targetShowImage:SetLocalScaleXYZ(1, 1, 1)
    self.rect_mask:SetSizeDeltaY(163)
  else
    self.targetShowImage:SetLocalScaleXYZ(0.88, 0.88, 0.88)
    self.rect_mask:SetSizeDeltaY(132)
  end
end

function LWUITrailTowerDifficultyGroupItemRender:RefreshNewState()
  local trailTowerInfo = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(self.trailTowerId)
  local cur = self.groupId == trailTowerInfo:GetCurCanDoDifficultyGroup()
  if cur then
    local isNew = DataCenter.LWTrailTowerManager:IsDifficultyGroupChange(self.trailTowerId)
    self.curGroupNewMark:SetActive(isNew)
    if isNew then
      self.ani:Play("NormalBubble")
    end
  end
end

function LWUITrailTowerDifficultyGroupItemRender:BtnClick()
  local param = {}
  param.groupId = self.groupId
  param.lock = self.lock
  EventManager:GetInstance():Broadcast(EventId.ChangeTrailTowerDiffGroupSelect, param)
end

return LWUITrailTowerDifficultyGroupItemRender
