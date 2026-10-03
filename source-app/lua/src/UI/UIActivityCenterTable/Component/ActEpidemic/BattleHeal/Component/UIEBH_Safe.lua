local base = UIBaseContainer
local UIEBH_Safe = BaseClass("UIEBH_Safe", base)
local s_icon_path = "SIcon"
local speed_text_path = "SIcon/SpeedText"
local p_second_text_path = "SIcon/PSecond"
local btn_path = "Btn"

function UIEBH_Safe:OnCreate()
  base.OnCreate(self)
  self.s_icon = self:AddComponent(UIImage, s_icon_path)
  local soldierData = DataCenter.SoldierDataManager:GetDragonSoldierInfo()
  local soldierId = soldierData ~= nil and soldierData.id or nil
  local iconPath
  if soldierId then
    local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
    iconPath = soldierTemplate.icon
  end
  self.s_icon:LoadSpriteAuto(string.format(LoadPath.ItemPath, iconPath or "soldier_10"))
  self.speed_text = self:AddComponent(UITextMeshProUGUIEx, speed_text_path)
  local speed = LuaEntry.DataConfig:TryGetNum("YiBianJinQu_battle", "k9", 0)
  self.speed_text:SetText(string.format("+%s/s", speed))
  self.p_second_text = self:AddComponent(UITextMeshProUGUIEx, p_second_text_path)
  self.p_second_text:SetText("/s")
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickBtn))
end

function UIEBH_Safe:OnDestroy()
  self.s_icon = nil
  self.speed_text = nil
  self.p_second_text = nil
  self.btn = nil
  base.OnDestroy(self)
end

function UIEBH_Safe:UpdateData()
end

function UIEBH_Safe:OnClickBtn()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local x, y = BattleFieldUtil.GetNearSafePoint(LuaEntry.Player:GetBattleFieldPos(), BattleFieldType.EpidemicZone)
  if x and y then
    local willPos = SceneUtils.TileToWorld({x = x, y = y})
    self.view.ctrl:CloseSelf()
    GoToUtil.GotoDragonPos(willPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId(), LuaEntry.Player:GetCurWorldType())
  end
end

return UIEBH_Safe
