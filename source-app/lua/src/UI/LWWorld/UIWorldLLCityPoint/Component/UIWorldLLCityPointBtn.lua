local UIWorldLLCityPointBtn = BaseClass("UIWorldLLCityPointBtn", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local btn_image_path = "BtnImage"
local effect_path = "effect"

function UIWorldLLCityPointBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWorldLLCityPointBtn:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIWorldLLCityPointBtn:OnEnable()
  base.OnEnable(self)
end

function UIWorldLLCityPointBtn:OnDisable()
  base.OnDisable(self)
end

function UIWorldLLCityPointBtn:ComponentDefine()
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

function UIWorldLLCityPointBtn:ComponentDestroy()
  self.btn = nil
  self.btnImage = nil
  self.time_obj = nil
  self.anim = nil
end

function UIWorldLLCityPointBtn:DataDefine()
  self.param = nil
end

function UIWorldLLCityPointBtn:DataDestroy()
  self.param = nil
end

function UIWorldLLCityPointBtn:ReInit(param)
  self.param = param
  self.btnImage:LoadSprite(LoadPath.GetBuildBtnSpritePath(param.btnType))
  self.btnImage.transform.localPosition = param.position
end

function UIWorldLLCityPointBtn:OnBtnClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("300707")
    return
  end
  local city_type = self.param.info.type
  local uuid = self.param.info.uuid
  local serverId = self.param.info.serverId
  local pointId = self.param.info.pointId
  local inProtectMode = self.param.info.inProtectMode
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
  elseif loginServerId == serverId then
    if inProtectMode then
      UIUtil.ShowTipsId("camp_battle_tip012")
    elseif btnType == WorldPointBtnType.LLAssistanceCity then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_ZWL_BUILDING, pointId, uuid, -1, 1)
    elseif btnType == WorldPointBtnType.LLAttackCity then
      MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ZWL_BUILDING, pointId, uuid, -1, 1)
    elseif btnType == WorldPointBtnType.LLRallyCity then
      MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_ZWL_BUILDING, pointId, uuid, -1, 1)
    elseif btnType == WorldPointBtnType.LLScoutCity then
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_ZWL_BUILDING, pointId, uuid)
    end
  else
    UIUtil.ShowTipsId("season_tips143")
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldLLCityPoint)
end

function UIWorldLLCityPointBtn:PlayAnim(name)
  if self.anim then
    self.anim:Play(name, 0, 0)
  end
end

function UIWorldLLCityPointBtn:CanCrossInteraction()
  return self.param.info and SeasonUtil.CanCrossInteraction(self.param.info.serverId, true, true)
end

return UIWorldLLCityPointBtn
