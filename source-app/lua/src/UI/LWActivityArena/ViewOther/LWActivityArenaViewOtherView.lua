local LWActivityArenaViewOtherView = BaseClass("LWActivityArenaViewOtherView", UIBaseView)
local base = UIBaseView
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = "500211"
  },
  {
    path = "btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "head",
    name = "head",
    type = UICommonHead
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText,
    text = ""
  },
  {
    path = "txtLabel",
    name = "txtLabel",
    type = UIText,
    textKey = "500264"
  },
  {
    path = "head/Score",
    name = "score",
    type = UIBaseContainer
  },
  {
    path = "head/Score/ScoreText",
    name = "scoreText",
    type = UIText,
    text = ""
  },
  {
    path = "layout",
    name = "layout",
    type = nil
  },
  {
    path = "layout/txtPower",
    name = "txtPower",
    type = UIText,
    text = ""
  },
  {
    path = "layout/Soldier",
    name = "compSoldier",
    type = UIBaseContainer
  },
  {
    path = "layout/Soldier/SoldierBase",
    name = "imgSoldierBase",
    type = UIImage
  },
  {
    path = "layout/Soldier/SoldierBase/SoldierImg",
    name = "imgSoldier",
    type = UIImage
  },
  {
    path = "layout/Soldier/SoldierText",
    name = "textSoldier",
    type = UIText,
    text = ""
  },
  {
    path = "btnChat",
    name = "btnChat",
    type = UIButton,
    onClick = function(self)
      self:OnClickChat()
    end
  },
  {
    path = "btnChat/txtChat",
    name = "txtChat",
    type = UIText,
    textKey = "393014"
  },
  {
    path = "scrollHeros",
    name = "scrollHeros",
    type = UIScrollRect
  },
  {
    path = "scrollHeros/Viewport/Content",
    name = "contentHeros",
    type = UIBaseContainer
  }
}

function LWActivityArenaViewOtherView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh(self:GetUserData())
end

function LWActivityArenaViewOtherView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaViewOtherView:ComponentDefine()
  self.heroCells = {}
  self:DefineCompsByBook(compBook)
end

function LWActivityArenaViewOtherView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaViewOtherView:OnAddListener()
  base.OnAddListener(self)
end

function LWActivityArenaViewOtherView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWActivityArenaViewOtherView:Refresh(otherInfo)
  self.otherInfo = otherInfo
  local playerInfo = otherInfo.playerInfo
  self.head:SetHeadAndFrame(playerInfo.uid, playerInfo.pic, playerInfo.picver, false, playerInfo.headSkinId)
  local nameStr = ""
  if not string.IsNullOrEmpty(playerInfo.abbr) then
    nameStr = nameStr .. " [" .. playerInfo.abbr .. "]"
  end
  nameStr = nameStr .. " " .. playerInfo.name
  self.txtName:SetText(nameStr)
  if otherInfo.formationPower then
    self.txtPower:SetText(otherInfo.formationPower)
  else
    self.txtPower:SetText(playerInfo.power)
  end
  self.btnChat:SetActive(playerInfo.uid and not string.IsNullOrEmpty(playerInfo.uid) and playerInfo.uid ~= LuaEntry.Player.uid)
  self:RefreshHeroCells(otherInfo.heros)
  if otherInfo.score then
    self.score:SetActive(true)
    self.scoreText:SetText(otherInfo.score)
  else
    self.score:SetActive(false)
  end
  local soldierId = checknumber(otherInfo.formationSoldier)
  local showSoldier = 0 < soldierId
  if self.compSoldier then
    self.compSoldier:SetActive(showSoldier)
    if showSoldier then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
      if soldierTemplate ~= nil then
        self.imgSoldierBase:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
        local soldierIcon = string.format(LoadPath.ItemPath, soldierTemplate.icon)
        self.imgSoldier:LoadSprite(soldierIcon)
        self.textSoldier:SetText("Lv." .. soldierTemplate.lv)
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
end

function LWActivityArenaViewOtherView:ClearHeroCells()
  self.contentHeros:RemoveComponents(UIHeroCellSmall)
  if not self.heroCells then
    for _, cell in pairs(self.heroCells) do
      if not IsNull(cell) then
        self:GameObjectDestroy(cell)
      end
    end
  end
  self.heroCells = {}
end

function LWActivityArenaViewOtherView:RefreshHeroCells(heroes)
  self:ClearHeroCells()
  if not heroes then
    return
  end
  local heroList = table.values(heroes)
  if 0 < #heroList then
    table.sort(heroList, function(heroA, heroB)
      if heroA.index == ArmyFormationSlot.Dominator then
        return true
      end
      if heroB.index == ArmyFormationSlot.Dominator then
        return false
      end
      return heroA.index < heroB.index
    end)
    for idx, heroInfo in pairs(heroList) do
      if self.heroCells[idx] == nil then
        self.heroCells[idx] = self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.gameObject:SetActive(true)
          go.transform:SetParent(self.contentHeros.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.name = idx
          local cell = self.contentHeros:AddComponent(UIHeroCellSmall, go)
          cell:InitWithConfigId(heroInfo.heroId, heroInfo.heroQuality, heroInfo.heroLevel, heroInfo.rankLv, heroInfo.weaponLevel, heroInfo.awakenLv, heroInfo.heroSkinId)
        end)
      end
    end
  end
end

function LWActivityArenaViewOtherView:OnClickChat()
  if not self.otherInfo or not self.otherInfo.playerInfo then
    return
  end
  self.ctrl:CloseSelf()
  local userInfo = {}
  userInfo.uid = self.otherInfo.playerInfo.uid
  userInfo.userName = self.otherInfo.playerInfo.name
  GoToUtil.OpenChatView(false, {anim = false}, {privateUserInfo = userInfo})
end

return LWActivityArenaViewOtherView
