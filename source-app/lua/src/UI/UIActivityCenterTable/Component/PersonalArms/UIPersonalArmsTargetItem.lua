local UIPersonalArmsTargetItem = BaseClass("UIPersonalArmsTargetItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DEFAULT_IMG_POS = Vector3.New(4.5, -2.5, 0)

function UIPersonalArmsTargetItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIBaseContainer, "bg")
  self._require_txt = self:AddComponent(UIText, "Txt_Require")
  self._reward_txt = self:AddComponent(UIText, "Txt_Reward")
  self.imgArmsTarget = self:AddComponent(UIImage, "targetIcon")
  self.imgRecommend = self:AddComponent(UIImage, "recommendImg")
  self.btnGoto = self:AddComponent(UIButton, "btnGoto")
  self.btnGoto:SetOnClick(function()
    self:Goto()
  end)
  self.imgGo = self:AddComponent(UIImage, "btnGoto/img")
  self.imgGo.transform.localPosition = DEFAULT_IMG_POS
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.imgGo.transform.localScale = Vector3.New(-1, 1, 1)
  else
    self.imgGo.transform.localScale = Vector3.New(1, 1, 1)
  end
  self.imgGoAnimator = self.imgGo.transform:GetComponent(typeof(CS.UnityEngine.Animator))
  self.btnMoreInfo = self:AddComponent(UIButton, "btnMoreInfo")
  self.btnMoreInfo:SetOnClick(function()
    self:ShowMoreInfo()
  end)
  self.more_txt = self:AddComponent(UIText, "btnMoreInfo/Text")
  self.more_txt:SetLocalText("armsRace_score_viewMore")
end

function UIPersonalArmsTargetItem:OnDestroy()
  base.OnDestroy(self)
end

function UIPersonalArmsTargetItem:OnEnable()
  base.OnEnable(self)
end

function UIPersonalArmsTargetItem:OnDisable()
  base.OnDisable(self)
end

function UIPersonalArmsTargetItem:RefreshData(param, isShowAnim)
  local scoreId = param
  local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
  if string.IsNullOrEmpty(cfg.tips) then
    self._require_txt:SetLocalText(cfg.name)
  else
    self._require_txt:SetLocalText(cfg.tips)
  end
  self._reward_txt:SetText("+ " .. cfg.points)
  self.imgArmsTarget:LoadSprite(cfg.icon_path)
  self.scoreType = tonumber(cfg.type) or 0
  self.typeVal = tonumber(cfg.value) or 0
  self.groupId = tonumber(cfg.group) or 0
  local recommend = tonumber(cfg.recommend) or 0
  self.imgRecommend:SetActive(recommend == 1)
  self.btnMoreInfo:SetActive(0 < self.groupId)
  self:ShowGotoImgAnim(isShowAnim)
end

function UIPersonalArmsTargetItem:SetBg(value)
  self.bg:SetActive(not value)
end

function UIPersonalArmsTargetItem:Goto()
  if self.scoreType <= 0 then
    return
  end
  GoToUtil.PersonalArmsGoto(self.scoreType, self.typeVal)
end

function UIPersonalArmsTargetItem:ShowMoreInfo()
  if self.groupId <= 0 then
    return
  end
  local scoreTaskList = DataCenter.ActivityPersonalArmsDataManager:GetScoreGroup(self.groupId)
  local param = {}
  param.scoreTaskList = scoreTaskList
  param.pos = self.btnMoreInfo.transform.position
  if scoreTaskList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsTaskTip, {anim = false}, param)
  end
end

function UIPersonalArmsTargetItem:ShowGotoImgAnim(isShowAnim)
  if isShowAnim then
    self.imgGoAnimator.enabled = true
  else
    self.imgGo.transform.localPosition = DEFAULT_IMG_POS
    self.imgGoAnimator.enabled = false
  end
end

return UIPersonalArmsTargetItem
