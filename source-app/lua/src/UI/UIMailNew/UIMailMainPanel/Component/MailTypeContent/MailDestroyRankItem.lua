local MailDestroyRankItem = BaseClass("MailDestroyRankItem", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local name_txt_path = "name_txt"
local num_txt_path = "num_txt"
local reward_txt_path = "reward_txt"
local reward_icon_path = "reward_txt/reward_icon"
local head_obj_path = "UIPlayerHead"
local player_head_path = "UIPlayerHead/HeadIcon"
local headFg_path = "UIPlayerHead/Foreground"
local A_Color = Color.New(0.9607843, 0.8941177, 0.8, 1)
local Self_Color = Color.New(0.9921569, 0.8627451, 0.5607843, 1)
local B_Color = Color.New(0.9607843, 0.8666667, 0.7411765, 1)

function MailDestroyRankItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.head_obj = self:AddComponent(UIBaseContainer, head_obj_path)
  self.player_head = self:AddComponent(UIPlayerHead, player_head_path)
  self.playerHeadFg = self:AddComponent(UIImage, headFg_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.reward_txt = self:AddComponent(UIText, reward_txt_path)
  self.reward_icon = self:AddComponent(UIImage, reward_icon_path)
end

function MailDestroyRankItem:SetData(isTitle, rankType, rankData)
  if isTitle then
    self.bg:SetColor(A_Color)
    self.head_obj:SetActive(false)
    self.name_txt:SetText(Localization:GetString("110188"))
    if rankType == DestroyRankType.Blood then
      self.num_txt:SetText(Localization:GetString("110186"))
    else
      self.num_txt:SetText(Localization:GetString("110187"))
    end
    self.reward_txt:SetText(Localization:GetString("130065"))
    self.reward_icon:SetActive(false)
  else
    local rank = rankData.rank
    local num = rank % 2
    if 0 < num then
      self.bg:SetColor(B_Color)
    else
      self.bg:SetColor(A_Color)
    end
    self.head_obj:SetActive(true)
    local playerInfo = rankData.playerInfo
    local uid = playerInfo.uid
    if uid == LuaEntry.Player.uid then
      self.bg:SetColor(Self_Color)
    end
    local userPic = playerInfo.pic or ""
    local userPicVer = playerInfo.picVer or 0
    local name = playerInfo.name
    local userinfo = ChatInterface.getUserData(uid)
    if userinfo ~= nil then
      userPic = userinfo.headPic or ""
      userPicVer = userinfo.headPicVer or 0
      local tempFg = userinfo:GetHeadBgImg()
      if tempFg then
        self.playerHeadFg:SetActive(true)
        self.playerHeadFg:LoadSprite(tempFg)
      else
        self.playerHeadFg:SetActive(false)
      end
    end
    self.player_head:SetData(uid, userPic, userPicVer)
    self.name_txt:SetText(name)
    self.num_txt:SetText(string.GetFormattedSeperatorNum(rankData.scord))
    local rewardList = rankData.rewardInfo
    if rewardList ~= nil and 0 < table.count(rewardList) then
      local hasGet = false
      for k, v in pairs(rewardList) do
        if hasGet == false then
          local rewardItem = v
          local tempType = RewardType.FOOD
          local tempId = 0
          local count = 0
          if rewardItem.type ~= nil then
            tempType = rewardItem.type.value
          end
          if rewardItem.id ~= nil then
            tempId = rewardItem.id.value
          end
          if rewardItem.num ~= nil then
            count = rewardItem.num.value
          end
          local pic = RewardUtil.GetPic(tempType, tempId)
          self.reward_icon:SetActive(true)
          self.reward_icon:LoadSprite(pic)
          self.reward_txt:SetText(string.GetFormattedSeperatorNum(count))
          hasGet = true
        end
      end
    else
      self.reward_txt:SetText("-")
      self.reward_icon:SetActive(false)
    end
  end
end

return MailDestroyRankItem
