local KillZombieAlChallengeRankView = BaseClass("KillZombieAlChallengeRankView", UIBaseView)
local base = UIBaseView
local KillZombieAlChallengeRankContentBase = require("UI.KillZombieAlChallengeRank.Component.KillZombieAlChallengeRankContentBase")
local KillZombieAlChallengeRankContent = require("UI.KillZombieAlChallengeRank.Component.KillZombieAlChallengeRankContent")
local title_text_path = "Root/UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "Root/UICommonPopUpTitle/CloseBtn"
local rank_content_path = "Root/MiddleContentContainer/RankContent"
local bg_btn_path = "ImgBg"
local new_rank_content_path = "Root/MiddleContentContainer/NewRankContent"

function KillZombieAlChallengeRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SendAlMemberDataMsg()
end

function KillZombieAlChallengeRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function KillZombieAlChallengeRankView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("challenge_zombie_rank_title")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bg_btn = self:AddComponent(UIButton, bg_btn_path)
  self.bg_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local switch = DataCenter.ActivityKillZombieManager:CheckAllChallengeDmgNewFunctionOn()
  if switch then
    local hideContent = self:AddComponent(KillZombieAlChallengeRankContentBase, rank_content_path)
    hideContent:SetActive(false)
    self.rank_content = self:AddComponent(KillZombieAlChallengeRankContent, new_rank_content_path)
  else
    local hideContent = self:AddComponent(KillZombieAlChallengeRankContent, new_rank_content_path)
    hideContent:SetActive(false)
    self.rank_content = self:AddComponent(KillZombieAlChallengeRankContentBase, rank_content_path)
  end
  self.rank_content:SetActive(true)
end

function KillZombieAlChallengeRankView:ComponentDestroy()
  self.title_text = nil
  self.close_btn = nil
  self.bg_btn = nil
  if self.rank_content then
    self.rank_content:SetActive(false)
  end
  self.rank_content = nil
  self.new_rank_content = nil
end

function KillZombieAlChallengeRankView:DataDefine()
  self.sendTime = nil
  self.rankList = nil
  self.selfInfo = nil
end

function KillZombieAlChallengeRankView:DataDestroy()
  self.sendTime = nil
  self.rankList = nil
  self.selfInfo = nil
end

function KillZombieAlChallengeRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChallengeZombieGetAlChallengeRank, self.GetMemberData)
end

function KillZombieAlChallengeRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChallengeZombieGetAlChallengeRank, self.GetMemberData)
  base.OnRemoveListener(self)
end

function KillZombieAlChallengeRankView:GetMemberData(message)
  self:ParseMessage(message)
  self.rank_content:SetData(self:GetRankData(), self.selfInfo)
end

function KillZombieAlChallengeRankView:SendAlMemberDataMsg()
  if self.sendTime == nil then
    self.sendTime = 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.sendTime + 2000 then
    self.sendTime = curTime
    SFSNetwork.SendMessage(MsgDefines.AllianceChallengeNewDamageRank)
  end
end

function KillZombieAlChallengeRankView:GetRankData()
  local rankData = {}
  local all = self.rankList
  if all ~= nil then
    local selfUid = LuaEntry.Player.uid
    for k, v in pairs(all) do
      if v then
        local memberData = v
        memberData.isSelf = false
        if v.roleInfo.uid == selfUid then
          memberData.isSelf = true
        end
        table.insert(rankData, memberData)
      end
    end
    table.sort(rankData, function(a, b)
      if a.score ~= b.score then
        return a.score > b.score
      end
    end)
  end
  return rankData
end

function KillZombieAlChallengeRankView:ParseMessage(message)
  if message then
    self.rankList = message.ranks
    self.selfInfo = message.self
    if self.selfInfo then
      self.selfInfo.isSelf = true
    end
  end
end

return KillZombieAlChallengeRankView
