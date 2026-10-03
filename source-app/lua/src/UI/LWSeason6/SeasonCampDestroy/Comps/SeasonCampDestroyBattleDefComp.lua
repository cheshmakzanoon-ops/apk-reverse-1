local p_comp_scroll_me_path = "p_comp_scroll_me"
local content_path = "p_comp_scroll_me/Content"
local p_text_declare_defence_path = "p_text_declare_defence"
local SeasonCampDestroyBattleDetailDef = require("UI/LWSeason6/SeasonCampDestroy/Comps/SeasonCampDestroyBattleDetailDef")
local base = UIBaseContainer
local SeasonCampDestroyBattleDefComp = BaseClass("SeasonCampDestroyBattleDefComp", UIBaseContainer)

function SeasonCampDestroyBattleDefComp:ComponentDefine()
  self.p_comp_scroll_me = self:AddComponent(UIScrollRect, p_comp_scroll_me_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.p_text_declare_defence = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_defence_path)
end

function SeasonCampDestroyBattleDefComp:ComponentDestroy()
  self:ClearScroll()
  self.p_comp_scroll_me = nil
  self.content = nil
  self.p_text_declare_defence = nil
end

function SeasonCampDestroyBattleDefComp:DataDefine()
  self.listGO = {}
end

function SeasonCampDestroyBattleDefComp:DataDestroy()
  self.listGO = {}
end

function SeasonCampDestroyBattleDefComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyBattleDefComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBattleDefComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
end

function SeasonCampDestroyBattleDefComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBattleDefComp:OnSeasonCampDestroyActRefresh()
  local beDeclareList = DataCenter.SeasonCampDestroyManager:GetBeDeclareList()
  self:ReInit(beDeclareList)
end

function SeasonCampDestroyBattleDefComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonCampDestroyBattleDefComp:InitData(data)
  self.BeDeclareList = data or {}
  return true
end

function SeasonCampDestroyBattleDefComp:InitUi()
  self:ClearScroll()
  if table.count(self.BeDeclareList) == 0 then
    self.p_comp_scroll_me:SetActive(false)
    self.p_text_declare_defence:SetActive(true)
    self.p_text_declare_defence:SetLocalText("season_s5_activity_1200059_desc20")
  else
    self.p_comp_scroll_me:SetActive(true)
    self.p_text_declare_defence:SetActive(false)
    local initFunc = BindCallback(self, self.InitScroll)
    local updateFunc = BindCallback(self, self.UpdateScroll)
    local destroyFunc = BindCallback(self, self.DestroyScrollItem)
    self.content:SetMaxCount(table.count(self.BeDeclareList))
    self.content:Init(initFunc, updateFunc, destroyFunc)
    self.content:SetItemCount(table.count(self.BeDeclareList))
    self.content:ForceUpdate()
  end
end

function SeasonCampDestroyBattleDefComp:UpdateData()
end

function SeasonCampDestroyBattleDefComp:UpdateUi()
end

function SeasonCampDestroyBattleDefComp:InitScroll(go, index)
  local item = self.p_comp_scroll_me:AddComponent(SeasonCampDestroyBattleDetailDef, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function SeasonCampDestroyBattleDefComp:UpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    local data = {}
    data.DeclareInfo = self.BeDeclareList[theIndex]
    cellItem:ReInit(data)
  end
end

function SeasonCampDestroyBattleDefComp:DestroyScrollItem(go, index)
  self.listGO[go] = nil
end

function SeasonCampDestroyBattleDefComp:ClearScroll(go, index)
  self.p_comp_scroll_me:SetVerticalNormalizedPosition(1)
  self.p_comp_scroll_me:RemoveComponents(SeasonCampDestroyBattleDetailDef)
  self.content:DestroyChildNode()
  self.listGO = {}
end

return SeasonCampDestroyBattleDefComp
