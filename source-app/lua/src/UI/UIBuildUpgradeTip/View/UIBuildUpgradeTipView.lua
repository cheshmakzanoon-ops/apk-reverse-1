local UIBuildUpgradeTipView = BaseClass("UIBuildUpgradeTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local text_path = "Panel/msgItem/doTween/desTxt"
local animator_obj_path = "Panel/msgItem/doTween"

local function OnCreate(self)
  base.OnCreate(self)
  self.des_txt = self:AddComponent(UIText, text_path)
  self.des_txt:SetLocalText(120062)
  self.animator_obj = self:AddComponent(UIBaseContainer, animator_obj_path)
  self.timeDelta = 0
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self:AddTimer()
  DOTween.Rewind(self.animator_obj.gameObject)
  DOTween.Restart(self.animator_obj.gameObject, "UICommonMessageSuc_animation")
end

local function OnDestroy(self)
  self.msg = nil
  self.des_txt = nil
  self.return_btn = nil
  self.timeDelta = nil
  self.timer_action = nil
  self.msgQueue = nil
  self.isPlaying = nil
  self:DeleteTimer()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  self.timeDelta = self.timeDelta + 1
  if self.timeDelta == 1 then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_CombatPowerUp, false)
    local pos = self.animator_obj.gameObject.transform.position
    local data = self:GetUserData()
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(data.buildUid)
    if buildData ~= nil then
      local worldPos = SceneUtils.TileIndexToWorld(buildData.pointId)
      pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    end
    local rewardTyp = RewardType.POWER
    local pic = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_btn_Power.png"
    UIUtil.DoFly(tonumber(rewardTyp), 5, pic, pos, Vector3.New(0, 0, 0))
  elseif self.timeDelta > 2 then
    self:DeleteTimer()
    self.ctrl:CloseSelf()
  end
end

UIBuildUpgradeTipView.OnCreate = OnCreate
UIBuildUpgradeTipView.OnDestroy = OnDestroy
UIBuildUpgradeTipView.OnEnable = OnEnable
UIBuildUpgradeTipView.OnDisable = OnDisable
UIBuildUpgradeTipView.DeleteTimer = DeleteTimer
UIBuildUpgradeTipView.AddTimer = AddTimer
UIBuildUpgradeTipView.RefreshTime = RefreshTime
return UIBuildUpgradeTipView
