local LWUIVotePlayerListView = BaseClass("LWUIVotePlayerListView", UIBaseView)
local base = UIBaseView
local UIVotePlayerItem = require("UI.LWUIVotePlayerList.Component.VotePlayerItem")
local heroList_path = "panel/Common_bg_orange/scrollView_HeroList"
local title_path = "panel/Common_bg_orange/text_title"
local close_path = "panel"

function LWUIVotePlayerListView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUIVotePlayerListView:ComponentDefine()
  self.playerList = self:AddComponent(UIScrollView, "panel/scrollView_PlayerList")
  self.close = self:AddComponent(UIButton, "panel")
  self.closeBtn = self:AddComponent(UIButton, "panel/BG/closeBtn")
  self.infoText = self:AddComponent(UIText, "panel/Text")
  self.close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.playerList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function LWUIVotePlayerListView:ComponentDestroy()
  self.playerList = nil
end

function LWUIVotePlayerListView:ShowScroll()
  self:ClearScroll()
  local count = #self.playerDatalist
  self.playerList:SetTotalCount(count)
  if 0 < count then
    self.playerList:RefillCells()
  end
end

function LWUIVotePlayerListView:ClearScroll()
  self.playerList:ClearCells()
  self.playerList:RemoveComponents(UIVotePlayerItem)
end

function LWUIVotePlayerListView:OnCreateCell(itemObj, index)
  if not self.playerDatalist then
    return
  end
  itemObj.name = tostring(index)
  local item = self.playerList:AddComponent(UIVotePlayerItem, itemObj)
  item:ReInit(self.playerDatalist[index])
end

function LWUIVotePlayerListView:ReInit()
  self.data = self:GetUserData()
  self.index = self.data.index
  self.playerDatalist = self.data.playerList
  if self.playerDatalist and #self.playerDatalist > 0 then
    self:ShowScroll()
  else
    self.playerList:ClearCells()
  end
  self.infoText:SetLocalText("poll_selected_user_des", self.index)
end

function LWUIVotePlayerListView:OnDeleteCell(itemObj, index)
  self.playerList:RemoveComponent(itemObj.name, UIVotePlayerItem)
end

function LWUIVotePlayerListView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIVotePlayerListView:OnEnable()
  base.OnEnable(self)
end

function LWUIVotePlayerListView:OnDisable()
  base.OnDisable(self)
end

function LWUIVotePlayerListView:DataDefine()
  self.playerDatalist = {}
  self.slot = nil
end

function LWUIVotePlayerListView:DataDestroy()
  self.playerDatalist = nil
  self.curBuildIndex = nil
  self.slot = nil
end

function LWUIVotePlayerListView:UpdateList(data)
  self.playerDatalist = data
end

return LWUIVotePlayerListView
