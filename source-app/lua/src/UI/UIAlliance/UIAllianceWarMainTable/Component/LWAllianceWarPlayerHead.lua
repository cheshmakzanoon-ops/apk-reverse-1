local LWAllianceWarPlayerHead = BaseClass("LWAllianceWarPlayerHead", UIBaseContainer)
local base = UIBaseContainer
local join_btn_path = "joinBtn"
local head_icon_path = "UIPlayerHead"
local self_flag = "selfFlag"

function LWAllianceWarPlayerHead:OnCreate()
  base.OnCreate(self)
  self.head_icon = self:AddComponent(UICommonHead, head_icon_path)
  self.head_icon:SetEnableClickShowInfo(true, true)
  self.head_icon:SetActive(false)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.self_flag_obj = self:AddComponent(UIBaseContainer, self_flag)
end

function LWAllianceWarPlayerHead:OnDestroy()
  self.join_btn = nil
  self.head_icon = nil
  self.self_flag_obj = nil
  base.OnDestroy(self)
end

function LWAllianceWarPlayerHead:OnEnable()
  base.OnEnable(self)
  self.rallyMonsterId = nil
end

function LWAllianceWarPlayerHead:OnDisable()
  self.rallyMonsterId = nil
  base.OnDisable(self)
end

function LWAllianceWarPlayerHead:OnBtnClick()
  if self.head_icon:GetActive() then
    return
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local isBigMapMode, _, _, loginSameGroup = SeasonUtil.InSeasonBigMapMode(self.serverId)
  if isBigMapMode and loginSameGroup and loginServerId == self.serverId then
  elseif CrossServerUtil:NeedIntercept("world_tip10005", self.serverId, true) then
    return
  end
  local canJoin, _, inTeam, state = self:CheckCanJoin()
  if canJoin then
    if self.rallyMonsterId and self.holder.TryJoinAllianceRallyWar and LuaEntry.DataConfig:CheckSwitch("alliance_rallyNoRewardTips_swich") then
      self.holder:TryJoinAllianceRallyWar()
    else
      self.view.ctrl:OnJoinClick(self.uuid, self.monsterSpecialType)
    end
  elseif inTeam then
    UIUtil.ShowTipsId(120226)
  elseif self.idx == 4 then
    Logger.LogWarning("[LWAllianceWarPlayerHead] OnBtnClick error! not canJoin and not inTeam, state=", state)
  end
end

function LWAllianceWarPlayerHead:CheckCanJoin()
  return DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(self.uuid)
end

function LWAllianceWarPlayerHead:RefreshData(data_info, serverId, uuid, monsterSpecialType, fixedSoldierType, idx)
  self.dataInfo = data_info
  self.serverId = serverId
  self.monsterSpecialType = monsterSpecialType
  self.uuid = uuid
  self.idx = idx
  if self.dataInfo then
    if fixedSoldierType == SoldierType.Mummy then
      self.head_icon:ShowMummyIcon()
    else
      self.head_icon:SetData(self.dataInfo.ownerUid, self.dataInfo.ownerIcon, self.dataInfo.ownerIconVer, nil, self.dataInfo.headBg)
    end
    self.head_icon:SetActive(true)
    self.self_flag_obj:SetActive(LuaEntry.Player.uid == self.dataInfo.ownerUid)
  else
    self.self_flag_obj:SetActive(false)
  end
end

function LWAllianceWarPlayerHead:SetJoinActive(active)
  self.join_btn:SetActive(active)
  if active then
    self.head_icon:SetActive(false)
  end
end

function LWAllianceWarPlayerHead:SetEmpty()
  self.head_icon:SetActive(false)
  self.join_btn:SetActive(false)
end

function LWAllianceWarPlayerHead:RefreshTimeoutState()
  local canJoin = self:CheckCanJoin()
  self:SetJoinActive(canJoin)
end

function LWAllianceWarPlayerHead:SetRallyMonsterId(rallyMonsterId)
  self.rallyMonsterId = rallyMonsterId
end

return LWAllianceWarPlayerHead
