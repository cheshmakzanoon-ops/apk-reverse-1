local MainMiniMapMeteoriteNewsItem = BaseClass("MainMiniMapMeteoriteNewsItem", UIAsyncContainer)
local base = UIAsyncContainer
local tmp_live_path = "tmpLive"
local tmp_name_path = "tmpName"

local function OnCreate(self, holder)
  base.OnCreate(self)
  self.tmp_live = self:AddComponent(UITextMeshProUGUIEx, tmp_live_path)
  self.tmp_name = self:AddComponent(UITextMeshProUGUIEx, tmp_name_path)
  self.holder = holder
  self.tmp_live:SetLocalText("yuntieBattle_news_dialog_1001")
  self.tmp_name:SetLocalText("yuntieBattle_news_dialog_1003")
  UIUtil.InitBtn(self, "", self.OnClickedIcon)
  self.inited = true
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self.inited = nil
end

function MainMiniMapMeteoriteNewsItem:Refresh(lod, curState)
  if not self.inited then
    return
  end
  local obj = self.holder or self.gameObject
  if IsNull(obj) then
    return
  end
  if lod < 4 then
    obj:SetActive(false)
    return
  end
  if curState < 0 then
    obj:SetActive(false)
  elseif 2 <= curState and curState <= 6 then
    obj:SetActive(true)
  else
    obj:SetActive(false)
  end
end

function MainMiniMapMeteoriteNewsItem:OnClickedIcon()
  DataCenter.ActMeteoriteBattleManager:OpenActWindowPls()
end

MainMiniMapMeteoriteNewsItem.OnCreate = OnCreate
MainMiniMapMeteoriteNewsItem.OnDestroy = OnDestroy
return MainMiniMapMeteoriteNewsItem
