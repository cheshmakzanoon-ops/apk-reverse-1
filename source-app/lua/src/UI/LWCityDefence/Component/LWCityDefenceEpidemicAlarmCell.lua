local LWCityDefenceEpidemicAlarmCell = BaseClass("LWCityDefenceEpidemicAlarmCell", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local ActMgr = DataCenter.ActEpidemicZoneManager
local player_head_path = "Head/UIPlayerHead"
local time_bar_path = "TimeBar"
local bar_text_path = "TimeBar/BarText"
local server_txt_path = "ServerTxt"
local name_txt_path = "ServerTxt/NameTxt"
local pos_btn_path = "ServerTxt/NameTxt/PosBtn"
local skill_icon_path = "SkillIcon"

function LWCityDefenceEpidemicAlarmCell:OnCreate()
  base.OnCreate(self)
  self.root = self:AddComponent(UIImage, "")
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.time_bar = self:AddComponent(UISlider, time_bar_path)
  self.bar_text = self:AddComponent(UITextMeshProUGUIEx, bar_text_path)
  self.server_txt = self:AddComponent(UITextMeshProUGUIEx, server_txt_path)
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, name_txt_path)
  self.pos_btn = self:AddComponent(UIButton, pos_btn_path)
  self.pos_btn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
    local worldPos = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
    GoToUtil.GotoDragonPos(worldPos)
  end)
  self.skill_icon = self:AddComponent(UIButton, skill_icon_path)
  local prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleMainSkillEffect.prefab"
  local request = ResourceManager:InstantiateAsync(prefab)
  self.effRequest = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.effRequest = nil
      return
    end
    local go = request.gameObject
    local tf = go.transform
    go:SetActive(true)
    go.name = "Effect"
    tf:SetParent(self.transform)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTF ~= nil then
      rectTF:Set_anchoredPosition(230, -12)
    end
    local cls = require("UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneSkillEffect")
    local effect = self:AddComponent(cls, go.name)
    effect:SetShow(self.skillId)
  end)
end

function LWCityDefenceEpidemicAlarmCell:OnDestroy()
  if self.effRequest ~= nil then
    self.effRequest:Destroy()
    self.effRequest = nil
  end
  self.player_head = nil
  self.time_bar = nil
  self.bar_text = nil
  self.server_txt = nil
  self.name_txt = nil
  self.pos_btn = nil
  self.skill_icon = nil
  base.OnDestroy(self)
end

function LWCityDefenceEpidemicAlarmCell:SetData(param, view)
  self.view = view
  self.skillId = param.skillId
  self.root:SetColorHex(self.skillId == EpidemicSkillId.Hospital and "b7e1fd" or "ffc9b9")
  self.pointId = param.point
  local battleInfo = ActMgr:GetBattleInfo()
  local alId, info = battleInfo:GetAlMemberByPlayerUid(param.uid)
  self.player_head:SetHeadAndFrame(info.uid, info.pic, info.picVer, false, info.headSkinId, info.headSkinET)
  self.name_txt:SetText("<u>" .. info.name)
  local alInfo = ActMgr:GetActInfo():GetAllianceById(alId)
  self.server_txt:SetText(alInfo.serverId .. "[" .. alInfo.abbr .. "]")
  local template = ActMgr:GetTemplateSkillById(param.skillId)
  if not string.IsNullOrEmpty(template.icon) then
    self.skill_icon:LoadSprite(template.icon)
  end
  self.checkTime = ((template.effPartTime or 3) + 1) * 1000
  self.sTime = param.startTime
  self.eTime = param.endTime
  self.lsTime = param.lastSignTime
  self:Update1000MS()
end

function LWCityDefenceEpidemicAlarmCell:Update1000MS()
  if self.sTime == nil or self.eTime == nil or self.lsTime == nil then
    return
  end
  local uiTimeMgr = UITimeManager:GetInstance()
  local curTime = uiTimeMgr:GetServerTime()
  if curTime >= self.eTime then
    self:SetActive(false)
    self.sTime = nil
    self.eTime = nil
    self.lsTime = nil
    return
  end
  if curTime - self.lsTime > self.checkTime then
    return
  end
  local max = self.eTime - self.sTime
  local cur = curTime - self.sTime
  self.time_bar:SetValue(cur / max)
  self.bar_text:SetText(uiTimeMgr:SecondToFmtStringWithoutHour((self.eTime - curTime) / 1000))
end

return LWCityDefenceEpidemicAlarmCell
