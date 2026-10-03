local UIMailTroopBuffAddPanelView = BaseClass("UIMailTroopBuffAddPanelView", UIBaseView)
local ObjTroopBuffAddItem = require("UI.UIMailNew.UIMailTroopBuffAddPanel.Component.ObjTroopBuffAddItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local _cp_btnClose = "UICommonPopUpTitle/CloseBtn"
local _cp_scrollContent = "ScrollView/Viewport/Content"
local _cp_objTroopBuffAddItem = "template/ObjTroopBuffAddItem"
local _cp_txtTitle = "UICommonPopUpTitle/Common_img_title/titleText"

function UIMailTroopBuffAddPanelView:ComponentDefine()
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(BindCallback(self, self.OnClickBtnClose))
  self._scrollContent = self:AddComponent(UIBaseContainer, _cp_scrollContent)
  self._prefab = self.transform:Find(_cp_objTroopBuffAddItem).gameObject
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._txtTitle:SetLocalText(311048)
end

function UIMailTroopBuffAddPanelView:OnClickBtnClose()
  self.ctrl:CloseSelf()
end

function UIMailTroopBuffAddPanelView:OnEnable()
  base.OnEnable(self)
  local userdata = self:GetUserData()
  local mailId = userdata.mailId
  local roundIndex = userdata.roundIndex
  local mailInfo = userdata.mailInfo
  self._mailInfo = mailInfo
  if mailInfo == nil then
    return
  end
  local roundInfo = mailInfo:GetMailExt():GetFightReportByRoundIndex(roundIndex)
  if roundInfo == nil then
    return
  end
  local member_myside = roundInfo:GetAllMembers(true)
  local member_other = roundInfo:GetAllMembers(false)
  local member_myside_cnt = table.count(member_myside)
  local member_other_cnt = table.count(member_other)
  local cellCnt = math.max(member_myside_cnt, member_other_cnt)
  if cellCnt == 0 then
    return
  end
  self._prefab.gameObject:GameObjectRecycleAll()
  local param = {}
  for idx = 1, cellCnt do
    param.mailId = mailId
    param.roundIndex = roundIndex
    param.cellIndex = idx
    self:AddBuffItem(param)
  end
end

function UIMailTroopBuffAddPanelView:AddBuffItem(param)
  local item = self._prefab:GameObjectSpawn(self._scrollContent.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = self._scrollContent:AddComponent(ObjTroopBuffAddItem, item.name)
  obj:SetData(param)
end

function UIMailTroopBuffAddPanelView:OnAddListener()
  base.OnAddListener(self)
end

function UIMailTroopBuffAddPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMailTroopBuffAddPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMailTroopBuffAddPanelView:OnDestroy()
  self._prefab.gameObject:GameObjectRecycleAll()
  self._scrollContent:RemoveComponents(ObjTroopBuffAddItem)
end

return UIMailTroopBuffAddPanelView
