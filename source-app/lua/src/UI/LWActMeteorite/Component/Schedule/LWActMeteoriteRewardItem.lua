local base = UIBaseContainer
local LWActMeteoriteRewardItem = BaseClass("LWActMeteoriteRewardItem", base)
local box_path = "Box"
local score_text_path = "ScoreText"
local tip_path = "Tip"
local gold_text_path = "Tip/GoldText"
local red_path = "Red"
local btn_path = "Btn"

function LWActMeteoriteRewardItem:OnCreate()
  base.OnCreate(self)
  self.box = self:AddComponent(UIImage, box_path)
  self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
  self.tip = self:AddComponent(UIBaseComponent, tip_path)
  self.gold_text = self:AddComponent(UITextMeshProUGUIEx, gold_text_path)
  self.red = self:AddComponent(UIImage, red_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.config == nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWActMeteoriteAward)
    else
      local state = self.config ~= nil and DataCenter.ActMeteoriteBattleManager:GetBoxStateByCfg(self.config) or 0
      if state == 2 then
        DataCenter.ActMeteoriteBattleManager:ReqGetReward(self.config.id)
      else
        DataCenter.ActMeteoriteBattleManager:ShowRewardTips(self.box, self.config, self.index, nil, 80)
      end
    end
  end)
end

function LWActMeteoriteRewardItem:OnDestroy()
  self.box = nil
  self.score_text = nil
  self.tip = nil
  self.gold_text = nil
  self.btn = nil
  self.config = nil
  base.OnDestroy(self)
end

function LWActMeteoriteRewardItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MeteoriteBattleScoreUpdate, self.SetData)
end

function LWActMeteoriteRewardItem:OnRemoveListener()
  self:RemoveUIListener(EventId.MeteoriteBattleScoreUpdate, self.SetData)
  base.OnRemoveListener(self)
end

function LWActMeteoriteRewardItem:InitConfig(config, idx)
  self.config = config
  self.index = idx
  if config ~= nil then
    local score = toInt(config.para)
    self.score_text:SetText(string.GetFormattedStr(score))
    self.gold_text:SetText(config.value)
  else
    self.tip:SetActive(false)
    self.box:LoadSpriteAuto(string.format(LoadPath.ItemPath, "lrb_zhouliuhuodong_jifen.png"))
    self.box:SetLocalScaleXYZ(1.5, 1.5, 1)
    self:UpdateScore()
  end
end

function LWActMeteoriteRewardItem:UpdateScore()
  if self.config ~= nil then
    return
  end
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo() or {}
  local score = actInfo.count or 0
  self.score_text:SetText(string.GetFormattedStr(score))
end

function LWActMeteoriteRewardItem:SetData()
  local config = self.config
  if config == nil then
    return
  end
  local state = DataCenter.ActMeteoriteBattleManager:GetBoxStateByCfg(config)
  self.tip:SetActive(state ~= 3)
  local fileName = state == 3 and "lrb_zhouliuhuodong_baoxiangguan_0%d.png" or "lrb_zhouliuhuodong_baoxiangkai_0%d.png"
  local iconId = toInt(config.icon)
  iconId = Mathf.Clamp(iconId, 1, 5)
  fileName = string.format(fileName, iconId)
  self.box:LoadSpriteAuto(string.format(LoadPath.LWActMeteoriteBattlePath, fileName))
  self.red:SetActive(state == 2)
end

return LWActMeteoriteRewardItem
