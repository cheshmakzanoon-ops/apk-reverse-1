local base = UIAsyncContainer
local SignArbiterSkill = BaseClass("SignArbiterSkill", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local RED_IMG = "mjc_yibianjunqu_zhanshenbianshen_difang_bg.png"
local BLUE_IMG = "mjc_yibianjunqu_zhanshenbianshen_jifang_bg.png"

function SignArbiterSkill:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SignArbiterSkill:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SignArbiterSkill:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.arbiter_anim = self.viewSkin:AddComponent(self, UIAnimator, 1)
  self.arbiter_player = self.viewSkin:AddComponent(self, UICommonHead, 2)
  self.arbiter_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.arbiter_skill = self.viewSkin:AddComponent(self, UIImage, 4)
end

function SignArbiterSkill:ComponentDestroy()
  self.viewSkin = nil
  self.arbiter_anim = nil
  self.arbiter_player = nil
  self.arbiter_text = nil
  self.arbiter_skill = nil
end

function SignArbiterSkill:DataDefine()
  self.arbiter_player:SetEnableClickShowInfo(true, true)
end

function SignArbiterSkill:DataDestroy()
  self.uid = nil
end

function SignArbiterSkill:OnAddListener()
  base.OnAddListener(self)
end

function SignArbiterSkill:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SignArbiterSkill:UpdateData()
  if self.uid == nil then
    return
  end
  local ActMgr = DataCenter.ActEpidemicZoneManager
  local battleInfo = ActMgr:GetBattleInfo()
  local alId, info = battleInfo:GetAlMemberByPlayerUid(self.uid)
  if info == nil then
    return
  end
  local bEnemy = ActMgr:GetWorldCampInEpidemic(alId) == WorldCamp.Enemy
  local path = bEnemy and RED_IMG or BLUE_IMG
  self.arbiter_skill:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldCommanderPath, path))
  self.arbiter_player:SetHeadAndFrame(info.uid, info.pic, info.picVer, false, info.headSkinId, info.headSkinET)
  self.arbiter_text:SetLocalText("YiBianJinQu_trivial_tips_32", info.name)
end

function SignArbiterSkill:SetInfo(uid)
  self.uid = uid
  self:RefreshView()
end

return SignArbiterSkill
