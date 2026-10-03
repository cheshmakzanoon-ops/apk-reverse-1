local UIActEpidemicBattleHistoryItem = BaseClass("UIActEpidemicBattleHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.mvp = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compObjWinLeft = self:AddComponent(UIBaseContainer, "ObjWinLeft")
  self.compObjWinRight = self:AddComponent(UIBaseContainer, "ObjWinRight")
  self.textTmpTime = self:AddComponent(UITextMeshProUGUIEx, "TmpTime")
  self.imgAllianceFlag22 = self:AddComponent(UIImage, "Farm/ImgAllianceFlag_22")
  self.imgAllianceFlag21 = self:AddComponent(UIImage, "Farm/ImgAllianceFlag_21")
  self.imgAllianceFlag1 = self:AddComponent(UIImage, "Lord/ImgAllianceFlag_1")
  self.textTmpServer1 = self:AddComponent(UITextMeshProUGUIEx, "Lord/TmpServer_1")
  self.textTmpServer21 = self:AddComponent(UITextMeshProUGUIEx, "Farm/TmpServer_21")
  self.textTmpServer22 = self:AddComponent(UITextMeshProUGUIEx, "Farm/TmpServer_22")
  self.textTmpAlliance1 = self:AddComponent(UITextMeshProUGUIEx, "Lord/TmpAlliance_1")
  self.textTmpAlliance21 = self:AddComponent(UITextMeshProUGUIEx, "Farm/TmpAlliance_21")
  self.textTmpAlliance22 = self:AddComponent(UITextMeshProUGUIEx, "Farm/TmpAlliance_22")
  self.textTmpScoreRole1 = self:AddComponent(UITextMeshProUGUIEx, "Lord/TmpScoreRole_1")
  self.textTmpScoreRole2 = self:AddComponent(UITextMeshProUGUIEx, "Farm/TmpScoreRole_2")
  self.textTmpMemberRole1 = self:AddComponent(UITextMeshProUGUIEx, "Lord/TmpMemberRole_1")
  self.textTmpMemberRole2 = self:AddComponent(UITextMeshProUGUIEx, "Farm/TmpMemberRole_2")
  self.textTmpOurMvp = self:AddComponent(UITextMeshProUGUIEx, "TmpOurMvp")
  self.textTmpMvpName = self:AddComponent(UITextMeshProUGUIEx, "TmpMvpName")
  self.compHeadIcon = self:AddComponent(UIPlayerHead, "MvpDogHead/HeadIcon")
  self.btnLoveDog = self:AddComponent(UIButton, "BtnLoveDog")
  self.btnLoveDog:SetOnClick(function()
    self:OnBtnLoveDogClick()
  end)
  self.imgSelfTeam1 = self:AddComponent(UIImage, "Lord/ImgSelfTeam_1")
  self.imgSelfTeam21 = self:AddComponent(UIImage, "Farm/ImgSelfTeam_21")
  self.imgSelfTeam22 = self:AddComponent(UIImage, "Farm/ImgSelfTeam_22")
  self.compLord = self:AddComponent(UIBaseContainer, "Lord")
  self.compFarm = self:AddComponent(UIBaseContainer, "Farm")
  self.btnMvpDogHead = self:AddComponent(UIButton, "MvpDogHead")
  self.btnMvpDogHead:SetOnClick(function()
    self:OnBtnMvpDogHeadClick()
  end)
  self.rendersSides = {}
  self.rendersSides[EpidemicBattleSide.Lord] = {
    flag = self.imgAllianceFlag1,
    server = self.textTmpServer1,
    alName = self.textTmpAlliance1,
    tag = self.imgSelfTeam1
  }
  self.rendersSides[EpidemicBattleSide.FarmerL] = {
    flag = self.imgAllianceFlag21,
    server = self.textTmpServer21,
    alName = self.textTmpAlliance21,
    tag = self.imgSelfTeam21
  }
  self.rendersSides[EpidemicBattleSide.FarmerR] = {
    flag = self.imgAllianceFlag22,
    server = self.textTmpServer22,
    alName = self.textTmpAlliance22,
    tag = self.imgSelfTeam22
  }
  self.renderRoles = {}
  self.renderRoles[EpidemicZoneRole.Lord] = {
    member = self.textTmpMemberRole1,
    score = self.textTmpScoreRole1
  }
  self.renderRoles[EpidemicZoneRole.Farmer] = {
    member = self.textTmpMemberRole2,
    score = self.textTmpScoreRole2
  }
  self.textTmpOurMvp:SetLocalText("YiBianJinQu_battle_record_tips_2")
end

local function ComponentDestroy(self)
  self.compObjWinLeft = nil
  self.compObjWinRight = nil
  self.textTmpTime = nil
  self.imgAllianceFlag22 = nil
  self.imgAllianceFlag21 = nil
  self.imgAllianceFlag1 = nil
  self.textTmpServer1 = nil
  self.textTmpServer21 = nil
  self.textTmpServer22 = nil
  self.textTmpAlliance1 = nil
  self.textTmpAlliance21 = nil
  self.textTmpAlliance22 = nil
  self.textTmpScoreRole1 = nil
  self.textTmpScoreRole2 = nil
  self.textTmpMemberRole1 = nil
  self.textTmpMemberRole2 = nil
  self.textTmpOurMvp = nil
  self.textTmpMvpName = nil
  self.compHeadIcon = nil
  self.btnLoveDog = nil
  self.imgSelfTeam1 = nil
  self.imgSelfTeam21 = nil
  self.imgSelfTeam22 = nil
  self.compLord = nil
  self.compFarm = nil
  self.btnMvpDogHead = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local lordLeft = Vector3.New(-182, 0, 0)
local lordRight = Vector3.New(254, 2, 0)
local farmLeft = Vector3.New(-254.3, 0.7, 0)
local farmRight = Vector3.New(182, 0, 0)

function UIActEpidemicBattleHistoryItem:ReInit(index, data)
  local timeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(data.battleTime * 1000)
  self.textTmpTime:SetText(Localization:GetString("800811") .. timeStr)
  self.compObjWinLeft:SetActive(data.isWin)
  self.compObjWinRight:SetActive(not data.isWin)
  for i = EpidemicBattleSide.Lord, EpidemicBattleSide.FarmerR do
    local render = self.rendersSides[i]
    local member = data.members[i]
    render.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, member.icon))
    render.server:SetText(string.format("#%s", member.server))
    render.alName:SetText(string.format("[%s]", member.abbr))
    render.alName:SetColor(member.oneself and ActEpidemicUtils.GetMyColor() or ActEpidemicUtils.GetOtherColor())
    if member.oneself then
      render.tag:SetActive(true)
      ActEpidemicUtils.LoadTeamSprite(render.tag, member.group)
    else
      render.tag:SetActive(false)
    end
  end
  local _, maxMemberCount = DataCenter.ActEpidemicZoneManager:GetBattleMemberLimitCount()
  for i = EpidemicZoneRole.Lord, EpidemicZoneRole.Farmer do
    local render = self.renderRoles[i]
    local role = data.roles[i]
    render.member:SetText(string.format("%s/%s", role.memberCount, maxMemberCount * role.sideCount))
    render.score:SetText(string.GetFormattedStr(role.score))
  end
  if data.mvp then
    self.btnMvpDogHead:SetActive(true)
    self.btnLoveDog:SetActive(true)
    self.compHeadIcon:SetData(data.mvp.uid, data.mvp.pic, data.mvp.picVer, nil)
    self.textTmpMvpName:SetText(data.mvp.name)
    self.mvp = data.mvp
  else
    self.btnMvpDogHead:SetActive(false)
    self.btnLoveDog:SetActive(false)
    self.textTmpMvpName:SetText("")
    self.mvp = nil
  end
  if data.myRole == EpidemicZoneRole.Lord then
    self.compLord:SetAnchoredPosition(lordLeft)
    self.compFarm:SetAnchoredPosition(farmRight)
  else
    self.compLord:SetAnchoredPosition(lordRight)
    self.compFarm:SetAnchoredPosition(farmLeft)
  end
end

function UIActEpidemicBattleHistoryItem:OnBtnLoveDogClick()
  if not self.mvp then
    return
  end
  InteractiveUtil.TryThumbsUp(self.mvp.uid, InteractiveUtil.ThumbsUpType.EpidemicBattleMvp, "UIActEpidemicBattleHistoryItem", function()
    UIUtil.ShowTipsId("YiBianJinQu_trivial_tips_21")
  end)
end

function UIActEpidemicBattleHistoryItem:OnBtnMvpDogHeadClick()
  if self.mvp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.mvp.uid)
  end
end

UIActEpidemicBattleHistoryItem.OnCreate = OnCreate
UIActEpidemicBattleHistoryItem.OnDestroy = OnDestroy
UIActEpidemicBattleHistoryItem.OnEnable = OnEnable
UIActEpidemicBattleHistoryItem.OnDisable = OnDisable
UIActEpidemicBattleHistoryItem.ComponentDefine = ComponentDefine
UIActEpidemicBattleHistoryItem.ComponentDestroy = ComponentDestroy
UIActEpidemicBattleHistoryItem.DataDefine = DataDefine
UIActEpidemicBattleHistoryItem.DataDestroy = DataDestroy
UIActEpidemicBattleHistoryItem.OnAddListener = OnAddListener
UIActEpidemicBattleHistoryItem.OnRemoveListener = OnRemoveListener
return UIActEpidemicBattleHistoryItem
