local UIWorldOutpostCanonPointBtn = BaseClass("UIWorldOutpostCanonPointBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local btn_image_path = "BtnImage"
local effect_path = "effect"

function UIWorldOutpostCanonPointBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldOutpostCanonPointBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCanonPointBtn:OnEnable()
  base.OnEnable(self)
end

function UIWorldOutpostCanonPointBtn:OnDisable()
  base.OnDisable(self)
end

function UIWorldOutpostCanonPointBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_image_path)
  self.btnImage = self:AddComponent(UIImage, btn_image_path)
  self.anim = self:TryAddComponent(UIAnimator, this_path)
  if self.anim then
    self.anim:Enable(false)
  end
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.effect:SetActive(false)
end

function UIWorldOutpostCanonPointBtn:ComponentDestroy()
  self.btn = nil
  self.btnImage = nil
  self.time_obj = nil
  self.anim = nil
end

function UIWorldOutpostCanonPointBtn:DataDefine()
  self.param = nil
end

function UIWorldOutpostCanonPointBtn:DataDestroy()
  self.param = nil
end

function UIWorldOutpostCanonPointBtn:ReInit(param)
  self.param = param
  self.btnImage:LoadSpriteAuto(LoadPath.GetBuildBtnSpritePath(param.btnType))
  self.btnImage.transform.localPosition = param.position
end

function UIWorldOutpostCanonPointBtn:OnBtnClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("300707")
    return
  end
  local city_type = self.param.info.type
  local uuid = self.param.info.uuid
  local serverId = self.param.info.serverId
  local pointId = self.param.info.pointId
  local btnType = self.param.btnType
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if btnType == WorldPointBtnType.CallBack then
    if not self:CanCrossInteraction() then
      return
    end
    local assistanceCount = CS.SceneManager.World:GetMyAssistanceCount(pointId)
    if 0 < assistanceCount then
      local _uuid = DataCenter.WorldMarchDataProxy:GetFirstMyAssistanceMarchUuid(pointId)
      if _uuid ~= 0 then
        MarchUtil.OnBackHome(_uuid)
      end
    end
  elseif btnType == WorldPointBtnType.CrossZoneOutpostFix then
    MarchUtil.OnClickStartMarch(MarchTargetType.REPAIR_OUTPOST, pointId, uuid, -1, 1)
  elseif loginServerId == serverId then
    if btnType == WorldPointBtnType.CrossZoneOutpostAssistance then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_OUTPOST_BUILDING, pointId, uuid, -1, 0)
    elseif btnType == WorldPointBtnType.CrossZoneOutpostAttack then
      MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_OUTPOST_BUILDING, pointId, uuid, -1, 1)
    elseif btnType == WorldPointBtnType.CrossZoneOutpostRally then
      MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_OUTPOST_BUILDING, pointId, uuid, -1, 1)
    elseif btnType == WorldPointBtnType.CrossZoneOutpostScout then
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_OUTPOST_BUILDING, pointId, uuid)
    end
  else
    UIUtil.ShowTipsId("season_tips143")
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldOutpostCanonPoint)
end

function UIWorldOutpostCanonPointBtn:PlayAnim(name)
  if self.anim then
    self.anim:Play(name, 0, 0)
  end
end

function UIWorldOutpostCanonPointBtn:CanCrossInteraction()
  return self.param.info and SeasonUtil.CanCrossInteraction(self.param.info.serverId, true, true)
end

return UIWorldOutpostCanonPointBtn
