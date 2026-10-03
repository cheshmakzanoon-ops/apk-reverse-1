local UIFishRankView = BaseClass("UIFishRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local FishRankItemComponent = require("UI.UIFishing.UIFishRank.FishRankItemComponent")
local bot_text_path = "Content/BotText"

function UIFishRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIFishRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnCloseBg = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnCloseBg:SetOnClick(function()
    self:OnBtnCloseBgClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.scrollViewScrollView = self.viewSkin:AddComponent(self, UIScrollView, 5)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.compMyRankItem = self.viewSkin:AddComponent(self, FishRankItemComponent, 7)
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 8)
  self.scrollViewScrollView:SetFixedItemSize(712, 141)
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.bot_text = self:AddComponent(UITextMeshProUGUIEx, bot_text_path)
end

function UIFishRankView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnCloseBg = nil
  self.btnClose = nil
  self.textTitle = nil
  self.compEmpty = nil
  self.scrollViewScrollView = nil
  self.compContent = nil
  self.compMyRankItem = nil
  self.rawImgBanner = nil
end

function UIFishRankView:DataDefine()
  self.fishId = self:GetUserData()
end

function UIFishRankView:DataDestroy()
end

function UIFishRankView:OnEnable()
  base.OnEnable(self)
  self:Refresh()
end

function UIFishRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FishRankRefresh, self.Refresh)
end

function UIFishRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.FishRankRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function UIFishRankView:OnBtnCloseBgClick()
  self.ctrl:CloseSelf()
end

function UIFishRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIFishRankView:Refresh()
  local fishMeta = DataCenter.FishMetaManager:GetMeta(self.fishId)
  self.textTitle:SetLocalText("fish_rank_limit", Localization:GetString(fishMeta.name))
  self.weight_type = fishMeta.weight_type
  self:ClearScroll()
  local rankList = DataCenter.FishingDataManager:GetRankList(self.fishId)
  self.rankList = rankList.rankList or {}
  self.compEmpty:SetActive(#self.rankList == 0)
  self.scrollViewScrollView:SetTotalCount(#self.rankList)
  self.scrollViewScrollView:RefillCells()
  self.compMyRankItem:SetData(rankList.myRank or {}, self.weight_type, true)
  local myCamp = DataCenter.SeasonFactionWarDataManager.myCampId
  if myCamp == 2 then
    self.rawImgBanner:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Textures/Fishing/FX_diaoyu_paihangbang2_banner.png")
  else
    self.rawImgBanner:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Textures/Fishing/FX_diaoyu_paihangbang_banner.png")
  end
  self.bot_text:SetLocalText("season_s6_fish_titl_get_desc", fishMeta.title_min .. (self.weight_type == 1 and "g" or "kg"))
end

function UIFishRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewScrollView:AddComponent(FishRankItemComponent, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.rankList[index], self.weight_type)
  end
end

function UIFishRankView:OnRankItemMoveOut(itemObj, index)
  self.scrollViewScrollView:RemoveComponent(itemObj.name, FishRankItemComponent)
end

function UIFishRankView:ClearScroll()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(FishRankItemComponent)
end

return UIFishRankView
