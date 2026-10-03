ChatChannelShowMinLevel = 1
ChatCmd = {cmdSendMsg = false, cmdSendLan = false}
ChatShareChannel = {
  TO_COUNTRY = 0,
  TO_ALLIANCE = 1,
  TO_PERSON = 2,
  TO_LANGUAGE = 3
}
RedPackageType = {
  LevelUp = 1,
  Hero_Quality_4 = 2,
  Hero_Quality_7 = 3
}
BubbleType = {
  RedPackage = 1,
  Notice = 2,
  Private = 3,
  Treasure = 4,
  At = 5,
  ElectricianGather = 6,
  CustomerService = 7,
  NewThumpsUp = 8,
  NewsCenter = 9,
  FireworkGiftBox = 10,
  GroupChat = 11,
  LuckyBuffPacket = 12,
  S0AllianceBoss = 13,
  Gift = 14
}
RedPackageState = {
  AlreadyGet = 0,
  Valid = 1,
  Cost_All = 2,
  TimeOut = 3
}
ProxyType = {
  AWS = "aws",
  CF = "cf",
  GCP = "gcp"
}
ReportType = {
  player = 1,
  chat = 2,
  alliance = 3,
  championDuel = 4,
  chatPhoto = 5,
  actMigrate = 6,
  mailR4 = 7,
  mailPresident = 8,
  allianceNotice = 9,
  FriendCircle = 10,
  FriendCircleMoment = 11,
  SeasonAlliancePhotoMessage = 12,
  SeasonAlliancePhoto = 13,
  ActEasterEggOwner = 14,
  GroupChat = 15,
  actMigrateAlly = 16,
  actMigrateSNotice = 17,
  gift = 18,
  voiceRoom = 19
}
ReportExtraType = {
  championDuel = 2,
  actMigrate = 3,
  actMigrateAlly = 4,
  actMigrateSNotice = 5
}
VoteType = {radio = 0, More = 1}
SelectType = {Multiple = 0, Radio = 1}
ChatTranslateLanguage = {
  Language.English,
  Language.ChineseTraditional,
  Language.Spanish,
  Language.Japanese,
  Language.German,
  Language.French,
  Language.Arabic,
  Language.Italian,
  Language.PortuguesePortugal,
  Language.Korean,
  Language.Russian,
  Language.Turkish,
  Language.Thai,
  Language.Hindi,
  Language.Dutch,
  Language.Indonesian,
  Language.Polish,
  Language.Swedish,
  Language.Farsi,
  Language.Danish,
  Language.Norwegian,
  Language.Finnish,
  Language.Greek,
  Language.Czech,
  Language.Hungarian,
  Language.Lithuanian,
  Language.Romanian,
  Language.Ukrainian,
  Language.Vietnamese,
  Language.ChineseSimplified
}
LanageAbbr = {
  [Language.English] = "en",
  [Language.ChineseTraditional] = "zh-Hant",
  [Language.ChineseSimplified] = "zh-Hans",
  [Language.Spanish] = "es",
  [Language.Japanese] = "ja",
  [Language.German] = "de",
  [Language.French] = "fr",
  [Language.Arabic] = "ar",
  [Language.Italian] = "it",
  [Language.PortuguesePortugal] = "pt",
  [Language.Korean] = "ko",
  [Language.Russian] = "ru",
  [Language.Turkish] = "tr",
  [Language.Thai] = "th",
  [Language.Hindi] = "hi",
  [Language.Dutch] = "nl",
  [Language.Indonesian] = "id",
  [Language.Bengali] = "bn",
  [Language.Polish] = "pl",
  [Language.Swedish] = "sv",
  [Language.Farsi] = "fa",
  [Language.Danish] = "da",
  [Language.Norwegian] = "no",
  [Language.Finnish] = "fi",
  [Language.Greek] = "el",
  [Language.Czech] = "cs",
  [Language.Hungarian] = "hu",
  [Language.Lithuanian] = "lt",
  [Language.Norwegian] = "nb",
  [Language.Romanian] = "ro",
  [Language.Ukrainian] = "uk",
  [Language.Vietnamese] = "vi"
}
ChatEmojiLikePath = {
  "ChatWindow/icon_great_light.png",
  "ChatWindow/icon_grimace_light.png",
  "ChatWindow/mjc_liaotiangonggao_sahua.png"
}
ChatStickerCoverPath = "Assets/Main/Sprites/UI/LWChatEmoji/StickerCover/%s.png"
ChatStickerDynamicPath = "Assets/Main/TextureEx/UIStickerDynamic/%s.png"
ChatStickerDicePath = "Assets/Main/Sprites/UI/UIChatDice/%s.png"
ChatStickerDynamicName = "ChatDynamicSticker_"
ChatStickerDynamicMatName = "DynamicSticker_"
ChatStickerItemPath = "Assets/Main/Prefabs/UI/ChatNew/ChatSitcker/ChatDynamicSticker.prefab"
ChatstickerMaterialPath = "Assets/Main/Material/%s.mat"
ChatStickerPlaySpeed = 12
ChatStickerImagePatch = "Assets/Main/Sprites/MapSticker/"
ChatSendPhotoLoadingBgPath = "Assets/Main/TextureEx/ChatSendPhoto/defaultLoadingBg.png"
ChatSendPhotoReloadBgPath = "Assets/Main/TextureEx/ChatSendPhoto/defaultLoadingBg.png"
ChatSendPhotoShowMaxSize = 300
ChatFakePhotoMsg = "<FakeLWPhoto>"
ChatEmojiPath = "Assets/Main/Sprites/UI/LWChatEmoji/Default/%s.png"
ChatEmojiType = {
  Text = 1,
  Emoji = 2,
  Sticker = 3
}
ChatNoticeType = {
  NORMAL = 0,
  ALLIANCE_AHEAD_DECLARE = 1,
  ALLIANCE_DECLARE = 2,
  ALLIANCE_VOTE = 3
}
ChatEventEnum = EventId
ChatBottomFuncConfig = {
  RedPackage = {
    type = "RedPackage",
    getImageFunc = function(roomGroup)
      return ChatInterface.GetChatUIPath("ChatFuncsBottom/zyf_liaotian_egg2.png")
    end,
    getIsUnlock = function(roomGroup)
      return DataCenter.RedPacketManager:GetChatOpen()
    end,
    txtName = "red_pocket_desc1",
    redPointType = 2
  },
  PhotoAlbum = {
    type = "PhotoAlbum",
    getImageFunc = function(roomGroup)
      local isOpen = ChatManager2:GetInstance():IsActivePhotoAlbum(roomGroup)
      if isOpen then
        return ChatInterface.GetChatUIPath("ChatFuncsBottom/zyf_liaotian_album1.png")
      else
        return ChatInterface.GetChatUIPath("ChatFuncsBottom/zyf_liaotian_album2.png")
      end
    end,
    getIsUnlock = function(roomGroup)
      if roomGroup == ChatGroupType.GROUP_CUSTOM or roomGroup == ChatGroupType.GROUP_CUSTOM_GROUP then
        return LuaEntry.DataConfig:CheckSwitch("picture_send_private")
      else
        return true
      end
    end,
    txtName = "album",
    redPointType = 0
  },
  TranslateAll = {
    type = "TranslateAll",
    getImageFunc = function(roomGroup)
      local isOpen = ChatInterface.TranslateAllIsOpen()
      if isOpen then
        return ChatInterface.GetChatUIPath("ChatFuncsBottom/zyf_liaotian_fanyi1.png")
      else
        return ChatInterface.GetChatUIPath("ChatFuncsBottom/zyf_liaotian_fanyi2.png")
      end
    end,
    getIsUnlock = function(roomGroup)
      return ChatInterface.IsTranslateAllOpen()
    end,
    txtName = "full_page_translation",
    redPointType = 0
  },
  Gift = {
    type = "Gift",
    getImageFunc = function(roomGroup)
      return "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_tubiao_jiangli.png"
    end,
    getIsUnlock = function(roomGroup)
      return IsGiftSystemOpen
    end,
    txtName = "string_gifts",
    redPointType = 0
  },
  ShareMyPoint = {
    type = "ShareMyPoint",
    getImageFunc = function(roomGroup)
      return ChatInterface.GetChatUIPath("ChatFuncsBottom/zyf_liaotian_fasongzuobiao1.png")
    end,
    getIsUnlock = function(roomGroup)
      return true
    end,
    txtName = "base_location_share_btn",
    redPointType = 0
  }
}
EmojiCategory = {Default = 0, Goods = 3}
ChatLayoutEmojiSpace = 12
ChatLayoutEmojiLength = 90
EmojiCommentsType = {
  Up = 1,
  Down = 2,
  ScatterFlowers = 3,
  HighFive = 4
}
HideInChatItemFrame = {
  [EmojiCommentsType.HighFive] = true
}
PrivateListPage = 20
lwEmojiScope = {uncodeStart = 57344, uncodeEnd = 61439}
lwAtTranslateScope = {uncodeStart = 61440, uncodeEnd = 61459}
lwArabicCode = {uncodeStart = 57600, uncodeEnd = 57602}
ChatLoadingTipHeight = 40
TranslateAllMaxServerId = 200
ChatDefaultBubbleId = 50000
PanelTypeEnum = {
  EmojiPanel = "EmojiPanel",
  FuncsPanel = "FuncsPanel",
  Keyboard = "Keyboard",
  None = "None"
}
EmojiTabTypeConfig = {
  EmojiPanel = {
    type = "EmojiPanel",
    getImageFunc = function()
      return "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_liaotianfenye_icon1.png"
    end,
    getIsUnlock = function()
      return true
    end
  },
  StickerPanel = {
    type = "StickerPanel",
    getImageFunc = function()
      return "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_liaotianfenye_icon2.png"
    end,
    getIsUnlock = function()
      local strickerShowList = DataCenter.ChatEmojiTemplateManager:GetShowStickerList()
      return strickerShowList ~= nil and 0 < #strickerShowList
    end
  }
}
KeyboardView = {
  [UIWindowNames.UILWSingleMomentDetailView] = true,
  [UIWindowNames.UILWPostCircleFriend] = true,
  [UIWindowNames.UIChatNew_v2] = true,
  [UIWindowNames.LWUIAllianceNoticeDetail] = true
}
local ColorList = {
  e6e6e6 = Color.New(0.9, 0.9, 0.9, 1),
  ["8c8c8c"] = Color.New(0.55, 0.55, 0.55, 1),
  a5a5a5 = Color.New(0.65, 0.65, 0.65, 1),
  ["737d96"] = Color.New(0.45, 0.49, 0.59, 1),
  ["525252"] = Color.New(0.32, 0.32, 0.32, 1),
  ["818083"] = Color.New(0.5058823529411764, 0.5019607843137255, 0.5137254901960784, 1),
  ["000000"] = Color.New(0, 0, 0, 0.5),
  ["515151"] = Color.New(0.3176470588235294, 0.3176470588235294, 0.3176470588235294, 1),
  ["646464"] = Color.New(0.39215686274509803, 0.39215686274509803, 0.39215686274509803, 1),
  ["3F4142"] = Color.New(0.24705882352941178, 0.2549019607843137, 0.25882352941176473, 1),
  aaaaaa = Color.New(0.6666666666666666, 0.6666666666666666, 0.6666666666666666, 1),
  ["828282"] = Color.New(0.5098039215686274, 0.5098039215686274, 0.5098039215686274, 1),
  ["080808"] = Color.New(0.03137254901960784, 0.03137254901960784, 0.03137254901960784, 1)
}
UnreadNotificationType = {
  ShowUnreadCount = 1,
  ShowUnreadDot = 2,
  NoNotification = 3
}
UnreadNotificationText = {
  [UnreadNotificationType.ShowUnreadCount] = "setting_red_dots_counts",
  [UnreadNotificationType.ShowUnreadDot] = "setting_red_dots_dots",
  [UnreadNotificationType.NoNotification] = "setting_red_dots_not"
}
MomentPushType = {
  NoticeLike = 0,
  NoticeComment = 1,
  Alliance = 2,
  Follow = 3
}
ChatUIThemeConfig = {
  ChatMode = {Normal = 1, Night = 2},
  UIPrefix = {
    "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/",
    "Assets/Main/Sprites/UI/LWChat_v2/NightSkin/"
  },
  UIRawPrefix = {
    "Assets/Main/TextureEx/LWChat_v2/DefaultSkin/",
    "Assets/Main/TextureEx/LWChat_v2/NightSkin/"
  },
  UIBigPrefix = {
    "Assets/Main/Sprites/UI/LWChat_v2/BigSprite/Default/",
    "Assets/Main/Sprites/UI/LWChat_v2/BigSprite/Night/"
  },
  HeadAlpha = {1, 0.3},
  StickerAlpha = {1, 0.6},
  ChatAlpha = {1, 0.6},
  LevelColor = {
    Color.black,
    ColorList.a5a5a5
  },
  ChatNameColor = {
    ColorList["515151"],
    ColorList.a5a5a5
  },
  TextColor = {
    ColorList["525252"],
    ColorList.e6e6e6
  },
  TextReplyColor = {
    ColorList["818083"],
    ColorList["737d96"]
  },
  TextReplyColor2 = {
    ColorList["818083"],
    ColorList["646464"]
  },
  InputHolderColor = {
    ColorList["000000"],
    ColorList["8c8c8c"]
  },
  InputTextColor = {
    Color.black,
    ColorList.e6e6e6
  },
  MobilBackGroundColor = {
    Color.white,
    ColorList["3F4142"]
  },
  MoreBtnColor = {
    Color.New(0.141, 0.607, 0.772, 1),
    Color.New(0.176, 0.725, 0.921, 1)
  },
  NameColor = {
    Color.red,
    Color.New(0.7, 0.23, 0.23, 1)
  },
  ChatAIBodyColor = {
    Color.white,
    Color.New(0.9, 0.9, 0.9, 1)
  },
  TrainRobRewardColor = {
    Color.white,
    Color.New(0.125, 0.11, 0.105, 1)
  },
  ZREliteBossAtkMsgThemeColor = {
    Color.white,
    ColorList.e6e6e6
  },
  MomentOrdinaryColor = {
    Color.black,
    ColorList["8c8c8c"]
  },
  MomentClickColor = {
    Color.black,
    ColorList.e6e6e6
  },
  GroupChatExitImgColor = {
    Color.New(0.941, 0.917, 0.906, 1),
    Color.New(0.24, 0.24, 0.24, 1)
  },
  GroupChatExitNameColor = {
    Color.red,
    Color.New(0.647, 0.254, 0.317, 1)
  },
  AllianceInvite_TitleColor = {
    [1] = {
      Color.New(0.636, 0.592, 0.569, 1),
      Color.New(0.51, 0.51, 0.51, 1)
    },
    [2] = {
      Color.New(0.384, 0.431, 0.541, 1),
      Color.New(0.51, 0.51, 0.51, 1)
    }
  },
  AllianceInvite_NameColor = {
    Color.New(0.165, 0.157, 0.189, 1),
    Color.New(0.667, 0.667, 0.667, 1)
  },
  AllianceInvite_MemberColor = {
    Color.New(1, 1, 1, 1),
    Color.New(0.667, 0.667, 0.667, 1)
  },
  AllianceInvite_CellTextColor = {
    Color.New(0.165, 0.157, 0.189, 1),
    Color.New(0.631, 0.631, 0.631, 1)
  },
  AllianceInvite_RecordColor = {
    [1] = {
      Color.New(0.298, 0.29, 0.31, 1),
      Color.New(0.631, 0.631, 0.631, 1)
    },
    [2] = {
      Color.New(0.384, 0.431, 0.541, 1),
      Color.New(0.631, 0.631, 0.631, 1)
    }
  },
  AllianceInvite_MemberIconAlpha = {1, 0.5},
  AllianceInvite_LineAlpha = {1, 0.05},
  AllianceInvite_IconAlpha = {1, 0.9},
  AllianceInvite_GridBgColor = {
    [1] = {
      Color.New(0.984, 0.952, 0.941, 1),
      Color.New(0.227, 0.211, 0.207, 1)
    },
    [2] = {
      Color.New(0.752, 0.796, 0.89, 1),
      Color.New(0.329, 0.384, 0.545, 1)
    }
  },
  AllianceInvite_TipTextColor = {
    Color.New(0.165, 0.157, 0.189, 1),
    Color.New(0.863, 0.863, 0.863, 1)
  },
  AllianceInvite_TipBgColor = {
    Color.New(0.941, 0.91, 0.898, 1),
    Color.New(0.329, 0.384, 0.545, 1)
  },
  AllianceInvite_WarnTextColor = {
    Color.New(0.961, 0.235, 0.235, 1),
    Color.New(0.961, 0.235, 0.235, 1)
  },
  AllianceInvite_WarnBgColor = {
    Color.New(0.996, 0.886, 0.894, 1),
    Color.New(0.996, 0.886, 0.894, 1)
  },
  BF_Winter_Achievement_TextColor = {
    [1] = {
      ColorList["080808"],
      ColorList["080808"]
    },
    [2] = {
      ColorList.aaaaaa,
      ColorList["828282"]
    }
  },
  MomentColor = {
    {
      momentImgBg = "#E9EDEF",
      bodyText = "#525252",
      countText = "#2A2830",
      titleText = "#FFFFFF",
      replyColor = "#818083",
      morePlayerBg = "#D3D7D9"
    },
    {
      momentImgBg = "#272727",
      bodyText = "#AAAAAA",
      countText = "#828282",
      titleText = "#828282",
      replyColor = "#686868",
      morePlayerBg = "#939697"
    }
  },
  MomentImage = {
    {
      transPath = "Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/lyp_liaotian_fanyi.png"
    },
    {
      transPath = "Assets/Main/Sprites/UI/LWChat_v2/NightSkin/ChatItems/lyp_liaotian_fanyi.png"
    }
  }
}
RequestType = {
  InitFetch = 1,
  JumpTo = 2,
  PullPrev = 3,
  PullLast = 4,
  ReceivePush = 5,
  LoadRecentMessages = 6
}
ChatOnePageItemCount = 100
ChatItemAutoLoadCount = 10
MomentMsgCount = 10
ChatTipType = {Unread = 1, At = 2}
GroupChatSettingType = {
  MakeOver = 1,
  GroupMembers = 2,
  push = 3,
  ReName = 4,
  Exit = 5,
  Report = 6,
  RoomTop = 7,
  IsMuted = 8
}
AtMaxTimes = 5
MAX_AT_PLAYERS = 20
STICKY_MAX_COUNT = 10
AtColors = {
  [50000] = Color.FromHex("249bc5"),
  [50001] = Color.FromHex("0073ae"),
  [50002] = Color.FromHex("12b3ef"),
  [50003] = Color.FromHex("6bc7f4"),
  [50004] = Color.FromHex("249bc5"),
  [50005] = Color.FromHex("0073ae"),
  [50006] = Color.FromHex("0073ae"),
  [50007] = Color.FromHex("197798"),
  [50008] = Color.FromHex("197798"),
  [50009] = Color.FromHex("197798"),
  [55000] = Color.FromHex("0073ae"),
  [55001] = Color.FromHex("0073ae"),
  [55002] = Color.FromHex("197798"),
  [55003] = Color.FromHex("12b3ef"),
  [55004] = Color.FromHex("0073ae")
}
GroupMemberOpenType = {
  CreateRooom = 1,
  GroupMembersOut = 2,
  GroupMembersMakeOver = 3,
  InviteNewMember = 4
}
PrivateSlidingType = {
  Delete = 1,
  Block = 2,
  Pinned = 3
}
ChatSystemMessageType = {
  ROOM_OP_CREATE = 1,
  ROOM_OP_MEMBER_QUIT = 3,
  ROOM_OP_KICK_MEMBER = 4,
  ROOM_OP_MODIFY_NAME = 5,
  ROOM_OP_ACCEPT_INVITE = 6,
  ROOM_OP_CHANGE_LEADER = 7
}
InviteState = {
  InviteCanOp = 1,
  InviteAgree = 2,
  InviteReject = 3
}
MaxChatHistoryLoops = 5
ChatHistoryFetchSize = 20
ChatNewsCenterTabType = {
  World = 1,
  Alliance = 2,
  News = 3,
  StrategyGuide = 4,
  Announcement = 5
}
LoadingTipStatus = {
  None = 1,
  WaitRelease = 2,
  WaitLoad = 3,
  Loaded = 4
}
AllianceInvite_CellType = {
  Member = 1,
  Power = 2,
  Gift = 3,
  Engagement = 4,
  GiftNum = 5,
  R4Limit = 6,
  BlackIndustry = 7
}
NewsCenterOpenType = {
  Chat = 1,
  News = 2,
  NoticeDetail = 3,
  NoticeRecord = 4
}
ATTag = {atAllTag = "<LW:atAll>"}
AllianceInvite_CellSetting = {
  [AllianceInvite_CellType.Member] = {
    IconPath = "Assets/Main/Sprites/UI/UIAllianceInvite/lrb_lianmeng_icon01.png",
    tipTextId = "alliance_invite_point_member",
    dialogTextId = "390199",
    nameTextId = "390199"
  },
  [AllianceInvite_CellType.Power] = {
    IconPath = "Assets/Main/Sprites/UI/UIAllianceInvite/lrb_lianmeng_icon02.png",
    tipTextId = "alliance_invite_point_power",
    dialogTextId = "100644",
    nameTextId = "100644"
  },
  [AllianceInvite_CellType.Gift] = {
    IconPath = "Assets/Main/Sprites/UI/UIAllianceInvite/lrb_lianmeng_icon03.png",
    tipTextId = "alliance_invite_point_gift",
    dialogTextId = "alliance_invite_desc_alGiftLv",
    nameTextId = "alliance_invite_name_alGiftLv"
  },
  [AllianceInvite_CellType.Engagement] = {
    IconPath = "Assets/Main/Sprites/UI/UIAllianceInvite/lrb_lianmeng_icon04.png",
    tipTextId = "alliance_invite_point_activity",
    dialogTextId = "alliance_invite_desc_alActivityPoint",
    nameTextId = "alliance_attr_name_alActivityPoint"
  },
  [AllianceInvite_CellType.GiftNum] = {
    IconPath = "Assets/Main/Sprites/UI/UIAllianceInvite/zyf_tongmengguanli_tiaocao_liwu_icon.png",
    tipTextId = "alliance_attr_name_giftCount",
    dialogTextId = "alliance_attr_desc_giftCount",
    nameTextId = "alliance_attr_name_giftCount"
  },
  [AllianceInvite_CellType.R4Limit] = {
    IconPath = "Assets/Main/Sprites/UI/UIAllianceInvite/lrb_lianmeng_tanhao.png",
    tipTextId = "alliance_invite_title_noR4"
  },
  [AllianceInvite_CellType.BlackIndustry] = {
    IconPath = "Assets/Main/Sprites/UI/UIAllianceInvite/lrb_lianmeng_tanhao.png",
    tipTextId = "alliance_invite_title_spy"
  }
}
ChatItemUIType = {
  Normal = 1,
  Time = 2,
  Tip = 3
}
MomentVisibilityRange = {
  All = "all",
  SameServer = "country",
  Alliance = "alliance",
  MyFollowers = "follow",
  Only = "self"
}
MomentOperationBtnType = {
  RangeSet = 1,
  Delete = 2,
  Close = 3
}
GroupChatItemType = {
  SelectMember = 1,
  Search = 2,
  MemberList = 3,
  GroupSettingItem = 4
}
NewsCenterShareFrom = {
  NewsCenter = "news_center",
  CopyLink = "copy_link"
}
