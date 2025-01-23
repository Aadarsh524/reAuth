enum AuthCategory {
  financial,
  socialMedia,
  entertainment,
  network,
  others,
}

Map<AuthCategory, String> authCategoryStrings = {
  AuthCategory.financial: "Financial",
  AuthCategory.socialMedia: "Social Media",
  AuthCategory.entertainment: "Entertainment",
  AuthCategory.network: "Network",
  AuthCategory.others: "Others",
};

Map<AuthCategory, List<String>> authCategoryTags = {
  AuthCategory.financial: ["Mobile Banking", "Wallets", "Financial"],
  AuthCategory.socialMedia: [
    "Messaging",
    "Social Media",
  ],
  AuthCategory.entertainment: [
    "Entertainment",
    "Streaming",
    "Books",
    "Music",
    "Movies"
  ],
  AuthCategory.network: [
    "Network",
    "Wifi",
  ],
  AuthCategory.others: [
    "Others",
  ],
};
