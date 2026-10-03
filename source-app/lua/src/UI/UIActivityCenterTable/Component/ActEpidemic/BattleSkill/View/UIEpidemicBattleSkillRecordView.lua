local base = UIBaseView
local UIEpidemicBattleSkillRecordView = BaseClass("UIEpidemicBattleSkillRecordView", base)
local ActMgr = DataCenter.ActEpidemicZoneManager
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local empty_text_path = "PopUpTitle/Common_bg_orange2/EmptyText"
local info_text_path = "PopUpTitle/Common_bg_orange2/InfoText"

function UIEpidemicBattleSkillRecordView:OnCreate()
  base.OnCreate(self)
  self.records = {}
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("winter_battlefield_tips1053")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.info_text = self.transform:Find(info_text_path).gameObject
  self.info_text:GameObjectCreatePool()
  self.content:SetActive(false)
  self.empty_text:SetActive(true)
  ActMgr:ReqBattleSkillRecords()
end

function UIEpidemicBattleSkillRecordView:OnDestroy()
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.info_text:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function UIEpidemicBattleSkillRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleSkillEffectRecords, self.RefreshView)
end

function UIEpidemicBattleSkillRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EpidemicBattleSkillEffectRecords, self.RefreshView)
end

function UIEpidemicBattleSkillRecordView:RefreshView(records)
  local rL = #records
  self.content:SetActive(0 < rL)
  self.empty_text:SetActive(rL == 0)
  local cL = #self.records
  local max = math.max(rL, cL)
  for i = 1, max do
    local record = records[i]
    local cell = self.records[i]
    if record then
      if not cell then
        local goItem = self.info_text:GameObjectSpawn(self.content.transform)
        goItem.name = "record" .. i
        cell = self.content:AddComponent(UITextMeshProUGUIEx, goItem.name)
        self.records[i] = cell
      end
      cell:SetActive(true)
      local template = ActMgr:GetTemplateSkillById(record.skillId)
      local skillName = template ~= nil and template.name or ""
      local descStr
      if record.skillId == EpidemicSkillId.Hospital then
        descStr = Localization:GetString("YiBianJinQu_trivial_tips_31", record.playerName or "", Localization:GetString(skillName), record.cureHole or 0, record.cureSolider or 0)
      else
        descStr = Localization:GetString("YiBianJinQu_trivial_tips_30", record.playerName or "", Localization:GetString(skillName), record.damageHole or 0, record.damageSolider or 0)
      end
      descStr = UITimeManager:GetInstance():TimeStampToTimeForServer(record.time, true) .. " " .. descStr
      cell:SetText(descStr)
    elseif cell then
      cell:SetActive(false)
    end
  end
end

return UIEpidemicBattleSkillRecordView
