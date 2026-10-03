local MailHeroItem_HeroInfo = require("UI.UIMailNew.UIMailAllUserHeroesView.Component.MailHeroItem_HeroInfo")
local MailHeroItem_UserInfo = require("UI.UIMailNew.UIMailAllUserHeroesView.Component.MailHeroItem_UserInfo")
local UIMailAllUserHeroesView = BaseClass("UIMailAllUserHeroesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local _cp_btnClose = "CloseBtn"
local _cp_txtTitle = "txtTitle"
local _cp_gridContent = "ScrollView/Viewport/Content"

function UIMailAllUserHeroesView:OnCreate()
  base.OnCreate(self)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(BindCallback(self, self.OnClickBtnClose))
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._gridContent = self:AddComponent(UIBaseContainer, _cp_gridContent)
  self._prefab_user = self.transform:Find("template/ObjBattleHeroListView_UserItem").gameObject
  self._prefab_hero = self.transform:Find("template/ObjBattleHeroListView_HeroItem").gameObject
  self._prefab_user:GameObjectCreatePool()
  self._prefab_hero:GameObjectCreatePool()
end

function UIMailAllUserHeroesView:OnClickBtnClose()
  self.ctrl:CloseSelf()
end

function UIMailAllUserHeroesView:OnEnable()
  base.OnEnable(self)
  local param = self:GetUserData()
  local roundIdx = param.roundIdx or 0
  local side = param.side or "self"
  local mailId = param.mailId or ""
  local mailInfo = param.mailInfo
  if mailInfo == nil then
    mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailId)
  end
  if mailInfo == nil then
    return
  end
  local mailExt = mailInfo:GetMailExt()
  if mailExt == nil then
    return
  end
  local battleRoundItem = mailExt:GetFightReportByRoundIndex(roundIdx)
  if battleRoundItem == nil then
    return
  end
  local isMySide = side == "self"
  local heroExp = mailExt:GetHeroExpAddInfo()
  local allMember = battleRoundItem:GetAllMembers(isMySide, false)
  for _, memberInfo in pairs(allMember) do
    if not memberInfo:IsEmpty() then
      self:AddUserInfoNode(memberInfo)
      local heroes = memberInfo:GetPlayerHeroes()
      local heroCnt = 0
      for _, heroInfo in pairs(heroes) do
        if heroExp[heroInfo.heroId] then
          heroInfo.expAdd = heroExp[heroInfo.heroId].expAdd
        end
        heroCnt = heroCnt + 1
        self:AddHeroNode(heroInfo)
      end
      if heroCnt == 0 then
        self:AddHeroNode(nil)
      end
    end
  end
  self._txtTitle:SetLocalText(300694)
end

function UIMailAllUserHeroesView:AddHeroNode(heroInfo)
  local item = self._prefab_hero:GameObjectSpawn(self._gridContent.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = self._gridContent:AddComponent(MailHeroItem_HeroInfo, item.name)
  obj:SetData(heroInfo)
end

function UIMailAllUserHeroesView:AddUserInfoNode(memberInfo)
  local item = self._prefab_user:GameObjectSpawn(self._gridContent.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = self._gridContent:AddComponent(MailHeroItem_UserInfo, item.name)
  obj:SetData(memberInfo)
end

function UIMailAllUserHeroesView:OnDestroy()
  base.OnDestroy(self)
end

function UIMailAllUserHeroesView:OnDisable()
  self._gridContent:RemoveComponents(MailHeroItem_HeroInfo)
  self._gridContent:RemoveComponents(MailHeroItem_UserInfo)
  self._prefab_user.gameObject:GameObjectRecycleAll()
  self._prefab_hero.gameObject:GameObjectRecycleAll()
  base.OnDisable(self)
end

return UIMailAllUserHeroesView
