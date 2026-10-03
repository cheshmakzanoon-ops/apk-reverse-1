local UIMainSandWormObj = BaseClass("UIMainSandWormObj", UIBaseContainer)
local base = UIBaseContainer
local btn_path = "btn"
local slider_path = "slider"
local u_i_player_head_path = "UIPlayerHead"
local common_t_ips_path = "CommonTIps"
local goto_btn_path = "CommonTIps/bg/gotoBtn"

function UIMainSandWormObj:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainSandWormObj:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainSandWormObj:ComponentDefine()
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.slider = self:AddComponent(UIImage, slider_path)
  self.playerHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.playerHead:SetFrameActive(false)
  self.common_t_ips = self:AddComponent(UIButton, common_t_ips_path)
  self.common_t_ips:SetOnClick(function()
    self:OnClickTip()
  end)
  self.common_t_ips:SetActive(false)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(function()
    self:OnClickGo()
  end)
end

function UIMainSandWormObj:ComponentDestroy()
  self.btn = nil
  self.slider = nil
  self.playerHead = nil
  self.common_t_ips = nil
  self.goto_btn = nil
end

function UIMainSandWormObj:OnClickTip()
  self.common_t_ips:SetActive(false)
end

function UIMainSandWormObj:OnClickGo()
  self.common_t_ips:SetActive(false)
  SeasonUtil.OpenSeasonActivityByType(EnumActivity.SandWormHunt.Type)
end

function UIMainSandWormObj:OnClickBtn()
  local nearestSandWorm = DataCenter.SandWormHuntDataManager:GetNearestSandWorm()
  if nearestSandWorm then
    local serverId = nearestSandWorm.serverId
    local pos = SceneUtils.TileIndexToWorld(nearestSandWorm.pointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(pos, nil, 0, nil, serverId)
  else
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SandWormHunt.Type)
    if actList and actList[1] and actList[1].para_5 then
      UIUtil.CheckEventTrigger(OpMode.ClickBtnMainUISandWorm, nil, nil, tonumber(actList[1].para_5))
      self.common_t_ips:SetActive(not self.common_t_ips:GetActive())
    end
  end
end

function UIMainSandWormObj:Refresh()
  local nearestSandWorm = DataCenter.SandWormHuntDataManager:GetNearestSandWorm()
  if nearestSandWorm then
    self.slider:SetFillAmount(0)
    local meta = DataCenter.MonsterTemplateManager:GetMonsterTemplate(nearestSandWorm.monsterId)
    if not meta then
      return
    end
    self.playerHead:SetHead(nil, meta:GetSmallIcon())
  else
    local fillAmount = DataCenter.SandWormHuntDataManager:GetFillAmount()
    self.slider:SetFillAmount(fillAmount)
    self.playerHead:SetHead(nil, "Assets/Main/SeasonRes/S3/Sprites/Sandworm/mjc_S3_sc_zhujiemian_weizhishachong.png")
  end
end

return UIMainSandWormObj
