local FormationScoutSelectItemV2 = BaseClass("FormationScoutSelectItemV2", UIBaseContainer)
local base = UIBaseContainer
local locked_node_path = "lockObj"
local locked_tip_path = "lockObj/unlockLv"
local unlocked_node_path = "unLockObj"
local unlocked_selected_path = "unLockObj/selectImg"
local unlocked_state_icon = "unLockObj/marchObj/stateIcon"
local unlocked_select_btn = "unLockObj/marchObj"
local scoutIndexNum_path = "nameNum"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.LockedNode = self:AddComponent(UIBaseContainer, locked_node_path)
  self.LockedTipNum = self:AddComponent(UIText, locked_tip_path)
  self.LockedBtn = self:AddComponent(UIButton, locked_node_path)
  self.LockedBtn:SetOnClick(function()
    self:OnClickLockBtn()
  end)
  self.UnlockedNode = self:AddComponent(UIBaseContainer, unlocked_node_path)
  self.UnlockedSelected = self:AddComponent(UIBaseContainer, unlocked_selected_path)
  self.UnlockedStateIcon = self:AddComponent(UIImage, unlocked_state_icon)
  self.UnlockedSelectBtn = self:AddComponent(UIButton, unlocked_select_btn)
  self.UnlockedSelectBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSelectBtnClick()
  end)
  self.scoutIndexNum = self:AddComponent(UIText, scoutIndexNum_path)
end

local function ComponentDestroy(self)
  self.LockedNode = nil
  self.LockedTipNum = nil
  self.UnlockedNode = nil
  self.UnlockedSelected = nil
  self.UnlockedStateIcon = nil
  self.UnlockedSelectBtn = nil
end

local function DataDefine(self)
  self.formationIndex = nil
end

local function DataDestroy(self)
  self.formationIndex = nil
end

local function RefreshUI(self, formationIndex)
  self.formationIndex = formationIndex
  self.scoutIndexNum:SetText(formationIndex)
  local unlockCount = DataCenter.ArmyFormationDataManager:GetMaxInvesFormationCount()
  local formationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(formationIndex)
  if formationIndex > unlockCount then
    self.UnlockedNode:SetActive(false)
    self.LockedNode:SetActive(true)
    self.LockedTipNum:SetText("")
  else
    self.UnlockedNode:SetActive(true)
    self.LockedNode:SetActive(false)
    if formationInfo.MarchInfo == nil then
      self:SetMarchState(MarchStatus.STATION, MarchTargetType.STATE)
    else
      self:SetMarchState(formationInfo.MarchInfo:GetMarchStatus(), formationInfo.MarchInfo:GetMarchTargetType())
    end
  end
end

local function SetMarchState(self, status, target)
  if status == MarchStatus.STATION then
    self.UnlockedStateIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_waiting")
  elseif target == MarchTargetType.BACK_HOME then
    self.UnlockedStateIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_return")
  else
    self.UnlockedStateIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_march_scout")
  end
end

local function SetSelected(self, isSelected)
  self.UnlockedSelected:SetActive(isSelected)
  if isSelected then
    local posX = self.UnlockedSelectBtn.transform.position.x
    local posY = self.UnlockedSelectBtn.transform.position.y
    self.view:ResetScoutSelectTipPosition(posX, posY)
  end
end

local function OnSelectBtnClick(self)
  self:SetSelected(true)
  self.view:OnClickScoutTroopItem(self.formationIndex)
  if not self.view.ctrl.targetPoint or self.view.ctrl.targetPoint <= 0 then
    local formationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(self.formationIndex)
    if formationInfo.MarchInfo == nil then
      local pos = LuaEntry.Player:GetMainWorldPos()
      GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(pos))
      local position = SceneUtils.TileIndexToWorld(pos) + Vector3.New(-1, 0, -1)
      WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
    else
      CS.SceneManager.World:TrackMarch(formationInfo.MarchInfo.uuid)
      WorldMarchTileUIManager:GetInstance():ShowTroop(formationInfo.MarchInfo.uuid)
    end
  end
end

local function OnClickLockBtn(self)
  UIUtil.ShowTipsId(110208)
end

FormationScoutSelectItemV2.OnCreate = OnCreate
FormationScoutSelectItemV2.OnDestroy = OnDestroy
FormationScoutSelectItemV2.OnEnable = OnEnable
FormationScoutSelectItemV2.OnDisable = OnDisable
FormationScoutSelectItemV2.ComponentDefine = ComponentDefine
FormationScoutSelectItemV2.ComponentDestroy = ComponentDestroy
FormationScoutSelectItemV2.DataDefine = DataDefine
FormationScoutSelectItemV2.DataDestroy = DataDestroy
FormationScoutSelectItemV2.RefreshUI = RefreshUI
FormationScoutSelectItemV2.SetSelected = SetSelected
FormationScoutSelectItemV2.OnSelectBtnClick = OnSelectBtnClick
FormationScoutSelectItemV2.SetMarchState = SetMarchState
FormationScoutSelectItemV2.OnClickLockBtn = OnClickLockBtn
return FormationScoutSelectItemV2
