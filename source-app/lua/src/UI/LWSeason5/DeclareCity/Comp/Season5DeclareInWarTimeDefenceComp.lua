local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local p_comp_scroll_me_path = "p_comp_scroll_me"
local content_path = "p_comp_scroll_me/Content"
local p_text_declare_defence_path = "p_text_declare_defence"
local Season5DeclareInWarTimeDefenceCell = require("UI/LWSeason5/DeclareCity/Comp/Season5DeclareInWarTimeDefenceCell")
local base = UIBaseContainer
local Season5DeclareInWarTimeDefenceComp = BaseClass("Season5DeclareInWarTimeDefenceComp", UIBaseContainer)

function Season5DeclareInWarTimeDefenceComp:ComponentDefine()
  self.p_comp_scroll_me = self:AddComponent(UIScrollRect, p_comp_scroll_me_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.p_text_declare_defence = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_defence_path)
end

function Season5DeclareInWarTimeDefenceComp:ComponentDestroy()
  self:ClearScroll()
  self.p_comp_scroll_me = nil
  self.content = nil
  self.p_text_declare_defence = nil
end

function Season5DeclareInWarTimeDefenceComp:DataDefine()
  self.listGO = {}
end

function Season5DeclareInWarTimeDefenceComp:DataDestroy()
  self.listGO = {}
end

function Season5DeclareInWarTimeDefenceComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareInWarTimeDefenceComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareInWarTimeDefenceComp:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareInWarTimeDefenceComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareInWarTimeDefenceComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function Season5DeclareInWarTimeDefenceComp:InitData(data)
  local info = DataCenter.SeasonDataManager.CrossDeclareWarInfo
  if info ~= nil then
    self.BeDeclareList = info.beDeclareList
  end
  return true
end

function Season5DeclareInWarTimeDefenceComp:InitUi()
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
  SeasonRedPointUtils.GetCrossDeclareWarRedPoint(nil, true)
end

function Season5DeclareInWarTimeDefenceComp:InitScroll(go, index)
  local item = self.p_comp_scroll_me:AddComponent(Season5DeclareInWarTimeDefenceCell, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function Season5DeclareInWarTimeDefenceComp:UpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    local data = {}
    data.DeclareInfo = self.BeDeclareList[theIndex]
    cellItem:ReInit(data)
  end
end

function Season5DeclareInWarTimeDefenceComp:DestroyScrollItem(go, index)
end

function Season5DeclareInWarTimeDefenceComp:ClearScroll(go, index)
  self.p_comp_scroll_me:SetVerticalNormalizedPosition(1)
  self.p_comp_scroll_me:RemoveComponents(Season5DeclareInWarTimeDefenceCell)
  self.content:DestroyChildNode()
end

return Season5DeclareInWarTimeDefenceComp
