local base = UIBaseContainer
local EnterDsbDuelBattle = BaseClass("EnterDsbDuelBattle", base)
local Localization = CS.GameEntry.Localization
local EnterDsbDuelBattleTeam = require("UI.DsbDuelBattlefield.Misc.EnterDsbDuelBattleTeam")

function EnterDsbDuelBattle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function EnterDsbDuelBattle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EnterDsbDuelBattle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compRect = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.btnUnfold = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnUnfold:SetOnClick(function()
    self:OnBtnUnfoldClick()
  end)
  self.textTmpFoldName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpBtnFoldGo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnLWCommonNew = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnLWCommonNew:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  self.compTeam1 = self.viewSkin:AddComponent(self, EnterDsbDuelBattleTeam, 8)
  self.compTeam2 = self.viewSkin:AddComponent(self, EnterDsbDuelBattleTeam, 9)
  self.compTeam3 = self.viewSkin:AddComponent(self, EnterDsbDuelBattleTeam, 10)
  self.compTeam4 = self.viewSkin:AddComponent(self, EnterDsbDuelBattleTeam, 11)
  self.compTeams = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.imgBtnUnfold = self.viewSkin:AddComponent(self, UIImage, 13)
  self.btnRect = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnRect:SetOnClick(function()
    self:OnBtnRectClick()
  end)
  self.comps = {
    self.compTeam1,
    self.compTeam2,
    self.compTeam3,
    self.compTeam4
  }
  self.textTmpFoldName:SetLocalText("dsb_duel_activitiy_name_1001")
  self.textTmpBtnFoldGo:SetLocalText("110003")
  self:OnBtnUnfoldClick()
  self:RefreshTime()
end

function EnterDsbDuelBattle:ComponentDestroy()
  self.viewSkin = nil
  self.compRoot = nil
  self.compRect = nil
  self.btnUnfold = nil
  self.textTmpFoldName = nil
  self.textTmpTime = nil
  self.textTmpBtnFoldGo = nil
  self.btnLWCommonNew = nil
  self.compTeam1 = nil
  self.compTeam2 = nil
  self.compTeam3 = nil
  self.compTeam4 = nil
  self.compTeams = nil
  self.imgBtnUnfold = nil
  self.btnRect = nil
end

function EnterDsbDuelBattle:DataDefine()
end

function EnterDsbDuelBattle:DataDestroy()
end

function EnterDsbDuelBattle:IsSmallShow()
  return self.isFold
end

function EnterDsbDuelBattle:Refresh()
  self:RefreshAllTeam()
end

function EnterDsbDuelBattle:SetFoldState(fold)
  if self.isFold == fold then
    return
  end
  self.isFold = fold
  local sp = fold and "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_zhushouwanfa_shouqi.png" or "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png"
  self.imgBtnUnfold:LoadSpriteAsync(sp)
  local size = fold and {420, 130} or {605, 285}
  self.compRect:SetSizeDeltaXY(size[1], size[2])
  self.compTeams:SetActive(not self.isFold)
end

function EnterDsbDuelBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActBattleInfoUpdate, self.OnDsbDuelActBattleInfoUpdate)
end

function EnterDsbDuelBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActBattleInfoUpdate, self.OnDsbDuelActBattleInfoUpdate)
  base.OnRemoveListener(self)
end

function EnterDsbDuelBattle:OnDsbDuelActBattleInfoUpdate()
  self:RefreshAllTeam()
end

function EnterDsbDuelBattle:OnBtnUnfoldClick()
  if self.isFold == nil then
    self:SetFoldState(true)
  else
    self:SetFoldState(not self.isFold)
    if not self.isFold then
      self:RefreshAllTeam()
    end
  end
end

function EnterDsbDuelBattle:RefreshAllTeam()
  if self.isFold then
    return
  end
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  if not actInfo then
    self.compRoot:SetActive(false)
    return
  end
  self.compRoot:SetActive(true)
  local list = actInfo:GetTeamBattleAllianceInfo(actInfo:GetSelfTeam())
  if list and table.count(list) > 0 then
    for i = BattlefieldDsbConst.RoleType.MIN, BattlefieldDsbConst.RoleType.MAX do
      local info = list[i]
      local comp = self.comps[i]
      if not info then
        comp:SetActive(false)
      else
        comp:Refresh(i, info)
        comp:SetActive(true)
      end
    end
  else
    self:SetFoldState(true)
  end
end

function EnterDsbDuelBattle:RefreshTime()
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  if not actInfo then
    self.textTmpTime:SetText("")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local battleStartTime, battleEndTime = actInfo:GetBattleTime()
  local gap
  if curTime < battleStartTime then
    gap = battleStartTime - curTime
  elseif curTime < battleEndTime then
    gap = battleEndTime - curTime
  else
    self.textTmpTime:SetText("")
    return
  end
  self.textTmpTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(gap))
end

function EnterDsbDuelBattle:Update1000MS()
  self:RefreshTime()
end

function EnterDsbDuelBattle:OnBtnLWCommonNewClick()
  DataCenter.BattlefieldDsbDuelManager:TryEnterBattlefield()
end

function EnterDsbDuelBattle:OnBtnRectClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX.EditBattle)
end

return EnterDsbDuelBattle
