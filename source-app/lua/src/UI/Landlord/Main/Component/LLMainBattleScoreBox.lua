local base = UIBaseContainer
local LLMainBattleScoreBox = BaseClass("LLMainBattleScoreBox", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local box_path = "Box"
local score_text_path = "ScoreText"
local tip_path = "Tip"
local gold_text_path = "Tip/GoldText"
local red_path = "Red"
local btn_path = "Btn"

function LLMainBattleScoreBox:OnCreate()
  base.OnCreate(self)
  self.box = self:AddComponent(UIImage, box_path)
  self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
  self.tip = self:AddComponent(UIBaseComponent, tip_path)
  self.tip:SetActive(false)
  self.gold_text = self:AddComponent(UITextMeshProUGUIEx, gold_text_path)
  self.red = self:AddComponent(UIImage, red_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function LLMainBattleScoreBox:OnDestroy()
  self.box = nil
  self.score_text = nil
  self.tip = nil
  self.gold_text = nil
  self.red = nil
  self.config = nil
  self.index = nil
  base.OnDestroy(self)
end

function LLMainBattleScoreBox:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.config == nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLNineBox)
  else
    local state = ActMgr:GetNineBoxState(self.index)
    if state == 2 then
      ActMgr:ReqGetNineBox(self.index)
    else
      local x = self.box.transform.position.x
      local y = self.box.transform.position.y
      local width = self.box.rectTransform.rect.width
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101", self.config.value), EnumActivity.ActLandlord.Type, x, y, nil, self.index, width, 80)
    end
  end
end

function LLMainBattleScoreBox:InitConfig(config, idx)
  self.config = config
  self.index = idx
  if config ~= nil then
    local score = toInt(config.target)
    self.score_text:SetText(string.GetFormattedStr(score))
    self.gold_text:SetText(config.value)
    self.red:SetActive(false)
  else
    self.box:LoadSpriteAuto(string.format(LoadPath.LandlordPath, "lrb_jinmai_juezhan_jifen.png"))
    self.box:SetLocalScaleXYZ(0.7, 0.7, 1)
    self:UpdateScore()
  end
end

function LLMainBattleScoreBox:UpdateScore()
  if self.config ~= nil then
    return
  end
  local score = ActMgr:GetNineBoxScore()
  self.score_text:SetText(string.GetFormattedStr(score))
end

function LLMainBattleScoreBox:SetData()
  local config = self.config
  if config == nil then
    return
  end
  local state = ActMgr:GetNineBoxState(self.index)
  local iconId = (self.index - 1) % 3
  if iconId == 1 then
    iconId = 2
  elseif iconId == 2 then
    iconId = 1
  end
  iconId = (state == 3 and 2 or 1) + iconId * 2
  self.box:LoadSpriteAuto(string.format(LoadPath.LandlordPath, string.format("LXY_s5_Baoxiang%s_icon.png", iconId)))
  self.box:SetLocalScaleXYZ(0.5, 0.5, 1)
  self.red:SetActive(state == 2)
end

return LLMainBattleScoreBox
