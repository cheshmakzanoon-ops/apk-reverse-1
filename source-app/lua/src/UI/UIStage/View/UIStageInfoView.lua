local UIStageInfoView = BaseClass("UIStageInfoView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.host = nil
  self.rewardTitle = self:AddComponent(UIText, "Content/Bg/RewardTitle")
  self.desc = self:AddComponent(UIText, "Content/Bg/Desc")
  self.mosterTitle = self:AddComponent(UIText, "Content/Bg/MosterTitle")
  self.nameText = self:AddComponent(UIText, "Content/Bg/NameText")
  self.enterBtn = self:AddComponent(UIButton, "Content/Bg/EnterBtn")
  self.enterBtnText = self:AddComponent(UIText, "Content/Bg/EnterBtn/EnterBtnText")
  self.enterBtn:SetOnClick(function()
    self:OnEnterClick()
  end)
  self.content = self:AddComponent(UIBaseContainer, "Content")
  self.arrowContent = self:AddComponent(UIBaseContainer, "ArrowContent")
  self.hideMask = self:AddComponent(UIButton, "HideMask")
  self.hideMask:SetOnClick(function()
    self:SetActive(false)
  end)
  self.enterBtnText:SetText(Localization:GetString("110003"))
  self.rewardTitle:SetText(Localization:GetString("390832"))
end

local function OnDestroy(self)
  self.rewardTitle = nil
  self.desc = nil
  self.mosterTitle = nil
  self.nameText = nil
  self.enterBtn = nil
  self.enterBtnText = nil
  self.enterBtn = nil
  base.OnDestroy(self)
end

local function RefreshData(self, cell)
  local cellPos = cell.transform.localPosition
  self.content.transform.localPosition = Vector3.New(Mathf.Clamp(cellPos.x, -170, 170), cellPos.y, cellPos.z)
  self.arrowContent.transform.position = cell.transform.position
  self.nameText:SetText(Localization:GetString(cell.stageGroupMeta.name))
  self.desc:SetText(Localization:GetString(cell.stageGroupMeta.desc))
  self.mosterTitle:SetText(Localization:GetString("800300") .. cell.stageGroupMeta.stage_level)
  self.stageGroupMeta = cell.stageGroupMeta
end

local function OnEnterClick(self)
  local levelId = 0
  local curChapter = self.host.ctrl:GetCurrentChapterId()
  local curStageGroup = self.host.ctrl:GetCurrentStageGroupId()
  local spl = self.stageGroupMeta.stageGroup
  if spl == nil then
    spl = string.split(self.stageGroupMeta.stage_group, "|")
    self.stageGroupMeta.stageGroup = spl
  end
  if curChapter > self.stageGroupMeta.chapter_group then
    levelId = tonumber(spl[#spl])
  elseif self.stageGroupMeta.chapter_group == curChapter then
    if curStageGroup == self.stageGroupMeta.id then
      levelId = self.host.ctrl:GetCurrentStageId()
    elseif curStageGroup > self.stageGroupMeta.id then
      levelId = tonumber(spl[#spl])
    end
  end
  if 0 < levelId then
    local param = {}
    param.levelId = levelId
    if not DataCenter.ZombieBattleManager.gameOver and not DataCenter.ZombieBattleManager.gamePause then
      DataCenter.ZombieBattleManager:OnBattleLose()
    end
    DataCenter.ZombieBattleManager:Destroy()
    PveUtil.TryEnterBattle(self.stageGroupMeta.id, levelId)
  end
end

local function SetActive(self, active)
  self.gameObject:SetActive(active)
end

UIStageInfoView.OnCreate = OnCreate
UIStageInfoView.OnDestroy = OnDestroy
UIStageInfoView.RefreshData = RefreshData
UIStageInfoView.OnEnterClick = OnEnterClick
UIStageInfoView.SetActive = SetActive
return UIStageInfoView
