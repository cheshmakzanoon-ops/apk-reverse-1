local UIAllyDuelConditionTipView = BaseClass("UIAllyDuelConditionTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIAllyDuelConditionTipItem = require("UI.UIAllyDuelConditionTip.Component.UIAllyDuelConditionTipItem")
local WIN_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
local LOSE_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"

function UIAllyDuelConditionTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIAllyDuelConditionTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelConditionTipView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBlack = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.btnBtnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBtnClose:SetOnClick(function()
    self:OnBtnBtnCloseClick()
  end)
  self.compRank1 = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textFirstNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textScoreTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 6)
  self.textDayLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compResult = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.imgResultL = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textResultScoreR = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgResultR = self.viewSkin:AddComponent(self, UIImage, 11)
  self.textResultTitleRName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textResultTitleLName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textResultScoreL = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 16)
  self.btnTip = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnTip:SetOnClick(function()
    self:OnBtnTipClick()
  end)
  self.btnFavor = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnFavor:SetOnClick(function()
    self:OnBtnFavorClick()
  end)
  self.textFavorTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compDianZanEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
end

function UIAllyDuelConditionTipView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBlack = nil
  self.btnBtnClose = nil
  self.compRank1 = nil
  self.textFirstNameTxt = nil
  self.textScoreTxt = nil
  self.compUIPlayerHead = nil
  self.textDayLabel = nil
  self.compResult = nil
  self.imgResultL = nil
  self.textResultScoreR = nil
  self.imgResultR = nil
  self.textResultTitleRName = nil
  self.textResultTitleLName = nil
  self.textResultScoreL = nil
  self.compContent = nil
  self.scrollView = nil
  self.btnTip = nil
  self.btnFavor = nil
  self.textFavorTxt = nil
  self.compDianZanEffect = nil
end

function UIAllyDuelConditionTipView:DataDefine()
  self.conditionList = {}
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.compDianZanEffect:SetActive(false)
end

function UIAllyDuelConditionTipView:DataDestroy()
  self.rankUid = nil
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self:ClearScroll()
end

function UIAllyDuelConditionTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshRank)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function UIAllyDuelConditionTipView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshRank)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnRemoveListener(self)
end

function UIAllyDuelConditionTipView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function UIAllyDuelConditionTipView:OnBtnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIAllyDuelConditionTipView:OnBtnTipClick()
  local effectInfos = self:RefreshEffectInfo()
  local datalist = {}
  local name = ""
  local value = ""
  for i = 1, #effectInfos do
    name = Localization:GetString(effectInfos[i].language)
    value = effectInfos[i].value
    datalist[i] = {}
    datalist[i].name = name
    datalist[i].value = value
  end
  local parameter = {
    titleAlignment = CS.UnityEngine.TextAnchor.UpperCenter,
    comtentWidthAdd = 120,
    layoutShow = true,
    datalist = datalist
  }
  UIUtil.ShowBubbleTips(nil, self.btnTip.transform.position, 0, 0, -120, nil, Localization:GetString(500035), parameter)
end

function UIAllyDuelConditionTipView:OnBtnFavorClick()
  if self.rankUid == nil then
    return
  end
  InteractiveUtil.TryThumbsUp(self.rankUid, InteractiveUtil.ThumbsUpType.AllyDuelRank, "UIAllyDuelConditionTipView", function()
    self:OnFavorClickSuccess()
  end)
end

function UIAllyDuelConditionTipView:OnFavorClickSuccess()
  if self.textFavorTxt == nil then
    return
  end
  local num = toInt(self.textFavorTxt:GetText()) + 1
  self.textFavorTxt:SetText(num)
  UIUtil.ShowTipsId("activity_sports_uitips_017")
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.compDianZanEffect:SetActive(false)
  self.compDianZanEffect:SetActive(true)
  self.diamondSeq = CS.DG.Tweening.DOTween.Sequence()
  self.diamondSeq:AppendInterval(0.8)
  self.diamondSeq:AppendCallback(function()
    if self.compDianZanEffect then
      self.compDianZanEffect:SetActive(false)
    end
  end)
end

function UIAllyDuelConditionTipView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIAllyDuelConditionTipItem)
  self.list = {}
end

function UIAllyDuelConditionTipView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  itemObj.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  local item = self.scrollView:AddComponent(UIAllyDuelConditionTipItem, itemObj)
  local data = self.list[index]
  item:RefreshData(data, index)
end

function UIAllyDuelConditionTipView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIAllyDuelConditionTipItem)
end

function UIAllyDuelConditionTipView:ReInit()
  local param = self:GetUserData()
  local day = param.day
  self.day = day
  self.textDayLabel:SetLocalText(372099, day)
  self:RefreshResult(param.info)
  local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
  local haveRank = day <= today
  self:SetRankShow(false)
  if haveRank then
    DataCenter.AllianceCompeteDataManager:FetchRankList(AllyDuelRankType.Day, day)
    local rankList = DataCenter.AllianceCompeteDataManager:GetRankListState(AllyDuelRankType.Day, day)
    local rankInfo = rankList ~= nil and rankList[1] or nil
    if rankInfo ~= nil then
      self:RefreshRank()
    end
  end
  self:RefreshList(param.content, day)
end

function UIAllyDuelConditionTipView:RefreshResult(info)
  if table.IsNullOrEmpty(info) then
    return
  end
  self.textResultScoreL:SetText(string.GetFormattedSeparatorNum(info.scoreL))
  self.textResultScoreR:SetText(string.GetFormattedSeparatorNum(info.scoreR))
  self.textResultTitleLName:SetText(info.abbrL)
  self.textResultTitleRName:SetText(info.abbrR)
  local isWin = info.isWin
  self.imgResultL:SetActive(isWin ~= nil)
  self.imgResultR:SetActive(isWin ~= nil)
  if isWin ~= nil then
    self.imgResultL:LoadSprite(isWin == 1 and WIN_IMG_PATH or LOSE_IMG_PATH)
    self.imgResultR:LoadSprite(isWin ~= 1 and WIN_IMG_PATH or LOSE_IMG_PATH)
  end
end

function UIAllyDuelConditionTipView:RefreshRank()
  if self.diamondSeq then
    self.diamondSeq:Kill()
    self.diamondSeq = nil
  end
  self.compDianZanEffect:SetActive(false)
  local rankList = DataCenter.AllianceCompeteDataManager:GetRankListState(AllyDuelRankType.Day, self.day)
  local rankInfo = rankList ~= nil and rankList[1] or nil
  if rankInfo == nil then
    self.rankUid = nil
    self:SetRankShow(false)
    return
  end
  self:SetRankShow(true)
  self.rankUid = rankInfo.uid
  local showName = UIUtil.FormatAllianceAndName(rankInfo.abbr, rankInfo.name, rankInfo.uid)
  self.textFirstNameTxt:SetText(showName)
  local score = rankInfo.score or 0
  self.textScoreTxt:SetText(string.GetFormattedSeparatorNum(score))
  self.compUIPlayerHead:SetHeadAndFrame(rankInfo.uid, rankInfo.pic, rankInfo.picVer, nil, rankInfo.headSkinId, rankInfo.headSkinET)
  local bSelf = rankInfo.uid == LuaEntry.Player:GetUid()
  self.btnFavor:SetActive(not bSelf)
  if not bSelf then
    self:OnGetNewUserInfoSucc(rankInfo.uid)
  end
end

function UIAllyDuelConditionTipView:OnGetNewUserInfoSucc(uid)
  if uid == self.rankUid then
    local info = UIUtil.GetPlayerInfoShowByUid(uid)
    self.textFavorTxt:SetText(info.thumbsUpCount or 0)
  end
end

function UIAllyDuelConditionTipView:SetRankShow(bShow)
  self.compRank1:SetActive(bShow)
  self.scrollView:SetOffsetMaxXY(0, bShow and -140 or -5)
end

function UIAllyDuelConditionTipView:RefreshList(content, day)
  self.list = DataCenter.AllyDuelConditionTipManager:GetTip(day + 1)
  local count = self.list ~= nil and #self.list or 0
  self.scrollView:SetTotalCount(count)
  if 0 < count then
    self.scrollView:RefillCells()
  end
end

function UIAllyDuelConditionTipView:RefreshEffectInfo()
  local effectShowList
  if self.day then
    effectShowList = DataCenter.AllyDuelConditionTipManager:GetEffectShow(self.day + 1)
  else
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    effectShowList = actInfo.eventInfo.effectShowList
  end
  local effectInfos = {}
  for i = 1, #effectShowList do
    local num = LuaEntry.Effect:GetGameEffect(tonumber(effectShowList[i].id)) or 0
    effectInfos[i] = {}
    effectInfos[i].value = "+" .. string.format("%.0f", num * 100) .. "%"
    effectInfos[i].language = effectShowList[i].languageId
  end
  return effectInfos
end

return UIAllyDuelConditionTipView
