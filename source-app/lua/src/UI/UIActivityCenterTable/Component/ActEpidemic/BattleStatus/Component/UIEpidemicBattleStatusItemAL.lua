local UIEpidemicBattleStatusItemAL = BaseClass("UIEpidemicBattleStatusItemAL", UIBaseContainer)
local base = UIBaseContainer
local actMgr = DataCenter.ActEpidemicZoneManager
local flag1_path = "al/flag1"
local abbr1_path = "al/flag1/abbr1"
local flag2_path = "al/flag2"
local abbr2_path = "al/flag2/abbr2"
local name_path = "name"
local score_path = "score"
local speed_path = "speed"
local player_path = "player"
local btn_path = "btn"
local select_path = "select"

function UIEpidemicBattleStatusItemAL:OnCreate()
  base.OnCreate(self)
  self.flag1 = self:AddComponent(UIButton, flag1_path)
  self.flag1:SetOnClick(function()
    self:SetOnClickAL(1)
  end)
  self.abbr1 = self:AddComponent(UITextMeshProUGUIEx, abbr1_path)
  self.flag2 = self:AddComponent(UIButton, flag2_path)
  self.flag2:SetOnClick(function()
    self:SetOnClickAL(2)
  end)
  self.abbr2 = self:AddComponent(UITextMeshProUGUIEx, abbr2_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.score = self:AddComponent(UITextMeshProUGUIEx, score_path)
  self.speed = self:AddComponent(UITextMeshProUGUIEx, speed_path)
  self.player = self:AddComponent(UITextMeshProUGUIEx, player_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.select = self:AddComponent(UIButton, select_path)
end

function UIEpidemicBattleStatusItemAL:SetOnClickAL(idx)
  local alInfo = self.als[idx]
  if alInfo == nil then
    return
  end
  local allianceId = alInfo[1]
  local serverId = alInfo[2]
  local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
  if data == nil then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceId)
  else
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIAllianceDetail) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceDetail)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, "", allianceId, serverId)
  end
end

function UIEpidemicBattleStatusItemAL:SetSelect(bSel)
  self.select:SetActive(bSel)
  local s = bSel and 1.05 or 1
  self:SetLocalScaleXYZ(s, s, s)
end

function UIEpidemicBattleStatusItemAL:ReInit(targetRole)
  self.als = {}
  self.flag2:SetActive(false)
  local actInfo = actMgr:GetActInfo()
  if actInfo == nil then
    return
  end
  local curGroup = actMgr:GetCurGroup()
  if curGroup == nil then
    return
  end
  local mIdx = 0
  for _, v in ipairs(curGroup.roles) do
    local img, txt
    if v.role == targetRole then
      img = mIdx == 0 and self.flag1 or self.flag2
      txt = mIdx == 0 and self.abbr1 or self.abbr2
      mIdx = mIdx + 1
      self.als[mIdx] = {
        v.allianceId,
        v.serverId
      }
      local abbr, _, icon = actInfo:GetAlNameAndIcon(v.allianceId)
      txt:SetText("[" .. abbr .. "]")
      img:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, icon))
      img:SetActive(true)
    end
  end
  self.name:SetLocalText(mIdx == 1 and "YiBianJinQu_camp_name_1" or "YiBianJinQu_camp_name_2")
  local battleInfo = DataCenter.ActEpidemicZoneManager:GetBattleInfo()
  local vsInfoArr = battleInfo.vsInfo
  local maxNumMain = LuaEntry.DataConfig:TryGetNum("YiBianJinQu", "k6", 20)
  local max = mIdx * maxNumMain
  for i, v in pairs(vsInfoArr) do
    if i == targetRole then
      self.score:SetText(string.GetFormattedSeparatorNum(v.score or 0))
      self.speed:SetText("+" .. (v.speed or 0) .. "/s")
      self.player:SetText((v.count or 0) .. "/" .. max)
      break
    end
  end
end

return UIEpidemicBattleStatusItemAL
